Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4B72BEFFF;
	Wed,  8 Apr 2026 18:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673585; cv=none; b=uMCMMh9l88U/4WUU49Ic1u8bSTB8S65wJsTOcMRTnmQlRH5x0QITWsf5ETZviKnd9qnHIuoIhsQL/p440vWVwn6LNuLx97SL7OhJwxeyf5zapqnJJX26jmF1jSo5nOnmzDIFTzOFXewtaNKwi3KK68bYBueWcFihgoqCSAKZE70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673585; c=relaxed/simple;
	bh=wuRuvlsKYcuRwcjgl/5/kWzDM9AzKsJFb7c65ouNZvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWiNOYgu0cryeye80Pk0FyVQrp6JZ29gaRg0N6Ty/X2vl2TLqwPvxbvzBq5+0r+HIbCApa4UxGYx8QbXl+rNLW2Ua1i3LjNso4Gmm5voSFZhSxPWV75sMmvd55wu9jaknPR07APFdUUSteXxEs8jSJrGZAH7A1xuqVnrYv+Ws+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbiyYCDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbiyYCDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE35C19421;
	Wed,  8 Apr 2026 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673585;
	bh=wuRuvlsKYcuRwcjgl/5/kWzDM9AzKsJFb7c65ouNZvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbiyYCDjmbp3Q2AZkh1vPg5TgnURmmkS1tP6OdQsbuBENWmXsCgwT1fY4RWKIy30q
	 Mi2pI19BneTAHIPITRkCRiidgcCxY7XsvXoET/aPV6+EAWYJ+pVLS5AAR5WzPdEisL
	 GHTHugW/VWf9i0bV3wIJ6DB5eJau24X9Nwn3DvXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 012/242] io_uring/kbuf: introduce struct io_br_sel
Date: Wed,  8 Apr 2026 20:00:52 +0200
Message-ID: <20260408175927.532244495@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit ab6559bdbb08f6bee606435cd014fc5ba0f7b750 upstream.

Rather than return addresses directly from buffer selection, add a
struct around it. No functional changes in this patch, it's in
preparation for storing more buffer related information locally, rather
than in struct io_kiocb.

Link: https://lore.kernel.org/r/20250821020750.598432-7-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   26 +++++++++++++-------------
 io_uring/kbuf.h |   19 +++++++++++++++++--
 io_uring/net.c  |   18 +++++++++---------
 io_uring/rw.c   |   31 ++++++++++++++++++-------------
 4 files changed, 57 insertions(+), 37 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -152,18 +152,18 @@ static int io_provided_buffers_select(st
 	return 1;
 }
 
-static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
-					  struct io_buffer_list *bl,
-					  unsigned int issue_flags)
+static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
+					      struct io_buffer_list *bl,
+					      unsigned int issue_flags)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	__u16 tail, head = bl->head;
+	struct io_br_sel sel = { };
 	struct io_uring_buf *buf;
-	void __user *ret;
 
 	tail = smp_load_acquire(&br->tail);
 	if (unlikely(tail == head))
-		return NULL;
+		return sel;
 
 	if (head + 1 == tail)
 		req->flags |= REQ_F_BL_EMPTY;
@@ -174,7 +174,7 @@ static void __user *io_ring_buffer_selec
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
-	ret = u64_to_user_ptr(buf->addr);
+	sel.addr = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
 		/*
@@ -191,27 +191,27 @@ static void __user *io_ring_buffer_selec
 			req->flags |= REQ_F_BUF_MORE;
 		req->buf_list = NULL;
 	}
-	return ret;
+	return sel;
 }
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned int issue_flags)
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				  unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_br_sel sel = { };
 	struct io_buffer_list *bl;
-	void __user *ret = NULL;
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
 	if (likely(bl)) {
 		if (bl->flags & IOBL_BUF_RING)
-			ret = io_ring_buffer_select(req, len, bl, issue_flags);
+			sel = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
-			ret = io_provided_buffer_select(req, len, bl);
+			sel.addr = io_provided_buffer_select(req, len, bl);
 	}
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return ret;
+	return sel;
 }
 
 /* cap it at a reasonable 256, will be one page even for 4K */
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -64,8 +64,23 @@ struct buf_sel_arg {
 	unsigned short partial_map;
 };
 
-void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned int issue_flags);
+/*
+ * Return value from io_buffer_list selection. Just returns the error or
+ * user address for now, will be extended to return the buffer list in the
+ * future.
+ */
+struct io_br_sel {
+	/*
+	 * Some selection parts return the user address, others return an error.
+	 */
+	union {
+		void __user *addr;
+		ssize_t val;
+	};
+};
+
+struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
+				 unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      unsigned int issue_flags);
 int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1035,22 +1035,22 @@ int io_recvmsg(struct io_kiocb *req, uns
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		void __user *buf;
+		struct io_br_sel sel;
 		size_t len = sr->len;
 
-		buf = io_buffer_select(req, &len, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, &len, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
 
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
-			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);
+			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);
 			if (ret) {
 				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return ret;
 			}
 		}
 
-		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, buf, len);
+		iov_iter_ubuf(&kmsg->msg.msg_iter, ITER_DEST, sel.addr, len);
 	}
 
 	kmsg->msg.msg_get_inq = 1;
@@ -1144,13 +1144,13 @@ static int io_recv_buf_select(struct io_
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 	} else {
-		void __user *buf;
+		struct io_br_sel sel;
 
 		*len = sr->len;
-		buf = io_buffer_select(req, len, issue_flags);
-		if (!buf)
+		sel = io_buffer_select(req, len, issue_flags);
+		if (!sel.addr)
 			return -ENOBUFS;
-		sr->buf = buf;
+		sr->buf = sel.addr;
 		sr->len = *len;
 map_ubuf:
 		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -88,28 +88,28 @@ static int io_iov_buffer_select_prep(str
 
 static int __io_import_iovec(int ddir, struct io_kiocb *req,
 			     struct io_async_rw *io,
+			     struct io_br_sel *sel,
 			     unsigned int issue_flags)
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct iovec *iov;
-	void __user *buf;
 	int nr_segs, ret;
 	size_t sqe_len;
 
-	buf = u64_to_user_ptr(rw->addr);
+	sel->addr = u64_to_user_ptr(rw->addr);
 	sqe_len = rw->len;
 
 	if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
 		if (io_do_buffer_select(req)) {
-			buf = io_buffer_select(req, &sqe_len, issue_flags);
-			if (!buf)
+			*sel = io_buffer_select(req, &sqe_len, issue_flags);
+			if (!sel->addr)
 				return -ENOBUFS;
-			rw->addr = (unsigned long) buf;
+			rw->addr = (unsigned long) sel->addr;
 			rw->len = sqe_len;
 		}
 
-		return import_ubuf(ddir, buf, sqe_len, &io->iter);
+		return import_ubuf(ddir, sel->addr, sqe_len, &io->iter);
 	}
 
 	if (io->free_iovec) {
@@ -119,7 +119,7 @@ static int __io_import_iovec(int ddir, s
 		iov = &io->fast_iov;
 		nr_segs = 1;
 	}
-	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
+	ret = __import_iovec(ddir, sel->addr, sqe_len, nr_segs, &iov, &io->iter,
 				req->ctx->compat);
 	if (unlikely(ret < 0))
 		return ret;
@@ -134,11 +134,12 @@ static int __io_import_iovec(int ddir, s
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,
 				  struct io_async_rw *io,
+				  struct io_br_sel *sel,
 				  unsigned int issue_flags)
 {
 	int ret;
 
-	ret = __io_import_iovec(rw, req, io, issue_flags);
+	ret = __io_import_iovec(rw, req, io, sel, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -240,6 +241,7 @@ done:
 static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 {
 	struct io_async_rw *rw;
+	struct io_br_sel sel = { };
 	int ret;
 
 	if (io_rw_alloc_async(req))
@@ -249,7 +251,7 @@ static int io_prep_rw_setup(struct io_ki
 		return 0;
 
 	rw = req->async_data;
-	ret = io_import_iovec(ddir, req, rw, 0);
+	ret = io_import_iovec(ddir, req, rw, &sel, 0);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -827,7 +829,8 @@ static int io_rw_init_file(struct io_kio
 	return 0;
 }
 
-static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_read(struct io_kiocb *req, struct io_br_sel *sel,
+		     unsigned int issue_flags)
 {
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -837,7 +840,7 @@ static int __io_read(struct io_kiocb *re
 	loff_t *ppos;
 
 	if (io_do_buffer_select(req)) {
-		ret = io_import_iovec(ITER_DEST, req, io, issue_flags);
+		ret = io_import_iovec(ITER_DEST, req, io, sel, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 	}
@@ -947,9 +950,10 @@ done:
 
 int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_br_sel sel = { };
 	int ret;
 
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
@@ -961,6 +965,7 @@ int io_read(struct io_kiocb *req, unsign
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_br_sel sel = { };
 	unsigned int cflags = 0;
 	int ret;
 
@@ -970,7 +975,7 @@ int io_read_mshot(struct io_kiocb *req,
 	if (!io_file_can_poll(req))
 		return -EBADFD;
 
-	ret = __io_read(req, issue_flags);
+	ret = __io_read(req, &sel, issue_flags);
 
 	/*
 	 * If we get -EAGAIN, recycle our buffer and just let normal poll


