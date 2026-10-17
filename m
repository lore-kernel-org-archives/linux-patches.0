Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386E391E74;
	Sat, 17 Oct 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254865; cv=none; b=cBjy78/Htl2jAxtX8fpZ9Z2RoZWzktQUmF2e4HssDYaHLcTroFkfNsuWftoUBCTDPMs8t3yplWdtD//0JodDC9J8Wjp9CJ3fBx4y+nJCWRlPVk+QBEdwvB8JXFlE13c7pMzf2k0Y0+sFp/daPzBK6GQvZ9wOCF/H/ht+b9+OctM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254865; c=relaxed/simple;
	bh=e8RaYlR+aQ2yi8qwZUllpsfgE841vYU2pTjAvTNzGrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq2TUDmt4kMrxwviYNsfcp32l4IGy3X4ukollxgkMkGYjyeOtzB2D96GyyJyySoimXhyyTeOGCf9Z8eo4QVuZY1JB+LLbpTU8Nsug/Mae0szYpbxzFopvpU5vgiBdccedpRk7AN5485h3tg3Pl9OOk/WCSGhJSGzAbG6iZocUAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7wD/bRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7wD/bRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3B61F000C4;
	Sat, 17 Oct 2026 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254863;
	bh=FeQ4tuizbnQCWdfH9wReKdxIBdq4FFrWTN1lvQpyUmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7wD/bRkbbqZlWtkiqXvfu4/Al626T7J4MkzDCA4hgKJv3a020G2fPjPAQeSEm1qA
	 oNDDESLpKZnMDSHNOFO8fJOOILZFdu29tkdVlDURCy7s9zRK6MBnlOKQyrzJc94GO7
	 vNHTg2huRS2rzv+KqrSjmrxOZFIqMValDvNzqz70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 560/869] io_uring: defer eventfd signaling when queued from a wakeup handler
Date: Sat, 17 Oct 2026 17:56:41 +0200
Message-ID: <20261017160051.435584043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/io_uring_types.h |  8 ++++++++
 io_uring/eventfd.c             |  6 +++---
 io_uring/eventfd.h             |  2 +-
 io_uring/futex.c               |  4 ++--
 io_uring/io_uring.c            |  2 +-
 io_uring/poll.c                | 23 ++++++++++++-----------
 io_uring/waitid.c              |  2 +-
 7 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6d47d0d3fde01..7711d99201414 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -17,6 +17,14 @@ enum {
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
 
 enum io_uring_cmd_flags {
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index ffc4bd17d0786..6a6ec9d4d6402 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -41,7 +41,7 @@ static void io_eventfd_do_signal(struct rcu_head *rcu)
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
-void io_eventfd_signal(struct io_ring_ctx *ctx)
+void io_eventfd_signal(struct io_ring_ctx *ctx, bool defer)
 {
 	struct io_ev_fd *ev_fd = NULL;
 
@@ -68,7 +68,7 @@ void io_eventfd_signal(struct io_ring_ctx *ctx)
 	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
 		goto out;
 
-	if (likely(eventfd_signal_allowed())) {
+	if (likely(!defer && eventfd_signal_allowed())) {
 		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	} else {
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
@@ -101,7 +101,7 @@ void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 	if (skip)
 		return;
 
-	io_eventfd_signal(ctx);
+	io_eventfd_signal(ctx, false);
 }
 
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
diff --git a/io_uring/eventfd.h b/io_uring/eventfd.h
index d394f49c63210..c93f32d594072 100644
--- a/io_uring/eventfd.h
+++ b/io_uring/eventfd.h
@@ -5,4 +5,4 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 
 void io_eventfd_flush_signal(struct io_ring_ctx *ctx);
-void io_eventfd_signal(struct io_ring_ctx *ctx);
+void io_eventfd_signal(struct io_ring_ctx *ctx, bool defer);
diff --git a/io_uring/futex.c b/io_uring/futex.c
index a3d2b700b480c..589769761cea1 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -201,7 +201,7 @@ static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
 
 	io_req_set_res(req, 0, 0);
 	req->io_task_work.func = io_futexv_complete;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_IN_WAKE);
 }
 
 int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -248,7 +248,7 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 
 	io_req_set_res(req, 0, 0);
 	req->io_task_work.func = io_futex_complete;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_IN_WAKE);
 }
 
 static struct io_futex_data *io_alloc_ifd(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1e7963cc30d3e..0076c7599c947 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1201,7 +1201,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
-			io_eventfd_signal(ctx);
+			io_eventfd_signal(ctx, flags & IOU_F_TWQ_IN_WAKE);
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 002f1ae830b8a..1a6179ac491bf 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -231,9 +231,9 @@ enum {
 	IOU_POLL_REQUEUE = 4,
 };
 
-static void __io_poll_execute(struct io_kiocb *req, int mask)
+static void __io_poll_execute(struct io_kiocb *req, int mask, unsigned tw_flags)
 {
-	unsigned flags = 0;
+	unsigned flags = tw_flags;
 
 	io_req_set_res(req, mask, 0);
 	req->io_task_work.func = io_poll_task_func;
@@ -241,14 +241,15 @@ static void __io_poll_execute(struct io_kiocb *req, int mask)
 	trace_io_uring_task_add(req, mask);
 
 	if (!(req->flags & REQ_F_POLL_NO_LAZY))
-		flags = IOU_F_TWQ_LAZY_WAKE;
+		flags |= IOU_F_TWQ_LAZY_WAKE;
 	__io_req_task_work_add(req, flags);
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
@@ -363,7 +364,7 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 	if (ret == IOU_POLL_NO_ACTION) {
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		__io_poll_execute(req, 0);
+		__io_poll_execute(req, 0, 0);
 		return;
 	}
 	io_poll_remove_entries(req);
@@ -401,7 +402,7 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 {
 	io_poll_mark_cancelled(req);
 	/* kick tw, which should complete the request */
-	io_poll_execute(req, 0);
+	io_poll_execute(req, 0, 0);
 }
 
 #define IO_ASYNC_POLL_COMMON	(EPOLLONESHOT | EPOLLPRI)
@@ -410,7 +411,7 @@ static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
 {
 	io_poll_mark_cancelled(req);
 	/* we have to kick tw in case it's not already */
-	io_poll_execute(req, 0);
+	io_poll_execute(req, 0, IOU_F_TWQ_IN_WAKE);
 
 	/*
 	 * If the waitqueue is being freed early but someone is already
@@ -465,7 +466,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			else
 				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, IOU_F_TWQ_IN_WAKE);
 	}
 	return 1;
 }
@@ -657,7 +658,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {
-		__io_poll_execute(req, mask);
+		__io_poll_execute(req, mask, 0);
 		return 0;
 	}
 	io_napi_add(req);
@@ -668,7 +669,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		 * poll was waken up, queue up a tw, it'll deal with it.
 		 */
 		if (atomic_cmpxchg(&req->poll_refs, 1, 0) != 1)
-			__io_poll_execute(req, 0);
+			__io_poll_execute(req, 0, 0);
 	}
 	return 0;
 }
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 7f3a6c2d9f807..4475b02bafbad 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -298,7 +298,7 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 1;
 
 	req->io_task_work.func = io_waitid_cb;
-	io_req_task_work_add(req);
+	__io_req_task_work_add(req, IOU_F_TWQ_IN_WAKE);
 	return 1;
 }
 
-- 
2.53.0



