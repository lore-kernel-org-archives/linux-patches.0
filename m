Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D34328967;
	Wed, 17 Sep 2025 12:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113260; cv=none; b=m7tjEJGFzbX1UivmpZgCl08o3VIIyihlm0rXSNHm5BJq5eqp3zzrVeipfjotDV3gOLDCtNr6FzyHeT/ePOuRx/ZamLWYC3BZk8lBS1mZp68utod8E4lPqDIJ5u13HMpSUdxXJTWb1NVZBVAX0hIpBLXfN5bZ1ycTXL5wDf4WhbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113260; c=relaxed/simple;
	bh=PFctZpDZ/Ii4Smbl47JQ32yetbCWdqrjouVpl87cWwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFaPfnVNOhnf6/Z+mmrTvchk2YvKs0D0HXfKXTe6rwx+JAPY7ZNqQCfXa4eccphNbKF7lpgerc4FitXXqqCWXCgT7gGx+WkW2AIkB7LFE6VXFemgcAGhxyMPlTdLVSIof4XbtoZMw1P5XnCzc3k8w85nexZJyh5rQBav8JLYBIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e43V6IPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e43V6IPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6722AC4CEF0;
	Wed, 17 Sep 2025 12:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113259;
	bh=PFctZpDZ/Ii4Smbl47JQ32yetbCWdqrjouVpl87cWwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e43V6IPV5hlwz0DjgA+zKBNr1Ua9cwyBwo9+85cruvnVYNTVyPhfy+5Rja8j45NtQ
	 E1qAAuCBCX+WI5EfeUd8q2RZEClK6HEIh76NZrgHZ6tm5zjfwb+ceZ30sUgs/8zti4
	 oi0gORqTpLvYV/ZmflwIoG7TGXPVCYM+ryMQywCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/140] dma-mapping: trace more error paths
Date: Wed, 17 Sep 2025 14:32:57 +0200
Message-ID: <20250917123344.449257835@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 68b6dbf1f441c4eba3b8511728a41cf9b01dca35 ]

It can be surprising to the user if DMA functions are only traced on
success. On failure, it can be unclear what the source of the problem
is. Fix this by tracing all functions even when they fail. Cases where
we BUG/WARN are skipped, since those should be sufficiently noisy
already.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 7e2368a21741 ("dma-debug: don't enforce dma mapping check on noncoherent allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/dma.h | 36 ++++++++++++++++++++++++++++++++++++
 kernel/dma/mapping.c       | 25 ++++++++++++++++++-------
 2 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 45cc0ca8287fe..63b55ccc4f00c 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -158,6 +158,7 @@ DEFINE_EVENT(dma_alloc_class, name, \
 
 DEFINE_ALLOC_EVENT(dma_alloc);
 DEFINE_ALLOC_EVENT(dma_alloc_pages);
+DEFINE_ALLOC_EVENT(dma_alloc_sgt_err);
 
 TRACE_EVENT(dma_alloc_sgt,
 	TP_PROTO(struct device *dev, struct sg_table *sgt, size_t size,
@@ -322,6 +323,41 @@ TRACE_EVENT(dma_map_sg,
 		decode_dma_attrs(__entry->attrs))
 );
 
+TRACE_EVENT(dma_map_sg_err,
+	TP_PROTO(struct device *dev, struct scatterlist *sgl, int nents,
+		 int err, enum dma_data_direction dir, unsigned long attrs),
+	TP_ARGS(dev, sgl, nents, err, dir, attrs),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(dev))
+		__dynamic_array(u64, phys_addrs, nents)
+		__field(int, err)
+		__field(enum dma_data_direction, dir)
+		__field(unsigned long, attrs)
+	),
+
+	TP_fast_assign(
+		struct scatterlist *sg;
+		int i;
+
+		__assign_str(device);
+		for_each_sg(sgl, sg, nents, i)
+			((u64 *)__get_dynamic_array(phys_addrs))[i] = sg_phys(sg);
+		__entry->err = err;
+		__entry->dir = dir;
+		__entry->attrs = attrs;
+	),
+
+	TP_printk("%s dir=%s dma_addrs=%s err=%d attrs=%s",
+		__get_str(device),
+		decode_dma_data_direction(__entry->dir),
+		__print_array(__get_dynamic_array(phys_addrs),
+			      __get_dynamic_array_len(phys_addrs) /
+				sizeof(u64), sizeof(u64)),
+		__entry->err,
+		decode_dma_attrs(__entry->attrs))
+);
+
 TRACE_EVENT(dma_unmap_sg,
 	TP_PROTO(struct device *dev, struct scatterlist *sgl, int nents,
 		 enum dma_data_direction dir, unsigned long attrs),
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 690aeda8bd7da..32dcf8492bbcd 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -223,6 +223,7 @@ static int __dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
 		debug_dma_map_sg(dev, sg, nents, ents, dir, attrs);
 	} else if (WARN_ON_ONCE(ents != -EINVAL && ents != -ENOMEM &&
 				ents != -EIO && ents != -EREMOTEIO)) {
+		trace_dma_map_sg_err(dev, sg, nents, ents, dir, attrs);
 		return -EIO;
 	}
 
@@ -604,20 +605,26 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	if (WARN_ON_ONCE(flag & __GFP_COMP))
 		return NULL;
 
-	if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr))
+	if (dma_alloc_from_dev_coherent(dev, size, dma_handle, &cpu_addr)) {
+		trace_dma_alloc(dev, cpu_addr, *dma_handle, size,
+				DMA_BIDIRECTIONAL, flag, attrs);
 		return cpu_addr;
+	}
 
 	/* let the implementation decide on the zone to allocate from: */
 	flag &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
-	if (dma_alloc_direct(dev, ops))
+	if (dma_alloc_direct(dev, ops)) {
 		cpu_addr = dma_direct_alloc(dev, size, dma_handle, flag, attrs);
-	else if (use_dma_iommu(dev))
+	} else if (use_dma_iommu(dev)) {
 		cpu_addr = iommu_dma_alloc(dev, size, dma_handle, flag, attrs);
-	else if (ops->alloc)
+	} else if (ops->alloc) {
 		cpu_addr = ops->alloc(dev, size, dma_handle, flag, attrs);
-	else
+	} else {
+		trace_dma_alloc(dev, NULL, 0, size, DMA_BIDIRECTIONAL, flag,
+				attrs);
 		return NULL;
+	}
 
 	trace_dma_alloc(dev, cpu_addr, *dma_handle, size, DMA_BIDIRECTIONAL,
 			flag, attrs);
@@ -642,11 +649,11 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 	 */
 	WARN_ON(irqs_disabled());
 
+	trace_dma_free(dev, cpu_addr, dma_handle, size, DMA_BIDIRECTIONAL,
+		       attrs);
 	if (!cpu_addr)
 		return;
 
-	trace_dma_free(dev, cpu_addr, dma_handle, size, DMA_BIDIRECTIONAL,
-		       attrs);
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 	if (dma_alloc_direct(dev, ops))
 		dma_direct_free(dev, size, cpu_addr, dma_handle, attrs);
@@ -688,6 +695,8 @@ struct page *dma_alloc_pages(struct device *dev, size_t size,
 		trace_dma_alloc_pages(dev, page_to_virt(page), *dma_handle,
 				      size, dir, gfp, 0);
 		debug_dma_map_page(dev, page, 0, size, dir, *dma_handle, 0);
+	} else {
+		trace_dma_alloc_pages(dev, NULL, 0, size, dir, gfp, 0);
 	}
 	return page;
 }
@@ -772,6 +781,8 @@ struct sg_table *dma_alloc_noncontiguous(struct device *dev, size_t size,
 		sgt->nents = 1;
 		trace_dma_alloc_sgt(dev, sgt, size, dir, gfp, attrs);
 		debug_dma_map_sg(dev, sgt->sgl, sgt->orig_nents, 1, dir, attrs);
+	} else {
+		trace_dma_alloc_sgt_err(dev, NULL, 0, size, gfp, dir, attrs);
 	}
 	return sgt;
 }
-- 
2.51.0



