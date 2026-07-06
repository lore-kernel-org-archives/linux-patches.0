Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F936F905
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378020; cv=none; b=T0sPXXR3c2PvzOjg+hcEI+03tbQFhtaiH1dM+UR5qZYosu0KoafWbdP3V22llH9jnRpCTMcVVxqyxInVeaV5CJacSlmdnTcQZ9YaR2GMLogl21R0QtBdu/7g3VI8T0j87eBE3pcP7gGYUQU9QciLQtl9wm/O+iAsnZD74Q3O73s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378020; c=relaxed/simple;
	bh=fGERMFmTJ4r2lZdd5ICktYB3zBb6Wxs1jJkPcZOb7vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLME733h8I5ccm/Ne1w5w9bsFGZz8GPdP7B0NR8P4YWWYI4+A5/8Z5cVVGpaNnWGDx/v2JwUHbh9ImLmf4VvLABw3fCFlyPAUcW1EPpYbhYB4wtHgwljmGA52NUxJWS5w79q4ONcbO+TMgcM1rtbkikg2/WDJ5L0nyIgx1t+wSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QYqWh7Pb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QYqWh7Pb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783378018; x=1814914018;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fGERMFmTJ4r2lZdd5ICktYB3zBb6Wxs1jJkPcZOb7vY=;
  b=QYqWh7PbXVtJlL6KnhvsIoHEMxDMLruVnHvfwJaIz1AuRsRkhKdDQNYN
   /VZ6PZtU89LXRSnnXbml2FCNHTyVC656/VUeqoXUhTK3tqys6sDA7sVOD
   BjK05SnkfBacIPgOnXOQH2mZWbL9K9Off4eI9wlH6qVlQDCl+4xgWfYSh
   OcU8lMYsTAW1bfutUiKArBQWCZ/MIDAlPzBxUVtr2xoU17f6xZUM3lEu1
   p1yt1IWT+LuQ2kufznHb+oKg9I1IPFZfw6EZkhhqz4tE+uG1uCtnBXFRi
   Uf8jy5+Kfo3McoDJz/ng/4cCWiJyxw7OeanJlyM5a5YN7MjxSwmzkAVjp
   Q==;
X-CSE-ConnectionGUID: Gsv1NveXR1yCPlMe3QKoiA==
X-CSE-MsgGUID: wNJ5QPM8SKK8GoKs/5XbYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401564"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401564"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:42 -0700
X-CSE-ConnectionGUID: fxAlXkFDRh+oK6o23RjR/g==
X-CSE-MsgGUID: QADyxn9SRIS3FsSf+v+4UA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:42 -0700
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
Subject: [PATCH v6 10/10] fs/resctrl: Fix UAF from worker threads when domains are removed
Date: Mon,  6 Jul 2026 15:46:30 -0700
Message-ID: <4c88e01e29df638d9ecad71b2ee3b411e24067bd.1783377598.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783377598.git.reinette.chatre@intel.com>
References: <cover.1783377598.git.reinette.chatre@intel.com>
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
index 9f998e394911..b5fb59d0e035 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4491,6 +4491,29 @@ static void domain_destroy_l3_mon_state(struct rdt_l3_mon_domain *d)
 
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
@@ -4503,6 +4526,24 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
@@ -4519,8 +4560,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4531,7 +4570,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4712,12 +4750,16 @@ void resctrl_offline_cpu(unsigned int cpu)
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

