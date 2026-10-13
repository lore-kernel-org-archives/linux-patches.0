Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2006E47CA69;
	Tue, 13 Oct 2026 12:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895181; cv=none; b=EXBN/sKpbxm3rqLuxyveSu/bM2Y8yad2LZQXwkOI2CrISNWbCVFcvm5YStOQBO6dZuUOLYPm/4eIm6urpGr/QBpszo+9N/qtomkCDjLH+uaNlQf23BjWHmHrJYc50psPWg0moAkGslCISF2vLOMH8gp2q8+RckX51bN7ttDsvfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895181; c=relaxed/simple;
	bh=IRGoQ+VuJ8EJ+f38iuXx9GAcS6jJiL3qXvi3KOIxwuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=krNxxPlCvLI81bR/qIejq1OpyL3700GS2hFtVNk3c9xNHZ4TzgzNbDXNswq3pWPwyc8f2hVQJext/ttojSIUk0g3UHmpEGkoOLxwUnrmjh81/pJFwgxDQgkxDoJ9lIcz1yMBx3e9apYFjS+hbnrE8zZyzdaMvbsswc4rrWfHzLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPoA0tyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPoA0tyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C031F00893;
	Tue, 13 Oct 2026 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895179;
	bh=TVUtKaLemW9ORjTphJP3XcN9jlKRUORDoB0QNmP+yQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPoA0tycns9Kr6vT3hbguB8j8n4WJ3he5EITG6Fn9C/o+EGVkRIBbilSsaG/eGEic
	 k8uMzVgs5MH+0k8lkErX2GEyjxIsYhOB5DRwmLg8PgdK1Cr9s1M1+VkMu9WTqHFy4k
	 aqfhSH0ClS3t2SY8i3Z4FVQwiInqMXKp1aAKXWXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/497] io_uring: fix task_work add use-after-free with SQPOLL
Date: Tue, 13 Oct 2026 13:35:56 +0200
Message-ID: <20261013112912.377274498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted hunk placement for the existing task-work implementation using llist_add() instead of mpscq_push(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 03c6ab505d74a..1e7963cc30d3e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1219,6 +1219,9 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* SQPOLL can retire the request on push, see io_ring_exit_work() */
+	guard(rcu)();
+
 	/* task_work already pending, we're done */
 	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
 		return;
@@ -2962,8 +2965,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
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



