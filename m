Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEE61DF246;
	Thu, 17 Apr 2025 18:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915073; cv=none; b=SODm0nC7TP2XZFrEcwdxNS5lEe5eO58XwjE8gWQj3XW2JR6ZecvAA+JJZLaYZT98Ir2Dt2bHEFrCub9YpmwEiozpfrueHmMs83OJ6ruD2UWs4/e/xRd7p+haL+nadGp4LytSth90ZfrPeSkTFOm4YvdTRl1ME4UsE94jrPmXzFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915073; c=relaxed/simple;
	bh=9qDmeIVQf7rOqxZp5e+oqHlEpSJIUsy8XJEy0zhVon4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQrnbTiaa3C8Gdlu7yoYDopMJdqF6PGWCkZpTQn8R8+I7nxKQXJVHiKWLp9zJfiUUSFVesJ47VGEZ7JNI/iNQTFkFv6uJ+D6fGJbO9T8k2FZv/FTd8DggQ/Fv5UaBc1WvbXzAvSmxvhZ9OB1k6H/YKUk/5il2CaqOZE5Pk5Q/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPNIcvR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPNIcvR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A93C4CEE4;
	Thu, 17 Apr 2025 18:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915073;
	bh=9qDmeIVQf7rOqxZp5e+oqHlEpSJIUsy8XJEy0zhVon4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPNIcvR7WINNlKLSj9IzSdDjegZORqP2gqw3EPQCe11aYy1IAE6e2T3NXlqABvxPC
	 7+IcZLOKWNpDJneYhpCyKv6XsuHTaqtg/jEWtD4IzPegNSd9TMnV5tyNO/goFf4AD/
	 U2jAm9gqehWKBw7x7rrlC5ziWQoeDOyiembZZueE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/393] ublk: refactor recovery configuration flag helpers
Date: Thu, 17 Apr 2025 19:46:59 +0200
Message-ID: <20250417175107.992794917@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 3b939b8f715e014adcc48f7827fe9417252f0833 ]

ublk currently supports the following behaviors on ublk server exit:

A: outstanding I/Os get errors, subsequently issued I/Os get errors
B: outstanding I/Os get errors, subsequently issued I/Os queue
C: outstanding I/Os get reissued, subsequently issued I/Os queue

and the following behaviors for recovery of preexisting block devices by
a future incarnation of the ublk server:

1: ublk devices stopped on ublk server exit (no recovery possible)
2: ublk devices are recoverable using start/end_recovery commands

The userspace interface allows selection of combinations of these
behaviors using flags specified at device creation time, namely:

default behavior: A + 1
UBLK_F_USER_RECOVERY: B + 2
UBLK_F_USER_RECOVERY|UBLK_F_USER_RECOVERY_REISSUE: C + 2

We can't easily change the userspace interface to allow independent
selection of one of {A, B, C} and one of {1, 2}, but we can refactor the
internal helpers which test for the flags. Replace the existing helpers
with the following set:

ublk_nosrv_should_reissue_outstanding: tests for behavior C
ublk_nosrv_[dev_]should_queue_io: tests for behavior B
ublk_nosrv_should_stop_dev: tests for behavior 1

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241007182419.3263186-3-ushankar@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 6ee6bd5d4fce ("ublk: fix handling recovery & reissue in ublk_abort_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 62 +++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 79b7bd8bfd458..dd328d40c7de5 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -681,22 +681,44 @@ static int ublk_max_cmd_buf_size(void)
 	return __ublk_queue_cmd_buf_size(UBLK_MAX_QUEUE_DEPTH);
 }
 
-static inline bool ublk_queue_can_use_recovery_reissue(
-		struct ublk_queue *ubq)
+/*
+ * Should I/O outstanding to the ublk server when it exits be reissued?
+ * If not, outstanding I/O will get errors.
+ */
+static inline bool ublk_nosrv_should_reissue_outstanding(struct ublk_device *ub)
 {
-	return (ubq->flags & UBLK_F_USER_RECOVERY) &&
-			(ubq->flags & UBLK_F_USER_RECOVERY_REISSUE);
+	return (ub->dev_info.flags & UBLK_F_USER_RECOVERY) &&
+	       (ub->dev_info.flags & UBLK_F_USER_RECOVERY_REISSUE);
 }
 
-static inline bool ublk_queue_can_use_recovery(
-		struct ublk_queue *ubq)
+/*
+ * Should I/O issued while there is no ublk server queue? If not, I/O
+ * issued while there is no ublk server will get errors.
+ */
+static inline bool ublk_nosrv_dev_should_queue_io(struct ublk_device *ub)
+{
+	return ub->dev_info.flags & UBLK_F_USER_RECOVERY;
+}
+
+/*
+ * Same as ublk_nosrv_dev_should_queue_io, but uses a queue-local copy
+ * of the device flags for smaller cache footprint - better for fast
+ * paths.
+ */
+static inline bool ublk_nosrv_should_queue_io(struct ublk_queue *ubq)
 {
 	return ubq->flags & UBLK_F_USER_RECOVERY;
 }
 
-static inline bool ublk_can_use_recovery(struct ublk_device *ub)
+/*
+ * Should ublk devices be stopped (i.e. no recovery possible) when the
+ * ublk server exits? If not, devices can be used again by a future
+ * incarnation of a ublk server via the start_recovery/end_recovery
+ * commands.
+ */
+static inline bool ublk_nosrv_should_stop_dev(struct ublk_device *ub)
 {
-	return ub->dev_info.flags & UBLK_F_USER_RECOVERY;
+	return !(ub->dev_info.flags & UBLK_F_USER_RECOVERY);
 }
 
 static void ublk_free_disk(struct gendisk *disk)
@@ -1072,7 +1094,7 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 {
 	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
 
-	if (ublk_queue_can_use_recovery_reissue(ubq))
+	if (ublk_nosrv_should_reissue_outstanding(ubq->dev))
 		blk_mq_requeue_request(req, false);
 	else
 		ublk_put_req_ref(ubq, req);
@@ -1100,7 +1122,7 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 		struct request *rq)
 {
 	/* We cannot process this rq so just requeue it. */
-	if (ublk_queue_can_use_recovery(ubq))
+	if (ublk_nosrv_dev_should_queue_io(ubq->dev))
 		blk_mq_requeue_request(rq, false);
 	else
 		blk_mq_end_request(rq, BLK_STS_IOERR);
@@ -1245,10 +1267,10 @@ static enum blk_eh_timer_return ublk_timeout(struct request *rq)
 		struct ublk_device *ub = ubq->dev;
 
 		if (ublk_abort_requests(ub, ubq)) {
-			if (ublk_can_use_recovery(ub))
-				schedule_work(&ub->quiesce_work);
-			else
+			if (ublk_nosrv_should_stop_dev(ub))
 				schedule_work(&ub->stop_work);
+			else
+				schedule_work(&ub->quiesce_work);
 		}
 		return BLK_EH_DONE;
 	}
@@ -1277,7 +1299,7 @@ static blk_status_t ublk_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * Note: force_abort is guaranteed to be seen because it is set
 	 * before request queue is unqiuesced.
 	 */
-	if (ublk_queue_can_use_recovery(ubq) && unlikely(ubq->force_abort))
+	if (ublk_nosrv_should_queue_io(ubq) && unlikely(ubq->force_abort))
 		return BLK_STS_IOERR;
 
 	if (unlikely(ubq->canceling)) {
@@ -1517,10 +1539,10 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 	ublk_cancel_cmd(ubq, io, issue_flags);
 
 	if (need_schedule) {
-		if (ublk_can_use_recovery(ub))
-			schedule_work(&ub->quiesce_work);
-		else
+		if (ublk_nosrv_should_stop_dev(ub))
 			schedule_work(&ub->stop_work);
+		else
+			schedule_work(&ub->quiesce_work);
 	}
 }
 
@@ -1640,7 +1662,7 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
 		goto unlock;
-	if (ublk_can_use_recovery(ub)) {
+	if (ublk_nosrv_dev_should_queue_io(ub)) {
 		if (ub->dev_info.state == UBLK_S_DEV_LIVE)
 			__ublk_quiesce_dev(ub);
 		ublk_unquiesce_dev(ub);
@@ -2738,7 +2760,7 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 	int i;
 
 	mutex_lock(&ub->mutex);
-	if (!ublk_can_use_recovery(ub))
+	if (ublk_nosrv_should_stop_dev(ub))
 		goto out_unlock;
 	if (!ub->nr_queues_ready)
 		goto out_unlock;
@@ -2791,7 +2813,7 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 			__func__, ub->dev_info.nr_hw_queues, header->dev_id);
 
 	mutex_lock(&ub->mutex);
-	if (!ublk_can_use_recovery(ub))
+	if (ublk_nosrv_should_stop_dev(ub))
 		goto out_unlock;
 
 	if (ub->dev_info.state != UBLK_S_DEV_QUIESCED) {
-- 
2.39.5



