Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF72EE299;
	Thu,  3 Jul 2025 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554560; cv=none; b=KE39IwpOJzEqG72TKjP+nrzw2FWsMsoDHSpeWsEcu/PnheLc0T2tgaFj7PU3flQoq5Vc5Sa0XkVcr6AhcHb8Jg4xVKRan8/61C+ebeGxTJub8phUvN3zyt1jMHyb2D9ZVjjIQy/HYirpZONJU9z/9KG8wCWYTePYD4L+BoGs2OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554560; c=relaxed/simple;
	bh=xNyt9Bb7+e3H2t6LAuckpA2e5vc8hA1agy1C9zqHBIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeJyW/7CERdistA12owTwejFmmNe+lI9DiQl7MJuEkbWHAWKXjToLxwFZyZybn+YUEAKGFNjeAjTE5C5MfK9I2WsK5iwNl3RCj87A6X5wIEpZZcFewTGTBC+rRIy+kUwu+kcFC6i+sMqV0TI2W3lLp3bj+vN9H6chW7XtQhETQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ1r1RjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ1r1RjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529D3C4CEE3;
	Thu,  3 Jul 2025 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554559;
	bh=xNyt9Bb7+e3H2t6LAuckpA2e5vc8hA1agy1C9zqHBIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ1r1RjBUypbtJrpqWoJttn1cgS9Uf9I8CPfin7P7mir+IMcDxygZcr0KLhaH8ddz
	 0yOTLMWJtJ0palk6WYFtIoaDmIcRF3Tvjl2F3gdhNCIE9RC5aoqpLzcpjqmMt2EAVS
	 KW/ZJ1kH7oWQ6Lo8enfNzEzocESC6q5qemjJBd/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 189/218] io_uring/kbuf: flag partial buffer mappings
Date: Thu,  3 Jul 2025 16:42:17 +0200
Message-ID: <20250703144003.754210589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

A previous commit aborted mapping more for a non-incremental ring for
bundle peeking, but depending on where in the process this peeking
happened, it would not necessarily prevent a retry by the user. That can
create gaps in the received/read data.

Add struct buf_sel_arg->partial_map, which can pass this information
back. The networking side can then map that to internal state and use it
to gate retry as well.

Since this necessitates a new flag, change io_sr_msg->retry to a
retry_flags member, and store both the retry and partial map condition
in there.

Cc: stable@vger.kernel.org
Fixes: 26ec15e4b0c1 ("io_uring/kbuf: don't truncate end buffer for multiple buffer peeks")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 178b8ff66ff827c41b4fa105e9aabb99a0b5c537)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    1 +
 io_uring/kbuf.h |    1 +
 io_uring/net.c  |   23 +++++++++++++++--------
 3 files changed, 17 insertions(+), 8 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -263,6 +263,7 @@ static int io_ring_buffers_peek(struct i
 		if (len > arg->max_len) {
 			len = arg->max_len;
 			if (!(bl->flags & IOBL_INC)) {
+				arg->partial_map = 1;
 				if (iov != arg->iovs)
 					break;
 				buf->len = len;
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -61,6 +61,7 @@ struct buf_sel_arg {
 	size_t max_len;
 	unsigned short nr_iovs;
 	unsigned short mode;
+	unsigned short partial_map;
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -76,13 +76,18 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
 	u16				buf_group;
-	bool				retry;
+	unsigned short			retry_flags;
 	void __user			*addr;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
+enum sr_retry_flags {
+	IO_SR_MSG_RETRY		= 1,
+	IO_SR_MSG_PARTIAL_MAP	= 2,
+};
+
 /*
  * Number of times we'll try and do receives if there's more data. If we
  * exceed this limit, then add us to the back of the queue and retry from
@@ -204,7 +209,7 @@ static inline void io_mshot_prep_retry(s
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 	sr->len = 0; /* get from the provided buffer */
 	req->buf_index = sr->buf_group;
 }
@@ -411,7 +416,7 @@ int io_sendmsg_prep(struct io_kiocb *req
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 
 	if (req->opcode == IORING_OP_SEND) {
 		if (READ_ONCE(sqe->__pad3[0]))
@@ -783,7 +788,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry = false;
+	sr->retry_flags = 0;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -856,7 +861,7 @@ static inline bool io_recv_finish(struct
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
-		if (sr->retry)
+		if (sr->retry_flags & IO_SR_MSG_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -865,12 +870,12 @@ static inline bool io_recv_finish(struct
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
+		if (!sr->retry_flags && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
 			sr->done_io += this_ret;
-			sr->retry = true;
+			sr->retry_flags |= IO_SR_MSG_RETRY;
 			return false;
 		}
 	} else {
@@ -1123,6 +1128,8 @@ static int io_recv_buf_select(struct io_
 			kmsg->free_iov = arg.iovs;
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
+		if (arg.partial_map)
+			sr->retry_flags |= IO_SR_MSG_PARTIAL_MAP;
 
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
@@ -1252,7 +1259,7 @@ int io_send_zc_prep(struct io_kiocb *req
 	struct io_kiocb *notif;
 
 	zc->done_io = 0;
-	zc->retry = false;
+	zc->retry_flags = 0;
 	req->flags |= REQ_F_POLL_NO_LAZY;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))


