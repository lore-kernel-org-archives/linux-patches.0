Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622745;
	b=ub3ls1HNCjUQgjfAtedIF0z3G2yjmY7cgJ7N0H2IGZpkS6d2QkctPZpw5fVIVKyiBn9A
	 pkGaps6M6ot2H+8hUjaeCQwFU17FXqreuFUL+58Q6CZG2PnO8pJxetKNPX8u6J7X2qL7k
	 43BzwK0aAU70biRBBxf4tTBVKolCXwQSHLgo37C1wsFwbN8hRSNs/raBYLpuQFaKix/gI
	 f3CFjs/Bk48KVGRWJK42zGgUNMsHtqSv3HuDfsgeHw6Wax3gJljOzYgv9atRhvfd+NARR
	 IXXds1HBweMMY9RjGS/zKfIYVvvgmmgZd2qn6RWPi09U6gsLIxeQyHJXcvXauEyI0Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qjfS1cyPKEdwW+qbg2eQmcL6mk5mz8iexl/8YeHYk+Q=;
	b=cCP0WeXLDrwQ49IP/RHanUO7vbgL1aUS3J6psBimCD8e9ulQiUYx1YSJR/73UAUInrmx
	 Njj2zerdTwMUfW7Jg3fGmorXKWpLi9IfxiQXuXNupMxQ2BHa+xD7cbiMb8ScZham4tYMb
	 NORT/lCus8KAzEvTZD+UMh8eB0SnoZ+oW9d6chG8riqhziy35XV6NTqHGk39zV5IPhOEc
	 Eno4+XuGD6B5mckYVLsMqFM2KLQJSK3ujT1YjGQ3+swMTYsCmhviY/s48SjQnuyQO4ib2
	 5US27c1f+WKv1MRMqjMaMXI10w953w4sGUafJccC0ln4moqiwtgit9gOM9h6Zoy6SuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vcgztg+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DC5606A321;
	Wed, 25 Nov 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vcgztg+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A821F000C4;
	Wed, 25 Nov 2026 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622745;
	bh=qjfS1cyPKEdwW+qbg2eQmcL6mk5mz8iexl/8YeHYk+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vcgztg+g7kEM5e4iZHElR5gr7jVioMU3Ys/ULkYTKxboEtO+mZisF+kuU7YoFJWwH
	 tqxHl3e3vIk8NJMz4ybn+vbLY5D7NhxPS2nGG31KMvrLUQ7dgY51+6hxRzBIz/xBkH
	 1AYqYPz/+8nQu2YRvAQU99LYTDcGFZBfOvE7uNMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 632/990] cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()
Date: Wed, 25 Nov 2026 15:33:19 +0100
Message-ID: <20261125143836.901832569@linuxfoundation.org>
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
[ sashal: Kept the existing nr_subparts decrement and reset lines in the context, and added the explicit ":S+" to the new selftest row to match this tree's test-matrix syntax. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 46 +++++++------------
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b63489f9d3765..084cee4e789d5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -170,15 +170,6 @@ static inline bool cs_is_member(const struct cpuset *cs)
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
@@ -2234,8 +2225,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
  * or update_cpumasks_hier() where parent and children are modified
  * successively, we don't need to call update_parent_effective_cpumask()
  * and the child's effective_cpus will be updated in later iterations.
- *
- * Note that rcu_read_lock() is assumed to be held.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
 						struct cpumask *new_ecpus)
@@ -2247,15 +2236,16 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
@@ -2267,22 +2257,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
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
 			cs->nr_subparts--;
 			child->nr_subparts = 0;
 			spin_unlock_irq(&callback_lock);
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bd06324af3843..9a1590e630e6b 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -431,6 +431,10 @@ TEST_MATRIX=(
 	"CX0-4:P2:S+ CX2-4:P2:S+ CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
 								       A1:P2|A2:P2|A3:P-2 0-4"
 
+	# When an isolated partition child with root partition parent is invalidated,
+	# its effective xcpus will be removed from isolated_cpus.
+	"C1-4:P1:S+ C3-4:P2 .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
+
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
 	# Failure cases:
-- 
2.53.0



