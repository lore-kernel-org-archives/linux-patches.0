Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE50335946;
	Wed,  5 Feb 2025 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768443; cv=none; b=WZdtz94LZhlbgtNZBBy9iHSmy/t4Pj92JAvTVoHUwaFqoi3I/C0FWUuDjZfbpSk5vksGLV/RqRWfAI5Eg3ThAEaXbsilFDQn83Vb28IDvj5ZIb5Et1eg7WY7pR0FP6JQDzC9BlN3++WrGnXlBb4bVwu4CM8HDJN1RUimujuzfQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768443; c=relaxed/simple;
	bh=2W8EZZL1oCKYxE6E+ucni+Mawt59mMHxWZ7aJ9w42ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU/mw6XfdLUo4+agyM4HyK2R55BZyqz3UzoilgdoJyHjvCbpcSGJclCV1q7MkpEeD8a3+vRYKBSAghyjfOX1aq7BRTqmmk/4orL6ipq6nsu+T4zvz1dYL0Gqn15s1fQRV+AxaUQpPqqmrR9cgGZqSEW3OL2ezOzmqENo1lv2gMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/hJXN6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/hJXN6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5FAC4CED1;
	Wed,  5 Feb 2025 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768442;
	bh=2W8EZZL1oCKYxE6E+ucni+Mawt59mMHxWZ7aJ9w42ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/hJXN6uf0LyuMxr08MxTGNBn50EM6055R4z4eNc9YDE+7mxHBeBB8AYD0sARE9wK
	 as5PCN0XR3PiGJVsXsiTlFqCwJkyz4DqV3AQbwqzzfLfGHneF1uz33s5Zj3/akdLfx
	 pP0AFyD62dRbfzCcYzN8aEH/dye8sLxHhlh07Tkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 559/623] io_uring/msg_ring: dont leave potentially dangling ->tctx pointer
Date: Wed,  5 Feb 2025 14:45:01 +0100
Message-ID: <20250205134517.604736412@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 69a62e03f896a7382671877b6ad6aab87c53e9c3 ]

For remote posting of messages, req->tctx is assigned even though it
is never used. Rather than leave a dangling pointer, just clear it to
NULL and use the previous check for a valid submitter_task to gate on
whether or not the request should be terminated.

Reported-by: Jann Horn <jannh@google.com>
Fixes: b6f58a3f4aa8 ("io_uring: move struct io_kiocb from task_struct to io_uring_task")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/msg_ring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 333c220d322a9..800cd48001e6e 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -89,8 +89,7 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			      int res, u32 cflags, u64 user_data)
 {
-	req->tctx = READ_ONCE(ctx->submitter_task->io_uring);
-	if (!req->tctx) {
+	if (!READ_ONCE(ctx->submitter_task)) {
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
@@ -98,6 +97,7 @@ static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	io_req_set_res(req, res, cflags);
 	percpu_ref_get(&ctx->refs);
 	req->ctx = ctx;
+	req->tctx = NULL;
 	req->io_task_work.func = io_msg_tw_complete;
 	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 	return 0;
-- 
2.39.5



