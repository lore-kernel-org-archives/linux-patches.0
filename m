Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B830743AB6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdrrcmfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFA2C433BD;
	Wed, 15 Nov 2023 20:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081254;
	bh=Y1Yxr89r+C1RFGQLjbGCKBeyTHElnKDsyt9h0IGOAGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdrrcmfJN+NPQAgq3L+xvZVtboBhNkyteQ8SJ4gG9pNYjAC3ghm8Wyw/v3/00j/bH
	 xKXTKJwB2sTE6EtlJKw/nMHZOgljzqZteDnRWzwo+UH6nTvAgSPEV2RQvce+ueSgsw
	 zFTzujZ2hjc5ju2iYJCQG2eB5XPssOyMYWylLzbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/244] iwlwifi: pcie: adjust to Bz completion descriptor
Date: Wed, 15 Nov 2023 15:33:55 -0500
Message-ID: <20231115203550.957335545@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5d19e2087fea28651eff7eadf4510fa1564688a2 ]

The Bz devices got a new completion descriptor again since
we only ever really used 4 out of 32 bytes anyway. Adjust
the code to deal with that. Note that the intention was to
reduce the size, but the hardware was implemented wrongly.

While at it, do some cleanups and remove the union to simplify
the code, clean up iwl_pcie_free_bd_size() to no longer need
an argument and add iwl_pcie_used_bd_size() with the logic to
selct completion descriptor size.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220204122220.bef461a04110.I90c8885550fa54eb0aaa4363d322f50e301175a6@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Stable-dep-of: 37fb29bd1f90 ("wifi: iwlwifi: pcie: synchronize IRQs before NAPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    | 20 +++++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 56 ++++++++++++-------
 2 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 6dce36d326935..775ee03e5b128 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2003-2015, 2018-2021 Intel Corporation
+ * Copyright (C) 2003-2015, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -103,6 +103,18 @@ struct iwl_rx_completion_desc {
 	u8 reserved2[25];
 } __packed;
 
+/**
+ * struct iwl_rx_completion_desc_bz - Bz completion descriptor
+ * @rbid: unique tag of the received buffer
+ * @flags: flags (0: fragmented, all others: reserved)
+ * @reserved: reserved
+ */
+struct iwl_rx_completion_desc_bz {
+	__le16 rbid;
+	u8 flags;
+	u8 reserved[1];
+} __packed;
+
 /**
  * struct iwl_rxq - Rx queue
  * @id: queue index
@@ -133,11 +145,7 @@ struct iwl_rxq {
 	int id;
 	void *bd;
 	dma_addr_t bd_dma;
-	union {
-		void *used_bd;
-		__le32 *bd_32;
-		struct iwl_rx_completion_desc *cd;
-	};
+	void *used_bd;
 	dma_addr_t used_bd_dma;
 	u32 read;
 	u32 write;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index f82fb17450165..74b4280221e0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -652,23 +652,30 @@ void iwl_pcie_rx_allocator_work(struct work_struct *data)
 	iwl_pcie_rx_allocator(trans_pcie->trans);
 }
 
-static int iwl_pcie_free_bd_size(struct iwl_trans *trans, bool use_rx_td)
+static int iwl_pcie_free_bd_size(struct iwl_trans *trans)
 {
-	struct iwl_rx_transfer_desc *rx_td;
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+		return sizeof(struct iwl_rx_transfer_desc);
 
-	if (use_rx_td)
-		return sizeof(*rx_td);
-	else
-		return trans->trans_cfg->mq_rx_supported ? sizeof(__le64) :
-			sizeof(__le32);
+	return trans->trans_cfg->mq_rx_supported ?
+			sizeof(__le64) : sizeof(__le32);
+}
+
+static int iwl_pcie_used_bd_size(struct iwl_trans *trans)
+{
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
+		return sizeof(struct iwl_rx_completion_desc_bz);
+
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
+		return sizeof(struct iwl_rx_completion_desc);
+
+	return sizeof(__le32);
 }
 
 static void iwl_pcie_free_rxq_dma(struct iwl_trans *trans,
 				  struct iwl_rxq *rxq)
 {
-	bool use_rx_td = (trans->trans_cfg->device_family >=
-			  IWL_DEVICE_FAMILY_AX210);
-	int free_size = iwl_pcie_free_bd_size(trans, use_rx_td);
+	int free_size = iwl_pcie_free_bd_size(trans);
 
 	if (rxq->bd)
 		dma_free_coherent(trans->dev,
@@ -682,8 +689,8 @@ static void iwl_pcie_free_rxq_dma(struct iwl_trans *trans,
 
 	if (rxq->used_bd)
 		dma_free_coherent(trans->dev,
-				  (use_rx_td ? sizeof(*rxq->cd) :
-				   sizeof(__le32)) * rxq->queue_size,
+				  iwl_pcie_used_bd_size(trans) *
+					rxq->queue_size,
 				  rxq->used_bd, rxq->used_bd_dma);
 	rxq->used_bd_dma = 0;
 	rxq->used_bd = NULL;
@@ -707,7 +714,7 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 	else
 		rxq->queue_size = RX_QUEUE_SIZE;
 
-	free_size = iwl_pcie_free_bd_size(trans, use_rx_td);
+	free_size = iwl_pcie_free_bd_size(trans);
 
 	/*
 	 * Allocate the circular buffer of Read Buffer Descriptors
@@ -720,7 +727,8 @@ static int iwl_pcie_alloc_rxq_dma(struct iwl_trans *trans,
 
 	if (trans->trans_cfg->mq_rx_supported) {
 		rxq->used_bd = dma_alloc_coherent(dev,
-						  (use_rx_td ? sizeof(*rxq->cd) : sizeof(__le32)) * rxq->queue_size,
+						  iwl_pcie_used_bd_size(trans) *
+							rxq->queue_size,
 						  &rxq->used_bd_dma,
 						  GFP_KERNEL);
 		if (!rxq->used_bd)
@@ -1419,6 +1427,7 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 	u16 vid;
 
 	BUILD_BUG_ON(sizeof(struct iwl_rx_completion_desc) != 32);
+	BUILD_BUG_ON(sizeof(struct iwl_rx_completion_desc_bz) != 4);
 
 	if (!trans->trans_cfg->mq_rx_supported) {
 		rxb = rxq->queue[i];
@@ -1426,11 +1435,20 @@ static struct iwl_rx_mem_buffer *iwl_pcie_get_rxb(struct iwl_trans *trans,
 		return rxb;
 	}
 
-	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
-		vid = le16_to_cpu(rxq->cd[i].rbid);
-		*join = rxq->cd[i].flags & IWL_RX_CD_FLAGS_FRAGMENTED;
+	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
+		struct iwl_rx_completion_desc_bz *cd = rxq->used_bd;
+
+		vid = le16_to_cpu(cd[i].rbid);
+		*join = cd[i].flags & IWL_RX_CD_FLAGS_FRAGMENTED;
+	} else if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
+		struct iwl_rx_completion_desc *cd = rxq->used_bd;
+
+		vid = le16_to_cpu(cd[i].rbid);
+		*join = cd[i].flags & IWL_RX_CD_FLAGS_FRAGMENTED;
 	} else {
-		vid = le32_to_cpu(rxq->bd_32[i]) & 0x0FFF; /* 12-bit VID */
+		__le32 *cd = rxq->used_bd;
+
+		vid = le32_to_cpu(cd[i]) & 0x0FFF; /* 12-bit VID */
 	}
 
 	if (!vid || vid > RX_POOL_SIZE(trans_pcie->num_rx_bufs))
-- 
2.42.0



