Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210258;
	b=eoTAEeLIn74DTzPyagiImTfubLPdYkCXtJzrTom1W1XrVriUS4kHowLvxw/899coQaSi
	 SoUlVc+8/b8vgRsGQwvOhtSHTfyNHqzpaF2OLvekLRX+Z3IOxU/XKJ3wmG0TfdW3yfeWH
	 C4bSVbgP59ONScSebo+2dNvSrEYJ8WwMH8Rb/XYpnXzB1s+lks6GytvhSmEeYcN/tO0OW
	 L+0no9iNcuT2JbCWc20LAL3RYPItWJ4hmwjicMUyqUjDz5qXUWAqJlVH8C1TLXo4+ZCNj
	 SP2ii5Gss7JyRiIcIkJq1zwVoQLtJ+oOvcm7VnQUbsUi2yxYZO2t28Wk17YOn964iqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1y8PrRzxT52S4irhJsPxLzzhmnkBV2Wfnqzj0SDMiVs=;
	b=LAIbGrJE8zZO+l63DRVvtMvO0Aq1N4vdy8Uwf8xQRpa7SkxkdcIjARq+eOc3fCBkXZyr
	 XLZfZq9sbq5qBJFSO4x73A1pM+GvbS3R/gWbreWpHwvEyAHByKdht1NI5dOPwOD4C3Puh
	 NtOQKZyoZMuJtuyxCQfBW32u6wsk9C3PhmZt2PvHck8ONuuJ/+9ZMXzudtNHMMvkYBj64
	 QygQSPqF+Gp7VdP/zONcWNA2/rtoTcLXkB5sgyc8w3qleGJE1DPgL9rnYGxn3Ei+MFFgg
	 dj1Xj6cqwtuiU23jRNrwJX30g5JXI4NhLINt2abrgL9+H32R9kgAv/hJeB6opaVDQMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijeG0PZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78937606A321;
	Wed, 28 Oct 2026 17:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ijeG0PZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E361F031E3;
	Wed, 28 Oct 2026 17:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210258;
	bh=1y8PrRzxT52S4irhJsPxLzzhmnkBV2Wfnqzj0SDMiVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijeG0PZ4yLK9efFdICFDD8Y20/wKM80caVQv98MscOnpka78HrWqDhzDX1qjGTiPw
	 TDlUySExNEeuz1YpdJwSLdHJrXrhHORAfb9nd1nC7aS12zZJuTVKiwnG8EwfHRaZhY
	 9mlR6ipbxYGzsFMAZsUc+kRO+E0XIK/opUr3vmZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.6 131/168] io_uring/io-wq: dont strand work when a worker exits
Date: Wed, 28 Oct 2026 18:01:07 +0100
Message-ID: <20261028165946.186813694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

[ 6.6: no exit-on-idle state, ->nr_workers and the free list are under wq->lock ]
Fixes: 38aa434ab933 ("io_uring/io-wq: add exit-on-idle state")
Fixes: 05c5f4ee4da7 ("io-wq: get rid of FIXED worker flag")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-11-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -648,6 +648,36 @@ static void io_worker_handle_work(struct
 	} while (1);
 }
 
+/*
+ * The worker has decided to exit, and has given up its ->nr_workers slot and
+ * its place on the free list. io_wq_enqueue() may have picked it from that
+ * list, or seen it running, after it last looked at the work list. Leave
+ * ->nr_running as well and check again. Returns false if the worker has to
+ * stay.
+ */
+static bool io_worker_retire(struct io_wq *wq, struct io_wq_acct *acct,
+			     struct io_worker *worker)
+{
+	/* turns io_wq_dec_running() and the scheduler hooks into no-ops */
+	clear_bit(IO_WORKER_F_UP, &worker->flags);
+	atomic_dec(&acct->nr_running);
+	if (!io_acct_run_queue(acct))
+		return true;
+	raw_spin_unlock(&acct->lock);
+
+	raw_spin_lock(&wq->lock);
+	if (acct->nr_workers >= acct->max_workers) {
+		/* a worker was created in our place, the work is its business */
+		raw_spin_unlock(&wq->lock);
+		return true;
+	}
+	acct->nr_workers++;
+	raw_spin_unlock(&wq->lock);
+	atomic_inc(&acct->nr_running);
+	set_bit(IO_WORKER_F_UP, &worker->flags);
+	return false;
+}
+
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -681,9 +711,14 @@ static int io_wq_worker(void *data)
 		 */
 		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
+			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
+				hlist_nulls_del_init_rcu(&worker->nulls_node);
 			raw_spin_unlock(&wq->lock);
 			__set_current_state(TASK_RUNNING);
-			break;
+			if (io_worker_retire(wq, acct, worker))
+				break;
+			last_timeout = false;
+			continue;
 		}
 		last_timeout = false;
 		__io_worker_idle(wq, worker);


