Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0BC386455;
	Sat, 12 Sep 2026 09:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205702; cv=none; b=UmeMUZxeX9VIgR9YSkIcC/kEUSWkeIlDLxmmGwBk8Oqi7sr6a6WaRXYx3ONu6zyafl9Wjx5RGz3TN7YqzWBO2Cl91GAS6hjd65rhL1CDpq6FUXwtQZDdqpBnoXST3djalsFFdSee+wPs58GPykiFO0cOXw4u0PIw+vk9oOoLVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205702; c=relaxed/simple;
	bh=Q9OJ5Wl4FsI/XsYWk5l1mRRxDElJbAnFRLCi/KIVqqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhuVSbT4CU+oF0wDd4rv8j7dQd8XX6XDZoGAKP+2P7EO8BgK0tE0z4ddeLthyhxnQGXE28axnFNJeZ/Z+42k7jXHIbN+SFNh0TCodU4r28a68S8OTYXD9YvZ2cyTz6dntzDsXwwpT9jUbq6TiwmhDW2QzSPUVVuyFtQkk0C/ufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fy++9pzd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fy++9pzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613D21F000FF;
	Sat, 12 Sep 2026 09:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205700;
	bh=jRK6oV5d+TvvlQ5S2+GQz39QTS5UJDtXMm+8BQoTKPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy++9pzdYQJF72J6AnOtVRxiYacPJyWErlmmI77HfAvX4YiWa4MzVWeiO7k0d7Y24
	 wQr4VnLNYDYy/mQXCcBH5uHACjWY75Xg7H41gaMStyXkfikem11YHuZ3iMxIBiQI5Z
	 3lpovwSNrINFzkd0qVmwNIYQKDIGI1cN7FpcEue0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0056/1518] io_uring: add wrapper type for io_req_tw_func_t arg
Date: Sat, 12 Sep 2026 08:37:05 +0200
Message-ID: <20260912065624.713205023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit c33e779aba6804778c1440192a8033a145ba588d ]

In preparation for uring_cmd implementations to implement functions
with the io_req_tw_func_t signature, introduce a wrapper struct
io_tw_req to hide the struct io_kiocb * argument. The intention is for
only the io_uring core to access the inner struct io_kiocb *. uring_cmd
implementations should instead call a helper from io_uring/cmd.h to
convert struct io_tw_req to struct io_uring_cmd *.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 14572de82e50 ("io_uring/waitid: honor task_work cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    6 +++++-
 io_uring/futex.c               |   16 +++++++++-------
 io_uring/io_uring.c            |   21 ++++++++++++---------
 io_uring/io_uring.h            |    4 ++--
 io_uring/msg_ring.c            |    3 ++-
 io_uring/notif.c               |    5 +++--
 io_uring/poll.c                |   11 ++++++-----
 io_uring/poll.h                |    2 +-
 io_uring/rw.c                  |    5 +++--
 io_uring/rw.h                  |    2 +-
 io_uring/timeout.c             |   18 +++++++++++-------
 io_uring/uring_cmd.c           |    3 ++-
 io_uring/waitid.c              |    7 ++++---
 13 files changed, 61 insertions(+), 42 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -626,7 +626,11 @@ enum {
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
+struct io_tw_req {
+	struct io_kiocb *req;
+};
+
+typedef void (*io_req_tw_func_t)(struct io_tw_req tw_req, io_tw_token_t tw);
 
 struct io_task_work {
 	struct llist_node		node;
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -41,24 +41,26 @@ void io_futex_cache_free(struct io_ring_
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
-static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void __io_futex_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	hlist_del_init(&req->hash_node);
-	io_req_task_complete(req, tw);
+	hlist_del_init(&tw_req.req->hash_node);
+	io_req_task_complete(tw_req, tw);
 }
 
-static void io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_futex_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
 	io_cache_free(&ctx->futex_cache, req->async_data);
 	io_req_async_data_clear(req, 0);
-	__io_futex_complete(req, tw);
+	__io_futex_complete(tw_req, tw);
 }
 
-static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_futexv_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv = req->async_data;
 
@@ -73,7 +75,7 @@ static void io_futexv_complete(struct io
 	}
 
 	io_req_async_data_free(req);
-	__io_futex_complete(req, tw);
+	__io_futex_complete(tw_req, tw);
 }
 
 static bool io_futexv_claim(struct io_futex *iof)
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -294,7 +294,7 @@ static __cold void io_fallback_req_func(
 	mutex_lock(&ctx->uring_lock);
 	ts.cancel = io_should_terminate_tw(ctx);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func(req, ts);
+		req->io_task_work.func((struct io_tw_req){req}, ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -542,9 +542,9 @@ static void io_queue_iowq(struct io_kioc
 	io_wq_enqueue(tctx->io_wq, &req->work);
 }
 
-static void io_req_queue_iowq_tw(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_queue_iowq_tw(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	io_queue_iowq(req);
+	io_queue_iowq(tw_req.req);
 }
 
 void io_req_queue_iowq(struct io_kiocb *req)
@@ -1171,7 +1171,7 @@ struct llist_node *io_handle_tw_list(str
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, ts);
+				(struct io_tw_req){req}, ts);
 		node = next;
 		(*count)++;
 		if (unlikely(need_resched())) {
@@ -1422,7 +1422,7 @@ static int __io_run_local_work_loop(stru
 						    io_task_work.node);
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, tw);
+				(struct io_tw_req){req}, tw);
 		*node = next;
 		if (++ret >= events)
 			break;
@@ -1492,14 +1492,17 @@ static int io_run_local_work(struct io_r
 	return ret;
 }
 
-static void io_req_task_cancel(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_task_cancel(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
+
 	io_tw_lock(req->ctx, tw);
 	io_req_defer_failed(req, req->cqe.res);
 }
 
-void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
@@ -1735,9 +1738,9 @@ static int io_iopoll_check(struct io_rin
 	return 0;
 }
 
-void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
-	io_req_complete_defer(req);
+	io_req_complete_defer(tw_req.req);
 }
 
 /*
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -160,9 +160,9 @@ struct file *io_file_get_fixed(struct io
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
 void io_req_task_queue(struct io_kiocb *req);
-void io_req_task_complete(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw);
 struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -70,8 +70,9 @@ static inline bool io_msg_need_remote(st
 	return target_ctx->task_complete;
 }
 
-static void io_msg_tw_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_msg_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -11,8 +11,9 @@
 
 static const struct ubuf_info_ops io_ubuf_ops;
 
-static void io_notif_tw_complete(struct io_kiocb *notif, io_tw_token_t tw)
+static void io_notif_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *notif = tw_req.req;
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
@@ -34,7 +35,7 @@ static void io_notif_tw_complete(struct
 		}
 
 		nd = nd->next;
-		io_req_task_complete(notif, tw);
+		io_req_task_complete((struct io_tw_req){notif}, tw);
 	} while (nd);
 }
 
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,8 +316,9 @@ static int io_poll_check_events(struct i
 	return IOU_POLL_NO_ACTION;
 }
 
-void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
+void io_poll_task_func(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	int ret;
 
 	ret = io_poll_check_events(req, tw);
@@ -338,7 +339,7 @@ void io_poll_task_func(struct io_kiocb *
 			poll = io_kiocb_to_cmd(req, struct io_poll);
 			req->cqe.res = mangle_poll(req->cqe.res & poll->events);
 		} else if (ret == IOU_POLL_REISSUE) {
-			io_req_task_submit(req, tw);
+			io_req_task_submit(tw_req, tw);
 			return;
 		} else if (ret != IOU_POLL_REMOVE_POLL_USE_RES) {
 			req->cqe.res = ret;
@@ -346,14 +347,14 @@ void io_poll_task_func(struct io_kiocb *
 		}
 
 		io_req_set_res(req, req->cqe.res, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 	} else {
 		io_tw_lock(req->ctx, tw);
 
 		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
-			io_req_task_complete(req, tw);
+			io_req_task_complete(tw_req, tw);
 		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
-			io_req_task_submit(req, tw);
+			io_req_task_submit(tw_req, tw);
 		else
 			io_req_defer_failed(req, ret);
 	}
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -46,4 +46,4 @@ int io_arm_poll_handler(struct io_kiocb
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
 
-void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw);
+void io_poll_task_func(struct io_tw_req tw_req, io_tw_token_t tw);
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -574,8 +574,9 @@ static inline int io_fixup_rw_res(struct
 	return res;
 }
 
-void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
+void io_req_rw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
@@ -591,7 +592,7 @@ void io_req_rw_complete(struct io_kiocb
 		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
 
 	io_req_rw_cleanup(req, 0);
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res)
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -46,7 +46,7 @@ int io_read_fixed(struct io_kiocb *req,
 int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw);
+void io_req_rw_complete(struct io_tw_req tw_req, io_tw_token_t tw);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
 void io_rw_cache_free(const void *entry);
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -68,8 +68,9 @@ static inline bool io_timeout_finish(str
 
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer);
 
-static void io_timeout_complete(struct io_kiocb *req, io_tw_token_t tw)
+static void io_timeout_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -85,7 +86,7 @@ static void io_timeout_complete(struct i
 		}
 	}
 
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static __cold bool io_flush_killed_timeouts(struct list_head *list, int err)
@@ -157,8 +158,10 @@ __cold void io_flush_timeouts(struct io_
 	io_flush_killed_timeouts(&list, 0);
 }
 
-static void io_req_tw_fail_links(struct io_kiocb *link, io_tw_token_t tw)
+static void io_req_tw_fail_links(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *link = tw_req.req;
+
 	io_tw_lock(link->ctx, tw);
 	while (link) {
 		struct io_kiocb *nxt = link->link;
@@ -168,7 +171,7 @@ static void io_req_tw_fail_links(struct
 			res = link->cqe.res;
 		link->link = NULL;
 		io_req_set_res(link, res, 0);
-		io_req_task_complete(link, tw);
+		io_req_task_complete((struct io_tw_req){link}, tw);
 		link = nxt;
 	}
 }
@@ -317,8 +320,9 @@ int io_timeout_cancel(struct io_ring_ctx
 	return 0;
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req, io_tw_token_t tw)
+static void io_req_task_link_timeout(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret;
@@ -335,11 +339,11 @@ static void io_req_task_link_timeout(str
 			ret = -ECANCELED;
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 		io_put_req(prev);
 	} else {
 		io_req_set_res(req, -ETIME, 0);
-		io_req_task_complete(req, tw);
+		io_req_task_complete(tw_req, tw);
 	}
 }
 
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -115,8 +115,9 @@ void io_uring_cmd_mark_cancelable(struct
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_kiocb *req, io_tw_token_t tw)
+static void io_uring_cmd_work(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -16,7 +16,7 @@
 #include "waitid.h"
 #include "../kernel/exit.h"
 
-static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw);
+static void io_waitid_cb(struct io_tw_req tw_req, io_tw_token_t tw);
 
 #define IO_WAITID_CANCEL_FLAG	BIT(31)
 #define IO_WAITID_REF_MASK	GENMASK(30, 0)
@@ -194,8 +194,9 @@ static inline bool io_waitid_drop_issue_
 	return true;
 }
 
-static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw)
+static void io_waitid_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 {
+	struct io_kiocb *req = tw_req.req;
 	struct io_waitid_async *iwa = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -229,7 +230,7 @@ static void io_waitid_cb(struct io_kiocb
 	}
 
 	io_waitid_complete(req, ret);
-	io_req_task_complete(req, tw);
+	io_req_task_complete(tw_req, tw);
 }
 
 static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,


