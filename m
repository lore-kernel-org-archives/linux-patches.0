Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE0B155CB3;
	Tue, 30 Jul 2024 16:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358072; cv=none; b=V0NeKPtBxxxZYZzZ0lLYAJ6BcOtrzxcgwsd990eWcLk3HBY8SqN1WEP3v9BYjBxh/2zQYoZUtzqoIwBbWcfK5SxdO0TkiwIzEV+r+FmXwcwTIKJ8D9WkClF2CBV/GOJJN58arW2mTf4fYi81eWKTxTsDdTF1tGrZ+M3FtTnIRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358072; c=relaxed/simple;
	bh=pFc2vcvN6eKvToeWsK5adQOVCxzUUZ4AglReaMsnBWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqckY5BUbusz/xptTaZNpAIZY2bHYMaMaES2/wY0EvU5RC/Xvxo+l2cWZfzotNi8frwdOqnZHcBkHb3www0CgW9LVvM8S741BWbc3qUaQy9CCMI8NUPuhuymkHIi8gfDNAskjAUaLYnn7ISfN6/H4VVYYNLHRMzADmTbOwa3pts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+36V8ZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+36V8ZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68498C4AF0E;
	Tue, 30 Jul 2024 16:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358071;
	bh=pFc2vcvN6eKvToeWsK5adQOVCxzUUZ4AglReaMsnBWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+36V8ZMe2eco+gPZd9QM5aeHF3jVGSZozXAntwMR/sRRNRh8Vsor3YOp0EAaoB2W
	 fMms2Tum5EP+nePEYXWG090Ep2zwvNvV85eLNjQp1KrUfQ7b6p4yf5InCCoWwTrnkH
	 srOTuTey1X1pdHhbTEX7xOT4tVXql1Dk+vhk9r3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 354/440] perf: Fix event leak upon exec and file release
Date: Tue, 30 Jul 2024 17:49:47 +0200
Message-ID: <20240730151629.645432940@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit 3a5465418f5fd970e86a86c7f4075be262682840 upstream.

The perf pending task work is never waited upon the matching event
release. In the case of a child event, released via free_event()
directly, this can potentially result in a leaked event, such as in the
following scenario that doesn't even require a weak IRQ work
implementation to trigger:

schedule()
   prepare_task_switch()
=======> <NMI>
      perf_event_overflow()
         event->pending_sigtrap = ...
         irq_work_queue(&event->pending_irq)
<======= </NMI>
      perf_event_task_sched_out()
          event_sched_out()
              event->pending_sigtrap = 0;
              atomic_long_inc_not_zero(&event->refcount)
              task_work_add(&event->pending_task)
   finish_lock_switch()
=======> <IRQ>
   perf_pending_irq()
      //do nothing, rely on pending task work
<======= </IRQ>

begin_new_exec()
   perf_event_exit_task()
      perf_event_exit_event()
         // If is child event
         free_event()
            WARN(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1)
            // event is leaked

Similar scenarios can also happen with perf_event_remove_on_exec() or
simply against concurrent perf_event_release().

Fix this with synchonizing against the possibly remaining pending task
work while freeing the event, just like is done with remaining pending
IRQ work. This means that the pending task callback neither need nor
should hold a reference to the event, preventing it from ever beeing
freed.

Fixes: 517e6a301f34 ("perf: Fix perf_pending_task() UaF")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240621091601.18227-5-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -765,6 +765,7 @@ struct perf_event {
 	struct irq_work			pending_irq;
 	struct callback_head		pending_task;
 	unsigned int			pending_work;
+	struct rcuwait			pending_work_wait;
 
 	atomic_t			event_limit;
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2320,7 +2320,6 @@ event_sched_out(struct perf_event *event
 		if (state != PERF_EVENT_STATE_OFF &&
 		    !event->pending_work &&
 		    !task_work_add(current, &event->pending_task, TWA_RESUME)) {
-			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
 			event->pending_work = 1;
 		} else {
 			local_dec(&event->ctx->nr_pending);
@@ -5004,9 +5003,35 @@ static bool exclusive_event_installable(
 static void perf_addr_filters_splice(struct perf_event *event,
 				       struct list_head *head);
 
+static void perf_pending_task_sync(struct perf_event *event)
+{
+	struct callback_head *head = &event->pending_task;
+
+	if (!event->pending_work)
+		return;
+	/*
+	 * If the task is queued to the current task's queue, we
+	 * obviously can't wait for it to complete. Simply cancel it.
+	 */
+	if (task_work_cancel(current, head)) {
+		event->pending_work = 0;
+		local_dec(&event->ctx->nr_pending);
+		return;
+	}
+
+	/*
+	 * All accesses related to the event are within the same
+	 * non-preemptible section in perf_pending_task(). The RCU
+	 * grace period before the event is freed will make sure all
+	 * those accesses are complete by then.
+	 */
+	rcuwait_wait_event(&event->pending_work_wait, !event->pending_work, TASK_UNINTERRUPTIBLE);
+}
+
 static void _free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending_irq);
+	perf_pending_task_sync(event);
 
 	unaccount_event(event);
 
@@ -6637,23 +6662,27 @@ static void perf_pending_task(struct cal
 	int rctx;
 
 	/*
+	 * All accesses to the event must belong to the same implicit RCU read-side
+	 * critical section as the ->pending_work reset. See comment in
+	 * perf_pending_task_sync().
+	 */
+	preempt_disable_notrace();
+	/*
 	 * If we 'fail' here, that's OK, it means recursion is already disabled
 	 * and we won't recurse 'further'.
 	 */
-	preempt_disable_notrace();
 	rctx = perf_swevent_get_recursion_context();
 
 	if (event->pending_work) {
 		event->pending_work = 0;
 		perf_sigtrap(event);
 		local_dec(&event->ctx->nr_pending);
+		rcuwait_wake_up(&event->pending_work_wait);
 	}
 
 	if (rctx >= 0)
 		perf_swevent_put_recursion_context(rctx);
 	preempt_enable_notrace();
-
-	put_event(event);
 }
 
 #ifdef CONFIG_GUEST_PERF_EVENTS
@@ -11779,6 +11808,7 @@ perf_event_alloc(struct perf_event_attr
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending_irq, perf_pending_irq);
 	init_task_work(&event->pending_task, perf_pending_task);
+	rcuwait_init(&event->pending_work_wait);
 
 	mutex_init(&event->mmap_mutex);
 	raw_spin_lock_init(&event->addr_filters.lock);


