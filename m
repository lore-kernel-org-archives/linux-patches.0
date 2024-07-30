Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6A71A6185;
	Tue, 30 Jul 2024 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356179; cv=none; b=qCSDPJcHHpraubq8+rnb6xQxroh24qiVr8U12eUcPiU/F/efqQeW/oxOnYZ/kIiBqhM73PTfo6dtS281kxWHGmOhHLgEO13MaKWe8+FoLTRuAhvTCnO4HtyZtT6Z2bRZxqCN5pVUrTuszaLYRETywesh8+bPCrtL4W7ScMNJf90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356179; c=relaxed/simple;
	bh=h2AyTB45vx5efZpCP6tuvHndhsLihurGnHEKshsyi00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5Sk8HpA8/YFkP7eWXGEVK8LSxxDOZ8jrX2NmND5bvI0X0qbcaFvbCdstgBVteM0z8HrudTY3dzEOxjJ2qZxtkvvdWrp6gaF0DO5qTqnTecQDSfJRSuuDn2+vQP04opygjlIxfSXGO8IubDnSkFFdvVG938D/L2PCoFilGDUp2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EGZUzkQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EGZUzkQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15F7C32782;
	Tue, 30 Jul 2024 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356178;
	bh=h2AyTB45vx5efZpCP6tuvHndhsLihurGnHEKshsyi00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGZUzkQ05x/VsO6i5QO2k7s7JmMUEqP1pdO57SGBg7pz+SXVzk+FE6qUX/5F5VJuY
	 M5dbTYt3CMK2S0+x8QUOBu4HsW7nPclDHRNXXbK2Al2s+WXMbYAmXySTrpIiVTITFN
	 xq6y4UU45TqnKFvw9AiHkgEUEA/K+sRV4BAOCUuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/568] wifi: ath12k: fix wrong definition of CE rings base address
Date: Tue, 30 Jul 2024 17:43:48 +0200
Message-ID: <20240730151644.605196579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 0ae570703754858a77cc42b3c9fff42e9f084608 ]

Base address of CE ring is defined as u32, currently this works
because DMA mask configured as 32 bit:

	#define ATH12K_PCI_DMA_MASK	32

However this mask could be changed once firmware bugs are fixed
to fully support 36 bit DMA addressing. So to protect against any
future changes to the DMA mask, change the type of the fields that
are dependent upon it.

This is found during code review. Compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240524024021.37711-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ce.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.h b/drivers/net/wireless/ath/ath12k/ce.h
index 79af3b6159f1c..857bc5f9e946a 100644
--- a/drivers/net/wireless/ath/ath12k/ce.h
+++ b/drivers/net/wireless/ath/ath12k/ce.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef ATH12K_CE_H
@@ -119,7 +119,7 @@ struct ath12k_ce_ring {
 	/* Host address space */
 	void *base_addr_owner_space_unaligned;
 	/* CE address space */
-	u32 base_addr_ce_space_unaligned;
+	dma_addr_t base_addr_ce_space_unaligned;
 
 	/* Actual start of descriptors.
 	 * Aligned to descriptor-size boundary.
@@ -129,7 +129,7 @@ struct ath12k_ce_ring {
 	void *base_addr_owner_space;
 
 	/* CE address space */
-	u32 base_addr_ce_space;
+	dma_addr_t base_addr_ce_space;
 
 	/* HAL ring id */
 	u32 hal_ring_id;
-- 
2.43.0



