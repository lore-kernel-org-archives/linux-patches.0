Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED23B31F9A3
	for <patches@lists.linux.dev>; Fri,  1 May 2026 21:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777671381; cv=none; b=GBQPIJwcZ/ZgKZ9yNfc6fldfeDmi9NrCA9EsTn7i5PNqH2muvuuVpMvPw1KRNnFvF06cPrGUFSwI0/5B0C6AoFTv88vZti1lyPg55q/FPP18jDA+7zbCIPR095Wt2dcgSSg27/AqOkmdyiUFhJt5Rf3Glj1Y9dPoqq7cpUxZVgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777671381; c=relaxed/simple;
	bh=g870jxe0uzIT6MVe48utoxZZQMBkbyKmBC9T+BZ++jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ImcqCa5O0BsoAnjTXcAILdNHMls5l43q5FWXOYZkCWoIO+1lb46oUNEE+qis7w9nsZMtURtZHTFBAU0Sn3vBod02NDCOsVVSCG9ABfdBJchaGm5i+Wj+Zx/aGPHVdiQYNn3iVFYUhFLM3CoAeWp6EAZNCcDTD2QVT3sOzSdb07Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=isJJSQ86; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="isJJSQ86"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777671380; x=1809207380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g870jxe0uzIT6MVe48utoxZZQMBkbyKmBC9T+BZ++jQ=;
  b=isJJSQ86sMEWD/ultJDMs9uyqUQyo/N/2whik2/jPKStnQ1WFto4p+jo
   ACltfwDwS2o3LUcK4P9g0XtzrXjwRTXYJGjcfbc+tP4yGG44Elmj/1HWp
   FHJK+bgAT4nA0NQfWw4muaeMlFjWt8HnklgYBPztYWahdRDtIpwNXUHas
   fMsV78yDsXvX/3ZXzrlp/1z0xEun8RhlHohN7j0SYi2jsqihjF4WdvzOB
   BAfrk56g6RCRSm/gbqDTwT0Rpa+SSDDn8d9eRXnoChGRkx2eKR2ebh6LL
   m9kuKrNs8E6ExWHsfQMn/UgTzCRd3HETl2x3oAmtul/+R8W0mCncfiK7V
   w==;
X-CSE-ConnectionGUID: FQ6Umo5HRLuCwUJRxesc/w==
X-CSE-MsgGUID: 6oq4pG5EQSqOhlYNcbsHhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="104084692"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="104084692"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 14:36:20 -0700
X-CSE-ConnectionGUID: iujQy4F0QIuWEI6jkn9O9Q==
X-CSE-MsgGUID: 1ZsobNbmQ9Cal336nawGBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="258574195"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.222.155])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 14:36:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] fs/resctrl: Fix use-after-free in resctrl_offline_mon_domain()
Date: Fri,  1 May 2026 14:36:11 -0700
Message-ID: <20260501213611.25600-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko noticed[1] a user-after-free in the resctrl worker thread code.

resctrl_offline_mon_domain() acquires rdtgroup_mutex and calls
cancel_delayed_work() (non-synchronous) on the per-domain mbm_over and
cqm_limbo delayed_work items, then calls domain_destroy_l3_mon_state()
which frees d->rmid_busy_llc and d->mbm_states[]. After it returns, the
caller (e.g. domain_remove_cpu_mon() in arch/x86 or the mpam equivalent)
deletes the domain from its list and frees the domain itself.

cancel_delayed_work() does not wait for a handler that is already
running. mbm_handle_overflow() and cqm_handle_limbo() each acquire
rdtgroup_mutex before touching the domain, so a handler that started
just before resctrl_offline_mon_domain() runs will block on the mutex.
When resctrl_offline_mon_domain() drops the mutex, the handler wakes
up with a stale 'd' obtained via container_of() and dereferences memory
that has just been freed.

Drain the handlers with cancel_delayed_work_sync() so no handler can be
running or pending against the domain when its state is freed:

  - Add an 'offlining' flag to struct rdt_l3_mon_domain. Under
    rdtgroup_mutex, resctrl_offline_mon_domain() sets it before
    dropping the mutex; the handlers test it after acquiring the
    mutex and exit without rescheduling. This guarantees that
    cancel_delayed_work_sync() does not race with the handler
    re-arming itself.

  - Drop cpus_read_lock() from mbm_handle_overflow() and
    cqm_handle_limbo(). resctrl_offline_mon_domain() can be invoked
    from a CPU hotplug callback that holds the hotplug write lock;
    a handler blocked on cpus_read_lock() in that window would
    deadlock cancel_delayed_work_sync(). The data the handlers
    examine is protected by rdtgroup_mutex, and
    schedule_delayed_work_on() copes with a target CPU that is going
    offline by migrating the work, so the cpus_read_lock() was not
    required for correctness.

  - Restructure resctrl_offline_mon_domain() to: set ->offlining and
    remove the mondata directories under rdtgroup_mutex; drop the
    mutex; cancel_delayed_work_sync() both handlers; reacquire the
    mutex to do the final force __check_limbo() and free the
    per-domain monitor state. The cancel must run with the mutex
    released because the handlers acquire it. Cancel both handlers
    unconditionally on the L3 path (subject to the feature being
    enabled) rather than gating cqm_limbo on has_busy_rmid(): a
    handler may already be executing __check_limbo() with no busy
    RMIDs left, and that invocation must be drained before its 'd'
    is freed.

Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
Assisted-by: Copilot:claude-opus-4.7
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---
 include/linux/resctrl.h |  1 +
 fs/resctrl/monitor.c    | 18 ++++++++++--------
 fs/resctrl/rdtgroup.c   | 38 ++++++++++++++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..73f2638b96ad 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -203,6 +203,7 @@ struct rdt_l3_mon_domain {
 	int				mbm_work_cpu;
 	int				cqm_work_cpu;
 	struct mbm_cntr_cfg		*cntr_cfg;
+	bool				offlining;
 };
 
 /**
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 9fd901c78dc6..e68eec83306e 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -794,11 +794,14 @@ void cqm_handle_limbo(struct work_struct *work)
 	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
 	struct rdt_l3_mon_domain *d;
 
-	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
 	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
 
+	/*  If this domain is being deleted this work no longer needs to run. */
+	if (d->offlining)
+		goto out_unlock;
+
 	__check_limbo(d, false);
 
 	if (has_busy_rmid(d)) {
@@ -808,8 +811,8 @@ void cqm_handle_limbo(struct work_struct *work)
 					 delay);
 	}
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
@@ -841,18 +844,18 @@ void mbm_handle_overflow(struct work_struct *work)
 	struct list_head *head;
 	struct rdt_resource *r;
 
-	cpus_read_lock();
 	mutex_lock(&rdtgroup_mutex);
 
+	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
+
 	/*
-	 * If the filesystem has been unmounted this work no longer needs to
-	 * run.
+	 * If this domain is being deleted, or the filesystem has been
+	 * unmounted this work no longer needs to run.
 	 */
-	if (!resctrl_mounted || !resctrl_arch_mon_capable())
+	if (d->offlining || !resctrl_mounted || !resctrl_arch_mon_capable())
 		goto out_unlock;
 
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
-	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp);
@@ -875,7 +878,6 @@ void mbm_handle_overflow(struct work_struct *work)
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 8544020ef420..c883149fa373 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4323,7 +4323,7 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
 
 void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
 {
-	struct rdt_l3_mon_domain *d;
+	struct rdt_l3_mon_domain *d = NULL;
 
 	mutex_lock(&rdtgroup_mutex);
 
@@ -4341,8 +4341,39 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
+
+	/*
+	 * Tell mbm_handle_overflow() and cqm_handle_limbo() that this
+	 * domain is going away.
+	 */
+	d->offlining = true;
+
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+
+	if (!d)
+		return;
+
+	/*
+	 * Drain any pending or in-flight overflow / limbo handlers before
+	 * freeing per-domain monitor state (and before the caller frees the
+	 * domain itself). cancel_delayed_work_sync() must be called with
+	 * rdtgroup_mutex released because the handlers acquire it; the
+	 * handlers no longer take cpus_read_lock(), so this is safe to call
+	 * from a CPU hotplug callback that holds the hotplug write lock.
+	 *
+	 * Without the synchronous cancel, a handler that was already running
+	 * and blocked on rdtgroup_mutex when this function was entered could
+	 * wake after the mutex is dropped and dereference d->rmid_busy_llc,
+	 * d->mbm_states[] or the domain itself after they have been freed.
+	 */
 	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
+		cancel_delayed_work_sync(&d->mbm_over);
+	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
+		cancel_delayed_work_sync(&d->cqm_limbo);
+
+	mutex_lock(&rdtgroup_mutex);
+
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4353,11 +4384,10 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
-out_unlock:
+
 	mutex_unlock(&rdtgroup_mutex);
 }
 
-- 
2.54.0

