Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021782;
	b=JJnlAVe0KPYPc2C+giMaoctxrZ3T49zZATDampEqsRgzuOOygXoppkqRyW/CzJoqlfDe
	 TVjPlSbatWBJZD2BvPByGwuRGnRm77sm6F7/bRRMiCD3c0w1ry4FJGcDz4yY4P20iJVvQ
	 mOk8kWC2plQbQ68ar5wV+ReZyZ/+a0mk5XeTBDmda8daYz09d4YxKYUdcRijgAe+KiMgt
	 4PFwzdDjE+R9JiGVUdNolku7SJLtfdIjN9/PJK99+Nm2MiKZaxLGE+6zOe/F620DFSAEl
	 h7rQhHqoOkAhMJ+dkmk7YsmLnQJ/OzIBaHd8T+ed/9FsqWBwyNF6uGc+qT/MNynyS9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CJVTDjh4khfAHzZgGDFBd1ppcxHZh02PP5CyiAQAXwU=;
	b=YruF3DQuDM1CC4bvUJhrxaBU0kuPvxGmSCK7vCZL19GFLL6N49DyPO4TpEnbwoTkk3fD
	 EEoBg29PwRC7RseNlLoBA74qDwNYjXFHDxBliaMspmHDEKZZWr58drJsK/5LyTWm10cUw
	 jsXufvXIDQC8rFG65x/LGHYFepfMCT3NIFr6dR/ZyrvtMTElzyyFG/czdqzpGHtCKUM+V
	 97T94a8sUpxx4jN40EfEc56bLTYOwKjPmoin/A045L/XmfdzgPdSmkpFHuaWn51k0muAj
	 TGel7cgVproFR9tqg1F7Due1AlFHkIkOhed7MRdb6kXcLtXqh5IH98YDa8/TiXUojjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZS5ZJAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6A9606A32A;
	Wed, 18 Nov 2026 17:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZS5ZJAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EFD1F000C4;
	Wed, 18 Nov 2026 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021782;
	bh=CJVTDjh4khfAHzZgGDFBd1ppcxHZh02PP5CyiAQAXwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZS5ZJAP3Glfz2vu9tEmQMLqN5EvCx7ntHkmZXCNSv17bt4SFksqZ4Q6qzZ6aHW8G
	 Bfu0TlUo+Q1po7WAJzrqzsTzq3LPCwy7vM/DqF3aeDxNuzZUd5E4VqQuWF9dDaJzKg
	 U+sNJlyd/6vctHud5pM0YCBTi0Ks+LFB0hhqNXrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2429/2651] cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()
Date: Wed, 18 Nov 2026 16:01:09 +0100
Message-ID: <20261118150412.662584311@linuxfoundation.org>
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

[ Upstream commit a7d89d92fdfbceb678d82710135d4eee2623d727 ]

It is found by sashiko that when a child isolated partition with parent
root partition is invalidated in compute_partition_effective_cpumask(),
the switching of the isolated exclusive CPUs from child to parent will
not be reflected in isolated_cpus leading to CPU leakage. Fix that by
calling isolated_cpus_update() when that happens.

Also simplify compute_partition_effective_cpumask() by doing
child partition invalidation only for the special case of no more
effective_cpus left in a populated parent. The other case doesn't
actually warrant invalidation at this stage and subsequent iteration
in update_cpumasks_hier() and update_parent_effective_cpumask() for
that child should handle that.

Also drop the make_partition_invalid() helper by inlining it into
compute_partition_effective_cpumask() as it is the only caller.

A new test case is add to test_cpuset_prs.sh to verify this.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 46 +++++++------------
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 96c018c77838f..e7a2f812db9ed 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -255,15 +255,6 @@ static inline bool cs_is_member(const struct cpuset *cs)
 	return cs->partition_root_state == PRS_MEMBER;
 }
 
-/*
- * Callers should hold callback_lock to modify partition_root_state.
- */
-static inline void make_partition_invalid(struct cpuset *cs)
-{
-	if (cs->partition_root_state > 0)
-		cs->partition_root_state = -cs->partition_root_state;
-}
-
 /*
  * Send notification event of whenever partition_root_state changes.
  */
@@ -2194,8 +2185,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
  * or update_cpumasks_hier() where parent and children are modified
  * successively, we don't need to call update_parent_effective_cpumask()
  * and the child's effective_cpus will be updated in later iterations.
- *
- * Note that rcu_read_lock() is assumed to be held.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
 						struct cpumask *new_ecpus)
@@ -2207,15 +2196,16 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	WARN_ON_ONCE(!is_partition_valid(cs));
 
 	/*
-	 * Check child partition roots to see if they should be
-	 * invalidated when
-	 *  1) child effective_xcpus not a subset of new
-	 *     excluisve_cpus
-	 *  2) All the effective_cpus will be used up and cp
-	 *     has tasks
+	 * Check child partition roots to see if they should be invalidated
+	 * when all the effective_cpus will be used up and cs is populated.
+	 * It is better to sacrifice a child partition root than invalidating
+	 * the whole subtree.
+	 *
+	 * Return early if the effective_cpus is already empty.
 	 */
 	compute_excpus(cs, new_ecpus);
-	cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);
+	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
+		return;
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
@@ -2227,22 +2217,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		WRITE_ONCE(child->prs_err, 0);
-		if (!cpumask_subset(child->effective_xcpus,
-				    cs->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
-		else if (populated &&
-			 cpumask_subset(new_ecpus, child->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-
-		if (child->prs_err) {
+		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
 			int old_prs = child->partition_root_state;
+			int parent_prs = cs->partition_root_state;
 
 			/*
-			 * Invalidate child partition
+			 * Invalidate child partition and update isolated_cpus
+			 * if necessary.
 			 */
 			spin_lock_irq(&callback_lock);
-			make_partition_invalid(child);
+			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
+			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
+				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
+						     child->effective_xcpus);
+			child->partition_root_state = -old_prs;
 			spin_unlock_irq(&callback_lock);
 			notify_partition_change(child, old_prs);
 			continue;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index b7ddebb6eebec..5f1229c06645e 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -452,6 +452,10 @@ TEST_MATRIX=(
 	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
 								       A1:P2|A2:P2|A3:P-2 0-4"
 
+	# When an isolated partition child with root partition parent is invalidated,
+	# its effective xcpus will be removed from isolated_cpus.
+	" C1-4:P1 C3-4:P2   .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.53.0



