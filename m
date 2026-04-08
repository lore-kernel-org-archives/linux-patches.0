Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66462494F0;
	Wed,  8 Apr 2026 18:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672450; cv=none; b=K8NvcKa5Rhjf9jehz2bxGqa4ZjtGfHCGISMhSf+H+4a5+3ZP9H7F3XlMeBboVqgCepy75sTobaMimigsRKgrfgNuCOmq1lNqdFlCkbdGwezEPZBEcNqujX0lcTEQK9fwETq0ntV9/xLeBkLqkAg27+DAfySshESco3UmliOuW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672450; c=relaxed/simple;
	bh=YgjV0SYYhWe8ijF/DNn77QGcD0sqfIZvW/8ZgZwYOY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJE6JRhR8Su/kPQW2Jmo/U0M4KU318g8h9ZMvLm/cFbKVTqssV93XM0rKxIDCQRe8cRn9MP1NCqNiFOrp0PT8pQjryFBhp0nX1Y+uIodFu7WJZSAYntdnqP1VHFmh2/36URzN0LoO0m2a7DWGfgLg7jbeRElgIXES2V9CZi4C+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nzlswp2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nzlswp2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C521C19421;
	Wed,  8 Apr 2026 18:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672449;
	bh=YgjV0SYYhWe8ijF/DNn77QGcD0sqfIZvW/8ZgZwYOY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nzlswp2wMKpOU4ODeQwgZip8jK7M4YB69ic49+6jpRVxhHUDEftnjWNa76+kB2d6a
	 MzzVomffDbo1+K82FT5PXiC7UdDqLQ4H3gmJXCe8eGERIUNx2LExIbOI2NR1uixJIr
	 Wgtr3q9ukwXvqBX3wc74U/lpwUVcO0LiNn77s3uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkateswara Naralasetty <quic_vnaralas@quicinc.com>,
	Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/160] wifi: ath11k: skip status ring entry processing
Date: Wed,  8 Apr 2026 20:01:39 +0200
Message-ID: <20260408175913.654571214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkateswara Naralasetty <quic_vnaralas@quicinc.com>

[ Upstream commit 4c2b796be3a12a11ab611917fafdabc9d3862a1d ]

If STATUS_BUFFER_DONE is not set for a monitor status ring entry,
we don't process the status ring until STATUS_BUFFER_DONE set
for that status ring entry.

During LMAC reset it may happen that hardware will not write
STATUS_BUFFER_DONE tlv in status buffer, in that case we end up
waiting for STATUS_BUFFER_DONE leading to backpressure on monitor
status ring.

To fix the issue, when HP (Head Pointer) + 1 entry is peeked and if DMA is not
done and if HP + 2 entry's DMA done is set, replenish HP + 1 entry and start
processing in next interrupt. If HP + 2 entry's DMA done is not set, poll onto
HP + 1 entry DMA done to be set.

Also, during monitor attach HP points to the end of the ring and TP (Tail
Pointer) points to the start of the ring.  Using ath11k_hal_srng_src_peek() may
result in processing invalid buffer for the very first interrupt. Since, HW
starts writing buffer from TP.

To avoid this issue call ath11k_hal_srng_src_next_peek() instead of
calling ath11k_hal_srng_src_peek().

Tested-on: IPQ5018 hw1.0 AHB WLAN.HK.2.6.0.1-00861-QCAHKSWPL_SILICONZ-1

Signed-off-by: Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
Co-developed-by: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Signed-off-by: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240429073624.736147-1-quic_tamizhr@quicinc.com
Stable-dep-of: e225b36f83d7 ("wifi: ath11k: Pass the correct value of each TID during a stop AMPDU session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 82 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath11k/hal.c   | 16 ++++-
 drivers/net/wireless/ath/ath11k/hal.h   |  2 +
 3 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index ed1ea61c81420..c37722a727309 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/ieee80211.h>
@@ -2996,11 +2996,52 @@ ath11k_dp_rx_mon_update_status_buf_state(struct ath11k_mon_data *pmon,
 	}
 }
 
+static enum dp_mon_status_buf_state
+ath11k_dp_rx_mon_buf_done(struct ath11k_base *ab, struct hal_srng *srng,
+			  struct dp_rxdma_ring *rx_ring)
+{
+	struct ath11k_skb_rxcb *rxcb;
+	struct hal_tlv_hdr *tlv;
+	struct sk_buff *skb;
+	void *status_desc;
+	dma_addr_t paddr;
+	u32 cookie;
+	int buf_id;
+	u8 rbm;
+
+	status_desc = ath11k_hal_srng_src_next_peek(ab, srng);
+	if (!status_desc)
+		return DP_MON_STATUS_NO_DMA;
+
+	ath11k_hal_rx_buf_addr_info_get(status_desc, &paddr, &cookie, &rbm);
+
+	buf_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_BUF_ID, cookie);
+
+	spin_lock_bh(&rx_ring->idr_lock);
+	skb = idr_find(&rx_ring->bufs_idr, buf_id);
+	spin_unlock_bh(&rx_ring->idr_lock);
+
+	if (!skb)
+		return DP_MON_STATUS_NO_DMA;
+
+	rxcb = ATH11K_SKB_RXCB(skb);
+	dma_sync_single_for_cpu(ab->dev, rxcb->paddr,
+				skb->len + skb_tailroom(skb),
+				DMA_FROM_DEVICE);
+
+	tlv = (struct hal_tlv_hdr *)skb->data;
+	if (FIELD_GET(HAL_TLV_HDR_TAG, tlv->tl) != HAL_RX_STATUS_BUFFER_DONE)
+		return DP_MON_STATUS_NO_DMA;
+
+	return DP_MON_STATUS_REPLINISH;
+}
+
 static int ath11k_dp_rx_reap_mon_status_ring(struct ath11k_base *ab, int mac_id,
 					     int *budget, struct sk_buff_head *skb_list)
 {
 	struct ath11k *ar;
 	const struct ath11k_hw_hal_params *hal_params;
+	enum dp_mon_status_buf_state reap_status;
 	struct ath11k_pdev_dp *dp;
 	struct dp_rxdma_ring *rx_ring;
 	struct ath11k_mon_data *pmon;
@@ -3063,15 +3104,38 @@ static int ath11k_dp_rx_reap_mon_status_ring(struct ath11k_base *ab, int mac_id,
 				ath11k_warn(ab, "mon status DONE not set %lx, buf_id %d\n",
 					    FIELD_GET(HAL_TLV_HDR_TAG,
 						      tlv->tl), buf_id);
-				/* If done status is missing, hold onto status
-				 * ring until status is done for this status
-				 * ring buffer.
-				 * Keep HP in mon_status_ring unchanged,
-				 * and break from here.
-				 * Check status for same buffer for next time
+				/* RxDMA status done bit might not be set even
+				 * though tp is moved by HW.
 				 */
-				pmon->buf_state = DP_MON_STATUS_NO_DMA;
-				break;
+
+				/* If done status is missing:
+				 * 1. As per MAC team's suggestion,
+				 *    when HP + 1 entry is peeked and if DMA
+				 *    is not done and if HP + 2 entry's DMA done
+				 *    is set. skip HP + 1 entry and
+				 *    start processing in next interrupt.
+				 * 2. If HP + 2 entry's DMA done is not set,
+				 *    poll onto HP + 1 entry DMA done to be set.
+				 *    Check status for same buffer for next time
+				 *    dp_rx_mon_status_srng_process
+				 */
+
+				reap_status = ath11k_dp_rx_mon_buf_done(ab, srng,
+									rx_ring);
+				if (reap_status == DP_MON_STATUS_NO_DMA)
+					continue;
+
+				spin_lock_bh(&rx_ring->idr_lock);
+				idr_remove(&rx_ring->bufs_idr, buf_id);
+				spin_unlock_bh(&rx_ring->idr_lock);
+
+				dma_unmap_single(ab->dev, rxcb->paddr,
+						 skb->len + skb_tailroom(skb),
+						 DMA_FROM_DEVICE);
+
+				dev_kfree_skb_any(skb);
+				pmon->buf_state = DP_MON_STATUS_REPLINISH;
+				goto move_next;
 			}
 
 			spin_lock_bh(&rx_ring->idr_lock);
diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index 79cf65bc2e172..b42925f84200c 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #include <linux/dma-mapping.h>
 #include "hal_tx.h"
@@ -783,6 +783,20 @@ u32 *ath11k_hal_srng_src_get_next_reaped(struct ath11k_base *ab,
 	return desc;
 }
 
+u32 *ath11k_hal_srng_src_next_peek(struct ath11k_base *ab, struct hal_srng *srng)
+{
+	u32 next_hp;
+
+	lockdep_assert_held(&srng->lock);
+
+	next_hp = (srng->u.src_ring.hp + srng->entry_size) % srng->ring_size;
+
+	if (next_hp != srng->u.src_ring.cached_tp)
+		return srng->ring_base_vaddr + next_hp;
+
+	return NULL;
+}
+
 u32 *ath11k_hal_srng_src_peek(struct ath11k_base *ab, struct hal_srng *srng)
 {
 	lockdep_assert_held(&srng->lock);
diff --git a/drivers/net/wireless/ath/ath11k/hal.h b/drivers/net/wireless/ath/ath11k/hal.h
index aa21eb1fdce15..494c2b8a12816 100644
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -946,6 +946,8 @@ u32 *ath11k_hal_srng_dst_peek(struct ath11k_base *ab, struct hal_srng *srng);
 int ath11k_hal_srng_dst_num_free(struct ath11k_base *ab, struct hal_srng *srng,
 				 bool sync_hw_ptr);
 u32 *ath11k_hal_srng_src_peek(struct ath11k_base *ab, struct hal_srng *srng);
+u32 *ath11k_hal_srng_src_next_peek(struct ath11k_base *ab,
+				   struct hal_srng *srng);
 u32 *ath11k_hal_srng_src_get_next_reaped(struct ath11k_base *ab,
 					 struct hal_srng *srng);
 u32 *ath11k_hal_srng_src_reap_next(struct ath11k_base *ab,
-- 
2.53.0



