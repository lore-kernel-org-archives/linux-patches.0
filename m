Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE9F204582
	for <patches@lists.linux.dev>; Fri, 14 Mar 2025 20:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741983979; cv=none; b=TLPYd5h5Dc2HNyyuPKj36OBedVUOB/0q0hMlGjL7G3x3bCW62IoIhqoQKDUIu801AJX4f+Ie/s3J3MdbMmeYvbvMw6QOQFuvOvAXpCpvn4ZeSRNupDlfn4JfB82Q09UnijXqncNbMKhbuqoybdDyLqQFkHFRB6iEuFkeSE084pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741983979; c=relaxed/simple;
	bh=oh34QAMiam2WAif9UoUCVBcieOviNCdkFK0g+VvEsF4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U2UWzOxfcNDKICiLxNmXXyHNukx+5fla5CHnmA+FB7e+8F4m+I113sS8wcaXPc49EC1StoxFTUpJUH+u0OHWOvxaxe3Rs8+VonOalrfKrUXvsjk6M5rs0IVjp0Cct846XUcB5/XpqSoOq335DZ3NWfdexFyqAtYzjiiRnMaaZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e2lIuNMl; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e2lIuNMl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741983977; x=1773519977;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oh34QAMiam2WAif9UoUCVBcieOviNCdkFK0g+VvEsF4=;
  b=e2lIuNMlW8GoPP5xHozYDtVyJ/IIx3ygs1yyNgyTgk71XVud7nj5LGHD
   AI/1dbihwFnugRhSIYaw4g2+vqTI3xKYbOK8rnEysvVChFsbQbh+ONbTT
   c5rj50HJoW20GZRgWlEzYF+SK6W7KzwDIWrSoejSaO8+BZLGrRbgVDOK+
   dFyrNhF5zg4+V2KNEQMOuz570xSFRPnEOhnozacENPYUbachqSz276w9x
   WxDrafFXqTbUBhDQXtdFIIcLs4rOi5JQI1hwFMaKsooptZH6FzE5LKwfE
   tzK9shN5B2VaqYDWAGSvG/zHYcPqVn17Xy1VK1UBSG5nWdavw0Dp9sWlo
   w==;
X-CSE-ConnectionGUID: zxSl6QiGS1aav98QdrpxFQ==
X-CSE-MsgGUID: dBVA3vPjQKGagqMWtlIsUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="43355407"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="43355407"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 13:26:16 -0700
X-CSE-ConnectionGUID: pDnO5SIsRSGkbepwF/OOnQ==
X-CSE-MsgGUID: KLCqXf3GSwuep4scyJM/dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="121370137"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 13:26:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/resctrl: Refactor to make adding extra MBM events easy
Date: Fri, 14 Mar 2025 13:26:09 -0700
Message-ID: <20250314202609.5753-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preamble
--------
I wrote this to play with some experimental MBM-like events
that may or may not ever see the light of day. I'm amused that
this refactor reduced the number of lines of code by enough
that the patch to support the new events basically just got
back to parity with current code size.

While the resulting code looks cleaner that the original, I'm
not sure there is much motivation to apply this change at the
moment. Just posting for casual reading and to archive it in
case I do need it someday.

Based on TIP x86/cache.

Commit message
--------------
There's a rule in computer programming that objects appear zero,
once, or many times. So code accordingly.

There are two MBM events and resctrl coded with a lot of
	if (local)
		do one thing
	if (total)
		do a different thing

Simplify the code by coding for many events using loops on
which are enabled.

Rename resctrl_is_mbm_event() to resctrl_arch_is_mbm_event()
and move to <asm/resctrl.h> as it gets used by core.c

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h                   |   6 +-
 include/linux/resctrl_types.h             |   2 +
 arch/x86/include/asm/resctrl.h            |   8 +-
 arch/x86/kernel/cpu/resctrl/internal.h    |   8 +-
 arch/x86/kernel/cpu/resctrl/core.c        |  34 ++++---
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  41 ++-------
 arch/x86/kernel/cpu/resctrl/monitor.c     | 104 +++++++++++-----------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  42 ++++-----
 8 files changed, 108 insertions(+), 137 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 880351ca3dfc..aaec3083db46 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -147,8 +147,7 @@ struct rdt_ctrl_domain {
  * @hdr:		common header for different domain types
  * @ci:			cache info for this domain
  * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
- * @mbm_total:		saved state for MBM total bandwidth
- * @mbm_local:		saved state for MBM local bandwidth
+ * @mbm_states:		saved state for each QOS MBM event
  * @mbm_over:		worker to periodically read MBM h/w counters
  * @cqm_limbo:		worker to periodically read CQM h/w counters
  * @mbm_work_cpu:	worker CPU for MBM h/w counters
@@ -158,8 +157,7 @@ struct rdt_mon_domain {
 	struct rdt_domain_hdr		hdr;
 	struct cacheinfo		*ci;
 	unsigned long			*rmid_busy_llc;
-	struct mbm_state		*mbm_total;
-	struct mbm_state		*mbm_local;
+	struct mbm_state		*mbm_states[QOS_L3_NUM_EVENTS];
 	struct delayed_work		mbm_over;
 	struct delayed_work		cqm_limbo;
 	int				mbm_work_cpu;
diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
index f26450b3326b..ecca6f419a1d 100644
--- a/include/linux/resctrl_types.h
+++ b/include/linux/resctrl_types.h
@@ -51,4 +51,6 @@ enum resctrl_event_id {
 	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
 };
 
+#define QOS_L3_NUM_EVENTS (QOS_L3_MBM_LOCAL_EVENT_ID + 1)
+
 #endif /* __LINUX_RESCTRL_TYPES_H */
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 011bf67a1866..25fb4121afa5 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -42,7 +42,7 @@ DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
 
 extern bool rdt_alloc_capable;
 extern bool rdt_mon_capable;
-extern unsigned int rdt_mon_features;
+extern unsigned long rdt_mon_features;
 
 DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
 DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
@@ -97,6 +97,12 @@ static inline bool resctrl_arch_is_mbm_local_enabled(void)
 	return (rdt_mon_features & (1 << QOS_L3_MBM_LOCAL_EVENT_ID));
 }
 
+static inline bool resctrl_arch_is_mbm_event(int e)
+{
+	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
+		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
+}
+
 /*
  * __resctrl_sched_in() - Writes the task's CLOSid/RMID to IA32_PQR_MSR
  *
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index c44c5b496355..ffba9ac73be1 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -333,15 +333,13 @@ struct rdt_hw_ctrl_domain {
  * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
  *			      a resource for a monitor function
  * @d_resctrl:	Properties exposed to the resctrl file system
- * @arch_mbm_total:	arch private state for MBM total bandwidth
- * @arch_mbm_local:	arch private state for MBM local bandwidth
+ * @arch_mbm_states: arch private state for each MBM event
  *
  * Members of this structure are accessed via helpers that provide abstraction.
  */
 struct rdt_hw_mon_domain {
 	struct rdt_mon_domain		d_resctrl;
-	struct arch_mbm_state		*arch_mbm_total;
-	struct arch_mbm_state		*arch_mbm_local;
+	struct arch_mbm_state		*arch_mbm_states[QOS_L3_NUM_EVENTS];
 };
 
 static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctrl_domain *r)
@@ -504,6 +502,8 @@ void resctrl_file_fflags_init(const char *config, unsigned long fflags);
 void rdt_staged_configs_clear(void);
 bool closid_allocated(unsigned int closid);
 int resctrl_find_cleanest_closid(void);
+int rdt_lookup_evtid_by_name(char *name);
+char *rdt_event_name(enum resctrl_event_id evt);
 
 #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
 int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index cf29681d01e0..695c9742212a 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -383,8 +383,8 @@ static void ctrl_domain_free(struct rdt_hw_ctrl_domain *hw_dom)
 
 static void mon_domain_free(struct rdt_hw_mon_domain *hw_dom)
 {
-	kfree(hw_dom->arch_mbm_total);
-	kfree(hw_dom->arch_mbm_local);
+	for (int i = 0; i < QOS_L3_NUM_EVENTS; i++)
+		kfree(hw_dom->arch_mbm_states[i]);
 	kfree(hw_dom);
 }
 
@@ -418,25 +418,23 @@ static int domain_setup_ctrlval(struct rdt_resource *r, struct rdt_ctrl_domain *
  */
 static int arch_domain_mbm_alloc(u32 num_rmid, struct rdt_hw_mon_domain *hw_dom)
 {
-	size_t tsize;
-
-	if (resctrl_arch_is_mbm_total_enabled()) {
-		tsize = sizeof(*hw_dom->arch_mbm_total);
-		hw_dom->arch_mbm_total = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_total)
-			return -ENOMEM;
-	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
-		tsize = sizeof(*hw_dom->arch_mbm_local);
-		hw_dom->arch_mbm_local = kcalloc(num_rmid, tsize, GFP_KERNEL);
-		if (!hw_dom->arch_mbm_local) {
-			kfree(hw_dom->arch_mbm_total);
-			hw_dom->arch_mbm_total = NULL;
-			return -ENOMEM;
-		}
+	size_t tsize = sizeof(struct arch_mbm_state);
+	int evt;
+
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
+		if (!resctrl_arch_is_mbm_event(evt))
+			continue;
+		hw_dom->arch_mbm_states[evt] = kcalloc(num_rmid, tsize, GFP_KERNEL);
+		if (!hw_dom->arch_mbm_states[evt])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	for (evt = 0; evt < QOS_L3_NUM_EVENTS; evt++)
+		kfree(hw_dom->arch_mbm_states[evt]);
+
+	return -ENOMEM;
 }
 
 static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 0a0ac5f6112e..be0652361949 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -545,56 +545,29 @@ ssize_t rdtgroup_mba_mbps_event_write(struct kernfs_open_file *of,
 	}
 	rdt_last_cmd_clear();
 
-	if (!strcmp(buf, "mbm_local_bytes")) {
-		if (resctrl_arch_is_mbm_local_enabled())
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else if (!strcmp(buf, "mbm_total_bytes")) {
-		if (resctrl_arch_is_mbm_total_enabled())
-			rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
-		else
-			ret = -EINVAL;
-	} else {
-		ret = -EINVAL;
-	}
-
-	if (ret)
+	ret = rdt_lookup_evtid_by_name(buf);
+	if (ret < 0)
 		rdt_last_cmd_printf("Unsupported event id '%s'\n", buf);
+	else
+		rdtgrp->mba_mbps_event = ret;
 
 	rdtgroup_kn_unlock(of->kn);
 
-	return ret ?: nbytes;
+	return ret < 0 ? ret : nbytes;
 }
 
 int rdtgroup_mba_mbps_event_show(struct kernfs_open_file *of,
 				 struct seq_file *s, void *v)
 {
 	struct rdtgroup *rdtgrp;
-	int ret = 0;
 
 	rdtgrp = rdtgroup_kn_lock_live(of->kn);
 
-	if (rdtgrp) {
-		switch (rdtgrp->mba_mbps_event) {
-		case QOS_L3_MBM_LOCAL_EVENT_ID:
-			seq_puts(s, "mbm_local_bytes\n");
-			break;
-		case QOS_L3_MBM_TOTAL_EVENT_ID:
-			seq_puts(s, "mbm_total_bytes\n");
-			break;
-		default:
-			pr_warn_once("Bad event %d\n", rdtgrp->mba_mbps_event);
-			ret = -EINVAL;
-			break;
-		}
-	} else {
-		ret = -ENOENT;
-	}
+	seq_printf(s, "%s\n", rdt_event_name(rdtgrp->mba_mbps_event));
 
 	rdtgroup_kn_unlock(of->kn);
 
-	return ret;
+	return 0;
 }
 
 struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index a93ed7d2a160..4f355d3ec2d3 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -84,7 +84,7 @@ bool rdt_mon_capable;
 /*
  * Global to indicate which monitoring events are enabled.
  */
-unsigned int rdt_mon_features;
+unsigned long rdt_mon_features;
 
 /*
  * This is the threshold cache occupancy in bytes at which we will consider an
@@ -253,19 +253,11 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
 						 u32 rmid,
 						 enum resctrl_event_id eventid)
 {
-	switch (eventid) {
-	case QOS_L3_OCCUP_EVENT_ID:
-		return NULL;
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &hw_dom->arch_mbm_total[rmid];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &hw_dom->arch_mbm_local[rmid];
-	}
+	struct arch_mbm_state *state;
 
-	/* Never expect to get here */
-	WARN_ON_ONCE(1);
+	state = hw_dom->arch_mbm_states[eventid];
 
-	return NULL;
+	return state ? &state[rmid] : NULL;
 }
 
 void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
@@ -294,14 +286,14 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
 void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d)
 {
 	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
+	int evt;
 
-	if (resctrl_arch_is_mbm_total_enabled())
-		memset(hw_dom->arch_mbm_total, 0,
-		       sizeof(*hw_dom->arch_mbm_total) * r->num_rmid);
-
-	if (resctrl_arch_is_mbm_local_enabled())
-		memset(hw_dom->arch_mbm_local, 0,
-		       sizeof(*hw_dom->arch_mbm_local) * r->num_rmid);
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
+		if (!hw_dom->arch_mbm_states[evt])
+			continue;
+		memset(hw_dom->arch_mbm_states[evt], 0,
+		       sizeof(struct arch_mbm_state) * r->num_rmid);
+	}
 }
 
 static u64 mbm_overflow_count(u64 prev_msr, u64 cur_msr, unsigned int width)
@@ -579,15 +571,11 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
 				       u32 rmid, enum resctrl_event_id evtid)
 {
 	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
+	struct mbm_state *states;
 
-	switch (evtid) {
-	case QOS_L3_MBM_TOTAL_EVENT_ID:
-		return &d->mbm_total[idx];
-	case QOS_L3_MBM_LOCAL_EVENT_ID:
-		return &d->mbm_local[idx];
-	default:
-		return NULL;
-	}
+	states = d->mbm_states[evtid];
+
+	return states ? &states[idx] : NULL;
 }
 
 static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
@@ -864,15 +852,14 @@ static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *
 static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
 		       u32 closid, u32 rmid)
 {
+	int evt;
+
 	/*
 	 * This is protected from concurrent reads from user as both
 	 * the user and overflow handler hold the global mutex.
 	 */
-	if (resctrl_arch_is_mbm_total_enabled())
-		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_TOTAL_EVENT_ID);
-
-	if (resctrl_arch_is_mbm_local_enabled())
-		mbm_update_one_event(r, d, closid, rmid, QOS_L3_MBM_LOCAL_EVENT_ID);
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
+		mbm_update_one_event(r, d, closid, rmid, evt);
 }
 
 /*
@@ -1075,20 +1062,37 @@ static void dom_data_exit(struct rdt_resource *r)
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-static struct mon_evt llc_occupancy_event = {
-	.name		= "llc_occupancy",
-	.evtid		= QOS_L3_OCCUP_EVENT_ID,
+static struct mon_evt all_events[] = {
+	[QOS_L3_OCCUP_EVENT_ID] = {
+		.name		= "llc_occupancy",
+		.evtid		= QOS_L3_OCCUP_EVENT_ID,
+	},
+	[QOS_L3_MBM_TOTAL_EVENT_ID] = {
+		.name		= "mbm_total_bytes",
+		.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
+	},
+	[QOS_L3_MBM_LOCAL_EVENT_ID] = {
+		.name		= "mbm_local_bytes",
+		.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
+	},
 };
 
-static struct mon_evt mbm_total_event = {
-	.name		= "mbm_total_bytes",
-	.evtid		= QOS_L3_MBM_TOTAL_EVENT_ID,
-};
+int rdt_lookup_evtid_by_name(char *name)
+{
+	int evt;
 
-static struct mon_evt mbm_local_event = {
-	.name		= "mbm_local_bytes",
-	.evtid		= QOS_L3_MBM_LOCAL_EVENT_ID,
-};
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
+		if (!strcmp(name, all_events[evt].name))
+			return evt;
+	return -EINVAL;
+}
+
+char *rdt_event_name(enum resctrl_event_id evt)
+{
+	if (!(rdt_mon_features & BIT(evt)))
+		return NULL;
+	return all_events[evt].name;
+}
 
 /*
  * Initialize the event list for the resource.
@@ -1099,14 +1103,12 @@ static struct mon_evt mbm_local_event = {
  */
 static void l3_mon_evt_init(struct rdt_resource *r)
 {
+	int evt;
+
 	INIT_LIST_HEAD(&r->evt_list);
 
-	if (resctrl_arch_is_llc_occupancy_enabled())
-		list_add_tail(&llc_occupancy_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_total_enabled())
-		list_add_tail(&mbm_total_event.list, &r->evt_list);
-	if (resctrl_arch_is_mbm_local_enabled())
-		list_add_tail(&mbm_local_event.list, &r->evt_list);
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features))
+		list_add_tail(&all_events[evt].list, &r->evt_list);
 }
 
 /*
@@ -1219,12 +1221,12 @@ int __init resctrl_mon_resource_init(void)
 	l3_mon_evt_init(r);
 
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
-		mbm_total_event.configurable = true;
+		all_events[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_total_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
 	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_LOCAL_EVENT_ID)) {
-		mbm_local_event.configurable = true;
+		all_events[QOS_L3_MBM_LOCAL_EVENT_ID].configurable = true;
 		resctrl_file_fflags_init("mbm_local_bytes_config",
 					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index c6274d40b217..3d46551f39f6 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -123,12 +123,6 @@ static bool resctrl_is_mbm_enabled(void)
 		resctrl_arch_is_mbm_local_enabled());
 }
 
-static bool resctrl_is_mbm_event(int e)
-{
-	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
-		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
-}
-
 /*
  * Trivial allocator for CLOSIDs. Since h/w only supports a small number,
  * we can keep a bitmap of free CLOSIDs in a single integer.
@@ -3168,7 +3162,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
 		if (ret)
 			return ret;
 
-		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
+		if (!do_sum && resctrl_arch_is_mbm_event(mevt->evtid))
 			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
 	}
 
@@ -4100,8 +4094,8 @@ static void __init rdtgroup_setup_default(void)
 static void domain_destroy_mon_state(struct rdt_mon_domain *d)
 {
 	bitmap_free(d->rmid_busy_llc);
-	kfree(d->mbm_total);
-	kfree(d->mbm_local);
+	for (int i = 0; i < QOS_L3_NUM_EVENTS; i++)
+		kfree(d->mbm_states[i]);
 }
 
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
@@ -4162,31 +4156,29 @@ static int domain_setup_mon_state(struct rdt_resource *r, struct rdt_mon_domain
 {
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	size_t tsize;
+	int evt;
 
 	if (resctrl_arch_is_llc_occupancy_enabled()) {
 		d->rmid_busy_llc = bitmap_zalloc(idx_limit, GFP_KERNEL);
 		if (!d->rmid_busy_llc)
 			return -ENOMEM;
 	}
-	if (resctrl_arch_is_mbm_total_enabled()) {
-		tsize = sizeof(*d->mbm_total);
-		d->mbm_total = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_total) {
-			bitmap_free(d->rmid_busy_llc);
-			return -ENOMEM;
-		}
-	}
-	if (resctrl_arch_is_mbm_local_enabled()) {
-		tsize = sizeof(*d->mbm_local);
-		d->mbm_local = kcalloc(idx_limit, tsize, GFP_KERNEL);
-		if (!d->mbm_local) {
-			bitmap_free(d->rmid_busy_llc);
-			kfree(d->mbm_total);
-			return -ENOMEM;
-		}
+
+	for_each_set_bit(evt, &rdt_mon_features, sizeof(rdt_mon_features)) {
+		if (!resctrl_arch_is_mbm_event(evt))
+			continue;
+		d->mbm_states[evt] = kcalloc(idx_limit, tsize, GFP_KERNEL);
+		if (!d->mbm_states[evt])
+			goto cleanup;
 	}
 
 	return 0;
+cleanup:
+	bitmap_free(d->rmid_busy_llc);
+	for (evt = 0; evt < QOS_L3_NUM_EVENTS; evt++)
+		kfree(d->mbm_states[evt]);
+
+	return -ENOMEM;
 }
 
 int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
-- 
2.48.1

