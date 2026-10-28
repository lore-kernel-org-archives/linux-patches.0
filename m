Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207958;
	b=ysZo89VoTZx0EeVehKX79k5flgTw4tSmtDmweaNAwY1sxVOoOvnF8lyc8BcIhI3zKDVC
	 reF3kId2G3dGklWCMFWpcgWr/TZYQWz7IFIs5NPw6GQXc0Vl26xjdHWk7F0oy+UQgEl03
	 ElOD+JbbqkviuwWb8X0zLK8mV0NJlOkmyHJIO824D9ZifCNBbRnqQ1rUIWSuytufY5zSP
	 vdFqpuKOmszUa9TXnwDwXkxeiI+yzyDXFKRIMOD0VFlQk25oU+pTq3xJ2p4cWK1cp+F2o
	 uSnvNMKr5HZ41z5CwB95AHqqQR84ddfd+bfU+papXfKDrUUzjrVuEsJOreBmb5uXlYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c3yoq2lLnX1tuqcI4VYmLieyjhx8bidLgrub2PQm4h8=;
	b=FikXHBwO9QRO/du/dXu2mtproWBoImBiRefTMtuFkXejki2dCrb8EMad2PA+9rs5YziD
	 ixTcOJDjgiBwGtU3bUP2bSvXhMO7I8w0afiWobaie8MnNA2e6Rbujzhmve66RcdzvfZ+E
	 ORmG/xEC+fWFVUOCTG/9OX7D+K05qF46d2A8LGChHUhYw303niaLpFX3xF0sOX8ug5kt7
	 0kAtQTrLXv+vd6Nv7+kFa48G0qnJnowMzpgptlFwh+aZOUymXTYahtN/gd66BSBai62KP
	 /Ey2HXIqzXum3m0SWusHJxkByET7ikPTCMPsuEod5d2BFDUIazLOCybuddvcdsbpyTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0psvEF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1150606A322;
	Wed, 28 Oct 2026 17:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0psvEF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9AA1F01828;
	Wed, 28 Oct 2026 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207957;
	bh=c3yoq2lLnX1tuqcI4VYmLieyjhx8bidLgrub2PQm4h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0psvEF7ZVx1J8G3ndMGW/ti0lc/0Rt99HKghW3mfxOFBYTn1xqZrumeFrM60k8c7
	 ZUmk6NyJpgO3W4QQfMsOWnbfvS9ofA/vBuCI9tgHctluXdoqRn3NA33hoZkBVZ2YLs
	 ZTS6L4U0z3d4RRSIQBNHb2+RKRy42mo+PCBPjl8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 6.12 199/247] io_uring/io-wq: dont strand work when a worker exits
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028165952.131726691@linuxfoundation.org>
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

[ 6.12: ->nr_workers and the free list are under wq->lock, there is no
  acct->workers_lock ]
Fixes: 38aa434ab933 ("io_uring/io-wq: add exit-on-idle state")
Fixes: 05c5f4ee4da7 ("io-wq: get rid of FIXED worker flag")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-11-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -647,6 +647,37 @@ static void io_worker_handle_work(struct
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
+	struct io_wq *wq = worker->wq;
+
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
@@ -680,9 +711,14 @@ static int io_wq_worker(void *data)
 		 */
 		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
+			if (test_and_clear_bit(IO_WORKER_F_FREE, &worker->flags))
+				hlist_nulls_del_init_rcu(&worker->nulls_node);
 			raw_spin_unlock(&wq->lock);
 			__set_current_state(TASK_RUNNING);
-			break;
+			if (io_worker_retire(acct, worker))
+				break;
+			last_timeout = false;
+			continue;
 		}
 		last_timeout = false;
 		__io_worker_idle(wq, worker);


