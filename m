Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5453D4134;
	Wed,  8 Apr 2026 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673583; cv=none; b=L40Abf3bXsDusXEUTpH5AkNBbeOQMp6/KCnZTa9JIYb46X2WhGSDKZhnAEUO/xyr8VeS3TpU9piHUVPyhe0vHxS9suoOC6O4wxr3MuhR2tdGARLDC1/GoU4gJ8cDdhLEueS2vSiBISKUyQ/bHc87CVQ0NYZvx0LpVY/KDlTcqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673583; c=relaxed/simple;
	bh=btcFDRUvHHK5XvB19A7Vkafses+NwjETZoX+BBbGug4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oATbI9Pj5F/GjJIx1XNauevI5maOIXaG9Sj481Q1hQW9GCtrfbQuue/ylOO91+cBi06EYu7PblhF2tkL8/XmjyKXyn/+ouytpizSgR9WbiOHpLe1p9zWTMv7mRWMKEa08YYBV47SWHOn4df60fIZkY9Ma3cr8t0O/8Dqrznz+60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLC/g9Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLC/g9Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6440C19421;
	Wed,  8 Apr 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673583;
	bh=btcFDRUvHHK5XvB19A7Vkafses+NwjETZoX+BBbGug4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLC/g9NnAtTUQHtpk1pVZvdxrlMK5hK5DiZZlSuYPHn6NLQ2p/4PwVbL2jLdlruBZ
	 Ng/RU7tL/PF81pccPabW0IDNYjqS3Yy1qT4wyPTDpmZgBVr5Ev4tKx3q92Kchl7fYE
	 5AkTvdXx0+qALW9Xx1uAVpUMtFjBCiGBGQgmwTts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 011/242] io_uring/kbuf: pass in struct io_buffer_list to commit/recycle helpers
Date: Wed,  8 Apr 2026 20:00:51 +0200
Message-ID: <20260408175927.495537831@linuxfoundation.org>
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

Commit 1b5add75d7c894c62506c9b55f1d9eaadae50ef1 upstream.

Rather than have this implied being in the io_kiocb, pass it in directly
so it's immediately obvious where these users of ->buf_list are coming
from.

Link: https://lore.kernel.org/r/20250821020750.598432-6-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    6 +++---
 io_uring/kbuf.c     |    9 +++++----
 io_uring/kbuf.h     |   24 ++++++++++++++----------
 io_uring/net.c      |   30 +++++++++++++-----------------
 io_uring/poll.c     |    6 +++---
 io_uring/rw.c       |   16 ++++++++--------
 6 files changed, 46 insertions(+), 45 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -921,7 +921,7 @@ void io_req_defer_failed(struct io_kiocb
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res));
+	io_req_set_res(req, res, io_put_kbuf(req, res, req->buf_list));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
@@ -1921,11 +1921,11 @@ static void io_queue_async(struct io_kio
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -368,9 +368,9 @@ int io_buffers_peek(struct io_kiocb *req
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
 }
 
-static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
+static inline bool __io_put_kbuf_ring(struct io_kiocb *req,
+				      struct io_buffer_list *bl, int len, int nr)
 {
-	struct io_buffer_list *bl = req->buf_list;
 	bool ret = true;
 
 	if (bl) {
@@ -381,7 +381,8 @@ static inline bool __io_put_kbuf_ring(st
 	return ret;
 }
 
-unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs)
+unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
+			    int len, int nbufs)
 {
 	unsigned int ret;
 
@@ -392,7 +393,7 @@ unsigned int __io_put_kbufs(struct io_ki
 		return ret;
 	}
 
-	if (!__io_put_kbuf_ring(req, len, nbufs))
+	if (!__io_put_kbuf_ring(req, bl, len, nbufs))
 		ret |= IORING_CQE_F_BUF_MORE;
 	return ret;
 }
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -84,7 +84,8 @@ int io_register_pbuf_status(struct io_ri
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 void io_kbuf_drop_legacy(struct io_kiocb *req);
 
-unsigned int __io_put_kbufs(struct io_kiocb *req, int len, int nbufs);
+unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
+			    int len, int nbufs);
 bool io_kbuf_commit(struct io_kiocb *req,
 		    struct io_buffer_list *bl, int len, int nr);
 
@@ -93,7 +94,8 @@ struct io_buffer_list *io_pbuf_get_bl(st
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
-static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
+static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
+					struct io_buffer_list *bl)
 {
 	/*
 	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
@@ -102,8 +104,8 @@ static inline bool io_kbuf_recycle_ring(
 	 * The exception is partial io, that case we should increment bl->head
 	 * to monopolize the buffer.
 	 */
-	if (req->buf_list) {
-		req->buf_index = req->buf_list->bgid;
+	if (bl) {
+		req->buf_index = bl->bgid;
 		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
@@ -117,32 +119,34 @@ static inline bool io_do_buffer_select(s
 	return !(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING));
 }
 
-static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
+static inline bool io_kbuf_recycle(struct io_kiocb *req, struct io_buffer_list *bl,
+				   unsigned issue_flags)
 {
 	if (req->flags & REQ_F_BL_NO_RECYCLE)
 		return false;
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
-		return io_kbuf_recycle_ring(req);
+		return io_kbuf_recycle_ring(req, bl);
 	return false;
 }
 
 /* Mapped buffer ring, return io_uring_buf from head */
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len)
+static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
+				       struct io_buffer_list *bl)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbufs(req, len, 1);
+	return __io_put_kbufs(req, bl, len, 1);
 }
 
 static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
-					int nbufs)
+					struct io_buffer_list *bl, int nbufs)
 {
 	if (!(req->flags & (REQ_F_BUFFER_RING | REQ_F_BUFFER_SELECTED)))
 		return 0;
-	return __io_put_kbufs(req, len, nbufs);
+	return __io_put_kbufs(req, bl, len, nbufs);
 }
 #endif
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -498,12 +498,12 @@ static int io_bundle_nbufs(struct io_asy
 	return nbufs;
 }
 
-static int io_net_kbuf_recyle(struct io_kiocb *req,
+static int io_net_kbuf_recyle(struct io_kiocb *req, struct io_buffer_list *bl,
 			      struct io_async_msghdr *kmsg, int len)
 {
 	req->flags |= REQ_F_BL_NO_RECYCLE;
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
-		io_kbuf_commit(req, req->buf_list, len, io_bundle_nbufs(kmsg, len));
+		io_kbuf_commit(req, bl, len, io_bundle_nbufs(kmsg, len));
 	return -EAGAIN;
 }
 
@@ -515,11 +515,11 @@ static inline bool io_send_finish(struct
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret);
+		cflags = io_put_kbuf(req, *ret, req->buf_list);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret));
+	cflags = io_put_kbufs(req, *ret, req->buf_list, io_bundle_nbufs(kmsg, *ret));
 
 	/*
 	 * Don't start new bundles if the buffer list is empty, or if the
@@ -675,7 +675,7 @@ retry_bundle:
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -869,7 +869,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret));
+		cflags |= io_put_kbufs(req, this_ret, req->buf_list, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->retry_flags & IO_SR_MSG_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
@@ -888,7 +888,7 @@ static inline bool io_recv_finish(struct
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, *ret);
+		cflags |= io_put_kbuf(req, *ret, req->buf_list);
 	}
 
 	/*
@@ -1045,7 +1045,7 @@ retry_multishot:
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);
 			if (ret) {
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return ret;
 			}
 		}
@@ -1070,15 +1070,11 @@ retry_multishot:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			if (issue_flags & IO_URING_F_MULTISHOT) {
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
 			return -EAGAIN;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
-			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
-		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1091,7 +1087,7 @@ retry_multishot:
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
@@ -1209,7 +1205,7 @@ retry_multishot:
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			if (issue_flags & IO_URING_F_MULTISHOT) {
-				io_kbuf_recycle(req, issue_flags);
+				io_kbuf_recycle(req, req->buf_list, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
 
@@ -1219,7 +1215,7 @@ retry_multishot:
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, kmsg, ret);
+			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1235,7 +1231,7 @@ out_free:
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -356,10 +356,10 @@ void io_poll_task_func(struct io_kiocb *
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, 0);
+		io_kbuf_recycle(req, req->buf_list, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -753,7 +753,7 @@ int io_arm_poll_handler(struct io_kiocb
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, issue_flags);
+	io_kbuf_recycle(req, req->buf_list, issue_flags);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -520,7 +520,7 @@ void io_req_rw_complete(struct io_kiocb
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, req->buf_list);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, ts);
@@ -602,7 +602,7 @@ static int kiocb_done(struct io_kiocb *r
 			 */
 			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
-				       io_put_kbuf(req, ret));
+				       io_put_kbuf(req, ret, req->buf_list));
 			io_req_rw_cleanup(req, issue_flags);
 			return IOU_OK;
 		}
@@ -954,7 +954,7 @@ int io_read(struct io_kiocb *req, unsign
 		return kiocb_done(req, ret, issue_flags);
 
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 	return ret;
 }
 
@@ -981,17 +981,17 @@ int io_read_mshot(struct io_kiocb *req,
 		 * Reset rw->len to 0 again to avoid clamping future mshot
 		 * reads, in case the buffer size varies.
 		 */
-		if (io_kbuf_recycle(req, issue_flags))
+		if (io_kbuf_recycle(req, req->buf_list, issue_flags))
 			rw->len = 0;
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			return IOU_ISSUE_SKIP_COMPLETE;
 		return -EAGAIN;
 	} else if (ret <= 0) {
-		io_kbuf_recycle(req, issue_flags);
+		io_kbuf_recycle(req, req->buf_list, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		cflags = io_put_kbuf(req, ret);
+		cflags = io_put_kbuf(req, ret, req->buf_list);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -999,7 +999,7 @@ int io_read_mshot(struct io_kiocb *req,
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret);
+		cflags = io_put_kbuf(req, ret, req->buf_list);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1210,7 +1210,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res, req->buf_list);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}


