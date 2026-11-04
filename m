Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826872;
	b=l0mPx801Y7MAIX7QStMGudkmppM26o091cv7HkXU+tgARrvtDiABQ5Zf2hKdmsL2fGh3
	 5KI8PCfyRPXL6LPxbTNf6TpJXNlxCx9BiRoUX+dc/XHQ/ltr/NSRs7cmFahGds1nA5NLR
	 +b34Q+oy8Rd7aTo9pLKO0459qYMWf4FAnZzwVOor9cVVQO8lZnYcoOrHQOyUArUSuW3iX
	 WxGZQZWsoXF+E8QuXPD6m6VetaHs0Tg7eLqlWvfBr42odKIS0YAwioMHfAYEvdjUTAo3R
	 7M6J6PpwOytS31LldLHnAMHCtDupnGoN7L8/Amn1z8BWCHRjsSiHVZcS/HWzU7XPoPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mFlytu1O0vvGYL3SfCBgYIvRdkVC4L/z7V2YdSJNsgA=;
	b=ffrwZMT/VYKMfEgOH3K9GWN1cIS9amooBS6k1zKqcsAAdbBSK4yjNMot0ODPGBSFn7ES
	 QQ8QHgu2HKYQccgCMlW5huOj8Ghgvefs+H1OM5rK24ZUbe+TtBok5wW4Dx5qrCLZpQjum
	 IT7Kg1SwZpLbi0kFzeJSSKbXqgJkQSnmOiX5LDLsiLHHC/8IP3AX15c6cN6T6TCv0qwJ2
	 ZDLjec3kWr/wH/sFuNOawYc9Jc5TAnmkQQ3gSnopQNKKOrWy6+StJTykpPrk23m0TgxqP
	 eHZEqVGvq8mnKrQP5n6f9zX61Pp0XN6JisfyGGfiMvmpELbEb+bw2JTuXhW1M1oMLRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrZKYSSD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19AF6070331;
	Wed,  4 Nov 2026 21:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GrZKYSSD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0981F00A18;
	Wed,  4 Nov 2026 21:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826871;
	bh=mFlytu1O0vvGYL3SfCBgYIvRdkVC4L/z7V2YdSJNsgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrZKYSSD5GiH/PbMv2X+iuz8ew2XdZwSA1NdXI0NfvLnJRbBagfkdeyKdOWIlJdo4
	 w7kYYuDxftsLBXEGSO9a5Hr+UBZbJKW8L6v/R7V1gsoIjurgoFYc4xEzHkrCRc0F5M
	 OV/EffftJ0v+ICtnc2xaEXtHZjPTK/nVUBYhbb+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 022/547] io_uring: dont flood a cancelling task with task_work
Date: Wed,  4 Nov 2026 16:03:26 -0500
Message-ID: <20261104211038.995799343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 22e643e61b9b6299b42ff7d88bab48bccada8a5d ]

io_ring_exit_work() asks each task which has used the ring to remove its
tctx node, by task_work, and repeats that until the list is empty.
io_tctx_exit_cb() doesn't touch the node while the task is in
io_uring_cancel_generic(), which removes all the nodes at its end. So the
work item queues the callback again as soon as it has completed, for
nothing.

That is more than a waste of time. task_work_run() only returns when it
finds the list empty. If the rings are released from inside the
cancellation, because requests of other rings held the last references to
their files, up to 64 work items keep sending callbacks to the one task
which is running them. It never finds the list empty, never gets back to
the cancellation, the nodes stay, and so it goes on: a task with 60 pairs
of rings which poll each other ran 280000 callbacks in 5 seconds, 20
seconds after exit_group(). It ends when all the senders happen to be late
at the same time. Until then the task keeps a CPU and the work items busy.

An exiting task can't be killed meanwhile. execve() cancels the requests in
the same way, so a live task can get stuck there as well, for minutes. If
it takes more than five, the work items run into the
WARN_ON_ONCE(time_after(jiffies, timeout)) of io_ring_exit_work(). No
privilege is needed for any of this.

If the callback has met a task in cancellation, wait a little before it is
sent again. Nobody has to wake the work item up for that: either the node
is gone by then, or it is the turn of the next round.

Fixes: d56d938b4bef ("io_uring: do ctx initiated file note removal")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-6-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9db7e68ba9970..19f79e53c4d37 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2339,6 +2339,7 @@ struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
 	struct io_ring_ctx		*ctx;
+	bool				in_cancel;
 };
 
 static __cold void io_tctx_exit_cb(struct callback_head *cb)
@@ -2353,7 +2354,8 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 	 * tctx can be NULL if the queueing of this task_work raced with
 	 * work cancelation off the exec path.
 	 */
-	if (tctx && !atomic_read(&tctx->in_cancel))
+	work->in_cancel = tctx && atomic_read(&tctx->in_cancel);
+	if (tctx && !work->in_cancel)
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
@@ -2447,6 +2449,14 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		 * wait is marked as interruptible.
 		 */
 		wait_for_completion_interruptible(&exit.completion);
+		/*
+		 * The task removes the node when it is done with its
+		 * cancellation. Give it the time for that: it doesn't get back
+		 * to it as long as it finds new task_work each time it has run
+		 * the old one, and we may be one of many who send it.
+		 */
+		if (exit.in_cancel)
+			schedule_timeout_idle(HZ / 20);
 		mutex_lock(&ctx->uring_lock);
 		mutex_lock(&ctx->tctx_lock);
 	}
-- 
2.53.0



