Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CEA3290B0;
	Sat, 12 Sep 2026 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210746; cv=none; b=GUHF4/Xf9G6Xlka5riu1nOzi5TweVn+RQtRZoH7bq9eF1yNc/6tCKEbIJVCXqiTVfBJGh1lJ38AJVI9hFqJyGlCYQBJIErP2L6FIYGlWUVzjyVj1OAgzGku0tAhmaXTDC9hU7dZ1kNmK4oPvF38h2zS6tALPod5AX/MDT5ZvZo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210746; c=relaxed/simple;
	bh=h+VMdQTKoBw9F08SlEJmAbjfrG4Mw3BOmzD2kMtme9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnE5ESmCioFtjz2EG1RK2ibxzmok0I+89kFY1wpMuqjb7raCGOkXXH15NfjjEX0wTyqxsKOab2G8zt4aRfL7OUfaI/dEzUurqYMEZn3K+XxvjF9bJm9JTvITJxLiCbitMc68mhxYdrtyIdZNBBizyMB8v/fgOp7PgeRPnOAfazk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AomGG894; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AomGG894"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414A21F000FF;
	Sat, 12 Sep 2026 10:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210745;
	bh=t0EB65b3VY+v9HBzp9rNfmZc1X3oZlHtmD5Vcsu2fmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AomGG894ke7iEmgclNvNB0e19pPnKJ1DF5tcQDDtpiOoLASCJeFu5OdrZre4i8lMo
	 XetfKcrglg/4vr+vDBSx2m2Q56nREiwNOkXIuzhHC1L63tYMaQ1e4INwl1Fk7D9DbQ
	 fZ+AuaTihVQOmesz0Mg1vrK/n/abMLgmsGrqFf9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Gabriele Monaco <gmonaco@redhat.com>
Subject: [PATCH 6.18 1088/1518] cgroup/cpuset: Fail if isolated and nohz_full dont leave any housekeeping
Date: Sat, 12 Sep 2026 08:54:17 +0200
Message-ID: <20260912065648.064525840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 103b08709e8a59876980a8edddf4e68f3a23e34e ]

Currently the user can set up isolated cpus via cpuset and nohz_full in
such a way that leaves no housekeeping CPU (i.e. no CPU that is neither
domain isolated nor nohz full). This can be a problem for other
subsystems (e.g. the timer wheel imgration).

Prevent this configuration by blocking any assignation that would cause
the union of domain isolated cpus and nohz_full to covers all CPUs.

[longman: Remove isolated_cpus_should_update() and rewrite the checking
 in update_prstate() and update_parent_effective_cpumask()]

Originally-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 26d3a59e0241 ("cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 74 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index feff482e26484..dacfc7481759b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1410,6 +1410,45 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
 	return isolcpus_updated;
 }
 
+/*
+ * isolated_cpus_can_update - check for isolated & nohz_full conflicts
+ * @add_cpus: cpu mask for cpus that are going to be isolated
+ * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
+ * Return: false if there is conflict, true otherwise
+ *
+ * If nohz_full is enabled and we have isolated CPUs, their combination must
+ * still leave housekeeping CPUs.
+ *
+ * TBD: Should consider merging this function into
+ *      prstate_housekeeping_conflict().
+ */
+static bool isolated_cpus_can_update(struct cpumask *add_cpus,
+				     struct cpumask *del_cpus)
+{
+	cpumask_var_t full_hk_cpus;
+	int res = true;
+
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
+		return true;
+
+	if (del_cpus && cpumask_weight_and(del_cpus,
+			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
+		return true;
+
+	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+		return false;
+
+	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+		    housekeeping_cpumask(HK_TYPE_DOMAIN));
+	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
+	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
+	if (!cpumask_weight_andnot(full_hk_cpus, add_cpus))
+		res = false;
+
+	free_cpumask_var(full_hk_cpus);
+	return res;
+}
+
 static void update_isolation_cpumasks(bool isolcpus_updated)
 {
 	int ret;
@@ -1568,6 +1607,9 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
+	if ((new_prs == PRS_ISOLATED) &&
+	    !isolated_cpus_can_update(tmp->new_cpus, NULL))
+		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
 	isolcpus_updated = partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
@@ -1674,6 +1716,9 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			cs->prs_err = PERR_NOCPUS;
+		else if ((prs == PRS_ISOLATED) &&
+			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
+			cs->prs_err = PERR_HKEEPING;
 		if (cs->prs_err)
 			goto invalidate;
 	}
@@ -1775,6 +1820,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	int subparts_delta = 0;
 	int isolcpus_updated = 0;
 	struct cpumask *xcpus = user_xcpus(cs);
+	int parent_prs = parent->partition_root_state;
 	bool nocpu;
 
 	lockdep_assert_held(&cpuset_mutex);
@@ -1839,6 +1885,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (prstate_housekeeping_conflict(new_prs, xcpus))
 			return PERR_HKEEPING;
 
+		if ((new_prs == PRS_ISOLATED) && (new_prs != parent_prs) &&
+		    !isolated_cpus_can_update(xcpus, NULL))
+			return PERR_HKEEPING;
+
 		if (tasks_nocpu_error(parent, cs, xcpus))
 			return PERR_NOCPUS;
 
@@ -1894,6 +1944,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * For invalid partition:
 		 *   delmask = newmask & parent->effective_xcpus
+		 *   The partition may become valid soon.
 		 */
 		if (is_partition_invalid(cs)) {
 			adding = false;
@@ -1908,6 +1959,23 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			deleting = cpumask_and(tmp->delmask, tmp->delmask,
 					       parent->effective_xcpus);
 		}
+
+		/*
+		 * TBD: Invalidate a currently valid child root partition may
+		 * still break isolated_cpus_can_update() rule if parent is an
+		 * isolated partition.
+		 */
+		if (is_partition_valid(cs) && (old_prs != parent_prs)) {
+			if ((parent_prs == PRS_ROOT) &&
+			    /* Adding to parent means removing isolated CPUs */
+			    !isolated_cpus_can_update(tmp->delmask, tmp->addmask))
+				part_error = PERR_HKEEPING;
+			if ((parent_prs == PRS_ISOLATED) &&
+			    /* Adding to parent means adding isolated CPUs */
+			    !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
+				part_error = PERR_HKEEPING;
+		}
+
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
 		 * must be present.
@@ -3039,7 +3107,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		isolcpus_updated = true;
+		if ((new_prs == PRS_ISOLATED) &&
+		    !isolated_cpus_can_update(cs->effective_xcpus, NULL))
+			err = PERR_HKEEPING;
+		else
+			isolcpus_updated = true;
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
-- 
2.53.0



