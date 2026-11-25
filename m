Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622680;
	b=OOju4QI/MahHTpOlF9/8KxWCJoZzlrj1JBiA6m2+um/6ph0xPwYpSMvrXfzT+yOzUByl
	 S6VStIrzY/8Qz6lpQpwFX1RhV3tu1gq2CIx0WySQKwhrVMQhKxkPXznwQRhL51jtVqdTl
	 Yi/oJhLB+K59Y+y/GOm60eeKqAJXEYY2LsFu1sZILJWKq2IaLG2/SPywmELewE5YFaxc7
	 r0HQg1cEaDRGRiJVHCaRbURXF/RMnqr8gdExxNTBOmka6G3Qze99WmlrK2h5RObxzKuCb
	 aLkVNsbWcDT5BCA6MOCh511rL8a97BU2gfpsnjUVWGx8L9Ih/GRBCRbxiq+qR5FsXgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6saQ7l/OqZMapc3TbDNvTVxcOxDQnJjXiN6y6jfu5zQ=;
	b=Fomz86L0yn1ssgnEPXU/BxIea1NJabsPDHSrByPp7qHK019JC1x7qbCFYupoYIqncazt
	 Y+L+/FvcgRGhNLrGBq0PcyzVQmAFafnsuonne8alu1R4/lFkJph6YVYwm1vFE1A3cfSg/
	 cwqEFQdqqGUwBHWPCenTVGsD70hqvNjx7xp4z/A/bSTWxmiV9Yyti537PNfZGed1qGpd+
	 mOgukdcAXNBoUhQxj5GxJjYPNPzfXBY1RaroLRlFH9qusChjTmRjS+q1js2e3AwkuHtIW
	 hE36SZ0QtIyA02WADmzZGFe6nSBdQY/7lSttmc88U+MVqRrLZYOe3YJY8NhAeB3bt6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIpWNkhT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A64606A321;
	Wed, 25 Nov 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIpWNkhT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1BE1F000C4;
	Wed, 25 Nov 2026 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622680;
	bh=6saQ7l/OqZMapc3TbDNvTVxcOxDQnJjXiN6y6jfu5zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIpWNkhTX1jg7cSG6N1zIW7UCZbl1l0sTTJQHY6h/iPnBlKvwFYLjbUwVTUCZXucv
	 8KrHjQBIW+bxcgt+ycijYjVqZJc29poyf+4ZpZgtC3wlIwRNlXs5GYtkjq8qiB7gGW
	 UItc4egZvdfQQNK0ltRyB1xzMK50YB1saEdNjxpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 614/990] cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check
Date: Wed, 25 Nov 2026 15:33:01 +0100
Message-ID: <20261125143836.475634493@linuxfoundation.org>
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

[ Upstream commit 9527ff78a413e2b4089e78953926af77b98fd43f ]

When prstate_housekeeping_conflict() is called to perform housekeeping
check with cpumask changes, the cpumask changes are passed in via add_cpus
and del_cpus parameters. With this arrangement, the exclusive CPUs owned
by the child partitions and not affected by the cpumask change, if any,
are excluded in the analysis. The only places where there are separate
add and delete masks are when the cpuset.cpus or cpuset.cpus.exclusive
is being changed. In both cases, partition_cpus_change() is a good place
to perform the housekeeping check.

If we allow a root partition to be created under an isolated partition,
it is possible the cpumask change will still leave active housekeeping
CPUs but then no housekeeping CPUs will be left when the child partitions
are disabled or invalidated.

As a first step to protect against this possibility, all the exclusive
CPUs of the cpuset should be considered to be owned by the current cpuset
when doing housekeeping check. At the same time, we do want to know if
some housekeeping CPUs are going to be removed from the isolated partition
that there will be no danger of losing all the active housekeeping CPUs.
So the current add_cpus paremeter is renamed as new_cpus to indicate
that it includes the complete set of effective xcpus.

With the new check in partition_cpus_change(), the housekeeping check
in update_parent_effective_cpumask() with partcmd_update and newmask
is now duplicative and can be removed. The housekeeping check in
remote_cpus_update(), however, will still be useful as this function can
be called directly from update_cpumasks_hier() without going through
partition_cpus_change(). The update_parent_effective_cpumask() call
from update_cpumasks_hier() is partcmd_update with no cpumask which
still have the housekeeping check and so is covered.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Replaced the upstream HK_TYPE_DOMAIN_BOOT housekeeping checks with this tree's have_boot_isolcpus and boot_hk_cpus, keeping the add_cpus to new_cpus rename. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 46 +++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4bda4c6b754f4..ee5ee72b8590d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1431,19 +1431,19 @@ static bool partition_xcpus_del(int old_prs, struct cpuset *parent,
  * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
  * @new_prs: new partition root state to be checked
  * @parent_prs: Parent partition root state
- * @add_cpus: additional CPUs to be added to current cpuset
- * @del_cpus: CPUs to be removed from current cpuset, can be NULL
+ * @new_cpus: the set of new effective xcpus in the current cpuset
+ * @del_cpus: old CPUs going to be removed from current cpuset, can be NULL
  * Return: true if there is conflict, false otherwise
  *
  * There are two different housekeeping conflicts to be checked:
- * 1) If new_prs is PRS_ROOT, none of the @add_cpus can be a boot-time isolated
- *    CPU. IOW, the whole @add_cpus must be a subset of boot_hk_cpus.
+ * 1) If new_prs is PRS_ROOT, none of the @new_cpus can be a boot-time isolated
+ *    CPU. IOW, the whole @new_cpus must be a subset of boot_hk_cpus.
  * 2) If nohz_full is enabled and we have isolated CPUs, their combination must
  *    still leave housekeeping CPUs. This check is only needed if new_prs
  *    differs from parent_prs and one of them is PRS_ISOLATED.
  */
 static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
-					  struct cpumask *add_cpus,
+					  struct cpumask *new_cpus,
 					  struct cpumask *del_cpus)
 {
 	cpumask_var_t full_hk_cpus;
@@ -1468,7 +1468,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		new_prs = -new_prs;
 
 	if (have_boot_isolcpus && (new_prs == PRS_ROOT) &&
-	    !cpumask_subset(add_cpus, boot_hk_cpus))
+	    !cpumask_subset(new_cpus, boot_hk_cpus))
 		return true;
 
 	/*
@@ -1484,12 +1484,12 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		return false;
 
 	/*
-	 * Now make sure that @add_cpus contains new CPUs to be isolated and
+	 * Now make sure that @new_cpus contains new CPUs to be isolated and
 	 * @del_cpus contains isolated CPUs to be un-isolated.
-	 * With the guards above, @add_cpus can't be NULL after the swap.
+	 * With the guards above, @new_cpus can't be NULL after the swap.
 	 */
 	if (parent_prs == PRS_ISOLATED)
-		swap(add_cpus, del_cpus);
+		swap(new_cpus, del_cpus);
 
 	if (del_cpus &&
 	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
@@ -1503,7 +1503,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
-	res = !cpumask_weight_andnot(full_hk_cpus, add_cpus);
+	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
 
 	free_cpumask_var(full_hk_cpus);
 	return res;
@@ -1777,7 +1777,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
 			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
 		else if (prstate_housekeeping_conflict(prs, PRS_ROOT,
-						       tmp->addmask, tmp->delmask))
+						       excpus, tmp->delmask))
 			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
 		if (cs->prs_err)
 			goto invalidate;
@@ -1996,14 +1996,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 					       parent->effective_xcpus);
 		}
 
-		/*
-		 * Check for housekeeping conflicts
-		 */
-		if (is_partition_valid(cs) &&
-		    prstate_housekeeping_conflict(old_prs, parent_prs,
-						  tmp->delmask, tmp->addmask))
-			part_error = PERR_HKEEPING;
-
 		/*
 		 * The new CPUs to be removed from parent's effective CPUs
 		 * must be present.
@@ -2629,6 +2621,22 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
+	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+		int prs = cs->partition_root_state;
+		int parent_prs = is_remote_partition(cs)
+			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+		/*
+		 * Check for housekeeping conflict by passing the whole
+		 * effective_xcpus as well as those CPUs that are to be
+		 * removed from cs as delmask.
+		 */
+		cpumask_andnot(tmp->delmask, cs->effective_xcpus, trialcs->effective_xcpus);
+		if (parent_prs > 0 &&
+		    prstate_housekeeping_conflict(prs, parent_prs,
+						  trialcs->effective_xcpus, tmp->delmask))
+			prs_err = PERR_HKEEPING;
+	}
+
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
-- 
2.53.0



