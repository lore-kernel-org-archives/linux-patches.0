Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F85A1E22E6;
	Mon, 23 Jun 2025 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716419; cv=none; b=fnthIbNGMmvi+lc8M9WXCQjDRZvK/vUP61u7x5z5GYVcBUYg1YE3HQ5AwPJaTQwrt1z0HiNkRG7DtpcOz/4EkRx0bQR65SsMPw4sw8fssdMEnbFisI9Pi/Q6ovTi+SetLBKZQGrLJ+WUoxb+oOeKNXQiLs6kw9bGfwi90jfHLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716419; c=relaxed/simple;
	bh=z7XQ/OC366l9gJvKJHWBbC8qpSHv9LYhlSxLzJQZtI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRnDEBRCZcpWhA9FTwVB45vp/7+6oJIQ1bFsImyYRrkJju4763VgR9PH9wP+fug+Vbfb2x1fCIz72F4XXP7aok3G6X2dFR/8iYz9H/2G160RgGPPgefu+QQPJWY4STIj76d3+dSePCrmjsyZUtsseUU0NQPGYiXxwmxYcwAif2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kkfk59E3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kkfk59E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B31C4CEEA;
	Mon, 23 Jun 2025 22:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716419;
	bh=z7XQ/OC366l9gJvKJHWBbC8qpSHv9LYhlSxLzJQZtI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kkfk59E3ADqX5Yl+zmpVp530tKw7wAub53AjC/H/p5xxCmyGBerXnuID5mpv8Cm5O
	 HdiV9y+b3mAYX3RAZ8tPZ+J7M32pH6jicPskL27fW/NFBM6tJVJ4MXFMkTVML7/ebH
	 ogfDB4ncDC9v0nZd1gwcMOZDinN/PlP/LeavNI8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Clayton Craft <clayton@craftyguy.net>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 301/508] wifi: ath11k: fix rx completion meta data corruption
Date: Mon, 23 Jun 2025 15:05:46 +0200
Message-ID: <20250623130652.707819576@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit ab52e3e44fe9b666281752e2481d11e25b0e3fdd upstream.

Add the missing memory barrier to make sure that the REO dest ring
descriptor is read after the head pointer to avoid using stale data on
weakly ordered architectures like aarch64.

This may fix the ring-buffer corruption worked around by commit
f9fff67d2d7c ("wifi: ath11k: Fix SKB corruption in REO destination
ring") by silently discarding data, and may possibly also address user
reported errors like:

	ath11k_pci 0006:01:00.0: msdu_done bit in attention is not set

Tested-on: WCN6855 hw2.1 WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org	# 5.6
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218005
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Clayton Craft <clayton@craftyguy.net>
Link: https://patch.msgid.link/20250321145302.4775-1-johan+linaro@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2648,7 +2648,7 @@ int ath11k_dp_process_rx(struct ath11k_b
 	struct ath11k *ar;
 	struct hal_reo_dest_ring *desc;
 	enum hal_reo_dest_ring_push_reason push_reason;
-	u32 cookie;
+	u32 cookie, info0, rx_msdu_info0, rx_mpdu_info0;
 	int i;
 
 	for (i = 0; i < MAX_RADIOS; i++)
@@ -2661,11 +2661,14 @@ int ath11k_dp_process_rx(struct ath11k_b
 try_again:
 	ath11k_hal_srng_access_begin(ab, srng);
 
+	/* Make sure descriptor is read after the head pointer. */
+	dma_rmb();
+
 	while (likely(desc =
 	      (struct hal_reo_dest_ring *)ath11k_hal_srng_dst_get_next_entry(ab,
 									     srng))) {
 		cookie = FIELD_GET(BUFFER_ADDR_INFO1_SW_COOKIE,
-				   desc->buf_addr_info.info1);
+				   READ_ONCE(desc->buf_addr_info.info1));
 		buf_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_BUF_ID,
 				   cookie);
 		mac_id = FIELD_GET(DP_RXDMA_BUF_COOKIE_PDEV_ID, cookie);
@@ -2694,8 +2697,9 @@ try_again:
 
 		num_buffs_reaped[mac_id]++;
 
+		info0 = READ_ONCE(desc->info0);
 		push_reason = FIELD_GET(HAL_REO_DEST_RING_INFO0_PUSH_REASON,
-					desc->info0);
+					info0);
 		if (unlikely(push_reason !=
 			     HAL_REO_DEST_RING_PUSH_REASON_ROUTING_INSTRUCTION)) {
 			dev_kfree_skb_any(msdu);
@@ -2703,18 +2707,21 @@ try_again:
 			continue;
 		}
 
-		rxcb->is_first_msdu = !!(desc->rx_msdu_info.info0 &
+		rx_msdu_info0 = READ_ONCE(desc->rx_msdu_info.info0);
+		rx_mpdu_info0 = READ_ONCE(desc->rx_mpdu_info.info0);
+
+		rxcb->is_first_msdu = !!(rx_msdu_info0 &
 					 RX_MSDU_DESC_INFO0_FIRST_MSDU_IN_MPDU);
-		rxcb->is_last_msdu = !!(desc->rx_msdu_info.info0 &
+		rxcb->is_last_msdu = !!(rx_msdu_info0 &
 					RX_MSDU_DESC_INFO0_LAST_MSDU_IN_MPDU);
-		rxcb->is_continuation = !!(desc->rx_msdu_info.info0 &
+		rxcb->is_continuation = !!(rx_msdu_info0 &
 					   RX_MSDU_DESC_INFO0_MSDU_CONTINUATION);
 		rxcb->peer_id = FIELD_GET(RX_MPDU_DESC_META_DATA_PEER_ID,
-					  desc->rx_mpdu_info.meta_data);
+					  READ_ONCE(desc->rx_mpdu_info.meta_data));
 		rxcb->seq_no = FIELD_GET(RX_MPDU_DESC_INFO0_SEQ_NUM,
-					 desc->rx_mpdu_info.info0);
+					 rx_mpdu_info0);
 		rxcb->tid = FIELD_GET(HAL_REO_DEST_RING_INFO0_RX_QUEUE_NUM,
-				      desc->info0);
+				      info0);
 
 		rxcb->mac_id = mac_id;
 		__skb_queue_tail(&msdu_list[mac_id], msdu);


