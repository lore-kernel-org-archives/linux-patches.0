Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B4534D915
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964435; cv=none; b=uf6FcBypxypyOJpQdI28FEjUOmTruY9ibtaWw8NdXC81RXdN2SguTCb3eJ0G/AnP8eYhuLyrKXYX5qR4biXwvniz3Bm7g7esZjYisJsXb3efkjtB39c4mWK1XfcSx7WfPl+JsaVQNbaIY1Yr3+NcGIDddOt9Fu6pRMAxzE9fT3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964435; c=relaxed/simple;
	bh=w5SdYLhUTXyIwo1CoVQ9DTifKbl75szZuCsdWP9BVhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeekx95cbs0Agbcqd0MaOzobMS7Aba4eDfTSRmjG3RM756lL9HSIAqfUoON2Pd2Bn/y/c09axF97iWoE1RhmexYZBLekUqZG4qXxB8pqIeMwSRtV+DMQi77BKiGYacueQljJcQpDy+s3Znh9eR8GB0Oe9UrehiNEmRHkO6JZnlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjdYTHbz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjdYTHbz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964431; x=1815500431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w5SdYLhUTXyIwo1CoVQ9DTifKbl75szZuCsdWP9BVhs=;
  b=VjdYTHbzcrUOtnanoGh0B6Kt8BRWxSC738K5AMw7jdPXSgN6xVLCD13Y
   OLWngdulOQGX0D9/B299Fu4txjMi1MGzknF8mrMC0zNr0XgzF1+S8g5pn
   aG49OH3ew5itWaghtcDdO/HeYR1+8aCfHF/2qUOp4ieGll4We2Mr1Sl+g
   UnZ9eY+IO9bfp78Z48D41POV8CShsQQRXdnAmaZqinFh8Ql+ZbmJ3TM9G
   X0OzYkUbU8IKgI7iqApKAsy9exN0r1lfO/+muv1CStiNL4bCCiMHyxX9h
   p6iFRb0mln0grfmGzVg8kQsOWTibGtFVJmzDv+cK9MHbv2dsvkQ3V1plE
   Q==;
X-CSE-ConnectionGUID: 0bBZCQXHRAqGHRduU9NFmA==
X-CSE-MsgGUID: iMMjYFGDTh+aRnR01fI/qQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375581"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375581"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: 3Wbw4otzT9eYfsvn7Lie7A==
X-CSE-MsgGUID: ROj8yhKfR52eYLzqd9/zbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483900"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:25 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v7 7/7] fs/resctrl: Fix UAF from worker threads when domains are removed
Date: Mon, 13 Jul 2026 10:39:43 -0700
Message-ID: <3f0e0752deb3421606dfc4600f0ab3a4ae098cd7.1783963505.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783963505.git.reinette.chatre@intel.com>
References: <cover.1783963505.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The mbm_handle_overflow() and cqm_handle_limbo() workers read event
counters and may sleep while doing so. They are scheduled via
delayed_work embedded in struct rdt_l3_mon_domain. Architecture allocates
and frees these domains from CPU hotplug callbacks under cpus_write_lock(),
and the workers acquire cpus_read_lock() to keep the domain alive across
their access.

A use-after-free can occur when a worker is blocked waiting for
cpus_read_lock() while the hotplug core holds cpus_write_lock():
the architecture frees the rdt_l3_mon_domain that contains the worker's
work_struct. When the worker unblocks, the container_of() it performs on
the embedded work pointer dereferences freed memory.

Drop cpus_read_lock() from the workers and instead drain pending and
in-flight work synchronously before the architecture can free the domain.
Since architecture offlines the domain under cpus_write_lock() after it has
been unlinked from the RCU list and a grace period has elapsed, no new work
can be scheduled. The cancel only needs to wait out existing work.
Drop rdtgroup_mutex during CPU offline around cancel_delayed_work_sync()
so that a worker waiting on the mutex can complete before re-pinning the
work on a different CPU.

When offlining a CPU the architecture may iterate over resources in any
order. For example, the MBA control domain may be offlined before or
after a corresponding L3 monitor domain. Ensure that resctrl fs cancels
the workers no matter what order the architecture offlines the domains.

Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com # [1]
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v2:
- Rewrite changelog
- v2 attempted to solve the issue by using is_percpu_thread() within the
  worker to learn if CPU worker was running on is going offline. A
  Sashiko (https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=5)
  pointed out that this would not be able to handle the scenario if one
  of the hotplug handlers following the resctrl offline handlers failed.
- Some other fixes attempted that failed:
  - Switch to accessing domain structure in handler via RCU so that CPU
    hotplug lock no longer needed. Use cancel_delayed_work_sync() with
    mutex dropped to cancel worker. Running worker from RCU read-side
    critical section is a problem since the worker needs to be
    able to sleep (mbm_handle_overflow()->mbm_update()->
		    mbm_update_one_event()->resctrl_arch_mon_ctx_alloc()->
		    might_sleep())
  - Adding a reference count to the domain structure to avoid the worker
    needing to take CPU hotplug lock. This ended up being very complicated
    with the architecture needing new APIs to manage the reference count
    which cannot cleanly integrate into MPAM since it uses a single
    architecture domain structure to contain both the control and monitoring
    domain structures. Managing the references across mount, unmount,
    online, offline, as well as worker self exit resulted in several
    asymmetrical and complicated paths that were error prone. Locking also
    proved to be complicated since architecture would need to initiate
    domain free that will need to call back into resctrl that will take
    rdtgroup_mutex which means that references need to be taken/released
    without locking.

Changes since V3:
- Traverse mon_domains list using list_for_each_entry_rcu( ...,
  lockdep_is_cpus_held()) to document how CPU hotplug lock is required
  to be held (via architecture).
- Add snippet in changelog to motivate canceling work in monitor and
  control domain offline handlers.

Changes since V4:
- Add check for empty domain to workers to avoid reading RMID when
  domain's cpu_mask is empty because x86's resctrl_arch_rmid_read()
  depends on there being CPUs in the domain's cpu_mask.
---
 fs/resctrl/monitor.c  | 60 +++++++++++++++++++++++++++++++++++--------
 fs/resctrl/rdtgroup.c | 52 +++++++++++++++++++++++++++++++++----
 2 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 15e3eeddb6df..7340b1d17f17 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -633,14 +633,22 @@ void mon_event_count(void *info)
 		rr->err = 0;
 }
 
-static struct rdt_ctrl_domain *get_ctrl_domain_from_cpu(int cpu,
-							struct rdt_resource *r)
+/*
+ * Find the software controller's ctrl domain that contains @cpu on resource @r.
+ *
+ * Only called from the mbm_over worker via update_mba_bw() where the returned
+ * domain is kept alive by cancel_delayed_work_sync() in
+ * resctrl_offline_ctrl_domain(). This drains this worker and then waits on
+ * rdtgroup_mutex held here before the architecture can free the ctrl domain.
+ *
+ * Context: Call from RCU read-side critical section.
+ */
+static struct rdt_ctrl_domain *get_sc_ctrl_domain_from_cpu(int cpu,
+							   struct rdt_resource *r)
 {
 	struct rdt_ctrl_domain *d;
 
-	lockdep_assert_cpus_held();
-
-	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
+	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list) {
 		/* Find the domain that contains this CPU */
 		if (cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
 			return d;
@@ -701,7 +709,8 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_m
 	if (WARN_ON_ONCE(!pmbm_data))
 		return;
 
-	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
+	guard(rcu)();
+	dom_mba = get_sc_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
 		pr_warn_once("Failure to get domain for MBA update\n");
 		return;
@@ -804,11 +813,25 @@ void cqm_handle_limbo(struct work_struct *work)
 	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
 	struct rdt_l3_mon_domain *d;
 
-	cpus_read_lock();
+	/*
+	 * Safe to run without CPU hotplug lock. Work is guaranteed to be
+	 * canceled before the domain structure is removed.
+	 */
 	mutex_lock(&rdtgroup_mutex);
 
+	/*
+	 * Ensure the worker is dedicated to a CPU as intended and not
+	 * relocated by workqueue subsystem as part of CPU going offline.
+	 */
+	if (!is_percpu_thread())
+		goto out_unlock;
+
 	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
 
+	/* Domain is going offline */
+	if (cpumask_empty(&d->hdr.cpu_mask))
+		goto out_unlock;
+
 	__check_limbo(d, false);
 
 	if (has_busy_rmid(d)) {
@@ -818,8 +841,8 @@ void cqm_handle_limbo(struct work_struct *work)
 					 delay);
 	}
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
@@ -851,7 +874,10 @@ void mbm_handle_overflow(struct work_struct *work)
 	struct list_head *head;
 	struct rdt_resource *r;
 
-	cpus_read_lock();
+	/*
+	 * Safe to run without CPU hotplug lock. Work is guaranteed to be
+	 * canceled before the domain structure is removed.
+	 */
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -861,9 +887,24 @@ void mbm_handle_overflow(struct work_struct *work)
 	if (!resctrl_mounted || !resctrl_arch_mon_capable())
 		goto out_unlock;
 
+	/*
+	 * Ensure the worker is dedicated to a CPU and not relocated by
+	 * workqueue subsystem as part of CPU going offline since reading
+	 * events depend on smp_processor_id(). After passing this check
+	 * smp_processor_id() is valid for entire duration of this worker
+	 * since it runs with rdtgroup_mutex held and the offline handler needs
+	 * rdtgroup_mutex to offline the CPU being run on here.
+	 */
+	if (!is_percpu_thread())
+		goto out_unlock;
+
 	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
 
+	/* Domain is going offline */
+	if (cpumask_empty(&d->hdr.cpu_mask))
+		goto out_unlock;
+
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
 		mbm_update(r, d, prgrp);
 
@@ -885,7 +926,6 @@ void mbm_handle_overflow(struct work_struct *work)
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 2fd68733166c..30df902ea776 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4489,6 +4489,29 @@ static void domain_destroy_l3_mon_state(struct rdt_l3_mon_domain *d)
 
 void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d)
 {
+	/*
+	 * mbm_handle_overflow() may dereference this ctrl domain via
+	 * update_mba_bw()->get_sc_ctrl_domain_from_cpu(). The architecture has
+	 * unlinked the domain from the RCU list and waited a grace period, so
+	 * no new worker iteration can find it; drain any worker that already
+	 * holds a pointer to it before the architecture frees the domain.
+	 *
+	 * Software controller is enabled/disabled on mount/unmount with
+	 * cpus_read_lock() held. Running here with cpus_write_lock() so
+	 * there are no concurrent changes to software controller status.
+	 */
+	if (r->rid == RDT_RESOURCE_MBA && is_mba_sc(r)) {
+		struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
+		struct rdt_l3_mon_domain *mon_d;
+
+		list_for_each_entry_rcu(mon_d, &l3->mon_domains, hdr.list, lockdep_is_cpus_held()) {
+			if (mon_d->hdr.id == d->hdr.id) {
+				cancel_delayed_work_sync(&mon_d->mbm_over);
+				break;
+			}
+		}
+	}
+
 	mutex_lock(&rdtgroup_mutex);
 
 	if (supports_mba_mbps() && r->rid == RDT_RESOURCE_MBA)
@@ -4501,6 +4524,24 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 {
 	struct rdt_l3_mon_domain *d;
 
+	/*
+	 * Called by architecture under CPU hotplug lock as it prepares to remove
+	 * the domain which is guaranteed to be accessible here.
+	 * The domain has been unlinked from the RCU list and a grace period
+	 * has elapsed, so no new worker can be scheduled. Drain any worker that
+	 * is in flight or pending before letting architecture proceed to free
+	 * the domain that has the workers' struct delayed_work embedded.
+	 * Do so before taking rdtgroup_mutex since the workers also acquire it.
+	 */
+	if (r->rid == RDT_RESOURCE_L3 &&
+	    domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
+		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
+		if (resctrl_is_mbm_enabled())
+			cancel_delayed_work_sync(&d->mbm_over);
+		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
+			cancel_delayed_work_sync(&d->cqm_limbo);
+	}
+
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -4517,8 +4558,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4529,7 +4568,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4710,12 +4748,16 @@ void resctrl_offline_cpu(unsigned int cpu)
 	d = get_mon_domain_from_cpu(cpu, l3);
 	if (d) {
 		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
-			cancel_delayed_work(&d->mbm_over);
+			mutex_unlock(&rdtgroup_mutex);
+			cancel_delayed_work_sync(&d->mbm_over);
+			mutex_lock(&rdtgroup_mutex);
 			mbm_setup_overflow_handler(d, 0, cpu);
 		}
 		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
 		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {
-			cancel_delayed_work(&d->cqm_limbo);
+			mutex_unlock(&rdtgroup_mutex);
+			cancel_delayed_work_sync(&d->cqm_limbo);
+			mutex_lock(&rdtgroup_mutex);
 			cqm_setup_limbo_handler(d, 0, cpu);
 		}
 	}
-- 
2.54.0

