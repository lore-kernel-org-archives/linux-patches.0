Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C2519DFD;
	Wed, 30 Sep 2026 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793034; cv=none; b=HAbtK9kYm/eW5J9QGnnI7r2dcu+FHBOSvZ6gYIh0SfDCWn/Sj38g1ni6X5aBvdW+hSXoaG26hmWXOjTXnZ9fK1emwH632bZ5PKfKZ+PfVxaMSNjlJ3heFrVXWvJmu3tvSv0ByM1ieykRxx+zt6VuGG6stkUln85cV9r2SMjIGUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793034; c=relaxed/simple;
	bh=7j0BsLvbk1gN5OOuukk6WsiFCUAlW7EWdFhogLgwy/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf5kGKq63Qisi6hMhAiRjGFI6EFedZTxPTAVWNGNljkO2noxlq6+Y/ya9lRytRWRdALlnwEMyIg12H3WsAvgFuG8Hb/UyV+AY610Omp2+wVhBc5F/TWhPLpN9yjJm0ZXiEoRI+aL0ajp+e7tLq84ZnHkfWJf7yEzB+RbaWiYU9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXmyitsE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXmyitsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05A51F000FF;
	Wed, 30 Sep 2026 18:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793033;
	bh=XQsTvcBx105e4bB2/7WpvGtS4oBcT7clBnJ8VXoAOVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXmyitsEyUabDciQjpp2NSowDlXELXrBpyfGsB53FjCgw5hyraCYDrpIwvXcC18K9
	 KYF+1TusXlJjhJPslOSTU05E/Sy3KsJSnqBR3lzATknNJMN8T7Z9Ic0iBPXJQSSrR9
	 e4+OTpDSNFGHgXQC8H8ZjD3nEPDnoLSTa9FfuHx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/395] octeontx2-af: Fix memory scaling limitation in SR-IOV mode
Date: Wed, 30 Sep 2026 17:26:13 +0200
Message-ID: <20260930152343.048913532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit d06f2ebf67ff2962fe00d687e4f0d4703eb41a12 ]

The original code used DMA_ATTR_FORCE_CONTIGUOUS, which could exhaust
the CMA pool when a large number of VFs were requested.

Fix this by switching to the DMA streaming API. This is equivalent on
Octeon platforms, which provide full I/O coherency via the SMMU.

Cc: Leon Romanovsky <leon@kernel.org>
Fixes: 73d33dbc0723 ("octeontx2-af: Use DMA_ATTR_FORCE_CONTIGUOUS attribute in DMA alloc")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Leon Romanovsky <leon@kernel.org>
Link: https://patch.msgid.link/20260916022111.1083017-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/common.h    | 45 ++++++++++++++++---
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 8a08bebf08c2c..e6c6e03c3f293 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -7,6 +7,10 @@
 #ifndef COMMON_H
 #define COMMON_H
 
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+
 #include "rvu_struct.h"
 
 #define OTX2_ALIGN			128  /* Align to cacheline */
@@ -44,6 +48,33 @@ struct qmem {
 	u32		qsize;
 };
 
+static inline void *otx2_dma_alloc_coherent(struct device *dev, size_t size,
+					    dma_addr_t *dma_handle)
+{
+	dma_addr_t dma_addr;
+	void *vaddr;
+
+	vaddr = kzalloc(size, GFP_KERNEL);
+	if (!vaddr)
+		return NULL;
+
+	dma_addr = dma_map_single(dev, vaddr, size, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, dma_addr)) {
+		kfree(vaddr);
+		return NULL;
+	}
+
+	*dma_handle = dma_addr;
+	return vaddr;
+}
+
+static inline void otx2_dma_free_coherent(struct device *dev, size_t size,
+					  void *vaddr, dma_addr_t dma_handle)
+{
+	dma_unmap_single(dev, dma_handle, size, DMA_BIDIRECTIONAL);
+	kfree(vaddr);
+}
+
 static inline int qmem_alloc(struct device *dev, struct qmem **q,
 			     int qsize, int entry_sz)
 {
@@ -60,8 +91,11 @@ static inline int qmem_alloc(struct device *dev, struct qmem **q,
 
 	qmem->entry_sz = entry_sz;
 	qmem->alloc_sz = (qsize * entry_sz) + OTX2_ALIGN;
-	qmem->base = dma_alloc_attrs(dev, qmem->alloc_sz, &qmem->iova,
-				     GFP_KERNEL, DMA_ATTR_FORCE_CONTIGUOUS);
+
+	if (get_order(PAGE_ALIGN(qmem->alloc_sz)) > MAX_PAGE_ORDER)
+		return -ENOMEM;
+
+	qmem->base = otx2_dma_alloc_coherent(dev, qmem->alloc_sz, &qmem->iova);
 	if (!qmem->base)
 		return -ENOMEM;
 
@@ -80,10 +114,9 @@ static inline void qmem_free(struct device *dev, struct qmem *qmem)
 		return;
 
 	if (qmem->base)
-		dma_free_attrs(dev, qmem->alloc_sz,
-			       qmem->base - qmem->align,
-			       qmem->iova - qmem->align,
-			       DMA_ATTR_FORCE_CONTIGUOUS);
+		otx2_dma_free_coherent(dev, qmem->alloc_sz,
+				       qmem->base - qmem->align,
+				       qmem->iova - qmem->align);
 	devm_kfree(dev, qmem);
 }
 
-- 
2.53.0



