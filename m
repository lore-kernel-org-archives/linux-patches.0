Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96FF1917EC;
	Tue, 30 Jul 2024 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356168; cv=none; b=G8ixIYJL/zdk5vhaRvll7YvEKQUujP8ZzP2CRU0F+GAayhvzBA+Sked8m1MH8CTwXha4VZW0GF/6FD0m/mkmPJtMZfO50ADniwoiq8fjkLBV2XZ8/NQJXAEcpZQi7nCzeX0gKpyrVNGUwo3Djq2hxuzEfAjS/DCWTVFWdSEK118=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356168; c=relaxed/simple;
	bh=iPcodd5ejGTo2aII8bjhhP2KsSXc7oRLuDZlolU49pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI1GLkT470u1TetCc5ysQ83zfZjGhXt7UHNUifSPqdXi8ikmvYzpMwsZHnaEE+hyr4BISp5qzKFs5vDae4THxjfbtePgdTmHjqLoApEyWojWKmuSfIezEY/fku+LVRf6k9fg57Jtmfm04+0DgUR0BLrEOw+bg7YQ69saCCjw4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+IkqSrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+IkqSrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69804C32782;
	Tue, 30 Jul 2024 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356167;
	bh=iPcodd5ejGTo2aII8bjhhP2KsSXc7oRLuDZlolU49pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+IkqSrLh7/OI2TrmC/ym8AN/Td5nyhUBApiq4XfDAfpT50QtrVZlYcyWKpnYA4KS
	 AkkEn0LfSlFQOwiwzcfgjpm+shrX06fCfIXcZ9lLNjcMwozCniFbyT5O0FImTfb1yE
	 QEv2t8PXLQdkebNfkLAAFEVVWS3dKH5618P9MKio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/568] wifi: ath11k: fix wrong definition of CE rings base address
Date: Tue, 30 Jul 2024 17:43:47 +0200
Message-ID: <20240730151644.567159601@linuxfoundation.org>
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

[ Upstream commit 5714e25f1d1875b300fb337dadfaa75324c1161a ]

Base address of CE ring is defined as u32, currently this works
because coherent DMA mask configured as 32 bit:

	#define ATH11K_PCI_COHERENT_DMA_MASK	32

However this mask could be changed once firmware bugs are fixed
to fully support 36 bit DMA addressing. So to protect against any
future changes to the DMA mask, change the type of the fields that
are dependent upon it.

This is found during code review. Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240524021558.34452-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ce.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ce.h b/drivers/net/wireless/ath/ath11k/ce.h
index 69946fc700777..bcde2fcf02cf7 100644
--- a/drivers/net/wireless/ath/ath11k/ce.h
+++ b/drivers/net/wireless/ath/ath11k/ce.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef ATH11K_CE_H
@@ -146,7 +146,7 @@ struct ath11k_ce_ring {
 	/* Host address space */
 	void *base_addr_owner_space_unaligned;
 	/* CE address space */
-	u32 base_addr_ce_space_unaligned;
+	dma_addr_t base_addr_ce_space_unaligned;
 
 	/* Actual start of descriptors.
 	 * Aligned to descriptor-size boundary.
@@ -156,7 +156,7 @@ struct ath11k_ce_ring {
 	void *base_addr_owner_space;
 
 	/* CE address space */
-	u32 base_addr_ce_space;
+	dma_addr_t base_addr_ce_space;
 
 	/* HAL ring id */
 	u32 hal_ring_id;
-- 
2.43.0



