Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061850;
	b=VSa2IIQtkUVjfSQ3WJObweV5+TyolVa/X19JqIKaBm3MXJLPAA78XkCThkFKQAY9SN3D
	 KwkZH8DZ29pnBFcaY5Zhmw1EzoDpQM+rmPZP+5+WaTzkM/SmHFhJkvmRP/3pHvgBp5LIE
	 ggm0cw72vaKKlzsh39uvL+gfsD9aVxVlkfUreT0xdbKKLVyUHes5uIuhIRuH3134ptaop
	 VojiSQTPZRuElxf7BuET3NVCzQRRe6Ja5j2UwNlBCbU6MhfHoB3zaO3wZzRzbLroNT0jD
	 NJ/NZLvEkc/FnaSP91BfbpuZid7IftW1OfRZYybFE8wW/TAgoSxdyO6BTTQHGalKRrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfDH9YVGfxdzclkBInq8qUaLdqA/aHB6285kwR0R5Mg=;
	b=ggCV5eu2IYd9xowAFqnV/tFJCAuWbz3r7gypnTTzqdlYoVglhdEIJd4s+pcCxqMHmw3J
	 i/2n5Q9sX+aZG9Xf9yeN19fToz8jLEkgHRLYB6TH3DMzhpPDcDkI58odeKofF8Sn4Unw4
	 NP12QI+6xk9bZA0bMWDaIdxOvvAgiA3c7QWZ0sHWLyF6FOvJkHKfp3I9PPKULOS8Jr9Vk
	 A+1JiPxr1081XzWha+OpTGeij/Og5GFVYhoapwfGkjMJXX3XWN/jcONQXKk01sTWBye48
	 QQoyTzeyqvb5qGfBb5S41pm6i+hlzhfFUOgN3T6eXGMergsrhpQLSwtFH1DJ8Yt59fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSKBt50W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD6606A32C;
	Sat,  7 Nov 2026 14:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSKBt50W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C4D1F0089F;
	Sat,  7 Nov 2026 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061850;
	bh=DfDH9YVGfxdzclkBInq8qUaLdqA/aHB6285kwR0R5Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSKBt50WWY5zLdCUV/4YR5yHOLViQX9yrHGNQQ2xhOlYzhhZ3HEib/Zyvdt3kI28x
	 7ouxcqh0tOzxX5MaEtOoQ6oKc9tu+MIu7yo24ip+NUplgGHi3ylRnYhiHPGyxpXLut
	 6ZjHWOFkTSnHj3eT3v9Z+W0XJ4EqumkJFXYRs0xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0831/1536] io_uring/io-wq: no new workers once the exit has begun
Date: Sat,  7 Nov 2026 08:47:27 -0500
Message-ID: <20261107135020.887227267@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -1320,6 +1320,12 @@ void io_wq_exit_start(struct io_wq *wq)
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


