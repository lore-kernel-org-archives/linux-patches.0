Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207961;
	b=DTfshq/I4kRDb6PeSvWBb8Ce2CLL0DBumjtto0P8wcloOzhwKriekkr4VbCQ05e7FwC7
	 +0ABEv+6sk1hUnVWNjV2qlYwDHTrVret1QxsFacj8oxhEGl+LzutlbbA573usrXWqoFGO
	 JZrlhzxIj55u28/vxIg3CBax/rZNT3QYnVfUBAeLGw9U8Xa5+fe3X9vjhfppFxPGyLLlW
	 7LQmhoadqGqDvgp3Sy+JvvqHG5FADMV++s6u91YP2KAqRAfE6qf8TdEMD1qW7IKV6IFwb
	 2Sfj7bpDUms22IEbqD6ounyMp0kQLRi2LhPHNxT7DLPQg5zyYGO1nV32YHHSxPN8aeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BatabeKitl+1oE+zB+VVDzYQ/4auDl+s//Zb6zOfe6Y=;
	b=VIR7/uEpGzP4Y9ygVzSXNR4AzV2jkMgxMXcRxlgOmQF5skV6yZCcNofcVqa5yeFGH9ny
	 uwlwsG8XJXHOw1aNpSSzAI+fmYVbQX4Y7BI9yvBWk4uQSwmlLWyxW6mQZ9+PgI0/XzO5F
	 x+KHGbNWCP0yhDoMySaL8V98po2SIec5EnCDf8oixx6gFBHFgcq8pouoOhgRtDWZHIDp4
	 0bFb0MEz6riAARJYCwLx4k3HZD8Iojfk/U13vrKTCmyTY1I5vZ0JkwczAj8fNVT3iuyz3
	 3sLAs/nD09ORSIK4RnFQGAQVn8zw6WVmFMdhl2iYayG5r+eFXTy1ytNyWNfIOjb1wmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1k1NGVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1576606A324;
	Wed, 28 Oct 2026 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1k1NGVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22971F01825;
	Wed, 28 Oct 2026 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207960;
	bh=BatabeKitl+1oE+zB+VVDzYQ/4auDl+s//Zb6zOfe6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1k1NGVddzC4XV8XqPpEOKUnW4khdeYnJTz1BdyLflggO9gPND3QeSpY+8IPGyt1O
	 0+2h4ZSbllXM8NQKpBQcMw9fS4aI2YZ4fFdkZQPlJQy5YFoJKVkp76rAnK++RIr/6Z
	 Tma6Pf7ZhTkSwv2uG3bWIDK2ooY5AL+OvpWh/DFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 200/247] io_uring/io-wq: dont exit with a creation pending
Date: Wed, 28 Oct 2026 18:00:03 +0100
Message-ID: <20261028165952.155050337@linuxfoundation.org>
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

Commit e231d2e8f80d3649ecd3851b7f2abdfbe606c04b upstream.

A worker that is the last one to go to sleep while work is pending asks
for another worker. io_wq_dec_running() bumps ->nr_running on behalf of
the new worker and queues create_worker_cb() as task_work for the owner
of the io-wq. Until that has run, everybody else takes it that a worker
is running which is going to look after the work list: io_wq_enqueue()
doesn't create one, and other workers that go to sleep don't find
themselves to be the last.

If the worker that made the request exits, io_worker_exit() cancels the
task_work, and io_worker_cancel_cb() drops ->nr_running without a look at
the work list:

worker A                   worker B                 io_wq_enqueue()
blocks, work is pending
  nr_running++
  queues create_worker_cb()
wakes, handles the work
idle timeout, decides to exit
                           picks up work 1
                                                    queues work 2
                                                    B is on the free list
                                                    still: wakes B
                           work 1 blocks
                             nr_running 2 -> 1
io_worker_exit()
  io_worker_cancel_cb()
    nr_running 1 -> 0

Work 2 has to wait for work 1, although there is room for more workers.
It takes an owner that doesn't get around to run its task_work for the
time of the idle timeout, less if the worker exits because its affinity
was changed or the io-wq is marked exit-on-idle.

Let the worker stay around until its request has been dealt with. Only
the worker itself sets ->create_state, so it can't be set behind its
back once it has decided to leave.

[ 6.12: no exit-on-idle state ]
Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-12-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -708,8 +708,12 @@ static int io_wq_worker(void *data)
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
+		 * Not as long as a request of ours for another worker is
+		 * pending, though. It is accounted as a running worker, which
+		 * others rely on, and io_worker_exit() would cancel it.
 		 */
-		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
+		if (last_timeout && (exit_mask || acct->nr_workers > 1) &&
+		    !test_bit(0, &worker->create_state)) {
 			acct->nr_workers--;
 			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
 				hlist_nulls_del_init_rcu(&worker->nulls_node);


