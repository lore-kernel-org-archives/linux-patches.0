Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14B3CFF6F;
	Tue, 13 Oct 2026 11:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892465; cv=none; b=Dng+A7/IBp6kCzuI2dWwtA8tYVenS5RJh4U8sihVNQljjFwVaP9jiO6puvqLdGrsWyUm0jlujX6sUB+q7S59tBB6TAnT1FHym7+I5nov/N1qrASkaEZjIC0Gb5dsw23qvRxMzBN263o+2ui+TC6h6k6rwU48F3ZPWhJO/ItP1XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892465; c=relaxed/simple;
	bh=MlGdYbdH69+ESW7y8FwgvrLnu0givyyZ/u2cp9GbaJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6iK6+Xe1orVydlJi7V9qulZlzKZxacAI5GvDOz1nSEnRmy/E9NQZW8kPtEHsotgBfPaPMo1mRKF/dZqzrUZvZyc43OAdg0EQ6VD06uKZciq28WAinkvbeywH4Lw0yn8eCYKnPuYoDeQdeWDlvn6UdT699FW5B1Uxmt+JqHeafw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hbv23EFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hbv23EFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31AC1F000FF;
	Tue, 13 Oct 2026 11:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892464;
	bh=M5OMtyyvfWoQPMLPo50ttwdbR/dGGqW3Yyy9kPk9vS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hbv23EFJy+aRDr50xizUrN43nBOWqNZ9x+21OQ0DHesvvnIkcLbWJ6X2VVTx6G/W1
	 AicFyynatt79dZE5yHJl2F7FdMA7MVbVTK7s9W3HnSy9PCc2qUzIAYyV53tduVelKe
	 YnR/rlf9baLghgvvM4Yj/0wpEIqWgsx5GQ2GBWFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Robin Murphy <robin.murphy@arm.comn>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 183/281] iommu/dma: skip swiotlb bounce for DMA_ATTR_MMIO in iommu_dma_map_phys
Date: Tue, 13 Oct 2026 13:38:19 +0200
Message-ID: <20261013112859.606279548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 057e5e07420c753f248f9ce148040ab6dcf8359f ]

MMIO resources mapped via dma_map_resource() carry DMA_ATTR_MMIO. These
never need swiotlb bounce buffering, but the current code enters the
swiotlb path when the physical address is not page-aligned, then rejects
the mapping because MMIO cannot be bounced.

Move the DMA_ATTR_MMIO check before the swiotlb block so the entire bounce
path is skipped for MMIO, falling through directly to __iommu_dma_map()
which creates the IOVA mapping.

Fixes: f9374de14c0e8 ("iommu/dma: implement DMA_ATTR_MMIO for iommu_dma_(un)map_phys()")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Acked-by: Robin Murphy <robin.murphy@arm.comn>
Link: https://lore.kernel.org/r/20260916-iommu-dma-fix-v1-1-a59a0c45ec5b@nxp.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dma-iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ae814d8c99c04..5f901b4baf216 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1228,9 +1228,9 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 	 * If both the physical buffer start address and size are page aligned,
 	 * we don't need to use a bounce page.
 	 */
-	if (dev_use_swiotlb(dev, size, dir) &&
+	if (!(attrs & DMA_ATTR_MMIO) && dev_use_swiotlb(dev, size, dir) &&
 	    iova_unaligned(iovad, phys, size)) {
-		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
+		if (attrs & DMA_ATTR_REQUIRE_COHERENT)
 			return DMA_MAPPING_ERROR;
 
 		phys = iommu_dma_map_swiotlb(dev, phys, size, dir, attrs);
-- 
2.53.0



