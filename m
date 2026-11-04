Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831885;
	b=BAi4D6bVZlsX5UQW0nl2ZsAFJglFGtiZOfj0G1JeSyXdqZdSxeIRye/6tqSpaDGBWvV2
	 oE1Er8JIN7tTNUCmQS1rZ3v7RN3gRSlcc3r3nS9ZRaJ1RyLy3CBlBmThi9mjg1dkOSMti
	 mLouOnf1xM0FEmdhcwVXOO6HH8YbrxmckzlddiF+k76L9pUSGH/sy/bYGpjZg/3Y2cWLY
	 mW8izSOskeyI0/wkS+9lpBBai1Z4jIrb5hn5+JEpEq912YRfCYcqlvFTT+avKmQwOcq8Q
	 7Bbr39h+Dq6X2x7sJfAdIUlouEp/3WXfWeS5zjb+Bm3V7D0e+ZU6oAIXNyYkgjHkszw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o8YSH8qO52EZ0XHMYhHsc4hHEJ264GiZnwhZE2Za3Gw=;
	b=Jz2FZoQyLOhz76FePJJY0iyNqO0X99H6Kz62lIfUFjIe3OEaVgAwLDz/DGtLSvCCZcle
	 V0/5NR3C/kMOg8Wz7yrmxrLQRAN3z/OCmlJPbRaio1YNtG9bbOMqk61oNL88wToDbfnGx
	 g5MPu/zShjxqgPUBik366Lt/9KB/BBy3M5fPpvnD6WDgzYU2kG+9oIUmoBGry/7uDpN9W
	 4q/7jAeEW65IQAaxq4/Tp85CT20CzE1BlGTSjzOUdVctnHw5lC5/1jDQpqfcgxFkd4Sou
	 94gGVq5F5PfBOhT1T65cVU8yiwayMXXJDVn1w2+bJ3I+DxpW91XZzuUX+8KH/AzENNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjZHy78r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2190A606A333;
	Wed,  4 Nov 2026 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjZHy78r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E061F000C1;
	Wed,  4 Nov 2026 22:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831885;
	bh=o8YSH8qO52EZ0XHMYhHsc4hHEJ264GiZnwhZE2Za3Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjZHy78ritO5irMusUyYFbprwlzTIasXwcqrE9j0SmWWA1duYDWA/rW13YlJT4YbA
	 hgPm21oNdxJjwn/vFTB3QltglueCyeswCNUlD/ejlkcTPiiYF+qyNWlE1X2M+SgRVI
	 cLQndcabPmAcJu/H3/eq6c9bHKgtBv1FRdBcPDhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0974/1005] io_uring/io-wq: no new workers once the exit has begun
Date: Wed,  4 Nov 2026 16:11:47 -0500
Message-ID: <20261104211110.343012430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

Commit 47c68f925062a6013235d06add85a59f7d91e0fb upstream.

io_wq_exit_start() sets IO_WQ_BIT_EXIT, but worker creation task_work
queued before that stays queued until io_wq_exit_workers() cancels it.
In between the task runs its task_work while canceling requests, and a
worker can still get created.

That's a problem for exec. begin_new_exec() calls io_uring_task_cancel()
after de_thread(), when it's supposedly the only thread left, and
io_wq_exit_workers() only waits for ->worker_done, which a worker
completes before do_exit(). So the exiting worker is still in the thread
group, using the mm, files and sighand, while exec replaces them. Easy
to hit with a signal pending when create_io_thread() fails and the retry
gets queued right before execve().

Cancel the queued creation task_work as soon as the exit bit is set.
Pending work that isn't otherwise canceled now ends with -ECANCELED when
the io-wq is destroyed, rather than depending on whether the task
happened to run its task_work first.

Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[axboe: the barrier is already upstream, see 0e5663856b69, only the
 cancel is new]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1412,6 +1412,12 @@ void io_wq_exit_start(struct io_wq *wq)
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	/* Pairs with task_work_add() in io_queue_worker_create(). */
 	smp_mb__after_atomic();
+	/*
+	 * No more workers from here on. The caller is going to run its task
+	 * work, and on exec a thread that is created now would still be
+	 * around, exiting, by the time that the caller must be on its own.
+	 */
+	io_wq_cancel_tw_create(wq);
 }
 
 static void io_wq_cancel_tw_create(struct io_wq *wq)


