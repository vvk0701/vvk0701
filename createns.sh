vc_sso_username=cloudadmin@vmc.local
namespace_prefix='wcpns'
cluster_name='Cluster-1'
password=$1

sp=`dcli +show-unreleased +username $vc_sso_username  +password $password com vmware vcenter storage policies list | grep "VMC Workload Storage Policy - Cluster-1" | cut -d'|' -f4`
echo "Storage policy ID = $sp"

cluster_id=`dcli  +show-unreleased +username $vc_sso_username +password $password com vmware vcenter cluster list | grep ${cluster_name} | grep True | cut -d'|' -f3`
echo "Cluster ID = $cluster_id"


for (( i=1; i <= 10; i++ ))
do
output=`dcli +show-unreleased +username $vc_sso_username +password $password com vmware vcenter namespaces instances create --cluster $cluster_id --namespace ${namespace_prefix}${i} --storage-specs "[{\"policy\": \"$sp\"}]" || echo "WCP Namespace already exists"`
    
echo $output

output=`dcli +show-unreleased +username $vc_sso_username +password $password com vmware vcenter namespaces access create  --namespace ${namespace_prefix}${i}  --type USER --role EDIT --domain vmc.local --subject cloudadmin || echo "WCP Namespace already exists"`
done
