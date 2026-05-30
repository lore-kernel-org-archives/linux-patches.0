Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33C521ADC7;
	Sat, 30 May 2026 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165534; cv=none; b=pSd1Ykuv3ujl0mKQ9glTIWiMgI0woHMBsWMln9AABt+3TeE6HJeTB/bw6WGHgnwEj4c6u+7W+H2Fp5FFwZutBco03o80PtfqlS0ze/j9+Z/bDp0t8UCJzqpIXwbYV5PQlKsivky7/bprseze0q7ikHjj0gqz+NnlPKLX4OoGwL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165534; c=relaxed/simple;
	bh=2VaKEX/p/vhpHTXn7Dz/RzBNtTWy7ptm3UNWLY5N7ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8xL3uR/W0xBAPrNVUMUEiZJOCVWeepYykS6pT8akqfvSxfc012baqbOF35CFOs6JbwMhpWAARWaooZCOR6iox7IbGDyMnE7Ucn3vwtBhQ/PkC/Av6aPv7LJFgA3fagNlDrJdEXZPi1o4IGvbyURB/P385IQr41cmQPc3QNKSqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Urm6/xbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Urm6/xbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AB1F00893;
	Sat, 30 May 2026 18:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165532;
	bh=suoku9vRYHli+cd5Iicd/yI8fAXUCGlfoDXeNOAJJcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Urm6/xbdk3yUAqRvKuPJyXaZ0cUw5VTaO5TvCDotk+IMPQKZGLRF2qAf4F6NsEInV
	 mPwJ375NI3ucrfm9W0NrvfSlzv4LsOCnAzIFHrST3G6P7MobPL8CJa1Y44QLvHb1/W
	 wTj+JXJz3iUjXXPWG+h4KYuBJ+Mz/Q8ZiRZEYxFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Subject: [PATCH 5.10 107/589] blk-mq: use quiesced elevator switch when reinitializing queues
Date: Sat, 30 May 2026 17:59:48 +0200
Message-ID: <20260530160227.559296606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 8237c01f1696bc53c470493bf1fe092a107648a6 ]

The hctx's run_work may be racing with the elevator switch when
reinitializing hardware queues. The queue is merely frozen in this
context, but that only prevents requests from allocating and doesn't
stop the hctx work from running. The work may get an elevator pointer
that's being torn down, and can result in use-after-free errors and
kernel panics (example below). Use the quiesced elevator switch instead,
and make the previous one static since it is now only used locally.

  nvme nvme0: resetting controller
  nvme nvme0: 32/0/0 default/read/poll queues
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 80000020c8861067 P4D 80000020c8861067 PUD 250f8c8067 PMD 0
  Oops: 0000 [#1] SMP PTI
  Workqueue: kblockd blk_mq_run_work_fn
  RIP: 0010:kyber_has_work+0x29/0x70

...

  Call Trace:
   __blk_mq_do_dispatch_sched+0x83/0x2b0
   __blk_mq_sched_dispatch_requests+0x12e/0x170
   blk_mq_sched_dispatch_requests+0x30/0x60
   __blk_mq_run_hw_queue+0x2b/0x50
   process_one_work+0x1ef/0x380
   worker_thread+0x2d/0x3e0

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220927155652.3260724-1-kbusch@fb.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Brennan Lamoreaux <brennan.lamoreaux@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c   |    6 +++---
 block/blk.h      |    3 +--
 block/elevator.c |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3689,14 +3689,14 @@ static bool blk_mq_elv_switch_none(struc
 
 	mutex_lock(&q->sysfs_lock);
 	/*
-	 * After elevator_switch_mq, the previous elevator_queue will be
+	 * After elevator_switch, the previous elevator_queue will be
 	 * released by elevator_release. The reference of the io scheduler
 	 * module get by elevator_get will also be put. So we need to get
 	 * a reference of the io scheduler module here to prevent it to be
 	 * removed.
 	 */
 	__module_get(qe->type->elevator_owner);
-	elevator_switch_mq(q, NULL);
+	elevator_switch(q, NULL);
 	mutex_unlock(&q->sysfs_lock);
 
 	return true;
@@ -3721,7 +3721,7 @@ static void blk_mq_elv_switch_back(struc
 	kfree(qe);
 
 	mutex_lock(&q->sysfs_lock);
-	elevator_switch_mq(q, t);
+	elevator_switch(q, t);
 	mutex_unlock(&q->sysfs_lock);
 }
 
--- a/block/blk.h
+++ b/block/blk.h
@@ -202,8 +202,7 @@ void blk_account_io_done(struct request
 void blk_insert_flush(struct request *rq);
 
 void elevator_init_mq(struct request_queue *q);
-int elevator_switch_mq(struct request_queue *q,
-			      struct elevator_type *new_e);
+int elevator_switch(struct request_queue *q, struct elevator_type *new_e);
 void __elevator_exit(struct request_queue *, struct elevator_queue *);
 int elv_register_queue(struct request_queue *q, bool uevent);
 void elv_unregister_queue(struct request_queue *q);
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -572,7 +572,7 @@ void elv_unregister(struct elevator_type
 }
 EXPORT_SYMBOL_GPL(elv_unregister);
 
-int elevator_switch_mq(struct request_queue *q,
+static int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e)
 {
 	int ret;
@@ -701,7 +701,7 @@ void elevator_init_mq(struct request_que
  * need for the new one. this way we have a chance of going back to the old
  * one, if the new one fails init for some reason.
  */
-static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
+int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 {
 	int err;
 


