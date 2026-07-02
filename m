Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8351C695;
	Thu,  2 Jul 2026 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011553; cv=none; b=FPKWoZMZxQUZOHmHDypoFQ6ZZxLaL7CdM6Oulb3KaXERIYLcYiI+JvYzJVQgmQNflDPIxvlT1bPI5kwfeP45cPhWyY0G49+xqMfiDBC7Tv9sF/qoGJv/38f1rR3RV9W3zx1HHPFaO3Nl/3Z+AlZY7B3jFHuTu2nJSW3r7CsfAvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011553; c=relaxed/simple;
	bh=1QxFBqwqM9oTPrC+0c+R4Kj4brC15eFzttEKGS7Y77Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOnRBRPo6rPha4PRHFoFOqPrIW9ohX2g9wey4Qa6LNDVzEAowPdgvczCX1pnW6ugze3lNxH2M4SLsHVUtxUGPYHkVaEx1blGu8yVUCJt15vY8X8lie3YxTuQPmh6EIIi55CEyyJxXUhzIz2oPry/VkSoMjWIOMHpG3BR2Dg4dgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGshz5ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGshz5ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512A31F00A3D;
	Thu,  2 Jul 2026 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011551;
	bh=F1BKvFye3UOOxb3F4bbHY9OZk3Lm0NNbuLWbLy/yP6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGshz5utmJ3K1ouoaDPkbn8xZK0HfKB1LE2wmETyR/yWzgJLQjsYs8H4UREe8fWJt
	 0LNE5YRFJGXGEXHTpxRiar5T5iHr9lRznbTOaanXrqfmTy6NDyxRiZH0ea9bPugpog
	 oXQB7PACF7v/eYBl2yn3qRTBSVY+VMMGjq8W8lvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 041/120] block: invalidate cached plug timestamp after task switch
Date: Thu,  2 Jul 2026 18:20:37 +0200
Message-ID: <20260702155113.811489696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Usama Arif <usama.arif@linux.dev>

commit fad156c2af227f42ca796cbb20ddc354a6dd9932 upstream.

blk_time_get_ns() caches ktime_get_ns() in current->plug->cur_ktime
and marks the task with PF_BLOCK_TS. That cache is only valid while the
task keeps running; if the task is switched out, wall-clock time
advances and the cached value must not be reused when the task runs again.

The existing invalidation covers explicit plug flushes through
__blk_flush_plug(), and the schedule() / rtmutex paths through
sched_update_worker(). It does not cover in-kernel preemption paths such
as preempt_schedule(), preempt_schedule_notrace(), and
preempt_schedule_irq(), which enter __schedule(SM_PREEMPT) directly and
return without calling sched_update_worker().

As a result, a task preempted while holding a plug with PF_BLOCK_TS set
can reuse a stale plug->cur_ktime after it is scheduled back in. blk-iocost
then consumes that stale timestamp through ioc_now(), producing stale vnow
values for throttle decisions, and through ioc_rqos_done(), inflating
on-queue time and feeding false missed-QoS samples into vrate
adjustment.

Move the schedule-side invalidation to finish_task_switch(), which runs
for the scheduled-in task after every actual context switch regardless
of which schedule entry point was used. Keep __blk_flush_plug() as the
explicit flush/finish-plug invalidation path, and remove only the
PF_BLOCK_TS handling from sched_update_worker().

Fixes: 06b23f92af87 ("block: update cached timestamp post schedule/preemption")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Link: https://patch.msgid.link/20260616141604.328820-3-usama.arif@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h |   18 +++++++-----------
 kernel/sched/core.c    |   12 ++++++++----
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1214,16 +1214,12 @@ static inline void blk_flush_plug(struct
 		__blk_flush_plug(plug, async);
 }
 
-/*
- * tsk == current here
- */
-static inline void blk_plug_invalidate_ts(struct task_struct *tsk)
-{
-	struct blk_plug *plug = tsk->plug;
-
-	if (plug)
-		plug->cur_ktime = 0;
-	current->flags &= ~PF_BLOCK_TS;
+static __always_inline void blk_plug_invalidate_ts(void)
+{
+	if (unlikely(current->flags & PF_BLOCK_TS)) {
+		current->plug->cur_ktime = 0;
+		current->flags &= ~PF_BLOCK_TS;
+	}
 }
 
 int blkdev_issue_flush(struct block_device *bdev);
@@ -1249,7 +1245,7 @@ static inline void blk_flush_plug(struct
 {
 }
 
-static inline void blk_plug_invalidate_ts(struct task_struct *tsk)
+static inline void blk_plug_invalidate_ts(void)
 {
 }
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5252,6 +5252,12 @@ static struct rq *finish_task_switch(str
 	 */
 	kmap_local_sched_in();
 
+	/*
+	 * Any cached block-layer timestamp (plug->cur_ktime) is stale now,
+	 * invalidate it.
+	 */
+	blk_plug_invalidate_ts();
+
 	fire_sched_in_preempt_notifiers(current);
 	/*
 	 * When switching through a kernel thread, the loop in
@@ -7251,12 +7257,10 @@ static inline void sched_submit_work(str
 
 static void sched_update_worker(struct task_struct *tsk)
 {
-	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER | PF_BLOCK_TS)) {
-		if (tsk->flags & PF_BLOCK_TS)
-			blk_plug_invalidate_ts(tsk);
+	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
 		if (tsk->flags & PF_WQ_WORKER)
 			wq_worker_running(tsk);
-		else if (tsk->flags & PF_IO_WORKER)
+		else
 			io_wq_worker_running(tsk);
 	}
 }


