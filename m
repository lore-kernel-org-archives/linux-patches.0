Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502B330C35E;
	Mon, 13 Oct 2025 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368838; cv=none; b=QBqI2+oAIq4r44r408Z69GRtbIMTA0aDmxwR77EysMW+Ci6s39/fzYy56Xz8WR06D40g/4U8NkToC/BKecXU3llDSYjb3mRP7jNSmzdB8zmZszH/4R2G1Dkz+phKVuinDwanbGtlOF6Bs3sJnE3VYbaM3H9Cugj8qrOGq0Xq6Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368838; c=relaxed/simple;
	bh=+H6cHARicJvXyndzq5LyIx+fbQ/WhCuX1XZZqzCTIHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpCXu1GwBQX3CaCJ+xhAzcV8Esr9kCrAQi9xSuLJbeWEWcAwp8ZUoJNVGMFfC/0jv6qzfY+3R1Eom/ZoMbLb3N1GmKufJiCI0IfZrAbTFjiEbH1s/yKc2x9dJKAbugZantA5ttsTz2RoTGjIyZuYzj6Eqe0NE/NQHjmvKFe8D1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCzK8Mqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCzK8Mqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74726C4CEFE;
	Mon, 13 Oct 2025 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368837;
	bh=+H6cHARicJvXyndzq5LyIx+fbQ/WhCuX1XZZqzCTIHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCzK8Mqq/UbhkeTjVJF7X/Zqx/pJoqmWGBdktRzvlbug8yQwpahStotQGOOZRHh0c
	 o4bi4Mr2zHLTucP1n3Ii+2Z/1zaW7ImHDBQbsEyush43hCG2md4YvcqsQlGnFSq2Bv
	 9QcF4/HcKZ8qYheNBYpU6B6VrFmLDPKn1C4wSEKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/563] sched/fair: Get rid of sched_domains_curr_level hack for tl->cpumask()
Date: Mon, 13 Oct 2025 16:38:17 +0200
Message-ID: <20251013144412.597554042@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 661f951e371cc134ea31c84238dbdc9a898b8403 ]

Leon [1] and Vinicius [2] noted a topology_span_sane() warning during
their testing starting from v6.16-rc1. Debug that followed pointed to
the tl->mask() for the NODE domain being incorrectly resolved to that of
the highest NUMA domain.

tl->mask() for NODE is set to the sd_numa_mask() which depends on the
global "sched_domains_curr_level" hack. "sched_domains_curr_level" is
set to the "tl->numa_level" during tl traversal in build_sched_domains()
calling sd_init() but was not reset before topology_span_sane().

Since "tl->numa_level" still reflected the old value from
build_sched_domains(), topology_span_sane() for the NODE domain trips
when the span of the last NUMA domain overlaps.

Instead of replicating the "sched_domains_curr_level" hack, get rid of
it entirely and instead, pass the entire "sched_domain_topology_level"
object to tl->cpumask() function to prevent such mishap in the future.

sd_numa_mask() now directly references "tl->numa_level" instead of
relying on the global "sched_domains_curr_level" hack to index into
sched_domains_numa_masks[].

The original warning was reproducible on the following NUMA topology
reported by Leon:

    $ sudo numactl -H
    available: 5 nodes (0-4)
    node 0 cpus: 0 1
    node 0 size: 2927 MB
    node 0 free: 1603 MB
    node 1 cpus: 2 3
    node 1 size: 3023 MB
    node 1 free: 3008 MB
    node 2 cpus: 4 5
    node 2 size: 3023 MB
    node 2 free: 3007 MB
    node 3 cpus: 6 7
    node 3 size: 3023 MB
    node 3 free: 3002 MB
    node 4 cpus: 8 9
    node 4 size: 3022 MB
    node 4 free: 2718 MB
    node distances:
    node   0   1   2   3   4
      0:  10  39  38  37  36
      1:  39  10  38  37  36
      2:  38  38  10  37  36
      3:  37  37  37  10  36
      4:  36  36  36  36  10

The above topology can be mimicked using the following QEMU cmd that was
used to reproduce the warning and test the fix:

     sudo qemu-system-x86_64 -enable-kvm -cpu host \
     -m 20G -smp cpus=10,sockets=10 -machine q35 \
     -object memory-backend-ram,size=4G,id=m0 \
     -object memory-backend-ram,size=4G,id=m1 \
     -object memory-backend-ram,size=4G,id=m2 \
     -object memory-backend-ram,size=4G,id=m3 \
     -object memory-backend-ram,size=4G,id=m4 \
     -numa node,cpus=0-1,memdev=m0,nodeid=0 \
     -numa node,cpus=2-3,memdev=m1,nodeid=1 \
     -numa node,cpus=4-5,memdev=m2,nodeid=2 \
     -numa node,cpus=6-7,memdev=m3,nodeid=3 \
     -numa node,cpus=8-9,memdev=m4,nodeid=4 \
     -numa dist,src=0,dst=1,val=39 \
     -numa dist,src=0,dst=2,val=38 \
     -numa dist,src=0,dst=3,val=37 \
     -numa dist,src=0,dst=4,val=36 \
     -numa dist,src=1,dst=0,val=39 \
     -numa dist,src=1,dst=2,val=38 \
     -numa dist,src=1,dst=3,val=37 \
     -numa dist,src=1,dst=4,val=36 \
     -numa dist,src=2,dst=0,val=38 \
     -numa dist,src=2,dst=1,val=38 \
     -numa dist,src=2,dst=3,val=37 \
     -numa dist,src=2,dst=4,val=36 \
     -numa dist,src=3,dst=0,val=37 \
     -numa dist,src=3,dst=1,val=37 \
     -numa dist,src=3,dst=2,val=37 \
     -numa dist,src=3,dst=4,val=36 \
     -numa dist,src=4,dst=0,val=36 \
     -numa dist,src=4,dst=1,val=36 \
     -numa dist,src=4,dst=2,val=36 \
     -numa dist,src=4,dst=3,val=36 \
     ...

  [ prateek: Moved common functions to include/linux/sched/topology.h,
    reuse the common bits for s390 and ppc, commit message ]

Closes: https://lore.kernel.org/lkml/20250610110701.GA256154@unreal/ [1]
Fixes: ccf74128d66c ("sched/topology: Assert non-NUMA topology masks don't (partially) overlap") # ce29a7da84cd, f55dac1dafb3
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Tested-by: Valentin Schneider <vschneid@redhat.com> # x86
Tested-by: Shrikanth Hegde <sshegde@linux.ibm.com> # powerpc
Link: https://lore.kernel.org/lkml/a3de98387abad28592e6ab591f3ff6107fe01dc1.1755893468.git.tim.c.chen@linux.intel.com/ [2]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig                |  4 ++++
 arch/powerpc/include/asm/topology.h |  2 ++
 arch/powerpc/kernel/smp.c           | 27 +++++++++++----------------
 arch/s390/kernel/topology.c         | 20 +++++++-------------
 arch/x86/kernel/smpboot.c           |  8 ++++----
 include/linux/sched/topology.h      | 28 +++++++++++++++++++++++++++-
 include/linux/topology.h            |  2 +-
 kernel/sched/topology.c             | 28 ++++++++++------------------
 8 files changed, 66 insertions(+), 53 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 93402a1d9c9fc..e51a595a06228 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -971,6 +971,10 @@ config SCHED_SMT
 	  when dealing with POWER5 cpus at a cost of slightly increased
 	  overhead in some places. If unsure say N here.
 
+config SCHED_MC
+	def_bool y
+	depends on SMP
+
 config PPC_DENORMALISATION
 	bool "PowerPC denormalisation exception handling"
 	depends on PPC_BOOK3S_64
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index da15b5efe8071..f19ca44512d1e 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -131,6 +131,8 @@ static inline int cpu_to_coregroup_id(int cpu)
 #ifdef CONFIG_SMP
 #include <asm/cputable.h>
 
+struct cpumask *cpu_coregroup_mask(int cpu);
+
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index f59e4b9cc2074..68edb66c2964b 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1028,19 +1028,19 @@ static int powerpc_shared_proc_flags(void)
  * We can't just pass cpu_l2_cache_mask() directly because
  * returns a non-const pointer and the compiler barfs on that.
  */
-static const struct cpumask *shared_cache_mask(int cpu)
+static const struct cpumask *tl_cache_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return per_cpu(cpu_l2_cache_map, cpu);
 }
 
 #ifdef CONFIG_SCHED_SMT
-static const struct cpumask *smallcore_smt_mask(int cpu)
+static const struct cpumask *tl_smallcore_smt_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return cpu_smallcore_mask(cpu);
 }
 #endif
 
-static struct cpumask *cpu_coregroup_mask(int cpu)
+struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return per_cpu(cpu_coregroup_map, cpu);
 }
@@ -1054,11 +1054,6 @@ static bool has_coregroup_support(void)
 	return coregroup_enabled;
 }
 
-static const struct cpumask *cpu_mc_mask(int cpu)
-{
-	return cpu_coregroup_mask(cpu);
-}
-
 static int __init init_big_cores(void)
 {
 	int cpu;
@@ -1448,7 +1443,7 @@ static bool update_mask_by_l2(int cpu, cpumask_var_t *mask)
 		return false;
 	}
 
-	cpumask_and(*mask, cpu_online_mask, cpu_cpu_mask(cpu));
+	cpumask_and(*mask, cpu_online_mask, cpu_node_mask(cpu));
 
 	/* Update l2-cache mask with all the CPUs that are part of submask */
 	or_cpumasks_related(cpu, cpu, submask_fn, cpu_l2_cache_mask);
@@ -1538,7 +1533,7 @@ static void update_coregroup_mask(int cpu, cpumask_var_t *mask)
 		return;
 	}
 
-	cpumask_and(*mask, cpu_online_mask, cpu_cpu_mask(cpu));
+	cpumask_and(*mask, cpu_online_mask, cpu_node_mask(cpu));
 
 	/* Update coregroup mask with all the CPUs that are part of submask */
 	or_cpumasks_related(cpu, cpu, submask_fn, cpu_coregroup_mask);
@@ -1601,7 +1596,7 @@ static void add_cpu_to_masks(int cpu)
 
 	/* If chip_id is -1; limit the cpu_core_mask to within PKG */
 	if (chip_id == -1)
-		cpumask_and(mask, mask, cpu_cpu_mask(cpu));
+		cpumask_and(mask, mask, cpu_node_mask(cpu));
 
 	for_each_cpu(i, mask) {
 		if (chip_id == cpu_to_chip_id(i)) {
@@ -1701,22 +1696,22 @@ static void __init build_sched_topology(void)
 	if (has_big_cores) {
 		pr_info("Big cores detected but using small core scheduling\n");
 		powerpc_topology[i++] =
-			SDTL_INIT(smallcore_smt_mask, powerpc_smt_flags, SMT);
+			SDTL_INIT(tl_smallcore_smt_mask, powerpc_smt_flags, SMT);
 	} else {
-		powerpc_topology[i++] = SDTL_INIT(cpu_smt_mask, powerpc_smt_flags, SMT);
+		powerpc_topology[i++] = SDTL_INIT(tl_smt_mask, powerpc_smt_flags, SMT);
 	}
 #endif
 	if (shared_caches) {
 		powerpc_topology[i++] =
-			SDTL_INIT(shared_cache_mask, powerpc_shared_cache_flags, CACHE);
+			SDTL_INIT(tl_cache_mask, powerpc_shared_cache_flags, CACHE);
 	}
 
 	if (has_coregroup_support()) {
 		powerpc_topology[i++] =
-			SDTL_INIT(cpu_mc_mask, powerpc_shared_proc_flags, MC);
+			SDTL_INIT(tl_mc_mask, powerpc_shared_proc_flags, MC);
 	}
 
-	powerpc_topology[i++] = SDTL_INIT(cpu_cpu_mask, powerpc_shared_proc_flags, PKG);
+	powerpc_topology[i++] = SDTL_INIT(tl_pkg_mask, powerpc_shared_proc_flags, PKG);
 
 	/* There must be one trailing NULL entry left.  */
 	BUG_ON(i >= ARRAY_SIZE(powerpc_topology) - 1);
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 46569b8e47dde..1594c80e9bc4d 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -509,33 +509,27 @@ int topology_cpu_init(struct cpu *cpu)
 	return rc;
 }
 
-static const struct cpumask *cpu_thread_mask(int cpu)
-{
-	return &cpu_topology[cpu].thread_mask;
-}
-
-
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return &cpu_topology[cpu].core_mask;
 }
 
-static const struct cpumask *cpu_book_mask(int cpu)
+static const struct cpumask *tl_book_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return &cpu_topology[cpu].book_mask;
 }
 
-static const struct cpumask *cpu_drawer_mask(int cpu)
+static const struct cpumask *tl_drawer_mask(struct sched_domain_topology_level *tl, int cpu)
 {
 	return &cpu_topology[cpu].drawer_mask;
 }
 
 static struct sched_domain_topology_level s390_topology[] = {
-	SDTL_INIT(cpu_thread_mask, cpu_smt_flags, SMT),
-	SDTL_INIT(cpu_coregroup_mask, cpu_core_flags, MC),
-	SDTL_INIT(cpu_book_mask, NULL, BOOK),
-	SDTL_INIT(cpu_drawer_mask, NULL, DRAWER),
-	SDTL_INIT(cpu_cpu_mask, NULL, PKG),
+	SDTL_INIT(tl_smt_mask, cpu_smt_flags, SMT),
+	SDTL_INIT(tl_mc_mask, cpu_core_flags, MC),
+	SDTL_INIT(tl_book_mask, NULL, BOOK),
+	SDTL_INIT(tl_drawer_mask, NULL, DRAWER),
+	SDTL_INIT(tl_pkg_mask, NULL, PKG),
 	{ NULL, },
 };
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 33e166f6ab122..eb289abece237 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -479,14 +479,14 @@ static int x86_cluster_flags(void)
 static bool x86_has_numa_in_package;
 
 static struct sched_domain_topology_level x86_topology[] = {
-	SDTL_INIT(cpu_smt_mask, cpu_smt_flags, SMT),
+	SDTL_INIT(tl_smt_mask, cpu_smt_flags, SMT),
 #ifdef CONFIG_SCHED_CLUSTER
-	SDTL_INIT(cpu_clustergroup_mask, x86_cluster_flags, CLS),
+	SDTL_INIT(tl_cls_mask, x86_cluster_flags, CLS),
 #endif
 #ifdef CONFIG_SCHED_MC
-	SDTL_INIT(cpu_coregroup_mask, x86_core_flags, MC),
+	SDTL_INIT(tl_mc_mask, x86_core_flags, MC),
 #endif
-	SDTL_INIT(cpu_cpu_mask, x86_sched_itmt_flags, PKG),
+	SDTL_INIT(tl_pkg_mask, x86_sched_itmt_flags, PKG),
 	{ NULL },
 };
 
diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 5263746b63e8c..a3a24e115d446 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -30,11 +30,19 @@ struct sd_flag_debug {
 };
 extern const struct sd_flag_debug sd_flag_debug[];
 
+struct sched_domain_topology_level;
+
 #ifdef CONFIG_SCHED_SMT
 static inline int cpu_smt_flags(void)
 {
 	return SD_SHARE_CPUCAPACITY | SD_SHARE_LLC;
 }
+
+static inline const
+struct cpumask *tl_smt_mask(struct sched_domain_topology_level *tl, int cpu)
+{
+	return cpu_smt_mask(cpu);
+}
 #endif
 
 #ifdef CONFIG_SCHED_CLUSTER
@@ -42,6 +50,12 @@ static inline int cpu_cluster_flags(void)
 {
 	return SD_CLUSTER | SD_SHARE_LLC;
 }
+
+static inline const
+struct cpumask *tl_cls_mask(struct sched_domain_topology_level *tl, int cpu)
+{
+	return cpu_clustergroup_mask(cpu);
+}
 #endif
 
 #ifdef CONFIG_SCHED_MC
@@ -49,8 +63,20 @@ static inline int cpu_core_flags(void)
 {
 	return SD_SHARE_LLC;
 }
+
+static inline const
+struct cpumask *tl_mc_mask(struct sched_domain_topology_level *tl, int cpu)
+{
+	return cpu_coregroup_mask(cpu);
+}
 #endif
 
+static inline const
+struct cpumask *tl_pkg_mask(struct sched_domain_topology_level *tl, int cpu)
+{
+	return cpu_node_mask(cpu);
+}
+
 #ifdef CONFIG_NUMA
 static inline int cpu_numa_flags(void)
 {
@@ -172,7 +198,7 @@ bool cpus_equal_capacity(int this_cpu, int that_cpu);
 bool cpus_share_cache(int this_cpu, int that_cpu);
 bool cpus_share_resources(int this_cpu, int that_cpu);
 
-typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+typedef const struct cpumask *(*sched_domain_mask_f)(struct sched_domain_topology_level *tl, int cpu);
 typedef int (*sched_domain_flags_f)(void);
 
 struct sd_data {
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 33b7fda97d390..6575af39fd10f 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -260,7 +260,7 @@ static inline bool topology_is_primary_thread(unsigned int cpu)
 
 #endif
 
-static inline const struct cpumask *cpu_cpu_mask(int cpu)
+static inline const struct cpumask *cpu_node_mask(int cpu)
 {
 	return cpumask_of_node(cpu_to_node(cpu));
 }
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 6e2f54169e66c..36d4f9f063516 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1591,7 +1591,6 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 enum numa_topology_type sched_numa_topology_type;
 
 static int			sched_domains_numa_levels;
-static int			sched_domains_curr_level;
 
 int				sched_max_numa_distance;
 static int			*sched_domains_numa_distance;
@@ -1632,14 +1631,7 @@ sd_init(struct sched_domain_topology_level *tl,
 	int sd_id, sd_weight, sd_flags = 0;
 	struct cpumask *sd_span;
 
-#ifdef CONFIG_NUMA
-	/*
-	 * Ugly hack to pass state to sd_numa_mask()...
-	 */
-	sched_domains_curr_level = tl->numa_level;
-#endif
-
-	sd_weight = cpumask_weight(tl->mask(cpu));
+	sd_weight = cpumask_weight(tl->mask(tl, cpu));
 
 	if (tl->sd_flags)
 		sd_flags = (*tl->sd_flags)();
@@ -1677,7 +1669,7 @@ sd_init(struct sched_domain_topology_level *tl,
 	};
 
 	sd_span = sched_domain_span(sd);
-	cpumask_and(sd_span, cpu_map, tl->mask(cpu));
+	cpumask_and(sd_span, cpu_map, tl->mask(tl, cpu));
 	sd_id = cpumask_first(sd_span);
 
 	sd->flags |= asym_cpu_capacity_classify(sd_span, cpu_map);
@@ -1737,17 +1729,17 @@ sd_init(struct sched_domain_topology_level *tl,
  */
 static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_SMT
-	SDTL_INIT(cpu_smt_mask, cpu_smt_flags, SMT),
+	SDTL_INIT(tl_smt_mask, cpu_smt_flags, SMT),
 #endif
 
 #ifdef CONFIG_SCHED_CLUSTER
-	SDTL_INIT(cpu_clustergroup_mask, cpu_cluster_flags, CLS),
+	SDTL_INIT(tl_cls_mask, cpu_cluster_flags, CLS),
 #endif
 
 #ifdef CONFIG_SCHED_MC
-	SDTL_INIT(cpu_coregroup_mask, cpu_core_flags, MC),
+	SDTL_INIT(tl_mc_mask, cpu_core_flags, MC),
 #endif
-	SDTL_INIT(cpu_cpu_mask, NULL, PKG),
+	SDTL_INIT(tl_pkg_mask, NULL, PKG),
 	{ NULL, },
 };
 
@@ -1769,9 +1761,9 @@ void __init set_sched_topology(struct sched_domain_topology_level *tl)
 
 #ifdef CONFIG_NUMA
 
-static const struct cpumask *sd_numa_mask(int cpu)
+static const struct cpumask *sd_numa_mask(struct sched_domain_topology_level *tl, int cpu)
 {
-	return sched_domains_numa_masks[sched_domains_curr_level][cpu_to_node(cpu)];
+	return sched_domains_numa_masks[tl->numa_level][cpu_to_node(cpu)];
 }
 
 static void sched_numa_warn(const char *str)
@@ -2413,7 +2405,7 @@ static bool topology_span_sane(const struct cpumask *cpu_map)
 		 * breaks the linking done for an earlier span.
 		 */
 		for_each_cpu(cpu, cpu_map) {
-			const struct cpumask *tl_cpu_mask = tl->mask(cpu);
+			const struct cpumask *tl_cpu_mask = tl->mask(tl, cpu);
 			int id;
 
 			/* lowest bit set in this mask is used as a unique id */
@@ -2421,7 +2413,7 @@ static bool topology_span_sane(const struct cpumask *cpu_map)
 
 			if (cpumask_test_cpu(id, id_seen)) {
 				/* First CPU has already been seen, ensure identical spans */
-				if (!cpumask_equal(tl->mask(id), tl_cpu_mask))
+				if (!cpumask_equal(tl->mask(tl, id), tl_cpu_mask))
 					return false;
 			} else {
 				/* First CPU hasn't been seen before, ensure it's a completely new span */
-- 
2.51.0



