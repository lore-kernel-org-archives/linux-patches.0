Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CA72590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF95C433D2;
	Sun, 22 Jan 2023 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400634;
	bh=/XcWDfGyJ7HEHVSwb5TC44LLxAPz1Dtuz55cm6EQcOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ierbr9Fe+ZlNaq0zjzHFZfE4AQHFmWhRuMnXKhtwz5q+lM1h6+/UUtxZxoY5yG7dB
	 jtx9eXyWIr6vlB+SL6glB6rkJIjVPlUCuGK25t7qZPenUBBLpfPK4J9jFZSIYBfqCh
	 woOWPJ89sBu8584xppzhZIXZOQAdAnEc2aNjEYsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/117] io_uring: add flag for disabling provided buffer recycling
Date: Sun, 22 Jan 2023 16:03:43 +0100
Message-Id: <20230122150234.099736283@linuxfoundation.org>
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

commit 8a3e8ee56417f5e0e66580d93941ed9d6f4c8274 upstream.

If we need to continue doing this IO, then we don't want a potentially
selected buffer recycled. Add a flag for that.

Set this for recv/recvmsg if they do partial IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 04441e981624..2350d43aa782 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -740,6 +740,7 @@ enum {
 	REQ_F_CREDS_BIT,
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -795,6 +796,8 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -5123,6 +5126,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5196,6 +5200,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
 		req_set_fail(req);
-- 
2.39.0



