Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECB02E7BBF;
	Thu,  3 Jul 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554921; cv=none; b=KaEStfrP2su4C/4fsmoss4hY4uv1iVbSWFhIWoNGPJVqjz4l/weJ0o7wiJfg14DFwG1DtB7iSNezlRW8ph9cG63NQjTmYeUkywKzYT/NaYTjBHsuPV18HI6YsqLwgy2U4+XBFAiGRRpAR5o3OeCwcKxFD8JLNblgjuMFs/JZvgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554921; c=relaxed/simple;
	bh=XxAmZt55gPmfnrazjVNtFd7MOuvFbxzK3w+9dSsOuCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkM4HPql39o8JDM3/BS76sn1J48vkkFtb202tM5zUU5tmX25PK0R+sIO9oMbdAn1+J5PWZiyl3hUO2wkxHoUrALp9ssDEdjiuljJGWm0wL8AFsdhm5FzI4GZwnuYzaj6wyScc4R+GKtG/kwW+PvBvqc+JeO3DFu9+JZ0cwi01y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY57X2ZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY57X2ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7A2C4CEE3;
	Thu,  3 Jul 2025 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554921;
	bh=XxAmZt55gPmfnrazjVNtFd7MOuvFbxzK3w+9dSsOuCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY57X2ZZ9PrNIFt+YXiHfpYyG1qTti5wD74i/uq05qrCYG/kvPofYW4ljNuox2jv8
	 n2hLSjmG9VEi6xBuTLi57N8UjXYG7Tk/sIpYcDyGkMeLol4PzZsyaY9+/YGZNpBkYR
	 Z8SBbCykzpqvPS4joPeM3YMmwFu4T+IjKjTaKvE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 093/263] io_uring/zcrx: split out memory holders from area
Date: Thu,  3 Jul 2025 16:40:13 +0200
Message-ID: <20250703144008.024903602@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 782dfa329ac9d1b5ca7b6df56a7696bac58cb829 ]

In the data path users of struct io_zcrx_area don't need to know what
kind of memory it's backed by. Only keep there generic bits in there and
and split out memory type dependent fields into a new structure. It also
logically separates the step that actually imports the memory, e.g.
pinning user pages, from the generic area initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b60fc09c76921bf69e77eb17e07eb4decedb3bf4.1746097431.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 0ec33c81d9c7 ("io_uring/zcrx: fix area release on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 71 ++++++++++++++++++++++++++++++++-----------------
 io_uring/zcrx.h | 11 ++++++--
 2 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0771a57d81a5b..7214236c14882 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,6 +26,8 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 {
 	return pp->mp_priv;
@@ -42,10 +44,43 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
-	return area->pages[net_iov_idx(niov)];
+	return area->mem.pages[net_iov_idx(niov)];
 }
 
-#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+static void io_release_area_mem(struct io_zcrx_mem *mem)
+{
+	if (mem->pages) {
+		unpin_user_pages(mem->pages, mem->nr_folios);
+		kvfree(mem->pages);
+	}
+}
+
+static int io_import_area(struct io_zcrx_ifq *ifq,
+			  struct io_zcrx_mem *mem,
+			  struct io_uring_zcrx_area_reg *area_reg)
+{
+	struct page **pages;
+	int nr_pages;
+	int ret;
+
+	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
+	if (ret)
+		return ret;
+	if (!area_reg->addr)
+		return -EFAULT;
+	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
+		return -EINVAL;
+
+	pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
+				   &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	mem->pages = pages;
+	mem->nr_folios = nr_pages;
+	mem->size = area_reg->len;
+	return 0;
+}
 
 static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 				 struct io_zcrx_area *area, int nr_mapped)
@@ -84,8 +119,8 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 		struct net_iov *niov = &area->nia.niovs[i];
 		dma_addr_t dma;
 
-		dma = dma_map_page_attrs(ifq->dev, area->pages[i], 0, PAGE_SIZE,
-					 DMA_FROM_DEVICE, IO_DMA_ATTR);
+		dma = dma_map_page_attrs(ifq->dev, area->mem.pages[i], 0,
+					 PAGE_SIZE, DMA_FROM_DEVICE, IO_DMA_ATTR);
 		if (dma_mapping_error(ifq->dev, dma))
 			break;
 		if (net_mp_niov_set_dma_addr(niov, dma)) {
@@ -188,14 +223,11 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
 	io_zcrx_unmap_area(area->ifq, area);
+	io_release_area_mem(&area->mem);
 
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
-	if (area->pages) {
-		unpin_user_pages(area->pages, area->nr_folios);
-		kvfree(area->pages);
-	}
 	kfree(area);
 }
 
@@ -204,36 +236,27 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct io_zcrx_area *area;
-	int i, ret, nr_pages, nr_iovs;
+	unsigned nr_iovs;
+	int i, ret;
 
 	if (area_reg->flags || area_reg->rq_area_token)
 		return -EINVAL;
 	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
 		return -EINVAL;
-	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
-		return -EINVAL;
-
-	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
-	if (ret)
-		return ret;
-	if (!area_reg->addr)
-		return -EFAULT;
 
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
 
-	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
-				   &nr_pages);
-	if (IS_ERR(area->pages)) {
-		ret = PTR_ERR(area->pages);
-		area->pages = NULL;
+	ret = io_import_area(ifq, &area->mem, area_reg);
+	if (ret)
 		goto err;
-	}
-	area->nr_folios = nr_iovs = nr_pages;
+
+	nr_iovs = area->mem.size >> PAGE_SHIFT;
 	area->nia.num_niovs = nr_iovs;
 
+	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
 					 GFP_KERNEL | __GFP_ZERO);
 	if (!area->nia.niovs)
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index f2bc811f022c6..64796c90851e1 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -7,6 +7,13 @@
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
+struct io_zcrx_mem {
+	unsigned long			size;
+
+	struct page			**pages;
+	unsigned long			nr_folios;
+};
+
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
@@ -14,13 +21,13 @@ struct io_zcrx_area {
 
 	bool			is_mapped;
 	u16			area_id;
-	struct page		**pages;
-	unsigned long		nr_folios;
 
 	/* freelist */
 	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
 	u32			free_count;
 	u32			*freelist;
+
+	struct io_zcrx_mem	mem;
 };
 
 struct io_zcrx_ifq {
-- 
2.39.5



