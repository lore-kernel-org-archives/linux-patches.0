Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044687;
	b=tEt5i68sIiIJMJ6zAmilLXy7AIgLmLxavgLrSyYCPM+ytqCw3qMLhNlnL+96tKjzzbqX
	 QGWVUfGet2IBrf8a4HwPJwwZPXUj7vgJgPTrfYEshkt/BZHBEZIA7oo3cix0g9aqXgZ5G
	 9qbPLf9peLmy1nLIiKIHfH+RyG2SYz/nA0qDOuUo9e7qXKMm+TyNYr4Iga6GTGfAiFb+V
	 yjKLbMvIxBhZoql5Y6T/gUa8mGIqS8+pN7QuVVUs/ob/kg0Ez6q8zxlmiSlV8VQFbl/Tb
	 qD//Uc0bQ9DjT1w7zupMfFIOp1rUrU6tdjt50pnuzNNvPGckiDbiGPBidbeYygKOvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dIBAxII2Fme63xsaGgg1X1RJnOmGrQs5b6xzzys+Y9o=;
	b=gyyMcv9uHvyrOIQEd7HiwLXCgoeDEVJ0ASTfJ8Tqg+AVZKOEGj0upOea18crWpJCtF6c
	 4/IN5lJvgt4owZxNwgjlch095PBv/Rr87HO/Y0NiSj3PwcL3lf7g8PtYAuAyA6oI9THUG
	 DFrckTyLnx6hj9a8frMurEM2NIFLQHcZZfyOM/8xDfwujE7mulhu6ZMLLP/JSunhsGC7F
	 dbIIIN+v3g2ceS7RH2wJJOpuK6vMCKvHWnnXzAQvx7G2DDF0Bf+DYVhW5luKmxIYw9LHy
	 5sV7bCDkgem8rJWFTNgUm9sOXjm5NFnoLhbJF/eeCoUa5lODP8JhkVEZCMfWHVjck+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tc3EMEIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D249606A31C;
	Wed, 18 Nov 2026 23:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tc3EMEIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835521F000C4;
	Wed, 18 Nov 2026 23:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044687;
	bh=dIBAxII2Fme63xsaGgg1X1RJnOmGrQs5b6xzzys+Y9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tc3EMEIoRyTS1Jf0K+aQaSimd+XGqBXX2WtWOjF1PQie9ORhCeSCXRCNFiQYh4M0l
	 sSr4A5OJaVJGsvBvHIj4Ib5wHfAWzp1qySPvm8GI1UW6+L6Mq3EKWhj1VKAuO3qjBy
	 edcNGUAKe5TTMb7RJ/HjnIgCgRz03juzvicIcxrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0655/2857] io_uring/io-wq: no new workers once the exit has begun
Date: Wed, 18 Nov 2026 15:28:09 +0100
Message-ID: <20261118150225.141653785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -1335,6 +1335,12 @@ void io_wq_exit_start(struct io_wq *wq)
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


