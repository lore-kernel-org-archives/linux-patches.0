Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9713C7D419
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 22:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706653247; cv=none; b=BNBgSuHVIA5aUNe8N9rEhfFg0FOkzQtCsmTS/lyuHgh2pctzI7sl/zjDEam7ipNeGzM4Jr8gHE5ALhRwA77b9vDM+2/hwY7TYkwHboujQaYcYnOwHEFD/lpfaH25Rtj11KEITgCQHUnSYqkKp3EO8Tr5ZVdnpoY0Px1rJUXnkyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706653247; c=relaxed/simple;
	bh=1TyiQiWxXMk7SQhe5/husjTz7Y/m94kkQYw6BLrbMtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMCOMpA+rWH25U4N9t6kP0mDCmalemxz2YyE80Ee3j9AstXgDq9TOyKzus0eMyYb3xmILuT5XvIEHNAIsF6iQXHNmJyx30xjJPq+6G1pgPauBFI5vtqt76Wjk/rJFm8JRPmQ6DzxqMzqs/txugzGcQulXOLUhvE2ncRBHaNynSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjI8K8tW; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjI8K8tW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706653245; x=1738189245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1TyiQiWxXMk7SQhe5/husjTz7Y/m94kkQYw6BLrbMtY=;
  b=MjI8K8tWekToiHcH4RWm9xRHZcuxgX5Lh/5SW22fwBoDf2fnnQc8Kj6/
   sDPoMcZZiSKMe8V+uyWrOmWJuOAVZTYPkDw1VWSmTHGcPQOU18bOgcaaA
   EEOigqP2NSBt1kMitPIY5kmNF/abQZZ2mmCBzhMwQkKSyvlJjHX8ZSAGg
   g8CbXlMrJul+m/tMDrejWLAQqw9B1icc1sCrIRx/4Y+SxwqB4ueq8N6Sp
   Qv9MKccK5r1uEePPXgL+y2KYlyvYYZWuryLwIvXjX9UReTngoDO7ISnq+
   HONQCnwwzr/BR0ZEvGafV1O0ePhs2iQ0CJDqE9WM/Rrhi22z40f0nlkLI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="403041720"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="403041720"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 14:20:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="1119412841"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="1119412841"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 14:20:42 -0800
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
Subject: [PATCH v15-RFC 2/8] x86/resctrl: Move all monitoring functions to RDT_RESOURCE_L3_MON
Date: Tue, 30 Jan 2024 14:20:28 -0800
Message-ID: <20240130222034.37181-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130222034.37181-1-tony.luck@intel.com>
References: <20240126223837.21835-1-tony.luck@intel.com>
 <20240130222034.37181-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch over all places that setup and use monitoring funtions to
use the new resource structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c     |  6 ++++--
 arch/x86/kernel/cpu/resctrl/monitor.c  | 12 ++++--------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c50f55d7790e..0828575c3e13 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -591,11 +591,13 @@ static void domain_remove_cpu(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (r == &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl) {
+	if (r == &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl) {
 		if (is_mbm_enabled() && cpu == d->mbm_work_cpu) {
 			cancel_delayed_work(&d->mbm_over);
 			mbm_setup_overflow_handler(d, 0);
 		}
+	}
+	if (r == &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl) {
 		if (is_llc_occupancy_enabled() && cpu == d->cqm_work_cpu &&
 		    has_busy_rmid(r, d)) {
 			cancel_delayed_work(&d->cqm_limbo);
@@ -826,7 +828,7 @@ static __init bool get_rdt_alloc_resources(void)
 
 static __init bool get_rdt_mon_resources(void)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 
 	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC))
 		rdt_mon_features |= (1 << QOS_L3_OCCUP_EVENT_ID);
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 3a6c069614eb..080cad0d7288 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -268,7 +268,7 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain *d,
  */
 void __check_limbo(struct rdt_domain *d, bool force_free)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 	struct rmid_entry *entry;
 	u32 crmid = 1, nrmid;
 	bool rmid_dirty;
@@ -333,7 +333,7 @@ int alloc_rmid(void)
 
 static void add_rmid_to_limbo(struct rmid_entry *entry)
 {
-	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 	struct rdt_domain *d;
 	int cpu, err;
 	u64 val = 0;
@@ -623,7 +623,7 @@ void cqm_handle_limbo(struct work_struct *work)
 
 	mutex_lock(&rdtgroup_mutex);
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 	d = container_of(work, struct rdt_domain, cqm_limbo.work);
 
 	__check_limbo(d, false);
@@ -659,7 +659,7 @@ void mbm_handle_overflow(struct work_struct *work)
 	if (!static_branch_likely(&rdt_mon_enable_key))
 		goto out_unlock;
 
-	r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+	r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 	d = container_of(work, struct rdt_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
@@ -736,10 +736,6 @@ static struct mon_evt mbm_local_event = {
 
 /*
  * Initialize the event list for the resource.
- *
- * Note that MBM events are also part of RDT_RESOURCE_L3 resource
- * because as per the SDM the total and local memory bandwidth
- * are enumerated as part of L3 monitoring.
  */
 static void l3_mon_evt_init(struct rdt_resource *r)
 {
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index aa24343f1d23..9ee3a9906781 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2644,7 +2644,7 @@ static int rdt_get_tree(struct fs_context *fc)
 		static_branch_enable_cpuslocked(&rdt_enable_key);
 
 	if (is_mbm_enabled()) {
-		r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
+		r = &rdt_resources_all[RDT_RESOURCE_L3_MON].r_resctrl;
 		list_for_each_entry(dom, &r->domains, list)
 			mbm_setup_overflow_handler(dom, MBM_OVERFLOW_INTERVAL);
 	}
-- 
2.43.0

