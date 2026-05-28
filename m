Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DB1DE4E0;
	Thu, 28 May 2026 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001005; cv=none; b=J/LCl+/2BEkWQ2kSxsTuooUpWzCi68kqyqobFY1gvIiIEZ/3PSBWIF0EnaXOMnW1wT230Ckm+P3SfRCIbxOnTdUXf4UUA1WkOBf5shi5lDKPXvxXj3v4Kw1+aciRK5So/MJndlbhmnAQVhYQFmlmUAw+oncHtrcdBb6BK6huoZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001005; c=relaxed/simple;
	bh=uuSsWvWVuTq0QLJTZK5JSR3nF6ujsejsKJfW17wTyRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6Cn6q8GeG3SxNDR1HE7OyYXoJonAx9AhfBDkgmGiBc2fzJI8+44vJREFSKL3UJEwa3RURgEBKvvhQ2OUmWEYzSGzIiF/WmBFKWOK6OkJpatU4kpx7VAFTGqPQ6DQUv1sgNNCdwt8l+Sz1Gzfc2MfYjM06+x2AtM8AN+Hm/hRR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Grrd1lH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Grrd1lH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A8E1F000E9;
	Thu, 28 May 2026 20:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001003;
	bh=b6+J6xP8y/1klnfRTa508fOvnlsrlFELi8FYaudVWgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Grrd1lH/uy6NazXPMz9q/yEgpafjDg38N6tVNPLEGswUnWjksiECzy3dgu5EGjYf9
	 f8YHRSAJo2NBgfumGZHdV6X45rKs+qcvUtIPqLnmym8lwmEPJhCCIcCB0wKuMV6AQf
	 J1DbUVNVdrN1lUPz/6qjDg7moAwN//Ql3rDxM4wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/272] blk-integrity: remove seed for user mapped buffers
Date: Thu, 28 May 2026 21:49:43 +0200
Message-ID: <20260528194635.081869396@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 133008e84b99e4f5f8cf3d8b768c995732df9406 ]

The seed is only used for kernel generation and verification. That
doesn't happen for user buffers, so passing the seed around doesn't
accomplish anything.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://lore.kernel.org/r/20241016201309.1090320-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 637ad3a56a3b ("block: don't overwrite bip_vcnt in bio_integrity_copy_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c         | 13 +++++--------
 block/blk-integrity.c         |  4 ++--
 drivers/nvme/host/ioctl.c     | 17 ++++++++---------
 include/linux/bio-integrity.h |  4 ++--
 include/linux/blk-integrity.h |  5 ++---
 5 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6641ecbf69678..ab58f44058e96 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -197,7 +197,7 @@ EXPORT_SYMBOL(bio_integrity_add_page);
 
 static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 				   int nr_vecs, unsigned int len,
-				   unsigned int direction, u32 seed)
+				   unsigned int direction)
 {
 	bool write = direction == ITER_SOURCE;
 	struct bio_integrity_payload *bip;
@@ -245,7 +245,6 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 	}
 
 	bip->bip_flags |= BIP_COPY_USER;
-	bip->bip_iter.bi_sector = seed;
 	bip->bip_vcnt = nr_vecs;
 	return 0;
 free_bip:
@@ -256,7 +255,7 @@ static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
 }
 
 static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
-				   int nr_vecs, unsigned int len, u32 seed)
+				   int nr_vecs, unsigned int len)
 {
 	struct bio_integrity_payload *bip;
 
@@ -265,7 +264,6 @@ static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
 		return PTR_ERR(bip);
 
 	memcpy(bip->bip_vec, bvec, nr_vecs * sizeof(*bvec));
-	bip->bip_iter.bi_sector = seed;
 	bip->bip_iter.bi_size = len;
 	bip->bip_vcnt = nr_vecs;
 	return 0;
@@ -301,8 +299,7 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 	return nr_bvecs;
 }
 
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
-			   u32 seed)
+int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
@@ -348,9 +345,9 @@ int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t bytes,
 
 	if (copy)
 		ret = bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes,
-					      direction, seed);
+					      direction);
 	else
-		ret = bio_integrity_init_user(bio, bvec, nr_bvecs, bytes, seed);
+		ret = bio_integrity_init_user(bio, bvec, nr_bvecs, bytes);
 	if (ret)
 		goto release_pages;
 	if (bvec != stack_vec)
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 3fe0681399f6e..013469faa5e7c 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -113,9 +113,9 @@ int blk_rq_map_integrity_sg(struct request *rq, struct scatterlist *sglist)
 EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 
 int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
-			      ssize_t bytes, u32 seed)
+			      ssize_t bytes)
 {
-	int ret = bio_integrity_map_user(rq->bio, ubuf, bytes, seed);
+	int ret = bio_integrity_map_user(rq->bio, ubuf, bytes);
 
 	if (ret)
 		return ret;
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 64ae8af01d9a4..930521c633d23 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -114,7 +114,7 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		u32 meta_seed, struct io_uring_cmd *ioucmd, unsigned int flags)
+		struct io_uring_cmd *ioucmd, unsigned int flags)
 {
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
@@ -164,8 +164,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		bio_set_dev(bio, bdev);
 
 	if (has_metadata) {
-		ret = blk_rq_integrity_map_user(req, meta_buffer, meta_len,
-						meta_seed);
+		ret = blk_rq_integrity_map_user(req, meta_buffer, meta_len);
 		if (ret)
 			goto out_unmap;
 	}
@@ -182,7 +181,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 
 static int nvme_submit_user_cmd(struct request_queue *q,
 		struct nvme_command *cmd, u64 ubuffer, unsigned bufflen,
-		void __user *meta_buffer, unsigned meta_len, u32 meta_seed,
+		void __user *meta_buffer, unsigned meta_len,
 		u64 *result, unsigned timeout, unsigned int flags)
 {
 	struct nvme_ns *ns = q->queuedata;
@@ -199,7 +198,7 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, meta_seed, NULL, flags);
+				meta_len, NULL, flags);
 		if (ret)
 			return ret;
 	}
@@ -280,7 +279,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	c.rw.lbatm = cpu_to_le16(io.appmask);
 
 	return nvme_submit_user_cmd(ns->queue, &c, io.addr, length, metadata,
-			meta_len, lower_32_bits(io.slba), NULL, 0, 0);
+			meta_len, NULL, 0, 0);
 }
 
 static bool nvme_validate_passthru_nsid(struct nvme_ctrl *ctrl,
@@ -334,7 +333,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			cmd.addr, cmd.data_len, nvme_to_user_ptr(cmd.metadata),
-			cmd.metadata_len, 0, &result, timeout, 0);
+			cmd.metadata_len, &result, timeout, 0);
 
 	if (status >= 0) {
 		if (put_user(result, &ucmd->result))
@@ -381,7 +380,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 
 	status = nvme_submit_user_cmd(ns ? ns->queue : ctrl->admin_q, &c,
 			cmd.addr, cmd.data_len, nvme_to_user_ptr(cmd.metadata),
-			cmd.metadata_len, 0, &cmd.result, timeout, flags);
+			cmd.metadata_len, &cmd.result, timeout, flags);
 
 	if (status >= 0) {
 		if (put_user(cmd.result, &ucmd->result))
@@ -511,7 +510,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (d.addr && d.data_len) {
 		ret = nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, 0, ioucmd, vec);
+			d.metadata_len, ioucmd, vec);
 		if (ret)
 			return ret;
 	}
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index dd831c269e994..dbf0f74c15291 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -72,7 +72,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
 		unsigned int offset);
-int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len, u32 seed);
+int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t len);
 void bio_integrity_unmap_user(struct bio *bio);
 bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
@@ -99,7 +99,7 @@ static inline void bioset_integrity_free(struct bio_set *bs)
 }
 
 static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
-					 ssize_t len, u32 seed)
+					 ssize_t len)
 {
 	return -EINVAL;
 }
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 676f8f860c474..c7eae0bfb013f 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -28,7 +28,7 @@ static inline bool queue_limits_stack_integrity_bdev(struct queue_limits *t,
 int blk_rq_map_integrity_sg(struct request *, struct scatterlist *);
 int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
 int blk_rq_integrity_map_user(struct request *rq, void __user *ubuf,
-			      ssize_t bytes, u32 seed);
+			      ssize_t bytes);
 
 static inline bool
 blk_integrity_queue_supports_integrity(struct request_queue *q)
@@ -104,8 +104,7 @@ static inline int blk_rq_map_integrity_sg(struct request *q,
 }
 static inline int blk_rq_integrity_map_user(struct request *rq,
 					    void __user *ubuf,
-					    ssize_t bytes,
-					    u32 seed)
+					    ssize_t bytes)
 {
 	return -EINVAL;
 }
-- 
2.53.0



