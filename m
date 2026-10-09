Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6831145D910;
	Fri,  9 Oct 2026 14:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556710; cv=none; b=YAMZ03Mr4nY+wbNfxFGLplhRHMr86+78hkYNnchfjbfG5/TbQOKU8My5c7iyYV2FRgM82HJC+Iz4TyCa38mBDL6P3ELAmdtlGr3xuaVLEvZSfl2Hcnv2qDIAUVxTpgCdGqI9qnpA+8Y94nZboV+oohbKccsaf9p1mz5qPyDGAsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556710; c=relaxed/simple;
	bh=alcfVVA+cBOyDgdO/5hEzy4K9u2J6TDsPos3AXK4P9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPsZNQWSSMMvOS0gmNMrv2AU4biA10j7M0fDScNNLcA4H/wdtC5yIdD63fU0e+33S2a4fSXTYEW6rwo2mCjvw3g+MgLSWJCIR8AyBiw1fdvjI2YV58XNYgEiBYH0vj4boXmdaTIUSmIfGqTwh6p4jDWVs4jJaXlCPjdZp5vcJxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MImqhbPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MImqhbPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77E81F00899;
	Fri,  9 Oct 2026 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556709;
	bh=ggwQJx7UYHBSYXxqbJj5KLOE76q2V3FQEMrn8CuCS7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MImqhbPbhiARjOo+rGTZlBOvqu9jBmjR1YgThJAvxieuNoaTnK8/Wvhx+UnO4dOPw
	 afXW/JIa9P6sZV+Bzu9VMECWdB3nmLiF0ocn5giYbttPTFqHI/DNRZqkoR5Mh5Kdxu
	 Nv6VqA0ZiqjTkyA7z0y+gdlwgOYyFtZQJfRzr/sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/403] io_uring: fix task_work add use-after-free with SQPOLL
Date: Fri,  9 Oct 2026 16:10:02 +0200
Message-ID: <20261009140957.803501390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a92193c91e8839fe5fc209616ea95465ae4b919d ]

For SQPOLL, the sqpoll thread runs task_work off its own list and
doesn't need to be told about it, so it can pop and complete a request
as soon as mpscq_push() has published it. If that was the last request
holding the ring alive, io_ring_exit_work() then frees the ctx, stops
the thread, and with it the tctx, while io_req_normal_work_add() is
still looking at both after the push:

  BUG: KASAN: slab-use-after-free in io_req_normal_work_add+0x439/0x510
  Read of size 4 at addr ff11000000ca0000 by task repro/55
  (...)
  BUG: KASAN: slab-use-after-free in queue_work_on+0x25/0x70
  Write of size 8 at addr ff11000000c3bd00 by task repro/55

Hold an RCU read lock across the add, like io_req_local_work_add() already
does, and have io_ring_exit_work() wait for a grace period for SQPOLL rings
as well before freeing the ctx.

Reported-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://lore.kernel.org/io-uring/20260924205056.3759980-2-Jeremy.Jean@oss.cyber.gouv.fr/
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Relocated the task-work hunk to the existing io_req_normal_work_add() implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd64ba7a0927a..524669ee19982 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1341,6 +1341,9 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* SQPOLL can retire the request on push, see io_ring_exit_work() */
+	guard(rcu)();
+
 	/* task_work already pending, we're done */
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
@@ -3146,8 +3149,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
-	/* pairs with RCU read section in io_req_local_work_add() */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	/* pairs with the RCU read sections in the task_work add paths */
+	if (ctx->flags & (IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SQPOLL))
 		synchronize_rcu();
 
 	io_ring_ctx_free(ctx);
-- 
2.53.0



