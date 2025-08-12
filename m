Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC396BB5B;
	Tue, 12 Aug 2025 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023225; cv=none; b=J0B8eDQG9TbrV+JJojO6mYPVpkK99u4TpdfETAao6zghrVI+hbJx+YCZ296Ajghrlpf9uI8lFflsitf9d+Y2w9SX/wmYSbMQUp+afDgAGYrkHX3l1FANgKYUb9TM25UJQCqXEnkp4ZRQ9fznUDM5hzXVi/suIOIln6z1eiIwGzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023225; c=relaxed/simple;
	bh=OTHj/cagT+7C2JhYR3zuxGZ8B/kBVaEVIUEBukv5BcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM1NS+tjbDre+NAHGj5c7HoCwrZfayE8qnCaCK3IxuOwe5+fDk28DdhhrK7kFmKptCxd/KvXMCsxDwJ1AaIUBr/LMrfmYC+Kfo5g8iiacYAL2tDQyiaVdfTjgBvsokOCxI+XlzeOrNY5d+/U6+KasllP/durGJWk/aoV7AOIzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfQpmiVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfQpmiVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C699C4CEF0;
	Tue, 12 Aug 2025 18:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023225;
	bh=OTHj/cagT+7C2JhYR3zuxGZ8B/kBVaEVIUEBukv5BcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfQpmiVZ++CtBMOCgREDur44Z/HhZ2YlgxhBiZ56owKmiWB+tbGpsV5GUWjSNWd5L
	 C+Hk/NDye8WQ8JLGROwwpCzAun23FkMttTpCMGtK7QoGLtNnEJf+oym7G57hrpfBHx
	 Jp+BI6iIgPt56VMFl6KHF9R3LQ4HybFfefozDVNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 018/627] ublk: speed up ublk server exit handling
Date: Tue, 12 Aug 2025 19:25:13 +0200
Message-ID: <20250812173420.013407083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 2fa9c93035e17380cafa897ee1a4d503881a3770 ]

Recently, we've observed a few cases where a ublk server is able to
complete restart more quickly than the driver can process the exit of
the previous ublk server. The new ublk server comes up, attempts
recovery of the preexisting ublk devices, and observes them still in
state UBLK_S_DEV_LIVE. While this is possible due to the asynchronous
nature of io_uring cleanup and should therefore be handled properly in
the ublk server, it is still preferable to make ublk server exit
handling faster if possible, as we should strive for it to not be a
limiting factor in how fast a ublk server can restart and provide
service again.

Analysis of the issue showed that the vast majority of the time spent in
handling the ublk server exit was in calls to blk_mq_quiesce_queue,
which is essentially just a (relatively expensive) call to
synchronize_rcu. The ublk server exit path currently issues an
unnecessarily large number of calls to blk_mq_quiesce_queue, for two
reasons:

1. It tries to call blk_mq_quiesce_queue once per ublk_queue. However,
   blk_mq_quiesce_queue targets the request_queue of the underlying ublk
   device, of which there is only one. So the number of calls is larger
   than necessary by a factor of nr_hw_queues.
2. In practice, it calls blk_mq_quiesce_queue _more_ than once per
   ublk_queue. This is because of a data race where we read
   ubq->canceling without any locking when deciding if we should call
   ublk_start_cancel. It is thus possible for two calls to
   ublk_uring_cmd_cancel_fn against the same ublk_queue to both call
   ublk_start_cancel against the same ublk_queue.

Fix this by making the "canceling" flag a per-device state. This
actually matches the existing code better, as there are several places
where the flag is set or cleared for all queues simultaneously, and
there is the general expectation that cancellation corresponds with ublk
server exit. This per-device canceling flag is then checked under a
(new) lock (addressing the data race (2) above), and the queue is only
quiesced if it is cleared (addressing (1) above). The result is just one
call to blk_mq_quiesce_queue per ublk device.

To minimize the number of cache lines that are accessed in the hot path,
the per-queue canceling flag is kept. The values of the per-device
canceling flag and all per-queue canceling flags should always match.

In our setup, where one ublk server handles I/O for 128 ublk devices,
each having 24 hardware queues of depth 4096, here are the results
before and after this patch, where teardown time is measured from the
first call to io_ring_ctx_wait_and_kill to the return from the last
ublk_ch_release:

						before		after
number of calls to blk_mq_quiesce_queue:	6469		256
teardown time:					11.14s		2.44s

There are still some potential optimizations here, but this takes care
of a big chunk of the ublk server exit handling delay.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250703-ublk_too_many_quiesce-v2-1-3527b5339eeb@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: c2c8089f325e ("ublk: validate ublk server pid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8ded49f3b68b..2492c11defcc 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -216,6 +216,8 @@ struct ublk_device {
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
 	unsigned int		nr_privileged_daemon;
+	struct mutex cancel_mutex;
+	bool canceling;
 };
 
 /* header of ublk_params */
@@ -1578,6 +1580,7 @@ static int ublk_ch_release(struct inode *inode, struct file *filp)
 	 * All requests may be inflight, so ->canceling may not be set, set
 	 * it now.
 	 */
+	ub->canceling = true;
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
@@ -1706,23 +1709,18 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 	}
 }
 
-/* Must be called when queue is frozen */
-static void ublk_mark_queue_canceling(struct ublk_queue *ubq)
-{
-	spin_lock(&ubq->cancel_lock);
-	if (!ubq->canceling)
-		ubq->canceling = true;
-	spin_unlock(&ubq->cancel_lock);
-}
-
-static void ublk_start_cancel(struct ublk_queue *ubq)
+static void ublk_start_cancel(struct ublk_device *ub)
 {
-	struct ublk_device *ub = ubq->dev;
 	struct gendisk *disk = ublk_get_disk(ub);
+	int i;
 
 	/* Our disk has been dead */
 	if (!disk)
 		return;
+
+	mutex_lock(&ub->cancel_mutex);
+	if (ub->canceling)
+		goto out;
 	/*
 	 * Now we are serialized with ublk_queue_rq()
 	 *
@@ -1731,8 +1729,12 @@ static void ublk_start_cancel(struct ublk_queue *ubq)
 	 * touch completed uring_cmd
 	 */
 	blk_mq_quiesce_queue(disk->queue);
-	ublk_mark_queue_canceling(ubq);
+	ub->canceling = true;
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ublk_get_queue(ub, i)->canceling = true;
 	blk_mq_unquiesce_queue(disk->queue);
+out:
+	mutex_unlock(&ub->cancel_mutex);
 	ublk_put_disk(disk);
 }
 
@@ -1805,8 +1807,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 	if (WARN_ON_ONCE(task && task != io->task))
 		return;
 
-	if (!ubq->canceling)
-		ublk_start_cancel(ubq);
+	ublk_start_cancel(ubq->dev);
 
 	WARN_ON_ONCE(io->cmd != cmd);
 	ublk_cancel_cmd(ubq, pdu->tag, issue_flags);
@@ -1933,6 +1934,7 @@ static void ublk_reset_io_flags(struct ublk_device *ub)
 		ubq->canceling = false;
 		ubq->fail_io = false;
 	}
+	ub->canceling = false;
 }
 
 /* device can only be started after all IOs are ready */
@@ -2580,6 +2582,7 @@ static void ublk_cdev_rel(struct device *dev)
 	ublk_deinit_queues(ub);
 	ublk_free_dev_number(ub);
 	mutex_destroy(&ub->mutex);
+	mutex_destroy(&ub->cancel_mutex);
 	kfree(ub);
 }
 
@@ -2933,6 +2936,7 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 		goto out_unlock;
 	mutex_init(&ub->mutex);
 	spin_lock_init(&ub->lock);
+	mutex_init(&ub->cancel_mutex);
 
 	ret = ublk_alloc_dev_number(ub, header->dev_id);
 	if (ret < 0)
@@ -3003,6 +3007,7 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	ublk_free_dev_number(ub);
 out_free_ub:
 	mutex_destroy(&ub->mutex);
+	mutex_destroy(&ub->cancel_mutex);
 	kfree(ub);
 out_unlock:
 	mutex_unlock(&ublk_ctl_mutex);
@@ -3357,8 +3362,9 @@ static int ublk_ctrl_quiesce_dev(struct ublk_device *ub,
 	if (ub->dev_info.state != UBLK_S_DEV_LIVE)
 		goto put_disk;
 
-	/* Mark all queues as canceling */
+	/* Mark the device as canceling */
 	blk_mq_quiesce_queue(disk->queue);
+	ub->canceling = true;
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
 		struct ublk_queue *ubq = ublk_get_queue(ub, i);
 
-- 
2.39.5



