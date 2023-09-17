Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8D36FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25B1C433CB;
	Sun, 17 Sep 2023 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980838;
	bh=IdHcUMu+dyYBScV4sPAjHudVxrCkl6Q+Yrgn7KqkGtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcPcnH1KEzfEagFIXuPEOxSg5HjDWDlVfd3JctI3QCY95eq72mGQSSo2rRl7bzs1P
	 CQWc4FJCm+c/RbNGoAz9X4FbeH6IiSzomMkddlOAQyz5r1WQOres4+D2dghtUtmtSn
	 SaVBsnaGZCE8WtNR2y8YHGJXD4Mcihn0/XhYKTyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 007/219] io_uring: break out of iowq iopoll on teardown
Date: Sun, 17 Sep 2023 21:12:14 +0200
Message-ID: <20230917191041.233540696@linuxfoundation.org>
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

[ upstream commit 45500dc4e01c167ee063f3dcc22f51ced5b2b1e9 ]

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
@@ -181,6 +181,16 @@ static void io_worker_ref_put(struct io_
 		complete(&wq->worker_done);
 }
 
+bool io_wq_worker_stopped(void)
+{
+	struct io_worker *worker = current->worker_private;
+
+	if (WARN_ON_ONCE(!io_wq_current_is_worker()))
+		return true;
+
+	return test_bit(IO_WQ_BIT_EXIT, &worker->wqe->wq->state);
+}
+
 static void io_worker_cancel_cb(struct io_worker *worker)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -52,6 +52,7 @@ void io_wq_hash_work(struct io_wq_work *
 
 int io_wq_cpu_affinity(struct io_wq *wq, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
+bool io_wq_worker_stopped(void);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1823,6 +1823,8 @@ fail:
 		if (!needs_poll) {
 			if (!(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
+			if (io_wq_worker_stopped())
+				break;
 			cond_resched();
 			continue;
 		}


