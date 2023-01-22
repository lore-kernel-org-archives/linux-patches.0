Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFCA2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B1C433D2;
	Sun, 22 Jan 2023 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400379;
	bh=adNrw7k6kD0ordoOigc/MIKYYE0ZHPHC0zAFS3NT2Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0lrHSZQveXnE8exx8QwqCWu+F96efVfbX66h4JLDmXhNvjAAf0spduzqGdsB/Wwx
	 J11c9KAiYCBCteBgjUoOvSdvJXbqs/ZXNCWs2FtYoAN/aK7Z1OocphFV1wBqhRX9co
	 eoPufQr8ulrNEQAi6B/RqXtrF1uTPmz1UJ0prXrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/98] io_uring: add flag for disabling provided buffer recycling
Date: Sun, 22 Jan 2023 16:03:39 +0100
Message-Id: <20230122150230.433607255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
index 3d67b9b4100f..7f9fb0cb9230 100644
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
@@ -4963,6 +4966,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5036,6 +5040,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
 		req_set_fail(req);
-- 
2.39.0



