Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829220;
	b=WstOJBW9Gu7AYsFkw6NSaUbCriASzbcVs37dIn+ttJkcvMZxbvRiTlQfbSTPFN8JsNL1
	 d6t4mwUTex5XG+6nmWYW1PQ+3dds09lXhvEuP1k9RicQz15Zhm8tY3pejrjRXHOdzg2Br
	 /DvTLV+XkaBLxQBg/2lteElWtuOzkFeN7YyjxCVmU6N7GhOww/tFUkISbsYXiOfd5vpxh
	 oMZVynQFH1/HxPuuBv6ovwjMdPKHAZECWk/aH7PrFgQg3D8qNvChAS5jMk4CZgLFEPzLB
	 c6niWt4aC5rtow+kk/pmL/DFBB0R5cZDUKStzbW8z0xX4XpRtnfmomacbwaix5/4cSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7mjPxHWpwvc/H50TOt3P4Vn7LD1LmoiyD98wBI0e4s=;
	b=mcl2EhtFN00Ir8XLmHHUe50uxqahfDgU1LcnTCv9zxdosSW+pVMyBhmDrIwNQjVgmAz4
	 QecUX+se8/aiiRsFhpE2E6JNhnrHQ8mpErs6IFr9eJamuuCWLaOxHEvKXZPze2BCR2u26
	 ZDO0ay7bpUelKNZ2dkRNK4UqU+9ZVaoDZpbDdQr3aE2qIvK7MuRZrokeUaOOl7Dj5blwV
	 FiF6aQeCaKGZKNelTm6+KXyNiA5pcZJkJcNrac4yCVworRYqpsFkn+5b2A2f74agq533T
	 HYVPVJ4PIeekOnZGJ+CIRukufCQ1pw/4tnrilWBhrX4LemxVq4UKtj+GcXT2nwm7uaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3VdSsKk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394286070A88;
	Wed,  4 Nov 2026 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3VdSsKk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B11F000C1;
	Wed,  4 Nov 2026 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829220;
	bh=h7mjPxHWpwvc/H50TOt3P4Vn7LD1LmoiyD98wBI0e4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3VdSsKkwxPmo7zCXNb5NBjwI+cWHVA+6vye1vUzv4a3abykH4/BSvz2s4D4bNVnZ
	 kIp75slQukwotM+lhFud4P9m2nN++YkHba4BQhkKgfhl/XQunXQbUTOw3s1LO/wB/c
	 GOGZJB621oONLEKyeb0jmHdgW2K1HOQtXmEcK20g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 524/547] io_uring/io-wq: no new workers once the exit has begun
Date: Wed,  4 Nov 2026 16:11:48 -0500
Message-ID: <20261104211053.284297357@linuxfoundation.org>
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
@@ -1416,6 +1416,12 @@ void io_wq_exit_start(struct io_wq *wq)
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


