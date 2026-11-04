Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826869;
	b=eSuVt2TRqsacZsfjhWfhdZQeavfCIZaGNbx7IzWnDGmCNJB931/xdSeWzLkWzh/Iy3W+
	 zmI++iWN5jXgstp7EBBPLLxqgxXAPMJTxRQx70rQENj4nPge2EGolAG4PBAk3f7VbtaoJ
	 nRBHLv4CR3XBG7sSTYe2rPsySXEM85EBrAsoZfpcrOy8y4pCx0c1AE7HFPLlWC8CB0BQA
	 r/XLVejjpb6+UXyub+6LEEjgyE4LG616nZf5Rc4V+GpW25ZVBpbO3xTi7qoZ+z3i/MPIO
	 5BDpe/4KO2jPGPrX07kXrmSKkcLUawIHkfhS/mu26OZIE9t+Gyic/yjlNZQWX5RYMUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0/p1zg2kdp7d96CFjTXw3yDkS0ELFiwsIXK9YXZD3s=;
	b=otUnHGmC+wb1d+zK5QYKBFKDCCAkBkNpl9aPAeElOhCVXuggAyP2N+iv3XMFRuA3Fac8
	 N7WtaoITXKdPatlkfLJAmziQUgGv54FprAGaajc6c+55XGuAQdK6f8G3TbrM56sTMaC3d
	 oKsvk7dclE06Vs2xQQGAzXORYU1p21VHA0SodVUsx5hibB6b5NOVzL4jOS9PywTn3P/B+
	 K+Rkb8+nVSbcTHFZ7GiI1whX6pLzQdBtimvY71Srs9XPLLWtkGJjdp6DKIIzwzjfxzWid
	 soOgWqU3D8OOuubox0Di7ZbHoHcP5adTMhQqlDfwm4TKm9k+6+bSlJ3gleiJtzi1Gvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBAfSGyH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94E6070331;
	Wed,  4 Nov 2026 21:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBAfSGyH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5BB1F00919;
	Wed,  4 Nov 2026 21:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826868;
	bh=t0/p1zg2kdp7d96CFjTXw3yDkS0ELFiwsIXK9YXZD3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBAfSGyH0cfNzSL/r7yQv29IrnBJ36lOTjGBnkFzgFhv6tShyMcSa/f6TZFJNxUeU
	 gMW7KbAL1Ez4+ocWoNL2gbVMAcZXybp71L0Pcn92+OK2HGgWuoXb/VZ53663zZTEMO
	 lGtxbWQ5arUGsr8vnz+nNWUa5oduX8Q6cIEjjT0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 020/547] io_uring/io-wq: dont lose the signal that ends work
Date: Wed,  4 Nov 2026 16:03:24 -0500
Message-ID: <20261104211038.943368434@linuxfoundation.org>
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

[ Upstream commit 63c103279a95e82280092f2f4232e91e8117a252 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 2a980e86dd940..140b7e022fbf2 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -651,9 +651,15 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 
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
 			req = container_of(work, struct io_kiocb, work);
 			kcov_remote_start_common(req->ctx->kcov_handle);
 			io_wq_submit_work(work);
-- 
2.53.0



