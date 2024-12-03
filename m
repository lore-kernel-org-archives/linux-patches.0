Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAFD1F890F;
	Tue,  3 Dec 2024 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242864; cv=none; b=VWhPiYolTcNdIE+EHKV3zYeo9BvVtgWWvQ8zRIs+ADKdOW3YZ2b5JDZS0qlBnENAtLsmEI930gjOdBgNvAjD2Z+5Zs9QV2ids0pzRU5BP3hacM2Sa3DxuDvlctyDgRe8vmW4/wFrCIkecDNBx7vZ2hbeahUmITnFZmjJhFMJ0dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242864; c=relaxed/simple;
	bh=s7Ltby4c0atloth4amTImZXmnuojwGJhLXkDHNePl/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meMMk3hXB6exz73royVsbE4WYwSvhEZdp0YuwDlKzDOmZw/7pCKmCe6and2sITfJ5Khr5BOfnX0oIWBtBtaBkdrYMD3cb1hKd14CnSgblF30m0oFH2ZVkmR9VnMsdF0YqIa0O2zAh6IGEVIMBC27i8sGQOOYMK7jNoIiRxMEZg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mePVtEbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mePVtEbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6330C4CECF;
	Tue,  3 Dec 2024 16:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242864;
	bh=s7Ltby4c0atloth4amTImZXmnuojwGJhLXkDHNePl/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mePVtEbcpDiOeIDEvFyIIHnvzW5L2S4hjH5MojGollKSic7KGa+tWQhK/MevLHbet
	 1/07msJRq9qkNetVnNBu/TtvFoNesJKSkolQEbxdQwSkUFGCagmkFfMLHn3CyZ5y6M
	 gDUVlgFwRzSo6VA44ANLyPKWy+xzsly7Ibse4EyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 825/826] block: always verify unfreeze lock on the owner task
Date: Tue,  3 Dec 2024 15:49:12 +0100
Message-ID: <20241203144815.935274788@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 6a78699838a0ddeed3620ddf50c1521f1fe1e811 upstream.

commit f1be1788a32e ("block: model freeze & enter queue as lock for
supporting lockdep") tries to apply lockdep for verifying freeze &
unfreeze. However, the verification is only done the outmost freeze and
unfreeze. This way is actually not correct because q->mq_freeze_depth
still may drop to zero on other task instead of the freeze owner task.

Fix this issue by always verifying the last unfreeze lock on the owner
task context, and make sure both the outmost freeze & unfreeze are
verified in the current task.

Fixes: f1be1788a32e ("block: model freeze & enter queue as lock for supporting lockdep")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241031133723.303835-4-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c       |    2 -
 block/blk-mq.c         |   62 ++++++++++++++++++++++++++++++++++++++++++-------
 block/blk.h            |    3 +-
 include/linux/blkdev.h |    4 +++
 4 files changed, 61 insertions(+), 10 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -287,7 +287,7 @@ bool blk_queue_start_drain(struct reques
 	 * entering queue, so we call blk_freeze_queue_start() to
 	 * prevent I/O from crossing blk_queue_enter().
 	 */
-	bool freeze = __blk_freeze_queue_start(q);
+	bool freeze = __blk_freeze_queue_start(q, current);
 	if (queue_is_mq(q))
 		blk_mq_wake_waiters(q);
 	/* Make blk_queue_enter() reexamine the DYING flag. */
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -120,20 +120,66 @@ void blk_mq_in_flight_rw(struct request_
 	inflight[1] = mi.inflight[1];
 }
 
-bool __blk_freeze_queue_start(struct request_queue *q)
+#ifdef CONFIG_LOCKDEP
+static bool blk_freeze_set_owner(struct request_queue *q,
+				 struct task_struct *owner)
 {
-	int freeze;
+	if (!owner)
+		return false;
+
+	if (!q->mq_freeze_depth) {
+		q->mq_freeze_owner = owner;
+		q->mq_freeze_owner_depth = 1;
+		return true;
+	}
+
+	if (owner == q->mq_freeze_owner)
+		q->mq_freeze_owner_depth += 1;
+	return false;
+}
+
+/* verify the last unfreeze in owner context */
+static bool blk_unfreeze_check_owner(struct request_queue *q)
+{
+	if (!q->mq_freeze_owner)
+		return false;
+	if (q->mq_freeze_owner != current)
+		return false;
+	if (--q->mq_freeze_owner_depth == 0) {
+		q->mq_freeze_owner = NULL;
+		return true;
+	}
+	return false;
+}
+
+#else
+
+static bool blk_freeze_set_owner(struct request_queue *q,
+				 struct task_struct *owner)
+{
+	return false;
+}
+
+static bool blk_unfreeze_check_owner(struct request_queue *q)
+{
+	return false;
+}
+#endif
+
+bool __blk_freeze_queue_start(struct request_queue *q,
+			      struct task_struct *owner)
+{
+	bool freeze;
 
 	mutex_lock(&q->mq_freeze_lock);
+	freeze = blk_freeze_set_owner(q, owner);
 	if (++q->mq_freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
 		mutex_unlock(&q->mq_freeze_lock);
 		if (queue_is_mq(q))
 			blk_mq_run_hw_queues(q, false);
-		freeze = true;
 	} else {
 		mutex_unlock(&q->mq_freeze_lock);
-		freeze = false;
 	}
 
 	return freeze;
@@ -141,7 +187,7 @@ bool __blk_freeze_queue_start(struct req
 
 void blk_freeze_queue_start(struct request_queue *q)
 {
-	if (__blk_freeze_queue_start(q))
+	if (__blk_freeze_queue_start(q, current))
 		blk_freeze_acquire_lock(q, false, false);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
@@ -190,7 +236,7 @@ EXPORT_SYMBOL_GPL(blk_mq_freeze_queue);
 
 bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 {
-	int unfreeze = false;
+	bool unfreeze;
 
 	mutex_lock(&q->mq_freeze_lock);
 	if (force_atomic)
@@ -200,8 +246,8 @@ bool __blk_mq_unfreeze_queue(struct requ
 	if (!q->mq_freeze_depth) {
 		percpu_ref_resurrect(&q->q_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
-		unfreeze = true;
 	}
+	unfreeze = blk_unfreeze_check_owner(q);
 	mutex_unlock(&q->mq_freeze_lock);
 
 	return unfreeze;
@@ -223,7 +269,7 @@ EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue)
  */
 void blk_freeze_queue_start_non_owner(struct request_queue *q)
 {
-	__blk_freeze_queue_start(q);
+	__blk_freeze_queue_start(q, NULL);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start_non_owner);
 
--- a/block/blk.h
+++ b/block/blk.h
@@ -38,7 +38,8 @@ void blk_free_flush_queue(struct blk_flu
 void blk_freeze_queue(struct request_queue *q);
 bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
 bool blk_queue_start_drain(struct request_queue *q);
-bool __blk_freeze_queue_start(struct request_queue *q);
+bool __blk_freeze_queue_start(struct request_queue *q,
+			      struct task_struct *owner);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 void submit_bio_noacct_nocheck(struct bio *bio);
 void bio_await_chain(struct bio *bio);
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -572,6 +572,10 @@ struct request_queue {
 	struct throtl_data *td;
 #endif
 	struct rcu_head		rcu_head;
+#ifdef CONFIG_LOCKDEP
+	struct task_struct	*mq_freeze_owner;
+	int			mq_freeze_owner_depth;
+#endif
 	wait_queue_head_t	mq_freeze_wq;
 	/*
 	 * Protect concurrent access to q_usage_counter by


