Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D7513C9C4;
	Wed,  5 Feb 2025 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763615; cv=none; b=ssOtmKaz98QTAn2yrC0EIb6IUSOkpN8BxF0uTrB9LLrMQ5q6+LiDRSyJD7X9lDfWOIngkISbLe3RAgIFrxHVBF0PFn+SYxEZm2rCbv4+yYEqxXOewpF7a520/uWbX3oD+g2EY8yn5GWwhQ+HNFB2t3fR/kIXyZk90IvtgQamQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763615; c=relaxed/simple;
	bh=M/SIpb9qqTq/ygcshybkd9iD+WiZDNc4NOEKxRnPPLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AieEWK6bWrNibhAb3OktwCgJeBKmJHBO0N0yxF1Que84VecZSfwHDkknaNlbUhPJAJwZMLpcYjIFe+cZ/PP7hXo9MRE8aEP7gsrBe8cIrS70CfTjZGDb3ZBqGZXuTYOpxrXtsQz0zwbPSFrnIRFAxbg6MjPS7htFfaw41075CN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5N/JDHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5N/JDHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5E7C4CED1;
	Wed,  5 Feb 2025 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763615;
	bh=M/SIpb9qqTq/ygcshybkd9iD+WiZDNc4NOEKxRnPPLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5N/JDHBbYHygWGDQhBXo54O2u9FNMhb9Z59WLkrJ4IYuGQHsdMrBF7/qPoxYAY09
	 GR/vUFwldWYYQ9W2/XdVVCzCUy6aDbb+eIDOzlTxsuvR/9hBzlm/kqWHDBKMuwQFyb
	 WXj8B62KLhQkUPqvzz1vYcqEO22xvQvycDtfDURo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/590] block: check BLK_FEAT_POLL under q_usage_count
Date: Wed,  5 Feb 2025 14:36:09 +0100
Message-ID: <20250205134455.784746337@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 958148a6ac061a9a80a184ea678a5fa872d0c56f ]

Otherwise feature reconfiguration can race with I/O submission.

Also drop the bio_clear_polled in the error path, as the flag does not
matter for instant error completions, it is a left over from when we
allowed polled I/O to proceed unpolled in this case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250110054726.1499538-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d432c817c21a ("block: don't update BLK_FEAT_POLL in __blk_mq_update_nr_hw_queues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 22 ++++++++++++----------
 block/blk-mq.c   | 12 ++++++++++--
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4f791a3114a12..487e8cafccc55 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -629,8 +629,14 @@ static void __submit_bio(struct bio *bio)
 		blk_mq_submit_bio(bio);
 	} else if (likely(bio_queue_enter(bio) == 0)) {
 		struct gendisk *disk = bio->bi_bdev->bd_disk;
-
-		disk->fops->submit_bio(bio);
+	
+		if ((bio->bi_opf & REQ_POLLED) &&
+		    !(disk->queue->limits.features & BLK_FEAT_POLL)) {
+			bio->bi_status = BLK_STS_NOTSUPP;
+			bio_endio(bio);
+		} else {
+			disk->fops->submit_bio(bio);
+		}
 		blk_queue_exit(disk->queue);
 	}
 
@@ -805,12 +811,6 @@ void submit_bio_noacct(struct bio *bio)
 		}
 	}
 
-	if (!(q->limits.features & BLK_FEAT_POLL) &&
-			(bio->bi_opf & REQ_POLLED)) {
-		bio_clear_polled(bio);
-		goto not_supported;
-	}
-
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 		break;
@@ -935,7 +935,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 		return 0;
 
 	q = bdev_get_queue(bdev);
-	if (cookie == BLK_QC_T_NONE || !(q->limits.features & BLK_FEAT_POLL))
+	if (cookie == BLK_QC_T_NONE)
 		return 0;
 
 	blk_flush_plug(current->plug, false);
@@ -951,7 +951,9 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 	 */
 	if (!percpu_ref_tryget(&q->q_usage_counter))
 		return 0;
-	if (queue_is_mq(q)) {
+	if (!(q->limits.features & BLK_FEAT_POLL)) {
+		ret = 0;
+	} else if (queue_is_mq(q)) {
 		ret = blk_mq_poll(q, cookie, iob, flags);
 	} else {
 		struct gendisk *disk = q->disk;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4e76651e786d1..784d41eb0abba 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3092,14 +3092,22 @@ void blk_mq_submit_bio(struct bio *bio)
 	}
 
 	/*
-	 * Device reconfiguration may change logical block size, so alignment
-	 * check has to be done with queue usage counter held
+	 * Device reconfiguration may change logical block size or reduce the
+	 * number of poll queues, so the checks for alignment and poll support
+	 * have to be done with queue usage counter held.
 	 */
 	if (unlikely(bio_unaligned(bio, q))) {
 		bio_io_error(bio);
 		goto queue_exit;
 	}
 
+	if ((bio->bi_opf & REQ_POLLED) &&
+	    !(q->limits.features & BLK_FEAT_POLL)) {
+		bio->bi_status = BLK_STS_NOTSUPP;
+		bio_endio(bio);
+		goto queue_exit;
+	}
+
 	bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
 	if (!bio)
 		goto queue_exit;
-- 
2.39.5



