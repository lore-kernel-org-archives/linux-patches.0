Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C239F6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33755C433C9;
	Sun, 17 Sep 2023 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980841;
	bh=xPm0lTU5o2YrqLTlw+9gI99rehl2ucUuKVkEJBxS2so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOtv6sJAEC6KgxSsekioZC0lI9e0ez654dvjxtQt0wireDnzZBQ/U3APe4N/z1M5d
	 izcwX57adL0s+bEAqCoekE31AuADXYg6jVIl4u7a1MhusfkwU3yVHxsin33R9srePd
	 Ef2yfgeA8U1kHsgEMWGaXL+qCLLVdTpAelFXGwbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 008/219] io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL is used
Date: Sun, 17 Sep 2023 21:12:15 +0200
Message-ID: <20230917191041.271186853@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

From: Jens Axboe <axboe@kernel.dk>

[ upstream commit ebdfefc09c6de7897962769bd3e63a2ff443ebf5 ]

If we setup the ring with SQPOLL, then that polling thread has its
own io-wq setup. This means that if the application uses
IORING_REGISTER_IOWQ_AFF to set the io-wq affinity, we should not be
setting it for the invoking task, but rather the sqpoll task.

Add an sqpoll helper that parks the thread and updates the affinity,
and use that one if we're using SQPOLL.

Fixes: fe76421d1da1 ("io_uring: allow user configurable IO thread CPU affinity")
Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/discussions/884
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |    7 +++++--
 io_uring/io-wq.h    |    2 +-
 io_uring/io_uring.c |   29 ++++++++++++++++++-----------
 io_uring/sqpoll.c   |   15 +++++++++++++++
 io_uring/sqpoll.h   |    1 +
 5 files changed, 40 insertions(+), 14 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1350,13 +1350,16 @@ static int io_wq_cpu_offline(unsigned in
 	return __io_wq_cpu_online(wq, cpu, false);
 }
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
 	int i;
 
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
 	rcu_read_lock();
 	for_each_node(i) {
-		struct io_wqe *wqe = wq->wqes[i];
+		struct io_wqe *wqe = tctx->io_wq->wqes[i];
 
 		if (mask)
 			cpumask_copy(wqe->cpu_mask, mask);
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -50,7 +50,7 @@ void io_wq_put_and_exit(struct io_wq *wq
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 bool io_wq_worker_stopped(void);
 
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3835,16 +3835,28 @@ static int io_register_enable_rings(stru
 	return 0;
 }
 
+static __cold int __io_register_iowq_aff(struct io_ring_ctx *ctx,
+					 cpumask_var_t new_mask)
+{
+	int ret;
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		ret = io_wq_cpu_affinity(current->io_uring, new_mask);
+	} else {
+		mutex_unlock(&ctx->uring_lock);
+		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
+		mutex_lock(&ctx->uring_lock);
+	}
+
+	return ret;
+}
+
 static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 				       void __user *arg, unsigned len)
 {
-	struct io_uring_task *tctx = current->io_uring;
 	cpumask_var_t new_mask;
 	int ret;
 
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
-
 	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
 		return -ENOMEM;
 
@@ -3865,19 +3877,14 @@ static __cold int io_register_iowq_aff(s
 		return -EFAULT;
 	}
 
-	ret = io_wq_cpu_affinity(tctx->io_wq, new_mask);
+	ret = __io_register_iowq_aff(ctx, new_mask);
 	free_cpumask_var(new_mask);
 	return ret;
 }
 
 static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 {
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (!tctx || !tctx->io_wq)
-		return -EINVAL;
-
-	return io_wq_cpu_affinity(tctx->io_wq, NULL);
+	return __io_register_iowq_aff(ctx, NULL);
 }
 
 static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -423,3 +423,18 @@ err:
 	io_sq_thread_finish(ctx);
 	return ret;
 }
+
+__cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
+				     cpumask_var_t mask)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+	int ret = -EINVAL;
+
+	if (sqd) {
+		io_sq_thread_park(sqd);
+		ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
+		io_sq_thread_unpark(sqd);
+	}
+
+	return ret;
+}
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -27,3 +27,4 @@ void io_sq_thread_park(struct io_sq_data
 void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
 int io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
+int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);


