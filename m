Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207340;
	b=SjBiRVRIORSaZ9HTBT7eEcviVuBsin/I2PbS5pRDsmbEXkEf+oOVcrS7RS5bx/wTHCAj
	 Vu4fhDl9IGHgtXhdhbVwe06TyhaqPKJu3WWldK9I1Kj1Js1Mzp54GJZTrTWgkRrEbLBH1
	 xrv/Kv3bERpsFyAfS/NothX8cpOCQqYzk8TLCByJaPE0vdS0hEAW2AM3zHqDSnM6rSxL6
	 BPD17gnVKhQBP6IRUSIKBPRtd9Gpu6bWd5tfGigS/Px0mE25OiLdO3hhfgAiIqxMsr/vJ
	 kxiISTTO6Uwi3MltcF3LCXcP9bNZtDtXQD7kCQHKJUMmifHhp53MASxoabHjz8SBGDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=50giJBCytldzxjM43/2jgaegdrUsLeGcs6J+6EOxmsg=;
	b=jkQ5eupqv5HTgJ2EM+X8bLf1103+SudqzJvSnsTe6LxylOIIZg2Ozs/9qk9AOc3JM/fN
	 zq5wdsQOAAD26um6i4mwhrmPspivjVbyGt2Z4G6B5I2hq4wQzio0mupW5FZyKF1OPt/fF
	 fm4DAO+Dgih+B+mIebD9n2SLJoRDkjTdW/zIPe8ThxifDyrjc/s7Dk46auqhymyPceXi4
	 7oaL2Qt9KlqsGLZGd4m8VxaHzXmb23bt6wKx0Y1YUBn4ZQoUQSEqsacU0bVc+geMbjg5a
	 w+vZg9YcHE20mHnYGChxrWXhdu6HZrA5t7MBd9OxKfx0CFKYdmjbJ2Zx7PsLMtrxtkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3L1DVn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88154606A31C;
	Wed, 28 Oct 2026 17:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3L1DVn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D807D1F01829;
	Wed, 28 Oct 2026 17:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207340;
	bh=50giJBCytldzxjM43/2jgaegdrUsLeGcs6J+6EOxmsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3L1DVn8K1WnMZ6ISsfRFfz26MqbmyD/3L+qfy32KNb2D+pSf8ljNpM5SgJrgQNg8
	 4x2fxD/6GmEo5eeI9B6Bnyv/u1oe+WqHspgCEiaRU+dy8DyFQQYjUstDOCdvDLHLfQ
	 HFGRqvlGunS3hMBDQTBMdcS4hETdBR0ND9tYtXKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 27/88] io_uring/io-wq: dont strand work when a worker exits
Date: Wed, 28 Oct 2026 17:59:35 +0100
Message-ID: <20261028165942.754925524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: 38aa434ab933 ("io_uring/io-wq: add exit-on-idle state")
Fixes: 05c5f4ee4da7 ("io-wq: get rid of FIXED worker flag")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-11-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -694,6 +694,35 @@ static void io_worker_handle_work(struct
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
@@ -731,9 +760,14 @@ static int io_wq_worker(void *data)
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


