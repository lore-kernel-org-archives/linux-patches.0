Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A0D28689B;
	Tue, 26 Aug 2025 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208108; cv=none; b=q4dYYqEl4wrVpEUnTFvfTMD/SFHbe/gxhJksjjvETS+xtMAaavW1Fc5Xv1pIfIgwtqeTATLn17BEfU+X99CrdyfhaADMQnRxIo7jZrYI6NiQmtk+IuqcJpQn+Bykl4sc3je22DmoGPX2v29AUDvQbtA4zEtFd4S6/O62XM5VYEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208108; c=relaxed/simple;
	bh=6+4a8aorQbgOCpo2hLQRNOyYMSbPkTH2hqmQEKQzAik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUcYioFG7fFTYr/E3Al3gJayixp/Xyl0vAt30fI9JjFJg9k/7YWZ8ToX0UPCOChy8AdEx5vFNXQxBdH82wOrLxdkHEs8RIzdYDP648v1YoNH8lwr0gGoLZ91u4WUZIoFsQ1GiIWkoXd7n/Y8eVXH3pAMNHSfoVZ+SDjZbGRvuVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jJuhXcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jJuhXcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F05C4CEF1;
	Tue, 26 Aug 2025 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208108;
	bh=6+4a8aorQbgOCpo2hLQRNOyYMSbPkTH2hqmQEKQzAik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jJuhXcENPKxZ4Tqp0Nn334fAXSlJQ9lejGb//1jZlAaROli/9MAOOGngGjxeHFcj
	 Y5jFtJB05BpfQxLkKNzRBP8yJ7dppQl/XXZNMOxsNY3AzkMthvADzLIsLjhkYQI4ov
	 xwNEtUCGgIc1QbmzE/+AE4dgRZ+Cf6Y6rqxka28s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 440/457] block: move elevator queue allocation logic into blk_mq_init_sched
Date: Tue, 26 Aug 2025 13:12:04 +0200
Message-ID: <20250826110948.160012364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 49811586be373e26a3ab52f54e0dfa663c02fddd ]

In preparation for allocating sched_tags before freezing the request
queue and acquiring ->elevator_lock, move the elevator queue allocation
logic from the elevator ops ->init_sched callback into blk_mq_init_sched.
As elevator_alloc is now only invoked from block layer core, we don't
need to export it, so unexport elevator_alloc function.

This refactoring provides a centralized location for elevator queue
initialization, which makes it easier to store pre-allocated sched_tags
in the struct elevator_queue during later changes.

Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250730074614.2537382-2-nilay@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 2d82f3bd8910 ("blk-mq: fix lockdep warning in __blk_mq_update_nr_hw_queues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c   | 13 +++----------
 block/blk-mq-sched.c  | 11 ++++++++---
 block/elevator.c      |  1 -
 block/elevator.h      |  2 +-
 block/kyber-iosched.c | 11 ++---------
 block/mq-deadline.c   | 14 ++------------
 6 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d68da9e92e1e..9483c529c958 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7229,22 +7229,16 @@ static void bfq_init_root_group(struct bfq_group *root_group,
 	root_group->sched_data.bfq_class_idle_last_service = jiffies;
 }
 
-static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
+static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 {
 	struct bfq_data *bfqd;
-	struct elevator_queue *eq;
 	unsigned int i;
 	struct blk_independent_access_ranges *ia_ranges = q->disk->ia_ranges;
 
-	eq = elevator_alloc(q, e);
-	if (!eq)
-		return -ENOMEM;
-
 	bfqd = kzalloc_node(sizeof(*bfqd), GFP_KERNEL, q->node);
-	if (!bfqd) {
-		kobject_put(&eq->kobj);
+	if (!bfqd)
 		return -ENOMEM;
-	}
+
 	eq->elevator_data = bfqd;
 
 	spin_lock_irq(&q->queue_lock);
@@ -7402,7 +7396,6 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 
 out_free:
 	kfree(bfqd);
-	kobject_put(&eq->kobj);
 	return -ENOMEM;
 }
 
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 55a0fd105147..359e0704e09b 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -475,10 +475,14 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
 				   BLKDEV_DEFAULT_RQ);
 
+	eq = elevator_alloc(q, e);
+	if (!eq)
+		return -ENOMEM;
+
 	if (blk_mq_is_shared_tags(flags)) {
 		ret = blk_mq_init_sched_shared_tags(q);
 		if (ret)
-			return ret;
+			goto err_put_elevator;
 	}
 
 	queue_for_each_hw_ctx(q, hctx, i) {
@@ -487,7 +491,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 			goto err_free_map_and_rqs;
 	}
 
-	ret = e->ops.init_sched(q, e);
+	ret = e->ops.init_sched(q, eq);
 	if (ret)
 		goto err_free_map_and_rqs;
 
@@ -508,7 +512,8 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 err_free_map_and_rqs:
 	blk_mq_sched_free_rqs(q);
 	blk_mq_sched_tags_teardown(q, flags);
-
+err_put_elevator:
+	kobject_put(&eq->kobj);
 	q->elevator = NULL;
 	return ret;
 }
diff --git a/block/elevator.c b/block/elevator.c
index 88f8f36bed98..939b0c590fbe 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -148,7 +148,6 @@ struct elevator_queue *elevator_alloc(struct request_queue *q,
 
 	return eq;
 }
-EXPORT_SYMBOL(elevator_alloc);
 
 static void elevator_release(struct kobject *kobj)
 {
diff --git a/block/elevator.h b/block/elevator.h
index a07ce773a38f..a4de5f9ad790 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -24,7 +24,7 @@ struct blk_mq_alloc_data;
 struct blk_mq_hw_ctx;
 
 struct elevator_mq_ops {
-	int (*init_sched)(struct request_queue *, struct elevator_type *);
+	int (*init_sched)(struct request_queue *, struct elevator_queue *);
 	void (*exit_sched)(struct elevator_queue *);
 	int (*init_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*exit_hctx)(struct blk_mq_hw_ctx *, unsigned int);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index bfd9a40bb33d..70cbc7b2deb4 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -399,20 +399,13 @@ static struct kyber_queue_data *kyber_queue_data_alloc(struct request_queue *q)
 	return ERR_PTR(ret);
 }
 
-static int kyber_init_sched(struct request_queue *q, struct elevator_type *e)
+static int kyber_init_sched(struct request_queue *q, struct elevator_queue *eq)
 {
 	struct kyber_queue_data *kqd;
-	struct elevator_queue *eq;
-
-	eq = elevator_alloc(q, e);
-	if (!eq)
-		return -ENOMEM;
 
 	kqd = kyber_queue_data_alloc(q);
-	if (IS_ERR(kqd)) {
-		kobject_put(&eq->kobj);
+	if (IS_ERR(kqd))
 		return PTR_ERR(kqd);
-	}
 
 	blk_stat_enable_accounting(q);
 
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 9ab6c6256695..b9b7cdf1d3c9 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -554,20 +554,14 @@ static void dd_exit_sched(struct elevator_queue *e)
 /*
  * initialize elevator private data (deadline_data).
  */
-static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
+static int dd_init_sched(struct request_queue *q, struct elevator_queue *eq)
 {
 	struct deadline_data *dd;
-	struct elevator_queue *eq;
 	enum dd_prio prio;
-	int ret = -ENOMEM;
-
-	eq = elevator_alloc(q, e);
-	if (!eq)
-		return ret;
 
 	dd = kzalloc_node(sizeof(*dd), GFP_KERNEL, q->node);
 	if (!dd)
-		goto put_eq;
+		return -ENOMEM;
 
 	eq->elevator_data = dd;
 
@@ -594,10 +588,6 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
 
 	q->elevator = eq;
 	return 0;
-
-put_eq:
-	kobject_put(&eq->kobj);
-	return ret;
 }
 
 /*
-- 
2.50.1



