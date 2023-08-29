Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3797462
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 23:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693352681; x=1724888681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WgHlgC60ihdg3OH9uRN9oBta8S6ahuDhNdnK2yhBSmQ=;
  b=Mr72NLygg2lTOgLrurIrmrx0NrwWhos2vQSM7mvpPZkjLgaHU9o1p1Lc
   l7wTo64W41OfNE7o0XdCYIBrmofWtU7QzJTqlD8aMUwIbmkWfYA9xrIos
   MWu7tWJ8GP+B+uyuk8VrRY0SaNEu6yPQdXE3zraFCMUY473ODN/1rX84z
   2YlabodYMKghB5FrCL0aCIgCEonhaef6LRIOcAM36KBxFNDVcHHobKVMf
   ge8ty/C2e/7NOl4D/QDdNOzim19QodzJs/r2nrRb/L+rMfcY1sUcwCRZc
   eSSdySzC5Lx/peNrPgnVE+IFB1zXfVS2SDNvke1TvUYN+1O5aaVVyb83y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="355015413"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="355015413"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="688691020"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="688691020"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:36 -0700
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
Subject: [PATCH v5 1/8] x86/resctrl: Prepare for new domain scope
Date: Tue, 29 Aug 2023 16:44:19 -0700
Message-ID: <20230829234426.64421-2-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829234426.64421-1-tony.luck@intel.com>
References: <20230722190740.326190-1-tony.luck@intel.com>
 <20230829234426.64421-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Legacy resctrl features operated on subsets of CPUs in the system with
the defining attribute of each subset being an instance of a particular
level of cache. E.g. all CPUs sharing an L3 cache would be part of the
same domain.

In preparation for features that are scoped at the NUMA node level
change the code from explicit references to "cache_level" to a more
generic scope. At this point the only options for this scope are groups
of CPUs that share an L2 cache or L3 cache.

No functional change.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                   |  9 ++++++--
 arch/x86/kernel/cpu/resctrl/core.c        | 27 ++++++++++++++++++-----
 arch/x86/kernel/cpu/resctrl/pseudo_lock.c | 15 ++++++++++++-
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 15 ++++++++++++-
 4 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 8334eeacfec5..2db1244ae642 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -144,13 +144,18 @@ struct resctrl_membw {
 struct rdt_parse_data;
 struct resctrl_schema;
 
+enum resctrl_scope {
+	RESCTRL_L3_CACHE,
+	RESCTRL_L2_CACHE,
+};
+
 /**
  * struct rdt_resource - attributes of a resctrl resource
  * @rid:		The index of the resource
  * @alloc_capable:	Is allocation available on this machine
  * @mon_capable:	Is monitor feature available on this machine
  * @num_rmid:		Number of RMIDs available
- * @cache_level:	Which cache level defines scope of this resource
+ * @scope:		Scope of this resource
  * @cache:		Cache allocation related data
  * @membw:		If the component has bandwidth controls, their properties.
  * @domains:		All domains for this resource
@@ -168,7 +173,7 @@ struct rdt_resource {
 	bool			alloc_capable;
 	bool			mon_capable;
 	int			num_rmid;
-	int			cache_level;
+	enum resctrl_scope	scope;
 	struct resctrl_cache	cache;
 	struct resctrl_membw	membw;
 	struct list_head	domains;
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 030d3b409768..0d3bae523ecb 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -65,7 +65,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_L3,
 			.name			= "L3",
-			.cache_level		= 3,
+			.scope			= RESCTRL_L3_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_L3),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -79,7 +79,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_L2,
 			.name			= "L2",
-			.cache_level		= 2,
+			.scope			= RESCTRL_L2_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_L2),
 			.parse_ctrlval		= parse_cbm,
 			.format_str		= "%d=%0*x",
@@ -93,7 +93,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_MBA,
 			.name			= "MB",
-			.cache_level		= 3,
+			.scope			= RESCTRL_L3_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_MBA),
 			.parse_ctrlval		= parse_bw,
 			.format_str		= "%d=%*u",
@@ -105,7 +105,7 @@ struct rdt_hw_resource rdt_resources_all[] = {
 		.r_resctrl = {
 			.rid			= RDT_RESOURCE_SMBA,
 			.name			= "SMBA",
-			.cache_level		= 3,
+			.scope			= RESCTRL_L3_CACHE,
 			.domains		= domain_init(RDT_RESOURCE_SMBA),
 			.parse_ctrlval		= parse_bw,
 			.format_str		= "%d=%*u",
@@ -487,6 +487,21 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
 	return 0;
 }
 
+static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
+{
+	switch (scope) {
+	case RESCTRL_L3_CACHE:
+		return get_cpu_cacheinfo_id(cpu, 3);
+	case RESCTRL_L2_CACHE:
+		return get_cpu_cacheinfo_id(cpu, 2);
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return -1;
+}
+
 /*
  * domain_add_cpu - Add a cpu to a resource's domain list.
  *
@@ -502,7 +517,7 @@ static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_domain *hw_dom)
  */
 static void domain_add_cpu(int cpu, struct rdt_resource *r)
 {
-	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
+	int id = get_domain_id_from_scope(cpu, r->scope);
 	struct list_head *add_pos = NULL;
 	struct rdt_hw_domain *hw_dom;
 	struct rdt_domain *d;
@@ -552,7 +567,7 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 
 static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 {
-	int id = get_cpu_cacheinfo_id(cpu, r->cache_level);
+	int id = get_domain_id_from_scope(cpu, r->scope);
 	struct rdt_hw_domain *hw_dom;
 	struct rdt_domain *d;
 
diff --git a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
index 458cb7419502..e79324676f57 100644
--- a/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
+++ b/arch/x86/kernel/cpu/resctrl/pseudo_lock.c
@@ -279,6 +279,7 @@ static void pseudo_lock_region_clear(struct pseudo_lock_region *plr)
 static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 {
 	struct cpu_cacheinfo *ci;
+	int cache_level;
 	int ret;
 	int i;
 
@@ -296,8 +297,20 @@ static int pseudo_lock_region_init(struct pseudo_lock_region *plr)
 
 	plr->size = rdtgroup_cbm_to_size(plr->s->res, plr->d, plr->cbm);
 
+	switch (plr->s->res->scope) {
+	case RESCTRL_L3_CACHE:
+		cache_level = 3;
+		break;
+	case RESCTRL_L2_CACHE:
+		cache_level = 2;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -ENODEV;
+	}
+
 	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == plr->s->res->cache_level) {
+		if (ci->info_list[i].level == cache_level) {
 			plr->line_size = ci->info_list[i].coherency_line_size;
 			return 0;
 		}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 725344048f85..f510414bf6ce 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1343,12 +1343,25 @@ unsigned int rdtgroup_cbm_to_size(struct rdt_resource *r,
 {
 	struct cpu_cacheinfo *ci;
 	unsigned int size = 0;
+	int cache_level;
 	int num_b, i;
 
+	switch (r->scope) {
+	case RESCTRL_L3_CACHE:
+		cache_level = 3;
+		break;
+	case RESCTRL_L2_CACHE:
+		cache_level = 2;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return size;
+	}
+
 	num_b = bitmap_weight(&cbm, r->cache.cbm_len);
 	ci = get_cpu_cacheinfo(cpumask_any(&d->cpu_mask));
 	for (i = 0; i < ci->num_leaves; i++) {
-		if (ci->info_list[i].level == r->cache_level) {
+		if (ci->info_list[i].level == cache_level) {
 			size = ci->info_list[i].size / r->cache.cbm_len * num_b;
 			break;
 		}
-- 
2.41.0

