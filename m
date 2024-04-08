Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827987FBC8;
	Mon,  8 Apr 2024 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583570; cv=none; b=LMirlUn2wIsZDWQSGdO2loq/o5VsFLwfaOGd5slWgxigg2HssnxiNT5y+0RYs6cCTNKYG6tko+mKX2OOwlS+0iruHOImL7Ds8oX5FHjkphBPq+XgIkoNKNtTzgaZ+uJ8cTxpkkAbe3cAFhp7W5j7+O2Ds6+VujnGIj3hHxVzR7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583570; c=relaxed/simple;
	bh=5PY2Noq0WUtP8f2J3VHBWDlldL8BQ+6618ZhTDS/UOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfXckn7UEF5V2vLfGtleSwmrLDOqNop7ju+k8iCz7g47L9K9ZPJWBAo8tBgYbCxBBFviZY2ekjm0a+7APl4hm3hy9GtQdOSFqcPO52dEJ1xItwAhdHJKrnLQGs/vXws5KwvbBB6X9ZnlqXaR8A7u9TeNbUkps5vGnc2AR5rNs1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=us+dv0Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="us+dv0Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B67C433C7;
	Mon,  8 Apr 2024 13:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583570;
	bh=5PY2Noq0WUtP8f2J3VHBWDlldL8BQ+6618ZhTDS/UOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=us+dv0EvIgwjtfho0TUk5sP9P82X1W8gnpSO4NyfFfYEDaynrJghvtR/q//Pct58p
	 ZyTqLHQcpxx9JYLmNpndKR606xbdPTiULpbz8W4GRDSn30O+aefCnColMsxyGTi5Xl
	 dHFL6fTYv6vi7sgR4hMILhjb9u2YpNXkjFNKIGzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 209/252] io_uring/kbuf: get rid of lower BGID lists
Date: Mon,  8 Apr 2024 14:58:28 +0200
Message-ID: <20240408125313.140400563@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 09ab7eff38202159271534d2f5ad45526168f2a5 upstream.

Just rely on the xarray for any kind of bgid. This simplifies things, and
it really doesn't bring us much, if anything.

Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    1 
 io_uring/io_uring.c            |    2 -
 io_uring/kbuf.c                |   70 ++++-------------------------------------
 3 files changed, 8 insertions(+), 65 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -250,7 +250,6 @@ struct io_ring_ctx {
 
 		struct io_submit_state	submit_state;
 
-		struct io_buffer_list	*io_bl;
 		struct xarray		io_bl_xa;
 
 		struct io_hash_table	cancel_table_locked;
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -343,7 +343,6 @@ static __cold struct io_ring_ctx *io_rin
 err:
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
@@ -2934,7 +2933,6 @@ static __cold void io_ring_ctx_free(stru
 		io_wq_put_hash(ctx->hash_map);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
-	kfree(ctx->io_bl);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 }
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -17,8 +17,6 @@
 
 #define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
 
-#define BGID_ARRAY	64
-
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
@@ -31,13 +29,9 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
-static struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
-						   struct io_buffer_list *bl,
-						   unsigned int bgid)
+static inline struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
+							  unsigned int bgid)
 {
-	if (bl && bgid < BGID_ARRAY)
-		return &bl[bgid];
-
 	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
@@ -53,7 +47,7 @@ static inline struct io_buffer_list *io_
 {
 	lockdep_assert_held(&ctx->uring_lock);
 
-	return __io_buffer_get_list(ctx, ctx->io_bl, bgid);
+	return __io_buffer_get_list(ctx, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
@@ -66,10 +60,6 @@ static int io_buffer_add_list(struct io_
 	 */
 	bl->bgid = bgid;
 	smp_store_release(&bl->is_ready, 1);
-
-	if (bgid < BGID_ARRAY)
-		return 0;
-
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
 
@@ -215,24 +205,6 @@ void __user *io_buffer_select(struct io_
 	return ret;
 }
 
-static __cold int io_init_bl_list(struct io_ring_ctx *ctx)
-{
-	struct io_buffer_list *bl;
-	int i;
-
-	bl = kcalloc(BGID_ARRAY, sizeof(struct io_buffer_list), GFP_KERNEL);
-	if (!bl)
-		return -ENOMEM;
-
-	for (i = 0; i < BGID_ARRAY; i++) {
-		INIT_LIST_HEAD(&bl[i].buf_list);
-		bl[i].bgid = i;
-	}
-
-	smp_store_release(&ctx->io_bl, bl);
-	return 0;
-}
-
 /*
  * Mark the given mapped range as free for reuse
  */
@@ -305,13 +277,6 @@ void io_destroy_buffers(struct io_ring_c
 {
 	struct io_buffer_list *bl;
 	unsigned long index;
-	int i;
-
-	for (i = 0; i < BGID_ARRAY; i++) {
-		if (!ctx->io_bl)
-			break;
-		__io_remove_buffers(ctx, &ctx->io_bl[i], -1U);
-	}
 
 	xa_for_each(&ctx->io_bl_xa, index, bl) {
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
@@ -485,12 +450,6 @@ int io_provide_buffers(struct io_kiocb *
 
 	io_ring_submit_lock(ctx, issue_flags);
 
-	if (unlikely(p->bgid < BGID_ARRAY && !ctx->io_bl)) {
-		ret = io_init_bl_list(ctx);
-		if (ret)
-			goto err;
-	}
-
 	bl = io_buffer_get_list(ctx, p->bgid);
 	if (unlikely(!bl)) {
 		bl = kzalloc(sizeof(*bl), GFP_KERNEL_ACCOUNT);
@@ -503,14 +462,9 @@ int io_provide_buffers(struct io_kiocb *
 		if (ret) {
 			/*
 			 * Doesn't need rcu free as it was never visible, but
-			 * let's keep it consistent throughout. Also can't
-			 * be a lower indexed array group, as adding one
-			 * where lookup failed cannot happen.
+			 * let's keep it consistent throughout.
 			 */
-			if (p->bgid >= BGID_ARRAY)
-				kfree_rcu(bl, rcu);
-			else
-				WARN_ON_ONCE(1);
+			kfree_rcu(bl, rcu);
 			goto err;
 		}
 	}
@@ -675,12 +629,6 @@ int io_register_pbuf_ring(struct io_ring
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
-	if (unlikely(reg.bgid < BGID_ARRAY && !ctx->io_bl)) {
-		int ret = io_init_bl_list(ctx);
-		if (ret)
-			return ret;
-	}
-
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -730,10 +678,8 @@ int io_unregister_pbuf_ring(struct io_ri
 		return -EINVAL;
 
 	__io_remove_buffers(ctx, bl, -1U);
-	if (bl->bgid >= BGID_ARRAY) {
-		xa_erase(&ctx->io_bl_xa, bl->bgid);
-		kfree_rcu(bl, rcu);
-	}
+	xa_erase(&ctx->io_bl_xa, bl->bgid);
+	kfree_rcu(bl, rcu);
 	return 0;
 }
 
@@ -741,7 +687,7 @@ void *io_pbuf_get_address(struct io_ring
 {
 	struct io_buffer_list *bl;
 
-	bl = __io_buffer_get_list(ctx, smp_load_acquire(&ctx->io_bl), bgid);
+	bl = __io_buffer_get_list(ctx, bgid);
 
 	if (!bl || !bl->is_mmap)
 		return NULL;


