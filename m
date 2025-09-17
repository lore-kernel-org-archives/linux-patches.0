Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A026F36D;
	Wed, 17 Sep 2025 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112580; cv=none; b=bn6QF/njnQ1UPpMeb6MYbTOi9Ny1JwdCU7zg7x+1PWaXUgR+BVoFvtDEwbA28M00punRe5kjoMlL6F+ErCpSBEryjqkwjgHGM20CKXqjuymWhyvtiQkR3nFlT9eykjYsR1b6GGywCqUF+omAybU8p6BfsfQqZL6r1dVOOwNbM0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112580; c=relaxed/simple;
	bh=WMXfmWgDnjRe9OLkqWlRk3lLzQGHhGQzn5nZYY8DnEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhyqI/NU7u2rZ2HrsTEIuoGO//SuDgAyIruLH+3WjgGYZ1NJtbROxp62FYWL9MNDHuTBCB8yZxbAGJsiDBwM7nVwFHbOEGO4bANlmdSBocLcmtl1JOq2gvo8y3vA4VDPPsJhevoshtiO8jZl6JLQ7QRuuHzt+7eGs4CK9OIg6u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Ufm+PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Ufm+PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F08C4CEF0;
	Wed, 17 Sep 2025 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112580;
	bh=WMXfmWgDnjRe9OLkqWlRk3lLzQGHhGQzn5nZYY8DnEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Ufm+PRZKArKuCDVPHcFq8i4Z0gz5+0AKt1JEWJnvT0rwgatj2Tgkc+ceMAc0WFG
	 3gUV1yCFmYQ0paY4wva3ctta/9yRA54ZjcoOcHqw36Z2PtmJrOX1XUOUOLrjcokbXm
	 bCHQzQBHRKpiAXqaiiDcXhFjMly/arc6kMaqyae8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 006/189] dma-debug: dont enforce dma mapping check on noncoherent allocations
Date: Wed, 17 Sep 2025 14:31:56 +0200
Message-ID: <20250917123352.003636148@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e43c6de2bce4e..b82399437db03 100644
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
@@ -1581,6 +1584,49 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
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
index 107e4a4d251df..56de28a3b1799 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -712,7 +712,7 @@ struct page *dma_alloc_pages(struct device *dev, size_t size,
 	if (page) {
 		trace_dma_alloc_pages(dev, page_to_virt(page), *dma_handle,
 				      size, dir, gfp, 0);
-		debug_dma_map_page(dev, page, 0, size, dir, *dma_handle, 0);
+		debug_dma_alloc_pages(dev, page, size, dir, *dma_handle, 0);
 	} else {
 		trace_dma_alloc_pages(dev, NULL, 0, size, dir, gfp, 0);
 	}
@@ -738,7 +738,7 @@ void dma_free_pages(struct device *dev, size_t size, struct page *page,
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



