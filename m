Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826820;
	b=o3orQaZW4vvymN0ub8aMVJf6bvSPiwCxH2BebIUgPsDQHfR0Q80wKb+9med4+pUFgjr2
	 QUuaN3tfH9zLy4wwviKL/osM+MrSW0xyUsdoLWRs6I+WHWweR1wVCndgNWQYwIB2+lB/n
	 fejggJy+DewAV0ghIOhOFdXQAnhvvdnxOYpUVdKjRc0F7THdBvN9QLotVzaEDeGGKBxuI
	 q1DsW75fe/hQofRjG0RdpYP0wbSkVvR6jjJtDe45ZuNjPDWqMC2LUvyfDluXQc1MmfaxU
	 mRX8y/mhSGjcKkrCnLlXW5yQKjFVAa67eeIK4wqpPWOMSrInxvPfIECx1DCZYWFblkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ysl4zElsqCR+cs3WQhXCSbOnmZa2l3h2MMh6Ouzp3Hg=;
	b=ir/60aJx6mDFnprt0eSKlezOJRIXMW5IWjAaLAlMDL2QXGuoReNPOgpTw3CeZeG0gNcI
	 vcJPQZ5JMjkMR6dTMPBW4Rvu34YMHOIjxB0dNtygm5Q5Nl0DJxIUVUdqbAPwF8wcKM915
	 U6gr2EM4FWupYsq5xp/wj+IvTURwjE4N1azaKbubn5AevbbDkkKmLqcLRgH2psFHYFKa0
	 PUtqQLiYKivUcDmGE1MyICm6EhCAqomoWl+6q19Jj+uvSa5AXTJzEbRKoFf4v3DE6nKEU
	 8QIawfO2BxH3qnp5pis+dsez0lxn9DcDTh4lLE17jsfCHducQn0OkL0xh0oqFfM1hgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HsgauYhw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3286071ADF;
	Wed,  4 Nov 2026 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HsgauYhw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89B21F00A1A;
	Wed,  4 Nov 2026 21:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826819;
	bh=ysl4zElsqCR+cs3WQhXCSbOnmZa2l3h2MMh6Ouzp3Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsgauYhwnw5joP34AMgOb8qC+xiUp63xcf0PEAGEaYqH5S1ODSiseuW/d3QdM57rb
	 wnJmHe/4MPtfmQhBGzvUTgNkZROXuLMfR0riAzAmPTvT8h6ZBTfo0S/u+rRLRhB26A
	 QtKpcefpCxQhsq9zKjqV59+gjCEsa4cFEAcCkb1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 027/547] io_uring/io-wq: dont strand work when a worker exits
Date: Wed,  4 Nov 2026 16:03:31 -0500
Message-ID: <20261104211039.126488618@linuxfoundation.org>
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

[ Upstream commit ad41f325be1271b22d99353819c90f0d5e45acc8 ]

A worker exits if its idle timeout fired and it isn't the last one, if
its affinity was changed, or if the wq is marked exit-on-idle. It decides
so after it found the work list empty, and until io_worker_exit() is
through it stays on the free list and in ->nr_running:

worker                                io_wq_enqueue()
io_acct_run_queue() == false
                                      queues work
                                      io_acct_activate_free_worker()
                                        wake_up_process(worker)
                                      // found one, nothing to create
acct->nr_workers--
break
io_worker_exit()

Nobody is going to look at the work. If other workers exist, it has to
wait until one of them finishes what it is blocked on or hits its idle
timeout. If not, which is possible for the affinity and the exit-on-idle
case, it sits there until something else is queued. For exit-on-idle it
takes a task that closes its last ring and sets up a new one while the
workers are on their way out.

Make the worker take itself off the free list when it gives up its
->nr_workers slot, then leave ->nr_running, and only then take the final
look at the work list. That look and queueing work are both done under
acct->lock, so either the worker sees the work and stays, or the enqueue
side sees that the worker is gone and wakes or creates another one. If it
wants to stay and finds that its slot has been taken, a worker has been
created in its place, which is going to look at the work list, and it can
leave after all.

Fixes: 38aa434ab933 ("io_uring/io-wq: add exit-on-idle state")
Fixes: 05c5f4ee4da7 ("io-wq: get rid of FIXED worker flag")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-11-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 38fcccf389936..4230a8ca7d8a3 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -699,6 +699,35 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 	} while (1);
 }
 
+/*
+ * The worker has decided to exit, and has given up its ->nr_workers slot and
+ * its place on the free list. io_wq_enqueue() may have picked it from that
+ * list, or seen it running, after it last looked at the work list. Leave
+ * ->nr_running as well and check again. Returns false if the worker has to
+ * stay.
+ */
+static bool io_worker_retire(struct io_wq_acct *acct, struct io_worker *worker)
+{
+	/* turns io_wq_dec_running() and the scheduler hooks into no-ops */
+	clear_bit(IO_WORKER_F_UP, &worker->flags);
+	atomic_dec(&acct->nr_running);
+	if (!io_acct_run_queue(acct))
+		return true;
+	raw_spin_unlock(&acct->lock);
+
+	raw_spin_lock(&acct->workers_lock);
+	if (acct->nr_workers >= acct->max_workers) {
+		/* a worker was created in our place, the work is its business */
+		raw_spin_unlock(&acct->workers_lock);
+		return true;
+	}
+	acct->nr_workers++;
+	raw_spin_unlock(&acct->workers_lock);
+	atomic_inc(&acct->nr_running);
+	set_bit(IO_WORKER_F_UP, &worker->flags);
+	return false;
+}
+
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -736,9 +765,14 @@ static int io_wq_worker(void *data)
 		if ((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
 		    test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) {
 			acct->nr_workers--;
+			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
+				hlist_nulls_del_init_rcu(&worker->nulls_node);
 			raw_spin_unlock(&acct->workers_lock);
 			__set_current_state(TASK_RUNNING);
-			break;
+			if (io_worker_retire(acct, worker))
+				break;
+			last_timeout = false;
+			continue;
 		}
 		last_timeout = false;
 		__io_worker_idle(acct, worker);
-- 
2.53.0



