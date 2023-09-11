Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFCF1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F241C433C7;
	Mon, 11 Sep 2023 14:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442150;
	bh=MzGDNy/nWTNHARTxsGApr5PJydIXRWRpRPSTXnIYfVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toZ3oetb5Qk9xgT7bXovFAxmdTCFQucHqxlKsjOeK4x02aK+CG9rmvug8Of5TMJpO
	 nR1dJKJ9nNsTTtFoeCwP8LRaWw/x4QU70k/PqpKqlF2EG2QLKc7KVx7ecpV/gnSB5M
	 kpgINEAHF+Z9P6M8Z6IZZ3kYAF+CKdwJ9SnCnzZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.5 663/739] io_uring: break out of iowq iopoll on teardown
Date: Mon, 11 Sep 2023 15:47:42 +0200
Message-ID: <20230911134709.625544972@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit 45500dc4e01c167ee063f3dcc22f51ced5b2b1e9 upstream.

io-wq will retry iopoll even when it failed with -EAGAIN. If that
races with task exit, which sets TIF_NOTIFY_SIGNAL for all its workers,
such workers might potentially infinitely spin retrying iopoll again and
again and each time failing on some allocation / waiting / etc. Don't
keep spinning if io-wq is dying.

Fixes: 561fb04a6a225 ("io_uring: replace workqueue usage with io-wq")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c    |   10 ++++++++++
 io_uring/io-wq.h    |    1 +
 io_uring/io_uring.c |    2 ++
 3 files changed, 13 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -174,6 +174,16 @@ static void io_worker_ref_put(struct io_
 		complete(&wq->worker_done);
 }
 
+bool io_wq_worker_stopped(void)
+{
+	struct io_worker *worker = current->worker_private;
+
+	if (WARN_ON_ONCE(!io_wq_current_is_worker()))
+		return true;
+
+	return test_bit(IO_WQ_BIT_EXIT, &worker->wq->state);
+}
+
 static void io_worker_cancel_cb(struct io_worker *worker)
 {
 	struct io_wq_acct *acct = io_wq_get_acct(worker);
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -52,6 +52,7 @@ void io_wq_hash_work(struct io_wq_work *
 
 int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+bool io_wq_worker_stopped(void);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1966,6 +1966,8 @@ fail:
 		if (!needs_poll) {
 			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
+			if (io_wq_worker_stopped())
+				break;
 			cond_resched();
 			continue;
 		}


