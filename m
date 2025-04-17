Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12037256C96;
	Thu, 17 Apr 2025 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915182; cv=none; b=CpowaRvAm0O1xzaWMupUkcCUr866PuKfkJg9CIbUotTW5KhiZ+4V3J9ADpSXYELmehE1SnC3tKYk0eyT/WdGH6MHdEeSNYoZDP/zGsaXG5hb0+Jez5w9StYrTYUZdiDNwp42JsIqVN/rIKIe68aqXfaIkic4tW3UJ02hSFGu0MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915182; c=relaxed/simple;
	bh=vnCNVW1HVrj7YTlfR+8Ai2ykvmrOqYtG+lyFvBe4oS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxk8dDNpt1OYuDrTsaInOPFrFNdosbgKxQBSrgX8EAxcNfzRU8HQrcj2BNm50fx0jKPBMA5yJCVmvIrXGVdGLYnJj8wN9YoQEzDjlHi8Hms/1lcE2I5Kouo3NuQIqW4CLvYdSswrhQXFbf+zvqKH70KRQ7r+Fk1JMiadHj0tZ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5R3gV58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5R3gV58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C17DC4CEE4;
	Thu, 17 Apr 2025 18:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915181;
	bh=vnCNVW1HVrj7YTlfR+8Ai2ykvmrOqYtG+lyFvBe4oS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5R3gV58yA/rDSDhu0hZFA9qd4s6G9+gYWN+GXrOIeidGrsTDF2c72NNpw/u9sQaY
	 IGPIfvdT1AjoMED0oyWOcV4zYsBx2BvCfJKJD+S6H1+998giVwzyGRawLvQL/+kpX3
	 D1tYwDlHF3r2yfNAaS3oRopETU1PhORkMH3gaNm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yi Lai" <yi1.lai@linux.intel.com>,
	syzbot+3c4321e10eea460eb606@syzkaller.appspotmail.com,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/393] perf: Fix hang while freeing sigtrap event
Date: Thu, 17 Apr 2025 19:47:33 +0200
Message-ID: <20250417175109.365658402@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 56799bc035658738f362acec3e7647bb84e68933 ]

Perf can hang while freeing a sigtrap event if a related deferred
signal hadn't managed to be sent before the file got closed:

perf_event_overflow()
   task_work_add(perf_pending_task)

fput()
   task_work_add(____fput())

task_work_run()
    ____fput()
        perf_release()
            perf_event_release_kernel()
                _free_event()
                    perf_pending_task_sync()
                        task_work_cancel() -> FAILED
                        rcuwait_wait_event()

Once task_work_run() is running, the list of pending callbacks is
removed from the task_struct and from this point on task_work_cancel()
can't remove any pending and not yet started work items, hence the
task_work_cancel() failure and the hang on rcuwait_wait_event().

Task work could be changed to remove one work at a time, so a work
running on the current task can always cancel a pending one, however
the wait / wake design is still subject to inverted dependencies when
remote targets are involved, as pictured by Oleg:

T1                                                      T2

fd = perf_event_open(pid => T2->pid);                  fd = perf_event_open(pid => T1->pid);
close(fd)                                              close(fd)
    <IRQ>                                                  <IRQ>
    perf_event_overflow()                                  perf_event_overflow()
       task_work_add(perf_pending_task)                        task_work_add(perf_pending_task)
    </IRQ>                                                 </IRQ>
    fput()                                                 fput()
        task_work_add(____fput())                              task_work_add(____fput())

    task_work_run()                                        task_work_run()
        ____fput()                                             ____fput()
            perf_release()                                         perf_release()
                perf_event_release_kernel()                            perf_event_release_kernel()
                    _free_event()                                          _free_event()
                        perf_pending_task_sync()                               perf_pending_task_sync()
                            rcuwait_wait_event()                                   rcuwait_wait_event()

Therefore the only option left is to acquire the event reference count
upon queueing the perf task work and release it from the task work, just
like it was done before 3a5465418f5f ("perf: Fix event leak upon exec and file release")
but without the leaks it fixed.

Some adjustments are necessary to make it work:

* A child event might dereference its parent upon freeing. Care must be
  taken to release the parent last.

* Some places assuming the event doesn't have any reference held and
  therefore can be freed right away must instead put the reference and
  let the reference counting to its job.

Reported-by: "Yi Lai" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/Zx9Losv4YcJowaP%2F@ly-workstation/
Reported-by: syzbot+3c4321e10eea460eb606@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/673adf75.050a0220.87769.0024.GAE@google.com/
Fixes: 3a5465418f5f ("perf: Fix event leak upon exec and file release")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250304135446.18905-1-frederic@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  1 -
 kernel/events/core.c       | 64 +++++++++++---------------------------
 2 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index db6d281644447..0997077bcc52a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -833,7 +833,6 @@ struct perf_event {
 	struct irq_work			pending_disable_irq;
 	struct callback_head		pending_task;
 	unsigned int			pending_work;
-	struct rcuwait			pending_work_wait;
 
 	atomic_t			event_limit;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 255bae926f10a..97af53c43608e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5312,30 +5312,6 @@ static bool exclusive_event_installable(struct perf_event *event,
 static void perf_addr_filters_splice(struct perf_event *event,
 				       struct list_head *head);
 
-static void perf_pending_task_sync(struct perf_event *event)
-{
-	struct callback_head *head = &event->pending_task;
-
-	if (!event->pending_work)
-		return;
-	/*
-	 * If the task is queued to the current task's queue, we
-	 * obviously can't wait for it to complete. Simply cancel it.
-	 */
-	if (task_work_cancel(current, head)) {
-		event->pending_work = 0;
-		local_dec(&event->ctx->nr_no_switch_fast);
-		return;
-	}
-
-	/*
-	 * All accesses related to the event are within the same RCU section in
-	 * perf_pending_task(). The RCU grace period before the event is freed
-	 * will make sure all those accesses are complete by then.
-	 */
-	rcuwait_wait_event(&event->pending_work_wait, !event->pending_work, TASK_UNINTERRUPTIBLE);
-}
-
 /* vs perf_event_alloc() error */
 static void __free_event(struct perf_event *event)
 {
@@ -5388,7 +5364,6 @@ static void _free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending_irq);
 	irq_work_sync(&event->pending_disable_irq);
-	perf_pending_task_sync(event);
 
 	unaccount_event(event);
 
@@ -5481,10 +5456,17 @@ static void perf_remove_from_owner(struct perf_event *event)
 
 static void put_event(struct perf_event *event)
 {
+	struct perf_event *parent;
+
 	if (!atomic_long_dec_and_test(&event->refcount))
 		return;
 
+	parent = event->parent;
 	_free_event(event);
+
+	/* Matches the refcount bump in inherit_event() */
+	if (parent)
+		put_event(parent);
 }
 
 /*
@@ -5568,11 +5550,6 @@ int perf_event_release_kernel(struct perf_event *event)
 		if (tmp == child) {
 			perf_remove_from_context(child, DETACH_GROUP);
 			list_move(&child->child_list, &free_list);
-			/*
-			 * This matches the refcount bump in inherit_event();
-			 * this can't be the last reference.
-			 */
-			put_event(event);
 		} else {
 			var = &ctx->refcount;
 		}
@@ -5598,7 +5575,8 @@ int perf_event_release_kernel(struct perf_event *event)
 		void *var = &child->ctx->refcount;
 
 		list_del(&child->child_list);
-		free_event(child);
+		/* Last reference unless ->pending_task work is pending */
+		put_event(child);
 
 		/*
 		 * Wake any perf_event_free_task() waiting for this event to be
@@ -5609,7 +5587,11 @@ int perf_event_release_kernel(struct perf_event *event)
 	}
 
 no_ctx:
-	put_event(event); /* Must be the 'last' reference */
+	/*
+	 * Last reference unless ->pending_task work is pending on this event
+	 * or any of its children.
+	 */
+	put_event(event);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(perf_event_release_kernel);
@@ -6994,12 +6976,6 @@ static void perf_pending_task(struct callback_head *head)
 	struct perf_event *event = container_of(head, struct perf_event, pending_task);
 	int rctx;
 
-	/*
-	 * All accesses to the event must belong to the same implicit RCU read-side
-	 * critical section as the ->pending_work reset. See comment in
-	 * perf_pending_task_sync().
-	 */
-	rcu_read_lock();
 	/*
 	 * If we 'fail' here, that's OK, it means recursion is already disabled
 	 * and we won't recurse 'further'.
@@ -7010,9 +6986,8 @@ static void perf_pending_task(struct callback_head *head)
 		event->pending_work = 0;
 		perf_sigtrap(event);
 		local_dec(&event->ctx->nr_no_switch_fast);
-		rcuwait_wake_up(&event->pending_work_wait);
 	}
-	rcu_read_unlock();
+	put_event(event);
 
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
@@ -9935,6 +9910,7 @@ static int __perf_event_overflow(struct perf_event *event,
 		    !task_work_add(current, &event->pending_task, notify_mode)) {
 			event->pending_work = pending_id;
 			local_inc(&event->ctx->nr_no_switch_fast);
+			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 
 			event->pending_addr = 0;
 			if (valid_sample && (data->sample_flags & PERF_SAMPLE_ADDR))
@@ -12283,7 +12259,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	init_irq_work(&event->pending_irq, perf_pending_irq);
 	event->pending_disable_irq = IRQ_WORK_INIT_HARD(perf_pending_disable);
 	init_task_work(&event->pending_task, perf_pending_task);
-	rcuwait_init(&event->pending_work_wait);
 
 	mutex_init(&event->mmap_mutex);
 	raw_spin_lock_init(&event->addr_filters.lock);
@@ -13426,8 +13401,7 @@ perf_event_exit_event(struct perf_event *event, struct perf_event_context *ctx)
 		 * Kick perf_poll() for is_event_hup();
 		 */
 		perf_event_wakeup(parent_event);
-		free_event(event);
-		put_event(parent_event);
+		put_event(event);
 		return;
 	}
 
@@ -13545,13 +13519,11 @@ static void perf_free_event(struct perf_event *event,
 	list_del_init(&event->child_list);
 	mutex_unlock(&parent->child_mutex);
 
-	put_event(parent);
-
 	raw_spin_lock_irq(&ctx->lock);
 	perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
-	free_event(event);
+	put_event(event);
 }
 
 /*
-- 
2.39.5



