Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17714BEE54;
	Sat, 12 Sep 2026 09:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205891; cv=none; b=Tf5j1lF7hwv9yLvHBob1svvE21YUjyl9srlLPoVC7HcQMzeJqfUHqbUH9Wivn8nfLon/Dz8MhVu/ZFROR2gWAgt1f0GH/enZYY4Fixklr4KA8SEa7jUA0YHMUI90gWbowAVHq5a0paqekKwdoIDEVHmXv4phYu/gKCAd8m41zVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205891; c=relaxed/simple;
	bh=t7C5EsdSYgULHOXPb61Qg0HNTZagd4PADY4HFtkLsO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7x2Rb/C0H5wynHZC+2+6UvYXYUMIQigGkgU9CTkh3FwXUR80CeEDBKZLgtKtuEnO+D2DVsegRA1N05BIAw6JB2kZXP08Wfh/9fR116rIDrDhF+XRDHvCblK1babZaLrgXkpIXWMBoSTZJq1y6YebAZ1fTJ0e5RfnrG1T8M1GQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oi2KrpDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oi2KrpDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1921F000FF;
	Sat, 12 Sep 2026 09:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205889;
	bh=sVwxtF0XmhC2+sP71fhMzNMAVzYNDkO99X0X6dusXDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oi2KrpDImO9lLr/r5GguE8imyv9EepU/3lICXsu+p/GKy8U/l9yvGG1pn8PePbk4k
	 I6ms5agKnUvAygVwyMWaYEBpbrTyRGVHUgctCnBW5N/MZ/2tlEc1QhCIy0AeKFqzfQ
	 bD++/4WvYcnFfo186hFMW1WGV2O+/9ncDty66NkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Kai <yaokai34@huawei.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0051/1518] futex: Provide rt_mutex_.*_schedule() equivalents for futex scheduling
Date: Sat, 12 Sep 2026 08:37:00 +0200
Message-ID: <20260912065624.596227864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 912edebe8501a36c6bedcef03bd238ab90a7e060 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
@@ -1064,17 +1064,11 @@ retry_private:
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
 
@@ -1140,10 +1134,6 @@ cleanup:
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
@@ -398,6 +398,7 @@ int __sched rt_mutex_wait_proxy_lock(str
 {
 	int ret;
 
+	rt_mutex_futex_pre_schedule();
 	raw_spin_lock_irq(&lock->wait_lock);
 	/* sleep on the mutex */
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -408,6 +409,7 @@ int __sched rt_mutex_wait_proxy_lock(str
 	 */
 	fixup_rt_mutex_waiters(lock, true);
 	raw_spin_unlock_irq(&lock->wait_lock);
+	rt_mutex_futex_post_schedule();
 
 	return ret;
 }
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7333,6 +7333,17 @@ void rt_mutex_pre_schedule(void)
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
@@ -7345,6 +7356,11 @@ void rt_mutex_post_schedule(void)
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


