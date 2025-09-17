Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7851B30CB51;
	Wed, 17 Sep 2025 12:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113263; cv=none; b=EJuheUayRyjJsz+2JDfVwMS56d6rck1OGv/NVfcbfWznOQuGlXj36Wxtl8Si3BsaPwoHu1ZSe/n0PGAAGz0JXGcoUNrwveoVGlncHCw7j4dxNd9FBeK/tM6PFcc3MKyxGRV8mXdzsNWsqNg6rZQoJBtOuT5AHqe7JsQBI5orzDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113263; c=relaxed/simple;
	bh=k4zUm1ho0xjaQKRmb1kWLYnppQtTtcksKWkGAlPBK2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GewIrKzVnHJxasCKGiUU6zZk4sCZg+V476Czhrld17BbF6e+DiZzPzRfZ0kNRGintEC0DuPj+stpeZzHYpI6HK34oQXDkXulidt3kqnJlzEnyfqDYHDDBfXasLSRpSrkd+kmZGhT1LcBVvxiD2kbNNnEKTaR2eeIXZF7Cs4gAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZ0gXbmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZ0gXbmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4E0C4CEF0;
	Wed, 17 Sep 2025 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113263;
	bh=k4zUm1ho0xjaQKRmb1kWLYnppQtTtcksKWkGAlPBK2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ0gXbmqvrQO8eIL3oCLUhmPWReMRdVahjNoPxOEIMB7IRHRvQ73iqIgSAks21Kfp
	 7Zyxp/NlEKrcOT5hB7qDCefSUeEYwkz1+ClWGXuotMasQcRuvVX62/wlGOe0TTYV4B
	 1ivKmMvP9ccHLZKtI2LulZZJ95RaaeqxzHWD2xUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/140] dma-debug: dont enforce dma mapping check on noncoherent allocations
Date: Wed, 17 Sep 2025 14:32:58 +0200
Message-ID: <20250917123344.473795889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 7e2368a21741e2db542330b32aa6fdd8908e7cff ]

As discussed in [1], there is no need to enforce dma mapping check on
noncoherent allocations, a simple test on the returned CPU address is
good enough.

Add a new pair of debug helpers and use them for noncoherent alloc/free
to fix this issue.

Fixes: efa70f2fdc84 ("dma-mapping: add a new dma_alloc_pages API")
Link: https://lore.kernel.org/all/ff6c1fe6-820f-4e58-8395-df06aa91706c@oss.qualcomm.com # 1
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250828-dma-debug-fix-noncoherent-dma-check-v1-1-76e9be0dd7fc@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c   | 48 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/dma/debug.h   | 20 ++++++++++++++++++
 kernel/dma/mapping.c |  4 ++--
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 4e3692afdf0d2..0221023e1120d 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -39,6 +39,7 @@ enum {
 	dma_debug_sg,
 	dma_debug_coherent,
 	dma_debug_resource,
+	dma_debug_noncoherent,
 };
 
 enum map_err_types {
@@ -141,6 +142,7 @@ static const char *type2name[] = {
 	[dma_debug_sg] = "scatter-gather",
 	[dma_debug_coherent] = "coherent",
 	[dma_debug_resource] = "resource",
+	[dma_debug_noncoherent] = "noncoherent",
 };
 
 static const char *dir2name[] = {
@@ -993,7 +995,8 @@ static void check_unmap(struct dma_debug_entry *ref)
 			   "[mapped as %s] [unmapped as %s]\n",
 			   ref->dev_addr, ref->size,
 			   type2name[entry->type], type2name[ref->type]);
-	} else if (entry->type == dma_debug_coherent &&
+	} else if ((entry->type == dma_debug_coherent ||
+		    entry->type == dma_debug_noncoherent) &&
 		   ref->paddr != entry->paddr) {
 		err_printk(ref->dev, entry, "device driver frees "
 			   "DMA memory with different CPU address "
@@ -1573,6 +1576,49 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	}
 }
 
+void debug_dma_alloc_pages(struct device *dev, struct page *page,
+			   size_t size, int direction,
+			   dma_addr_t dma_addr,
+			   unsigned long attrs)
+{
+	struct dma_debug_entry *entry;
+
+	if (unlikely(dma_debug_disabled()))
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->type      = dma_debug_noncoherent;
+	entry->dev       = dev;
+	entry->paddr	 = page_to_phys(page);
+	entry->size      = size;
+	entry->dev_addr  = dma_addr;
+	entry->direction = direction;
+
+	add_dma_entry(entry, attrs);
+}
+
+void debug_dma_free_pages(struct device *dev, struct page *page,
+			  size_t size, int direction,
+			  dma_addr_t dma_addr)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_noncoherent,
+		.dev            = dev,
+		.paddr		= page_to_phys(page),
+		.dev_addr       = dma_addr,
+		.size           = size,
+		.direction      = direction,
+	};
+
+	if (unlikely(dma_debug_disabled()))
+		return;
+
+	check_unmap(&ref);
+}
+
 static int __init dma_debug_driver_setup(char *str)
 {
 	int i;
diff --git a/kernel/dma/debug.h b/kernel/dma/debug.h
index f525197d3cae6..48757ca13f314 100644
--- a/kernel/dma/debug.h
+++ b/kernel/dma/debug.h
@@ -54,6 +54,13 @@ extern void debug_dma_sync_sg_for_cpu(struct device *dev,
 extern void debug_dma_sync_sg_for_device(struct device *dev,
 					 struct scatterlist *sg,
 					 int nelems, int direction);
+extern void debug_dma_alloc_pages(struct device *dev, struct page *page,
+				  size_t size, int direction,
+				  dma_addr_t dma_addr,
+				  unsigned long attrs);
+extern void debug_dma_free_pages(struct device *dev, struct page *page,
+				 size_t size, int direction,
+				 dma_addr_t dma_addr);
 #else /* CONFIG_DMA_API_DEBUG */
 static inline void debug_dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
@@ -126,5 +133,18 @@ static inline void debug_dma_sync_sg_for_device(struct device *dev,
 						int nelems, int direction)
 {
 }
+
+static inline void debug_dma_alloc_pages(struct device *dev, struct page *page,
+					 size_t size, int direction,
+					 dma_addr_t dma_addr,
+					 unsigned long attrs)
+{
+}
+
+static inline void debug_dma_free_pages(struct device *dev, struct page *page,
+					size_t size, int direction,
+					dma_addr_t dma_addr)
+{
+}
 #endif /* CONFIG_DMA_API_DEBUG */
 #endif /* _KERNEL_DMA_DEBUG_H */
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 32dcf8492bbcd..c12c62ad8a6bf 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -694,7 +694,7 @@ struct page *dma_alloc_pages(struct device *dev, size_t size,
 	if (page) {
 		trace_dma_alloc_pages(dev, page_to_virt(page), *dma_handle,
 				      size, dir, gfp, 0);
-		debug_dma_map_page(dev, page, 0, size, dir, *dma_handle, 0);
+		debug_dma_alloc_pages(dev, page, size, dir, *dma_handle, 0);
 	} else {
 		trace_dma_alloc_pages(dev, NULL, 0, size, dir, gfp, 0);
 	}
@@ -720,7 +720,7 @@ void dma_free_pages(struct device *dev, size_t size, struct page *page,
 		dma_addr_t dma_handle, enum dma_data_direction dir)
 {
 	trace_dma_free_pages(dev, page_to_virt(page), dma_handle, size, dir, 0);
-	debug_dma_unmap_page(dev, dma_handle, size, dir);
+	debug_dma_free_pages(dev, page, size, dir, dma_handle);
 	__dma_free_pages(dev, size, page, dma_handle, dir);
 }
 EXPORT_SYMBOL_GPL(dma_free_pages);
-- 
2.51.0



