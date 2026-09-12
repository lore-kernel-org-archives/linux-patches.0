Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050FC38B15B;
	Sat, 12 Sep 2026 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238388; cv=none; b=doy5jvE/5inYLjANBv3zW2vC0pbvKF4aqRkY4MEzsSQZRnVOG6saBHPN/pJoD4A1/5xytprOUTFwsRUejyRz042P0y9mvbMSbQXV0zBXgmVsfO/MgykeuLyP5LKMa9rODGBEVWqA6ovGzb6Tu5WHWOaQ7/GsHfzT7RhR8OhejI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238388; c=relaxed/simple;
	bh=3FT7lxnUE3s+3ARWtM+uuKqLRGDqxWdiXL+hy4UvcRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWY4dB4yp4zNlPojF++EJtYgpLDEKedaAXknZwxSDU9S8e+uLJO0IX4ZIZOcpwMau2aIftHf+tXn9AiuuINL2ork2HwSbvKUCLDmCdT67xyhl4Gy614EZGPYUz5n/0R8SZsZbkN2UYyO6gamxlfr/JGkh3lSfdInfPK/awPBmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFRmrEEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFRmrEEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBECF1F000FF;
	Sat, 12 Sep 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238384;
	bh=3wqx21AdqlDr59y2UwTl1rfd/HAF2J8dnZZRJC94f2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFRmrEEI8fl4vS7wpN4kTgwq5aT1dQZ5qhD19TO1f9k5yoWyImzld2POVZnosNfxx
	 LzrwXdB2TrPNmSVmT3BD+fYg7FSR7T5DamtNmyfBT9CT9VWruhcK2xrkeW3g6KOLEO
	 +b7L5wI4dNvuenbBFM8X9Maxv/I+FTIZzHEDP5B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/935] nvmet-rdma: use sbitmap to replace rsp free list
Date: Sat, 12 Sep 2026 08:57:54 +0200
Message-ID: <20260912065537.015783617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 40f0e5dc2f3c866bef3fccf398114b90c6136dfa ]

We can use sbitmap to manage all the nvmet_rdma_rsp instead of using
free lists and spinlock, and we can use an additional tag to
determine whether the nvmet_rdma_rsp is extra allocated.

In addition, performance has improved:
1. testing environment is local rxe rdma devie and mem-based
backstore device.
2. fio command, test the average 5 times:
fio -filename=/dev/nvme0n1 --ioengine=libaio -direct=1
-size=1G -name=1 -thread -runtime=60 -time_based -rw=read -numjobs=16
-iodepth=128 -bs=4k -group_reporting
3. Before: 241k IOPS, After: 256k IOPS, an increase of about 5%.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0114dd303b37 ("nvmet-rdma: fix response resource leak on queue teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 56 ++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index afdbe0506df5d..153008946087d 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -38,6 +38,8 @@
 
 #define NVMET_RDMA_BACKLOG 128
 
+#define NVMET_RDMA_DISCRETE_RSP_TAG		-1
+
 struct nvmet_rdma_srq;
 
 struct nvmet_rdma_cmd {
@@ -75,7 +77,7 @@ struct nvmet_rdma_rsp {
 	u32			invalidate_rkey;
 
 	struct list_head	wait_list;
-	struct list_head	free_list;
+	int			tag;
 };
 
 enum nvmet_rdma_queue_state {
@@ -98,8 +100,7 @@ struct nvmet_rdma_queue {
 	struct nvmet_sq		nvme_sq;
 
 	struct nvmet_rdma_rsp	*rsps;
-	struct list_head	free_rsps;
-	spinlock_t		rsps_lock;
+	struct sbitmap		rsp_tags;
 	struct nvmet_rdma_cmd	*cmds;
 
 	struct work_struct	release_work;
@@ -172,7 +173,8 @@ static void nvmet_rdma_queue_disconnect(struct nvmet_rdma_queue *queue);
 static void nvmet_rdma_free_rsp(struct nvmet_rdma_device *ndev,
 				struct nvmet_rdma_rsp *r);
 static int nvmet_rdma_alloc_rsp(struct nvmet_rdma_device *ndev,
-				struct nvmet_rdma_rsp *r);
+				struct nvmet_rdma_rsp *r,
+				int tag);
 
 static const struct nvmet_fabrics_ops nvmet_rdma_ops;
 
@@ -210,15 +212,12 @@ static inline bool nvmet_rdma_need_data_out(struct nvmet_rdma_rsp *rsp)
 static inline struct nvmet_rdma_rsp *
 nvmet_rdma_get_rsp(struct nvmet_rdma_queue *queue)
 {
-	struct nvmet_rdma_rsp *rsp;
-	unsigned long flags;
+	struct nvmet_rdma_rsp *rsp = NULL;
+	int tag;
 
-	spin_lock_irqsave(&queue->rsps_lock, flags);
-	rsp = list_first_entry_or_null(&queue->free_rsps,
-				struct nvmet_rdma_rsp, free_list);
-	if (likely(rsp))
-		list_del(&rsp->free_list);
-	spin_unlock_irqrestore(&queue->rsps_lock, flags);
+	tag = sbitmap_get(&queue->rsp_tags);
+	if (tag >= 0)
+		rsp = &queue->rsps[tag];
 
 	if (unlikely(!rsp)) {
 		int ret;
@@ -226,13 +225,12 @@ nvmet_rdma_get_rsp(struct nvmet_rdma_queue *queue)
 		rsp = kzalloc(sizeof(*rsp), GFP_KERNEL);
 		if (unlikely(!rsp))
 			return NULL;
-		ret = nvmet_rdma_alloc_rsp(queue->dev, rsp);
+		ret = nvmet_rdma_alloc_rsp(queue->dev, rsp,
+				NVMET_RDMA_DISCRETE_RSP_TAG);
 		if (unlikely(ret)) {
 			kfree(rsp);
 			return NULL;
 		}
-
-		rsp->allocated = true;
 	}
 
 	return rsp;
@@ -241,17 +239,13 @@ nvmet_rdma_get_rsp(struct nvmet_rdma_queue *queue)
 static inline void
 nvmet_rdma_put_rsp(struct nvmet_rdma_rsp *rsp)
 {
-	unsigned long flags;
-
-	if (unlikely(rsp->allocated)) {
+	if (unlikely(rsp->tag == NVMET_RDMA_DISCRETE_RSP_TAG)) {
 		nvmet_rdma_free_rsp(rsp->queue->dev, rsp);
 		kfree(rsp);
 		return;
 	}
 
-	spin_lock_irqsave(&rsp->queue->rsps_lock, flags);
-	list_add_tail(&rsp->free_list, &rsp->queue->free_rsps);
-	spin_unlock_irqrestore(&rsp->queue->rsps_lock, flags);
+	sbitmap_clear_bit(&rsp->queue->rsp_tags, rsp->tag);
 }
 
 static void nvmet_rdma_free_inline_pages(struct nvmet_rdma_device *ndev,
@@ -404,7 +398,7 @@ static void nvmet_rdma_free_cmds(struct nvmet_rdma_device *ndev,
 }
 
 static int nvmet_rdma_alloc_rsp(struct nvmet_rdma_device *ndev,
-		struct nvmet_rdma_rsp *r)
+		struct nvmet_rdma_rsp *r, int tag)
 {
 	/* NVMe CQE / RDMA SEND */
 	r->req.cqe = kmalloc(sizeof(*r->req.cqe), GFP_KERNEL);
@@ -432,6 +426,7 @@ static int nvmet_rdma_alloc_rsp(struct nvmet_rdma_device *ndev,
 	r->read_cqe.done = nvmet_rdma_read_data_done;
 	/* Data Out / RDMA WRITE */
 	r->write_cqe.done = nvmet_rdma_write_data_done;
+	r->tag = tag;
 
 	return 0;
 
@@ -454,21 +449,23 @@ nvmet_rdma_alloc_rsps(struct nvmet_rdma_queue *queue)
 {
 	struct nvmet_rdma_device *ndev = queue->dev;
 	int nr_rsps = queue->recv_queue_size * 2;
-	int ret = -EINVAL, i;
+	int ret = -ENOMEM, i;
+
+	if (sbitmap_init_node(&queue->rsp_tags, nr_rsps, -1, GFP_KERNEL,
+			NUMA_NO_NODE, false, true))
+		goto out;
 
 	queue->rsps = kcalloc(nr_rsps, sizeof(struct nvmet_rdma_rsp),
 			GFP_KERNEL);
 	if (!queue->rsps)
-		goto out;
+		goto out_free_sbitmap;
 
 	for (i = 0; i < nr_rsps; i++) {
 		struct nvmet_rdma_rsp *rsp = &queue->rsps[i];
 
-		ret = nvmet_rdma_alloc_rsp(ndev, rsp);
+		ret = nvmet_rdma_alloc_rsp(ndev, rsp, i);
 		if (ret)
 			goto out_free;
-
-		list_add_tail(&rsp->free_list, &queue->free_rsps);
 	}
 
 	return 0;
@@ -477,6 +474,8 @@ nvmet_rdma_alloc_rsps(struct nvmet_rdma_queue *queue)
 	while (--i >= 0)
 		nvmet_rdma_free_rsp(ndev, &queue->rsps[i]);
 	kfree(queue->rsps);
+out_free_sbitmap:
+	sbitmap_free(&queue->rsp_tags);
 out:
 	return ret;
 }
@@ -489,6 +488,7 @@ static void nvmet_rdma_free_rsps(struct nvmet_rdma_queue *queue)
 	for (i = 0; i < nr_rsps; i++)
 		nvmet_rdma_free_rsp(ndev, &queue->rsps[i]);
 	kfree(queue->rsps);
+	sbitmap_free(&queue->rsp_tags);
 }
 
 static int nvmet_rdma_post_recv(struct nvmet_rdma_device *ndev,
@@ -1463,8 +1463,6 @@ nvmet_rdma_alloc_queue(struct nvmet_rdma_device *ndev,
 	INIT_LIST_HEAD(&queue->rsp_wait_list);
 	INIT_LIST_HEAD(&queue->rsp_wr_wait_list);
 	spin_lock_init(&queue->rsp_wr_wait_lock);
-	INIT_LIST_HEAD(&queue->free_rsps);
-	spin_lock_init(&queue->rsps_lock);
 	INIT_LIST_HEAD(&queue->queue_list);
 
 	queue->idx = ida_simple_get(&nvmet_rdma_queue_ida, 0, 0, GFP_KERNEL);
-- 
2.53.0



