Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F47D091;
	Mon,  8 Apr 2024 13:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583710; cv=none; b=N1d9V3uL9TpWXfN3g7MY2/npOfKnW0w+X1JNw4ALrPgr14MBdPfccexNIIHBf7ESsMUjIC+0+mk5sQKc/Q+CGlO1aWoEpPCdNzZ1qD46hjt6kYvvWpOBrDvhzqBQILGcxRe+Rq++3fRDXbByFuNE0VVoZ0SglUZu0YphyKiov7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583710; c=relaxed/simple;
	bh=B8gkt2hV06x7DQZXXRneoKufbaipLGRCGKQoIl9yWWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2GBRunbqZHaVTzAkgkgwu3SWNBvXi+mjuIBy9iWp32zFKykvaqfiO8zKRlphwmpHokMbtUiSu0nrhvV0WLAiOsniNprY3+Ki2Xb8jHIhYG+Rl/+youowXcpprC2wkh4o2A+/GwkFEGAufmXqsUVd8nHLfjQE0d02eYyJwW7Zws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=th0ZisY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="th0ZisY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1844C43390;
	Mon,  8 Apr 2024 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583710;
	bh=B8gkt2hV06x7DQZXXRneoKufbaipLGRCGKQoIl9yWWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=th0ZisY95oqkXi4sWO3IVbgLSmVciHXkfJ3QvjJiSLGsWo6DGe8npVWR3Mt0tGaS7
	 wG/0S9IS0lj0wJ45aPos7oR3krfGw0S1GEXrYZFAC4YOyPwKTblqOJmm0p238MqEdK
	 KNAdyBzPgmTIIJ/mb/mv2ABiAxG+JpGe2PX7HxCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 211/273] io_uring/kbuf: hold io_buffer_list reference over mmap
Date: Mon,  8 Apr 2024 14:58:06 +0200
Message-ID: <20240408125315.910064424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3422,14 +3422,15 @@ static void *io_uring_validate_mmap_requ
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
@@ -275,7 +275,7 @@ static int __io_remove_buffers(struct io
 	return i;
 }
 
-static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (atomic_dec_and_test(&bl->refs)) {
 		__io_remove_buffers(ctx, bl, -1U);
@@ -728,16 +728,35 @@ int io_register_pbuf_status(struct io_ri
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
@@ -61,7 +61,9 @@ unsigned int __io_put_kbuf(struct io_kio
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
+struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
+				      unsigned long bgid);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {


