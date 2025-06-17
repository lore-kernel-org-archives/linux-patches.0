Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898238F54;
	Tue, 17 Jun 2025 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178324; cv=none; b=WHknWcZe5aXqkP3cNLA1OhRTXM9KpW+o8RSgtS6AINFDhifkxN3SdtR30++W69xhb4FUtzAAzNQ+6iyhCf0iMWImWsuY9vbflpaygi1LcxK3lLGq6hIxhW0V3crYcAPSy9YRy39isd31lmUbi4CEW/PbZ7SxzzLufU5Fne3pixQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178324; c=relaxed/simple;
	bh=TIk2P+ZcBhMtHpOBd2PMakFY+fRLeXvcglN3NNB4Vjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvAXxo3c5x12hSuvszdOO4Sbc5VRH935IncMtqA2mpY7SteL11gkdEApEUJa46D+ahP3RyO+W9WK+cbpCfk5Y+I5xkoS1nRkjbc7DxHpiM2f1Ivrp5NuNyJ0psehVk3U/Ji2Bc/6as7qfKcKH1BQJwnElos/RVwtNZI70qU9LN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VPJ6l6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VPJ6l6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79C0C4CEE3;
	Tue, 17 Jun 2025 16:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178324;
	bh=TIk2P+ZcBhMtHpOBd2PMakFY+fRLeXvcglN3NNB4Vjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VPJ6l6HmTuBQ7vbht2T+QnjlfnyF004hQzXz70teOvCU+Gg4mTaPibAwMNxHOlxE
	 j2hyFq+lYpeB62JBS7YAcDTH1mx0mrfZDEBzGUnw7Dl8PzMPdNzxCOAgLDr2Xb1GRz
	 V5Fl61lnVl4BiIwqeMobA0RBo6Rp1XchQQR73GLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/512] io_uring: consistently use rcu semantics with sqpoll thread
Date: Tue, 17 Jun 2025 17:27:25 +0200
Message-ID: <20250617152438.995762887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index bd3b3f7a6f6ca..64870f51b6788 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2916,7 +2916,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			struct task_struct *tsk;
 
 			io_sq_thread_park(sqd);
-			tsk = sqd->thread;
+			tsk = sqpoll_task_locked(sqd);
 			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
 				io_wq_cancel_cb(tsk->io_uring->io_wq,
 						io_cancel_ctx_cb, ctx, true);
@@ -3153,7 +3153,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	WARN_ON_ONCE(sqd && sqd->thread != current);
+	WARN_ON_ONCE(sqd && sqpoll_task_locked(sqd) != current);
 
 	if (!current->io_uring)
 		return;
diff --git a/io_uring/register.c b/io_uring/register.c
index eca26d4884d9a..a325b493ae121 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -268,6 +268,8 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
+			struct task_struct *tsk;
+
 			/*
 			 * Observe the correct sqd->lock -> ctx->uring_lock
 			 * ordering. Fine to drop uring_lock here, we hold
@@ -277,8 +279,9 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
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
index b0f17a1220ecd..9a63068948957 100644
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
@@ -45,24 +45,32 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
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
@@ -498,7 +506,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
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
@@ -526,10 +537,13 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
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



