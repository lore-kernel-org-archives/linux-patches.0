Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195EF3A4F46;
	Tue, 17 Mar 2026 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767055; cv=none; b=o020uFpXgGhNAyEeK01uSiVc25mYs+QjGTihSErCgCxqj9S/3DIxTNn3MvkzCujkX2XjzzWvCMg+PKdHDLPjBxGtYq1iEuTKhNnJH0EHRyCmrpR6ACrIfCP1HmRx+thX+2URn8E0BLYuUhomLrdjPDjCBce9wkKb0SeWO2Hpp6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767055; c=relaxed/simple;
	bh=JQjczrzOam9F5zhQRVpqGlzZoLNTWx6uXmA2VvuXGQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI3Dm8WXYD8cb7bqAlN7PZtheh7TfKM6mxOlYlA9Qme+sopLZa6zYfS9AS3V9OVGveNcyngnGNjkIQqR552miibHvf8BERVeu2Q2rk1+Q5Kg7jSvu/zTaWvUMi+jLDW6e8RIKIqGkndTbnlGw8UkQwgTWC6uibrgv/iqOBZIp6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b4W13qHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4W13qHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF74C19424;
	Tue, 17 Mar 2026 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767055;
	bh=JQjczrzOam9F5zhQRVpqGlzZoLNTWx6uXmA2VvuXGQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4W13qHWYRWE5A8xc1x9A9GmXj7d2r1eKy+1OQLbr68Ky1e8/bqmWq29LOcFwtZfz
	 y6lyKFZfgT5yrcR7fnzrN+W0bRZClLhpyQbYrFSWWOEfMEiXARvDBqzkpKYGNJxs3I
	 nXarb3OB3b4jTshFCY3moTP08h0o4dOJ+0AJ1pWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Yu Yang <naup96721@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.19 376/378] io_uring: ensure ctx->rings is stable for task work flags manipulation
Date: Tue, 17 Mar 2026 17:35:33 +0100
Message-ID: <20260317163020.813852548@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 96189080265e6bb5dde3a4afbaf947af493e3f82 upstream.

If DEFER_TASKRUN | SETUP_TASKRUN is used and task work is added while
the ring is being resized, it's possible for the OR'ing of
IORING_SQ_TASKRUN to happen in the small window of swapping into the
new rings and the old rings being freed.

Prevent this by adding a 2nd ->rings pointer, ->rings_rcu, which is
protected by RCU. The task work flags manipulation is inside RCU
already, and if the resize ring freeing is done post an RCU synchronize,
then there's no need to add locking to the fast path of task work
additions.

Note: this is only done for DEFER_TASKRUN, as that's the only setup mode
that supports ring resizing. If this ever changes, then they too need to
use the io_ctx_mark_taskrun() helper.

Link: https://lore.kernel.org/io-uring/20260309062759.482210-1-naup96721@gmail.com/
Cc: stable@vger.kernel.org
Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Reported-by: Hao-Yu Yang <naup96721@gmail.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    1 +
 io_uring/io_uring.c            |   24 ++++++++++++++++++++++--
 io_uring/register.c            |   12 ++++++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -371,6 +371,7 @@ struct io_ring_ctx {
 	 * regularly bounce b/w CPUs.
 	 */
 	struct {
+		struct io_rings	__rcu	*rings_rcu;
 		struct llist_head	work_llist;
 		struct llist_head	retry_llist;
 		unsigned long		check_cq;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1202,6 +1202,21 @@ void tctx_task_work(struct callback_head
 	WARN_ON_ONCE(ret);
 }
 
+/*
+ * Sets IORING_SQ_TASKRUN in the sq_flags shared with userspace, using the
+ * RCU protected rings pointer to be safe against concurrent ring resizing.
+ */
+static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
+{
+	lockdep_assert_in_rcu_read_lock();
+
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG) {
+		struct io_rings *rings = rcu_dereference(ctx->rings_rcu);
+
+		atomic_or(IORING_SQ_TASKRUN, &rings->sq_flags);
+	}
+}
+
 static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1256,8 +1271,7 @@ static void io_req_local_work_add(struct
 	 */
 
 	if (!head) {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		io_ctx_mark_taskrun(ctx);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx, false);
 	}
@@ -1281,6 +1295,10 @@ static void io_req_normal_work_add(struc
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
 
+	/*
+	 * Doesn't need to use ->rings_rcu, as resizing isn't supported for
+	 * !DEFER_TASKRUN.
+	 */
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
@@ -2760,6 +2778,7 @@ static void io_rings_free(struct io_ring
 	io_free_region(ctx->user, &ctx->sq_region);
 	io_free_region(ctx->user, &ctx->ring_region);
 	ctx->rings = NULL;
+	RCU_INIT_POINTER(ctx->rings_rcu, NULL);
 	ctx->sq_sqes = NULL;
 }
 
@@ -3389,6 +3408,7 @@ static __cold int io_allocate_scq_urings
 	if (ret)
 		return ret;
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
+	rcu_assign_pointer(ctx->rings_rcu, rings);
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
 
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -545,7 +545,15 @@ overflow:
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
+	/*
+	 * Just mark any flag we may have missed and that the application
+	 * should act on unconditionally. Worst case it'll be an extra
+	 * syscall.
+	 */
+	atomic_or(IORING_SQ_TASKRUN | IORING_SQ_NEED_WAKEUP, &n.rings->sq_flags);
 	ctx->rings = n.rings;
+	rcu_assign_pointer(ctx->rings_rcu, n.rings);
+
 	ctx->sq_sqes = n.sq_sqes;
 	swap_old(ctx, o, n, ring_region);
 	swap_old(ctx, o, n, sq_region);
@@ -554,6 +562,10 @@ overflow:
 out:
 	spin_unlock(&ctx->completion_lock);
 	mutex_unlock(&ctx->mmap_lock);
+
+	/* Wait for concurrent io_ctx_mark_taskrun() */
+	if (to_free == &o)
+		synchronize_rcu_expedited();
 	io_register_free_rings(ctx, to_free);
 
 	if (ctx->sq_data)


