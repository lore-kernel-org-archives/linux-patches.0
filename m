Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D014533C;
	Thu, 13 Jun 2024 12:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281012; cv=none; b=QlcV8Qo8+iJm2jVrKlrEofdNHivWGyjmt0DZ6Ddp0v9po5VcUbQyx5KE3TqsWXfhdQqEXIklDMt+4b6hpOfhVEBh2jQsgihdZpu4UcBJ9HTlecvnaUC86163P7nCN9gt2Zv8MmkCKknDmDOb5yT3XUFHOiFPJfJj9P973eeC+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281012; c=relaxed/simple;
	bh=4f971LrABPg0p7KYNkau4aUN2k9t5igad6SiE7Tg/zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL9vdF82gRrVyEztXiyma2pXEDsw+04APjuITe/NIi9L12CRmywszCEr/8qjzgL/gqGGf4cRHl7Xofd9llsl0KOaKi3xGm8x2X638/65AAnjzTomlZ5MrJ9Rrt9f5/p07OUE6VlTY7pjxN3jWPovzZPDpWyawDs7/3NwOVpV+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2WyjrFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2WyjrFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3B0C2BBFC;
	Thu, 13 Jun 2024 12:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281012;
	bh=4f971LrABPg0p7KYNkau4aUN2k9t5igad6SiE7Tg/zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2WyjrFFl749j32udP6RIMVotSoEjiAhD2VqUSMjPDX1EoW3hSqKgT6a1E9q8mOcO
	 6lKTLaORg+zg8PEuqclMgR9zboDeFejezI1MhTwysesR45MXZe2Q4/r1xj3+vvJhwm
	 TmBL73kGf9WksXGVC/JpTjwYWFuTtrE9JGoYdiZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Wang <wangxi11@huawei.com>,
	Weihang Li <liweihang@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/317] RDMA/hns: Refactor the hns_roce_buf allocation flow
Date: Thu, 13 Jun 2024 13:32:09 +0200
Message-ID: <20240613113251.844409154@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 6f6e2dcbb82b9b2ea304fe32635789fedd4e9868 ]

Add a group of flags to control the 'struct hns_roce_buf' allocation
flow, this is used to support the caller running in atomic context.

Link: https://lore.kernel.org/r/1605347916-15964-1-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 203b70fda634 ("RDMA/hns: Fix return value in hns_roce_map_mr_sg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_alloc.c  | 128 +++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_device.h |  51 ++++----
 drivers/infiniband/hw/hns/hns_roce_mr.c     |  39 ++----
 3 files changed, 113 insertions(+), 105 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
index 5b2baf89d1109..4bcaaa0524b12 100644
--- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
+++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
@@ -159,76 +159,96 @@ void hns_roce_bitmap_cleanup(struct hns_roce_bitmap *bitmap)
 
 void hns_roce_buf_free(struct hns_roce_dev *hr_dev, struct hns_roce_buf *buf)
 {
-	struct device *dev = hr_dev->dev;
-	u32 size = buf->size;
-	int i;
+	struct hns_roce_buf_list *trunks;
+	u32 i;
 
-	if (size == 0)
+	if (!buf)
 		return;
 
-	buf->size = 0;
+	trunks = buf->trunk_list;
+	if (trunks) {
+		buf->trunk_list = NULL;
+		for (i = 0; i < buf->ntrunks; i++)
+			dma_free_coherent(hr_dev->dev, 1 << buf->trunk_shift,
+					  trunks[i].buf, trunks[i].map);
 
-	if (hns_roce_buf_is_direct(buf)) {
-		dma_free_coherent(dev, size, buf->direct.buf, buf->direct.map);
-	} else {
-		for (i = 0; i < buf->npages; ++i)
-			if (buf->page_list[i].buf)
-				dma_free_coherent(dev, 1 << buf->page_shift,
-						  buf->page_list[i].buf,
-						  buf->page_list[i].map);
-		kfree(buf->page_list);
-		buf->page_list = NULL;
+		kfree(trunks);
 	}
+
+	kfree(buf);
 }
 
-int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
-		       struct hns_roce_buf *buf, u32 page_shift)
+/*
+ * Allocate the dma buffer for storing ROCEE table entries
+ *
+ * @size: required size
+ * @page_shift: the unit size in a continuous dma address range
+ * @flags: HNS_ROCE_BUF_ flags to control the allocation flow.
+ */
+struct hns_roce_buf *hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size,
+					u32 page_shift, u32 flags)
 {
-	struct hns_roce_buf_list *buf_list;
-	struct device *dev = hr_dev->dev;
-	u32 page_size;
-	int i;
+	u32 trunk_size, page_size, alloced_size;
+	struct hns_roce_buf_list *trunks;
+	struct hns_roce_buf *buf;
+	gfp_t gfp_flags;
+	u32 ntrunk, i;
 
 	/* The minimum shift of the page accessed by hw is HNS_HW_PAGE_SHIFT */
-	buf->page_shift = max_t(int, HNS_HW_PAGE_SHIFT, page_shift);
+	if (WARN_ON(page_shift < HNS_HW_PAGE_SHIFT))
+		return ERR_PTR(-EINVAL);
+
+	gfp_flags = (flags & HNS_ROCE_BUF_NOSLEEP) ? GFP_ATOMIC : GFP_KERNEL;
+	buf = kzalloc(sizeof(*buf), gfp_flags);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
 
+	buf->page_shift = page_shift;
 	page_size = 1 << buf->page_shift;
-	buf->npages = DIV_ROUND_UP(size, page_size);
-
-	/* required size is not bigger than one trunk size */
-	if (size <= max_direct) {
-		buf->page_list = NULL;
-		buf->direct.buf = dma_alloc_coherent(dev, size,
-						     &buf->direct.map,
-						     GFP_KERNEL);
-		if (!buf->direct.buf)
-			return -ENOMEM;
+
+	/* Calc the trunk size and num by required size and page_shift */
+	if (flags & HNS_ROCE_BUF_DIRECT) {
+		buf->trunk_shift = ilog2(ALIGN(size, PAGE_SIZE));
+		ntrunk = 1;
 	} else {
-		buf_list = kcalloc(buf->npages, sizeof(*buf_list), GFP_KERNEL);
-		if (!buf_list)
-			return -ENOMEM;
-
-		for (i = 0; i < buf->npages; i++) {
-			buf_list[i].buf = dma_alloc_coherent(dev, page_size,
-							     &buf_list[i].map,
-							     GFP_KERNEL);
-			if (!buf_list[i].buf)
-				break;
-		}
+		buf->trunk_shift = ilog2(ALIGN(page_size, PAGE_SIZE));
+		ntrunk = DIV_ROUND_UP(size, 1 << buf->trunk_shift);
+	}
 
-		if (i != buf->npages && i > 0) {
-			while (i-- > 0)
-				dma_free_coherent(dev, page_size,
-						  buf_list[i].buf,
-						  buf_list[i].map);
-			kfree(buf_list);
-			return -ENOMEM;
-		}
-		buf->page_list = buf_list;
+	trunks = kcalloc(ntrunk, sizeof(*trunks), gfp_flags);
+	if (!trunks) {
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
 	}
-	buf->size = size;
 
-	return 0;
+	trunk_size = 1 << buf->trunk_shift;
+	alloced_size = 0;
+	for (i = 0; i < ntrunk; i++) {
+		trunks[i].buf = dma_alloc_coherent(hr_dev->dev, trunk_size,
+						   &trunks[i].map, gfp_flags);
+		if (!trunks[i].buf)
+			break;
+
+		alloced_size += trunk_size;
+	}
+
+	buf->ntrunks = i;
+
+	/* In nofail mode, it's only failed when the alloced size is 0 */
+	if ((flags & HNS_ROCE_BUF_NOFAIL) ? i == 0 : i != ntrunk) {
+		for (i = 0; i < buf->ntrunks; i++)
+			dma_free_coherent(hr_dev->dev, trunk_size,
+					  trunks[i].buf, trunks[i].map);
+
+		kfree(trunks);
+		kfree(buf);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	buf->npages = DIV_ROUND_UP(alloced_size, page_size);
+	buf->trunk_list = trunks;
+
+	return buf;
 }
 
 int hns_roce_get_kmem_bufs(struct hns_roce_dev *hr_dev, dma_addr_t *bufs,
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 09b5e4935c2ca..e1f5b92596824 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -263,9 +263,6 @@ enum {
 #define HNS_HW_PAGE_SHIFT			12
 #define HNS_HW_PAGE_SIZE			(1 << HNS_HW_PAGE_SHIFT)
 
-/* The minimum page count for hardware access page directly. */
-#define HNS_HW_DIRECT_PAGE_COUNT 2
-
 struct hns_roce_uar {
 	u64		pfn;
 	unsigned long	index;
@@ -417,11 +414,26 @@ struct hns_roce_buf_list {
 	dma_addr_t	map;
 };
 
+/*
+ * %HNS_ROCE_BUF_DIRECT indicates that the all memory must be in a continuous
+ * dma address range.
+ *
+ * %HNS_ROCE_BUF_NOSLEEP indicates that the caller cannot sleep.
+ *
+ * %HNS_ROCE_BUF_NOFAIL allocation only failed when allocated size is zero, even
+ * the allocated size is smaller than the required size.
+ */
+enum {
+	HNS_ROCE_BUF_DIRECT = BIT(0),
+	HNS_ROCE_BUF_NOSLEEP = BIT(1),
+	HNS_ROCE_BUF_NOFAIL = BIT(2),
+};
+
 struct hns_roce_buf {
-	struct hns_roce_buf_list	direct;
-	struct hns_roce_buf_list	*page_list;
+	struct hns_roce_buf_list	*trunk_list;
+	u32				ntrunks;
 	u32				npages;
-	u32				size;
+	unsigned int			trunk_shift;
 	unsigned int			page_shift;
 };
 
@@ -1067,29 +1079,18 @@ static inline struct hns_roce_qp
 	return xa_load(&hr_dev->qp_table_xa, qpn & (hr_dev->caps.num_qps - 1));
 }
 
-static inline bool hns_roce_buf_is_direct(struct hns_roce_buf *buf)
-{
-	if (buf->page_list)
-		return false;
-
-	return true;
-}
-
 static inline void *hns_roce_buf_offset(struct hns_roce_buf *buf, int offset)
 {
-	if (hns_roce_buf_is_direct(buf))
-		return (char *)(buf->direct.buf) + (offset & (buf->size - 1));
-
-	return (char *)(buf->page_list[offset >> buf->page_shift].buf) +
-	       (offset & ((1 << buf->page_shift) - 1));
+	return (char *)(buf->trunk_list[offset >> buf->trunk_shift].buf) +
+			(offset & ((1 << buf->trunk_shift) - 1));
 }
 
 static inline dma_addr_t hns_roce_buf_page(struct hns_roce_buf *buf, int idx)
 {
-	if (hns_roce_buf_is_direct(buf))
-		return buf->direct.map + ((dma_addr_t)idx << buf->page_shift);
-	else
-		return buf->page_list[idx].map;
+	int offset = idx << buf->page_shift;
+
+	return buf->trunk_list[offset >> buf->trunk_shift].map +
+			(offset & ((1 << buf->trunk_shift) - 1));
 }
 
 #define hr_hw_page_align(x)		ALIGN(x, 1 << HNS_HW_PAGE_SHIFT)
@@ -1221,8 +1222,8 @@ int hns_roce_alloc_mw(struct ib_mw *mw, struct ib_udata *udata);
 int hns_roce_dealloc_mw(struct ib_mw *ibmw);
 
 void hns_roce_buf_free(struct hns_roce_dev *hr_dev, struct hns_roce_buf *buf);
-int hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size, u32 max_direct,
-		       struct hns_roce_buf *buf, u32 page_shift);
+struct hns_roce_buf *hns_roce_buf_alloc(struct hns_roce_dev *hr_dev, u32 size,
+					u32 page_shift, u32 flags);
 
 int hns_roce_get_kmem_bufs(struct hns_roce_dev *hr_dev, dma_addr_t *bufs,
 			   int buf_cnt, int start, struct hns_roce_buf *buf);
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index d5b3b10e0a807..13c7ac6ea3127 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -694,15 +694,6 @@ static inline size_t mtr_bufs_size(struct hns_roce_buf_attr *attr)
 	return size;
 }
 
-static inline size_t mtr_kmem_direct_size(bool is_direct, size_t alloc_size,
-					  unsigned int page_shift)
-{
-	if (is_direct)
-		return ALIGN(alloc_size, 1 << page_shift);
-	else
-		return HNS_HW_DIRECT_PAGE_COUNT << page_shift;
-}
-
 /*
  * check the given pages in continuous address space
  * Returns 0 on success, or the error page num.
@@ -731,7 +722,6 @@ static void mtr_free_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr)
 	/* release kernel buffers */
 	if (mtr->kmem) {
 		hns_roce_buf_free(hr_dev, mtr->kmem);
-		kfree(mtr->kmem);
 		mtr->kmem = NULL;
 	}
 }
@@ -743,13 +733,12 @@ static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	unsigned int best_pg_shift;
 	int all_pg_count = 0;
-	size_t direct_size;
 	size_t total_size;
 	int ret;
 
 	total_size = mtr_bufs_size(buf_attr);
 	if (total_size < 1) {
-		ibdev_err(ibdev, "Failed to check mtr size\n");
+		ibdev_err(ibdev, "failed to check mtr size\n.");
 		return -EINVAL;
 	}
 
@@ -761,7 +750,7 @@ static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		mtr->umem = ib_umem_get(ibdev, user_addr, total_size,
 					buf_attr->user_access);
 		if (IS_ERR_OR_NULL(mtr->umem)) {
-			ibdev_err(ibdev, "Failed to get umem, ret %ld\n",
+			ibdev_err(ibdev, "failed to get umem, ret = %ld.\n",
 				  PTR_ERR(mtr->umem));
 			return -ENOMEM;
 		}
@@ -779,19 +768,16 @@ static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		ret = 0;
 	} else {
 		mtr->umem = NULL;
-		mtr->kmem = kzalloc(sizeof(*mtr->kmem), GFP_KERNEL);
-		if (!mtr->kmem) {
-			ibdev_err(ibdev, "Failed to alloc kmem\n");
-			return -ENOMEM;
-		}
-		direct_size = mtr_kmem_direct_size(is_direct, total_size,
-						   buf_attr->page_shift);
-		ret = hns_roce_buf_alloc(hr_dev, total_size, direct_size,
-					 mtr->kmem, buf_attr->page_shift);
-		if (ret) {
-			ibdev_err(ibdev, "Failed to alloc kmem, ret %d\n", ret);
-			goto err_alloc_mem;
+		mtr->kmem =
+			hns_roce_buf_alloc(hr_dev, total_size,
+					   buf_attr->page_shift,
+					   is_direct ? HNS_ROCE_BUF_DIRECT : 0);
+		if (IS_ERR(mtr->kmem)) {
+			ibdev_err(ibdev, "failed to alloc kmem, ret = %ld.\n",
+				  PTR_ERR(mtr->kmem));
+			return PTR_ERR(mtr->kmem);
 		}
+
 		best_pg_shift = buf_attr->page_shift;
 		all_pg_count = mtr->kmem->npages;
 	}
@@ -799,7 +785,8 @@ static int mtr_alloc_bufs(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 	/* must bigger than minimum hardware page shift */
 	if (best_pg_shift < HNS_HW_PAGE_SHIFT || all_pg_count < 1) {
 		ret = -EINVAL;
-		ibdev_err(ibdev, "Failed to check mtr page shift %d count %d\n",
+		ibdev_err(ibdev,
+			  "failed to check mtr, page shift = %u count = %d.\n",
 			  best_pg_shift, all_pg_count);
 		goto err_alloc_mem;
 	}
-- 
2.43.0



