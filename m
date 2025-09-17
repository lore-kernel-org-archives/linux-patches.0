Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A082E7BA0;
	Wed, 17 Sep 2025 12:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113192; cv=none; b=o5rA6ERjh2R7EbJMYA0yYotHMaocOPgVJeU2mmHp9QxC6a4YAh3DBdHR4QDgz0+bqoIjcN6LIWogaAsw3k5fqE6ABbNCvhCkj6VlX+l4Y6GR83gMD+pCqounOF1xnGzxdPj6ErbD4Xg4VmD/lCzoXIEeJ8YtwT3eeirNd+bdM7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113192; c=relaxed/simple;
	bh=8z6H+FBua2nPe8KkorGUSY9/rf8YLJbs+e1cQSRN+wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGoSAZH/Zt4ZXJPqqxH3EFSYm7j3xMCqQHw5H5rTuSJw0FZsXKvCDaGLO74PRhEh8S9GZqrNPvCP9SunIiupoztBGCHsmyUn48hJMH8UDDsN1D64GOIpYOQiWmU2uM2byyAP6KwdhBmg1dOM+FIzmqhfHg6WwRTTvrUHJDEBvNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ES0S+OWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ES0S+OWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2748C4CEF0;
	Wed, 17 Sep 2025 12:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113192;
	bh=8z6H+FBua2nPe8KkorGUSY9/rf8YLJbs+e1cQSRN+wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ES0S+OWAoSFrej1km4XeX4lbGIAThyvO88lRbVXxnOD1JBMbqf9sqq6uvTcIYUDkJ
	 S4BDi/q0vuX0uV5YfLG3K1r8pJYF8kJegEatsqk1q0WGaoO1Iq7znWlxtuaWHrknxb
	 7F319KEhPlQhNcYtwzwsp8dP5eRu/+C6s6WBKrCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/140] dma-debug: fix physical address calculation for struct dma_debug_entry
Date: Wed, 17 Sep 2025 14:33:03 +0200
Message-ID: <20250917123344.593908517@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit aef7ee7649e02f7fc0d2e5e532f352496976dcb1 ]

Offset into the page should also be considered while calculating a physical
address for struct dma_debug_entry. page_to_phys() just shifts the value
PAGE_SHIFT bits to the left so offset part is zero-filled.

An example (wrong) debug assertion failure with CONFIG_DMA_API_DEBUG
enabled which is observed during systemd boot process after recent
dma-debug changes:

DMA-API: e1000 0000:00:03.0: cacheline tracking EEXIST, overlapping mappings aren't supported
WARNING: CPU: 4 PID: 941 at kernel/dma/debug.c:596 add_dma_entry
CPU: 4 UID: 0 PID: 941 Comm: ip Not tainted 6.12.0+ #288
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:add_dma_entry kernel/dma/debug.c:596
Call Trace:
 <TASK>
debug_dma_map_page kernel/dma/debug.c:1236
dma_map_page_attrs kernel/dma/mapping.c:179
e1000_alloc_rx_buffers drivers/net/ethernet/intel/e1000/e1000_main.c:4616
...

Found by Linux Verification Center (linuxtesting.org).

Fixes: 9d4f645a1fd4 ("dma-debug: store a phys_addr_t in struct dma_debug_entry")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
[hch: added a little helper to clean up the code]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 0221023e1120d..39972e834e7a1 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1224,7 +1224,7 @@ void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
 
 	entry->dev       = dev;
 	entry->type      = dma_debug_single;
-	entry->paddr	 = page_to_phys(page);
+	entry->paddr	 = page_to_phys(page) + offset;
 	entry->dev_addr  = dma_addr;
 	entry->size      = size;
 	entry->direction = direction;
@@ -1382,6 +1382,18 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	}
 }
 
+static phys_addr_t virt_to_paddr(void *virt)
+{
+	struct page *page;
+
+	if (is_vmalloc_addr(virt))
+		page = vmalloc_to_page(virt);
+	else
+		page = virt_to_page(virt);
+
+	return page_to_phys(page) + offset_in_page(virt);
+}
+
 void debug_dma_alloc_coherent(struct device *dev, size_t size,
 			      dma_addr_t dma_addr, void *virt,
 			      unsigned long attrs)
@@ -1404,8 +1416,7 @@ void debug_dma_alloc_coherent(struct device *dev, size_t size,
 
 	entry->type      = dma_debug_coherent;
 	entry->dev       = dev;
-	entry->paddr	 = page_to_phys((is_vmalloc_addr(virt) ?
-				vmalloc_to_page(virt) : virt_to_page(virt)));
+	entry->paddr	 = virt_to_paddr(virt);
 	entry->size      = size;
 	entry->dev_addr  = dma_addr;
 	entry->direction = DMA_BIDIRECTIONAL;
@@ -1428,8 +1439,7 @@ void debug_dma_free_coherent(struct device *dev, size_t size,
 	if (!is_vmalloc_addr(virt) && !virt_addr_valid(virt))
 		return;
 
-	ref.paddr = page_to_phys((is_vmalloc_addr(virt) ?
-			vmalloc_to_page(virt) : virt_to_page(virt)));
+	ref.paddr = virt_to_paddr(virt);
 
 	if (unlikely(dma_debug_disabled()))
 		return;
-- 
2.51.0



