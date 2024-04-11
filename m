Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A28C145B07;
	Thu, 11 Apr 2024 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830380; cv=none; b=LIicedp8SMmv0Zh4KnETj0VuPlp4RcwTQflK/LG13ZVb3TXnX8uPaq10nOMhduANNXGTlKQfdgk7tIE07KVE70HM3ps+gwdkjxN6w0pWM1hP42mLsk38P3okHPBWpKG/74U1muZP2FNOK44KXewlWwnpVl1LP+DQmfdiQo1zsLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830380; c=relaxed/simple;
	bh=wcuvU8sHKj7Ey1ZS6rdCjtFSOW5l5ZkCMMhBke5PgdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA8EBYzl42ei+cEy9ea23h5xr6CSWakSRLR2kp3xBlbb5Knr7qoZKrArgSEPqKHt1RPr087Xa1a5QQ8YmTEQBbi5376DgYh6SNE5IXuD/QNQXYVR5io5igFTUg6RlTp6r1JMQsV9kcJRwsnM6T7vJsE0vsfvyEUOFLfeMpre5lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAeUcyo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAeUcyo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C1AC433F1;
	Thu, 11 Apr 2024 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830380;
	bh=wcuvU8sHKj7Ey1ZS6rdCjtFSOW5l5ZkCMMhBke5PgdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAeUcyo/i54F3Li5FvbOCIX6l0oUofEZxaA/Vv8qjZ7I7gSC45MyOBoL2ipgw5hKT
	 ylvp0cc7LBadzEn4zJgZflju42FYl6u5021bmIVmEM9lGmeFbnCAq3RL8ZVQ0YYERb
	 89p6lWrod6rOHD0iEYZT6vVwoFd9WgyzzuVwgefE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Subject: [PATCH 6.8 125/143] io_uring: clear opcode specific data for an early failure
Date: Thu, 11 Apr 2024 11:56:33 +0200
Message-ID: <20240411095424.668057170@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit e21e1c45e1fe2e31732f40256b49c04e76a17cee ]

If failure happens before the opcode prep handler is called, ensure that
we clear the opcode specific area of the request, which holds data
specific to that request type. This prevents errors where opcode
handlers either don't get to clear per-request private data since prep
isn't even called.

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 572effd0af532..0f52ea80103ef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2143,6 +2143,13 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
+static __cold int io_init_fail_req(struct io_kiocb *req, int err)
+{
+	/* ensure per-opcode data is cleared if we fail before prep */
+	memset(&req->cmd.data, 0, sizeof(req->cmd.data));
+	return err;
+}
+
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
@@ -2163,29 +2170,29 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	}
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
 			if (!def->buffer_select)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			req->buf_index = READ_ONCE(sqe->buf_group);
 		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			if (ctx->drain_disabled)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			io_init_req_drain(req);
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
-			return -EACCES;
+			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
 		if (ctx->drain_active)
 			req->flags |= REQ_F_FORCE_ASYNC;
@@ -2198,9 +2205,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (!def->ioprio && sqe->ioprio)
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 
 	if (def->needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
@@ -2224,12 +2231,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 		req->creds = xa_load(&ctx->personalities, personality);
 		if (!req->creds)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		get_cred(req->creds);
 		ret = security_uring_override_creds(req->creds);
 		if (ret) {
 			put_cred(req->creds);
-			return ret;
+			return io_init_fail_req(req, ret);
 		}
 		req->flags |= REQ_F_CREDS;
 	}
-- 
2.43.0



