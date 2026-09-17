Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E360C4F391C;
	Thu, 17 Sep 2026 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660394; cv=none; b=WKbui6sY82juvdhiaSriAgxF2bM0nEOqVr3BFJvqYAN9u8SqRh59iYOfrWkIjRF22TAWKphIguyJ/odg3P20jBU+wU7QuJ+wsaJJ/m1TLYmHjnNJpaG+OJ5irgcjChFi0gl+uwRGM4e2zotqSkX66UX49wDLaJ8Ur2UxnQ4ObJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660394; c=relaxed/simple;
	bh=VfrU0eAGyFBa+4HrkBp+fVtX7zCekjY+aaaSgpvjnZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNwaFKqgdm8E0v1WZ/5yml+ujyf0+g1I2J6sKRtpIXZNH9PIsj7frohrSls4969K8mt02wiRTinweiuoiMOGBHoFX2Q+8TUUidCTkCVreYQsuZN0eLATnqjz3w3+lxgdfB0+oX+M6mMuXkBEWLO/2XWI4q0n2SzfNPBI+RhP1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOYogN9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOYogN9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F381F000FF;
	Thu, 17 Sep 2026 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660392;
	bh=tJNXzEPzGX4X2SrHCyI9oQx6hcdl7G8LPgAqZhjTmY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOYogN9KX7kRXZhFvHwQKuOiZnJ+ZUXWcyWWbNOptaZ9sbG8j9sTqkmB2tXgh1U1S
	 Mfu173CBHzpnhW0r98wdpwtE5KN6BoiTPU0ZhX36Vseuv9/h2och50xZHCUpN4KW16
	 AqHvz9z5Q/RVQIEJhLe1gxSkqb4fWFHKD+x8ihtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 539/733] io_uring/net: dont overconsume buffers when using MSG_TRUNC
Date: Thu, 17 Sep 2026 16:14:07 +0100
Message-ID: <20260917151405.654449262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -884,7 +884,7 @@ int io_recvmsg_prep(struct io_kiocb *req
 static inline bool io_recv_finish(struct io_kiocb *req,
 				  struct io_async_msghdr *kmsg,
 				  struct io_br_sel *sel, bool mshot_finished,
-				  unsigned issue_flags)
+				  unsigned issue_flags, int consumed)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	unsigned int cflags = 0;
@@ -908,7 +908,7 @@ static inline bool io_recv_finish(struct
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = sel->val - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, sel->buf_list, io_bundle_nbufs(kmsg, this_ret));
+		cflags |= io_put_kbufs(req, consumed, sel->buf_list, io_bundle_nbufs(kmsg, consumed));
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && sel->val >= sr->mshot_len)
@@ -930,7 +930,7 @@ static inline bool io_recv_finish(struct
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, sel->val, sel->buf_list);
+		cflags |= io_put_kbuf(req, consumed, sel->buf_list);
 	}
 
 	/*
@@ -1058,6 +1058,8 @@ int io_recvmsg(struct io_kiocb *req, uns
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished = true;
+	int consumed = 0;
+	size_t len;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -1073,9 +1075,8 @@ int io_recvmsg(struct io_kiocb *req, uns
 
 retry_multishot:
 	sel.buf_list = NULL;
+	len = sr->len;
 	if (io_do_buffer_select(req)) {
-		size_t len = sr->len;
-
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!sel.addr)
 			return -ENOBUFS;
@@ -1096,6 +1097,7 @@ retry_multishot:
 	if (req->flags & REQ_F_APOLL_MULTISHOT) {
 		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
 					   &mshot_finished);
+		consumed = ret;
 	} else {
 		/* disable partial retry for recvmsg with cmsg attached */
 		if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
@@ -1103,6 +1105,15 @@ retry_multishot:
 
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
@@ -1129,7 +1140,7 @@ retry_multishot:
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
-	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags, consumed))
 		goto retry_multishot;
 
 	return sel.val;
@@ -1216,9 +1227,10 @@ int io_recv(struct io_kiocb *req, unsign
 	struct io_br_sel sel;
 	struct socket *sock;
 	unsigned flags;
-	int ret, min_ret = 0;
+	int ret, min_ret = 0, consumed = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	bool mshot_finished;
+	size_t len = 0;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -1246,6 +1258,7 @@ int io_recv(struct io_kiocb *req, unsign
 
 retry_multishot:
 	sel.buf_list = NULL;
+	len = sr->len;
 	if (io_do_buffer_select(req)) {
 		sel.val = sr->len;
 		ret = io_recv_buf_select(req, kmsg, &sel, issue_flags);
@@ -1253,6 +1266,7 @@ retry_multishot:
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
 		}
+		len = ret;
 		sr->buf = NULL;
 	}
 
@@ -1283,6 +1297,17 @@ out_free:
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
@@ -1291,7 +1316,7 @@ out_free:
 		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
-	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags, consumed))
 		goto retry_multishot;
 
 	return sel.val;


