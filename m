Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D838F25DAF9;
	Thu, 17 Apr 2025 18:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915124; cv=none; b=UZlaDp3446AY81ekfHUWkYZn5vsUWB3yWxxG8sOyDhZft+mhSFRwh+TVKMXfluIfOyJb8FvAdd3M9s186VFIsg4+R/MaNZVjm93w+Z3G1/NnqwHo/2hdE2O4Nv0zNHv01rQm1qhA88ZR0UtnqEpSUlNr5Kt1K1p3vQrxHjPaOVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915124; c=relaxed/simple;
	bh=EJb0wmuMkzoPnle7+K0Sl7kjRqlCLHI+W5ELIz15Ufs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItiJv/TIfSJy3rL6Tqp2TCYykmi93EnGTrvOksYUoisgIzv2qgMuBAV7SOpYUoHF5l5E1rj0dfx5G0Y3u6/KuROvgqs6mqNFg8QsnZi4yD/mw4xt75B7FFcGed1iq7d0U5f75CUucirWWG0cWuGXArO/8KqTRjpgH0E/3fnKmB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPJ9fRLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPJ9fRLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1D2C4CEE4;
	Thu, 17 Apr 2025 18:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915124;
	bh=EJb0wmuMkzoPnle7+K0Sl7kjRqlCLHI+W5ELIz15Ufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPJ9fRLwNbWY1da0D9OZ401vg9BnCK/2vRJeNlQQjzKdCukcmZZKgbpyaYfFDnho/
	 PRMGSys6hiSKyLHQdsJmkyv/xO1HqPFStDa9fLNPw+X4cMV/6P51iZEbrBQx6gnCYn
	 blEgJMe+zr1NzNU5g/dx1lxp0VK3F5DK/v4Z7Eog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/393] cgroup/cpuset: Further optimize code if CONFIG_CPUSETS_V1 not set
Date: Thu, 17 Apr 2025 19:46:55 +0200
Message-ID: <20250417175107.825490364@linuxfoundation.org>
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

[ Upstream commit c4c9cebe2fb9cdc73e55513de7af7a4f50260e88 ]

Currently the cpuset code uses group_subsys_on_dfl() to check if we
are running with cgroup v2. If CONFIG_CPUSETS_V1 isn't set, there is
really no need to do this check and we can optimize out some of the
unneeded v1 specific code paths. Introduce a new cpuset_v2() and use it
to replace the cgroup_subsys_on_dfl() check to further optimize the
code.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: a22b3d54de94 ("cgroup/cpuset: Fix race between newly created partition and dying one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7ac2a634128b3..07ea3a563150b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -293,6 +293,12 @@ static inline void dec_attach_in_progress(struct cpuset *cs)
 	mutex_unlock(&cpuset_mutex);
 }
 
+static inline bool cpuset_v2(void)
+{
+	return !IS_ENABLED(CONFIG_CPUSETS_V1) ||
+		cgroup_subsys_on_dfl(cpuset_cgrp_subsys);
+}
+
 /*
  * Cgroup v2 behavior is used on the "cpus" and "mems" control files when
  * on default hierarchy or when the cpuset_v2_mode flag is set by mounting
@@ -303,7 +309,7 @@ static inline void dec_attach_in_progress(struct cpuset *cs)
  */
 static inline bool is_in_v2_mode(void)
 {
-	return cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+	return cpuset_v2() ||
 	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
 }
 
@@ -738,7 +744,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	int nslot;		/* next empty doms[] struct cpumask slot */
 	struct cgroup_subsys_state *pos_css;
 	bool root_load_balance = is_sched_load_balance(&top_cpuset);
-	bool cgrpv2 = cgroup_subsys_on_dfl(cpuset_cgrp_subsys);
+	bool cgrpv2 = cpuset_v2();
 	int nslot_update;
 
 	doms = NULL;
@@ -1206,7 +1212,7 @@ static void reset_partition_data(struct cpuset *cs)
 {
 	struct cpuset *parent = parent_cs(cs);
 
-	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+	if (!cpuset_v2())
 		return;
 
 	lockdep_assert_held(&callback_lock);
@@ -2035,7 +2041,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 */
 		if (!cp->partition_root_state && !force &&
 		    cpumask_equal(tmp->new_cpus, cp->effective_cpus) &&
-		    (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+		    (!cpuset_v2() ||
 		    (is_sched_load_balance(parent) == is_sched_load_balance(cp)))) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
@@ -2109,8 +2115,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * from parent if current cpuset isn't a valid partition root
 		 * and their load balance states differ.
 		 */
-		if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
-		    !is_partition_valid(cp) &&
+		if (cpuset_v2() && !is_partition_valid(cp) &&
 		    (is_sched_load_balance(parent) != is_sched_load_balance(cp))) {
 			if (is_sched_load_balance(parent))
 				set_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
@@ -2126,8 +2131,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
 		    is_sched_load_balance(cp) &&
-		   (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
-		    is_partition_valid(cp)))
+		   (!cpuset_v2() || is_partition_valid(cp)))
 			need_rebuild_sched_domains = true;
 
 		rcu_read_lock();
@@ -2264,7 +2268,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 
 	retval = validate_change(cs, trialcs);
 
-	if ((retval == -EINVAL) && cgroup_subsys_on_dfl(cpuset_cgrp_subsys)) {
+	if ((retval == -EINVAL) && cpuset_v2()) {
 		struct cgroup_subsys_state *css;
 		struct cpuset *cp;
 
@@ -2756,8 +2760,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed) {
-		if (!IS_ENABLED(CONFIG_CPUSETS_V1) ||
-		    cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+		if (cpuset_v2())
 			cpuset_force_rebuild();
 		else
 			rebuild_sched_domains_locked();
@@ -2943,8 +2946,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 		 * migration permission derives from hierarchy ownership in
 		 * cgroup_procs_write_permission()).
 		 */
-		if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
-		    (cpus_updated || mems_updated)) {
+		if (!cpuset_v2() || (cpus_updated || mems_updated)) {
 			ret = security_task_setscheduler(task);
 			if (ret)
 				goto out_unlock;
@@ -3058,8 +3060,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * in effective cpus and mems. In that case, we can optimize out
 	 * by skipping the task iteration and update.
 	 */
-	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
-	    !cpus_updated && !mems_updated) {
+	if (cpuset_v2() && !cpus_updated && !mems_updated) {
 		cpuset_attach_nodemask_to = cs->effective_mems;
 		goto out;
 	}
@@ -3384,7 +3385,7 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 	INIT_LIST_HEAD(&cs->remote_sibling);
 
 	/* Set CS_MEMORY_MIGRATE for default hierarchy */
-	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys))
+	if (cpuset_v2())
 		__set_bit(CS_MEMORY_MIGRATE, &cs->flags);
 
 	return &cs->css;
@@ -3411,8 +3412,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	/*
 	 * For v2, clear CS_SCHED_LOAD_BALANCE if parent is isolated
 	 */
-	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
-	    !is_sched_load_balance(parent))
+	if (cpuset_v2() && !is_sched_load_balance(parent))
 		clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 
 	cpuset_inc();
@@ -3482,8 +3482,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	if (is_partition_valid(cs))
 		update_prstate(cs, 0);
 
-	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
-	    is_sched_load_balance(cs))
+	if (!cpuset_v2() && is_sched_load_balance(cs))
 		cpuset_update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	cpuset_dec();
-- 
2.39.5



