Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622732;
	b=jAVHbAiDobVLtafbRG3e/RXZLupP6bcWKUemKyfSiloX49sMLl9x0EewlvqxPmzfCHRb
	 BoB8cQNjWy2mkkaGZZ+p1gbKfkUjXcREDQn0pG8IHYPFYiwcuu4HJwNTQFLLpEmishwzH
	 c+rPgJqNKA0Eox0N/aTX26wytYL7mx/fwYJgtcXoqf2jq9tkn24h4b8mGgfSFWW6xBLKk
	 LEqHJaw887ibN7MKnyn5BMw+0oCCk8iRqJ69DXk9xtoepTxGQoCbDyn6xyJu3IDICiCQG
	 m8iFqia6gDjbgfh5vRuMljYAxKKEJQJ5eHPQLvBTqSY5ZTeidRnvgFp1KFqgPGyt+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5bs+MZavJHMWz/8GzukY8P4W3HMahEGIIx4PyP5NMJ0=;
	b=rxKG2twMHc0tfO2T6kTuvGKXcv05rXredgL+TCUNjgSLGLiXPObad1pbet0a47sILa0L
	 A3TPeqBSxd3r3eJQnAVT+q8idJ1YoCUUroX3KylEpG2pU/23uDd17uTVGTTR1WaR5MJX7
	 LRE9hYpiqClZIjXRk2De6WCR2dDl/EFBNPk7XvR1u4OZhkAtm6zsb938S0arjUYcMugoW
	 J2L0saICBsojWFGHqkC5ozfGCH0PUg8Q9t97h24yNvab/GAW9y3IhUtb1lvIlq6MLTZno
	 pItJI9zbLHO1M2AyV9Lq8NleP2/1Ody6WxqkoK/gypvggNF+GqzoO0LGYlYiS+xR8YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRC3WkVH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC95D606A323;
	Wed, 25 Nov 2026 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRC3WkVH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA281F000C4;
	Wed, 25 Nov 2026 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622732;
	bh=5bs+MZavJHMWz/8GzukY8P4W3HMahEGIIx4PyP5NMJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRC3WkVHfu48KYa89lLFYrrI1hRdQrpe7C4KSave2B0Jq1l3jp1xsFKIwcXtsen39
	 Wtychzfwjzx12Q+kKLPAMQS7DchoeXOeqwbQtSWIORuE5wB47a0oYMqYG3Hqyx4cmx
	 A3mCg6B7yDeLMmX1JqDSj4RxZpWHs8TT3GXFUrPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 629/990] cgroup/cpuset: Properly compute effective xcpus in update_parent_effective_cpumask()
Date: Wed, 25 Nov 2026 15:33:16 +0100
Message-ID: <20261125143836.831785220@linuxfoundation.org>
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

[ Upstream commit 69a75e4f377629928bd173747b864694c2af4e1c ]

Since the introduction of cpuset.cpus.exclusive in commit
e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
compute_effective_exclusive_cpumask() helper which is later renamed to
compute_excpus() is added to compute the effective xcpus of a partition
root. However update_parent_effective_cpumask() is not updated in all
proper places to use the new helper to check if a given cpuset should
remain a valid partition root. This can cause a cpuset to incorrectly
remain a valid partition root even if no effective xcpus is left.

Fix that problem by using compute_excpus() to compute the effective xcpus
into delmask in all cases except partcmd_disable, partcmd_invalidate
or partcmd_update with newmask set and use it for tasks_nocpu_error()
check as well as checking its emptiness. This enables us to catch invalid
partition root more accurately in update_parent_effective_cpumask().

In the case of partcmd_update with newmask set, the passed in new
effective xcpus value will directly be used in the tasks_nocpu_error()
check without relying on old data in the cpuset.

For the partcmd_update with NULL newmask case, the cpu exclusivity test
there is also relaxed to be performed only if exclusive_cpus is empty.

Some test case are added to test_cpuset_prs.sh for invalidating a
partition root due to its effective xcpus becoming empty as well as
making sure that an invalid partition can only be revived when exclusive
CPUs are available agin.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Adjusted context for the older base (kept the xcpus declaration and subparts_delta lines, no PERR_ISOPARENT blocks) and added :S+ to parent cpusets in the selftest rows. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 86 ++++++++++---------
 .../selftests/cgroup/test_cpuset_prs.sh       | 11 +++
 2 files changed, 56 insertions(+), 41 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 54ee036020e05..7b13381755d07 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1854,7 +1854,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
  * @cmd:     Partition root state change command
- * @newmask: Optional new cpumask for partcmd_update
+ * @newmask: Optional new effective xcpus for partcmd_update
  * @tmp:     Temporary addmask and delmask
  * Return:   0 or a partition root state error code
  *
@@ -1869,11 +1869,11 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * given back to parent's effective_cpus. 0 will always be returned.
  *
  * For partcmd_update, if the optional newmask is specified, the cpu list is
- * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus is
- * assumed to remain the same. The cpuset should either be a valid or invalid
- * partition root. The partition root state may change from valid to invalid
- * or vice versa. An error code will be returned if transitioning from
- * invalid to valid violates the exclusivity rule.
+ * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus
+ * will be computed and a valid partition will be invalidated if it is the new
+ * cpumask is empty. The cpuset should either be a valid or invalid partition
+ * root. The partition root state may change from valid to invalid or vice
+ * versa.
  *
  * For partcmd_invalidate, the current partition will be made invalid.
  *
@@ -1941,30 +1941,30 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	if (!newmask && xcpus_empty(cs))
 		return PERR_CPUSEMPTY;
 
-	nocpu = tasks_nocpu_error(parent, cs, xcpus);
+	/*
+	 * Except for partcmd_disable and non-NULL newmask, use delmask
+	 * to compute the current effective xcpus value and use it for
+	 * tasks_nocpu_error check.
+	 */
+	if ((cmd != partcmd_disable) && !newmask) {
+		compute_excpus(cs, tmp->delmask);
+		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
+	}
 
 	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
-		/*
-		 * Need to call compute_excpus() in case
-		 * exclusive_cpus not set. Sibling conflict should only happen
-		 * if exclusive_cpus isn't set.
-		 */
-		xcpus = tmp->delmask;
-		if (compute_excpus(cs, xcpus))
-			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 
 		/*
 		 * Enabling partition root is not allowed if its
 		 * effective_xcpus is empty.
 		 */
-		if (cpumask_empty(xcpus))
+		if (cpumask_empty(tmp->delmask))
 			return PERR_INVCPUS;
 
-		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
 			return PERR_HKEEPING;
 
-		if (tasks_nocpu_error(parent, cs, xcpus))
+		if (nocpu)
 			return PERR_NOCPUS;
 
 		/*
@@ -1976,17 +1976,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * Warn if it is not the case.
 		 */
-		cpumask_and(tmp->new_cpus, xcpus, cpu_active_mask);
+		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
 		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
-
 		deleting = true;
 		subparts_delta++;
 	} else if (cmd == partcmd_disable) {
 		/*
 		 * May need to add cpus back to parent's effective_cpus
 		 * (and maybe removed from subpartitions_cpus/isolated_cpus)
-		 * for valid partition root. xcpus may contain CPUs that
-		 * shouldn't be removed from the two global cpumasks.
+		 * for valid partition root.
 		 */
 		if (is_partition_valid(cs)) {
 			cpumask_copy(tmp->addmask, cs->effective_xcpus);
@@ -2003,8 +2001,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			goto write_error;
 		}
 
-		/* Check newmask again, whether cpus are available for parent/cs */
-		nocpu |= tasks_nocpu_error(parent, cs, newmask);
+		/* Check newmask whether cpus are available for parent/cs */
+		nocpu = tasks_nocpu_error(parent, cs, newmask);
 
 		/*
 		 * partcmd_update with newmask:
@@ -2059,7 +2057,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		/*
 		 * partcmd_update w/o newmask
 		 *
-		 * delmask = effective_xcpus & parent->effective_cpus
+		 * delmask = newly computed effective xcpus value
 		 *
 		 * This can be called from:
 		 * 1) update_cpumasks_hier()
@@ -2071,43 +2069,49 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 * A partition error happens when parent has tasks and all
 		 * its effective CPUs will have to be distributed out.
 		 */
-		if (nocpu) {
+		if (nocpu || cpumask_empty(tmp->delmask)) {
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
 						xcpus, parent->effective_xcpus);
-		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
-			   cpumask_subset(xcpus, parent->effective_xcpus)) {
+		} else if (is_partition_invalid(cs)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
 			bool exclusive = true;
 
 			/*
 			 * Convert invalid partition to valid has to pass the
-			 * cpu exclusivity test as well as the housekeeping
-			 * check.
+			 * cpu exclusivity test when cpuset.cpus.exclusive is
+			 * empty as well as the housekeeping check.
 			 */
 			if (prstate_housekeeping_conflict(cs->partition_root_state,
-							  parent_prs, xcpus, NULL)) {
+							  parent_prs, tmp->delmask, NULL)) {
 				part_error = PERR_HKEEPING;
 				goto write_error;
 			}
-			rcu_read_lock();
-			cpuset_for_each_child(child, css, parent) {
-				if (child == cs)
-					continue;
-				if (!cpusets_are_exclusive(cs, child)) {
-					exclusive = false;
-					break;
+			if (cpumask_empty(cs->exclusive_cpus)) {
+				rcu_read_lock();
+				cpuset_for_each_child(child, css, parent) {
+					if (child == cs)
+						continue;
+					if (!cpusets_are_exclusive(cs, child)) {
+						exclusive = false;
+						break;
+					}
 				}
+				rcu_read_unlock();
 			}
-			rcu_read_unlock();
 			if (exclusive)
-				deleting = cpumask_and(tmp->delmask,
-						xcpus, parent->effective_cpus);
+				deleting = !cpumask_empty(tmp->delmask);
 			else
 				part_error = PERR_NOTEXCL;
 		}
+		/*
+		 * When both cs and parent remain valid, parent's
+		 * compute_partition_effective_cpumask() call would have removed
+		 * cs's effective_xcpus from the parent's effective_cpus. So
+		 * there is no need to adjust parent's effective_cpus here.
+		 */
 	}
 
 write_error:
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index ffa030cf1984d..7a077f4365072 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -291,6 +291,8 @@ TEST_MATRIX=(
 								       A1:P0|A2:P2|A3:P1 2-4|2-3"
 	" C0-4:S+ C1-4:S+ C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
 								       A1:P0|A2:P2|A3:P1 2"
+	"C1-6:P2:S+ C3-6:P2:S+ C3-4:P2 .      .     C5-6     .      .    0 A1:1-4|A2:5-6|A3:5-6 \
+								       A1:P2|A2:P2|A3:P-2 1-6"
 	" C1-4:X2-4:S+ C2-4:X3-4:S+:P1 C3-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
 								       A1:P0|A2:P-1|A3:P-2 ."
@@ -360,6 +362,10 @@ TEST_MATRIX=(
 	# cpuset.cpus is allowed, but those extra CPUs are ignored.
 	"C2-3:P1:S+ C3:P1   .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
 
+	# A child cannot recover until its exclusive CPUs are available again.
+	"CX1-4:P1:S+ CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
+	"CX1-4:P1:S+ CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
+
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"C2-3:P1:S+  C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"
@@ -419,6 +425,11 @@ TEST_MATRIX=(
 	" CX1-4:S+ CX2-4:P2 .    C5-6      .     .      .   P1:C3-6  0 A1:1|A2:2-4|B1:5-6 \
 								       A1:P0|A2:P2:B1:P-1 2-4"
 
+	# A middle isolated parent shrunk below coverage: the released CPUs of
+	# an invalidated child stay isolated as a higher ancestor still covers them.
+	"CX0-4:P2:S+ CX2-4:P2:S+ CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
+								       A1:P2|A2:P2|A3:P-2 0-4"
+
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
 	# Failure cases:
-- 
2.53.0



