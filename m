Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E1551599F;
	Thu, 17 Sep 2026 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666364; cv=none; b=kDQzuWvmtJ2D3qkdLx5aOSvfn5AZD8hhhnA36m9KIBVSa1oZ1qs4IcEMhuo3sy1pGoOeE406FX6YkPQUt8lNpbMJwmphSF5yWHh9cbQcC79848JUcf9Fovma5/Pewp1G4Q7ALWqZGzX7JBHQuRF9FfCc2d+b256Xw8xTruYB57A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666364; c=relaxed/simple;
	bh=opRGvCurkDaESLXpYJ1seyset579P2DGFJ3ofMg3r0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drZgaD7fOSPyV2Uee+Ain/i69SwSWBZor3f3stxhgiga4BvrTaev/PjiGn/MdRfp2IXeUhDArLhIkwk8PXh4KLWBfCxw4Kb7aN6aY35hNqtxRaTszoZFhJL3T+RPMLunSXAMEUWUOEbMR57f9nSbz2enI8AIxcC+c4HfZNbaRSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HywQc9r3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HywQc9r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2861F000FF;
	Thu, 17 Sep 2026 17:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666363;
	bh=NY6nwb0dE6c0Rt/jAApWfGbFTsrO/Sk4JBqp2ISZEkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HywQc9r3VUoFEdSB1yGFOe56+pWC77QbcYbSj45B56jaSsF/+KA+S6wH7pIJsqzAa
	 MvoEi67OVdrpzPkotDpYZwHYZQEsALGmANWNMI/aqNbpBYJp4fMjPC5PoprI2UyOdH
	 S1LlxVR2/ugnk2O0CQUobC3FyTTD/pOe71BUUVwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 1011/1250] io_uring/net: dont overconsume buffers when using MSG_TRUNC
Date: Thu, 17 Sep 2026 16:13:26 +0100
Message-ID: <20260917151619.450379425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

commit 6028b543884f8735e057ec9eea4908cd61cab230 upstream.

When a recv/recvmsg is issued with MSG_TRUNC and the incoming packet is
larger than the provided buffer, the net layer returns the full length
of the packet rather than the number of bytes actually copied into the
buffer.  As a result, io_uring advances more of the provided buffer ring
than was actually filled.  Use the actual filled region size to consume
the buffer, but still return the full size to preserve MSG_TRUNC
semantics.

Take care with multishot, because that seems to already truncate the
consumption based on the available payload size.

This was reported in https://github.com/axboe/liburing/issues/1619.

Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260728191454.1850326-1-krisman@suse.de
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260902230041.1320658-3-krisman@suse.de
[axboe: fold in size_t unsigned fix]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -852,7 +852,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 static inline bool io_recv_finish(struct io_kiocb *req,
 				  struct io_async_msghdr *kmsg,
 				  struct io_br_sel *sel, bool mshot_finished,
-				  unsigned issue_flags)
+				  unsigned issue_flags, int consumed)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags = 0;
@@ -876,7 +876,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = sel->val - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, sel->buf_list, io_bundle_nbufs(kmsg, this_ret));
+		cflags |= io_put_kbufs(req, consumed, sel->buf_list, io_bundle_nbufs(kmsg, consumed));
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && sel->val >= sr->mshot_len)
@@ -898,7 +898,7 @@ static inline bool io_recv_finish(struct
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, sel->val, sel->buf_list);
+		cflags |= io_put_kbuf(req, consumed, sel->buf_list);
 	}
 
 	/*
@@ -1026,6 +1026,8 @@ int io_recvmsg(struct io_kiocb *req, uns
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished = true;
+	int consumed = 0;
+	size_t len;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -1041,9 +1043,8 @@ int io_recvmsg(struct io_kiocb *req, uns
 
 retry_multishot:
 	sel.buf_list = NULL;
+	len = sr->len;
 	if (io_do_buffer_select(req)) {
-		size_t len = sr->len;
-
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel.addr)
 			return -ENOBUFS;
@@ -1064,6 +1065,7 @@ retry_multishot:
 	if (req->flags & REQ_F_APOLL_MULTISHOT) {
 		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
 					   &mshot_finished);
+		consumed = ret;
 	} else {
 		/* disable partial retry for recvmsg with cmsg attached */
 		if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
@@ -1071,6 +1073,15 @@ retry_multishot:
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg,
 					 kmsg->uaddr, flags);
+		/*
+		 * With MSG_TRUNC, the net layer will return the full size of
+		 * the packet, even if we only filled part of it in the buffers.
+		 * Adjust the returned size to consume only the real part of the
+		 * buffer.
+		 */
+		consumed = ret;
+		if (ret > 0)
+			consumed = min_t(size_t, ret, len);
 	}
 
 	if (ret < min_ret) {
@@ -1097,7 +1108,7 @@ retry_multishot:
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
-	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags, consumed))
 		goto retry_multishot;
 
 	return sel.val;
@@ -1184,9 +1195,10 @@ int io_recv(struct io_kiocb *req, unsign
 	struct io_br_sel sel;
 	struct socket *sock;
 	unsigned flags;
-	int ret, min_ret = 0;
+	int ret, min_ret = 0, consumed = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished;
+	size_t len = 0;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -1202,6 +1214,7 @@ int io_recv(struct io_kiocb *req, unsign
 
 retry_multishot:
 	sel.buf_list = NULL;
+	len = sr->len;
 	if (io_do_buffer_select(req)) {
 		sel.val = sr->len;
 		ret = io_recv_buf_select(req, kmsg, &sel, issue_flags);
@@ -1209,6 +1222,7 @@ retry_multishot:
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
 		}
+		len = ret;
 		sr->buf = NULL;
 	}
 
@@ -1239,6 +1253,17 @@ out_free:
 	}
 
 	mshot_finished = ret <= 0;
+
+	/*
+	 * With MSG_TRUNC, the net layer will return the full size of
+	 * the packet, even if we only filled part of it in the buffers.
+	 * Adjust the returned size to consume only the real part of the
+	 * buffer.
+	 */
+	consumed = ret;
+	if (ret > 0)
+		consumed = min_t(size_t, ret, len);
+
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -1247,7 +1272,7 @@ out_free:
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
-	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags, consumed))
 		goto retry_multishot;
 
 	return sel.val;


