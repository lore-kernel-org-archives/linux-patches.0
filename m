Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0194254B12;
	Thu, 17 Apr 2025 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912706; cv=none; b=Xgt6f6zG5keqeqL8t9AY/qyd3UCfjrsw+Ih8HHiBoT82LvqzLkGy5G6H/JFFG/lrnLjYVkChBQETZZAJLwBbaLsWr95mu9N70Dchjcat7aoOY6L4l35npZwqcFKfJB83jUN7YaB2Hffqrihzyu/YvVL2aOMAE93pUxSUrz+Pc2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912706; c=relaxed/simple;
	bh=rfLAmnWmu/XbpfVUEpn54hvesMDG4eN4ChlAXBOtYzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6EdK8H7eOTAuBPjH9QWU6cx6RoJEwt8lnBGD1LI6tNZU5lL0mmNlomlv8uMAzW88Qg68gf32m4e4aXQzysJRGFo4MOuVxJni+pq/IsdGnwSpJEvMrk149M2Lv/siDJAmSsLZ1Rz3qRCyLfO0rmRQhCpI1b2akY/44rbrKFq3wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wh0XcH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wh0XcH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283C1C4CEE4;
	Thu, 17 Apr 2025 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912705;
	bh=rfLAmnWmu/XbpfVUEpn54hvesMDG4eN4ChlAXBOtYzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wh0XcH8GcbJMWykxEw6ANiVzH59VIf2GeLIvo/36APlt3Zu8jSBGgISBnil1ITiZ
	 SDhN9g6ztFbXeN+MVo7BPJcq1uqHitEo0kHtM1K/wRvi7pk0r8/ylgd/0Xvj7HPt17
	 ZhOhJOqk4aw1HiLPYZ7+DwL76PBCV7fFaL173smQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 096/449] wifi: ath11k: Fix DMA buffer allocation to resolve SWIOTLB issues
Date: Thu, 17 Apr 2025 19:46:24 +0200
Message-ID: <20250417175121.826813990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 1bcd20981834928ccc5d981aacb806bb523d8b29 ]

Currently, the driver allocates cacheable DMA buffers for rings like
HAL_REO_DST and HAL_WBM2SW_RELEASE. The buffers for HAL_WBM2SW_RELEASE
are large (1024 KiB), exceeding the SWIOTLB slot size of 256 KiB. This
leads to "swiotlb buffer is full" error messages on systems without an
IOMMU that use SWIOTLB, causing driver initialization failures. The driver
calls dma_map_single() with these large buffers obtained from kzalloc(),
resulting in ring initialization errors on systems without an IOMMU that
use SWIOTLB.

To address these issues, replace the flawed buffer allocation mechanism
with the appropriate DMA API. Specifically, use dma_alloc_noncoherent()
for cacheable DMA buffers, ensuring proper freeing of buffers with
dma_free_noncoherent().

Error log:
[   10.194343] ath11k_pci 0000:04:00.0: swiotlb buffer is full (sz:1048583 bytes), total 32768 (slots), used 2529 (slots)
[   10.194406] ath11k_pci 0000:04:00.0: failed to set up tcl_comp ring (0) :-12
[   10.194781] ath11k_pci 0000:04:00.0: failed to init DP: -12

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Reported-by: Tim Harvey <tharvey@gateworks.com>
Closes: https://lore.kernel.org/all/20241210041133.GA17116@lst.de/
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Tested-by: Tim Harvey <tharvey@gateworks.com>
Link: https://patch.msgid.link/20250119164219.647059-2-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.c | 35 +++++++++-------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index fbf666d0ecf1d..f124b7329e1ac 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <crypto/hash.h>
@@ -104,14 +104,12 @@ void ath11k_dp_srng_cleanup(struct ath11k_base *ab, struct dp_srng *ring)
 	if (!ring->vaddr_unaligned)
 		return;
 
-	if (ring->cached) {
-		dma_unmap_single(ab->dev, ring->paddr_unaligned, ring->size,
-				 DMA_FROM_DEVICE);
-		kfree(ring->vaddr_unaligned);
-	} else {
+	if (ring->cached)
+		dma_free_noncoherent(ab->dev, ring->size, ring->vaddr_unaligned,
+				     ring->paddr_unaligned, DMA_FROM_DEVICE);
+	else
 		dma_free_coherent(ab->dev, ring->size, ring->vaddr_unaligned,
 				  ring->paddr_unaligned);
-	}
 
 	ring->vaddr_unaligned = NULL;
 }
@@ -249,25 +247,14 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 		default:
 			cached = false;
 		}
-
-		if (cached) {
-			ring->vaddr_unaligned = kzalloc(ring->size, GFP_KERNEL);
-			if (!ring->vaddr_unaligned)
-				return -ENOMEM;
-
-			ring->paddr_unaligned = dma_map_single(ab->dev,
-							       ring->vaddr_unaligned,
-							       ring->size,
-							       DMA_FROM_DEVICE);
-			if (dma_mapping_error(ab->dev, ring->paddr_unaligned)) {
-				kfree(ring->vaddr_unaligned);
-				ring->vaddr_unaligned = NULL;
-				return -ENOMEM;
-			}
-		}
 	}
 
-	if (!cached)
+	if (cached)
+		ring->vaddr_unaligned = dma_alloc_noncoherent(ab->dev, ring->size,
+							      &ring->paddr_unaligned,
+							      DMA_FROM_DEVICE,
+							      GFP_KERNEL);
+	else
 		ring->vaddr_unaligned = dma_alloc_coherent(ab->dev, ring->size,
 							   &ring->paddr_unaligned,
 							   GFP_KERNEL);
-- 
2.39.5



