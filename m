Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021774;
	b=YeSXIJ0WS9QjX+Olpo9Lwg6c6tBYRkZbRzsfnjVHxxuILCiZsBCZLaxilR2vsTTHh5Nc
	 skPETSw8drTyj8wAxj1OcC2l/VFwR9I+K+u/+7ZvTSIWhntmwMQg3O9soYczTfF7/7Q8n
	 BkfnpV6t1buH92Kkl3f9TzyhYp9CPMrlCOoXMg/nYWYhg3MQi5Y1zxr5H0B8WN4xfl12Z
	 TMi0DBX51+dd/WfgMXhUNHGWkMdzX+nfVno7V8pK86nCLOPVHPFoDNU50EY96YrXuKa04
	 PD7sL13U4ege5ooOrhSNCCd24eQUW8vqLRAZX0wRgoTyn6mosdAtLMDEmG1TvTy953Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QI98Wjy0zEmbmx1SD/Z1nz35OA9dF7He7MD0QwkFKzg=;
	b=TbRJPLp3/ZosbdSvtNKiQwfreW/SbehOYanqnBxv+eXbgUGMieHABDStWG+W2esbDbHP
	 3DQ28TmUvm6nm/xeiDoF7hZg1NM/PRDnkpyOK7FG4aeK03wF6OxPsVz86WfvAayyx9suu
	 bfKdehovw6cJmtXfLaSNOjU7k1Bf+8OT9fDBmo7LxflHMeZNlqfx/QOll0gUrlca4noOA
	 gn1SihBplG5H6CCqsRHE0Ew6U/AW5RPZHnFmt3X7o2HZ4aVkfi3dkyFTlMOsOhlk12Q+q
	 Y8Egerennk3QCbSsgMTtEdzJCF0muVkw2epkx+pimoV+krUjsfP6AhQJIOVK1Zzhq0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTxZlQe2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFA8606A320;
	Wed, 18 Nov 2026 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTxZlQe2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E691F000C4;
	Wed, 18 Nov 2026 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021774;
	bh=QI98Wjy0zEmbmx1SD/Z1nz35OA9dF7He7MD0QwkFKzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTxZlQe2+n6MIRZ11jFAJnQEzTzgjxgkAB4mc75FeDiehG9QQwiY1abVMLEpip/NN
	 VMN7HBaVp16Tawc2W63Xtf6jbXwaGvk5/JbEN9qb579BY01+lIgzaRLHwFF3XpB/ky
	 g3Yu1cZAW9dbhKWrCPeBKjvXV+glNUiUeT8iSx9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2426/2651] cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
Date: Wed, 18 Nov 2026 16:01:06 +0100
Message-ID: <20261118150412.568402473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 40702b2ca8fa08fb64b926d8c72a4909d0330580 ]

Commit 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when
doing housekeeping check") changes the way prstate_housekeeping_conflict()
is being used by considering all the exclusive xcpus to be owned by the
partition when doing housekeeping check. However there are two minor
issues reported by sashiko with that patch:

 1) In partition_cpus_change(), prstate_housekeeping_conflict() can
 be called with an invalid partition root. In that case, there are
 no isolated CPUs that are going to be returned back to the system to
 become housekeeping CPUs, so the calculation of the del_cpus cpumask
 is meaningless.

 2) The checking of del_cpus in prstate_housekeeping_conflict() to see
 if it can contain an active housekeeping CPU that can be returned to the
 system ignores the fact that an active CPU not in HK_TYPE_DOMAIN_BOOT HK
 cpumask will not become an active housekeeping CPU when it is released
 by an isolated partition.

Update the existing code to handle these two issues properly to make
prstate_housekeeping_conflict() produce more accurate result.

Fixes: 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 45 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 731f96f42574f..7e0ca4fae49eb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1471,6 +1471,9 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
+	if (del_cpus && cpumask_empty(del_cpus))
+		del_cpus = NULL;
+
 	/*
 	 * Exit 2nd check early and return false if
 	 * 1) there is no boot time isolated nohz_full CPU
@@ -1479,8 +1482,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	 *    be returned back to the parent.
 	 */
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
-	    (new_prs == parent_prs) ||
-	    ((new_prs == PRS_ROOT) && (!del_cpus || cpumask_empty(del_cpus))))
+	    (new_prs == parent_prs) || (!del_cpus && (new_prs == PRS_ROOT)))
 		return false;
 
 	/*
@@ -1491,20 +1493,29 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	if (parent_prs == PRS_ISOLATED)
 		swap(new_cpus, del_cpus);
 
-	if (del_cpus &&
-	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
-				   cpu_active_mask) < nr_cpu_ids))
-		return false;
-
 	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
 		return true;
 
+	/*
+	 * Check if del_cpus may contain a CPU that can become an active
+	 * housekeeping CPU again.
+	 */
+	if (del_cpus) {
+		cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+		if (cpumask_first_and_and(del_cpus, full_hk_cpus,
+					  cpu_active_mask) < nr_cpu_ids) {
+			res = false;
+			goto out;
+		}
+	}
+
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
 	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
-
+out:
 	free_cpumask_var(full_hk_cpus);
 	return res;
 }
@@ -2529,23 +2540,29 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
+	int parent_prs = is_remote_partition(cs)
+		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
 
 	if (cs_is_member(cs))
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
-	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+	if (!prs_err && (parent_prs > 0) &&
+	    !cpumask_empty(trialcs->effective_xcpus)) {
 		int prs = cs->partition_root_state;
-		int parent_prs = is_remote_partition(cs)
-			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+
 		/*
 		 * Check for housekeeping conflict by passing the whole
 		 * effective_xcpus as well as those CPUs that are to be
 		 * removed from cs as delmask.
 		 */
-		cpumask_andnot(tmp->delmask, cs->effective_xcpus, trialcs->effective_xcpus);
-		if (parent_prs > 0 &&
-		    prstate_housekeeping_conflict(prs, parent_prs,
+		if (prs > 0)
+			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
+				       trialcs->effective_xcpus);
+		else
+			cpumask_clear(tmp->delmask);
+
+		if (prstate_housekeeping_conflict(prs, parent_prs,
 						  trialcs->effective_xcpus, tmp->delmask))
 			prs_err = PERR_HKEEPING;
 	}
-- 
2.53.0



