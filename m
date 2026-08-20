Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8C53822BF;
	Thu, 20 Aug 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239295; cv=none; b=sJQzjs6aPcxGVM/b/9Xk2Mtyc+Ee/YDScW9NFjNg3tSFPUybyNQWgcSBv1xrMVx2/pHfRhpByV0Kjzr1puDzUVUubY+44I3FWZyndRxXM9DtmSSrgL6HZLkCh2wUR4IaZLJNEeqPEFCZNoSeiHKnt5I9Jiys6yITWetqrg14Lu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239295; c=relaxed/simple;
	bh=iZWSdPbdHKbe7db/npIG9CiFWfVq6kO/CCb1qbcBZeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQzWbyOzX1JpFLNnAjEwPoXq6o26HEIL1ikbWVWo5xsjD6caav6OwVzys/o54n3jlE1eO42NW+1aBmlLXUSPjOg/GE11yxwBFFG5jv9974XPW0bADUcuMpmsHbqh01r2pFMNJrFFP9g9jXaf06pRzxlTKP641fcFowWgqacIfQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2sSfNCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2sSfNCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D81F000E9;
	Thu, 20 Aug 2026 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239294;
	bh=DDMcnmh3Dn0+t0xKjKJzFanz4iIKVI8NdfwFpPx1Dgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2sSfNCu0YnM0a6cjXAIXydNVQimCrebioV8lGf5ndk98JIK45CAhoIqBCg/03Nir
	 obaH1QCtLHjAhn+nO0JUFXlq6+Y2wG7VEORWR03Lcvr294Jq2AqdrDnI6tuXz1miQq
	 gjKH12whmN18t4nA715YA2vBmH8OoTNgnOjLKFnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/217] firewire: ohci: split page allocation from dma mapping
Date: Thu, 20 Aug 2026 16:56:12 +0200
Message-ID: <20260820145243.844698786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit f2ae92780ab93ed7e59e469cfd5c7269bd68ddb4 ]

1394 OHCI PCI driver had long been the only user of dma_alloc_pages().
Although tee subsystem recently started using it, they are still a few
users of the infrequently-used function.

In the discussion for dma-mapping function, Jason Gunthorpe shows his
opinion about the design of public API for the function. According to it,
the users provide physical address to the function, then receive DMA
mapping address, regardless of the location of mapping target.

With the above aspects, this commit eliminates the use of
dma_alloc_pages() from this subsystem.

Link: https://lore.kernel.org/lkml/20250905174324.GI616306@nvidia.com/
Link: https://lore.kernel.org/r/20260110013911.19160-8-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Stable-dep-of: 42d217add8d8 ("firewire: ohci: fix NULL pointer dereference in ar_context_release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/ohci.c | 77 +++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 030aed5453a17..afcf36c01ef83 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -539,18 +539,22 @@ static void ar_context_link_page(struct ar_context *ctx, unsigned int index)
 static void ar_context_release(struct ar_context *ctx)
 {
 	struct device *dev = ctx->ohci->card.device;
-	unsigned int i;
 
 	if (!ctx->buffer)
 		return;
 
-	vunmap(ctx->buffer);
+	for (int i = 0; i < AR_BUFFERS; ++i) {
+		dma_addr_t dma_addr = page_private(ctx->pages[i]);
 
-	for (i = 0; i < AR_BUFFERS; i++) {
-		if (ctx->pages[i])
-			dma_free_pages(dev, PAGE_SIZE, ctx->pages[i],
-				       ar_buffer_bus(ctx, i), DMA_FROM_DEVICE);
+		dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+		set_page_private(ctx->pages[i], 0);
 	}
+
+	vunmap(ctx->buffer);
+	ctx->buffer = NULL;
+
+	release_pages(ctx->pages, AR_BUFFERS);
+	memset(ctx->pages, 0, sizeof(ctx->pages));
 }
 
 static void ar_context_abort(struct ar_context *ctx, const char *error_msg)
@@ -845,31 +849,57 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 {
 	struct device *dev = ohci->card.device;
 	unsigned int i;
-	dma_addr_t dma_addr;
 	struct page *pages[AR_BUFFERS + AR_WRAPAROUND_PAGES];
+	void *vaddr;
 	struct descriptor *d;
 
 	ctx->regs        = regs;
 	ctx->ohci        = ohci;
 	INIT_WORK(&ctx->work, ohci_ar_context_work);
 
-	for (i = 0; i < AR_BUFFERS; i++) {
-		ctx->pages[i] = dma_alloc_pages(dev, PAGE_SIZE, &dma_addr,
-						DMA_FROM_DEVICE, GFP_KERNEL);
-		if (!ctx->pages[i])
-			goto out_of_memory;
-		set_page_private(ctx->pages[i], dma_addr);
-		dma_sync_single_for_device(dev, dma_addr, PAGE_SIZE,
-					   DMA_FROM_DEVICE);
+	// Retrieve noncontiguous pages. The descriptors for 1394 OHCI AR DMA contexts have a set
+	// of address and length per each. The reason to use pages is to construct contiguous
+	// address range in kernel virtual address space.
+	unsigned long nr_populated = alloc_pages_bulk(GFP_KERNEL | GFP_DMA32, AR_BUFFERS, pages);
+
+	if (nr_populated != AR_BUFFERS) {
+		release_pages(pages, nr_populated);
+		return -ENOMEM;
 	}
 
-	for (i = 0; i < AR_BUFFERS; i++)
-		pages[i]              = ctx->pages[i];
+	// Map the pages into contiguous kernel virtual addresses so that the packet data
+	// across the pages can be referred as being contiguous, especially across the last
+	// and first pages.
 	for (i = 0; i < AR_WRAPAROUND_PAGES; i++)
-		pages[AR_BUFFERS + i] = ctx->pages[i];
-	ctx->buffer = vmap(pages, ARRAY_SIZE(pages), VM_MAP, PAGE_KERNEL);
-	if (!ctx->buffer)
-		goto out_of_memory;
+		pages[AR_BUFFERS + i] = pages[i];
+	vaddr = vmap(pages, ARRAY_SIZE(pages), VM_MAP, PAGE_KERNEL);
+	if (!vaddr) {
+		release_pages(pages, nr_populated);
+		return -ENOMEM;
+	}
+
+	// Retrieve DMA mapping addresses for the pages. They are not contiguous. Maintain the cache
+	// coherency for the pages by hand.
+	for (i = 0; i < AR_BUFFERS; i++) {
+		// The dma_map_phys() with a physical address per page is available here, instead.
+		dma_addr_t dma_addr = dma_map_page(dev, pages[i], 0, PAGE_SIZE, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev, dma_addr))
+			break;
+		set_page_private(pages[i], dma_addr);
+		dma_sync_single_for_device(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+	}
+	if (i < AR_BUFFERS) {
+		while (i-- > 0) {
+			dma_addr_t dma_addr = page_private(pages[i]);
+			dma_unmap_page(dev, dma_addr, PAGE_SIZE, DMA_FROM_DEVICE);
+		}
+		vunmap(vaddr);
+		release_pages(pages, nr_populated);
+		return -ENOMEM;
+	}
+
+	ctx->buffer = vaddr;
+	memcpy(ctx->pages, pages, sizeof(ctx->pages));
 
 	ctx->descriptors     = ohci->misc_buffer     + descriptors_offset;
 	ctx->descriptors_bus = ohci->misc_buffer_bus + descriptors_offset;
@@ -886,11 +916,6 @@ static int ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci,
 	}
 
 	return 0;
-
-out_of_memory:
-	ar_context_release(ctx);
-
-	return -ENOMEM;
 }
 
 static void ar_context_run(struct ar_context *ctx)
-- 
2.53.0



