Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6284E19BDD
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687369243; x=1718905243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RVDOF3voxFX9Crt96XzA5tUu5TmsiIolJV8bjLoqkS4=;
  b=fPPC8b+3af4Zron6S3bqUItV/JxyYN76heEGSVnIs9Sq1gmquEHAQ8Fc
   aA0zNdj1xuFDW5zDPFGivNdPwVlGYXoLcJg4P1QPVLKtjakE2ci2YAmXQ
   497X41vZrbUcE/sgi4u0zX1uoYvLb0gdE68+5MB+8NaxTU4SOtovjvDtO
   B8hzucnzhuAPB5uENNaTZQAzyKXD8oI4JeM7OaqxiUqzUKSPEE3GZlEc1
   0fsH9TO/i80ETbaSJF6stfl4I9+nR0E4l//Yfruv4Q6Y6Uao+Gh1qVn94
   nx7GRROCrOZd5yOgjTBuf35Ww5RazucFVdEEkURZ4y2uwzYSh9ITrBw6M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="359120544"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="359120544"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="779921575"
X-IronPort-AV: E=Sophos;i="6.00,261,1681196400"; 
   d="scan'208";a="779921575"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 10:40:17 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 5/7] x86/resctrl: Add package scoped resource
Date: Wed, 21 Jun 2023 10:40:04 -0700
Message-Id: <20230621174006.42533-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230621174006.42533-1-tony.luck@intel.com>
References: <20230621174006.42533-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some Intel features require setting a package scoped model specific
register.

Add a new resource that builds domains for each package.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                |  1 +
 arch/x86/kernel/cpu/resctrl/internal.h |  6 ++++++
 arch/x86/kernel/cpu/resctrl/core.c     | 23 +++++++++++++++++++----
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 25051daa6655..f504f6263fec 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -167,6 +167,7 @@ struct rdt_resource {
 	int			rid;
 	bool			alloc_capable;
 	bool			mon_capable;
+	bool			pkg_actions;
 	int			num_rmid;
 	int			scope;
 	struct resctrl_cache	cache;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 38bac0062c82..e51a5004be77 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -438,6 +438,7 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_NODE,
+	RDT_RESOURCE_PKG,
 
 	/* Must be the last */
 	RDT_NUM_RESOURCES,
@@ -447,6 +448,7 @@ enum resctrl_scope {
 	SCOPE_L2_CACHE = 2,
 	SCOPE_L3_CACHE = 3,
 	SCOPE_NODE,
+	SCOPE_PKG,
 };
 
 static inline int get_mbm_res_level(void)
@@ -482,6 +484,10 @@ int resctrl_arch_set_cdp_enabled(enum resctrl_res_level l, bool enable);
 	for_each_rdt_resource(r)					      \
 		if (r->alloc_capable || r->mon_capable)
 
+#define for_each_domain_needed_rdt_resource(r)				      \
+	for_each_rdt_resource(r)					      \
+		if (r->alloc_capable || r->mon_capable || r->pkg_actions)
+
 #define for_each_alloc_capable_rdt_resource(r)				      \
 	for_each_rdt_resource(r)					      \
 		if (r->alloc_capable)
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6fe9f87d4403..af3be3c2db96 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -127,6 +127,16 @@ struct rdt_hw_resource rdt_resources_all[] = {
 			.fflags			= 0,
 		},
 	},
+	[RDT_RESOURCE_PKG] =
+	{
+		.r_resctrl = {
+			.rid			= RDT_RESOURCE_PKG,
+			.name			= "PKG",
+			.scope			= SCOPE_PKG,
+			.domains		= domain_init(RDT_RESOURCE_PKG),
+			.fflags			= 0,
+		},
+	},
 };
 
 /*
@@ -504,9 +514,14 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
 
 static int get_domain_id(int cpu, enum resctrl_scope scope)
 {
-	if (scope == SCOPE_NODE)
+	switch (scope) {
+	case SCOPE_NODE:
 		return cpu_to_node(cpu);
-	return get_cpu_cacheinfo_id(cpu, scope);
+	case SCOPE_PKG:
+		return topology_physical_package_id(cpu);
+	default:
+		return get_cpu_cacheinfo_id(cpu, scope);
+	}
 }
 
 /*
@@ -630,7 +645,7 @@ static int resctrl_online_cpu(unsigned int cpu)
 	struct rdt_resource *r;
 
 	mutex_lock(&rdtgroup_mutex);
-	for_each_capable_rdt_resource(r)
+	for_each_domain_needed_rdt_resource(r)
 		domain_add_cpu(cpu, r);
 	/* The cpu is set in default rdtgroup after online. */
 	cpumask_set_cpu(cpu, &rdtgroup_default.cpu_mask);
@@ -657,7 +672,7 @@ static int resctrl_offline_cpu(unsigned int cpu)
 	struct rdt_resource *r;
 
 	mutex_lock(&rdtgroup_mutex);
-	for_each_capable_rdt_resource(r)
+	for_each_domain_needed_rdt_resource(r)
 		domain_remove_cpu(cpu, r);
 	list_for_each_entry(rdtgrp, &rdt_all_groups, rdtgroup_list) {
 		if (cpumask_test_and_clear_cpu(cpu, &rdtgrp->cpu_mask)) {
-- 
2.40.1

