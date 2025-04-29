Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2357A221719;
	Tue, 29 Apr 2025 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946519; cv=none; b=ZHcyWcG8qPGxADaNbO1/3Gd1WQVFHdQ99PIXvc5MhMFMTDD51FdQDpORNJfIZa6KxtGZwvZRz8Ry+mA67pMme8EisdJNaL+RzXKd1D+ZkdBmBBfsc1vzUPh6TEXNjwS2YjgeFQ77BZQz6JDIGb2G6hj7MkS38w0p6Ktof6T6QAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946519; c=relaxed/simple;
	bh=mABsr2jFnajjjvwgJIwODDRBvrZI+fa9EHcpoqbEPV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqhGQ+F+RvMoY1k2ClwgGZrygFPCp0jN2w3an+PQvzJsW6nIG50E+fYi1KM0UZf7n2qWzwPWX+u1Q3Lng9bMo5zUdKFwfz0hUKhOvW4Wyx21ULTlod57D/DoIYT9erzibljtTt3dyWRZIbXVHVByitcai/9RRGPv8HuFCIyddS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLkhr6xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLkhr6xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E5C4CEE3;
	Tue, 29 Apr 2025 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946519;
	bh=mABsr2jFnajjjvwgJIwODDRBvrZI+fa9EHcpoqbEPV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLkhr6xptBzp39+9EzQZJht97MxHlEOxEKAYhOA1dhFXbEjLoHiAe8vQOinPcPosY
	 L+G831jsJqAoJ2plNIxI5BYZR/lyqMp3pDH6U9GVOoPS2JRDfhFDkDYcy1IUbWFefq
	 Vv0n7MdQp/qiDAuB1aqna1f9QUHhVFOb6iGkiP6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 294/311] ublk: rely on ->canceling for dealing with ublk_nosrv_dev_should_queue_io
Date: Tue, 29 Apr 2025 18:42:11 +0200
Message-ID: <20250429161133.041292136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 7e26cb69c5e62152a6f05a2ae23605a983a8ef31 ]

Now ublk deals with ublk_nosrv_dev_should_queue_io() by keeping request
queue as quiesced. This way is fragile because queue quiesce crosses syscalls
or process contexts.

Switch to rely on ubq->canceling for dealing with
ublk_nosrv_dev_should_queue_io(), because it has been used for this purpose
during io_uring context exiting, and it can be reused before recovering too.
In ublk_queue_rq(), the request will be added to requeue list without
kicking off requeue in case of ubq->canceling, and finally requests added in
requeue list will be dispatched from either ublk_stop_dev() or
ublk_ctrl_end_recovery().

Meantime we have to move reset of ubq->canceling from ublk_ctrl_start_recovery()
to ublk_ctrl_end_recovery(), when IO handling can be recovered completely.

Then blk_mq_quiesce_queue() and blk_mq_unquiesce_queue() are always used
in same context.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Uday Shankar <ushankar@purestorage.com>
Link: https://lore.kernel.org/r/20250416035444.99569-4-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 7bb7276f14c60..0efac33473c1e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1698,13 +1698,19 @@ static void ublk_wait_tagset_rqs_idle(struct ublk_device *ub)
 
 static void __ublk_quiesce_dev(struct ublk_device *ub)
 {
+	int i;
+
 	pr_devel("%s: quiesce ub: dev_id %d state %s\n",
 			__func__, ub->dev_info.dev_id,
 			ub->dev_info.state == UBLK_S_DEV_LIVE ?
 			"LIVE" : "QUIESCED");
 	blk_mq_quiesce_queue(ub->ub_disk->queue);
+	/* mark every queue as canceling */
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ublk_get_queue(ub, i)->canceling = true;
 	ublk_wait_tagset_rqs_idle(ub);
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
+	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 }
 
 static void ublk_force_abort_dev(struct ublk_device *ub)
@@ -2846,7 +2852,6 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 	/* We have to reset it to NULL, otherwise ub won't accept new FETCH_REQ */
 	ubq->ubq_daemon = NULL;
 	ubq->timeout = false;
-	ubq->canceling = false;
 
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
@@ -2935,20 +2940,18 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	pr_devel("%s: new ublksrv_pid %d, dev id %d\n",
 			__func__, ublksrv_pid, header->dev_id);
 
-	if (ublk_nosrv_dev_should_queue_io(ub)) {
-		ub->dev_info.state = UBLK_S_DEV_LIVE;
-		blk_mq_unquiesce_queue(ub->ub_disk->queue);
-		pr_devel("%s: queue unquiesced, dev id %d.\n",
-				__func__, header->dev_id);
-		blk_mq_kick_requeue_list(ub->ub_disk->queue);
-	} else {
-		blk_mq_quiesce_queue(ub->ub_disk->queue);
-		ub->dev_info.state = UBLK_S_DEV_LIVE;
-		for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-			ublk_get_queue(ub, i)->fail_io = false;
-		}
-		blk_mq_unquiesce_queue(ub->ub_disk->queue);
+	blk_mq_quiesce_queue(ub->ub_disk->queue);
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+
+		ubq->canceling = false;
+		ubq->fail_io = false;
 	}
+	blk_mq_unquiesce_queue(ub->ub_disk->queue);
+	pr_devel("%s: queue unquiesced, dev id %d.\n",
+			__func__, header->dev_id);
+	blk_mq_kick_requeue_list(ub->ub_disk->queue);
 
 	ret = 0;
  out_unlock:
-- 
2.39.5



