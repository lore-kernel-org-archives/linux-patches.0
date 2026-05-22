Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42411376BC6
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477330; cv=none; b=ZQI73gQqnd/DjiFnQgqPYqb/K0LCgIexeGTLLl1kEecIj5ExZ8apRNLqN9ka2zIuJ3adHQzCcRYYotP9i1wVTSjZoUzWisxwgpKCebIjwDuFw6RUL4JytaPdgCT9yLqnYRpZljVqD/o+BxfeqscMpGkhtG5ZANsQpNG006AKJEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477330; c=relaxed/simple;
	bh=DejNb5y7kc25szJUthqObC//f69mjqcatZ0NbQJD3ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMCnSWES/xVoUEKdSPbBrwPeLCTKAYvTvT5prRnXTccat08srfqZfGzWv9oeN+u4nQ4VdYB1zuTXYbIthPQjpLWXECOGJFMZdgr1v5kxNdnMQQOAGu2f2DAMHD3xeY9dR4x18GaKC2axyaYWAO/xpqHDr73FBSizmG59x3j4aN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WF1/9rDI; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WF1/9rDI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477328; x=1811013328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DejNb5y7kc25szJUthqObC//f69mjqcatZ0NbQJD3ck=;
  b=WF1/9rDI5ppsglpZncRq7xT2UCm+OPWZI2+4YXaXW0kBNMlI2iXIIzC8
   mcUbHl1ITLLckVd0F+1PcXDwz6a/QHLSHXd+jAPBAvn6w6zgzFrPTy14N
   H7JeEtoE9u2rOH9lGluhglZGoee+85/TxAxQjB3773OGQJaTXsREKlvQc
   Vmz0eM2GPRLyggf9zwnG874730xigh5C8S1p2HHhFz34BYsO4eduB6Req
   lG1ita5xxj02dBlVqFr8etIoudXXjVOA6TB2NX2a4JnOmuiu7zsaCoYvp
   cGCQsxottcJ4G96ZAUsS1oCikqcYAybJ5Y0GEWNtF9kIGX5qvUutKhxoN
   A==;
X-CSE-ConnectionGUID: qWSMW9q1QqypsjGBn317ew==
X-CSE-MsgGUID: Oj1tECX1To+zuKTcSU8bcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140483"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140483"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
X-CSE-ConnectionGUID: HZOzsb/eRYGNWXUIAAO50g==
X-CSE-MsgGUID: yXuMAaFATK2UBhutWHG4Og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336474"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 6/9] fs/resctrl: Fix pseudo-locking lifetime handling
Date: Fri, 22 May 2026 12:15:10 -0700
Message-ID: <e785356d9a30047b3a917d78f09b338f0cd2f109.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rmdir_all_sub() implements resctrl unmount teardown by iterating through
all resource groups. Memory cleanup is coordinated by deferring resource
group removal to rdtgroup_kn_put() if there are lingering waiters.

A couple of issues exist in the pseudo-locking lifetime management:

1) rmdir_all_sub() unconditionally invokes rdtgroup_pseudo_lock_remove() on
   pseudo-locked groups, even if active references remain. When the deferred
   rdtgroup_kn_put() is finally executed by the last waiter, it erroneously
   calls rdtgroup_pseudo_lock_remove() a second time, resulting in a
   NULL-pointer dereference as the pseudo-lock structures have already been
   freed.

2) pseudo_lock_dev_release() drops the waitcount reference but misses
   checking if the resource group has been flagged for deletion. If
   resctrl is unmounted while a pseudo-lock device file is open,
   rmdir_all_sub() will observe the active waitcount and defer the deletion
   to the last reference holder. When the device file descriptor is
   subsequently closed, pseudo_lock_dev_release() decrements the
   waitcount without inspecting nor acting on the RDT_DELETED flag.
   Neither the pseudo-lock memory cleanup nor the final resource group
   removal are executed.

3) rdtgroup_pseudo_lock_remove() calls debugfs_remove_recursive() that
   will wait for any existing debugfs users to complete before it can
   do cleanup. Since the pseudo-locking debugfs handlers take
   rdtgroup_mutex it is required that this debugfs_remove_recursive()
   is not called with rdtgroup_mutex held, yet rmdir_all_sub() does so.

4) A pseudo-locked group's RMID is freed when it is created. On unmount
   rmdir_all_sub() unconditionally frees all RMID of all groups, resulting
   in a double-free of the pseudo-locked group's RMID. The additional
   consequence of this is that the original free results in the
   pseudo-locked group's RMID being added to the rmid_free_lru linked
   list and the second free then attempts to add the same RMID entry to
   the rmid_free_lru again.

Fix pseudo-locking lifetime handling by separating the pseudo-locking
infrastructure removal from the pseudo-locking region memory teardown, and
splitting pseudo-locking infrastructure removal into what needs rdtgroup_mutex
protection and what does not. With this separation an unmount of resctrl
fs can proceed to remove the pseudo-locking infrastructure of a pseudo-locked
region since the global infrastructure it depends on will be removed soon
after (resctrl_unmount()-> resctrl_fs_teardown()->rdt_pseudo_lock_release()).
Any active users of the pseudo-locked region via an open file can complete
safely afterwards and only need to do the pseudo-locked region specific
memory teardown.

The new RDT_DELETED_PLR resource group flag communicates to waiters whether
the pseudo-locked region's infrastructure has already been removed.

Fixes: 746e08590b86 ("x86/intel_rdt: Create character device exposing pseudo-locked region")
Fixes: e0bdfe8e36f3 ("x86/intel_rdt: Support creation/removal of pseudo-locked region")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=3
Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=1
Assisted-by: GitHub_Copilot:gemini-3.1-pro
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- New patch
---
 fs/resctrl/internal.h    | 12 +++++++++++
 fs/resctrl/pseudo_lock.c | 44 +++++++++++++++++++++++++++++++++-------
 fs/resctrl/rdtgroup.c    | 35 ++++++++++++++++++--------------
 3 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
index 48af75b9dc85..e7e415ee7766 100644
--- a/fs/resctrl/internal.h
+++ b/fs/resctrl/internal.h
@@ -234,6 +234,15 @@ struct rdtgroup {
 
 /* rdtgroup.flags */
 #define	RDT_DELETED		1
+/*
+ * RDT_DELETED_PLR is set when the pseudo-locked group's infrastructure
+ * (its associated device, debugfs files, etc.) has been deleted via
+ * rdtgroup_pseudo_lock_remove(). This can be done while there are
+ * references to the pseudo-locked region since the pseudo-locked region
+ * self is freed separately via pseudo_lock_free() after there are no more
+ * references.
+ */
+#define	RDT_DELETED_PLR		2
 
 /* rftype.flags */
 #define RFTYPE_FLAGS_CPUS_LIST	1
@@ -334,6 +343,7 @@ void rdt_last_cmd_puts(const char *s);
 __printf(1, 2)
 void rdt_last_cmd_printf(const char *fmt, ...);
 
+void rdtgroup_remove(struct rdtgroup *rdtgrp);
 struct rdtgroup *rdtgroup_kn_lock_live(struct kernfs_node *kn);
 
 void rdtgroup_kn_unlock(struct kernfs_node *kn);
@@ -484,6 +494,7 @@ void rdt_pseudo_lock_release(void);
 int rdtgroup_pseudo_lock_create(struct rdtgroup *rdtgrp);
 
 void rdtgroup_pseudo_lock_remove(struct rdtgroup *rdtgrp);
+void pseudo_lock_free(struct rdtgroup *rdtgrp);
 
 #else
 static inline int rdtgroup_locksetup_enter(struct rdtgroup *rdtgrp)
@@ -514,6 +525,7 @@ static inline int rdtgroup_pseudo_lock_create(struct rdtgroup *rdtgrp)
 }
 
 static inline void rdtgroup_pseudo_lock_remove(struct rdtgroup *rdtgrp) { }
+static inline void pseudo_lock_free(struct rdtgroup *rdtgrp) { }
 #endif /* CONFIG_RESCTRL_FS_PSEUDO_LOCK */
 
 #endif /* _FS_RESCTRL_INTERNAL_H */
diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index d1cb0986006e..f9d180eb699e 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -333,8 +333,10 @@ static int pseudo_lock_region_alloc(struct pseudo_lock_region *plr)
  *
  * Return: void
  */
-static void pseudo_lock_free(struct rdtgroup *rdtgrp)
+void pseudo_lock_free(struct rdtgroup *rdtgrp)
 {
+	if (!rdtgrp->plr)
+		return;
 	pseudo_lock_region_clear(rdtgrp->plr);
 	kfree(rdtgrp->plr);
 	rdtgrp->plr = NULL;
@@ -928,22 +930,37 @@ void rdtgroup_pseudo_lock_remove(struct rdtgroup *rdtgrp)
 {
 	struct pseudo_lock_region *plr = rdtgrp->plr;
 
+	lockdep_assert_held(&rdtgroup_mutex);
+
+	if (rdtgrp->mode != RDT_MODE_PSEUDO_LOCKSETUP &&
+	    rdtgrp->mode != RDT_MODE_PSEUDO_LOCKED)
+		return;
+
+	if (rdtgrp->flags & RDT_DELETED_PLR)
+		return;
+
+	rdtgrp->flags |= RDT_DELETED_PLR;
+
 	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP) {
 		/*
 		 * Default group cannot be a pseudo-locked region so we can
 		 * free closid here.
 		 */
 		closid_free(rdtgrp->closid);
-		goto free;
+		return;
 	}
 
 	pseudo_lock_cstates_relax(plr);
-	debugfs_remove_recursive(rdtgrp->plr->debugfs_dir);
+	/*
+	 * Drop rdtgroup_mutex to enable debugfs_remove_recursive() to
+	 * complete as it waits for active users that may be blocked
+	 * waiting on rdtgroup_mutex to complete.
+	 */
+	mutex_unlock(&rdtgroup_mutex);
+	debugfs_remove_recursive(plr->debugfs_dir);
+	mutex_lock(&rdtgroup_mutex);
 	device_destroy(&pseudo_lock_class, MKDEV(pseudo_lock_major, plr->minor));
 	pseudo_lock_minor_release(plr->minor);
-
-free:
-	pseudo_lock_free(rdtgrp);
 }
 
 static int pseudo_lock_dev_open(struct inode *inode, struct file *filp)
@@ -971,6 +988,7 @@ static int pseudo_lock_dev_open(struct inode *inode, struct file *filp)
 static int pseudo_lock_dev_release(struct inode *inode, struct file *filp)
 {
 	struct rdtgroup *rdtgrp;
+	bool needs_free = false;
 
 	mutex_lock(&rdtgroup_mutex);
 	rdtgrp = filp->private_data;
@@ -980,8 +998,20 @@ static int pseudo_lock_dev_release(struct inode *inode, struct file *filp)
 		return -ENODEV;
 	}
 	filp->private_data = NULL;
-	atomic_dec(&rdtgrp->waitcount);
+
+	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
+	    (rdtgrp->flags & RDT_DELETED)) {
+		needs_free = true;
+		rdtgroup_pseudo_lock_remove(rdtgrp);
+	}
+
 	mutex_unlock(&rdtgroup_mutex);
+
+	if (needs_free) {
+		pseudo_lock_free(rdtgrp);
+		rdtgroup_remove(rdtgrp);
+	}
+
 	return 0;
 }
 
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 6418395877cf..a8b4ac7dd823 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -595,7 +595,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
  *
  * Return: void
  */
-static void rdtgroup_remove(struct rdtgroup *rdtgrp)
+void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
 	if (rdtgrp == &rdtgroup_default)
 		return;
@@ -2606,23 +2606,24 @@ static void rdtgroup_kn_get(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 
 static void rdtgroup_kn_put(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 {
-	bool needs_free;
+	bool needs_free = false;
 
 	if (!atomic_dec_and_mutex_lock(&rdtgrp->waitcount, &rdtgroup_mutex)) {
 		kernfs_unbreak_active_protection(kn);
 		return;
 	}
 
-	needs_free = rdtgrp->flags & RDT_DELETED;
+	if (rdtgrp->flags & RDT_DELETED) {
+		needs_free = true;
+		rdtgroup_pseudo_lock_remove(rdtgrp);
+	}
 
 	mutex_unlock(&rdtgroup_mutex);
 
 	kernfs_unbreak_active_protection(kn);
 
 	if (needs_free) {
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
+		pseudo_lock_free(rdtgrp);
 		rdtgroup_remove(rdtgrp);
 	}
 }
@@ -2885,10 +2886,6 @@ static void rmdir_all_sub(void)
 		if (rdtgrp == &rdtgroup_default)
 			continue;
 
-		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
-		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
-			rdtgroup_pseudo_lock_remove(rdtgrp);
-
 		/*
 		 * Give any CPUs back to the default group. We cannot copy
 		 * cpu_online_mask because a CPU might have executed the
@@ -2899,15 +2896,23 @@ static void rmdir_all_sub(void)
 
 		rdtgroup_unassign_cntrs(rdtgrp);
 
-		free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
-
 		kernfs_remove(rdtgrp->kn);
 		list_del(&rdtgrp->rdtgroup_list);
 
-		if (atomic_read(&rdtgrp->waitcount) != 0)
-			rdtgrp->flags = RDT_DELETED;
-		else
+		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
+		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
+			rdtgroup_pseudo_lock_remove(rdtgrp);
+		} else {
+			/* Pseudo-locked group's RMID is freed during setup. */
+			free_rmid(rdtgrp->closid, rdtgrp->mon.rmid);
+		}
+
+		if (atomic_read(&rdtgrp->waitcount) != 0) {
+			rdtgrp->flags |= RDT_DELETED;
+		} else {
+			pseudo_lock_free(rdtgrp);
 			rdtgroup_remove(rdtgrp);
+		}
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
-- 
2.50.1

