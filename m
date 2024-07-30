Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39ED1A6197;
	Tue, 30 Jul 2024 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356659; cv=none; b=RiXxllz0b21w20m3pX9BkL9Y71TMoY7iTY6/xvQg0RTzKvVw/kVXshHe0jmxud1Du2ro3QLrPfz1/S/MO/U2af+d30Q6pC9G/XC4e7kVlSHnkeMJLmdFS9gUiTy6w3fleYAt1NCnZbLjH17DqwZnx52g2yFqqCUyW8WrwGimGP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356659; c=relaxed/simple;
	bh=cIOLMUfh4SlfhB8yQI5k63AHoBzZIP/LFlCDwtubUow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd1j4GJ5CwkQdGTAx0wQUJ9r0YihSwBouE+2hNRmGEbuBO/82SOpaSMJ8nD2snsTd5FBeU3CkbUK5vhHhe6W9tWki1G5wJ6M6PcP5iPMfc7AMThIoigGE2uBQi24aL03BYpRgowSH9RM+vYUJ84X2PSHYLTGAc/Z001I2Rmgbn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDk+pB6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDk+pB6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F3FC32782;
	Tue, 30 Jul 2024 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356659;
	bh=cIOLMUfh4SlfhB8yQI5k63AHoBzZIP/LFlCDwtubUow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fDk+pB6O4HBH/+4CT1FTHMvAGnMtvH5GziAWJNom6m3qgOZoHjOZS62m+HWcznI38
	 rwXcKprMQnA/+UDWVH6Q8GDhQUb79E0uzlmh99mn/w+03pyrQtQ1ac+ZOyLdZLQfKx
	 Xc84nidsXbkIeB97Zn0K2MTDFTIpkKCMenNuApVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 171/809] wifi: ath12k: fix wrong definition of CE rings base address
Date: Tue, 30 Jul 2024 17:40:47 +0200
Message-ID: <20240730151731.359706039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



