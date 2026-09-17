Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28C4E4C21;
	Thu, 17 Sep 2026 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667756; cv=none; b=OxkJQQkKwc0PbnGAaTjk5dy7OKXJtbdWfqkJkeV/iVaJuY1jsO4SCmleWqKKObalBA+HGMGY306oXNd+iK4I337DSnaBt8pir51PTVrASUhByBG5kMbaYR4Q9lWsqjRhDlEP7E9oCudze6ASCbsJf8C7JOBm/EKna378xuxT7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667756; c=relaxed/simple;
	bh=DiJ+MrR9SWibkWPc+/eDLYmKaGgUJeJFM/EMOVVRygw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5tc5AFOeWsvX9en6ykYGZaJy9KNzdTNiyszDFRZudQ+7P5/kIPpcw/UkIc541fsWhLJ7ebqVYIkbsg3FQ7oNxYsO5ODtdoQXXxjdE9jIeZkaZBJUaqOAJGQcZ7gdBQ3v81IT0O9DnjCq90EgaXl+L3h8J8LtEBWEMK8RUENecw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYwZZDBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYwZZDBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2FC1F000FF;
	Thu, 17 Sep 2026 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667754;
	bh=/6weZXxLXrg2y+IE3XV80wiWpA6Bl0cqrGvtKVgXKd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dYwZZDBIlhicwdyM0uCb5lqKY3UzCaGS8Brv4bVCU4bA+joFwhHfmZW1wLp8nNAO6
	 VHbBNrsPb0PdtpieRFPuv9EZkE5aubmgv2nQ0Es3QHgv4uXJSeENK0GrzLn8WMKMOJ
	 3gkTcXNO2hB3Iy/twrs6LNDXXxDYtTAll7ZHghZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0197/1102] wifi: ath11k: fix invalid data access in ath11k_dp_rx_h_undecap_nwifi
Date: Thu, 17 Sep 2026 16:02:20 +0100
Message-ID: <20260917151544.517085532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 4935cfdc9adc4..9344d3f1f45da 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2501,6 +2501,29 @@ static void ath11k_dp_rx_deliver_msdu(struct ath11k *ar, struct napi_struct *nap
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
@@ -2571,6 +2594,11 @@ static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 		}
 	}
 
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu))) {
+		ret = -EINVAL;
+		goto free_out;
+	}
+
 	ath11k_dp_rx_h_ppdu(ar, rx_desc, rx_status);
 	ath11k_dp_rx_h_mpdu(ar, msdu, rx_desc, rx_status);
 
@@ -3311,6 +3339,12 @@ static int ath11k_dp_rx_h_verify_tkip_mic(struct ath11k *ar, struct ath11k_peer
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
@@ -4003,6 +4037,10 @@ static int ath11k_dp_rx_h_null_q_desc(struct ath11k *ar, struct sk_buff *msdu,
 		skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 		skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 	}
+
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ar->ab, desc, msdu)))
+		return -EINVAL;
+
 	ath11k_dp_rx_h_ppdu(ar, desc, status);
 
 	ath11k_dp_rx_h_mpdu(ar, msdu, desc, status);
@@ -4047,7 +4085,7 @@ static bool ath11k_dp_rx_h_reo_err(struct ath11k *ar, struct sk_buff *msdu,
 	return drop;
 }
 
-static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
+static bool ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 					struct ieee80211_rx_status *status)
 {
 	u16 msdu_len;
@@ -4055,6 +4093,7 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 	u8 l3pad_bytes;
 	struct ath11k_skb_rxcb *rxcb = ATH11K_SKB_RXCB(msdu);
 	u32 hal_rx_desc_sz = ar->ab->hw_params.hal_desc_sz;
+	struct ath11k_base *ab = ar->ab;
 
 	rxcb->is_first_msdu = ath11k_dp_rx_h_msdu_end_first_msdu(ar->ab, desc);
 	rxcb->is_last_msdu = ath11k_dp_rx_h_msdu_end_last_msdu(ar->ab, desc);
@@ -4064,6 +4103,9 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 	skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 	skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 
+	if (unlikely(!ath11k_dp_rx_check_nwifi_hdr_len_valid(ab, desc, msdu)))
+		return true;
+
 	ath11k_dp_rx_h_ppdu(ar, desc, status);
 
 	status->flag |= (RX_FLAG_MMIC_STRIPPED | RX_FLAG_MMIC_ERROR |
@@ -4071,19 +4113,21 @@ static void ath11k_dp_rx_h_tkip_mic_err(struct ath11k *ar, struct sk_buff *msdu,
 
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



