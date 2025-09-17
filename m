Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50FE328977;
	Wed, 17 Sep 2025 12:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113254; cv=none; b=bL/6FIn2HlKRqsF+orR4WQErt7QjrwluJTAkL9LGGdnLEtxxS6VuHGglezwFdElvFhKchi96zMbBzN0yI/TvVtXOkQCor2iy7Qz2JmLDEeyTjWoqyxWlV9n7AQrs1GlznZ8lcewOLJAeSbFP9aXES6aw6KE9EG9A3g9aZk2WFSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113254; c=relaxed/simple;
	bh=RhU44sMsNFwRLE7LN8qhxN50fF0GTD26yfcqxdpV13Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/2rmZ3ejju0MteOKApMA1X6qcnSaBxZ2C2BKfQa5L78u9YvAWxnA6YLF73elDZJ2LfhCcAbnbYIPIAIJSZ9uPQArFC0PxjJmFCPGJ3FKuMl5Af+5PWED5Zt3WJFkhl81Fw68I/W65XWxb64BfE0NGBHH91KSulh33T90oFdoN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JL82HbA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JL82HbA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BC9C4CEF5;
	Wed, 17 Sep 2025 12:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113253;
	bh=RhU44sMsNFwRLE7LN8qhxN50fF0GTD26yfcqxdpV13Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JL82HbA+zB90M91HC+wfBUavmv/8cLU7BwbqD6Ge6rGoDWNPxsQqrZoP8nYQYZsIK
	 z4Qp6hsZeV1/tCiRer4NY/SEb+zfV+gHLdKyefk8nHokplp9r5ZpA4cwCODUwITkAf
	 IR/3v2/FAA0tv/4BpeBL5cOyBW7UX1y+Scsv4FS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/140] dma-mapping: trace dma_alloc/free direction
Date: Wed, 17 Sep 2025 14:32:55 +0200
Message-ID: <20250917123344.402595521@linuxfoundation.org>
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

[ Upstream commit 3afff779a725cba914e6caba360b696ae6f90249 ]

In preparation for using these tracepoints in a few more places, trace
the DMA direction as well. For coherent allocations this is always
bidirectional.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 7e2368a21741 ("dma-debug: don't enforce dma mapping check on noncoherent allocations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/dma.h | 18 ++++++++++++------
 kernel/dma/mapping.c       |  6 ++++--
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index b0f41265191c3..012729cc178f0 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -116,8 +116,9 @@ DEFINE_EVENT(dma_unmap, dma_unmap_resource,
 
 TRACE_EVENT(dma_alloc,
 	TP_PROTO(struct device *dev, void *virt_addr, dma_addr_t dma_addr,
-		 size_t size, gfp_t flags, unsigned long attrs),
-	TP_ARGS(dev, virt_addr, dma_addr, size, flags, attrs),
+		 size_t size, enum dma_data_direction dir, gfp_t flags,
+		 unsigned long attrs),
+	TP_ARGS(dev, virt_addr, dma_addr, size, dir, flags, attrs),
 
 	TP_STRUCT__entry(
 		__string(device, dev_name(dev))
@@ -125,6 +126,7 @@ TRACE_EVENT(dma_alloc,
 		__field(u64, dma_addr)
 		__field(size_t, size)
 		__field(gfp_t, flags)
+		__field(enum dma_data_direction, dir)
 		__field(unsigned long, attrs)
 	),
 
@@ -137,8 +139,9 @@ TRACE_EVENT(dma_alloc,
 		__entry->attrs = attrs;
 	),
 
-	TP_printk("%s dma_addr=%llx size=%zu virt_addr=%p flags=%s attrs=%s",
+	TP_printk("%s dir=%s dma_addr=%llx size=%zu virt_addr=%p flags=%s attrs=%s",
 		__get_str(device),
+		decode_dma_data_direction(__entry->dir),
 		__entry->dma_addr,
 		__entry->size,
 		__entry->virt_addr,
@@ -148,14 +151,15 @@ TRACE_EVENT(dma_alloc,
 
 TRACE_EVENT(dma_free,
 	TP_PROTO(struct device *dev, void *virt_addr, dma_addr_t dma_addr,
-		 size_t size, unsigned long attrs),
-	TP_ARGS(dev, virt_addr, dma_addr, size, attrs),
+		 size_t size, enum dma_data_direction dir, unsigned long attrs),
+	TP_ARGS(dev, virt_addr, dma_addr, size, dir, attrs),
 
 	TP_STRUCT__entry(
 		__string(device, dev_name(dev))
 		__field(void *, virt_addr)
 		__field(u64, dma_addr)
 		__field(size_t, size)
+		__field(enum dma_data_direction, dir)
 		__field(unsigned long, attrs)
 	),
 
@@ -164,11 +168,13 @@ TRACE_EVENT(dma_free,
 		__entry->virt_addr = virt_addr;
 		__entry->dma_addr = dma_addr;
 		__entry->size = size;
+		__entry->dir = dir;
 		__entry->attrs = attrs;
 	),
 
-	TP_printk("%s dma_addr=%llx size=%zu virt_addr=%p attrs=%s",
+	TP_printk("%s dir=%s dma_addr=%llx size=%zu virt_addr=%p attrs=%s",
 		__get_str(device),
+		decode_dma_data_direction(__entry->dir),
 		__entry->dma_addr,
 		__entry->size,
 		__entry->virt_addr,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 74d453ec750a1..9720f3c157d9f 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -619,7 +619,8 @@ void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
 	else
 		return NULL;
 
-	trace_dma_alloc(dev, cpu_addr, *dma_handle, size, flag, attrs);
+	trace_dma_alloc(dev, cpu_addr, *dma_handle, size, DMA_BIDIRECTIONAL,
+			flag, attrs);
 	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr, attrs);
 	return cpu_addr;
 }
@@ -644,7 +645,8 @@ void dma_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 	if (!cpu_addr)
 		return;
 
-	trace_dma_free(dev, cpu_addr, dma_handle, size, attrs);
+	trace_dma_free(dev, cpu_addr, dma_handle, size, DMA_BIDIRECTIONAL,
+		       attrs);
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 	if (dma_alloc_direct(dev, ops))
 		dma_direct_free(dev, size, cpu_addr, dma_handle, attrs);
-- 
2.51.0



