Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C08265CA2;
	Thu, 17 Apr 2025 18:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914119; cv=none; b=YkqfkMP8xUc4/vwArNC+MjwjCtDV/RtL+MTfr6HEcj5NpEGU2+F2nMpOwRC8jlByWqrhNS1+BLfcffIusfDCK3LHgA/fQf0RFg5K4dVIsqdXYPnoSOgW9uJot3Cn0p2QgcVWLt29QY9d02z1AQSpwo+3KlnVYMot6LlGmRdEsMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914119; c=relaxed/simple;
	bh=Xj+UiUqX+0eFQeDI09z3G4pE1FR5JNC/C44pAGVBikU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwPBpToigxr2eOD7sL9b9Q0uIFiN4Svh0TNEsOT0ppK0tKj9D5/SwRKCM8aQMWr9//jPw9cyzizYVkAiVk5cisuGPCvh2bXayIan8xULkqwflFVviLu2Ukg7bGPGw0oof9BLpEKXRe913407t8E7PvgTOrMBVDvxZY2paOFok4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uvbiyU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uvbiyU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE52AC4CEEC;
	Thu, 17 Apr 2025 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914119;
	bh=Xj+UiUqX+0eFQeDI09z3G4pE1FR5JNC/C44pAGVBikU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uvbiyU61UEMXMXjdGOapyPlbopJz/qCLIRe+Z3+tsq5z67Him6lgFXJNgjIj/9nY
	 WC44CPdEOhqI8I7dbT99+mzQ+QfrD438GoLnSgOp8D7HeNPcq/cEC9OMj5qJcvHh2C
	 zfB9zzULI6WkGdr7lsV0vryeuJCzPzbcuTIXb6s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 083/414] wifi: ath11k: Fix DMA buffer allocation to resolve SWIOTLB issues
Date: Thu, 17 Apr 2025 19:47:21 +0200
Message-ID: <20250417175114.783245983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



