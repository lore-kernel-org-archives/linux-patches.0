Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB25252287;
	Tue, 29 Apr 2025 17:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947509; cv=none; b=sed7JPXfEO9XhdaRZUC3R96oq8dWvx2SzwhX9dKiigL+TBAbIrdKZYGLJLDjgtH44QOHi9RiUZ9BXX4R1c4PXdAwkZZ5FG56cjzHNOnjeLCb/x8xfWyrdd9BmKtdegNe/uGMf0Eh7TF22hIB/TvagAxyuShi5U7ihgMye7/NZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947509; c=relaxed/simple;
	bh=50WEbXGLxLqoKRhCo9fW744wRv1IoIAMYOGREJJbBpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTUxRuds0a4CHMIB1eKuULhvTpkOR7XWNaNSO4+bPYF2V5zgLsm5NZX3qSl4vhlN7XnCQEfQRQg3NmQy2SH85CgqGta04dCO/ahlbAEwbFxQnxMt7G7UOMZy06oc+35hyfeN4WaD4UW8me0Zw1qTWmQyoqRJ9jgsXG9+PTl0K/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMDK4nGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMDK4nGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE414C4CEE9;
	Tue, 29 Apr 2025 17:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947509;
	bh=50WEbXGLxLqoKRhCo9fW744wRv1IoIAMYOGREJJbBpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMDK4nGdT+/+Dp3LzaUv99Mgpv4RhB/edhDZnPNF4hRgFcLJ8mmhUCzUC/aLJoFYX
	 /4CYzvZc4dwlKCxCv3rjXzlo6XNiAsYsqNhvWJCoOFUY0bKUmHBz+73xPMlGBgj5Io
	 lXuGk+Mik11awZ4zk1dMI1i2kFRPO9RFkrXS7oCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/280] block: remove the write_hint field from struct request
Date: Tue, 29 Apr 2025 18:39:18 +0200
Message-ID: <20250429161115.793746592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

[ Upstream commit 61952bb73486fff0f5550bccdf4062d9dd0fb163 ]

The write_hint is only used for read/write requests, which must have a
bio attached to them.  Just use the bio field instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241112170050.1612998-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: fc0e982b8a3a ("block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c      | 16 ++++++++++------
 block/blk-mq.c         |  2 --
 drivers/scsi/sd.c      |  6 +++---
 include/linux/blk-mq.h |  1 -
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index ceac64e796ea8..bc909bd894fae 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -864,9 +864,11 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (rq_data_dir(req) != rq_data_dir(next))
 		return NULL;
 
-	/* Don't merge requests with different write hints. */
-	if (req->write_hint != next->write_hint)
-		return NULL;
+	if (req->bio && next->bio) {
+		/* Don't merge requests with different write hints. */
+		if (req->bio->bi_write_hint != next->bio->bi_write_hint)
+			return NULL;
+	}
 
 	if (req->ioprio != next->ioprio)
 		return NULL;
@@ -998,9 +1000,11 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!bio_crypt_rq_ctx_compatible(rq, bio))
 		return false;
 
-	/* Don't merge requests with different write hints. */
-	if (rq->write_hint != bio->bi_write_hint)
-		return false;
+	if (rq->bio) {
+		/* Don't merge requests with different write hints. */
+		if (rq->bio->bi_write_hint != bio->bi_write_hint)
+			return false;
+	}
 
 	if (rq->ioprio != bio_prio(bio))
 		return false;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f26bee5626936..e3a0f521335bb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2654,7 +2654,6 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
 		rq->cmd_flags |= REQ_FAILFAST_MASK;
 
 	rq->__sector = bio->bi_iter.bi_sector;
-	rq->write_hint = bio->bi_write_hint;
 	blk_rq_bio_prep(rq, bio, nr_segs);
 	if (bio_integrity(bio))
 		rq->nr_integrity_segments = blk_rq_count_integrity_sg(rq->q,
@@ -3308,7 +3307,6 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->ioprio = rq_src->ioprio;
-	rq->write_hint = rq_src->write_hint;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca4bc0ac76adc..8947dab132d78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1190,8 +1190,8 @@ static u8 sd_group_number(struct scsi_cmnd *cmd)
 	if (!sdkp->rscs)
 		return 0;
 
-	return min3((u32)rq->write_hint, (u32)sdkp->permanent_stream_count,
-		    0x3fu);
+	return min3((u32)rq->bio->bi_write_hint,
+		    (u32)sdkp->permanent_stream_count, 0x3fu);
 }
 
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
@@ -1389,7 +1389,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua, dld);
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
-		   sdp->use_10_for_rw || protect || rq->write_hint) {
+		   sdp->use_10_for_rw || protect || rq->bio->bi_write_hint) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
 					 protect | fua);
 	} else {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 318245b4e38fb..07c3934080bad 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -156,7 +156,6 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
 
-	enum rw_hint write_hint;
 	unsigned short ioprio;
 
 	enum mq_rq_state state;
-- 
2.39.5



