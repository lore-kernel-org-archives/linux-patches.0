Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DB2C1A5;
	Mon, 12 Aug 2024 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479354; cv=none; b=gpjfgTey7mZhhZHEtE8681pvkdWcQ8EPmwwwOMOTUTIrn+hRyZL1MoL/+oFnih7IyX08xAs2dSo5HiYhi03ynqlud5a76junxSlIH46SEgWDVyesafbaLtC7T4cbK5NaAlmQ3VmIJKfiTy7g2/SGheLJJWK0RMZ4WdQRIWyW9EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479354; c=relaxed/simple;
	bh=ZxF9DKxyIbey3Tn7Cwy68jgZhxGnHeqvHOC84e0gJ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/c6N2zY5/7CdFbdAggAPkcMn+g7THCJkGAg/CFjph+Y6Tx8Z/5/Ui/STleW2usL0ZxNSy9qE5Tl+MBm9lzfTTO8KDgCw4vvPtv04o+orlQ76HvHV7+2qu47Jkirvy0xdRR6LICEAH3kE2oN4Z387TutMzPMfQRPXRos6zjNZj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOxHrU6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOxHrU6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303ADC32782;
	Mon, 12 Aug 2024 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479353;
	bh=ZxF9DKxyIbey3Tn7Cwy68jgZhxGnHeqvHOC84e0gJ2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOxHrU6VjXPb/j5fAAlQ9I403G9F+ElEAshGO5D6vZ3wjU6mR9xJIn7LRK9gxjDSm
	 7XhgihjFjLHqV8MM1O1XX5Xitqup2tV7sVNA1M+bg6D4Nupd4v91cTyMQYudn9+Pzr
	 +RTTzIQOKGKwBxynDqMzEy7z+D76kj7sP8lPwsdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/189] block: change rq_integrity_vec to respect the iterator
Date: Mon, 12 Aug 2024 18:01:25 +0200
Message-ID: <20240812160133.267527543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit cf546dd289e0f6d2594c25e2fb4e19ee67c6d988 ]

If we allocate a bio that is larger than NVMe maximum request size,
attach integrity metadata to it and send it to the NVMe subsystem, the
integrity metadata will be corrupted.

Splitting the bio works correctly. The function bio_split will clone the
bio, trim the iterator of the first bio and advance the iterator of the
second bio.

However, the function rq_integrity_vec has a bug - it returns the first
vector of the bio's metadata and completely disregards the metadata
iterator that was advanced when the bio was split. Thus, the second bio
uses the same metadata as the first bio and this leads to metadata
corruption.

This commit changes rq_integrity_vec, so that it calls mp_bvec_iter_bvec
instead of returning the first vector. mp_bvec_iter_bvec reads the
iterator and uses it to build a bvec for the current position in the
iterator.

The "queue_max_integrity_segments(rq->q) > 1" check was removed, because
the updated rq_integrity_vec function works correctly with multiple
segments.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c       |  6 +++---
 include/linux/blk-integrity.h | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 796c2a00fea4a..0fc7aa78b2e5b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -826,9 +826,9 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = rq_integrity_vec(req);
 
-	iod->meta_dma = dma_map_bvec(dev->dev, rq_integrity_vec(req),
-			rq_dma_dir(req), 0);
+	iod->meta_dma = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
 	if (dma_mapping_error(dev->dev, iod->meta_dma))
 		return BLK_STS_IOERR;
 	cmnd->rw.metadata = cpu_to_le64(iod->meta_dma);
@@ -969,7 +969,7 @@ static __always_inline void nvme_pci_unmap_rq(struct request *req)
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
+			       rq_integrity_vec(req).bv_len, rq_dma_dir(req));
 	}
 
 	if (blk_rq_nr_phys_segments(req))
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 378b2459efe2d..69f73d0546118 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -105,14 +105,13 @@ static inline bool blk_integrity_rq(struct request *rq)
 }
 
 /*
- * Return the first bvec that contains integrity data.  Only drivers that are
- * limited to a single integrity segment should use this helper.
+ * Return the current bvec that contains the integrity data. bip_iter may be
+ * advanced to iterate over the integrity data.
  */
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
-		return NULL;
-	return rq->bio->bi_integrity->bip_vec;
+	return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
+				 rq->bio->bi_integrity->bip_iter);
 }
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 static inline int blk_rq_count_integrity_sg(struct request_queue *q,
@@ -178,7 +177,8 @@ static inline int blk_integrity_rq(struct request *rq)
 
 static inline struct bio_vec *rq_integrity_vec(struct request *rq)
 {
-	return NULL;
+	/* the optimizer will remove all calls to this function */
+	return (struct bio_vec){ };
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 #endif /* _LINUX_BLK_INTEGRITY_H */
-- 
2.43.0



