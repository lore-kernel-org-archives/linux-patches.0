Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207955;
	b=dXTq1ESM2OTpQPNRHOGVlJuFjtnhtaFRJvgq/ClMh/1GOASDYPq/C31WKpeG7Q8VOScd
	 CcRzSw8Wgo0PS9MTOtAoR2Iir5js5OR+3Z//DqN5eBws7HyXE7iGngfMOG65vhnVCu6uZ
	 TjTlg/y3D7G+NY7bMfx/LL8nXZddXbPX7GUnes17sV1yHHrrVJaHwHowoE5CUfIY2o9Pr
	 ZYf0NvIi8wP6/TOvLtbilnJzVC7sJIR90JYXC4aL3Sw+eVEMK2EXBeNqhC2te938Nlm6T
	 N3DExy+47N57aFZzGy2tmLFzrGL7t+Ig8pKLcKi0SruwQw3h5bIBErIxlUK8GZiOWkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+O0K2O/zm7jqqkQ1+XC8Fc4GbnMbHOlfzQFgom0lBV8=;
	b=cAQNIDizIW2/WbZABPt5SMETeWNfThavMSrCnQYtPnmCswa8n1xnaxp5F4zCfhyV6go7
	 3d8rAdT53oTutTCnBWBXIHgBWOPv+hPHk9oVNY6vIaEavR4y7OP2Bhi/HiF1Bv/tqF8zc
	 gDYT5qqXVolskwhMV/oMTDZfp4pMOQc7fniG+JyQ46zLH98VNqrcgQtpmNcGYDK1Kjl2E
	 jSEKBi9YmETufywfSbA3Q3xO8kgycYiUSKHEguUGnPx/5Y2jZWW3SG+vQ1k+CN18k6qfV
	 sSxn13zUUYzWXQv20oHz8lQwjEEJFIvkI/GsgfMqQUcp6885p0eMzONB+U+OnPUszTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cnBiSRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6066606A325;
	Wed, 28 Oct 2026 17:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cnBiSRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3054A1F01829;
	Wed, 28 Oct 2026 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207954;
	bh=+O0K2O/zm7jqqkQ1+XC8Fc4GbnMbHOlfzQFgom0lBV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cnBiSRGrVgLpDh8AwZXiNOnSjPmkvNO554Y0R2PWY8+kaETmby5jyH3iV8MI4XST
	 tYwW9SuuxcFlNky8YNuAeM3SlXQPJUdOMIiWBhSxNssiVQnNkfFIl8FHu02+jcFzVV
	 85a5JwO0uJN9G/dyEeDlxhg4gohDzUHOOhCCuwnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 198/247] io_uring: dont flood a cancelling task with task_work
Date: Wed, 28 Oct 2026 18:00:01 +0100
Message-ID: <20261028165952.108337637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2873,6 +2873,7 @@ struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
 	struct io_ring_ctx		*ctx;
+	bool				in_cancel;
 };
 
 static __cold void io_tctx_exit_cb(struct callback_head *cb)
@@ -2887,7 +2888,8 @@ static __cold void io_tctx_exit_cb(struc
 	 * tctx can be NULL if the queueing of this task_work raced with
 	 * work cancelation off the exec path.
 	 */
-	if (tctx && !atomic_read(&tctx->in_cancel))
+	work->in_cancel = tctx && atomic_read(&tctx->in_cancel);
+	if (tctx && !work->in_cancel)
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
@@ -2981,6 +2983,14 @@ static __cold void io_ring_exit_work(str
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


