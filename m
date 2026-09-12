Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBE834252D;
	Sat, 12 Sep 2026 07:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198410; cv=none; b=nqlTLOfUo85tdaO99+fpnpmMbz5+B8OnTXFTTL6pK6D8ohDY+S3JV4EUiGwiWutpQrJTRvujBFSvjV33FYUoKN6YPCTN7L3D6hbpMjmDDSuZBwpDmVsxEzvswmG2rDVmwyryC/dS9WkxDd8flqd5mVecAlASEheTA6IY4pOOIh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198410; c=relaxed/simple;
	bh=sPRO6ZqUNoZ2yxeZp7FAPvySEDWW9TZC9B9LKJnfBIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRTJiu0tUeZLaZQGCn0VVPJgkuz7X3zqvZugTRwPAKucONm1EHK3hzx+Iwzr/w+2q8wdrpEaP/fiOORNsUr1p+q1soDOBru6iCRG6i0RZvdCo0X0qbxnTMRntMznTWlJ/SXBePHlEsaJ2t+9LKMtGpxMc7P6oInAdkkFO249VIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOZcTy2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOZcTy2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5921F000FF;
	Sat, 12 Sep 2026 07:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198408;
	bh=Dpq4cC8e5z1Gegpk7ALLcpwBELPt6dA18igxXb6gEGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOZcTy2F5RU1a7L8Dnkv2dW3q0GK36QFYuqCU3AGvfO39lbzG0ywab4jZFsVZovgi
	 JW4MWz5swXbcFev2jvAtp8QyRhS5mha7tTgDPVaw/tLDIwE1fWhH+duT/N+NPyZjNy
	 DYyMGbWGTrZG6To7lQ/CSUQceTcw+1zmAD20v/Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0375/1815] fs/resctrl: Fix UAF from worker threads when domains are removed
Date: Sat, 12 Sep 2026 08:35:25 +0200
Message-ID: <20260912065657.705250731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit 2566b5cd6a275c124e8f154fef6e815f92ec8d5c ]

The mbm_handle_overflow() and cqm_handle_limbo() workers read event counters
and may sleep while doing so. They are scheduled via delayed_work embedded in
struct rdt_l3_mon_domain. Architecture allocates and frees these domains from
CPU hotplug callbacks under cpus_write_lock(), and the workers acquire
cpus_read_lock() to keep the domain alive across their access.

A use-after-free can occur when a worker is blocked waiting for
cpus_read_lock() while the hotplug core holds cpus_write_lock(): the
architecture frees the rdt_l3_mon_domain that contains the worker's
work_struct. When the worker unblocks, the container_of() it performs on the
embedded work pointer dereferences freed memory.

Drop cpus_read_lock() from the workers and instead drain pending and in-flight
work synchronously before the architecture can free the domain.  Since
architecture offlines the domain under cpus_write_lock() after it has been
unlinked from the RCU list and a grace period has elapsed, no new work can be
scheduled. The cancel only needs to wait out existing work.  Drop
rdtgroup_mutex during CPU offline around cancel_delayed_work_sync() so that
a worker waiting on the mutex can complete before re-pinning the work on
a different CPU.

When offlining a CPU the architecture may iterate over resources in any order.
For example, the MBA control domain may be offlined before or after
a corresponding L3 monitor domain. Ensure that resctrl fs cancels the workers
no matter what order the architecture offlines the domains.

Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
Closes: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com # [1]
Reported-by: Sashiko <sashiko-bot@kernel.org>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/3f0e0752deb3421606dfc4600f0ab3a4ae098cd7.1783963505.git.reinette.chatre@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/resctrl/monitor.c  | 60 +++++++++++++++++++++++++++++++++++--------
 fs/resctrl/rdtgroup.c | 52 +++++++++++++++++++++++++++++++++----
 2 files changed, 97 insertions(+), 15 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index a932a1fea8182..723ba366324a8 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -628,14 +628,22 @@ void mon_event_count(void *info)
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
@@ -696,7 +704,8 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_l3_mon_domain *dom_m
 	if (WARN_ON_ONCE(!pmbm_data))
 		return;
 
-	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
+	guard(rcu)();
+	dom_mba = get_sc_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
 	if (!dom_mba) {
 		pr_warn_once("Failure to get domain for MBA update\n");
 		return;
@@ -799,11 +808,25 @@ void cqm_handle_limbo(struct work_struct *work)
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
@@ -813,8 +836,8 @@ void cqm_handle_limbo(struct work_struct *work)
 					 delay);
 	}
 
+out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
@@ -846,7 +869,10 @@ void mbm_handle_overflow(struct work_struct *work)
 	struct list_head *head;
 	struct rdt_resource *r;
 
-	cpus_read_lock();
+	/*
+	 * Safe to run without CPU hotplug lock. Work is guaranteed to be
+	 * canceled before the domain structure is removed.
+	 */
 	mutex_lock(&rdtgroup_mutex);
 
 	/*
@@ -856,9 +882,24 @@ void mbm_handle_overflow(struct work_struct *work)
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
 
@@ -880,7 +921,6 @@ void mbm_handle_overflow(struct work_struct *work)
 
 out_unlock:
 	mutex_unlock(&rdtgroup_mutex);
-	cpus_read_unlock();
 }
 
 /**
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ad280dca301e9..11c88d593f1ef 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -4342,6 +4342,29 @@ static void domain_destroy_l3_mon_state(struct rdt_l3_mon_domain *d)
 
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
@@ -4354,6 +4377,24 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
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
@@ -4370,8 +4411,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		goto out_unlock;
 
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
-	if (resctrl_is_mbm_enabled())
-		cancel_delayed_work(&d->mbm_over);
 	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
 		/*
 		 * When a package is going down, forcefully
@@ -4382,7 +4421,6 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *h
 		 * package never comes back.
 		 */
 		__check_limbo(d, true);
-		cancel_delayed_work(&d->cqm_limbo);
 	}
 
 	domain_destroy_l3_mon_state(d);
@@ -4563,12 +4601,16 @@ void resctrl_offline_cpu(unsigned int cpu)
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
2.53.0



