Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773FE1C860A;
	Wed,  4 Feb 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219283; cv=none; b=s7TNaRTmSasjJw/E6Rd+2uo8vVflwlIZcpjdwfvYn9O3TOg7FDhozpjSRHEsb4xc8IVk3vYRxbMoZc3h7DasfX90Q0BowAqhsRaU5lpUU6/yABsWVHjOikfSA5gBDPJtkdLCoqDQNKka7+OEHgRwyPgoKQCitX/x6LqZNtnvRSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219283; c=relaxed/simple;
	bh=cQ0Nq1MERezpOYdrvQOy7ERRI9MpYm43CGBApNc1+w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RymeBALKPHJHVsebAsjL0yZ4gDOipiavKa9/rG0zNmTQPO/EtWA4KbXDJ8DAXu6arWIbIT1VPfK/TMEy4Zq3Y7A/wU2L+wWkYffYFgo90Si6EqQ/91MFv1UadE7TCqaV9VH5zjt86+ul25BCa6rfkt9LEudqVXemontlD4hKqJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLA+vSjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLA+vSjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF607C4CEF7;
	Wed,  4 Feb 2026 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219283;
	bh=cQ0Nq1MERezpOYdrvQOy7ERRI9MpYm43CGBApNc1+w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLA+vSjbPEfnlGRNmGQIEog9sTcaoWhdGWyW6PFTGndEvPADbjMRzbIy+UpvHaTIS
	 P5CeQxPFZKCPK2VvxDHK5VD/oqOLqWoMAuKULyfCZXdVmcWiAdNHt1fblYUI4iH1u8
	 doLAS3kNaQrtC51e+bK5KGkWi+3frD44zOwRq9zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen-Fang Liu <liuwenfang@honor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.18 121/122] sched_ext: Fix SCX_KICK_WAIT to work reliably
Date: Wed,  4 Feb 2026 15:41:43 +0100
Message-ID: <20260204143856.204834107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

commit a379fa1e2cae15d7422b4eead83a6366f2f445cb upstream.

SCX_KICK_WAIT is used to synchronously wait for the target CPU to complete
a reschedule and can be used to implement operations like core scheduling.

This used to be implemented by scx_next_task_picked() incrementing pnt_seq,
which was always called when a CPU picks the next task to run, allowing
SCX_KICK_WAIT to reliably wait for the target CPU to enter the scheduler and
pick the next task.

However, commit b999e365c298 ("sched_ext: Replace scx_next_task_picked()
with switch_class()") replaced scx_next_task_picked() with the
switch_class() callback, which is only called when switching between sched
classes. This broke SCX_KICK_WAIT because pnt_seq would no longer be
reliably incremented unless the previous task was SCX and the next task was
not.

This fix leverages commit 4c95380701f5 ("sched/ext: Fold balance_scx() into
pick_task_scx()") which refactored the pick path making put_prev_task_scx()
the natural place to track task switches for SCX_KICK_WAIT. The fix moves
pnt_seq increment to put_prev_task_scx() and also increments it in
pick_task_scx() to handle cases where the same task is re-selected, whether
by BPF scheduler decision or slice refill. The semantics: If the current
task on the target CPU is SCX, SCX_KICK_WAIT waits until the CPU enters the
scheduling path. This provides sufficient guarantee for use cases like core
scheduling while keeping the operation self-contained within SCX.

v2: - Also increment pnt_seq in pick_task_scx() to handle same-task
      re-selection (Andrea Righi).
    - Use smp_cond_load_acquire() for the busy-wait loop for better
      architecture optimization (Peter Zijlstra).

Reported-by: Wen-Fang Liu <liuwenfang@honor.com>
Link: http://lkml.kernel.org/r/228ebd9e6ed3437996dffe15735a9caa@honor.com
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c          |   46 ++++++++++++++++++++++++--------------------
 kernel/sched/ext_internal.h |    6 +++--
 2 files changed, 30 insertions(+), 22 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2306,12 +2306,6 @@ static void switch_class(struct rq *rq,
 	struct scx_sched *sch = scx_root;
 	const struct sched_class *next_class = next->sched_class;
 
-	/*
-	 * Pairs with the smp_load_acquire() issued by a CPU in
-	 * kick_cpus_irq_workfn() who is waiting for this CPU to perform a
-	 * resched.
-	 */
-	smp_store_release(&rq->scx.pnt_seq, rq->scx.pnt_seq + 1);
 	if (!(sch->ops.flags & SCX_OPS_HAS_CPU_PREEMPT))
 		return;
 
@@ -2351,6 +2345,10 @@ static void put_prev_task_scx(struct rq
 			      struct task_struct *next)
 {
 	struct scx_sched *sch = scx_root;
+
+	/* see kick_cpus_irq_workfn() */
+	smp_store_release(&rq->scx.pnt_seq, rq->scx.pnt_seq + 1);
+
 	update_curr_scx(rq);
 
 	/* see dequeue_task_scx() on why we skip when !QUEUED */
@@ -2404,6 +2402,9 @@ static struct task_struct *pick_task_scx
 	bool keep_prev = rq->scx.flags & SCX_RQ_BAL_KEEP;
 	bool kick_idle = false;
 
+	/* see kick_cpus_irq_workfn() */
+	smp_store_release(&rq->scx.pnt_seq, rq->scx.pnt_seq + 1);
+
 	/*
 	 * WORKAROUND:
 	 *
@@ -5186,8 +5187,12 @@ static bool kick_one_cpu(s32 cpu, struct
 		}
 
 		if (cpumask_test_cpu(cpu, this_scx->cpus_to_wait)) {
-			pseqs[cpu] = rq->scx.pnt_seq;
-			should_wait = true;
+			if (cur_class == &ext_sched_class) {
+				pseqs[cpu] = rq->scx.pnt_seq;
+				should_wait = true;
+			} else {
+				cpumask_clear_cpu(cpu, this_scx->cpus_to_wait);
+			}
 		}
 
 		resched_curr(rq);
@@ -5248,18 +5253,19 @@ static void kick_cpus_irq_workfn(struct
 	for_each_cpu(cpu, this_scx->cpus_to_wait) {
 		unsigned long *wait_pnt_seq = &cpu_rq(cpu)->scx.pnt_seq;
 
-		if (cpu != cpu_of(this_rq)) {
-			/*
-			 * Pairs with smp_store_release() issued by this CPU in
-			 * switch_class() on the resched path.
-			 *
-			 * We busy-wait here to guarantee that no other task can
-			 * be scheduled on our core before the target CPU has
-			 * entered the resched path.
-			 */
-			while (smp_load_acquire(wait_pnt_seq) == pseqs[cpu])
-				cpu_relax();
-		}
+		/*
+		 * Busy-wait until the task running at the time of kicking is no
+		 * longer running. This can be used to implement e.g. core
+		 * scheduling.
+		 *
+		 * smp_cond_load_acquire() pairs with store_releases in
+		 * pick_task_scx() and put_prev_task_scx(). The former breaks
+		 * the wait if SCX's scheduling path is entered even if the same
+		 * task is picked subsequently. The latter is necessary to break
+		 * the wait when $cpu is taken by a higher sched class.
+		 */
+		if (cpu != cpu_of(this_rq))
+			smp_cond_load_acquire(wait_pnt_seq, VAL != pseqs[cpu]);
 
 		cpumask_clear_cpu(cpu, this_scx->cpus_to_wait);
 	}
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -986,8 +986,10 @@ enum scx_kick_flags {
 	SCX_KICK_PREEMPT	= 1LLU << 1,
 
 	/*
-	 * Wait for the CPU to be rescheduled. The scx_bpf_kick_cpu() call will
-	 * return after the target CPU finishes picking the next task.
+	 * The scx_bpf_kick_cpu() call will return after the current SCX task of
+	 * the target CPU switches out. This can be used to implement e.g. core
+	 * scheduling. This has no effect if the current task on the target CPU
+	 * is not on SCX.
 	 */
 	SCX_KICK_WAIT		= 1LLU << 2,
 };


