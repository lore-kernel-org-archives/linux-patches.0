Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62C25D8FB;
	Thu, 17 Apr 2025 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915118; cv=none; b=GtSwXLjtXKzvWWi9UPQXEaHXvl/wWo/9VbPX6hfr/EB8D/s2ysyW1v7UuevyUFEF+mQli0zJpg/+KPeY3lH3/aOmVTLKSaUsOG8iBiCTWpcmL+TNWt3tec+Yw0k7Yt/us1FjFJu39GE/aq+NzZW+OtMkNIs3zx2q+SlXRv4ZoYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915118; c=relaxed/simple;
	bh=WpyW3KmE+f7uPhbMDLuCIWw/6Ll1VlX0QzJhXHcjdKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDUmL3JbY0XFaX4sgpjcEF0TgUVagqjxInEQrPq8GD0rBhi2P2B7mQeGNmL73ajUpYk7ZJK6dY9M1OPAmsi2aC1IhimAn7IVnRzFdS0JpY+K5cBIytX09H6YtRIVrsZAlhmSYQieUrvT3Bx6RBZ5BK056te2rrZhsq9SzFDUOBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Mju/cSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Mju/cSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E204C4CEE4;
	Thu, 17 Apr 2025 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915118;
	bh=WpyW3KmE+f7uPhbMDLuCIWw/6Ll1VlX0QzJhXHcjdKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Mju/cSOy/BfVwybpImg2TRB2fqJeCJw0VITqNL6lmZiNHzAju67c7cSRjtPkDtB2
	 +hpwgxzv4uA/zDLGBz14Uww60ztywzA+nsCN2B9wSLWDlKQ8dZ7PAZIZ+MPuc/0/7d
	 c+eyPy0xsl6tX1I31rwaWVXfYY3XmPVzCyvIr8Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/393] cgroup/cpuset: Revert "Allow suppression of sched domain rebuild in update_cpumasks_hier()"
Date: Thu, 17 Apr 2025 19:46:53 +0200
Message-ID: <20250417175107.744681648@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit bcd7012afd7bcd45fcd7a0e2f48e57b273702317 ]

Revert commit 3ae0b773211e ("cgroup/cpuset: Allow suppression of sched
domain rebuild in update_cpumasks_hier()") to allow for an alternative
way to suppress unnecessary rebuild_sched_domains_locked() calls in
update_cpumasks_hier() and elsewhere in a following commit.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: a22b3d54de94 ("cgroup/cpuset: Fix race between newly created partition and dying one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 70fac05123c6d..0012c34bb8601 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1940,12 +1940,6 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	rcu_read_unlock();
 }
 
-/*
- * update_cpumasks_hier() flags
- */
-#define HIER_CHECKALL		0x01	/* Check all cpusets with no skipping */
-#define HIER_NO_SD_REBUILD	0x02	/* Don't rebuild sched domains */
-
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -1960,7 +1954,7 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
  * Called with cpuset_mutex held
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
-				 int flags)
+				 bool force)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
@@ -2025,10 +2019,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * Skip the whole subtree if
 		 * 1) the cpumask remains the same,
 		 * 2) has no partition root state,
-		 * 3) HIER_CHECKALL flag not set, and
+		 * 3) force flag not set, and
 		 * 4) for v2 load balance state same as its parent.
 		 */
-		if (!cp->partition_root_state && !(flags & HIER_CHECKALL) &&
+		if (!cp->partition_root_state && !force &&
 		    cpumask_equal(tmp->new_cpus, cp->effective_cpus) &&
 		    (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
 		    (is_sched_load_balance(parent) == is_sched_load_balance(cp)))) {
@@ -2130,8 +2124,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 	}
 	rcu_read_unlock();
 
-	if (need_rebuild_sched_domains && !(flags & HIER_NO_SD_REBUILD) &&
-	    !force_sd_rebuild)
+	if (need_rebuild_sched_domains && !force_sd_rebuild)
 		rebuild_sched_domains_locked();
 }
 
@@ -2159,9 +2152,7 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 	 * directly.
 	 *
 	 * The update_cpumasks_hier() function may sleep. So we have to
-	 * release the RCU read lock before calling it. HIER_NO_SD_REBUILD
-	 * flag is used to suppress rebuild of sched domains as the callers
-	 * will take care of that.
+	 * release the RCU read lock before calling it.
 	 */
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
@@ -2177,7 +2168,7 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 			continue;
 
 		rcu_read_unlock();
-		update_cpumasks_hier(sibling, tmp, HIER_NO_SD_REBUILD);
+		update_cpumasks_hier(sibling, tmp, false);
 		rcu_read_lock();
 		css_put(&sibling->css);
 	}
@@ -2197,7 +2188,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	struct tmpmasks tmp;
 	struct cpuset *parent = parent_cs(cs);
 	bool invalidate = false;
-	int hier_flags = 0;
+	bool force = false;
 	int old_prs = cs->partition_root_state;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
@@ -2258,8 +2249,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Check all the descendants in update_cpumasks_hier() if
 	 * effective_xcpus is to be changed.
 	 */
-	if (!cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus))
-		hier_flags = HIER_CHECKALL;
+	force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
 
 	retval = validate_change(cs, trialcs);
 
@@ -2327,7 +2317,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_unlock_irq(&callback_lock);
 
 	/* effective_cpus/effective_xcpus will be updated here */
-	update_cpumasks_hier(cs, &tmp, hier_flags);
+	update_cpumasks_hier(cs, &tmp, force);
 
 	/* Update CS_SCHED_LOAD_BALANCE and/or sched_domains, if necessary */
 	if (cs->partition_root_state)
@@ -2352,7 +2342,7 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	struct tmpmasks tmp;
 	struct cpuset *parent = parent_cs(cs);
 	bool invalidate = false;
-	int hier_flags = 0;
+	bool force = false;
 	int old_prs = cs->partition_root_state;
 
 	if (!*buf) {
@@ -2375,8 +2365,7 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * Check all the descendants in update_cpumasks_hier() if
 	 * effective_xcpus is to be changed.
 	 */
-	if (!cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus))
-		hier_flags = HIER_CHECKALL;
+	force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
 
 	retval = validate_change(cs, trialcs);
 	if (retval)
@@ -2429,8 +2418,8 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * of the subtree when it is a valid partition root or effective_xcpus
 	 * is updated.
 	 */
-	if (is_partition_valid(cs) || hier_flags)
-		update_cpumasks_hier(cs, &tmp, hier_flags);
+	if (is_partition_valid(cs) || force)
+		update_cpumasks_hier(cs, &tmp, force);
 
 	/* Update CS_SCHED_LOAD_BALANCE and/or sched_domains, if necessary */
 	if (cs->partition_root_state)
@@ -2871,7 +2860,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	update_unbound_workqueue_cpumask(new_xcpus_state);
 
 	/* Force update if switching back to member */
-	update_cpumasks_hier(cs, &tmpmask, !new_prs ? HIER_CHECKALL : 0);
+	update_cpumasks_hier(cs, &tmpmask, !new_prs);
 
 	/* Update sched domains and load balance flag */
 	update_partition_sd_lb(cs, old_prs);
-- 
2.39.5



