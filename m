Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A7F1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC6CC433C8;
	Mon, 11 Sep 2023 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442141;
	bh=FjQOnngEc2FOBWKBSHZF39mASNWFUnxvPgtHACxgc18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7E3Q0rQq+chn3VDeNFkbYqOhfhLf7a7tGRUSf9/PeVBTUbreJcEqG4Gh/7hBymcz
	 7MVwXNRDifcff5UxpmsW4DxnzFb/V9yJwx/2mJr94PHeqmG1iR4n2pmtjymCgyaV6e
	 3gwcxzYuz3BsRlBojrsUxNkASMpXkaMuLl9pHEpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 660/739] io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL is used
Date: Mon, 11 Sep 2023 15:47:39 +0200
Message-ID: <20230911134709.543085399@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit ebdfefc09c6de7897962769bd3e63a2ff443ebf5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |    9 ++++++---
 io_uring/io-wq.h    |    2 +-
 io_uring/io_uring.c |   29 ++++++++++++++++++-----------
 io_uring/sqpoll.c   |   15 +++++++++++++++
 io_uring/sqpoll.h   |    1 +
 5 files changed, 41 insertions(+), 15 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1285,13 +1285,16 @@ static int io_wq_cpu_offline(unsigned in
 	return __io_wq_cpu_online(wq, cpu, false);
 }
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask)
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
+	if (!tctx || !tctx->io_wq)
+		return -EINVAL;
+
 	rcu_read_lock();
 	if (mask)
-		cpumask_copy(wq->cpu_mask, mask);
+		cpumask_copy(tctx->io_wq->cpu_mask, mask);
 	else
-		cpumask_copy(wq->cpu_mask, cpu_possible_mask);
+		cpumask_copy(tctx->io_wq->cpu_mask, cpu_possible_mask);
 	rcu_read_unlock();
 
 	return 0;
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -50,7 +50,7 @@ void io_wq_put_and_exit(struct io_wq *wq
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
-int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
+int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4201,16 +4201,28 @@ static int io_register_enable_rings(stru
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
 
@@ -4231,19 +4243,14 @@ static __cold int io_register_iowq_aff(s
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
@@ -421,3 +421,18 @@ err:
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
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
+int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);


