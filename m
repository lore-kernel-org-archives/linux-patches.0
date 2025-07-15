Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638122E7BAC;
	Tue, 15 Jul 2025 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586690; cv=none; b=enwI/ulaFZVBYYn40ircY2A8GPxAjiAiO7nzrIXeTEf4/OPtqDMydhg2aUoXuGVxW+Wudd6FT1vVElFZhiR0u18WWA5InhnqWKefVLdgpWUs9eP7rhthu2x/bKinbnq672a1xmu3yJx1zy3Z+Et0d4wvU+czUgv9FO+31mf4084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586690; c=relaxed/simple;
	bh=Czh097WTwcv+zAUbviEpc+KlFL6V5mfpagU27oMjN7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0QgHnwSL2nNAL2Bd5Pysdymm5H50WB1gGKUHJZd5pu7ePMgz/LpSoSoPAb6a/0XOhRYToBVCIk9thL4bLqm1vbDEDEdSplTxKDYM+Y7BFfFy2dqwXjXrnKB0xXBPf2FU6qtz08gU1TPvf7E3h0kJvgrbLi1+fhDRlWnK7v+8xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6z8Y2OB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6z8Y2OB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD0FC4CEE3;
	Tue, 15 Jul 2025 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586690;
	bh=Czh097WTwcv+zAUbviEpc+KlFL6V5mfpagU27oMjN7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6z8Y2OBM4KkYAxgs47JzZIfUwpYwqXvp1vhVCZ2wfldRoXHON30RkrKi7dqAGP3l
	 AFdmz69M/oVhIcrp5we8bqCmJTzq+Vdj9KHMxEUed/+01mgDjVQv2x/XHJp7s2agMc
	 k25wI1+56n6OSXaLgnnEpuFeTu0oRynNd3fJt80U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuyo Chang <kuyo.chang@mediatek.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 012/192] sched/core: Fix migrate_swap() vs. hotplug
Date: Tue, 15 Jul 2025 15:11:47 +0200
Message-ID: <20250715130815.355276842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 009836b4fa52f92cba33618e773b1094affa8cd2 ]

On Mon, Jun 02, 2025 at 03:22:13PM +0800, Kuyo Chang wrote:

> So, the potential race scenario is:
>
> 	CPU0							CPU1
> 	// doing migrate_swap(cpu0/cpu1)
> 	stop_two_cpus()
> 							  ...
> 							 // doing _cpu_down()
> 							      sched_cpu_deactivate()
> 								set_cpu_active(cpu, false);
> 								balance_push_set(cpu, true);
> 	cpu_stop_queue_two_works
> 	    __cpu_stop_queue_work(stopper1,...);
> 	    __cpu_stop_queue_work(stopper2,..);
> 	stop_cpus_in_progress -> true
> 		preempt_enable();
> 								...
> 							1st balance_push
> 							stop_one_cpu_nowait
> 							cpu_stop_queue_work
> 							__cpu_stop_queue_work
> 							list_add_tail  -> 1st add push_work
> 							wake_up_q(&wakeq);  -> "wakeq is empty.
> 										This implies that the stopper is at wakeq@migrate_swap."
> 	preempt_disable
> 	wake_up_q(&wakeq);
> 	        wake_up_process // wakeup migrate/0
> 		    try_to_wake_up
> 		        ttwu_queue
> 		            ttwu_queue_cond ->meet below case
> 		                if (cpu == smp_processor_id())
> 			         return false;
> 			ttwu_do_activate
> 			//migrate/0 wakeup done
> 		wake_up_process // wakeup migrate/1
> 	           try_to_wake_up
> 		    ttwu_queue
> 			ttwu_queue_cond
> 		        ttwu_queue_wakelist
> 			__ttwu_queue_wakelist
> 			__smp_call_single_queue
> 	preempt_enable();
>
> 							2nd balance_push
> 							stop_one_cpu_nowait
> 							cpu_stop_queue_work
> 							__cpu_stop_queue_work
> 							list_add_tail  -> 2nd add push_work, so the double list add is detected
> 							...
> 							...
> 							cpu1 get ipi, do sched_ttwu_pending, wakeup migrate/1
>

So this balance_push() is part of schedule(), and schedule() is supposed
to switch to stopper task, but because of this race condition, stopper
task is stuck in WAKING state and not actually visible to be picked.

Therefore CPU1 can do another schedule() and end up doing another
balance_push() even though the last one hasn't been done yet.

This is a confluence of fail, where both wake_q and ttwu_wakelist can
cause crucial wakeups to be delayed, resulting in the malfunction of
balance_push.

Since there is only a single stopper thread to be woken, the wake_q
doesn't really add anything here, and can be removed in favour of
direct wakeups of the stopper thread.

Then add a clause to ttwu_queue_cond() to ensure the stopper threads
are never queued / delayed.

Of all 3 moving parts, the last addition was the balance_push()
machinery, so pick that as the point the bug was introduced.

Fixes: 2558aacff858 ("sched/hotplug: Ensure only per-cpu kthreads run during hotplug")
Reported-by: Kuyo Chang <kuyo.chang@mediatek.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kuyo Chang <kuyo.chang@mediatek.com>
Link: https://lkml.kernel.org/r/20250605100009.GO39944@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c   |  5 +++++
 kernel/stop_machine.c | 20 ++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 39fac649aa142..566fbf0c1b0b2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3935,6 +3935,11 @@ static inline bool ttwu_queue_cond(struct task_struct *p, int cpu)
 	if (!scx_allow_ttwu_queue(p))
 		return false;
 
+#ifdef CONFIG_SMP
+	if (p->sched_class == &stop_sched_class)
+		return false;
+#endif
+
 	/*
 	 * Do not complicate things with the async wake_list while the CPU is
 	 * in hotplug state.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 5d2d0562115b3..3fe6b0c99f3d8 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -82,18 +82,15 @@ static void cpu_stop_signal_done(struct cpu_stop_done *done)
 }
 
 static void __cpu_stop_queue_work(struct cpu_stopper *stopper,
-					struct cpu_stop_work *work,
-					struct wake_q_head *wakeq)
+				  struct cpu_stop_work *work)
 {
 	list_add_tail(&work->list, &stopper->works);
-	wake_q_add(wakeq, stopper->thread);
 }
 
 /* queue @work to @stopper.  if offline, @work is completed immediately */
 static bool cpu_stop_queue_work(unsigned int cpu, struct cpu_stop_work *work)
 {
 	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
-	DEFINE_WAKE_Q(wakeq);
 	unsigned long flags;
 	bool enabled;
 
@@ -101,12 +98,13 @@ static bool cpu_stop_queue_work(unsigned int cpu, struct cpu_stop_work *work)
 	raw_spin_lock_irqsave(&stopper->lock, flags);
 	enabled = stopper->enabled;
 	if (enabled)
-		__cpu_stop_queue_work(stopper, work, &wakeq);
+		__cpu_stop_queue_work(stopper, work);
 	else if (work->done)
 		cpu_stop_signal_done(work->done);
 	raw_spin_unlock_irqrestore(&stopper->lock, flags);
 
-	wake_up_q(&wakeq);
+	if (enabled)
+		wake_up_process(stopper->thread);
 	preempt_enable();
 
 	return enabled;
@@ -264,7 +262,6 @@ static int cpu_stop_queue_two_works(int cpu1, struct cpu_stop_work *work1,
 {
 	struct cpu_stopper *stopper1 = per_cpu_ptr(&cpu_stopper, cpu1);
 	struct cpu_stopper *stopper2 = per_cpu_ptr(&cpu_stopper, cpu2);
-	DEFINE_WAKE_Q(wakeq);
 	int err;
 
 retry:
@@ -300,8 +297,8 @@ static int cpu_stop_queue_two_works(int cpu1, struct cpu_stop_work *work1,
 	}
 
 	err = 0;
-	__cpu_stop_queue_work(stopper1, work1, &wakeq);
-	__cpu_stop_queue_work(stopper2, work2, &wakeq);
+	__cpu_stop_queue_work(stopper1, work1);
+	__cpu_stop_queue_work(stopper2, work2);
 
 unlock:
 	raw_spin_unlock(&stopper2->lock);
@@ -316,7 +313,10 @@ static int cpu_stop_queue_two_works(int cpu1, struct cpu_stop_work *work1,
 		goto retry;
 	}
 
-	wake_up_q(&wakeq);
+	if (!err) {
+		wake_up_process(stopper1->thread);
+		wake_up_process(stopper2->thread);
+	}
 	preempt_enable();
 
 	return err;
-- 
2.39.5



