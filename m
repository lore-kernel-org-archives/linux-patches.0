Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035666;
	b=pzokD4R/hqWW5sexRVCXOkQrzs76X68ISgP5Q/9dgGBh0DvD2xrOTtx0RlWXBuv1KaLS
	 TYIUcopHfFuWp1fnxu+JBnZmcethO+zhiV/Yl7RZu6OMSZshESUETiI8EJMM20C2Ko++f
	 ioMk195+B2hcawWgVftaMNMbs6sD6Gf9IsKApPBB+qQ1foZFsqrXAOsAKAhxCdZP9OqaU
	 ibXGqUHzSbiBEBSPzzM0kQtvq7bomA3gKZSzsR1DkgUXnc0Kmn1pbMlLBqB4kNj3GpZLH
	 4dJ3TOM6SrbZdozNb8tLPY6EqBwzDptlgez1+UZ3J33e2Ea8g5RDP969C4944ltMoCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhOgqK8u1gukhp84kvDHxuC088F22GK2cimSVEVy3GA=;
	b=oG4K1Dxsdqg+DCOVLis6u/+p2YFoUvdabois5GiaBAxb0i2H6tVyM/t8ptYRKcFBVOYT
	 Zd0xOx2nqjGocBCz5s5C+7BTz+lReDOxow0bptmSiX/jgz0HtiXN5Of6hrZhOWGOrFN/o
	 Nuf68eoG9A36Rl1Is8NONvVZD5BnsGf7/5db5zKe5IEPd6cTD+tBY9QSdisIByo0rSf2h
	 vN+CtEFi/OTSdrqo9Z+6QucqtkpD2YnEC0o65Ty5TLPZUCuCZa7w3lJ4IyBoJk47dwYrI
	 gmNMoWrwcDV6GE9EUNhm4kaj3ujEJW0xi1OwVr0Xo+zZmkhdipxIKQ0uMFrxmcwwcoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMeyyeIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EB606A31C;
	Wed, 18 Nov 2026 21:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tMeyyeIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8DF1F000C4;
	Wed, 18 Nov 2026 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035665;
	bh=DhOgqK8u1gukhp84kvDHxuC088F22GK2cimSVEVy3GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tMeyyeIAb9ZI2sfym/S3/LrpHVTRdXmjiwOr/Zl7JVsOHNkUfxgVRKvrbKFHMEcs6
	 H0Ek9MiCIucOb4I2+vCgWgo/JMXm3SCtnDcomO+6q8I4pUB+Ae/BcKabGzWYWN2jDK
	 0R5Rk7y+XsdlIgjD1Fc5bZUuFA6GyySFXWak6Abo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0747/3318] io_uring/io-wq: no new workers once the exit has begun
Date: Wed, 18 Nov 2026 15:22:49 +0100
Message-ID: <20261118150341.038280845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1318,6 +1318,12 @@ void io_wq_exit_start(struct io_wq *wq)
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


