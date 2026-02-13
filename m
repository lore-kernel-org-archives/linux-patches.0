Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD9554723;
	Fri, 13 Feb 2026 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990845; cv=none; b=HhjGMkbTWPVYsJNGmFANb+4JCDn1jN0PzNi9voPU971iYV4XA9ceUpxULBCUBtPVxAtDWH1KjfKqL+GqvO+xTCgS4hWCYnFn0PE/lCrMvDLOKfEKO7lXiBGIUDPRwgAaJ39g6Il3GZV5AFIFBLm+N6coZnU6HIZPc50UKQKFTA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990845; c=relaxed/simple;
	bh=3kdp0DUNKoy86GPX6z4SIZa9gb/WWJiU/quqzXZBa+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kICEmRRF6adwv6qbhXcLQUy0J2emkMWEEy/poHuESve7TH3Yl95shKTMtdSzd99hlDasrOWAPERqkYJLm0ak+wYMdAzNpQyMf48RudizJduEluo61ZX8aS7ejfIpYrCLmOxaWQtavXDvC2keJMHJkkZm5+H8s1b2t7RE+c8+FgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhoRd0kB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhoRd0kB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857F3C116C6;
	Fri, 13 Feb 2026 13:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990845;
	bh=3kdp0DUNKoy86GPX6z4SIZa9gb/WWJiU/quqzXZBa+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhoRd0kBeYxOyqAV2Pjw9/KoglWUa7TgVGqu+IqMD1vUrtDqwLiEq4NYmt6EjhrDh
	 EteKlQc1suDJL7rGpyDQtos8SNlwfvPlGit3Xzt0nuq1EAZ1/DFHMi7F7q69bRSA75
	 rMulpN9FyKX/lmmfzhhQDnVAWyqLdHg6YXew/CHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 01/49] io_uring/io-wq: add exit-on-idle state
Date: Fri, 13 Feb 2026 14:47:45 +0100
Message-ID: <20260213134708.941424898@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

commit 38aa434ab9335ce2d178b7538cdf01d60b2014c3 upstream.

io-wq uses an idle timeout to shrink the pool, but keeps the last worker
around indefinitely to avoid churn.

For tasks that used io_uring for file I/O and then stop using io_uring,
this can leave an iou-wrk-* thread behind even after all io_uring
instances are gone. This is unnecessary overhead and also gets in the
way of process checkpoint/restore.

Add an exit-on-idle state that makes all io-wq workers exit as soon as
they become idle, and provide io_wq_set_exit_on_idle() to toggle it.

Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   27 +++++++++++++++++++++++++--
 io_uring/io-wq.h |    1 +
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -34,6 +34,7 @@ enum {
 
 enum {
 	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
+	IO_WQ_BIT_EXIT_ON_IDLE	= 1,	/* allow all workers to exit on idle */
 };
 
 enum {
@@ -706,9 +707,13 @@ static int io_wq_worker(void *data)
 		raw_spin_lock(&acct->workers_lock);
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
-		 * or if someone modified our affinity.
+		 * or if someone modified our affinity. If wq is marked
+		 * idle-exit, drop the worker as well. This is used to avoid
+		 * keeping io-wq workers around for tasks that no longer have
+		 * any active io_uring instances.
 		 */
-		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
+		if ((last_timeout && (exit_mask || acct->nr_workers > 1)) ||
+		    test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) {
 			acct->nr_workers--;
 			raw_spin_unlock(&acct->workers_lock);
 			__set_current_state(TASK_RUNNING);
@@ -965,6 +970,24 @@ static bool io_wq_worker_wake(struct io_
 	return false;
 }
 
+void io_wq_set_exit_on_idle(struct io_wq *wq, bool enable)
+{
+	if (!wq->task)
+		return;
+
+	if (!enable) {
+		clear_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state);
+		return;
+	}
+
+	if (test_and_set_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state))
+		return;
+
+	rcu_read_lock();
+	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
+	rcu_read_unlock();
+}
+
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -41,6 +41,7 @@ struct io_wq_data {
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
+void io_wq_set_exit_on_idle(struct io_wq *wq, bool enable);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);


