Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC93D669E;
	Wed,  8 Apr 2026 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673658; cv=none; b=b73bxwEbPbt+lHvgFTnRFXORs2ntvfST4ei8xKepAJvaeq2bX9kScch0ZX0jInUlSGV0OPC7qCA2rkcoFpLAVUnwV5gpZfvKNIwKxBe/cSHjdjiWkMwpSAEhJY/EOLc2DFHA6CYn1WXDoWvpNGwvc8JEcYmc7N4jTvL8li9vn/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673658; c=relaxed/simple;
	bh=q5ctTHQJGfVGzyes7uINrPp7JAB0td4UfeV3iwnwzEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etZk3oEjYgBrQ0F9/8srbdqA2NYYKY4vkR8BeTIjCBs2LMVsVu+7zXJNVWsILaWu/obcYWnZ+CfPS5CpV87qngRnxJEIT0C0B5eVah/byAqRKq72HPujq2ZDlEpJiesLSIG/aLFlXk+pbn+/5j6u5nj2houAlXMquYLoE6GnbAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+qklmPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+qklmPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79195C19421;
	Wed,  8 Apr 2026 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673657;
	bh=q5ctTHQJGfVGzyes7uINrPp7JAB0td4UfeV3iwnwzEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+qklmPxJ0du0JjZaAU2nzjAgYMjqpkSiOy7Cg3rs6zETyqBAMx5pax1+Y4DUE/kD
	 Fjq6tyFdA4wmv+qaG+p8Ij92NkvkOlp3xTNh5nQSggCOm8SWypUgn59ymlpLiLHzeG
	 CrtYyutXe4HyiEgTuOVh17GRmBmZX52xunNonGZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 008/242] io_uring/kbuf: drop issue_flags from io_put_kbuf(s)() arguments
Date: Wed,  8 Apr 2026 20:00:48 +0200
Message-ID: <20260408175927.384707134@linuxfoundation.org>
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

Commit 5e73b402cbbea51bcab90fc5ee6c6d06af76ae1b upstream.

Picking multiple buffers always requires the ring lock to be held across
the operation, so there's no need to pass in the issue_flags to
io_put_kbufs(). On the single buffer side, if the initial picking of a
ring buffer was unlocked, then it will have been committed already. For
legacy buffers, no locking is required, as they will simply be freed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 io_uring/kbuf.h     |    5 ++---
 io_uring/net.c      |   14 ++++++--------
 io_uring/rw.c       |   10 +++++-----
 4 files changed, 14 insertions(+), 17 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -921,7 +921,7 @@ void io_req_defer_failed(struct io_kiocb
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res, IO_URING_F_UNLOCKED));
+	io_req_set_res(req, res, io_put_kbuf(req, res));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -131,8 +131,7 @@ static inline bool io_kbuf_recycle(struc
 /* Mapped buffer ring, return io_uring_buf from head */
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
-				       unsigned issue_flags)
+static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
@@ -140,7 +139,7 @@ static inline unsigned int io_put_kbuf(s
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
-					int nbufs, unsigned issue_flags)
+					int nbufs)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -508,19 +508,18 @@ static int io_net_kbuf_recyle(struct io_
 }
 
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
-				  struct io_async_msghdr *kmsg,
-				  unsigned issue_flags)
+				  struct io_async_msghdr *kmsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	bool bundle_finished = *ret <= 0;
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, issue_flags);
+		cflags = io_put_kbuf(req, *ret);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret));
 
 	/*
 	 * Don't start new bundles if the buffer list is empty, or if the
@@ -687,7 +686,7 @@ retry_bundle:
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	if (!io_send_finish(req, &ret, kmsg, issue_flags))
+	if (!io_send_finish(req, &ret, kmsg))
 		goto retry_bundle;
 
 	io_req_msg_cleanup(req, issue_flags);
@@ -870,8 +869,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
-				      issue_flags);
+		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->retry_flags & IO_SR_MSG_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
@@ -890,7 +888,7 @@ static inline bool io_recv_finish(struct
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret, issue_flags);
+		cflags |= io_put_kbuf(req, *ret);
 	}
 
 	/*
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -520,7 +520,7 @@ void io_req_rw_complete(struct io_kiocb
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, ts);
@@ -602,7 +602,7 @@ static int kiocb_done(struct io_kiocb *r
 			 */
 			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
-				       io_put_kbuf(req, ret, issue_flags));
+				       io_put_kbuf(req, ret));
 			io_req_rw_cleanup(req, issue_flags);
 			return IOU_OK;
 		}
@@ -991,7 +991,7 @@ int io_read_mshot(struct io_kiocb *req,
 		if (ret < 0)
 			req_set_fail(req);
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -999,7 +999,7 @@ int io_read_mshot(struct io_kiocb *req,
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret, issue_flags);
+		cflags = io_put_kbuf(req, ret);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1210,7 +1210,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, 0);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}


