Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826821;
	b=zgirvX7UiCo5OiRe81TZ5dBfhZUh6D3FVbTlhhuelgcdhgMTf4jQC00uettCgZ6T6qtv
	 fG+DNTvwna8OkrgQ6muEfNWeZyvGAFBivi1K0t/7MNSdFgAJ/kao2eEg7keftbfnVHAoZ
	 aJiB8nL++kxS75dADN+zRx6q2dyBYVzC1cthjCdr21X5Bkn83arx0uXRd3RZbBhGT/bPl
	 pp3XQB4oFIzacgcHqrxBbuqn9vo49H06jDWY5lfPHMvwu7BlyjGLW6EkqqHUii32brpyz
	 IxbtQc8hTZiP+GbCD82N1Opm87DDCC2Rq/zOMv1wIKDrIwMfSsNIwJYBpaqHGX81+MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eVKXrLFH0bmMx4r4EadxYf13QlO6QFDwhqyYhYdRFBA=;
	b=yEzUw8yl1qoITOg/6Itjf3fKAQN0bKKQ7CHNM4PB9svnZ8Lvsu7mk1OAnMjwiMV3K2MF
	 t0rK3hYsjjlnrBBYpT+FyqxFZ/C8dYGhOiUXBUIJbwQzoGTFpm2xjQcE0TD8IuiG+kKqx
	 we2s3x2b2axF32OcP1ePaH6mNXwOf+RFIbjIYbbfsczzjTGzBas3lWU1I8Erw57q6ajvc
	 j0RYpCaTxhg5Ufcl8wHT0IEpy8cfW9OJ8822eBKd1K5t2RmvyGuWImlfq93k+mWgJO1Wm
	 gtCwdv7AZ2Fl37dMa5whCr1tVTqXD/aU958KwUzwpdEbJS+VxjNKY+m2FefzhPcC0yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmJ1DRPD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0440A6071AE7;
	Wed,  4 Nov 2026 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmJ1DRPD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858FE1F00A16;
	Wed,  4 Nov 2026 21:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826820;
	bh=eVKXrLFH0bmMx4r4EadxYf13QlO6QFDwhqyYhYdRFBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmJ1DRPDtP0znmM6RXYnB0WvS6GaA7Gi5xDh1XQmNSMfqwzet1YRb2LcqumnxhBR8
	 Vb85wTfpee7ZBHlBG/jwbvL4/D1x+m1DpCx5ktFP2reL0n3VJERnlLDGAkmNs7vSbk
	 vhr3DjaBAZgaBjZs10SCAA3V4pjxuvt3KRYWadBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 028/547] io_uring/io-wq: dont exit with a creation pending
Date: Wed,  4 Nov 2026 16:03:32 -0500
Message-ID: <20261104211039.152278003@linuxfoundation.org>
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

[ Upstream commit e231d2e8f80d3649ecd3851b7f2abdfbe606c04b ]

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

Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-12-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 4230a8ca7d8a3..0120ec40effad 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -761,9 +761,13 @@ static int io_wq_worker(void *data)
 		 * idle-exit, drop the worker as well. This is used to avoid
 		 * keeping io-wq workers around for tasks that no longer have
 		 * any active io_uring instances.
+		 * Not as long as a request of ours for another worker is
+		 * pending, though. It is accounted as a running worker, which
+		 * others rely on, and io_worker_exit() would cancel it.
 		 */
-		if ((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
-		    test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) {
+		if (((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
+		     test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) &&
+		    !test_bit(0, &worker->create_state)) {
 			acct->nr_workers--;
 			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
 				hlist_nulls_del_init_rcu(&worker->nulls_node);
-- 
2.53.0



