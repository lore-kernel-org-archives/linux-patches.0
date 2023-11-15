Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8AB41212
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1fJynbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07AAC433CB;
	Wed, 15 Nov 2023 19:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076747;
	bh=u9sIIB+k9jPaRkC9kpCwByXk72BxYy/BwyRlu8qul5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1fJynbsKc3FP0eZaqSDGL11P6vx0Wqpfv5LAIoVc2xJ1x1EewsQbf0Nq5CeRLwt/
	 f7A9ARQYXmOCOTYTb+35/Nt0duqYCVGlV4pFbimob2L1FO/Qr+ninnysyNinBuiH3T
	 vJP+6Z5Jf1mNM+wOAEIXSsW710/yTkWCMvZphFBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kuyo=20Chang=20 ?= <Kuyo.Chang@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/603] sched: Fix stop_one_cpu_nowait() vs hotplug
Date: Wed, 15 Nov 2023 14:09:15 -0500
Message-ID: <20231115191613.856914331@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit f0498d2a54e7966ce23cd7c7ff42c64fa0059b07 ]

Kuyo reported sporadic failures on a sched_setaffinity() vs CPU
hotplug stress-test -- notably affine_move_task() remains stuck in
wait_for_completion(), leading to a hung-task detector warning.

Specifically, it was reported that stop_one_cpu_nowait(.fn =
migration_cpu_stop) returns false -- this stopper is responsible for
the matching complete().

The race scenario is:

	CPU0					CPU1

					// doing _cpu_down()

  __set_cpus_allowed_ptr()
    task_rq_lock();
					takedown_cpu()
					  stop_machine_cpuslocked(take_cpu_down..)

					<PREEMPT: cpu_stopper_thread()
					  MULTI_STOP_PREPARE
					  ...
    __set_cpus_allowed_ptr_locked()
      affine_move_task()
        task_rq_unlock();

  <PREEMPT: cpu_stopper_thread()\>
    ack_state()
					  MULTI_STOP_RUN
					    take_cpu_down()
					      __cpu_disable();
					      stop_machine_park();
						stopper->enabled = false;
					 />
   />
	stop_one_cpu_nowait(.fn = migration_cpu_stop);
          if (stopper->enabled) // false!!!

That is, by doing stop_one_cpu_nowait() after dropping rq-lock, the
stopper thread gets a chance to preempt and allows the cpu-down for
the target CPU to complete.

OTOH, since stop_one_cpu_nowait() / cpu_stop_queue_work() needs to
issue a wakeup, it must not be ran under the scheduler locks.

Solve this apparent contradiction by keeping preemption disabled over
the unlock + queue_stopper combination:

	preempt_disable();
	task_rq_unlock(...);
	if (!stop_pending)
	  stop_one_cpu_nowait(...)
	preempt_enable();

This respects the lock ordering contraints while still avoiding the
above race. That is, if we find the CPU is online under rq-lock, the
targeted stop_one_cpu_nowait() must succeed.

Apply this pattern to all similar stop_one_cpu_nowait() invocations.

Fixes: 6d337eab041d ("sched: Fix migrate_disable() vs set_cpus_allowed_ptr()")
Reported-by: "Kuyo Chang (張建文)" <Kuyo.Chang@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: "Kuyo Chang (張建文)" <Kuyo.Chang@mediatek.com>
Link: https://lkml.kernel.org/r/20231010200442.GA16515@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c     | 10 ++++++++--
 kernel/sched/deadline.c |  2 ++
 kernel/sched/fair.c     |  4 +++-
 kernel/sched/rt.c       |  4 ++++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 802551e0009bf..9e9a45a3394fe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2664,9 +2664,11 @@ static int migration_cpu_stop(void *data)
 		 * it.
 		 */
 		WARN_ON_ONCE(!pending->stop_pending);
+		preempt_disable();
 		task_rq_unlock(rq, p, &rf);
 		stop_one_cpu_nowait(task_cpu(p), migration_cpu_stop,
 				    &pending->arg, &pending->stop_work);
+		preempt_enable();
 		return 0;
 	}
 out:
@@ -2986,12 +2988,13 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 			complete = true;
 		}
 
+		preempt_disable();
 		task_rq_unlock(rq, p, rf);
-
 		if (push_task) {
 			stop_one_cpu_nowait(rq->cpu, push_cpu_stop,
 					    p, &rq->push_work);
 		}
+		preempt_enable();
 
 		if (complete)
 			complete_all(&pending->done);
@@ -3057,12 +3060,13 @@ static int affine_move_task(struct rq *rq, struct task_struct *p, struct rq_flag
 		if (flags & SCA_MIGRATE_ENABLE)
 			p->migration_flags &= ~MDF_PUSH;
 
+		preempt_disable();
 		task_rq_unlock(rq, p, rf);
-
 		if (!stop_pending) {
 			stop_one_cpu_nowait(cpu_of(rq), migration_cpu_stop,
 					    &pending->arg, &pending->stop_work);
 		}
+		preempt_enable();
 
 		if (flags & SCA_MIGRATE_ENABLE)
 			return 0;
@@ -9505,9 +9509,11 @@ static void balance_push(struct rq *rq)
 	 * Temporarily drop rq->lock such that we can wake-up the stop task.
 	 * Both preemption and IRQs are still disabled.
 	 */
+	preempt_disable();
 	raw_spin_rq_unlock(rq);
 	stop_one_cpu_nowait(rq->cpu, __balance_push_cpu_stop, push_task,
 			    this_cpu_ptr(&push_work));
+	preempt_enable();
 	/*
 	 * At this point need_resched() is true and we'll take the loop in
 	 * schedule(). The next pick is obviously going to be the stop task
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 58b542bf28934..d78f2e8769fb4 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2449,9 +2449,11 @@ static void pull_dl_task(struct rq *this_rq)
 		double_unlock_balance(this_rq, src_rq);
 
 		if (push_task) {
+			preempt_disable();
 			raw_spin_rq_unlock(this_rq);
 			stop_one_cpu_nowait(src_rq->cpu, push_cpu_stop,
 					    push_task, &src_rq->push_work);
+			preempt_enable();
 			raw_spin_rq_lock(this_rq);
 		}
 	}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4dee83c82ac33..1795f6fe991f3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11234,13 +11234,15 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
-			raw_spin_rq_unlock_irqrestore(busiest, flags);
 
+			preempt_disable();
+			raw_spin_rq_unlock_irqrestore(busiest, flags);
 			if (active_balance) {
 				stop_one_cpu_nowait(cpu_of(busiest),
 					active_load_balance_cpu_stop, busiest,
 					&busiest->active_balance_work);
 			}
+			preempt_enable();
 		}
 	} else {
 		sd->nr_balance_failed = 0;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 0597ba0f85ff3..904dd85345973 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2109,9 +2109,11 @@ static int push_rt_task(struct rq *rq, bool pull)
 		 */
 		push_task = get_push_task(rq);
 		if (push_task) {
+			preempt_disable();
 			raw_spin_rq_unlock(rq);
 			stop_one_cpu_nowait(rq->cpu, push_cpu_stop,
 					    push_task, &rq->push_work);
+			preempt_enable();
 			raw_spin_rq_lock(rq);
 		}
 
@@ -2448,9 +2450,11 @@ static void pull_rt_task(struct rq *this_rq)
 		double_unlock_balance(this_rq, src_rq);
 
 		if (push_task) {
+			preempt_disable();
 			raw_spin_rq_unlock(this_rq);
 			stop_one_cpu_nowait(src_rq->cpu, push_cpu_stop,
 					    push_task, &src_rq->push_work);
+			preempt_enable();
 			raw_spin_rq_lock(this_rq);
 		}
 	}
-- 
2.42.0



