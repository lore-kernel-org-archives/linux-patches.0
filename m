Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E142924CEEA;
	Sat, 12 Sep 2026 09:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205566; cv=none; b=cUTnEjbLJ9K8WE1V/xzg9nDQJNySN0CXC6mJGXxDsDsybiWjfEKiCL6hTwJgtBeP9DJCcnBZBQJ1RxgX+BO13IZmg78VqkJeSKbyzG4BD0fM4LEoy6xfe2NwWmFVksfJdPzjobSa/pfk1Q734tJeDoKcMN/3lVjZUdPs+KBuc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205566; c=relaxed/simple;
	bh=Nc16eve/yL7p1Hu3BMTh1i/oaOezPxrlLDKAdqujQD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQffG5AEDd6X84PXlt8U7CuTLvsdvMe+IkjSRmtuBKfgg8cASYXqf3gr6cY7KCJUQyhM3D+KUA4gK9ghrAt2CDkwR9sWHyN9qOet7gr/U8oOr2VkTmMOIequzCh2MUOnhb6R27NNoFJVuAtYkSTKh/krksLrz9TJW60GuTm3cmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZvfml1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZvfml1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D641F000FF;
	Sat, 12 Sep 2026 09:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205564;
	bh=wPnOxF0up865q+mwhFVzJJEPa2NnOYC/YI1IcKNxvG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZvfml1m0POjxZKUQKVaG2SrCHl2om4xBUU2fs5ALGgG+0vdSLTykzybH21DnUp8f
	 cBY4JkLkDB+POcbdEfibyjwno8EzmvaZnnvsnYOn6Ci9Xjl6wRV4ZO+5zQ3oXhTljg
	 3Bkgn1X7QVc6eBcJt2VRnTjKq423NsOP9+4HtCoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0028/1518] io_uring: unify task_work cancelation checks
Date: Sat, 12 Sep 2026 08:36:37 +0200
Message-ID: <20260912065624.060161612@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 7be20254a743be4f02414b9d56cc3fe5f84e6500 ]

Rather than do per-tw checking, which needs to dip into the task_struct
for checking flags, do it upfront before running task_work. This places
a 'cancel' member in io_tw_token_t, which is assigned before running
task_work for that given ctx.

This is both more efficient in doing it upfront rather than for every
task_work, and it means that io_should_terminate_tw() can be made
private in io_uring.c rather than need to be called by various
callbacks of task_work.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 14572de82e50 ("io_uring/waitid: honor task_work cancellation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    1 +
 io_uring/io_uring.c            |   27 ++++++++++++++++++++-------
 io_uring/io_uring.h            |   13 -------------
 io_uring/poll.c                |    2 +-
 io_uring/timeout.c             |    2 +-
 io_uring/uring_cmd.c           |    2 +-
 6 files changed, 24 insertions(+), 23 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -482,6 +482,7 @@ struct io_ring_ctx {
  * ONLY core io_uring.c should instantiate this struct.
  */
 struct io_tw_state {
+	bool cancel;
 };
 /* Alias to use in code that doesn't instantiate struct io_tw_state */
 typedef struct io_tw_state io_tw_token_t;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -268,6 +268,20 @@ static __cold void io_ring_ctx_ref_free(
 	complete(&ctx->ref_comp);
 }
 
+/*
+ * Terminate the request if either of these conditions are true:
+ *
+ * 1) It's being executed by the original task, but that task is marked
+ *    with PF_EXITING as it's exiting.
+ * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
+ *    our fallback task_work.
+ * 3) The ring has been closed and is going away.
+ */
+static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
+{
+	return (current->flags & (PF_EXITING | PF_KTHREAD)) || percpu_ref_is_dying(&ctx->refs);
+}
+
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
@@ -278,8 +292,10 @@ static __cold void io_fallback_req_func(
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.node) {
+		ts.cancel = io_should_terminate_tw(req->ctx);
 		req->io_task_work.func(req, ts);
+	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -1152,6 +1168,7 @@ struct llist_node *io_handle_tw_list(str
 			ctx = req->ctx;
 			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
+			ts.cancel = io_should_terminate_tw(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -1210,11 +1227,6 @@ struct llist_node *tctx_task_work_run(st
 {
 	struct llist_node *node;
 
-	if (unlikely(current->flags & PF_EXITING)) {
-		io_fallback_tw(tctx, true);
-		return NULL;
-	}
-
 	node = llist_del_all(&tctx->task_list);
 	if (node) {
 		node = llist_reverse_order(node);
@@ -1432,6 +1444,7 @@ static int __io_run_local_work(struct io
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
+	tw.cancel = io_should_terminate_tw(ctx);
 	min_events -= ret;
 	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
 	if (ctx->retry_llist.first)
@@ -1491,7 +1504,7 @@ void io_req_task_submit(struct io_kiocb
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
-	if (unlikely(io_should_terminate_tw(ctx)))
+	if (unlikely(tw.cancel))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -582,19 +582,6 @@ static inline bool io_allowed_run_tw(str
 		      ctx->submitter_task == current);
 }
 
-/*
- * Terminate the request if either of these conditions are true:
- *
- * 1) It's being executed by the original task, but that task is marked
- *    with PF_EXITING as it's exiting.
- * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
- *    our fallback task_work.
- */
-static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
-{
-	return (current->flags & (PF_KTHREAD | PF_EXITING)) || percpu_ref_is_dying(&ctx->refs);
-}
-
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 {
 	io_req_set_res(req, res, 0);
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -225,7 +225,7 @@ static int io_poll_check_events(struct i
 {
 	int v;
 
-	if (unlikely(io_should_terminate_tw(req->ctx)))
+	if (unlikely(tw.cancel))
 		return -ECANCELED;
 
 	do {
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -324,7 +324,7 @@ static void io_req_task_link_timeout(str
 	int ret;
 
 	if (prev) {
-		if (!io_should_terminate_tw(req->ctx)) {
+		if (!tw.cancel) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -120,7 +120,7 @@ static void io_uring_cmd_work(struct io_
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
-	if (io_should_terminate_tw(req->ctx))
+	if (unlikely(tw.cancel))
 		flags |= IO_URING_F_TASK_DEAD;
 
 	/* task_work executor checks the deffered list completion */


