Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADD33368B5;
	Thu, 28 May 2026 20:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000238; cv=none; b=Bhy18ox5mE1lt6q9F7SHY9fTQpAgvAAFbICJjqFbPLTmGoCq8R4ZN8G2G1gaEuEMqwxa7QyKyn+BIBOl44UOndHUwCMRtg9x6RTkmm6/J3Ohedbnq/0BGMAxjP43CBtoD4rTuoDPvX/x7eTDTCG+S7ocF69xrBrUukSlwT1xmF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000238; c=relaxed/simple;
	bh=E4AzP0BBudRPzr+6lSaufi0JFop0TgDkJMyn2fNtyxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi0f+S6U+GpVNVQeg7tlMi1Fy8cSUL6YskWKZftnj7XkDgMlvtCtavAeIbEq2ngdUecnCcDY/FsAkfhxKEYXkfNdlehFFAEBleEVsIWEX58Q9KfWIb3OURXBAFXu9/9HGR8X32bx+F7q9ScrcjsXjH43oYHNcIZ/K+whFfMJH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3zTPP8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3zTPP8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A791F00A3C;
	Thu, 28 May 2026 20:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000237;
	bh=RI5hQ6HI7VYrsnEp+fjFTLod0YOTrKu8O3bTd7Pmo1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3zTPP8USJCP9V4/2QvwGE4OwXP//ZX7FaRbX8S4OaUktd6ur/ijC3uY4XOS+ZHND
	 eZral1lND4IyDoPLsGyX1B8asUbyztoMrytdKHZmakhGgG4Q4Ih1EntiNy5/sCqu6L
	 SYWRvKmHcPrJ+g46Mt4igGKpjpPtMqyVbaw1E3Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Jianpeng Chang <jianpeng.chang.cn@windriver.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/377] dma-mapping: move dma_map_resource() sanity check into debug code
Date: Thu, 28 May 2026 21:49:12 +0200
Message-ID: <20260528194647.481237873@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>

[ Upstream commit af0c3f05866237f7592219bfe05387bc3bfc99b5 ]

dma_map_resource() uses pfn_valid() to ensure the range is not RAM.
However, pfn_valid() only checks for availability of the memory map for
a PFN but it does not ensure that the PFN is actually backed by RAM. On
ARM64 with SPARSEMEM (128MB section granularity), MMIO addresses that
share a section with RAM will falsely trigger the WARN_ON_ONCE and cause
dma_map_resource() to return DMA_MAPPING_ERROR.

This causes a WARNING on Raspberry Pi 4 during spi_bcm2835 probe because
the SPI FIFO register (0xfe204004) falls in the same sparsemem section
as the end of RAM (0xf8000000-0xfbffffff), both in section 31
(0xf8000000-0xffffffff).

Move the sanity check from dma_map_resource() into debug_dma_map_phys()
and replace the unreliable pfn_valid() with pfn_valid() &&
!PageReserved(), which correctly identifies actual usable RAM without
false positives for MMIO regions that happen to have struct pages.

Since dma_map_resource() is dma_map_phys(DMA_ATTR_MMIO), the check
applies equally to both APIs. Any non-reserved page represents kernel
memory to a sufficient degree that using DMA_ATTR_MMIO on it is almost
certainly wrong and risks breaking coherency on non-coherent platforms.
ZONE_DEVICE pages used for PCI P2P DMA (MEMORY_DEVICE_PCI_P2PDMA) have
PageReserved set, so they will not trigger a false positive.

The check no longer blocks the mapping and uses err_printk() to
integrate with dma-debug filtering.

Fixes: f7326196a781 ("dma-mapping: export new dma_*map_phys() interface")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260513072209.1486986-1-jianpeng.chang.cn@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c   | 9 ++++++++-
 kernel/dma/mapping.c | 4 ----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 21db331185911..fa4aac3339172 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1250,7 +1250,14 @@ void debug_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	entry->direction = direction;
 	entry->map_err_type = MAP_ERR_NOT_CHECKED;
 
-	if (!(attrs & DMA_ATTR_MMIO)) {
+	if (attrs & DMA_ATTR_MMIO) {
+		unsigned long pfn = PHYS_PFN(phys);
+
+		if (pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
+			err_printk(dev, entry,
+				   "dma_map_resource called for RAM address %pa\n",
+				   &phys);
+	} else {
 		check_for_stack(dev, phys);
 
 		if (!PhysHighMem(phys))
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index fe7472f13b106..35e4556b95566 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -366,10 +366,6 @@ EXPORT_SYMBOL(dma_unmap_sg_attrs);
 dma_addr_t dma_map_resource(struct device *dev, phys_addr_t phys_addr,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
-	if (IS_ENABLED(CONFIG_DMA_API_DEBUG) &&
-	    WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
-		return DMA_MAPPING_ERROR;
-
 	return dma_map_phys(dev, phys_addr, size, dir, attrs | DMA_ATTR_MMIO);
 }
 EXPORT_SYMBOL(dma_map_resource);
-- 
2.53.0



