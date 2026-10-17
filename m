Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16227324B32;
	Sat, 17 Oct 2026 17:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259563; cv=none; b=RPU4nwBI9qoFmBK9KEqrrI2Jh+fuJovO2etf+6NcelIIzcFH8vrkXEO5UK4VjZAvOpcsWgQqefIhKQdsLKBotz6BaDtgJGfTHovEKEWAoDKQG6qmjPNcWfqOIrJ7xST8DTJnR4SMps9w6B9IQxhMStdjuP2MnKlR0ImykN8et3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259563; c=relaxed/simple;
	bh=pJtq+BYbwEzV1yw26TA47KOXNo7SPE4oB2t5RS8yFN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/SgpDF5htjRjHKLT/cOvK1Ff/LrgOeGOIN6LD5GTKMQbp17p7yJEV+SF7FA6idyyD0TWTiew3omGpu3rDSoMOGvxfQmk4L/Zp1ZMK4QOnPK+EnbAfXO771n0b/gQ0b8Vggfca6UTqAWpy+WPwUx3rR5UQxwzUTnyt+InsixJZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjHz4eLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjHz4eLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6971F000C4;
	Sat, 17 Oct 2026 17:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259562;
	bh=0fYW3po/guttzoDIKjDYHDEte7rcgStmZTEVK9jKc84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjHz4eLVNhJxSgtquuVLINOCgc39leqA6/93uZ8QSFTUVtmrauXLKPmNCRlzfrphV
	 GO2++gvZfuWt3iJuzATzYYP95yiJ3J5zVInOv9Y1nvStb2kjhEvSxX07fR/VMs7cyf
	 MzGs3375tx4UeDEqGoCCWKIbiT0e66fMPYZvlrHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1255/1674] io_uring: defer eventfd signaling when queued from a wakeup handler
Date: Sat, 17 Oct 2026 17:58:47 +0200
Message-ID: <20261017160503.357031271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit cd305ee3633a45fcf5f3a5d83f99f3cb77d87b6e ]

io_req_local_work_add() signals the CQ ring eventfd inline when it is the
one to push the first entry onto ->work_list. For DEFER_TASKRUN rings that
add is frequently done from a waitqueue wakeup handler, where an
arbitrary waitqueue lock is held.

eventfd_signal_mask() only refuses to recurse when current->in_eventfd
is set, but that bit is set by eventfd_signal_mask() itself. If the wake
chain starts somewhere else, signal goes out inline and can feed back
into epoll.

Add IOU_F_TWQ_IN_WAKE, set it on the task_work add done from the three
waitqueue callbacks, and use it to force io_eventfd_signal() down the
existing call_rcu_hurry() deferral instead of signaling inline.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260813133843.2933127-1-4ncienth@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c |  8 ++++----
 io_uring/io_uring.h |  8 ++++++++
 io_uring/poll.c     | 22 ++++++++++++----------
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 910cd75753df9..d4973d0d4e434 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -539,7 +539,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
-static void io_eventfd_signal(struct io_ring_ctx *ctx)
+static void io_eventfd_signal(struct io_ring_ctx *ctx, bool defer)
 {
 	struct io_ev_fd *ev_fd = NULL;
 
@@ -562,7 +562,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
 		goto out;
 
-	if (likely(eventfd_signal_allowed())) {
+	if (!defer && likely(eventfd_signal_allowed())) {
 		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
@@ -596,7 +596,7 @@ static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 	if (skip)
 		return;
 
-	io_eventfd_signal(ctx);
+	io_eventfd_signal(ctx, false);
 }
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -1310,7 +1310,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
-			io_eventfd_signal(ctx);
+			io_eventfd_signal(ctx, flags & IOU_F_TWQ_IN_WAKE);
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 0f6b47f55c249..f845bf3eef0b5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -25,6 +25,14 @@ enum {
 	 * It's also ignored unless IORING_SETUP_DEFER_TASKRUN is set.
 	 */
 	IOU_F_TWQ_LAZY_WAKE			= 1,
+
+	/*
+	 * Set when task_work is queued from a waitqueue wakeup handler, where
+	 * an arbitrary provider waitqueue lock is held. Signaling the CQ ring
+	 * eventfd inline from there can recurse back into that lock through
+	 * epoll, so the eventfd signal must be deferred.
+	 */
+	IOU_F_TWQ_IN_WAKE			= 2,
 };
 
 enum {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 66a0a9b9950b4..c4cfc7a5236d6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -229,19 +229,21 @@ enum {
 	IOU_POLL_REQUEUE = 4,
 };
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
+static void __io_poll_execute(struct io_kiocb *req, int mask,
+			      unsigned tw_flags)
 {
 	io_req_set_res(req, mask, 0);
 	req->io_task_work.func = io_poll_task_func;
 
 	trace_io_uring_task_add(req, mask);
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, tw_flags);
 }
 
-static inline void io_poll_execute(struct io_kiocb *req, int res)
+static inline void io_poll_execute(struct io_kiocb *req, int res,
+				   unsigned tw_flags)
 {
 	if (io_poll_get_ownership(req))
-		__io_poll_execute(req, res);
+		__io_poll_execute(req, res, tw_flags);
 }
 
 /*
@@ -359,7 +361,7 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
 		io_kbuf_recycle(req, 0);
-		__io_poll_execute(req, 0);
+		__io_poll_execute(req, 0, 0);
 		return;
 	}
 	io_poll_remove_entries(req);
@@ -397,7 +399,7 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);
 	/* kick tw, which should complete the request */
-	io_poll_execute(req, 0);
+	io_poll_execute(req, 0, 0);
 }
 
 #define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
@@ -406,7 +408,7 @@ static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
 {
 	io_poll_mark_cancelled(req);
 	/* we have to kick tw in case it's not already */
-	io_poll_execute(req, 0);
+	io_poll_execute(req, 0, IOU_F_TWQ_IN_WAKE);
 
 	/*
 	 * If the waitqueue is being freed early but someone is already
@@ -461,7 +463,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, IOU_F_TWQ_IN_WAKE);
 	}
 	return 1;
 }
@@ -644,7 +646,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, 0);
 		return 0;
 	}
 
@@ -654,7 +656,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		 * poll was waken up, queue up a tw, it'll deal with it.
 		 */
 		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
-			__io_poll_execute(req, 0);
+			__io_poll_execute(req, 0, 0);
 	}
 	return 0;
 }
-- 
2.53.0



