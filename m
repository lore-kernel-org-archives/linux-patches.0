Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5913202F7B;
	Tue, 26 Aug 2025 11:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208564; cv=none; b=eGpoTOWBmqupiz2ICNvI+7rFySetuc4gvxEmCCYelRGca+tCVM+3qyX4vJxFDe0wVqybyABnLT/+9ai7V9Vo5V0XflJS01/d+zrHd8kSgRJZozbFaQWC9HLDrjgxGPSt+xrTqUqKmSIl4AbT1y7oXc6/AIXfeif0UJTaAD7MyEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208564; c=relaxed/simple;
	bh=OMPrHNTvZx1B9W1MPxv/m7RQdqxP3DJoP2e5nk2bUaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4dQZPZ+ZP1n4rk9EXHcfd+PkXulTUrLYb+I50ruCY0DS0ti0wN/to4pSnUnJ0cVUxxQfGGti8Gh/BwXdgUY0TpCAnuax2U0ahMyGStI5txKVQo2PNQt5vM3VvCbThQ6e1Q8U41BrYzuWGdeSQPgqqaqdhjJMwaxiz0MDC1EL+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8gIKcsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8gIKcsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5D8C4CEF4;
	Tue, 26 Aug 2025 11:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208563;
	bh=OMPrHNTvZx1B9W1MPxv/m7RQdqxP3DJoP2e5nk2bUaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8gIKcsKTxDjolEtW6TupbiuSx5apjW3XoEBd0UYxPrVt7QieK81ZxYWNLSfIf5/F
	 Fg/WWIH3FWw7Xw3C/SJlY13XqYdwxbGeLErf8bb6OcI06GkQv7xYL1+X8nHAB2ATuX
	 BPWmcGQELLWxxeG2rRV5PJeOHGCqKTk9jOGL12IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pt x <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 159/322] io_uring/net: commit partial buffers on retry
Date: Tue, 26 Aug 2025 13:09:34 +0200
Message-ID: <20250826110919.746897136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

commit 41b70df5b38bc80967d2e0ed55cc3c3896bba781 upstream.

Ring provided buffers are potentially only valid within the single
execution context in which they were acquired. io_uring deals with this
and invalidates them on retry. But on the networking side, if
MSG_WAITALL is set, or if the socket is of the streaming type and too
little was processed, then it will hang on to the buffer rather than
recycle or commit it. This is problematic for two reasons:

1) If someone unregisters the provided buffer ring before a later retry,
   then the req->buf_list will no longer be valid.

2) If multiple sockers are using the same buffer group, then multiple
   receives can consume the same memory. This can cause data corruption
   in the application, as either receive could land in the same
   userspace buffer.

Fix this by disallowing partial retries from pinning a provided buffer
across multiple executions, if ring provided buffers are used.

Cc: stable@vger.kernel.org
Reported-by: pt x <superman.xpt@gmail.com>
Fixes: c56e022c0a27 ("io_uring: add support for user mapped provided buffer ring")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -498,6 +498,15 @@ static int io_bundle_nbufs(struct io_asy
 	return nbufs;
 }
 
+static int io_net_kbuf_recyle(struct io_kiocb *req,
+			      struct io_async_msghdr *kmsg, int len)
+{
+	req->flags |= REQ_F_BL_NO_RECYCLE;
+	if (req->flags & REQ_F_BUFFERS_COMMIT)
+		io_kbuf_commit(req, req->buf_list, len, io_bundle_nbufs(kmsg, len));
+	return -EAGAIN;
+}
+
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
 				  unsigned issue_flags)
@@ -566,8 +575,7 @@ int io_sendmsg(struct io_kiocb *req, uns
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -664,8 +672,7 @@ retry_bundle:
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1068,8 +1075,7 @@ retry_multishot:
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1211,8 +1217,7 @@ retry_multishot:
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1441,8 +1446,7 @@ int io_send_zc(struct io_kiocb *req, uns
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1502,8 +1506,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;


