Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A36946F4BB;
	Fri,  9 Oct 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555549; cv=none; b=S5F0sB0PKQvdEwit7hMa0LCcYuEBBm1JQSP7rrVHQaPTOqpTrKfVy/LJz9/JP/aiRnzIXEpCAVTuSdArX8GcBSH4gyda1YB/kP1B2KR91xuVM++ZUCO76qWXbKvG2opNknwUDiOttdQU93RNuyRP3aFMuJWVwzpX7P9PzAt7UC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555549; c=relaxed/simple;
	bh=mXohtBF4IKlRl8IyVP+jtasZSu2bcikRQ58tAyQAmyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLAouNwJzd4nDGLSgHndajMcfa1canQRV5dtr/T/98ZiP6i6xJdxD0qdHhp3WA8Ji9VfN5zaVX9Gg0BM5NRTcZaSyWov4tTKLOV2qG9OiDNAZlv7vxlDpawsmOOI1i3piiDzC/UlXfFFvXYYDoFjGLbw+y49WGWUBiwqjMx4bDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrF/0JBX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrF/0JBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707551F00898;
	Fri,  9 Oct 2026 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555543;
	bh=d4eNoZHAa+YIjGZEH+dIzyQOXv6kzOQBkDb2WzSzJrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrF/0JBXqixPrXUWqw5mWub8OkvxDpe6m5nh5rT5MM5x4/JRhj2kVVOzJneQpFj73
	 3n4mVOQZc41CBeb+MEExwhy0qWvImfHgy7KONLlgOfyU5kdpTZajBYFKzPLyNsD3PI
	 uqaIEoMPF26t0NairZZCrYXEIgnp8oMN8AAKIvUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 026/428] io_uring: fix task_work add use-after-free with SQPOLL
Date: Fri,  9 Oct 2026 16:06:03 +0200
Message-ID: <20261009140946.645859875@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a92193c91e8839fe5fc209616ea95465ae4b919d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 ++--
 io_uring/tw.c       |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2412,8 +2412,8 @@ static __cold void io_ring_exit_work(str
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
-	/* pairs with RCU read section in io_req_local_work_add() */
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	/* pairs with the RCU read sections in the task_work add paths */
+	if (ctx->flags & (IORING_SETUP_DEFER_TASKRUN | IORING_SETUP_SQPOLL))
 		synchronize_rcu();
 
 	io_ring_ctx_free(ctx);
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -210,6 +210,9 @@ void io_req_normal_work_add(struct io_ki
 	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* SQPOLL can retire the request on push, see io_ring_exit_work() */
+	guard(rcu)();
+
 	/* tw run already pending, nothing else to do */
 	if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
 		return;


