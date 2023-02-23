Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE382584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392FEC433D2;
	Thu, 23 Feb 2023 13:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157836;
	bh=WfbdT70j7rheTbmkI3AfHIqFza3o8quxThZjxDqqHBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELsPXa+EGBrV3rwCz+kz8hn+/0OgpeLZI4YQn8OJ/PQgDiTRc7de0l1rX79fVessT
	 3YVVF6yk1SN2ESxjBKJV5pgZEJ7JOcz1lJvUV2l2sCZilbgz4eLc+zcJbezaYePfkn
	 FwdOJX3wveQZEuAXpoIfmkW3iOBcUgFCD97ufgIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/18] scatterlist: add generic wrappers for iterating over sgtable objects
Date: Thu, 23 Feb 2023 14:06:47 +0100
Message-Id: <20230223130425.798370786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 709d6d73c756107fb8a292a9f957d630097425fa ]

struct sg_table is a common structure used for describing a memory
buffer. It consists of a scatterlist with memory pages and DMA addresses
(sgl entry), as well as the number of scatterlist entries: CPU pages
(orig_nents entry) and DMA mapped pages (nents entry).

It turned out that it was a common mistake to misuse nents and orig_nents
entries, calling the scatterlist iterating functions with a wrong number
of the entries.

To avoid such issues, lets introduce a common wrappers operating directly
on the struct sg_table objects, which take care of the proper use of
the nents and orig_nents entries.

While touching this, lets clarify some ambiguities in the comments for
the existing for_each helpers.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: d37c120b7312 ("drm/etnaviv: don't truncate physical page address")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/scatterlist.h | 50 ++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6eec50fb36c80..4f922afb607ac 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -151,6 +151,20 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 #define for_each_sg(sglist, sg, nr, __i)	\
 	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
 
+/*
+ * Loop over each sg element in the given sg_table object.
+ */
+#define for_each_sgtable_sg(sgt, sg, i)		\
+	for_each_sg(sgt->sgl, sg, sgt->orig_nents, i)
+
+/*
+ * Loop over each sg element in the given *DMA mapped* sg_table object.
+ * Please use sg_dma_address(sg) and sg_dma_len(sg) to extract DMA addresses
+ * of the each element.
+ */
+#define for_each_sgtable_dma_sg(sgt, sg, i)	\
+	for_each_sg(sgt->sgl, sg, sgt->nents, i)
+
 /**
  * sg_chain - Chain two sglists together
  * @prv:	First scatterlist
@@ -401,9 +415,10 @@ sg_page_iter_dma_address(struct sg_dma_page_iter *dma_iter)
  * @sglist:	sglist to iterate over
  * @piter:	page iterator to hold current page, sg, sg_pgoffset
  * @nents:	maximum number of sg entries to iterate over
- * @pgoffset:	starting page offset
+ * @pgoffset:	starting page offset (in pages)
  *
  * Callers may use sg_page_iter_page() to get each page pointer.
+ * In each loop it operates on PAGE_SIZE unit.
  */
 #define for_each_sg_page(sglist, piter, nents, pgoffset)		   \
 	for (__sg_page_iter_start((piter), (sglist), (nents), (pgoffset)); \
@@ -412,18 +427,47 @@ sg_page_iter_dma_address(struct sg_dma_page_iter *dma_iter)
 /**
  * for_each_sg_dma_page - iterate over the pages of the given sg list
  * @sglist:	sglist to iterate over
- * @dma_iter:	page iterator to hold current page
+ * @dma_iter:	DMA page iterator to hold current page
  * @dma_nents:	maximum number of sg entries to iterate over, this is the value
  *              returned from dma_map_sg
- * @pgoffset:	starting page offset
+ * @pgoffset:	starting page offset (in pages)
  *
  * Callers may use sg_page_iter_dma_address() to get each page's DMA address.
+ * In each loop it operates on PAGE_SIZE unit.
  */
 #define for_each_sg_dma_page(sglist, dma_iter, dma_nents, pgoffset)            \
 	for (__sg_page_iter_start(&(dma_iter)->base, sglist, dma_nents,        \
 				  pgoffset);                                   \
 	     __sg_page_iter_dma_next(dma_iter);)
 
+/**
+ * for_each_sgtable_page - iterate over all pages in the sg_table object
+ * @sgt:	sg_table object to iterate over
+ * @piter:	page iterator to hold current page
+ * @pgoffset:	starting page offset (in pages)
+ *
+ * Iterates over the all memory pages in the buffer described by
+ * a scatterlist stored in the given sg_table object.
+ * See also for_each_sg_page(). In each loop it operates on PAGE_SIZE unit.
+ */
+#define for_each_sgtable_page(sgt, piter, pgoffset)	\
+	for_each_sg_page(sgt->sgl, piter, sgt->orig_nents, pgoffset)
+
+/**
+ * for_each_sgtable_dma_page - iterate over the DMA mapped sg_table object
+ * @sgt:	sg_table object to iterate over
+ * @dma_iter:	DMA page iterator to hold current page
+ * @pgoffset:	starting page offset (in pages)
+ *
+ * Iterates over the all DMA mapped pages in the buffer described by
+ * a scatterlist stored in the given sg_table object.
+ * See also for_each_sg_dma_page(). In each loop it operates on PAGE_SIZE
+ * unit.
+ */
+#define for_each_sgtable_dma_page(sgt, dma_iter, pgoffset)	\
+	for_each_sg_dma_page(sgt->sgl, dma_iter, sgt->nents, pgoffset)
+
+
 /*
  * Mapping sg iterator
  *
-- 
2.39.0



