Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3856153BDE
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718044554; cv=none; b=TCQmDVH+Clg49px+IsIiOED9oxoiUpWrcqW+6+sFdXZpHBSrSmRKIGaJO5O78HWV472k4+c4edeenrq3aAaJT0ilu4NnpbT73Q1zM10f4JseKWFNrTEiOEhdmtwWulQTGI66J+yX4Me4BjK0n6ibYCP9yt9lNLxgYdydA/LPGuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718044554; c=relaxed/simple;
	bh=0a/5yP+bOsvyPo9kpZjwN22typeu76+CUxAY34UmHFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1seThBTLBFQPCR2VSb13lp85rB1nrNKL4Ijvp626lA1hpF6mgZ7bFRGyx4mZKd8TiWuaBsAAMLDKFqy5ezv9Pdigj2H6eyoGxLnJSleqNpXDhERAYwusZXPYGZvcLFGN0FnWQ4nMyuwca12v8NPeZypEwS7gwWQST3ixU/ch0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WZNSlYFa; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WZNSlYFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718044552; x=1749580552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0a/5yP+bOsvyPo9kpZjwN22typeu76+CUxAY34UmHFA=;
  b=WZNSlYFanxOuJRyEUmYpR9kOHS9VTM/AATw2RkDrlg1Uzy+TwLguRp3t
   6mtXx07Si44mc2OBZ56vrfXL3hmdc5rhZ1YCmQra3LPBGdUqMnWrEur3b
   SQ5XIEfmWZTXrBCaeheUl5I6b7NGGZh4ZPel77aLFvxQ3vjs4oeAAsx4o
   raI6yKQXtx6nl2wCVA4V4VOt6Dt+n7zrnwtwcgj1tqK19SG11edwlJ5L4
   iTLZR84z7NSz7/bVSDEbsvgGrH1Itddqn+lvZ33xK6ggGMrxuXA3dVxEs
   F51wV1et7hBGbmWb9py/RaEq9mg9HOCvXwRyJc+zuXCOiOQDEbzufMF2T
   g==;
X-CSE-ConnectionGUID: 0GNghAb3R3u0tT8f2DIrjw==
X-CSE-MsgGUID: ZSSAm0FbQYSyGRfMLCIeTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="12004888"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="12004888"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:39 -0700
X-CSE-ConnectionGUID: 4U0Ihpc+RmicPJkdZISuXA==
X-CSE-MsgGUID: 1WZ1OG77TOuhMVuMCeSQ3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="43576604"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 11:35:39 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v20 17/18] x86/resctrl: Sub-NUMA Cluster (SNC) detection
Date: Mon, 10 Jun 2024 11:35:27 -0700
Message-ID: <20240610183528.349198-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240610183528.349198-1-tony.luck@intel.com>
References: <20240610183528.349198-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There isn't a simple hardware bit that indicates whether a CPU is
running in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing
the number of CPUs sharing the L3 cache with CPU0 to the number of CPUs in
the same NUMA node as CPU0.

If SNC mode is detected, print a single informational message to the
console.

Add the missing definition of pr_fmt() to monitor.c. This wasn't
noticed before as there are only "can't happen" console messages
from this file.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 66 +++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index efbb84c00d79..9835706ef772 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -15,6 +15,8 @@
  * Software Developer Manual June 2016, volume 3, section 17.17.
  */
 
+#define pr_fmt(fmt)	"resctrl: " fmt
+
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -1108,6 +1110,68 @@ void arch_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d)
 	wrmsrl(MSR_RMID_SNC_CONFIG, val);
 }
 
+/* CPU models that support MSR_RMID_SNC_CONFIG */
+static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
+	X86_MATCH_VFM(INTEL_ICELAKE_X, 0),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_EMERALDRAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_GRANITERAPIDS_X, 0),
+	X86_MATCH_VFM(INTEL_ATOM_CRESTMONT_X, 0),
+	{}
+};
+
+/*
+ * There isn't a simple hardware bit that indicates whether a CPU is running
+ * in Sub-NUMA Cluster (SNC) mode. Infer the state by comparing the
+ * number CPUs sharing the L3 cache with CPU0 to the number of CPUs in
+ * the same NUMA node as CPU0.
+ * It is not possible to accurately determine SNC state if the system is
+ * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
+ * to L3 caches. It will be OK if system is booted with hyperthreading
+ * disabled (since this doesn't affect the ratio).
+ */
+static __init int snc_get_config(void)
+{
+	struct cacheinfo *ci = get_cpu_cacheinfo_level(0, RESCTRL_L3_CACHE);
+	const cpumask_t *node0_cpumask;
+	int cpus_per_node, cpus_per_l3;
+	int ret;
+
+	if (!x86_match_cpu(snc_cpu_ids) || !ci)
+		return 1;
+
+	cpus_read_lock();
+	if (num_online_cpus() != num_present_cpus())
+		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
+	cpus_read_unlock();
+
+	node0_cpumask = cpumask_of_node(cpu_to_node(0));
+
+	cpus_per_node = cpumask_weight(node0_cpumask);
+	cpus_per_l3 = cpumask_weight(&ci->shared_cpu_map);
+
+	if (!cpus_per_node || !cpus_per_l3)
+		return 1;
+
+	ret = cpus_per_l3 / cpus_per_node;
+
+	/* sanity check: Only valid results are 1, 2, 3, 4 */
+	switch (ret) {
+	case 1:
+		break;
+	case 2 ... 4:
+		pr_info("Sub-NUMA Cluster mode detected with %d nodes per L3 cache\n", ret);
+		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_L3_NODE;
+		break;
+	default:
+		pr_warn("Ignore improbable SNC node count %d\n", ret);
+		ret = 1;
+		break;
+	}
+
+	return ret;
+}
+
 int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 {
 	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
@@ -1115,6 +1179,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	unsigned int threshold;
 	int ret;
 
+	snc_nodes_per_l3_cache = snc_get_config();
+
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
 	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
 	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
-- 
2.45.0

