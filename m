Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05519188006;
	Tue, 17 Jun 2025 16:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179427; cv=none; b=jRmj7wpGWKwcYdZCSBzKAHOmpwR8oUhJgkbskN810smI3LRiBscLaLr80t7x9eeQA7jPh0NiqzObb+TQgnofl4K+XVowZEg5EPvu4LOuUYXYvlJiI78ZiWW+I2kiuZ0IK3nl/k/cIAq/zZeuJDjl54/vKqpHVI1dFdok6elSGzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179427; c=relaxed/simple;
	bh=3wFYP99NyffCEc1ptxtJkT66mYhBV6T2A5cHCtPD9dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX0MF23Mfc4oR8SxEa50GkwoFjRQjqatTVuheUdROAffoDxg+MlEpZtkIz4TXpg/dm6h7wvIzUZHdB33C6TRu0Dn0/kpbyWxAlPRyeCG8RcA1gKK38qeIqovOrzDf2hmUOsDBvotHhp9JGNl0S90bjWTcEp4SYd4VOr939a+1HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPdg3+rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPdg3+rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167D4C4CEF2;
	Tue, 17 Jun 2025 16:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179426;
	bh=3wFYP99NyffCEc1ptxtJkT66mYhBV6T2A5cHCtPD9dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPdg3+rcTMZ2RxTa8DUp+qrldLRtfX52MH9n60fApuvXCoy5Ho3Q6NE91EfPYVB8m
	 xucfNcpFBM1PqOYXCtMXnr4axW1bYWsf/+V7TRD4d7pKCds4YVZ7mnjJRpnYN131/R
	 /DandArKbZ/MHFafcHwCWJQk6LwITCVfLt+58KYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 735/780] io_uring: consistently use rcu semantics with sqpoll thread
Date: Tue, 17 Jun 2025 17:27:23 +0200
Message-ID: <20250617152521.435619100@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c538f400fae22725580842deb2bef546701b64bd ]

The sqpoll thread is dereferenced with rcu read protection in one place,
so it needs to be annotated as an __rcu type, and should consistently
use rcu helpers for access and assignment to make sparse happy.

Since most of the accesses occur under the sqd->lock, we can use
rcu_dereference_protected() without declaring an rcu read section.
Provide a simple helper to get the thread from a locked context.

Fixes: ac0b8b327a5677d ("io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Link: https://lore.kernel.org/r/20250611205343.1821117-1-kbusch@meta.com
[axboe: fold in fix for register.c]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/register.c |  7 +++++--
 io_uring/sqpoll.c   | 34 ++++++++++++++++++++++++----------
 io_uring/sqpoll.h   |  8 +++++++-
 4 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9266d4f2016ad..e5466f6568269 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2913,7 +2913,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			struct task_struct *tsk;
 
 			io_sq_thread_park(sqd);
-			tsk = sqd->thread;
+			tsk = sqpoll_task_locked(sqd);
 			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
 				io_wq_cancel_cb(tsk->io_uring->io_wq,
 						io_cancel_ctx_cb, ctx, true);
@@ -3150,7 +3150,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(sqd && sqd->thread != current);
+	WARN_ON_ONCE(sqd && sqpoll_task_locked(sqd) != current);
 
 	if (!current->io_uring)
 		return;
diff --git a/io_uring/register.c b/io_uring/register.c
index cc23a4c205cd4..a59589249fce7 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -273,6 +273,8 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
+			struct task_struct *tsk;
+
 			/*
 			 * Observe the correct sqd->lock -> ctx->uring_lock
 			 * ordering. Fine to drop uring_lock here, we hold
@@ -282,8 +284,9 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 			mutex_unlock(&ctx->uring_lock);
 			mutex_lock(&sqd->lock);
 			mutex_lock(&ctx->uring_lock);
-			if (sqd->thread)
-				tctx = sqd->thread->io_uring;
+			tsk = sqpoll_task_locked(sqd);
+			if (tsk)
+				tctx = tsk->io_uring;
 		}
 	} else {
 		tctx = current->io_uring;
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 0625a421626f4..268d2fbe6160c 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -30,7 +30,7 @@ enum {
 void io_sq_thread_unpark(struct io_sq_data *sqd)
 	__releases(&sqd->lock)
 {
-	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(sqpoll_task_locked(sqd) == current);
 
 	/*
 	 * Do the dance but not conditional clear_bit() because it'd race with
@@ -46,24 +46,32 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(data_race(sqd->thread) == current);
+	struct task_struct *tsk;
 
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
+
+	tsk = sqpoll_task_locked(sqd);
+	if (tsk) {
+		WARN_ON_ONCE(tsk == current);
+		wake_up_process(tsk);
+	}
 }
 
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	WARN_ON_ONCE(sqd->thread == current);
+	struct task_struct *tsk;
+
 	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
 
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
+	tsk = sqpoll_task_locked(sqd);
+	if (tsk) {
+		WARN_ON_ONCE(tsk == current);
+		wake_up_process(tsk);
+	}
 	mutex_unlock(&sqd->lock);
 	wait_for_completion(&sqd->exited);
 }
@@ -486,7 +494,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			goto err_sqpoll;
 		}
 
-		sqd->thread = tsk;
+		mutex_lock(&sqd->lock);
+		rcu_assign_pointer(sqd->thread, tsk);
+		mutex_unlock(&sqd->lock);
+
 		task_to_put = get_task_struct(tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
@@ -514,10 +525,13 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
 	int ret = -EINVAL;
 
 	if (sqd) {
+		struct task_struct *tsk;
+
 		io_sq_thread_park(sqd);
 		/* Don't set affinity for a dying thread */
-		if (sqd->thread)
-			ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
+		tsk = sqpoll_task_locked(sqd);
+		if (tsk)
+			ret = io_wq_cpu_affinity(tsk->io_uring, mask);
 		io_sq_thread_unpark(sqd);
 	}
 
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 4171666b1cf4c..b83dcdec9765f 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -8,7 +8,7 @@ struct io_sq_data {
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
 
-	struct task_struct	*thread;
+	struct task_struct __rcu *thread;
 	struct wait_queue_head	wait;
 
 	unsigned		sq_thread_idle;
@@ -29,3 +29,9 @@ void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
 int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);
+
+static inline struct task_struct *sqpoll_task_locked(struct io_sq_data *sqd)
+{
+	return rcu_dereference_protected(sqd->thread,
+					 lockdep_is_held(&sqd->lock));
+}
-- 
2.39.5



