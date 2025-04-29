Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E561DF73C;
	Tue, 29 Apr 2025 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946516; cv=none; b=D3J15TNbjOAiQw0bH5ytddQGGhrTlP++86QtF1FDTun32pzDpgDnuYBk8JLEwnB2pWTbl/aZ14Hw8R3Iq28O1W/yYo5XuXwzlGZefyuJSc0ggNBKrRtvQqZl0kFq46Fwtrr5Z1Qex1kwHfeo24EwSfyMOIE1zIGrMi9tlG0M5S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946516; c=relaxed/simple;
	bh=WeCn5EdczkLJ8vkQCmrd5cznGiBxrZ74QYqFcGD/Jyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miB7Mvjk/IEq/rRPRnFQXRiRe7ITU5vskGX/9Yb7DnsBlC5bG3jjcJQeYK3mHEslb3m98tr0RDXCyAm5pAT4BHIB4okj/dJ53/o9v1o8BDmQpxeAYKcMhKrpGM4Hys8zLcEiDmDWI4FHeFxhFGeZ4iQZ+0eNghXErMjGQY9FF9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zleVXSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zleVXSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66524C4CEE3;
	Tue, 29 Apr 2025 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946515;
	bh=WeCn5EdczkLJ8vkQCmrd5cznGiBxrZ74QYqFcGD/Jyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zleVXSnHtxx3O5TbNYf+ct0bzcJ5kurfzY07wV6QF7efH06JEQZ7KoPE2f/v/85D
	 9ls7LKrVSsiQs5xt+B78CG2gedi629jYRGFrG0Hl0afOWO1PLoWUyLcPCd7kWhmZpW
	 IOXBQGvZoZ8EzvDvU66dwrhehucRLSqJ4TH6AUeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 293/311] ublk: add ublk_force_abort_dev()
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161133.001470287@linuxfoundation.org>
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

[ Upstream commit 00b3b0d7cb454d614117c93f33351cdcd20b5b93 ]

Add ublk_force_abort_dev() for handling ublk_nosrv_dev_should_queue_io()
in ublk_stop_dev(). Then queue quiesce and unquiesce can be paired in
single function.

Meantime not change device state to QUIESCED any more, since the disk is
going to be removed soon.

Reviewed-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250416035444.99569-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index c7761a5cfeec0..7bb7276f14c60 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1707,22 +1707,20 @@ static void __ublk_quiesce_dev(struct ublk_device *ub)
 	ub->dev_info.state = UBLK_S_DEV_QUIESCED;
 }
 
-static void ublk_unquiesce_dev(struct ublk_device *ub)
+static void ublk_force_abort_dev(struct ublk_device *ub)
 {
 	int i;
 
-	pr_devel("%s: unquiesce ub: dev_id %d state %s\n",
+	pr_devel("%s: force abort ub: dev_id %d state %s\n",
 			__func__, ub->dev_info.dev_id,
 			ub->dev_info.state == UBLK_S_DEV_LIVE ?
 			"LIVE" : "QUIESCED");
-	/* quiesce_work has run. We let requeued rqs be aborted
-	 * before running fallback_wq. "force_abort" must be seen
-	 * after request queue is unqiuesced. Then del_gendisk()
-	 * can move on.
-	 */
+	blk_mq_quiesce_queue(ub->ub_disk->queue);
+	if (ub->dev_info.state == UBLK_S_DEV_LIVE)
+		ublk_wait_tagset_rqs_idle(ub);
+
 	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
 		ublk_get_queue(ub, i)->force_abort = true;
-
 	blk_mq_unquiesce_queue(ub->ub_disk->queue);
 	/* We may have requeued some rqs in ublk_quiesce_queue() */
 	blk_mq_kick_requeue_list(ub->ub_disk->queue);
@@ -1750,11 +1748,8 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_DEAD)
 		goto unlock;
-	if (ublk_nosrv_dev_should_queue_io(ub)) {
-		if (ub->dev_info.state == UBLK_S_DEV_LIVE)
-			__ublk_quiesce_dev(ub);
-		ublk_unquiesce_dev(ub);
-	}
+	if (ublk_nosrv_dev_should_queue_io(ub))
+		ublk_force_abort_dev(ub);
 	del_gendisk(ub->ub_disk);
 	disk = ublk_detach_disk(ub);
 	put_disk(disk);
-- 
2.39.5



