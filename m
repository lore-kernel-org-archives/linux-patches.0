Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A69E77840
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709149052; cv=none; b=lq+Rqa1ZRtsooEbtSuj2EhXpo2QjA0EWsSXWpn3ZU726u+dPnX3TLYg1TYidLLf94vBbOk8WnF7qmzb3SV6m0RNc9fdlfIhMFFZjuXrXlxmY7skUMV05pIo/dxAuEO/wZm/6oX+LrN5MJ3+8QgUbBfldqqXEzjUrRnZI1mJ9DtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709149052; c=relaxed/simple;
	bh=GZ6Fxz5NTAguSBgG4QB2OlKuE6tlPVQE9QuNQQhOdSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXrUGMnXVDjOQJLpaby2YO6NlyDMdsqgH6qcEDF8OrDgIWELRmz7e88tkpxvgv04YwbejxRNCHbfgeqKOnbIq9pEIEkPc4bRAP+bElhEnGLM/uxPL3GuFwr5Q2M3b7CoiSyikv8ngUk3uWaRghiS5So210afG/8sI0OLJ1iStbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=II6Ees7V; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="II6Ees7V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709149051; x=1740685051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GZ6Fxz5NTAguSBgG4QB2OlKuE6tlPVQE9QuNQQhOdSs=;
  b=II6Ees7VrMxztFWfsBs8SNgnw9eKdrhtskpwyAPw9nAYFBaQBI0ROD6B
   ppCGxXHdY7S219jFlbyY5U/NQJyDJlNCnxdsM21ow+Jo0foJhfcohYa4s
   Thu91uzZRPnJZDI4czwH8PO/qd/oZzZC641lusqhjnTUUg9VBSWxhVSCB
   ffbhcIGYIRehwqL+QnPT+g2OHsxVfedgKb2UOH2z1mVDK7WZsOpzF5C71
   8dhFjL6VX62QWCHkpRioL5VJjyDxUja1wE+YPHGd+Mq5pLeTIuy5/oRot
   9sxzKB8hk/fT/sn975JkwM4j90Lx2/p275A/jzAbNQz7Hzy9fTp2ACb44
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3495562"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="3495562"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7485401"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 11:37:20 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Drew Fustini <dfustini@baylibre.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v15 6/8] x86/resctrl: Introduce snc_nodes_per_l3_cache
Date: Wed, 28 Feb 2024 11:37:01 -0800
Message-ID: <20240228193717.8170-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240228112935.8087-tony.luck@intel.com>
References: <20240228112215.8044-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
and memory controllers on a socket into two or more groups. These are
presented to the operating system as NUMA nodes.

This may enable some workloads to have slightly lower latency to memory
as the memory controller(s) in an SNC node are electrically closer to the
CPU cores on that SNC node. This cost may be offset by lower bandwidth
since the memory accesses for each core can only be interleaved between
the memory controllers on the same SNC node.

Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
to track L3 cache occupancy and memory bandwidth. There is an MSR that
controls how the RMIDs are shared between SNC nodes.

The default mode divides them numerically. E.g. when there are two SNC
nodes on a socket the lower number half of the RMIDs are given to the
first node, the remainder to the second node. This would be difficult
to use with the Linux resctrl interface as specific RMID values assigned
to resctrl groups are not visible to users.

The other mode divides the RMIDs and renumbers the ones on the second
SNC node to start from zero.

Even with this renumbering SNC mode requires several changes in resctrl
behavior for correct operation.

Add a global integer "snc_nodes_per_l3_cache" that shows how many
SNC nodes share each L3 cache. When "snc_nodes_per_l3_cache" is "1",
SNC mode is either not implemented, or not enabled.

Update all places to take appropriate action when SNC mode is enabled:
1) The number of logical RMIDs per L3 cache available for use is the
   number of physical RMIDs divided by the number of SNC nodes.
2) Likewise the "mon_scale" value must be divided by the number of SNC
   nodes.
3) The RMID renumbering operates when using the value from the
   IA32_PQR_ASSOC MSR to count accesses by a task. When reading an RMID
   counter, adjust from the logical RMID to the physical
   RMID value for the SNC node that it wishes to read and load the
   adjusted value into the IA32_QM_EVTSEL MSR.
4) Divide the L3 cache between the SNC nodes. Divide the value
   reported in the resctrl "size" file by the number of SNC
   nodes because the effective amount of cache that can be allocated
   is reduced by that factor.
5) Disable the "-o mba_MBps" mount option in SNC mode
   because the monitoring is being done per SNC node, while the
   bandwidth allocation is still done at the L3 cache scope.
   Trying to use this feedback loop might result in contradictory
   changes to the throttling level coming from each of the SNC
   node bandwidth measurements.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h |  2 ++
 arch/x86/kernel/cpu/resctrl/core.c     |  6 ++++++
 arch/x86/kernel/cpu/resctrl/monitor.c  | 16 +++++++++++++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  5 +++--
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 41a093feb744..786035eff7fb 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -483,6 +483,8 @@ extern struct rdt_hw_resource rdt_resources_all[];
 extern struct rdtgroup rdtgroup_default;
 extern struct dentry *debugfs_resctrl;
 
+extern unsigned int snc_nodes_per_l3_cache;
+
 enum resctrl_res_level {
 	RDT_RESOURCE_L3,
 	RDT_RESOURCE_L2,
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c34ce367c456..cb181796f73b 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -331,6 +331,12 @@ static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
 	return r->default_ctrl;
 }
 
+/*
+ * Number of SNC nodes that share each L3 cache.  Default is 1 for
+ * systems that do not support SNC, or have SNC disabled.
+ */
+unsigned int snc_nodes_per_l3_cache = 1;
+
 static void mba_wrmsr_intel(struct msr_param *m)
 {
 	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 08d53ce61d01..87badcec2834 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -186,8 +186,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
 
 static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
 {
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	int cpu = smp_processor_id();
+	int rmid_offset = 0;
 	u64 msr_val;
 
+	/*
+	 * When SNC mode is on, need to compute the offset to read the
+	 * physical RMID counter for the node to which this CPU belongs.
+	 */
+	if (snc_nodes_per_l3_cache > 1)
+		rmid_offset = (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
+
 	/*
 	 * As per the SDM, when IA32_QM_EVTSEL.EvtID (bits 7:0) is configured
 	 * with a valid event code for supported resource type and the bits
@@ -196,7 +206,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
 	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
 	 * are error bits.
 	 */
-	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
+	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid + rmid_offset);
 	rdmsrl(MSR_IA32_QM_CTR, msr_val);
 
 	if (msr_val & RMID_VAL_ERROR)
@@ -1011,8 +1021,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	int ret;
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
-	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
+	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
+	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 821c32876cc1..1afc64bf46fa 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1466,7 +1466,7 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 		}
 	}
 
-	return size;
+	return size / snc_nodes_per_l3_cache;
 }
 
 /*
@@ -2346,7 +2346,8 @@ static bool supports_mba_mbps(void)
 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
 
 	return (is_mbm_local_enabled() &&
-		r->alloc_capable && is_mba_linear());
+		r->alloc_capable && is_mba_linear() &&
+		snc_nodes_per_l3_cache == 1);
 }
 
 /*
-- 
2.43.0

