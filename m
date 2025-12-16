Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0132D34A3D8;
	Tue, 16 Dec 2025 11:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885195; cv=none; b=gFp3XoaUEAfcEMW+35/N3cH+SRN7ykOwdMn9Z1jPGTKaERnFNflDYOqL2rtaQW8YXx2BcTejw9wPWAkVb9kq1I9efj0Hymk/32taHe7qiPksCjQVjq8T72k0FnzItezNlcwp54y3mC6wok5ZC2JAxDJSPBVJssSNgoKS0OEf5Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885195; c=relaxed/simple;
	bh=RkySe3zeeo6U8ASdW4A+D3z63blb6qrTycpZyJBSZts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEzRi4Xoz+inTGisHsTOvMqc/dDXTWMqUAQ22gvOn+ypmL/q6G94hRZDE5Iz8DNFyUCWM4BPw/X0L7346TTE1cqOXOpjLGZDuuu9TWwceP7LBVCHEXYABs1VQox4E52RE/UOeAR+hQ/5WABoJFclLV448L02KPuwA/FxJNbbNFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txgoPWTc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txgoPWTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70462C4CEF1;
	Tue, 16 Dec 2025 11:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885194;
	bh=RkySe3zeeo6U8ASdW4A+D3z63blb6qrTycpZyJBSZts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txgoPWTce9i9O3f4PxT1TNw2uZLuFkG0Gie6a9lmpgR/IlnxoNHa8Ohqd+lZ19yBv
	 aiFobuHs+2boIIQ7tYjdlvt9NrAQtwO19RC18CMHfiuO0g6/D5WWfMN1Kinn4Kpbxe
	 bh6PyFmfDQAUSrI10clzuFNRyZ0QNS64ti1ufDg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <sarika.sharma@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 034/507] wifi: ath12k: Fix MSDU buffer types handling in RX error path
Date: Tue, 16 Dec 2025 12:07:55 +0100
Message-ID: <20251216111346.774562977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <sarika.sharma@oss.qualcomm.com>

[ Upstream commit 36f9edbb9d0fc36c865c74f3c1ad8e1261ad3981 ]

Currently, packets received on the REO exception ring from
unassociated peers are of MSDU buffer type, while the driver expects
link descriptor type packets. These packets are not parsed further due
to a return check on packet type in ath12k_hal_desc_reo_parse_err(),
but the associated skb is not freed. This may lead to kernel
crashes and buffer leaks.

Hence to fix, update the RX error handler to explicitly drop
MSDU buffer type packets received on the REO exception ring.
This prevents further processing of invalid packets and ensures
stability in the RX error handling path.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250930091551.3305312-2-sarika.sharma@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c  | 70 ++++++++++++++++++++++--
 drivers/net/wireless/ath/ath12k/hal_rx.c | 10 +---
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 9048818984f19..0be911b4f3166 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/ieee80211.h>
@@ -3690,6 +3690,48 @@ ath12k_dp_process_rx_err_buf(struct ath12k *ar, struct hal_reo_dest_ring *desc,
 	return 0;
 }
 
+static int ath12k_dp_h_msdu_buffer_type(struct ath12k_base *ab,
+					struct list_head *list,
+					struct hal_reo_dest_ring *desc)
+{
+	struct ath12k_rx_desc_info *desc_info;
+	struct ath12k_skb_rxcb *rxcb;
+	struct sk_buff *msdu;
+	u64 desc_va;
+
+	desc_va = (u64)le32_to_cpu(desc->buf_va_hi) << 32 |
+		  le32_to_cpu(desc->buf_va_lo);
+	desc_info = (struct ath12k_rx_desc_info *)(uintptr_t)desc_va;
+	if (!desc_info) {
+		u32 cookie;
+
+		cookie = le32_get_bits(desc->buf_addr_info.info1,
+				       BUFFER_ADDR_INFO1_SW_COOKIE);
+		desc_info = ath12k_dp_get_rx_desc(ab, cookie);
+		if (!desc_info) {
+			ath12k_warn(ab, "Invalid cookie in manual descriptor retrieval: 0x%x\n",
+				    cookie);
+			return -EINVAL;
+		}
+	}
+
+	if (desc_info->magic != ATH12K_DP_RX_DESC_MAGIC) {
+		ath12k_warn(ab, "rx exception, magic check failed with value: %u\n",
+			    desc_info->magic);
+		return -EINVAL;
+	}
+
+	msdu = desc_info->skb;
+	desc_info->skb = NULL;
+	list_add_tail(&desc_info->list, list);
+	rxcb = ATH12K_SKB_RXCB(msdu);
+	dma_unmap_single(ab->dev, rxcb->paddr, msdu->len + skb_tailroom(msdu),
+			 DMA_FROM_DEVICE);
+	dev_kfree_skb_any(msdu);
+
+	return 0;
+}
+
 int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 			     int budget)
 {
@@ -3734,6 +3776,26 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 		drop = false;
 		ab->device_stats.err_ring_pkts++;
 
+		hw_link_id = le32_get_bits(reo_desc->info0,
+					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
+		device_id = hw_links[hw_link_id].device_id;
+		partner_ab = ath12k_ag_to_ab(ag, device_id);
+
+		/* Below case is added to handle data packet from un-associated clients.
+		 * As it is expected that AST lookup will fail for
+		 * un-associated station's data packets.
+		 */
+		if (le32_get_bits(reo_desc->info0, HAL_REO_DEST_RING_INFO0_BUFFER_TYPE) ==
+		    HAL_REO_DEST_RING_BUFFER_TYPE_MSDU) {
+			if (!ath12k_dp_h_msdu_buffer_type(partner_ab,
+							  &rx_desc_used_list[device_id],
+							  reo_desc)) {
+				num_buffs_reaped[device_id]++;
+				tot_n_bufs_reaped++;
+			}
+			goto next_desc;
+		}
+
 		ret = ath12k_hal_desc_reo_parse_err(ab, reo_desc, &paddr,
 						    &desc_bank);
 		if (ret) {
@@ -3742,11 +3804,6 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 			continue;
 		}
 
-		hw_link_id = le32_get_bits(reo_desc->info0,
-					   HAL_REO_DEST_RING_INFO0_SRC_LINK_ID);
-		device_id = hw_links[hw_link_id].device_id;
-		partner_ab = ath12k_ag_to_ab(ag, device_id);
-
 		pdev_id = ath12k_hw_mac_id_to_pdev_id(partner_ab->hw_params,
 						      hw_links[hw_link_id].pdev_idx);
 		ar = partner_ab->pdevs[pdev_id].ar;
@@ -3795,6 +3852,7 @@ int ath12k_dp_rx_process_err(struct ath12k_base *ab, struct napi_struct *napi,
 			}
 		}
 
+next_desc:
 		if (tot_n_bufs_reaped >= quota) {
 			tot_n_bufs_reaped = quota;
 			goto exit;
diff --git a/drivers/net/wireless/ath/ath12k/hal_rx.c b/drivers/net/wireless/ath/ath12k/hal_rx.c
index 48aa48c48606a..805c31e4243db 100644
--- a/drivers/net/wireless/ath/ath12k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/hal_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include "debug.h"
@@ -320,7 +320,7 @@ int ath12k_hal_desc_reo_parse_err(struct ath12k_base *ab,
 {
 	enum hal_reo_dest_ring_push_reason push_reason;
 	enum hal_reo_dest_ring_error_code err_code;
-	u32 cookie, val;
+	u32 cookie;
 
 	push_reason = le32_get_bits(desc->info0,
 				    HAL_REO_DEST_RING_INFO0_PUSH_REASON);
@@ -335,12 +335,6 @@ int ath12k_hal_desc_reo_parse_err(struct ath12k_base *ab,
 		return -EINVAL;
 	}
 
-	val = le32_get_bits(desc->info0, HAL_REO_DEST_RING_INFO0_BUFFER_TYPE);
-	if (val != HAL_REO_DEST_RING_BUFFER_TYPE_LINK_DESC) {
-		ath12k_warn(ab, "expected buffer type link_desc");
-		return -EINVAL;
-	}
-
 	ath12k_hal_rx_reo_ent_paddr_get(ab, &desc->buf_addr_info, paddr, &cookie);
 	*desc_bank = u32_get_bits(cookie, DP_LINK_DESC_BANK_MASK);
 
-- 
2.51.0



