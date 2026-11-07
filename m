Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064969;
	b=I3Dp5dTb3c1jLajoU2ktPCbyyH/deivxJE8TIYZNB/x4eRZVGZHsbOBeoASEPTCpVPju
	 FdIhvUuhUhObdloA5ww3apED31d82tOwdpMLdU+IbPd159O6rJD04llVH7X+2hxmylt9e
	 WE4W5IBmK+VRts4WWCISNPXzs4O2ZXcOZbfChSiY+uNZ/8d2tVColFWqRwvMevtHne8Ll
	 rlMlLG4+Z6aqdAh8X1AJ6W/4ix+z1wBa3j47urlGSbA5lmKOoanLr8u6i/1XEtgTw8iO8
	 TvUOynTh8sXCm0dcTGO4Thto4GjYj6n331CHE+sltVKzd2/dKslIUuXoyYLrXvcRJEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYYjqieUsx8Fyv0lbgWHcZ4lHmVvj/mhVJtowPdZeNM=;
	b=yZXSVLkI0UrE9/CTDfgwIRmPaDkGMxCHyhiRjV2JD8tgneuYCm40Gy+bE+YCpCfp9TIL
	 eekEidviNTV3ZIJnpmqkTxhvyVEp5B4/pGTMvc90B+tyBo0MSSFINDi+NoXcoy02N32ek
	 9UBdiagO3nsJWO9tUG0Lc6f3jCDVxo74TDIr5gFscEa9yDzFt6MbGUBXoml/6XP5kaGqc
	 xgGhlYAIJZbpZw9p/q3qdrHENR8vG6v4YCf24nWILCh5cfEaYLP8kQ1Dfqi114YzlzcrX
	 LKbk3lIEAfzxJgUiPP9I2K/NOqnVJVxtvdPcgahPuY8MAWy3OMsmHMP1x3852zIMGFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Qo1uf3p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E0606A334;
	Sat,  7 Nov 2026 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Qo1uf3p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051461F0089F;
	Sat,  7 Nov 2026 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064969;
	bh=pYYjqieUsx8Fyv0lbgWHcZ4lHmVvj/mhVJtowPdZeNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Qo1uf3peucs33R+LPJy5DjwZllOAV4dQLeP882r0UbRPujqHOiA0UVa5yUwmAoU9
	 WvzrVsa5GIfbTuXP14/twxXUBbXSRxebM/EBzDCMwtc3zY+GALLVvOXsa8z8nwvbnV
	 25vvnBsQ046RBSbRa6uvrlSj9Z5gSpEW0KtPjadg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0851/1257] sched_ext: Dont leave balance callbacks queued across a pick retry
Date: Sat,  7 Nov 2026 08:52:27 -0500
Message-ID: <20261107135002.831593793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit ff0545e0c263727b200f60af47d0364e4d041bde ]

The dispatch path can request deferred work to be run from a balance
callback and pick_task_scx() queues rq->scx.deferred_bal_cb right after
dispatching. However, a balance callback must be consumed before the rq
lock is released and pick_task_scx() is not necessarily the end of the
pick:

 - it returns RETRY_TASK when a higher priority class task has been
   enqueued while the dispatch had the rq lock released;

 - the dl_server pick can return NULL, in which case the lower classes
   are picked next.

In both cases the callback stays queued while the core keeps picking,
and the rq lock can be released again, either by prev_balance() or by
another dispatch. For example, with an RT task as prev:

  __schedule()
    __pick_next_task()
      pick_task_scx()
        dispatch_pick()
          maybe_queue_balance_callback()    <- deferred_bal_cb queued
        return RETRY_TASK
      prev_balance()
        balance_rt()
          pull_rt_task()
            double_lock_balance()           <- rq lock released

Any CPU acquiring the rq lock in that window finds a pending balance
callback and triggers the following warning in rq_pin_lock():

  WARNING: kernel/sched/sched.h:1919 at rq_lock+0x7f/0xe0, CPU#10: stress-ng-sleep/533
  CPU: 10 UID: 0 PID: 533 Comm: stress-ng-sleep Not tainted 7.2.0-rc6-virtme #61 PREEMPT(full)
  Sched_ext: qmap (enabled+all)
  Call Trace:
   <IRQ>
   try_to_wake_up+0x2c1/0x5c0
   hrtimer_wakeup+0x22/0x30
   __hrtimer_run_queues+0x1d5/0x350
   hrtimer_interrupt+0x106/0x1e0
   __sysvec_apic_timer_interrupt+0x6f/0x210
   sysvec_apic_timer_interrupt+0x71/0x90
   </IRQ>

This can be reproduced running scx_qmap -I together with a SCHED_FIFO
workload that frequently sleeps, e.g.:

  $ vng -v --cpus 16 --memory 4G -- \
      'tools/sched_ext/build/bin/scx_qmap -I >/dev/null & \
       stress-ng --sleep 4 --sched fifo --sched-prio 1 -t 30 -q'

Fix this by queueing the balance callbacks only when the pick is final.
Otherwise, defer the pending work to the irq_work path, which doesn't
depend on the current rq lock section, and leave the kick sync wait
pending for the next pick.

Fixes: 4c95380701f5 ("sched/ext: Fold balance_scx() into pick_task_scx()")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 73 ++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 04167ed9b5803..8fc3f791c88f4 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3335,7 +3335,8 @@ static struct task_struct *first_local_task(struct rq *rq)
 }
 
 /*
- * Run dispatch and queue the follow-up work for a pick.
+ * Run dispatch for a pick. The follow-up work is queued by do_pick_task_scx()
+ * once the pick is final.
  */
 static enum scx_dsp_verdict dispatch_pick(struct rq *rq, struct rq_flags *rf,
 					  struct task_struct *prev)
@@ -3345,18 +3346,6 @@ static enum scx_dsp_verdict dispatch_pick(struct rq *rq, struct rq_flags *rf,
 	rq_unpin_lock(rq, rf);
 	verdict = dispatch_one(rq, prev);
 	rq_repin_lock(rq, rf);
-	maybe_queue_balance_callback(rq);
-
-	/*
-	 * Defer to a balance callback which can drop rq lock and enable IRQs.
-	 * Waiting directly in the pick path would deadlock against CPUs sending
-	 * us IPIs (e.g. TLB flushes) while we wait for them.
-	 */
-	if (unlikely(rq->scx.kick_sync_pending)) {
-		rq->scx.kick_sync_pending = false;
-		queue_balance_callback(rq, &rq->scx.kick_sync_bal_cb,
-				       kick_sync_wait_bal_cb);
-	}
 
 	return verdict;
 }
@@ -3383,16 +3372,8 @@ static enum scx_dsp_verdict dispatch_core_pick(struct rq *rq, struct rq_flags *r
 
 	verdict = dispatch_one(rq, prev);
 
-	if (cpu_of(rq) == smp_processor_id()) {
-		maybe_queue_balance_callback(rq);
-
-		/* see dispatch_pick() */
-		if (unlikely(rq->scx.kick_sync_pending)) {
-			rq->scx.kick_sync_pending = false;
-			queue_balance_callback(rq, &rq->scx.kick_sync_bal_cb,
-					       kick_sync_wait_bal_cb);
-		}
-	} else if (unlikely(rq->scx.flags & SCX_RQ_BAL_CB_PENDING)) {
+	if (cpu_of(rq) != smp_processor_id() &&
+	    unlikely(rq->scx.flags & SCX_RQ_BAL_CB_PENDING)) {
 		/*
 		 * Balance callbacks must run in the context that queued them,
 		 * so they can't be queued on another CPU's rq. Run the deferred
@@ -3435,8 +3416,10 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 	else
 		verdict = dispatch_pick(rq, rf, prev);
 
-	if (verdict == SCX_DSP_RETRY)
-		return RETRY_TASK;
+	if (verdict == SCX_DSP_RETRY) {
+		p = RETRY_TASK;
+		goto out;
+	}
 
 	/*
 	 * If any higher-priority sched class enqueued a runnable task on this
@@ -3446,8 +3429,10 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 	 * If @force_scx is true, always try to pick a SCHED_EXT task,
 	 * regardless of any higher-priority sched classes activity.
 	 */
-	if (!force_scx && rq_modified_above(rq, &ext_sched_class))
-		return RETRY_TASK;
+	if (!force_scx && rq_modified_above(rq, &ext_sched_class)) {
+		p = RETRY_TASK;
+		goto out;
+	}
 
 	/*
 	 * If we're keeping @prev, replenish slice if necessary and keep running
@@ -3463,7 +3448,7 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 	} else {
 		p = first_local_task(rq);
 		if (!p)
-			return NULL;
+			goto out;
 
 		if (unlikely(!p->scx.slice) && scx_task_can_stay_on_cpu(rq, p)) {
 			struct scx_sched *sch = scx_task_sched(p);
@@ -3478,6 +3463,38 @@ do_pick_task_scx(struct rq *rq, struct rq_flags *rf, bool force_scx)
 		}
 	}
 
+out:
+	if (cpu_of(rq) != smp_processor_id())
+		return p;
+
+	/*
+	 * Balance callbacks must be consumed before the rq lock is released, so
+	 * queue them only when the pick is final. On RETRY_TASK, or after a
+	 * NULL pick from the dl_server, the core continues picking and can
+	 * release the rq lock (e.g., prev_balance() or another dispatch). In
+	 * that case, run the deferred work from irq_work, which doesn't depend
+	 * on the current rq lock section, and leave the kick sync wait pending
+	 * for the next pick.
+	 */
+	if (p != RETRY_TASK && (p || !force_scx)) {
+		maybe_queue_balance_callback(rq);
+
+		/*
+		 * Defer to a balance callback which can drop rq lock and enable
+		 * IRQs. Waiting directly in the pick path would deadlock against
+		 * CPUs sending us IPIs (e.g., TLB flushes) while we wait for
+		 * them.
+		 */
+		if (unlikely(rq->scx.kick_sync_pending)) {
+			rq->scx.kick_sync_pending = false;
+			queue_balance_callback(rq, &rq->scx.kick_sync_bal_cb,
+					       kick_sync_wait_bal_cb);
+		}
+	} else if (rq->scx.flags & SCX_RQ_BAL_CB_PENDING) {
+		rq->scx.flags &= ~SCX_RQ_BAL_CB_PENDING;
+		schedule_deferred(rq);
+	}
+
 	return p;
 }
 
-- 
2.53.0



