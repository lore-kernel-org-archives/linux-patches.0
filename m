Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209706;
	b=f4qS6zcBq8eyO9u1HTNTR0F5ZIAMvT9JSLwKeCaQHqRebjF4uqcWDEdPYSBE6IXgO1o6
	 CojOiCj7pOtLzpUP7Jb2fQAVFb8EhCOfMIlXougGcuAZEBU4TGt1orWyjVwDjcHGNewzC
	 EXyacz9d0Q7NmtfYymqrjYJCHJwK1agOvrPWQ/vs2JrjJaJ/70LrZ6s+GdTwS8CKDbRxB
	 KvUqPSZbtU07sC4c05Z4tmujN0nI6Okfqa4g3kDGV5mLb+YmORzHfToUYOF4wi65fbbzc
	 zCnzvhXOf3uXFwmsucw33kU9RaH8m4+jY49MhHwki/hKUdgfqhHzbdSnxzpRrlJHRcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WyVsa1D9WjbJu0CjB0TxQ+/x2fRw1DSnb8apx4V7fOc=;
	b=xjm/yH9S0bK4sj8O2ERESkEC9bmEYuH2wZh/+Atu/32JhhJ1NISefvF3FBjCgyiDWJ8i
	 KUBQg5zd4SZyGBRwJKdYcRe9qvqjGgHQQmt12f6EWssRCRRTz0FCGtfACGjpJtHtfl93I
	 y109lywx+p5l18x/f7nKGefHp4GOY5+XCQTTWjUplffombcEqiWRHIsOWKFzJIe310r13
	 /G9FNyFC9fB3rvKTlIxtfaVJcZDA1fx0nWy7Bj8pkaBlNlbMtVeR9A1HUZzgd1oT8Awnu
	 gIZYPGWoN9JlP5WviCjiYpoTfJQ+AywgQOdGGlZZii9WQjSp7TpUiX2g/JvIQca4cFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u4C274/E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5B0606A322;
	Wed, 28 Oct 2026 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4C274/E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0251F01828;
	Wed, 28 Oct 2026 17:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209705;
	bh=WyVsa1D9WjbJu0CjB0TxQ+/x2fRw1DSnb8apx4V7fOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4C274/ECb+T2Nn+LlA8SoAiiIS9dqbUNs3OxbLTmcvWv5rZAIZaaJKqzKukTfur9
	 tzbZiJSLAFBUkEezbqaHDprcVYTlRI0eFEZNo91oWdEbebUpjnnyXlySZJq30BgqKN
	 4Mtfvy8Z6XK1JhAKWnZCmlx3qBi8WPl5DlkrtLZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 049/109] io_uring: dont flood a cancelling task with task_work
Date: Wed, 28 Oct 2026 18:00:33 +0100
Message-ID: <20261028165943.515044605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 22e643e61b9b6299b42ff7d88bab48bccada8a5d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3003,6 +3003,7 @@ struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
 	struct io_ring_ctx		*ctx;
+	bool				in_cancel;
 };
 
 static __cold void io_tctx_exit_cb(struct callback_head *cb)
@@ -3017,7 +3018,8 @@ static __cold void io_tctx_exit_cb(struc
 	 * tctx can be NULL if the queueing of this task_work raced with
 	 * work cancelation off the exec path.
 	 */
-	if (tctx && !atomic_read(&tctx->in_cancel))
+	work->in_cancel = tctx && atomic_read(&tctx->in_cancel);
+	if (tctx && !work->in_cancel)
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
@@ -3110,6 +3112,14 @@ static __cold void io_ring_exit_work(str
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
 	}
 	mutex_unlock(&ctx->uring_lock);


