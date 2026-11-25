Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622677;
	b=QSEknQen5/9Os0E1chwd1W+NJghcCP3PWV1R+wQxRryO48G8to77IXv/rf33W6ja7BmX
	 Ki2PGS3y0+SOwsw8nGhvH0JOgmymMywamnLZdXQkJdCGhHSSGTGZVGgJnrIMlBDkSOX5R
	 cDs4YPj3JwbTB87awAnJVOu7izfjZSYU5JHv+cZyw5PG5sN0+uAOpIhuB/9PP8IafExyU
	 4JBpgT4LcK+m1HZg6pMgyTxCNq7z/SLa7pJpD3Te58/5mmF8oSDD0KaPqqtQbDF6SHorQ
	 Fd7C04ZXlmtVTQ0BV5YXh8SwOuImGEDkwCpTHCWaQ65n/M3eCSJNV8DPJzYsC+bXnDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tow1WoazAUr54t4Gu9Be1yHSUiXWnpOSGd5/MP1Yzus=;
	b=k3fNgWMLTjhYdsIGZykJZv60L8WRLmopOoNhRyaeo+OttEXzg/X2sdQc/l1fe/ZcLPdg
	 oR7kHCAzUbtdwsaTe+EjMH+vWWGatIL7DT0qgNGD73XNM2Q27LlPerTE54N8RMIlVbSBe
	 68difDK2u45oZgF0lJAvg2T5jqVV5FaRAwAns2nwjlZKkEZCQIF5koT0VRyAC7VB5XHLe
	 W7LVADG0rypMncJ5oFXKlKhJjXnqbD6wqH1wAB271seiKscS4IGN+6lIc6NXpmUZO53eq
	 3fNutNNpBhY36vXSAsENLOys5/WA8b4owXUztan5Cw+aJpb/N14s+S+q7ffGG5wJJ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m9sH/LDD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5744606A31E;
	Wed, 25 Nov 2026 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9sH/LDD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869711F000D0;
	Wed, 25 Nov 2026 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622677;
	bh=Tow1WoazAUr54t4Gu9Be1yHSUiXWnpOSGd5/MP1Yzus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9sH/LDDgrLIcsDBdJzjv5LY+a1Ru0jNFLlWIvl2utBCzFNDCdvOOcWRYrv5pjjkE
	 BxTxl4d57D1U4hyumLeLX6gnuyMTMpoaCp9jch3KPbReASfCeOsv+DZ29geq3k1z+E
	 H9WI5ZbErXMT5u6mhNmaJNxLfF+9CP37Z9+XZbW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 613/990] cgroup/cpuset: Consolidate isolated_cpus_can_update() into prstate_housekeeping_conflict()
Date: Wed, 25 Nov 2026 15:33:00 +0100
Message-ID: <20261125143836.451432450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 53bbfb33b1f4fd669c5bffcb7670c4099ecbb225 ]

The isolated_cpus_can_update() and prstate_housekeeping_conflict() are
checking different aspects of upcoming cpumask changes that may conflict
with the current setting of the housekeeping cpumasks. There are places
where both are called together. There are also places where only one
of them is called. That inconsistency can contribute to missing check
where invalid cpumask changes may be allowed to move forward.

Fix that by consolidating isolated_cpus_can_update() into
prstate_housekeeping_conflict() and call prstate_housekeeping_conflict()
in all the places where either one of them or both are called. The
exception is the validate_partition() function where the
prstate_housekeeping_conflict() call is removed. It is because
validate_partition() is called only from partition_cpus_change()
where prstate_housekeeping_conflict() will be called from either
remote_cpus_update() or update_parent_effective_cpumask() with
partcmd_update if not for partition invalidatation or disablement.

Now prstate_housekeeping_conflict() will be called in the following
locations:
 - when a partition is enabled in remote_partition_enable() or in
   update_parent_effective_cpumask() with partcmd_enable*.
 - when a cpumask is updated in remote_cpus_update() or in
   update_parent_effective_cpumask() with partcmd_update.
 - when a partition state changes from root to isolated or vice versa
   in update_prstate().

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Replaced this tree's boot-isolcpus variables (have_boot_isolcpus, boot_hk_cpus) for the missing HK_TYPE_DOMAIN_BOOT housekeeping checks, with context adjusted for earlier backports. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 147 +++++++++++++++++++++--------------------
 1 file changed, 77 insertions(+), 70 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3ef103c4b68d3..4bda4c6b754f4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1428,64 +1428,87 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
 }
 
 /*
- * isolated_cpus_can_update - check for isolated & nohz_full conflicts
- * @add_cpus: cpu mask for cpus that are going to be isolated
- * @del_cpus: cpu mask for cpus that are no longer isolated, can be NULL
- * Return: false if there is conflict, true otherwise
- *
- * If nohz_full is enabled and we have isolated CPUs, their combination must
- * still leave housekeeping CPUs.
+ * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
+ * @new_prs: new partition root state to be checked
+ * @parent_prs: Parent partition root state
+ * @add_cpus: additional CPUs to be added to current cpuset
+ * @del_cpus: CPUs to be removed from current cpuset, can be NULL
+ * Return: true if there is conflict, false otherwise
  *
- * TBD: Should consider merging this function into
- *      prstate_housekeeping_conflict().
+ * There are two different housekeeping conflicts to be checked:
+ * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
+ *    CPU. IOW, the whole @add_cpus must be a subset of boot_hk_cpus.
+ * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
+ *    still leave housekeeping CPUs. This check is only needed if new_prs
+ *    differs from parent_prs and one of them is PRS_ISOLATED.
  */
-static bool isolated_cpus_can_update(struct cpumask *add_cpus,
-				     struct cpumask *del_cpus)
+static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
+					  struct cpumask *add_cpus,
+					  struct cpumask *del_cpus)
 {
 	cpumask_var_t full_hk_cpus;
-	int res = true;
+	int res;
 
-	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
-		return true;
+	WARN_ON_ONCE(parent_prs <= 0);
+	if (!new_prs)
+		return false;
 
-	if (del_cpus && cpumask_weight_and(del_cpus,
-			housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)))
+	/*
+	 * For a currently invalid partition root state, do the check assuming
+	 * that it may be converted back to valid.
+	 *
+	 * There are code paths where an invalid partition may be reverted back
+	 * to a valid partition but we still need to run the housekeeping check
+	 * before the conversion happens to make sure the switch is valid. We
+	 * can either do the negative to positive PRS switch individually in all
+	 * these code paths or do it here which I think will make the code a bit
+	 * easier to read.
+	 */
+	if (new_prs < 0)
+		new_prs = -new_prs;
+
+	if (have_boot_isolcpus && (new_prs == PRS_ROOT) &&
+	    !cpumask_subset(add_cpus, boot_hk_cpus))
 		return true;
 
-	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+	/*
+	 * Exit 2nd check early and return false if
+	 * 1) there is no boot time isolated nohz_full CPU
+	 * 2) parent and child has the same partition state
+	 * 3) new_prs is PRS_ROOT, parent_prs is PRS_ISOLATED and no CPU will
+	 *    be returned back to the parent.
+	 */
+	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
+	    (new_prs == parent_prs) ||
+	    ((new_prs == PRS_ROOT) && (!del_cpus || cpumask_empty(del_cpus))))
+		return false;
+
+	/*
+	 * Now make sure that @add_cpus contains new CPUs to be isolated and
+	 * @del_cpus contains isolated CPUs to be un-isolated.
+	 * With the guards above, @add_cpus can't be NULL after the swap.
+	 */
+	if (parent_prs == PRS_ISOLATED)
+		swap(add_cpus, del_cpus);
+
+	if (del_cpus &&
+	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+				   cpu_active_mask) < nr_cpu_ids))
 		return false;
 
+	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
+		return true;
+
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
-	if (!cpumask_weight_andnot(full_hk_cpus, add_cpus))
-		res = false;
+	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
 
 	free_cpumask_var(full_hk_cpus);
 	return res;
 }
 
-/*
- * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
- * @prstate: partition root state to be checked
- * @new_cpus: cpu mask
- * Return: true if there is conflict, false otherwise
- *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
- * isolated partition.
- */
-static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
-{
-	if (!have_boot_isolcpus)
-		return false;
-
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
-		return true;
-
-	return false;
-}
-
 static void update_isolation_cpumasks(bool isolcpus_updated)
 {
 	int ret;
@@ -1645,9 +1668,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 		return PERR_INVCPUS;
 	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
 		return PERR_NOCPUS;
-	if (((new_prs == PRS_ISOLATED) &&
-	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
-	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
+	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
@@ -1755,8 +1776,8 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if ((prs == PRS_ISOLATED) &&
-			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
+		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
+						       tmp->addmask, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
@@ -1901,11 +1922,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (cpumask_empty(xcpus))
 			return PERR_INVCPUS;
 
-		if (prstate_housekeeping_conflict(new_prs, xcpus))
-			return PERR_HKEEPING;
-
-		if ((new_prs == PRS_ISOLATED) && (new_prs != parent_prs) &&
-		    !isolated_cpus_can_update(xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
 			return PERR_HKEEPING;
 
 		if (tasks_nocpu_error(parent, cs, xcpus))
@@ -1980,20 +1997,12 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		}
 
 		/*
-		 * TBD: Invalidate a currently valid child root partition may
-		 * still break isolated_cpus_can_update() rule if parent is an
-		 * isolated partition.
+		 * Check for housekeeping conflicts
 		 */
-		if (is_partition_valid(cs) && (old_prs != parent_prs)) {
-			if ((parent_prs == PRS_ROOT) &&
-			    /* Adding to parent means removing isolated CPUs */
-			    !isolated_cpus_can_update(tmp->delmask, tmp->addmask))
-				part_error = PERR_HKEEPING;
-			if ((parent_prs == PRS_ISOLATED) &&
-			    /* Adding to parent means adding isolated CPUs */
-			    !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
-				part_error = PERR_HKEEPING;
-		}
+		if (is_partition_valid(cs) &&
+		    prstate_housekeeping_conflict(old_prs, parent_prs,
+						  tmp->delmask, tmp->addmask))
+			part_error = PERR_HKEEPING;
 
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
@@ -2559,10 +2568,6 @@ static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *tri
 	if (cpumask_empty(trialcs->effective_xcpus))
 		return PERR_INVCPUS;
 
-	if (prstate_housekeeping_conflict(trialcs->partition_root_state,
-					  trialcs->effective_xcpus))
-		return PERR_HKEEPING;
-
 	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
 		return PERR_NOCPUS;
 
@@ -2616,7 +2621,7 @@ static int cpus_allowed_validate_change(struct cpuset *cs, struct cpuset *trialc
  * CPU modifications may cause a partition to be disabled or require state updates.
  */
 static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
-					struct tmpmasks *tmp)
+				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
 
@@ -3173,13 +3178,15 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
 		}
 	} else if (old_prs && new_prs) {
+		int parent_prs = is_remote_partition(cs)
+				 ? PRS_ROOT : parent->partition_root_state;
+
 		/*
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		if (((new_prs == PRS_ISOLATED) &&
-		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs,
+						  cs->effective_xcpus, NULL))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;
-- 
2.53.0



