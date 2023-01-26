Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A731E4C92
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758550; x=1706294550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pd74plTjDM934Mu3gAMHaaPSse3mzDXyW5UsS0F/p6Y=;
  b=M4+DrZXgFsISNEoVz+4DKQxvK+yFOj3zhIvbQlnh9XFRglKmQXe6dDJN
   M6Bdz0Yibu4rwzoSkclp8zi/9W0zEU/WRi783thglTZQ3UF1VjwojgqgO
   1uNm9vDA7IVPy3EpVfKrQ+miFU/6OeOpUdH1zNMbsMlIxLzYzE1pB+Co6
   Ha8+OC/OqlsevFMwHscJKkZOrauGidQA2yD19Le9nggr8/5aBsZMi506c
   EuNzHDWnmmLJh3qAPqvrWR7hyfm94SOHE9tZy0COvwsE0M/TUeFxs7U/e
   Sc5iOKKq6YS9noaDIHFoElJzW3tzH606RmjmbEm2GVFHjh/uZ2vxIZ3kw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203322"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203322"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745439"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745439"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:05 -0800
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
Subject: [PATCH 1/7] x86/resctrl: Refactor in preparation for node-scoped resources
Date: Thu, 26 Jan 2023 10:41:51 -0800
Message-Id: <20230126184157.27626-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sub-NUMA cluster systems provide monitoring resources at the NUMA
node scope instead of the L3 cache scope.

Rename the cache_level field in struct rdt_resource to the more
generic "scope" and add symbolic names and a helper function.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                   |  4 ++--
 arch/x86/kernel/cpu/resctrl/internal.h    |  5 +++++
 arch/x86/kernel/cpu/resctrl/core.c        | 15 ++++++++++-----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  2 +-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 0cee154abc9f..64ecfcafa0a2 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -150,7 +150,7 @@ struct resctrl_schema;
  * @alloc_capable:	Is allocation available on this machine
  * @mon_capable:	Is monitor feature available on this machine
  * @num_rmid:		Number of RMIDs available
- * @cache_level:	Which cache level defines scope of this resource
+ * @scope:		Scope of this resource (cache level or NUMA node)
  * @cache:		Cache allocation related data
  * @membw:		If the component has bandwidth controls, their properties.
  * @domains:		All domains for this resource
@@ -168,7 +168,7 @@ struct rdt_resource {
 	bool			alloc_capable;
 	bool			mon_capable;
 	int			num_rmid;
-	int			cache_level;
+	int			scope;
 	struct resctrl_cache	cache;
 	struct resctrl_membw	membw;
 	struct list_head	domains;
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 5ebd28e6aa0c..15cea517efaa 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -414,6 +414,11 @@ enum resctrl_res_level {
 	RDT_NUM_RESOURCES,
 };
 
+enum resctrl_scope {
+	SCOPE_L2_CACHE = 2,
+	SCOPE_L3_CACHE = 3
+};
+
 static inline struct rdt_resource *resctrl_inc(struct rdt_resource *res)
 {
 	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(res);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c98e52ff5f20..6914232acf84 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -65,7 +65,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
-			.cache_level		= 3,
+			.scope			= SCOPE_L3_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -79,7 +79,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
-			.cache_level		= 2,
+			.scope			= SCOPE_L2_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -93,7 +93,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_MBA,
 			.name			= "MB",
-			.cache_level		= 3,
+			.scope			= SCOPE_L3_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_MBA),
 			.parse_ctrlval		= parse_bw,
 			.format_str		= "%d=%*u",
@@ -462,6 +462,11 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
 	return 0;
 }
 
+static int get_domain_id(int cpu, enum resctrl_scope scope)
+{
+	return get_cpu_cacheinfo_id(cpu, scope);
+}
+
 /*
  * domain_add_cpu - Add a cpu to a resource's domain list.
  *
@@ -477,7 +482,7 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
  */
 static void domain_add_cpu(int cpu, struct rdt_resource *r)
 {
-	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
+	int id = get_domain_id(cpu, r->scope);
 	struct list_head *add_pos = NULL;
 	struct rdt_hw_domain *hw_dom;
 	struct rdt_domain *d;
@@ -527,7 +532,7 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 
 static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 {
-	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
+	int id = get_domain_id(cpu, r->scope);
 	struct rdt_hw_domain *hw_dom;
 	struct rdt_domain *d;
 
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 524f8ff3e69c..d2ba4f7f6a79 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -297,7 +297,7 @@ static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 	plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
 
 	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == plr->s->res->cache_level) {
+		if (ci->info_list[i].level == plr->s->res->scope) {
 			plr->line_size = ci->info_list[i].coherency_line_size;
 			return 0;
 		}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5993da21d822..a6ba3080e5db 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1333,7 +1333,7 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
 	ci = get_cpu_cacheinfo(cpumask_any(&d->cpu_mask));
 	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == r->cache_level) {
+		if (ci->info_list[i].level == r->scope) {
 			size = ci->info_list[i].size / r->cache.cbm_len * num_b;
 			break;
 		}
-- 
2.39.1

