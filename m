Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CF03164B7;
	Thu, 28 May 2026 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999002; cv=none; b=NuKVkZu+ss4ajzSUmSWH0SGdzkEd0kLQ4/rENPIYZU5Ll/Zdr8+rcs6IROER1kzuAxaR/o2PZaLd5NuHLHJF9Qxt/hLFB0J3CbxivLscD01NGHFD4cNwMFKmwtKG+OdAmGI24Vp9yLAC5fshNI05/tlJCb5etour68udUiHKZsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999002; c=relaxed/simple;
	bh=aw8qREzzyXu8Al3+WPDt5eoCfID1voB7n00w7LUS5R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhKD3USxD5YvYwbIKT8wrkavrF5alqQUe3TkaDJWI4y2SQy8jm9Xw6JWzP562/l5JVacvcFLkfdUdAP7/zRS3PH3zHxxIgd2j7RwOz6Tz5PipJXO3hF9fqcra869U7LvGd7jfDvzN9RblYUxvWI2kSQA2doB1d/Z/C01hZFO41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwEKQap8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwEKQap8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A161F00A3A;
	Thu, 28 May 2026 20:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999001;
	bh=sYmNrDqr+KohwhrRW4lfpzYSn/QPKinM4iVqlVWSY2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwEKQap8Ai8wLmKIyDnABbJSql+SYwJiv0vAHiHLzdRsbXfzGdBtTOYCuHRErSw3r
	 Y5S//hYPdR1iBp7xG2eR3Kffba9qP5Kn0TDO9DLfSVrgUK9USdpkXXkMbwVYVdUa47
	 prTMjgoEXbW/K2cqtPySrCcCNvYWKOegIX/K+zRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 373/461] io_uring: propagate array_index_nospec opcode into req->opcode
Date: Thu, 28 May 2026 21:48:22 +0200
Message-ID: <20260528194658.243825254@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit cf18e36455603d65d4745de83e2d1743c54ada47 ]

Commit 1e988c3fe126 ("io_uring: prevent opcode speculation") added
array_index_nospec() to io_init_req(), but applied it only to a local
opcode variable. req->opcode is initialized from sqe->opcode before the
bounds check and remains the raw value.

Keep req->opcode as the canonical opcode in io_init_req(): reject
out-of-range values architecturally, then write the array_index_nospec()
result back to req->opcode before any table lookup. This keeps downstream
users of req->opcode from observing the raw user byte on a mispredicted
path.

No functional change: array_index_nospec() is a no-op for opcodes in
[0, IORING_OP_LAST), and out-of-range opcodes are still rejected at the
bounds check above the assignment.

Fixes: 1e988c3fe126 ("io_uring: prevent opcode speculation")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260517213010.696135-1-michael.bommarito@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 97260bca67e7b..cc4011d843377 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1719,10 +1719,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	const struct io_issue_def *def;
 	unsigned int sqe_flags;
 	int personality;
-	u8 opcode;
 
 	req->ctx = ctx;
-	req->opcode = opcode = READ_ONCE(sqe->opcode);
+	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
 	req->flags = (__force io_req_flags_t) sqe_flags;
@@ -1732,13 +1731,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->cancel_seq_set = false;
 	req->async_data = NULL;
 
-	if (unlikely(opcode >= IORING_OP_LAST)) {
+	if (unlikely(req->opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
 		return io_init_fail_req(req, -EINVAL);
 	}
-	opcode = array_index_nospec(opcode, IORING_OP_LAST);
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
 
-	def = &io_issue_defs[opcode];
+	def = &io_issue_defs[req->opcode];
 	if (def->is_128 && !(ctx->flags & IORING_SETUP_SQE128)) {
 		/*
 		 * A 128b op on a non-128b SQ requires mixed SQE support as
-- 
2.53.0



