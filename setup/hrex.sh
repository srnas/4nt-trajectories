# five replicas
nrep=24
# "effective" temperature range
tmin=300
tmax=400
# build geometric progression
list=$(
awk -v n=$nrep \
-v tmin=$tmin \
-v tmax=$tmax \
'BEGIN{for(i=0;i<n;i++){
t=tmin*exp(i*log(tmax/tmin)/(n-1));
printf(t); if(i<n-1)printf(",");
}
}'
)
# clean directory
#rm -fr \#*
#rm -fr topol*
for((i=0;i<nrep;i++))
do
lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $'$((i+1))';}')
echo  $i  $lambda
#sed -e 's/$num/'$i'/'  -e 's/$temp/'$lambda'/g' nvt.mdp > grompp$i.mdp
# choose lambda as T[0]/T[i]
# remember that high temperature is equivalent to low lambda
#lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')
# process topology
# (if you are curious, try "diff topol0.top topol1.top" to see the changes)
#plumed --no-mpi partial_tempering $lambda < processed.top > topol$i.top
# prepare tpr file
# -maxwarn is often needed because box could be charged
#grompp_mpi -maxwarn 1 -o topol$i.tpr -f grompp$i.mdp -p set/topol_01.top -c set/tpr_08.tpr
done
#mpirun -np $nrep mdrun_mpi_d -v -plumed plumed.dat -multi $nrep -replex 100 -nsteps 15000000 -hrex
