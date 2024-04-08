Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA385C62;
	Mon,  8 Apr 2024 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583804; cv=none; b=OfHqIBqhXEHet6WNuuYH61c7t66xjZWlBRbuCwtiIto2wu6d5VmjXp0P2IpMD4v9J4Q/hyU027hbTR7u7+caeX/syCcfWJpRUHkqba4Y0xzxTuTtqxJObJLgdxa9tBxUZ1xOkhQhVEtR+JEYSGM8bkfoP268Wdu+RoqpBgdkHTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583804; c=relaxed/simple;
	bh=UB7h9nRoHHN/eCGTQS25C0A8AUf77r0kDWBeA33/Ep4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUYsvsrDnXDIyurFqnGjhKem0wCNBRWlvSDC1Lzr37GCQx2f9TYxSWz0Xi48/MkzBpgKqzev91nckM83ZVMWy2pmzo1ubKYc+7+Ydyk3FkQXMiaPsneFBuFAhcpAWZoaZl/E69xEBSeXD2vhZ+HqU69ediydgM0/eMUytELRE4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UW0akM89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UW0akM89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D5C43390;
	Mon,  8 Apr 2024 13:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583803;
	bh=UB7h9nRoHHN/eCGTQS25C0A8AUf77r0kDWBeA33/Ep4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UW0akM896nE9Og6sFmihgcfURgnk28GAxCfVUwOlW/2NvmHF29ufAikeeEdYSPBq1
	 h1H7wvzq1wK65SUs955M32Z1UtH+UijgaVSM+w7gZqZydBI6PYLJrJFxLzyrBbVI6X
	 6+H1YZdOM4pbVYLxtRq8dE31dHRiX2roVRdo4H7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 213/252] io_uring/kbuf: hold io_buffer_list reference over mmap
Date: Mon,  8 Apr 2024 14:58:32 +0200
Message-ID: <20240408125313.272095078@linuxfoundation.org>
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

commit 561e4f9451d65fc2f7eef564e0064373e3019793 upstream.

If we look up the kbuf, ensure that it doesn't get unregistered until
after we're done with it. Since we're inside mmap, we cannot safely use
the io_uring lock. Rely on the fact that we can lookup the buffer list
under RCU now and grab a reference to it, preventing it from being
unregistered until we're done with it. The lookup returns the
io_buffer_list directly with it referenced.

Cc: stable@vger.kernel.org # v6.4+
Fixes: 5cf4f52e6d8a ("io_uring: free io_buffer_list entries via RCU")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   11 ++++++-----
 io_uring/kbuf.c     |   31 +++++++++++++++++++++++++------
 io_uring/kbuf.h     |    4 +++-
 3 files changed, 34 insertions(+), 12 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3429,14 +3429,15 @@ static void *io_uring_validate_mmap_requ
 		ptr = ctx->sq_sqes;
 		break;
 	case IORING_OFF_PBUF_RING: {
+		struct io_buffer_list *bl;
 		unsigned int bgid;
 
 		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		rcu_read_lock();
-		ptr = io_pbuf_get_address(ctx, bgid);
-		rcu_read_unlock();
-		if (!ptr)
-			return ERR_PTR(-EINVAL);
+		bl = io_pbuf_get_bl(ctx, bgid);
+		if (IS_ERR(bl))
+			return bl;
+		ptr = bl->buf_ring;
+		io_put_bl(ctx, bl);
 		break;
 		}
 	default:
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -273,7 +273,7 @@ static int __io_remove_buffers(struct io
 	return i;
 }
 
-static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (atomic_dec_and_test(&bl->refs)) {
 		__io_remove_buffers(ctx, bl, -1U);
@@ -689,16 +689,35 @@ int io_unregister_pbuf_ring(struct io_ri
 	return 0;
 }
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
+struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
+				      unsigned long bgid)
 {
 	struct io_buffer_list *bl;
+	bool ret;
 
-	bl = __io_buffer_get_list(ctx, bgid);
+	/*
+	 * We have to be a bit careful here - we're inside mmap and cannot grab
+	 * the uring_lock. This means the buffer_list could be simultaneously
+	 * going away, if someone is trying to be sneaky. Look it up under rcu
+	 * so we know it's not going away, and attempt to grab a reference to
+	 * it. If the ref is already zero, then fail the mapping. If successful,
+	 * the caller will call io_put_bl() to drop the the reference at at the
+	 * end. This may then safely free the buffer_list (and drop the pages)
+	 * at that point, vm_insert_pages() would've already grabbed the
+	 * necessary vma references.
+	 */
+	rcu_read_lock();
+	bl = xa_load(&ctx->io_bl_xa, bgid);
+	/* must be a mmap'able buffer ring and have pages */
+	ret = false;
+	if (bl && bl->is_mmap)
+		ret = atomic_inc_not_zero(&bl->refs);
+	rcu_read_unlock();
 
-	if (!bl || !bl->is_mmap)
-		return NULL;
+	if (ret)
+		return bl;
 
-	return bl->buf_ring;
+	return ERR_PTR(-EINVAL);
 }
 
 /*
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -60,7 +60,9 @@ unsigned int __io_put_kbuf(struct io_kio
 
 void io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
+struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
+				      unsigned long bgid);
 
 static inline void io_kbuf_recycle_ring(struct io_kiocb *req)
 {


