Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209834;
	b=F/VZcxFPubx9pCoKx5nucA3shFBdlDGq7ZF251OsgsWu5E6tCVpJnZA4rjiXkKKHOa0j
	 Y+nAROsfNg4BWUR1EaqKM1TnunijPX7FtnJi89J1nlrSCpKyD/qFljcxO3krJmm/AfeTT
	 gmLoWRNwx7pmxEBsLQSHxmv/ulXaBySoNsqdQwX+vuTzrQHs/sCXdkTq16bixZYQtK/u9
	 GOr61YLztpS8CFA1s7xlUMTEbT/YKPKYNice4F8bvwJQV9RRb+8dXPUVil2RMmujHOMh+
	 TuFwfjqKKe58ShPFz91/+dl/KKL+RZq1s4yVdpQsGIR7RU3S0RhG3TZn7wMlAjbh46A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9yrakk7b/4T8d24quldRLpL+1H8dkfQ6bVluxAQioA=;
	b=a4EJvEi2JxJvPdqQjgW/IoFEspQF2sdiFadzq89IF6iD/Ii8o9/QKzw9IHn11aOu7j1f
	 /wesEvZeTVFOligwVAuiCdT4ANX8Lrz5RMBUy4gtkRnDzZv08beszT2vgYgch+5PMy8qS
	 m/rqMbHDZOPF7vPUudC+zxnoB5fTr7pc/WHwyJ4Y0+g0lfT0IoDjJny7uK/eFF3CrPhQz
	 HG4W3KekcycRvl1C1NI8Skex9Thj/mlaJIPmPIN4Njis0UYT+K2cCuX/goHh6Hzou/rSQ
	 3SmJPD3zPJgZ2UTDgE6rul4LiodLIa/C7o6k8tL1dBFOmCMHyrU8zhxJptxrJdbVdOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHEpoQ7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16243606A31F;
	Wed, 28 Oct 2026 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MHEpoQ7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657C11F01828;
	Wed, 28 Oct 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209833;
	bh=K9yrakk7b/4T8d24quldRLpL+1H8dkfQ6bVluxAQioA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHEpoQ7iT3kLSLXKbLMv9U94Of1clWfMc9Kpoq9w3Z4NNBaOsZlsMe9+p9rkFmb6v
	 /uJ9keEGY0ZP7/HKb5CbH+lIq8xFe79X/OFrZ6LoRTt/i70tXhyVRXY9d0Fzh9Q4HY
	 fjNciv98TQiaR7sCUr/53Vki8IBssM17WKH0ZWIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 047/109] io_uring/io-wq: dont lose the signal that ends work
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028165943.469472825@linuxfoundation.org>
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

Commit 63c103279a95e82280092f2f4232e91e8117a252 upstream.

When a thread exits, only its tracked requests are cancelled. Then its
io-wq is torn down. io_wq_exit_workers() signals every worker, to get it
out of an interruptible sleep, and waits for all of them to exit. Before
they do, they go through the work that is left. Unbounded work is
cancelled. Bounded work is run, as it is expected to end by itself.

Not all of it does. An open has no file yet, so it counts as bounded, and
the open of a FIFO waits for the other end. That is what the signal is for.
But the workers are signalled once, and a worker that hasn't started the
work by then loses the signal:

  io_wq_exit_workers()               io_worker_handle_work()
    io_wq_worker_wake()
      set TIF_NOTIFY_SIGNAL
                                       io_assign_current_work()
                                         io_run_task_work()
                                           clear TIF_NOTIFY_SIGNAL
                                       io_wq_submit_work()
                                         fifo_open()
                                           wait_for_partner()
    wait_for_completion_timeout()

The thread never gets out of do_exit():

  IORING_OP_OPENAT of a FIFO without a writer, IOSQE_ASYNC
  exit of the thread that has submitted it

hangs in more than 9 of 10 attempts (4 CPUs, KVM), until the process is
killed.

Set TIF_NOTIFY_SIGNAL for bounded work that is started with IO_WQ_BIT_EXIT
set. The bit is set before the workers are signalled, and it is tested
after the flag has been cleared, with clear_notify_signal() providing the
barrier. So either the flag stays, or the bit is seen.

Work that is started while the io-wq exits is treated like work that is
being run at that time: it isn't interrupted unless it waits
interruptibly.

Fixes: afcc4015d1bf ("io-wq: provide an io_wq_put_and_exit() helper")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-4-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -648,9 +648,15 @@ static void io_worker_handle_work(struct
 
 			next_hashed = wq_next_work(work);
 
-			if (do_kill &&
-			    (work_flags & IO_WQ_WORK_UNBOUND))
+			/*
+			 * io_wq_exit_workers() signals us once, so that we
+			 * don't sleep for ever. If that was before this work
+			 * became the current one, the signal is gone.
+			 */
+			if (do_kill && (work_flags & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
+			else if (do_kill)
+				set_notify_signal(current);
 			io_wq_submit_work(work);
 			io_assign_current_work(worker, NULL);
 


