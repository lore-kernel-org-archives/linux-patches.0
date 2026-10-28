Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212035;
	b=49wJ2seQeyLdEkF8WTURpwZ9cPUXW9YXvsHLlOr6IFLFonyUcJo6z+WunvxpAuQR8pHY
	 bS9QNOoDb8VK+e5jvBTnpecv77LgG8NMXJPtAN2DI8zW/XwQY+nimBRTWciWHwYrB+iJQ
	 6rbkyhMx9As9IyxNayf0z+qrvre/q3dEDQRXWIn1tYBZLQA4Zkg/TacjQORZsgsM0dHks
	 JUM45y8qXB0XeafVQWa77FfMxfGX5l3QznYR9Q0iog+QWwDAp/J8F+kHxdLYJQm0Yhg7z
	 Kvr46QmsRpsFdSc7my9xBkd27aCofKU2zyqpcpuAQ/4pUKsvsgTTGBGVb/hBLze3HAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hKGHKxWLPptDYE1rI/BXiADEq9O8UpCtSx0KXY9KlZQ=;
	b=d4unsPnRW2AaZX8H2d9f/U3WCgYbWyscN6SmL4EAkHcnF6+pIzqNiGe1tQ8Nx4mHiAgk
	 eG7p4phfgcuozc8j7EEKw6DJMfbu9OErR2kDyXi3WuIILqsPf6yXEmSKDc2bBc4CMskPq
	 jRmgEGuxLxEVHF0ExdE9ETSuiYZXSpVStIoNHXoblMwv5u+CQco/eh/g9nHu19dyxYYQ8
	 aylq/OaG2aZy/v8q0Ne7zJUFp2UcZSujXcZyibqxPfvhuKGCPxUuV7KhqJUvqz9ycOTI9
	 P2ipoVNRkh+GZHU/x+w3LhXbemKtc6hWQC+0jiuhCMk308ezSwNtu4z2Ek5Vk03kbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q7/U5et5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8422C606A31E;
	Wed, 28 Oct 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7/U5et5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C491F01825;
	Wed, 28 Oct 2026 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212035;
	bh=hKGHKxWLPptDYE1rI/BXiADEq9O8UpCtSx0KXY9KlZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7/U5et5Owg2kjf3fDNkKG1RrCXXTl7VM8X5adUU0MGoIMR3nWm+DZZl8cfHrRpNh
	 2w+Fo87iy7RQYEypCSr3+OyL24W56vpJr+fF5/5MiN9QStCyLaLfKyI4NrFpfO0DZ8
	 5I2Ieaq5pwut2+lu0Afc6RtwLPz0TZ7L13J+CCvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0004/1887] io_uring: dont flood a cancelling task with task_work
Date: Wed, 28 Oct 2026 17:35:00 +0100
Message-ID: <20261028170459.319160821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2829,6 +2829,7 @@ struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
 	struct io_ring_ctx		*ctx;
+	bool				in_cancel;
 };
 
 static __cold void io_tctx_exit_cb(struct callback_head *cb)
@@ -2843,7 +2844,8 @@ static __cold void io_tctx_exit_cb(struc
 	 * tctx can be NULL if the queueing of this task_work raced with
 	 * work cancelation off the exec path.
 	 */
-	if (tctx && !atomic_read(&tctx->in_idle))
+	work->in_cancel = tctx && atomic_read(&tctx->in_idle);
+	if (tctx && !work->in_cancel)
 		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
@@ -2931,6 +2933,14 @@ static __cold void io_ring_exit_work(str
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


