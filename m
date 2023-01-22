Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEA22590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA36FC433EF;
	Sun, 22 Jan 2023 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400663;
	bh=7IIJZbVLF93PB3pADk9DFskYSnH12uSbG20w7+TJX9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1/X00uKpiGnbQmZr4bSOtNQCwEbu7pnEldscuTx0/dfSUjiI7MRihD3takPHWw8Z
	 n2nJK9y2y2ScXP17l7PRJDTdx5NVIfiG5a3axQipOG8saQmKdF7rYoF7mULuKB5ibu
	 eQnLb3RsSuWR2K3GiMaOJzW3hhalYRbYkkSS9BQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/117] io_uring: support MSG_WAITALL for IORING_OP_SEND(MSG)
Date: Sun, 22 Jan 2023 16:03:44 +0100
Message-Id: <20230122150234.147578888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 4c3c09439c08b03d9503df0ca4c7619c5842892e upstream.

Like commit 7ba89d2af17a for recv/recvmsg, support MSG_WAITALL for the
send side. If this flag is set and we do a short send, retry for a
stream of seqpacket socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2350d43aa782..3fb76863fed4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4777,6 +4777,13 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 #if defined(CONFIG_NET)
+static bool io_net_retry(struct socket *sock, int flags)
+{
+	if (!(flags & MSG_WAITALL))
+		return false;
+	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
+}
+
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
@@ -4840,12 +4847,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -4876,12 +4885,21 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4922,8 +4940,19 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	}
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5071,13 +5100,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_net_retry(struct socket *sock, int flags)
-{
-	if (!(flags & MSG_WAITALL))
-		return false;
-	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
-}
-
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
-- 
2.39.0



