Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31840442FD1;
	Wed,  9 Sep 2026 13:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961885; cv=none; b=AHLwGAwx64nooMbtUPIedIpmrJiX5OL5mEpVJa3Ihl/iS7gauNoWf4SGeIABdHV+Qsgma7rmDxxMgyH9eYUwqFia+PUJH+lJIaV5WQ4JKNqk6vPl/u1AZdP/Tc3qMC4YI6kFOSTTu96aAwfSzEhdmRKd0o6t+BEtRYJuT6eRvXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961885; c=relaxed/simple;
	bh=aAH/0ZBVtmw2fy6n5BNUUvTXnM65URD5YfopJZQlJws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg7AVVCYVLjzH09G7G1JKp/EabszNxLLOqQ7J8zoA71okXzg25iQky9QjrLqVEe8TkUxmIz1LhfYx/ee7JBUoBaJK4JpdBKvDMn1r+SNBtBhoXwHYBfVDP98pPPjTB+CH9htzkdGr4tWqF7ZYIa09OLXthRYlmf2X38i73OOGw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0cl/4vd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0cl/4vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B731F00A3A;
	Wed,  9 Sep 2026 13:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961884;
	bh=goR8HRD0HZ32J57SjHnLZICmPotf0ZDGOYH/Ma7ktSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0cl/4vdxzwO/4r3ABsIKLRuQqfCUdp9qW1WQTqYoiSCaJzjZ+5qEzSViImB6hw6t
	 ZuQtwXan6eGKh65682hsP4Y9W+6XE2Fe/jtuqZv563LsLF9zCRPw4Ttk6IZztR3KVh
	 pbV5dM051GI5TBrkA2rBFKF6oB3de3XWIvVIO5eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Kai <yaokai34@huawei.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 099/556] futex: Provide rt_mutex_.*_schedule() equivalents for futex scheduling
Date: Wed,  9 Sep 2026 15:36:19 +0200
Message-ID: <20260909134233.983894648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 912edebe8501a36c6bedcef03bd238ab90a7e060 upstream.

There is rt_mutex_{pre|post}_schedule() around
rt_mutex_wait_proxy_lock() to ensure that sched_submit_work()/
sched_update_worker() is invoked before we schedule out and block on
rt_mutex while waiting for it become available.

The reason is that blocking on rt_mutex assigns a pi_waiter for the PI
chain and sched_submit_work() will also assign a pi_waiter if it blocks
on lock but a this point we already have a waiter assigned.
We can't skip sched_submit_work() entirely because I/O relies on the
fact that I/O queue is flushed while it blocks on a sleeping lock.
Therefore sched_submit_work() is moved before we block on the lock.

Sleeping lock in this context means mutex or rw_semaphore not spinlock_t
on PREEMPT_RT. Because the mutex abstraction on PREEMPT_RT uses the same
abstraction as the futex proxy lock, the futex code ended up using
rt_mutex_{pre|post}_schedule(), too.
Using it is/ was just to keep the task_struct::sched_rt_mutex assertion
happy. Futex proxy lock is used only in the syscall context of a task.
At this point it never got any I/O that needs to be flushed and it can't
be a workqueue that needs to notify that it will be scheduled out.
Therefore sched_submit_work() does nothing here.

By mistake futex_wait_requeue_pi() -> rt_mutex_wait_proxy_lock() did not
get the rt_mutex_{pre|post}_schedule() annotation. This was not noticed
because in this callchain the lock is (usually) not contended and so
rt_mutex_slowlock_block() does not schedule, triggering the assert.

Adding rt_mutex_pre_schedule() here looks wrong (as noted by PeterZ)
because at this point there is a pi_waiter recorded and invoking
sched_submit_work() with a possible lock contention would be wrong.

Add rt_mutex_futex_{pre|post}_schedule() which toggles the
sched_rt_mutex assert and does not involve sched_submit_work(). Add
asserts here to ensure that sched_submit_work() would do nothing. Use it
only in futex proxy lock case which is rt_mutex_wait_proxy_lock().
Remove it from futex_lock_pi().

Fixes: d14f9e930b90 ("locking/rtmutex: Use rt_mutex specific scheduler helpers")
Reported-by: Yao Kai <yaokai34@huawei.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901135453.3121948-2-bigeasy@linutronix.de
Closes: https://lore.kernel.org/all/20260717084922.4153317-2-yaokai34@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/rt.h     |    2 ++
 kernel/futex/pi.c            |   16 +++-------------
 kernel/locking/rtmutex_api.c |    2 ++
 kernel/sched/core.c          |   16 ++++++++++++++++
 4 files changed, 23 insertions(+), 13 deletions(-)

--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -52,8 +52,10 @@ static inline bool rt_or_dl_task_policy(
 
 #ifdef CONFIG_RT_MUTEXES
 extern void rt_mutex_pre_schedule(void);
+extern void rt_mutex_futex_pre_schedule(void);
 extern void rt_mutex_schedule(void);
 extern void rt_mutex_post_schedule(void);
+extern void rt_mutex_futex_post_schedule(void);
 
 /*
  * Must hold either p->pi_lock or task_rq(p)->lock.
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -1070,17 +1070,11 @@ retry_private:
 		 * Caution; releasing @hb in-scope. The hb->lock is still locked
 		 * while the reference is dropped. The reference can not be dropped
 		 * after the unlock because if a user initiated resize is in progress
-		 * then we might need to wake him. This can not be done after the
-		 * rt_mutex_pre_schedule() invocation. The hb will remain valid because
-		 * the thread, performing resize, will block on hb->lock during
-		 * the requeue.
+		 * then we might need to wake him. The hb will remain valid
+		 * because the thread, performing resize, will block on
+		 * hb->lock during the requeue.
 		 */
 		futex_private_hash_put(no_free_ptr(hbr.fph));
-		/*
-		 * Must be done before we enqueue the waiter, here is unfortunately
-		 * under the hb lock, but that *should* work because it does nothing.
-		 */
-		rt_mutex_pre_schedule();
 
 		rt_mutex_init_waiter(&rt_waiter);
 
@@ -1146,10 +1140,6 @@ cleanup:
 		 * the
 		 */
 		futex_q_lockptr_lock(&q);
-		/*
-		 * Waiter is unqueued.
-		 */
-		rt_mutex_post_schedule();
 no_block:
 		/*
 		 * Fixup the pi_state owner and possibly acquire the lock if we
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -423,6 +423,7 @@ int __sched rt_mutex_wait_proxy_lock(str
 {
 	int ret;
 
+	rt_mutex_futex_pre_schedule();
 	raw_spin_lock_irq(&lock->wait_lock);
 	/* sleep on the mutex */
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -433,6 +434,7 @@ int __sched rt_mutex_wait_proxy_lock(str
 	 */
 	fixup_rt_mutex_waiters(lock, true);
 	raw_spin_unlock_irq(&lock->wait_lock);
+	rt_mutex_futex_post_schedule();
 
 	return ret;
 }
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7633,6 +7633,17 @@ void rt_mutex_pre_schedule(void)
 	sched_submit_work(current);
 }
 
+/*
+ * Used within the futex syscall context, skips sched_submit_work() because none
+ * its work will be done. Asserts ensure that it is indeed the case.
+ */
+void rt_mutex_futex_pre_schedule(void)
+{
+	lockdep_assert(!(current->flags & (PF_WQ_WORKER | PF_IO_WORKER)));
+	lockdep_assert(!current->plug);
+	lockdep_assert(!fetch_and_set(current->sched_rt_mutex, 1));
+}
+
 void rt_mutex_schedule(void)
 {
 	lockdep_assert(current->sched_rt_mutex);
@@ -7645,6 +7656,11 @@ void rt_mutex_post_schedule(void)
 	lockdep_assert(fetch_and_set(current->sched_rt_mutex, 0));
 }
 
+void rt_mutex_futex_post_schedule(void)
+{
+	lockdep_assert(fetch_and_set(current->sched_rt_mutex, 0));
+}
+
 /*
  * rt_mutex_setprio - set the current priority of a task
  * @p: task to boost


