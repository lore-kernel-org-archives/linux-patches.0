Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE521F18E
	for <patches@lists.linux.dev>; Thu, 13 Jul 2023 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689265954; x=1720801954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aaVT8LD/zFtFbNHJEOTnDWpLfqn+AGf2IASZmoZ4a+Q=;
  b=IQYXcKDqP3gBWRw/ZKOZEPvtiCa6SzUYOB1dvTMAHd1M91qKJVJqNNMJ
   QDTSxXs49s2o2ilZKInxmBkvH/wKDvXVWGYqEWFylraRs7khiJliKu8z0
   wIQOwgDBJrQNalou1kIfb5zfEj8uVwcvFuGRL8UGN7se/lfZBnVUaGncI
   1VMOsA/Hdg1W0sb40Fw8SVE4le7x95vaozmuBT/SQEfOA/1YyTqg3ZAlL
   pIzEgPqOu//cw3re2G7wQs4gJy4vWH+c+LPBMH4WBuCaCgt0rClwc5PJJ
   Tf1jhgbirJBQc9oYjninV6Y23Y46wUhVUFbpSTR71vDW4HK1+fh2jLvaU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="362707621"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="362707621"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="722046380"
X-IronPort-AV: E=Sophos;i="6.01,203,1684825200"; 
   d="scan'208";a="722046380"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2023 09:32:22 -0700
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
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 4/8] x86/resctrl: Add code to setup monitoring at L3 or NODE scope.
Date: Thu, 13 Jul 2023 09:32:03 -0700
Message-Id: <20230713163207.219710-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230713163207.219710-1-tony.luck@intel.com>
References: <20230713163207.219710-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA cluster is enabled (snc_ways > 1) use the RDT_RESOURCE_NODE
instead of RDT_RESOURCE_L3 for all monitoring operations.

The mon_scale and num_rmid values from CPUID(0xf,0x1),(EBX,ECX) must be
scaled down by the number of Sub-NUMA Clusters.

A subsequent change will detect sub-NUMA cluster mode and set
"snc_ways". For now set to one (meaning each L3 cache spans one
node).

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Peter Newman <peternewman@google.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 7 +++++++
 arch/x86/kernel/cpu/resctrl/core.c     | 7 ++++++-
 arch/x86/kernel/cpu/resctrl/monitor.c  | 4 ++--
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 2 +-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 243017096ddf..38bac0062c82 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -430,6 +430,8 @@ DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
 
 extern struct dentry *debugfs_resctrl;
 
+extern int snc_ways;
+
 enum resctrl_res_level {
 	RDT_RESOURCE_L3,
 	RDT_RESOURCE_L2,
@@ -447,6 +449,11 @@ enum resctrl_scope {
 	SCOPE_NODE,
 };
 
+static inline int get_mbm_res_level(void)
+{
+	return snc_ways > 1 ? RDT_RESOURCE_NODE : RDT_RESOURCE_L3;
+}
+
 static inline struct rdt_resource *resctrl_inc(struct rdt_resource *res)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(res);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index e4bd3072927c..6fe9f87d4403 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -48,6 +48,11 @@ int max_name_width, max_data_width;
  */
 bool rdt_alloc_capable;
 
+/*
+ * How many Sub-Numa Cluster nodes share a single L3 cache
+ */
+int snc_ways = 1;
+
 static void
 mba_wrmsr_intel(struct rdt_domain *d, struct msr_param *m,
 		struct rdt_resource *r);
@@ -831,7 +836,7 @@ static __init bool get_rdt_alloc_resources(void)
 
 static __init bool get_rdt_mon_resources(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = &rdt_resources_all[get_mbm_res_level()].r_resctrl;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
 		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 9be6ffdd01ae..da3f36212898 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -787,8 +787,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
 	int ret;
 
 	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
-	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
-	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
+	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_ways;
+	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_ways;
 	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
 
 	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 418658f0a9ad..d037f3da9e55 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2524,7 +2524,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		static_branch_enable_cpuslocked(&rdt_enable_key);
 
 	if (is_mbm_enabled()) {
-		r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+		r = &rdt_resources_all[get_mbm_res_level()].r_resctrl;
 		list_for_each_entry(dom, &r->domains, list)
 			mbm_setup_overflow_handler(dom, MBM_OVERFLOW_INTERVAL);
 	}
-- 
2.40.1

