Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826818;
	b=4VD8tMvFC/SAfsSTkaaSdDSWk9a/bKzisx4cVniOXcyJJbIyz31ZBJAcrO9h7YjpZwmo
	 on3sau2AF6p+z0PTFTOSWYypQWUoBoQfWSl3VWp+plfvnhQ5zuCB0zKw3lFvnz/LMw3kq
	 jQJt4cicCmVMu/NvnG3PROXFWb5wH+Hl/OHT8bdxIE6NHcoTyAqRM6TaoNOJ7t/o0/qm/
	 oUj36ShLmTt9f4sS7scF9BljrJaUtyzCxV39JUVoSBZB+04OAoQNVxg1mXhRUDcYrkAAd
	 rtdfBbceiI9oeeVfqK8vY77utQvmuYTsTg3VYPe70mzzTePaOuzKmiLdsMn9VdRLDjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mb4AywhwZQs519UHUO/fYW+nIA7/6Uek0Y5c2JZ4TUA=;
	b=TBGG7trgjZAN1d+aUoY6jI+REif+vNJb70u1fkj1HmBh4dbAlIfStaxNPPVcE3kyVgrK
	 SClvkSWPlQNJea5i+UA5xu4fC2SvHY2FISzJtjz6tvvKpnEfBYxLDT5W0yBoNMnrNAduI
	 Z55CmmHmllivcieTL8RAJtPxmq7a2Bx+mg1tt9oO+ZwWO6s5g29uC9bBuNYiGGvPpMopO
	 T3xtCc1jTZHHyEhkoNymC9cgURLTMu4cpycfxiIpIcRfcw8FOTG4ZfJ3HuMdJ0EV1IaS6
	 JEpYH9bL6eC1+NYTfa7F2yf+HHIsQPRkEt5e7smVbCpYFI2iXgejajJzQhf7j7tZMvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6Tjn7LA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39C0606A32D;
	Wed,  4 Nov 2026 21:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6Tjn7LA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C051F00A2B;
	Wed,  4 Nov 2026 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826817;
	bh=mb4AywhwZQs519UHUO/fYW+nIA7/6Uek0Y5c2JZ4TUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6Tjn7LAPyeleO216Jsh/k1moPBkXAaeDmDUAbTIBjV7J81VjgAQq0n0WegvLzMn6
	 rN9ofYXo9J/UueQdXALDuKHCGkHYgTOrnbo3QDCVAgaylO1JvdS9wo0DhA16U65dJ2
	 KZS8A9LgTxyFsjFIAxbW6BZveYlYnGCs8vBwA5P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 026/547] io_uring/io-wq: dont go to sleep on pending work
Date: Wed,  4 Nov 2026 16:03:30 -0500
Message-ID: <20261104211039.099830389@linuxfoundation.org>
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

[ Upstream commit f19c38feb96802ee53a99649d740d2bf630bcce7 ]

io_wq_enqueue() wakes a worker off the free list. If there is none it
creates one, unless ->nr_running says that a worker is running. That
relies on whoever takes ->nr_running to zero to check for pending work,
which io_wq_dec_running() no longer does for a worker without
->cur_work, on the grounds that an idle worker is either woken right
away or someone else has created a worker. Neither has to be the case:

worker A (idle)          worker B (idle)          io_wq_enqueue()
                         woken for work 1
woken (e.g. timeout)     takes work 1
work list is empty
                                                  queues work 2
                                                  B is first on the free
                                                  list: wake_up_process(B)
                         leaves the free list
                         work 1 blocks
                           nr_running 2 -> 1
schedule_timeout()
  nr_running 1 -> 0
  ->cur_work == NULL

Work 2 isn't looked at until work 1 is done or A's idle timeout fires,
five seconds later. ->cur_work is also NULL while a worker blocks on
->uring_lock in io_wq_put_work(), with the same result if it was the
only one running.

Let the idle worker leave ->nr_running by itself before it takes its last
look at the work list. Both that and queueing work are done under
acct->lock, so either the worker sees the work, or the enqueue side sees
that it can't count on this worker. This doesn't bring back the request
for a new worker which the check was meant to avoid, and as idle workers
don't get to io_wq_dec_running() any more, the check can go.

Fixes: 8343cae362e1 ("io_uring/io-wq: ignore non-busy worker going to sleep")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-10-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6a59994d4bd5e..38fcccf389936 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -467,11 +467,9 @@ static void io_wq_dec_running(struct io_worker *worker)
 
 	if (!atomic_dec_and_test(&acct->nr_running))
 		return;
-	if (!worker->cur_work)
-		return;
 	if (!io_acct_run_queue(acct))
 		return;
-	if (io_wq_hash_defer(worker->cur_work, acct)) {
+	if (worker->cur_work && io_wq_hash_defer(worker->cur_work, acct)) {
 		raw_spin_unlock(&acct->lock);
 		return;
 	}
@@ -747,6 +745,19 @@ static int io_wq_worker(void *data)
 		raw_spin_unlock(&acct->workers_lock);
 		if (io_run_task_work())
 			continue;
+		/*
+		 * io_wq_enqueue() leaves new work to us for as long as we are
+		 * accounted as running. Get out of ->nr_running before taking
+		 * the last look at the work list, rather than when scheduling
+		 * out. No need to ask for another worker then, we can do it.
+		 */
+		clear_bit(IO_WORKER_F_RUNNING, &worker->flags);
+		atomic_dec(&acct->nr_running);
+		if (io_acct_run_queue(acct)) {
+			io_wq_worker_running(current);
+			io_worker_handle_work(acct, worker);
+			continue;
+		}
 		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
 		if (signal_pending(current)) {
 			struct ksignal ksig;
-- 
2.53.0



