Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEE2B67E;
	Wed,  8 Apr 2026 18:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673655; cv=none; b=SBiAqoXvr/tmNrahtynTn0QSHsgpI5xAxYoMBAs+Heuwx+Bnb6merob+wadgcfZuwEpvvyjOf7whzf0ku5D9fmYX6eZc0snPQ9IsRNPQUtN0HN2g0bH3pC1Vjc4NVcR4+k0JGVYUNaa6An7LU3mehFxYXOolZIBqgKQuOGdHt7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673655; c=relaxed/simple;
	bh=8WURPUYzzLt+jBtSUG8xPUboNl0SuI2Ag3NZIjGcb3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQZ7acj9wP8EQkeW4WU+d4+7d+8LF7i+mApUjePXnn3ncCfbuOfs+r+cTR7bU3FeP2QznQM/eVhNIfdcky86CETS7Ekl2+pzxicZ4yT3n2xP/a/H3k14b3t9sVnCQt+X2VA67U13x0kCg01tgFYCCoM15VvUn3WaW0+SlXkZ86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdE1gET8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdE1gET8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94FDC19421;
	Wed,  8 Apr 2026 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673655;
	bh=8WURPUYzzLt+jBtSUG8xPUboNl0SuI2Ag3NZIjGcb3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdE1gET8G1kPzPFlaeRj7UEWIrgQ+T62mcmgHleLDmUZExbtz75oOrs8UrSR7JklS
	 8pYKnNv5ws4u/KXJJevYnoKm5Ltxr55yIPsO5vURKmvYM8BjXB3j/12XwmirVNvGT2
	 xJlzy5fGyPk2ooMixrKchpTz7Fo58BDcIcGy9Fng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 007/242] io_uring/kbuf: uninline __io_put_kbufs
Date: Wed,  8 Apr 2026 20:00:47 +0200
Message-ID: <20260408175927.347004376@linuxfoundation.org>
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

Commit 5d3e51240d89678b87b5dc6987ea572048a0f0eb upstream.

__io_put_kbufs() and other helper functions are too large to be inlined,
compilers would normally refuse to do so. Uninline it and move together
with io_kbuf_commit into kbuf.c.

io_kbuf_commitSigned-off-by: Pavel Begunkov <asml.silence@gmail.com>

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/3dade7f55ad590e811aff83b1ec55c9c04e17b2b.1738724373.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h |   73 +++++++-------------------------------------------------
 2 files changed, 70 insertions(+), 63 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -20,6 +20,9 @@
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
 
+/* Mapped buffer ring, return io_uring_buf from head */
+#define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -29,6 +32,34 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
+bool io_kbuf_commit(struct io_kiocb *req,
+		    struct io_buffer_list *bl, int len, int nr)
+{
+	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
+		return true;
+
+	req->flags &= ~REQ_F_BUFFERS_COMMIT;
+
+	if (unlikely(len < 0))
+		return true;
+
+	if (bl->flags & IOBL_INC) {
+		struct io_uring_buf *buf;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		if (WARN_ON_ONCE(len > buf->len))
+			len = buf->len;
+		buf->len -= len;
+		if (buf->len) {
+			buf->addr += len;
+			return false;
+		}
+	}
+
+	bl->head += nr;
+	return true;
+}
+
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
@@ -337,6 +368,35 @@ int io_buffers_peek(struct io_kiocb *req
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
 }
 
+static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
+{
+	struct io_buffer_list *bl = req->buf_list;
+	bool ret = true;
+
+	if (bl) {
+		ret = io_kbuf_commit(req, bl, len, nr);
+		req->buf_index = bl->bgid;
+	}
+	req->flags &= ~REQ_F_BUFFER_RING;
+	return ret;
+}
+
+unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
+{
+	unsigned int ret;
+
+	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
+
+	if (unlikely(!(req->flags & REQ_F_BUFFER_RING))) {
+		io_kbuf_drop_legacy(req);
+		return ret;
+	}
+
+	if (!__io_put_kbuf_ring(req, len, nbufs))
+		ret |= IORING_CQE_F_BUF_MORE;
+	return ret;
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -84,6 +84,10 @@ int io_register_pbuf_status(struct io_ri
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 void io_kbuf_drop_legacy(struct io_kiocb *req);
 
+unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs);
+bool io_kbuf_commit(struct io_kiocb *req,
+		    struct io_buffer_list *bl, int len, int nr);
+
 void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
@@ -127,76 +131,19 @@ static inline bool io_kbuf_recycle(struc
 /* Mapped buffer ring, return io_uring_buf from head */
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
-static inline bool io_kbuf_commit(struct io_kiocb *req,
-				  struct io_buffer_list *bl, int len, int nr)
-{
-	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
-		return true;
-
-	req->flags &= ~REQ_F_BUFFERS_COMMIT;
-
-	if (unlikely(len < 0))
-		return true;
-
-	if (bl->flags & IOBL_INC) {
-		struct io_uring_buf *buf;
-
-		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
-		if (len > buf->len)
-			len = buf->len;
-		buf->len -= len;
-		if (buf->len) {
-			buf->addr += len;
-			return false;
-		}
-	}
-
-	bl->head += nr;
-	return true;
-}
-
-static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
-{
-	struct io_buffer_list *bl = req->buf_list;
-	bool ret = true;
-
-	if (bl) {
-		ret = io_kbuf_commit(req, bl, len, nr);
-		req->buf_index = bl->bgid;
-	}
-	if (ret && (req->flags & REQ_F_BUF_MORE))
-		ret = false;
-	req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUF_MORE);
-	return ret;
-}
-
-static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
-					  int nbufs, unsigned issue_flags)
-{
-	unsigned int ret;
-
-	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
-		return 0;
-
-	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
-	if (req->flags & REQ_F_BUFFER_RING) {
-		if (!__io_put_kbuf_ring(req, len, nbufs))
-			ret |= IORING_CQE_F_BUF_MORE;
-	} else {
-		io_kbuf_drop_legacy(req);
-	}
-	return ret;
-}
-
 static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
 				       unsigned issue_flags)
 {
-	return __io_put_kbufs(req, len, 1, issue_flags);
+	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return __io_put_kbufs(req, len, 1);
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
 					int nbufs, unsigned issue_flags)
 {
-	return __io_put_kbufs(req, len, nbufs, issue_flags);
+	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
+		return 0;
+	return __io_put_kbufs(req, len, nbufs);
 }
 #endif


