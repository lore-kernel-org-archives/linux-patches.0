Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021958;
	b=NTuHFsWB0hUuAWZdCUoFkJZO6VJH0vlS4Zr51zMhSlNU3xhOBO4iI0i4yynS1RRHyIux
	 WiDCxxjgKUktFwZj68eQ0pN9BEoaZnHxuzrk+OoSOXtKBRHiCR6gRGH9VhgyF+CXBEPcK
	 57jpJgrm+D6RwlpyaeL47x9gqZZuJ4T5p79kUN6kViqp1eN+eYP7gCIw48Kr1C9uVeUP7
	 J7BL+tfAE1tGAJ/yPcRiXKvJsTESKVUz47ppZPAQt3YCMuu+0svHnmlxbmaF7zAtZoj+s
	 5OYowB4n91Hsa+a7NPam405JlMbueuUDpXpTcJOrcUHkcNiU0HoI5FBkTgg4zaKc03w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oWLJIEOBhC9V9xXnzd0DD00JdywTnOJ1gUZfVFHe/g0=;
	b=ePnHHLuRWGsQzCPiIuWhqxy/8AjkxdiyeEXHNSK2eGYgSWVX92DqEmL8N+Bj+DrD67X5
	 dOU/AnLXNyH/0pcl914bB6mthOvy/lFxrTXdGozQYTQwy56hAYi2H2frRHuZpiRRW8KUb
	 9THuWOB9ttDeTCK3MQ8FRksh+qmDC8k/fgZ8DzbhlWYRklnTfbSEx1w4a5WoM/l4Jyr0D
	 xIaowsxQbTtwbGqIYOycmjfydGnaTerU+SNAu5DlabXZVvpx3NVEX3+OjzXo2jYd/BPOz
	 lEnjZjJTl7QlGcfUtDvZgguVgc+BinqOY6ihRv33nGfhgSL+YmDLMz+T2lEu82Aok8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTFtA7TQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1369606A325;
	Wed, 18 Nov 2026 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTFtA7TQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024AE1F000C6;
	Wed, 18 Nov 2026 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021958;
	bh=oWLJIEOBhC9V9xXnzd0DD00JdywTnOJ1gUZfVFHe/g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTFtA7TQ3cn+8qthhE6DiH4/KP2PUCcaJg/9WJvuACyI9uZZeK7Vq111N3p4m+D3F
	 So+2mYkrQYWVIRm42zFRO1f+o1+wJoC82DZnQBmev6prvJJPthqh1x0U/ju6+B6VkO
	 WF7vEDrX+5wErC6jnMDutWM84zOKDMPyIuRHdVgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2490/2651] sched_ext: Let the bypass load balancer move tasks homed on other cpus
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150414.507381344@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit a043733588a06e12e69918fbf080a6c45446e6a5 ]

The following patch uses the bypass load balancer to drain a cpu's bypass
DSQ when the host loses SCX_CAP_BASE there. The host no longer consumes that
DSQ, so the drain has to move every task on it. The balancer skips the ones
homed on another cpu.

An earlier pass moved such a task in from its home cpu's DSQ, and the donor
cpu has not consumed it yet. A task's DSQ membership may only change under
the task's rq lock, which the balancer does not hold.

Take such a task off the donor DSQ with unlink_dsq_and_switch_rq_lock(), the
handshake a remote consumer uses. It drops the DSQ lock and switches to the
task's rq lock. A dequeue that gets in between takes the task, and the
balancer moves on. The insert then runs under the task's home rq lock, as it
already does for a donor-homed task.

A task whose donee is its own cpu can always run there.
task_can_run_on_remote_rq() warns when asked about a task's own cpu, so the
balancer skips the test for such a task.

The walk holds the donor rq lock, which keeps the donor cpu's dispatch and
its enqueuers away from the donor DSQ. A move of a task homed elsewhere
switches to the task's rq lock, and both can reach the DSQ meanwhile. The
parked cursor keeps the walk's place through a consume, and the sequence
bound keeps a task enqueued meanwhile out of the pass.

v2: The description says "the following patch", not "patches", uses the
balancer to drain a DSQ.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: 5c23d1710606 ("sched_ext: Fix queued bypassed tasks stalling when the host loses SCX_CAP_BASE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 64 +++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 352714097f8cf..dbe05c94cd7f0 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -5986,7 +5986,7 @@ bool scx_hardlockup(int cpu)
  * @sch: host sched whose bypass DSQs are balanced
  * @donor_rq: rq of the cpu whose bypass DSQ gives up @p, locked
  * @donor_dsq: @sch's bypass DSQ on @donor_rq's cpu, locked
- * @p: task on @donor_dsq, homed on @donor_rq
+ * @p: task on @donor_dsq, homed anywhere
  * @donee: cpu whose bypass DSQ receives @p
  *
  * Take @p off @donor_dsq and insert it into the bypass DSQ of @donee. The
@@ -5994,28 +5994,45 @@ bool scx_hardlockup(int cpu)
  * can still refuse the move under @p's rq lock. @p then goes back to the head
  * of @donor_dsq.
  *
+ * The insert runs under @p's rq lock. A task homed on @donor_rq is dequeued in
+ * place. unlink_dsq_and_switch_rq_lock() takes one homed elsewhere off and
+ * switches the rq lock from @donor_rq to its own. The switch can lose to a
+ * dequeue, and @p then belongs to the dequeuer.
+ *
  * @donor_rq and @donor_dsq are locked on entry and on return. @donor_dsq is
- * unlocked across the insert, so the caller's walk must find its place in it
- * again after the call.
+ * unlocked in between, and @donor_rq too while the lock is switched, so the
+ * caller's walk must find its place in @donor_dsq again after the call.
  *
- * Return the cpu that received @p, or -1 if @p went back onto @donor_dsq.
+ * Return the cpu that received @p, or -1 if @p went back onto @donor_dsq or was
+ * lost to a dequeue.
  */
 static s32 bypass_lb_move(struct scx_sched *sch, struct rq *donor_rq,
 			  struct scx_dispatch_q *donor_dsq, struct task_struct *p, s32 donee)
 {
 	struct scx_dispatch_q *dst_dsq;
 	u64 enq_flags;
+	struct rq *rq = task_rq(p);
 	s32 ret;
 
 	lockdep_assert_rq_held(donor_rq);
 	lockdep_assert_held(&donor_dsq->lock);
 
-	scx_wait_dispatching(p);
-	dispatch_dequeue_locked(p, donor_dsq);
-	raw_spin_unlock(&donor_dsq->lock);
+	if (rq == donor_rq) {
+		scx_wait_dispatching(p);
+		dispatch_dequeue_locked(p, donor_dsq);
+		raw_spin_unlock(&donor_dsq->lock);
+	} else if (!unlink_dsq_and_switch_rq_lock(p, donor_dsq, donor_rq, rq)) {
+		/* lost to a dequeue, @p is the dequeuer's now */
+		ret = -1;
+		goto out;
+	}
 
-	/* @p's affinity is stable under its rq lock */
-	if (task_can_run_on_remote_rq(sch, p, cpu_rq(donee), false)) {
+	/*
+	 * @p's affinity is stable under its rq lock. A task whose donee is its
+	 * own cpu can always run there, and task_can_run_on_remote_rq() warns
+	 * when asked about a task's own cpu.
+	 */
+	if (donee == task_cpu(p) || task_can_run_on_remote_rq(sch, p, cpu_rq(donee), false)) {
 		dst_dsq = scx_bypass_dsq(sch, donee);
 		enq_flags = 0;
 		ret = donee;
@@ -6026,8 +6043,10 @@ static s32 bypass_lb_move(struct scx_sched *sch, struct rq *donor_rq,
 		ret = -1;
 	}
 
-	scx_dispatch_enqueue(sch, donor_rq, dst_dsq, p, 0, 0, enq_flags);
-
+	scx_dispatch_enqueue(sch, rq, dst_dsq, p, 0, 0, enq_flags);
+out:
+	if (rq != donor_rq)
+		switch_rq_lock(rq, donor_rq);
 	raw_spin_lock(&donor_dsq->lock);
 	return ret;
 }
@@ -6080,22 +6099,16 @@ static u32 bypass_lb_cpu(struct scx_sched *sch, s32 donor,
 		if (u32_before(cursor.priv, p->scx.dsq_seq))
 			continue;
 
-		/*
-		 * If an earlier pass placed @p on @donor_dsq from a different
-		 * CPU and the donee hasn't consumed it yet, @p is still on the
-		 * previous CPU and task_rq(@p) != @donor_rq. @p can't be moved
-		 * without its rq locked. Skip.
-		 */
-		if (task_rq(p) != donor_rq)
-			continue;
-
 		donee = cpumask_any_and_distribute(donee_mask, p->cpus_ptr);
 		if (donee >= nr_cpu_ids)
 			continue;
 
 		/*
-		 * The move drops @donor_dsq's lock. Park the cursor behind @p
-		 * and resume from it afterwards.
+		 * The move drops @donor_dsq's lock, and the rq lock too when
+		 * @p is homed elsewhere. The donor cpu's dispatch and its
+		 * enqueuers can reach @donor_dsq then. Park the cursor behind
+		 * @p and resume from it afterwards. The seq test above keeps a
+		 * task enqueued meanwhile out of the pass.
 		 */
 		list_move(&cursor.node, &p->scx.dsq_list.node);
 		cpu = bypass_lb_move(sch, donor_rq, donor_dsq, p, donee);
@@ -6114,9 +6127,10 @@ static u32 bypass_lb_cpu(struct scx_sched *sch, s32 donor,
 			 * The rq lock is held across the walk, not cycled per
 			 * move. @donor_dsq can be very long and contended, and
 			 * the rq lock is what keeps its consumer and enqueuers
-			 * away while the walk cycles the DSQ lock. The walk can
-			 * still take a while, so let the cpu breathe every so
-			 * often.
+			 * away while the walk cycles the DSQ lock. The rare
+			 * move of a task homed elsewhere does switch it away,
+			 * see the cursor comment above. The walk can still take
+			 * a while, so let the cpu breathe every so often.
 			 */
 			if (!(++nr_balanced % SCX_BYPASS_LB_BATCH)) {
 				raw_spin_unlock(&donor_dsq->lock);
-- 
2.53.0



