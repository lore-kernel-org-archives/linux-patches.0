Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5265F3D6694;
	Wed,  8 Apr 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673588; cv=none; b=ZxuNPZJkrsOj89lXTXHWPlFzNj0wsRTDeX3LX6PRoMmO4mCebEeo9U953vQMOv7QLaxOy0EEXGwsAdJhjwMyUDQDUu/M4IxOhcRG/IAsJtLZO5ZcojDyyEoYoX0JdBDqoipUY1mMO9hLDPv+KCXB2b7HRjBKhA+xOuaqtmxuL5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673588; c=relaxed/simple;
	bh=YaICr2z5x/eCP5c5lSPADEI5/dx7IrjQ0+SjYJRfDTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxTpLR4qF5otkYlxcifuHssJrzd7eiOwhYDWNSdywrvUW/T3g7frP2VifKAyHque0SL31HnHsH/H9a/bwSAiB2FeOmbLIpTdgQ9NIvIYg4eJ/ZIVYMorJNOOprn9OXFIGvnyA7KuDELlWBcWgAuGWCzv7IowWhw242Q31LvsQIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPexvmmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPexvmmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC95AC19425;
	Wed,  8 Apr 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673588;
	bh=YaICr2z5x/eCP5c5lSPADEI5/dx7IrjQ0+SjYJRfDTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPexvmmdAZ92gH9/vnEz5evLrt81mByRn4/OONZni5qtSeOSFMCY8e61jSW80gIF1
	 1prW9S8WsH6jO7u/v3R1JYSRkn87G7Qc2GndUpjR4ShJSjdJykBkwgKIBuJOGxb2mz
	 UC8yxU+WzBVtLW7bl5KVNXwjw20pI/qa2bZB/tFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 013/242] io_uring/kbuf: use struct io_br_sel for multiple buffers picking
Date: Wed,  8 Apr 2026 20:00:53 +0200
Message-ID: <20260408175927.569058119@linuxfoundation.org>
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

Commit 429884ff35f75a8ac3e8f822f483e220e3ea6394 upstream.

The networking side uses bundles, which is picking multiple buffers at
the same time. Pass in struct io_br_sel to those helpers.

Link: https://lore.kernel.org/r/20250821020750.598432-9-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |    5 +++--
 io_uring/kbuf.h |    5 +++--
 io_uring/net.c  |   31 +++++++++++++++++--------------
 3 files changed, 23 insertions(+), 18 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -312,7 +312,7 @@ static int io_ring_buffers_peek(struct i
 }
 
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
-		      unsigned int issue_flags)
+		      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -345,7 +345,8 @@ out_unlock:
 	return ret;
 }
 
-int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
+		    struct io_br_sel *sel)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -82,8 +82,9 @@ struct io_br_sel {
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				 unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
-		      unsigned int issue_flags);
-int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
+		      struct io_br_sel *sel, unsigned int issue_flags);
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
+		    struct io_br_sel *sel);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -597,6 +597,7 @@ int io_send(struct io_kiocb *req, unsign
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -633,7 +634,7 @@ retry_bundle:
 		else
 			arg.mode |= KBUF_MODE_EXPAND;
 
-		ret = io_buffers_select(req, &arg, issue_flags);
+		ret = io_buffers_select(req, &arg, &sel, issue_flags);
 		if (unlikely(ret < 0))
 			return ret;
 
@@ -1015,6 +1016,7 @@ int io_recvmsg(struct io_kiocb *req, uns
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1035,7 +1037,6 @@ int io_recvmsg(struct io_kiocb *req, uns
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		struct io_br_sel sel;
 		size_t len = sr->len;
 
 		sel = io_buffer_select(req, &len, issue_flags);
@@ -1096,7 +1097,7 @@ retry_multishot:
 }
 
 static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
-			      size_t *len, unsigned int issue_flags)
+			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
@@ -1120,10 +1121,12 @@ static int io_recv_buf_select(struct io_
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(sr->len, kmsg->msg.msg_inq);
+		if (sel->val)
+			arg.max_len = sel->val;
+		else if (kmsg->msg.msg_inq > 1)
+			arg.max_len = min_not_zero(sel->val, (size_t) kmsg->msg.msg_inq);
 
-		ret = io_buffers_peek(req, &arg);
+		ret = io_buffers_peek(req, &arg, sel);
 		if (unlikely(ret < 0))
 			return ret;
 
@@ -1144,14 +1147,13 @@ static int io_recv_buf_select(struct io_
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 	} else {
-		struct io_br_sel sel;
+		size_t len = sel->val;
 
-		*len = sr->len;
-		sel = io_buffer_select(req, len, issue_flags);
-		if (!sel.addr)
+		*sel = io_buffer_select(req, &len, issue_flags);
+		if (!sel->addr)
 			return -ENOBUFS;
-		sr->buf = sel.addr;
-		sr->len = *len;
+		sr->buf = sel->addr;
+		sr->len = len;
 map_ubuf:
 		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
@@ -1166,11 +1168,11 @@ int io_recv(struct io_kiocb *req, unsign
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	size_t len = sr->len;
 	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
@@ -1187,7 +1189,8 @@ int io_recv(struct io_kiocb *req, unsign
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
+		sel.val = sr->len;
+		ret = io_recv_buf_select(req, kmsg, &sel, issue_flags);
 		if (unlikely(ret < 0)) {
 			kmsg->msg.msg_inq = -1;
 			goto out_free;


