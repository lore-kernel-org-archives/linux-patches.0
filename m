Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D159241696;
	Wed,  3 Dec 2025 16:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780537; cv=none; b=kGrdUDAGHl/0KWvNy8/s/Uzy8/F99+op+UcPoNb6pFqyU0ykX7jGRaooOwjtvQRvQX8c1vdInVZDFB9c0iPZO//jBicQzPCfrveQZTXEXWlS9zQGBGlgyvdiaNA4t/+6q7LhXb+K7IDlvBpZ3iPyicWZninK7AHOQ2COegR33pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780537; c=relaxed/simple;
	bh=2Aj9SoZ5b2rWQV+WT7xPUimDe9Q7hODzFXuTiJPFvaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR5ylAhsW2plj5omBG7QkFTZXYEbFjzsP9Wm/KlaUCaLtHBDX3CVCRTbVFipgK/336gsUjpN3MLXwHWfyUNJkL5QWcTA0YGtooCae8mYN93vllwPxN3qAKsIfXj94NCIp8Bbz+yTrZ1IJkX9cDRyiBkrGMSq8nVDA9A5ISRDSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15ZSZyKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15ZSZyKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E37C116B1;
	Wed,  3 Dec 2025 16:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780536;
	bh=2Aj9SoZ5b2rWQV+WT7xPUimDe9Q7hODzFXuTiJPFvaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15ZSZyKB9oluzh60OMl7cFoVd9fydYgg2LJc4WCHDo/bjHqK5YKtYDfxvwHQnAEr3
	 6VKLh1AukDp7yVY2O97uSYoP+SRqf06JEIHHNqwM2/Y/+vVWbtLS9O6/rPEjTdF9+P
	 q7PiOveoJ7GWl0IX966hZhURx8q8s+sRXTR+bL3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carol Soto <csoto@nvidia.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/132] net: aquantia: Add missing descriptor cache invalidation on ATL2
Date: Wed,  3 Dec 2025 16:28:15 +0100
Message-ID: <20251203152343.898763797@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai-Heng Feng <kaihengf@nvidia.com>

[ Upstream commit 7526183cfdbe352c51c285762f0e15b7c428ea06 ]

ATL2 hardware was missing descriptor cache invalidation in hw_stop(),
causing SMMU translation faults during device shutdown and module removal:
[   70.355743] arm-smmu-v3 arm-smmu-v3.5.auto: event 0x10 received:
[   70.361893] arm-smmu-v3 arm-smmu-v3.5.auto:  0x0002060000000010
[   70.367948] arm-smmu-v3 arm-smmu-v3.5.auto:  0x0000020000000000
[   70.374002] arm-smmu-v3 arm-smmu-v3.5.auto:  0x00000000ff9bc000
[   70.380055] arm-smmu-v3 arm-smmu-v3.5.auto:  0x0000000000000000
[   70.386109] arm-smmu-v3 arm-smmu-v3.5.auto: event: F_TRANSLATION client: 0001:06:00.0 sid: 0x20600 ssid: 0x0 iova: 0xff9bc000 ipa: 0x0
[   70.398531] arm-smmu-v3 arm-smmu-v3.5.auto: unpriv data write s1 "Input address caused fault" stag: 0x0

Commit 7a1bb49461b1 ("net: aquantia: fix potential IOMMU fault after
driver unbind") and commit ed4d81c4b3f2 ("net: aquantia: when cleaning
hw cache it should be toggled") fixed cache invalidation for ATL B0, but
ATL2 was left with only interrupt disabling. This allowed hardware to
write to cached descriptors after DMA memory was unmapped, triggering
SMMU faults. Once cache invalidation is applied to ATL2, the translation
fault can't be observed anymore.

Add shared aq_hw_invalidate_descriptor_cache() helper and use it in both
ATL B0 and ATL2 hw_stop() implementations for consistent behavior.

Fixes: e54dcf4bba3e ("net: atlantic: basic A2 init/deinit hw_ops")
Tested-by: Carol Soto <csoto@nvidia.com>
Signed-off-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251120041537.62184-1-kaihengf@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/aq_hw_utils.c  | 22 +++++++++++++++++++
 .../ethernet/aquantia/atlantic/aq_hw_utils.h  |  1 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 19 +---------------
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       |  2 +-
 4 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 1921741f7311d..18b08277d2e1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -15,6 +15,7 @@
 
 #include "aq_hw.h"
 #include "aq_nic.h"
+#include "hw_atl/hw_atl_llh.h"
 
 void aq_hw_write_reg_bit(struct aq_hw_s *aq_hw, u32 addr, u32 msk,
 			 u32 shift, u32 val)
@@ -81,6 +82,27 @@ void aq_hw_write_reg64(struct aq_hw_s *hw, u32 reg, u64 value)
 		lo_hi_writeq(value, hw->mmio + reg);
 }
 
+int aq_hw_invalidate_descriptor_cache(struct aq_hw_s *hw)
+{
+	int err;
+	u32 val;
+
+	/* Invalidate Descriptor Cache to prevent writing to the cached
+	 * descriptors and to the data pointer of those descriptors
+	 */
+	hw_atl_rdm_rx_dma_desc_cache_init_tgl(hw);
+
+	err = aq_hw_err_from_flags(hw);
+	if (err)
+		goto err_exit;
+
+	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
+				  hw, val, val == 1, 1000U, 10000U);
+
+err_exit:
+	return err;
+}
+
 int aq_hw_err_from_flags(struct aq_hw_s *hw)
 {
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
index ffa6e4067c211..d89c63d88e4a4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.h
@@ -35,6 +35,7 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg);
 void aq_hw_write_reg(struct aq_hw_s *hw, u32 reg, u32 value);
 u64 aq_hw_read_reg64(struct aq_hw_s *hw, u32 reg);
 void aq_hw_write_reg64(struct aq_hw_s *hw, u32 reg, u64 value);
+int aq_hw_invalidate_descriptor_cache(struct aq_hw_s *hw);
 int aq_hw_err_from_flags(struct aq_hw_s *hw);
 int aq_hw_num_tcs(struct aq_hw_s *hw);
 int aq_hw_q_per_tc(struct aq_hw_s *hw);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 56c46266bb0ae..3a0b6d65d5fca 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1198,26 +1198,9 @@ static int hw_atl_b0_hw_interrupt_moderation_set(struct aq_hw_s *self)
 
 static int hw_atl_b0_hw_stop(struct aq_hw_s *self)
 {
-	int err;
-	u32 val;
-
 	hw_atl_b0_hw_irq_disable(self, HW_ATL_B0_INT_MASK);
 
-	/* Invalidate Descriptor Cache to prevent writing to the cached
-	 * descriptors and to the data pointer of those descriptors
-	 */
-	hw_atl_rdm_rx_dma_desc_cache_init_tgl(self);
-
-	err = aq_hw_err_from_flags(self);
-
-	if (err)
-		goto err_exit;
-
-	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
-				  self, val, val == 1, 1000U, 10000U);
-
-err_exit:
-	return err;
+	return aq_hw_invalidate_descriptor_cache(self);
 }
 
 int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self, struct aq_ring_s *ring)
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index b0ed572e88c67..0ce9caae8799c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -759,7 +759,7 @@ static int hw_atl2_hw_stop(struct aq_hw_s *self)
 {
 	hw_atl_b0_hw_irq_disable(self, HW_ATL2_INT_MASK);
 
-	return 0;
+	return aq_hw_invalidate_descriptor_cache(self);
 }
 
 static struct aq_stats_s *hw_atl2_utils_get_hw_stats(struct aq_hw_s *self)
-- 
2.51.0



