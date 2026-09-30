Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F47F3B42C0;
	Wed, 30 Sep 2026 18:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794286; cv=none; b=muesvBvW1/T4DiQ/BfnVrrfBoer378H+McX8lErSsR3wHYcE5PJ4eN8R0umw7JiK+bwlT+fz10yFctp+k3/L1faw4vq2ruT5wz0CzI4yj8aDdSK0bZUF8/gb561ge5IsH+sxU1zmG9iJhoaSXq8nhOJdPpLzQtkjnZ+Tj9UiuKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794286; c=relaxed/simple;
	bh=yRtOUmWnlmarXq4wIxtb6xfcVA3/iPqYnKZHYkMYEOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb+dHbRIruDlh+hyH/O445LcDCDzvZy0rRQznDU4YFxZ/UnSYPhEprvUf3AEix2nNn62D/a9yXr/5bU6dl1q0LUobr5jt/A5wsfJD+1tKvHpc8TFkYjpmmXsskf7ok0ln6U+DgrZ7zc+Y+7S1+R8hsaNadLTNnXS+rBOZDfG0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FX+VkqSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FX+VkqSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2AE1F000FF;
	Wed, 30 Sep 2026 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794285;
	bh=abhk+0XppS6BDH8ICSlv7ugSsb/TxteS/RsLh4ByTL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FX+VkqSQXpyP22Df73lKABaHULbKZhEou8c2vPA7h4E3LpvUVnMakbhiG7lgPE42i
	 bInFx/pgW08n+kl6ENQ9HqBaHEEbPT5QQen944fbGTk/WDfK1qTcVypn/etM60G0Gj
	 KhAA7y6fMIw/SE9biz31S/up69BjANmaK87U1oNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0150/1193] wifi: ath11k: fix invalid data access in ath11k_dp_rx_h_undecap_nwifi
Date: Wed, 30 Sep 2026 17:13:54 +0200
Message-ID: <20260930152437.539758926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit 6b471e9aefee9ed73278eb1141e0d8530a56fae9 ]

In certain cases, hardware might provide packets with a
length greater than the maximum native Wi-Fi header length.
This can lead to accessing and modifying fields in the header
within the ath11k_dp_rx_h_undecap_nwifi() function for the
DP_RX_DECAP_TYPE_NATIVE_WIFI decap type and
potentially result in invalid data access and memory corruption.

Kernel stack is corrupted in: ath11k_dp_rx_h_undecap+0x6b0/0x6b0 [ath11k]
Call trace:
 ath11k_dp_rx_h_mpdu+0x0/0x2e8 [ath11k]
 ath11k_dp_rx_h_mpdu+0x1e0/0x2e8 [ath11k]
 ath11k_dp_rx_wbm_err+0x1e0/0x450 [ath11k]
 ath11k_dp_rx_process_wbm_err+0x2fc/0x460 [ath11k]
 ath11k_dp_service_srng+0x2e0/0x348 [ath11k]

Add a sanity check before processing the SKB to prevent invalid
data access in the undecap native Wi-Fi function for the
DP_RX_DECAP_TYPE_NATIVE_WIFI decap type.

This adapted from the discussion/patch of the ath12k driver [1].

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Link: https://lore.kernel.org/linux-wireless/20250211090302.4105141-1-tamizh.raja@oss.qualcomm.com/ # [1]
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260512022351.2033155-2-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 50 +++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 7e9a5de2776c6..b5def3cfcad35 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2504,6 +2504,29 @@ static void ath11k_dp_rx_deliver_msdu(struct ath11k *ar, struct napi_struct *nap
 	ieee80211_rx_napi(ar->hw, pubsta, msdu, napi);
 }
 
+static bool ath11k_dp_rx_check_nwifi_hdr_len_valid(struct ath11k_base *ab,
+						   struct hal_rx_desc *rx_desc,
+						   struct sk_buff *msdu)
+{
+	struct ieee80211_hdr *hdr;
+	u8 decap_type;
+	u32 hdr_len;
+
+	decap_type = ath11k_dp_rx_h_msdu_start_decap_type(ab, rx_desc);
+	if (decap_type != DP_RX_DECAP_TYPE_NATIVE_WIFI)
+		return true;
+
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (likely(hdr_len <= DP_MAX_NWIFI_HDR_LEN))
+		return true;
+
+	ab->soc_stats.invalid_rbm++;
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 				     struct sk_buff *msdu,
 				     struct sk_buff_head *msdu_list,
@@ -2574,6 +2597,11 @@ static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 		}
 	}
 
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu))) {
+		ret = -EINVAL;
+		goto free_out;
+	}
+
 	ath11k_dp_rx_h_ppdu(ar, rx_desc, rx_status);
 	ath11k_dp_rx_h_mpdu(ar, msdu, rx_desc, rx_status);
 
@@ -3314,6 +3342,12 @@ static int ath11k_dp_rx_h_verify_tkip_mic(struct ath11k *ar, struct ath11k_peer
 		    RX_FLAG_IV_STRIPPED | RX_FLAG_DECRYPTED;
 	skb_pull(msdu, hal_rx_desc_sz);
 
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ar->ab, rx_desc,
+							     msdu))) {
+		dev_kfree_skb_any(msdu);
+		return -EINVAL;
+	}
+
 	ath11k_dp_rx_h_ppdu(ar, rx_desc, rxs);
 	ath11k_dp_rx_h_undecap(ar, msdu, rx_desc,
 			       HAL_ENCRYPT_TYPE_TKIP_MIC, rxs, true);
@@ -4006,6 +4040,10 @@ static int ath11k_dp_rx_h_null_q_desc(struct ath11k *ar, struct sk_buff *msdu,
 		skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 		skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 	}
+
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ar->ab, desc, msdu)))
+		return -EINVAL;
+
 	ath11k_dp_rx_h_ppdu(ar, desc, status);
 
 	ath11k_dp_rx_h_mpdu(ar, msdu, desc, status);
@@ -4050,7 +4088,7 @@ static bool ath11k_dp_rx_h_reo_err(struct ath11k *ar, struct sk_buff *msdu,
 	return drop;
 }
 
-static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
+static bool ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 					struct ieee80211_rx_status *status)
 {
 	u16 msdu_len;
@@ -4058,6 +4096,7 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 	u8 l3pad_bytes;
 	struct ath11k_skb_rxcb *rxcb = ATH11K_SKB_RXCB(msdu);
 	u32 hal_rx_desc_sz = ar->ab->hw_params.hal_desc_sz;
+	struct ath11k_base *ab = ar->ab;
 
 	rxcb->is_first_msdu = ath11k_dp_rx_h_msdu_end_first_msdu(ar->ab, desc);
 	rxcb->is_last_msdu = ath11k_dp_rx_h_msdu_end_last_msdu(ar->ab, desc);
@@ -4067,6 +4106,9 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 	skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 	skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ab, desc, msdu)))
+		return true;
+
 	ath11k_dp_rx_h_ppdu(ar, desc, status);
 
 	status->flag |= (RX_FLAG_MMIC_STRIPPED | RX_FLAG_MMIC_ERROR |
@@ -4074,19 +4116,21 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 
 	ath11k_dp_rx_h_undecap(ar, msdu, desc,
 			       HAL_ENCRYPT_TYPE_TKIP_MIC, status, false);
+
+	return false;
 }
 
 static bool ath11k_dp_rx_h_rxdma_err(struct ath11k *ar,  struct sk_buff *msdu,
 				     struct ieee80211_rx_status *status)
 {
 	struct ath11k_skb_rxcb *rxcb = ATH11K_SKB_RXCB(msdu);
-	bool drop = false;
+	bool drop;
 
 	ar->ab->soc_stats.rxdma_error[rxcb->err_code]++;
 
 	switch (rxcb->err_code) {
 	case HAL_REO_ENTR_RING_RXDMA_ECODE_TKIP_MIC_ERR:
-		ath11k_dp_rx_h_tkip_mic_err(ar, msdu, status);
+		drop = ath11k_dp_rx_h_tkip_mic_err(ar, msdu, status);
 		break;
 	default:
 		/* TODO: Review other rxdma error code to check if anything is
-- 
2.53.0



