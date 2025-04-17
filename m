Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EDE256C79;
	Thu, 17 Apr 2025 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912779; cv=none; b=lHzB5B44mXSUOeqacWeczTiWsYKf/YThyvU55EEoeC2ZVswgbY2WxCeFASCc0/Rk0DoxherIxaSMSa6ddWySdVmWrCfTjju22c6aFnXG/HuAsgsq1SA29tdx5uL+GUzCnWpCJ7ew8tPTbk9n3/91n0NK+LRQCwgd7GmSwzW37a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912779; c=relaxed/simple;
	bh=FaWwrgMJoW0pf2uWd9rurcD17vaKyYiy0H/5xmyZvpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYqC71JIwj9IyEf3Fclf8ImM/rq8msSGurFTEhgDHLJ0mLDo9ANRHfdmV86bAWgJIcbUwIuU2c5Qlh42wVTLZJy0MJyHd8j7VMECEeic0N2OjoVSxjaCeHWZ+ru7ZCs2or+XIyKaCJwCkHo/JLi98Yii19/PsJ9twIN/iMd7v3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNii1ay7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNii1ay7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25723C4CEE4;
	Thu, 17 Apr 2025 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912779;
	bh=FaWwrgMJoW0pf2uWd9rurcD17vaKyYiy0H/5xmyZvpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNii1ay7PL4iO7ZIyr5vmfzbAbfVrQg1QPz8DxWJbsrVOMa1DHArJ12wC0y5cctvJ
	 0xOlam/Dk3iqipTEJarRMmcumPWORgRvQfSBN66c2hlzBAWQ5eMJpnku2gRW/0b26t
	 gJkx+hbd8bKSLat4FCAzfYBs1ecQp1UrvMNEwDQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manish Dharanenthiran <quic_mdharane@quicinc.com>,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 121/449] wifi: ath12k: Fix invalid data access in ath12k_dp_rx_h_undecap_nwifi
Date: Thu, 17 Apr 2025 19:46:49 +0200
Message-ID: <20250417175122.840014106@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manish Dharanenthiran <quic_mdharane@quicinc.com>

[ Upstream commit 9a0dddfb30f120db3851627935851d262e4e7acb ]

In certain cases, hardware might provide packets with a
length greater than the maximum native Wi-Fi header length.
This can lead to accessing and modifying fields in the header
within the ath12k_dp_rx_h_undecap_nwifi function for
DP_RX_DECAP_TYPE_NATIVE_WIFI decap type and
potentially resulting in invalid data access and memory corruption.

Add a sanity check before processing the SKB to prevent invalid
data access in the undecap native Wi-Fi function for the
DP_RX_DECAP_TYPE_NATIVE_WIFI decap type.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Signed-off-by: Manish Dharanenthiran <quic_mdharane@quicinc.com>
Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Link: https://patch.msgid.link/20250211090302.4105141-1-tamizh.raja@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 42 +++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 68d609f2ac60e..ae6608b10bb57 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -2530,6 +2530,29 @@ static void ath12k_dp_rx_deliver_msdu(struct ath12k *ar, struct napi_struct *nap
 	ieee80211_rx_napi(ath12k_ar_to_hw(ar), pubsta, msdu, napi);
 }
 
+static bool ath12k_dp_rx_check_nwifi_hdr_len_valid(struct ath12k_base *ab,
+						   struct hal_rx_desc *rx_desc,
+						   struct sk_buff *msdu)
+{
+	struct ieee80211_hdr *hdr;
+	u8 decap_type;
+	u32 hdr_len;
+
+	decap_type = ath12k_dp_rx_h_decap_type(ab, rx_desc);
+	if (decap_type != DP_RX_DECAP_TYPE_NATIVE_WIFI)
+		return true;
+
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	hdr_len = ieee80211_hdrlen(hdr->frame_control);
+
+	if ((likely(hdr_len <= DP_MAX_NWIFI_HDR_LEN)))
+		return true;
+
+	ab->soc_stats.invalid_rbm++;
+	WARN_ON_ONCE(1);
+	return false;
+}
+
 static int ath12k_dp_rx_process_msdu(struct ath12k *ar,
 				     struct sk_buff *msdu,
 				     struct sk_buff_head *msdu_list,
@@ -2588,6 +2611,11 @@ static int ath12k_dp_rx_process_msdu(struct ath12k *ar,
 		}
 	}
 
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu))) {
+		ret = -EINVAL;
+		goto free_out;
+	}
+
 	ath12k_dp_rx_h_ppdu(ar, rx_desc, rx_status);
 	ath12k_dp_rx_h_mpdu(ar, msdu, rx_desc, rx_status);
 
@@ -2978,6 +3006,9 @@ static int ath12k_dp_rx_h_verify_tkip_mic(struct ath12k *ar, struct ath12k_peer
 		    RX_FLAG_IV_STRIPPED | RX_FLAG_DECRYPTED;
 	skb_pull(msdu, hal_rx_desc_sz);
 
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, rx_desc, msdu)))
+		return -EINVAL;
+
 	ath12k_dp_rx_h_ppdu(ar, rx_desc, rxs);
 	ath12k_dp_rx_h_undecap(ar, msdu, rx_desc,
 			       HAL_ENCRYPT_TYPE_TKIP_MIC, rxs, true);
@@ -3720,6 +3751,9 @@ static int ath12k_dp_rx_h_null_q_desc(struct ath12k *ar, struct sk_buff *msdu,
 		skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 		skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 	}
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, desc, msdu)))
+		return -EINVAL;
+
 	ath12k_dp_rx_h_ppdu(ar, desc, status);
 
 	ath12k_dp_rx_h_mpdu(ar, msdu, desc, status);
@@ -3764,7 +3798,7 @@ static bool ath12k_dp_rx_h_reo_err(struct ath12k *ar, struct sk_buff *msdu,
 	return drop;
 }
 
-static void ath12k_dp_rx_h_tkip_mic_err(struct ath12k *ar, struct sk_buff *msdu,
+static bool ath12k_dp_rx_h_tkip_mic_err(struct ath12k *ar, struct sk_buff *msdu,
 					struct ieee80211_rx_status *status)
 {
 	struct ath12k_base *ab = ar->ab;
@@ -3782,6 +3816,9 @@ static void ath12k_dp_rx_h_tkip_mic_err(struct ath12k *ar, struct sk_buff *msdu,
 	skb_put(msdu, hal_rx_desc_sz + l3pad_bytes + msdu_len);
 	skb_pull(msdu, hal_rx_desc_sz + l3pad_bytes);
 
+	if (unlikely(!ath12k_dp_rx_check_nwifi_hdr_len_valid(ab, desc, msdu)))
+		return true;
+
 	ath12k_dp_rx_h_ppdu(ar, desc, status);
 
 	status->flag |= (RX_FLAG_MMIC_STRIPPED | RX_FLAG_MMIC_ERROR |
@@ -3789,6 +3826,7 @@ static void ath12k_dp_rx_h_tkip_mic_err(struct ath12k *ar, struct sk_buff *msdu,
 
 	ath12k_dp_rx_h_undecap(ar, msdu, desc,
 			       HAL_ENCRYPT_TYPE_TKIP_MIC, status, false);
+	return false;
 }
 
 static bool ath12k_dp_rx_h_rxdma_err(struct ath12k *ar,  struct sk_buff *msdu,
@@ -3807,7 +3845,7 @@ static bool ath12k_dp_rx_h_rxdma_err(struct ath12k *ar,  struct sk_buff *msdu,
 	case HAL_REO_ENTR_RING_RXDMA_ECODE_TKIP_MIC_ERR:
 		err_bitmap = ath12k_dp_rx_h_mpdu_err(ab, rx_desc);
 		if (err_bitmap & HAL_RX_MPDU_ERR_TKIP_MIC) {
-			ath12k_dp_rx_h_tkip_mic_err(ar, msdu, status);
+			drop = ath12k_dp_rx_h_tkip_mic_err(ar, msdu, status);
 			break;
 		}
 		fallthrough;
-- 
2.39.5



