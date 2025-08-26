Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3DA1547CC;
	Tue, 26 Aug 2025 12:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212680; cv=none; b=KnptV1dMHGgfcI9Jrxn0DHDf7ru3BeKV25G8MbpDeQNkD0MC8IaZJSAW/RM9jPhRBsQsylFxvCrDRy7zmfXh6ISZMw2mVn9+SP1lm142ZsFdADrDRb7W/CYh89/9ZCLLpzShtOz+TaDfgnRKrvUHJjiAVtDlBh1z3Gn26hVjoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212680; c=relaxed/simple;
	bh=eBIjTZOIUxStgdfhAiCYdgJ2TXKLTol8cZZPalhQTZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUD9dxGVma2/FBUP03IpAxVeLBF8OqqNPVh7/jajuiTdbbb8L2N+Qi74H8bUya9UDAZHRsnm1wmt2NZHI22qNi6p3HM+2kiKpVrv7WXVdS7dp8EwQbe26NDdASl2qEgcSoE4bZPqTCp11UBOYx1zAIO2PeAj3D1Jkv4VEI+XkeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ2117S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ2117S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D30C4CEF1;
	Tue, 26 Aug 2025 12:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212679;
	bh=eBIjTZOIUxStgdfhAiCYdgJ2TXKLTol8cZZPalhQTZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ2117S318HaxNMtL73iW+QWxtCiE+/9xULHdh/2JiXR8HiNuh/OMgViSEfT+R2JS
	 +Ox7Zx7R9l3vD80EviuE7AyTw3Uw3bStbIYuWylVIFi7nWykupHwMqW8lPRvPJ8o5P
	 k+3UXChb1q7iHxzYuskIQnPOD2OynLfkt6ZsWO0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	pt x <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 021/587] io_uring/net: commit partial buffers on retry
Date: Tue, 26 Aug 2025 13:02:50 +0200
Message-ID: <20250826110953.496245735@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 41b70df5b38bc80967d2e0ed55cc3c3896bba781 upstream.

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
 io_uring/net.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -351,6 +351,13 @@ static int io_setup_async_addr(struct io
 	return -EAGAIN;
 }
 
+static void io_net_kbuf_recyle(struct io_kiocb *req)
+{
+	req->flags |= REQ_F_PARTIAL_IO;
+	if (req->flags & REQ_F_BUFFER_RING)
+		io_kbuf_recycle_ring(req);
+}
+
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
@@ -442,7 +449,7 @@ int io_sendmsg(struct io_kiocb *req, uns
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -521,7 +528,7 @@ int io_send(struct io_kiocb *req, unsign
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -891,7 +898,7 @@ retry_multishot:
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -991,7 +998,7 @@ retry_multishot:
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -1235,7 +1242,7 @@ int io_send_zc(struct io_kiocb *req, uns
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -1306,7 +1313,7 @@ int io_sendmsg_zc(struct io_kiocb *req,
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			io_net_kbuf_recyle(req);
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)


