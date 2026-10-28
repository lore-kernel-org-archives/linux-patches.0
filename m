Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212039;
	b=i79FJco+eqRbvc5Cy9qL/jVWfQq1+dynr7aZEkE0iM2csbr2txG5TFSymQEJPoBnMM0S
	 JrdGkgy2Z/+bcjrLI1VmOiCXyMCzuSA2wGDRXJfTjm4mvprfRBCdy8Pql/HomMpQtQ1It
	 7KjJJtt8GYrrwlNnXD8FImT+sqFQjj6P0IVM/+2E7f2kZOHsbQFOCCnNSG61e3sGV/+im
	 QyZG4VXkabYX6PCM5w3bowvAHRl3EPQGyS2OprUvlTHuGa9JdzDBEkkv9nL07DrDoCXeD
	 ak/XywNUJ9cj12W5rRTJuMYLYL8WLJ8Xo1pu649auYatkN/oKNssbtXjZZlN2YVCjew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jKPdJFCpsokRM28t5nuvvTrw8GoYGQZBwzAQQmKNGTc=;
	b=GIAWILnaxlOSz/MwDigYktOcdrS1oerZjMfEXy4yIOAbdUG8Te4e5d18VUuVt/IA/PDd
	 tm/aDSBCq+kchpIgIb6grvS9LGxOhC+92OGWXDgy5DAH4NwFCflFhv/R89URXzv9SbB0i
	 L+tRG6Yz4KSLqRWdX0Lg7UvVNTcvZ0k5hypjjeeZfMtvQH9a7KqsgewSo+BQ3/RAkYUF4
	 mkRQX130cKIod0H0Rwvdc4LqZglFSlEqid8GSmhwNFzXDia1DNJOwTbbwLv3SHztMf4lK
	 MiR0Ktu0A2kQwPhOyyY58wa7SQrFPhWqnQStxFj+mSEd4rzAqMR2mvyKYz838ry0Vkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MJ/QF6Ro";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5842D606A31A;
	Wed, 28 Oct 2026 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MJ/QF6Ro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A733E1F01825;
	Wed, 28 Oct 2026 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212038;
	bh=jKPdJFCpsokRM28t5nuvvTrw8GoYGQZBwzAQQmKNGTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJ/QF6RooMBTfg0AEpCvnpnb7mQBKp7qcqMdfLyA2H+fDKNRrkt7gjYYQYgGiRa6p
	 IS79oOGQ4ShTjz+nvmqyrwELpX+1/MJt+caGqFxhYBr8/Nni8wsqoAA7uI/uMNxQ55
	 Pi+nAzs+hjojC5FpmGZi0ctzyGbDKQrC/DXzmhT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.1 0005/1887] io_uring/io-wq: dont strand work when a worker exits
Date: Wed, 28 Oct 2026 17:35:01 +0100
Message-ID: <20261028170459.342636575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

Commit ad41f325be1271b22d99353819c90f0d5e45acc8 upstream.

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

[ 6.1: no exit-on-idle state, per-node io_wqe with ->lock for the
  workers and non-atomic worker flags; io_acct_run_queue() drops
  acct->lock itself here ]
Fixes: 38aa434ab933 ("io_uring/io-wq: add exit-on-idle state")
Fixes: 05c5f4ee4da7 ("io-wq: get rid of FIXED worker flag")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-11-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -642,6 +642,36 @@ static void io_worker_handle_work(struct
 	} while (1);
 }
 
+/*
+ * The worker has decided to exit, and has given up its ->nr_workers slot and
+ * its place on the free list. io_wqe_enqueue() may have picked it from that
+ * list, or seen it running, after it last looked at the work list. Leave
+ * ->nr_running as well and check again. Returns false if the worker has to
+ * stay.
+ */
+static bool io_worker_retire(struct io_wqe *wqe, struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+	/* turns io_wqe_dec_running() and the scheduler hooks into no-ops */
+	worker->flags &= ~IO_WORKER_F_UP;
+	atomic_dec(&acct->nr_running);
+	if (!io_acct_run_queue(acct))
+		return true;
+
+	raw_spin_lock(&wqe->lock);
+	if (acct->nr_workers >= acct->max_workers) {
+		/* a worker was created in our place, the work is its business */
+		raw_spin_unlock(&wqe->lock);
+		return true;
+	}
+	acct->nr_workers++;
+	raw_spin_unlock(&wqe->lock);
+	atomic_inc(&acct->nr_running);
+	worker->flags |= IO_WORKER_F_UP;
+	return false;
+}
+
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -670,9 +700,16 @@ static int io_wqe_worker(void *data)
 		 */
 		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
+			if (worker->flags & IO_WORKER_F_FREE) {
+				worker->flags &= ~IO_WORKER_F_FREE;
+				hlist_nulls_del_init_rcu(&worker->nulls_node);
+			}
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
-			break;
+			if (io_worker_retire(wqe, worker))
+				break;
+			last_timeout = false;
+			continue;
 		}
 		last_timeout = false;
 		__io_worker_idle(wqe, worker);


