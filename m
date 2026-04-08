Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9563F3B0AFC;
	Wed,  8 Apr 2026 18:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673647; cv=none; b=CZJtlyWaH9Iu6Mmj3fdPhHhA7SecIzDTLzevbHfw4ItUj8JFQli6eN7swDq3s9YO0WZXKB0eGvRHo+wu1YulKgKhGtsfEcBlZeUs2vtMDA8Lc3lYPRdUw1gLVSVppswGa9IVht7darQ9x7Gb2n7vWnnwhgHkohqo3ZLHKnYogbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673647; c=relaxed/simple;
	bh=EH0qqrOh05uLLKYAfiUSLM0vVZq5DzeRp711r7aRgeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSJI+A4AMdFBoJKutyYyQk/tpivkZExrn+xCnZdPfPB0eyOdP3zLfXjd3bJyiOqn7u5/12MHc8Ow6iAjeUyoKLQ8Vx2RjqBw4Il1vlygRegcbweVDHUFK4YcOXjsb0WntC+MhZ7XU47bt4kPZfqSRSyMRx3BlwVdNEaVLOA/nOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keCGQg7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keCGQg7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8A7C19421;
	Wed,  8 Apr 2026 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673647;
	bh=EH0qqrOh05uLLKYAfiUSLM0vVZq5DzeRp711r7aRgeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keCGQg7QNp6voXekY6OdK/3m5EzZpUBAqdng2GtNcDA/OVA78u+hDL8me8zB1gGh3
	 8QGt2kD9oI7ATQbEuOlBvG7UbAYH2cbTxWq8/r9wjMerTACYb0QGdCnBEIOwzj6I20
	 3iVIdx4UjvRoNnDXrfd+d4a0jNEEze8z4LH9zeqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 004/242] io_uring/kbuf: remove legacy kbuf caching
Date: Wed,  8 Apr 2026 20:00:44 +0200
Message-ID: <20260408175927.236688394@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 13ee854e7c04236a47a5beaacdcf51eb0bc7a8fa upstream.

Remove all struct io_buffer caches. It makes it a fair bit simpler.
Apart from from killing a bunch of lines and juggling between lists,
__io_put_kbuf_list() doesn't need ->completion_lock locking now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/18287217466ee2576ea0b1e72daccf7b22c7e856.1738724373.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 --
 io_uring/io_uring.c            |    2 -
 io_uring/kbuf.c                |   58 ++++-------------------------------------
 io_uring/kbuf.h                |    5 +--
 4 files changed, 9 insertions(+), 59 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -341,7 +341,6 @@ struct io_ring_ctx {
 
 	spinlock_t		completion_lock;
 
-	struct list_head	io_buffers_comp;
 	struct list_head	cq_overflow_list;
 	struct io_hash_table	cancel_table;
 
@@ -361,8 +360,6 @@ struct io_ring_ctx {
 	unsigned int		file_alloc_start;
 	unsigned int		file_alloc_end;
 
-	struct list_head	io_buffers_cache;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -305,7 +305,6 @@ static __cold struct io_ring_ctx *io_rin
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	ret = io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
 	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
@@ -328,7 +327,6 @@ static __cold struct io_ring_ctx *io_rin
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -78,9 +78,7 @@ bool io_kbuf_recycle_legacy(struct io_ki
 
 void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
 {
-	spin_lock(&req->ctx->completion_lock);
 	__io_put_kbuf_list(req, len);
-	spin_unlock(&req->ctx->completion_lock);
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
@@ -362,14 +360,15 @@ static int __io_remove_buffers(struct io
 		return i;
 	}
 
-	/* protects io_buffers_cache */
 	lockdep_assert_held(&ctx->uring_lock);
 
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_move(&nxt->list, &ctx->io_buffers_cache);
+		list_del(&nxt->list);
+		kfree(nxt);
+
 		if (++i == nbufs)
 			return i;
 		cond_resched();
@@ -389,27 +388,12 @@ void io_put_bl(struct io_ring_ctx *ctx,
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
-	struct list_head *item, *tmp;
-	struct io_buffer *buf;
 	unsigned long index;
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
 		io_put_bl(ctx, bl);
 	}
-
-	/*
-	 * Move deferred locked entries to cache before pruning
-	 */
-	spin_lock(&ctx->completion_lock);
-	if (!list_empty(&ctx->io_buffers_comp))
-		list_splice_init(&ctx->io_buffers_comp, &ctx->io_buffers_cache);
-	spin_unlock(&ctx->completion_lock);
-
-	list_for_each_safe(item, tmp, &ctx->io_buffers_cache) {
-		buf = list_entry(item, struct io_buffer, list);
-		kfree(buf);
-	}
 }
 
 static void io_destroy_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
@@ -499,33 +483,6 @@ int io_provide_buffers_prep(struct io_ki
 	return 0;
 }
 
-static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
-{
-	struct io_buffer *buf;
-
-	/*
-	 * Completions that don't happen inline (eg not under uring_lock) will
-	 * add to ->io_buffers_comp. If we don't have any free buffers, check
-	 * the completion list and splice those entries first.
-	 */
-	if (!list_empty_careful(&ctx->io_buffers_comp)) {
-		spin_lock(&ctx->completion_lock);
-		if (!list_empty(&ctx->io_buffers_comp)) {
-			list_splice_init(&ctx->io_buffers_comp,
-						&ctx->io_buffers_cache);
-			spin_unlock(&ctx->completion_lock);
-			return 0;
-		}
-		spin_unlock(&ctx->completion_lock);
-	}
-
-	buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
-	if (!buf)
-		return -ENOMEM;
-	list_add_tail(&buf->list, &ctx->io_buffers_cache);
-	return 0;
-}
-
 static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 			  struct io_buffer_list *bl)
 {
@@ -534,12 +491,11 @@ static int io_add_buffers(struct io_ring
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		if (list_empty(&ctx->io_buffers_cache) &&
-		    io_refill_buffer_cache(ctx))
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
+		if (!buf)
 			break;
-		buf = list_first_entry(&ctx->io_buffers_cache, struct io_buffer,
-					list);
-		list_move_tail(&buf->list, &bl->buf_list);
+
+		list_add_tail(&buf->list, &bl->buf_list);
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -177,8 +177,9 @@ static inline void __io_put_kbuf_list(st
 		__io_put_kbuf_ring(req, len, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
-		list_add(&req->kbuf->list, &req->ctx->io_buffers_comp);
 		req->flags &= ~REQ_F_BUFFER_SELECTED;
+		kfree(req->kbuf);
+		req->kbuf = NULL;
 	}
 }
 
@@ -187,10 +188,8 @@ static inline void io_kbuf_drop(struct i
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 
-	spin_lock(&req->ctx->completion_lock);
 	/* len == 0 is fine here, non-ring will always drop all of it */
 	__io_put_kbuf_list(req, 0);
-	spin_unlock(&req->ctx->completion_lock);
 }
 
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,


