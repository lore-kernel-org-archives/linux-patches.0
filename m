Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F53221F14;
	Tue, 17 Jun 2025 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176677; cv=none; b=qrMirp7bm6pxN9rxEwzJETn/kT1dT+1+UBYeqWR3HWuVRZWwX8Fv8irv+hroXq1z2cwEFBvZ71T0zXVCFpmboTxyZFYoovdIMn2KnTpDeiwCLLydP5pHE7CJnVA82YIh/uGi0xSoEreZ6Ep2IWZWWTC+Zv7nNkANzW4TGs9ppGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176677; c=relaxed/simple;
	bh=so0KSigDaBEa08TUU2Vi0pOfOfU5gobNJWyBfQiDeZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaogfeM4k6A/Ro9To7Z/rCSJEmzG0qmbVvhGp0TuiWbCyPxXoSflRDQRfFLw5MY/1YuuFJ1M9nwOyZx/U9OxK21qLjxLi3h9yagA6mDsUmcb7ksC3LcIaEYuHhnyIEyQNFH5l1P5b7yuphhFyEziwRURHkBjVf7ujjfaTW2F1pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/EV7olj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/EV7olj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584C8C4CEE3;
	Tue, 17 Jun 2025 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176677;
	bh=so0KSigDaBEa08TUU2Vi0pOfOfU5gobNJWyBfQiDeZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/EV7oljYCck1aasq2HsH9qeAKo7tJz5Mu+UvZpVdXJs9iM7bbb6p7vU5cd8yB/iV
	 MCOCS9DB22EDUcIEcUDws/DmR2N98xoieH/DS8wG/0TY78jvFMTIxAxqBb4Barwkmg
	 /3z1iG5NTRDXsBwZZI3xVoLaqr/A6Ry2vOLR//hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 212/780] wifi: ath12k: fix wrong handling of CCMP256 and GCMP ciphers
Date: Tue, 17 Jun 2025 17:18:40 +0200
Message-ID: <20250617152500.094440543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit f5d6b15d9503263d9425dcde9cc2fd401a32b0f2 ]

Currently for CCMP256, GCMP128 and GCMP256 ciphers, in
ath12k_install_key() IEEE80211_KEY_FLAG_GENERATE_IV_MGMT is not set and
in ath12k_mac_mgmt_tx_wmi() a length of IEEE80211_CCMP_MIC_LEN is reserved
for all ciphers.

This results in unexpected drop of protected management frames in case
either of above 3 ciphers is used. The reason is, without
IEEE80211_KEY_FLAG_GENERATE_IV_MGMT set, mac80211 will not generate
CCMP/GCMP headers in TX frame for ath12k.
Also MIC length reserved is wrong and such frames are dropped by hardware.

Fix this by setting IEEE80211_KEY_FLAG_GENERATE_IV_MGMT flag for above
ciphers and by reserving proper MIC length for those ciphers.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250415195812.2633923-2-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c |  3 +--
 drivers/net/wireless/ath/ath12k/dp_rx.h |  3 +++
 drivers/net/wireless/ath/ath12k/mac.c   | 16 ++++++++++------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index f7e176e9c01a6..7fadd366ec13d 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1917,8 +1917,7 @@ static void ath12k_dp_rx_h_csum_offload(struct sk_buff *msdu,
 			   CHECKSUM_NONE : CHECKSUM_UNNECESSARY;
 }
 
-static int ath12k_dp_rx_crypto_mic_len(struct ath12k *ar,
-				       enum hal_encrypt_type enctype)
+int ath12k_dp_rx_crypto_mic_len(struct ath12k *ar, enum hal_encrypt_type enctype)
 {
 	switch (enctype) {
 	case HAL_ENCRYPT_TYPE_OPEN:
diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.h b/drivers/net/wireless/ath/ath12k/dp_rx.h
index eb4d2b60a035e..a4e179c6f2664 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.h
@@ -165,4 +165,7 @@ int ath12k_dp_htt_tlv_iter(struct ath12k_base *ab, const void *ptr, size_t len,
 			   void *data);
 void ath12k_dp_rx_h_fetch_info(struct ath12k_base *ab,  struct hal_rx_desc *rx_desc,
 			       struct ath12k_dp_rx_info *rx_info);
+
+int ath12k_dp_rx_crypto_mic_len(struct ath12k *ar, enum hal_encrypt_type enctype);
+
 #endif /* ATH12K_DP_RX_H */
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 4134f9512d038..65eb50bf03b24 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4623,8 +4623,8 @@ static int ath12k_install_key(struct ath12k_link_vif *arvif,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
-		/* TODO: Re-check if flag is valid */
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
@@ -4632,12 +4632,10 @@ static int ath12k_install_key(struct ath12k_link_vif *arvif,
 		arg.key_txmic_len = 8;
 		arg.key_rxmic_len = 8;
 		break;
-	case WLAN_CIPHER_SUITE_CCMP_256:
-		arg.key_cipher = WMI_CIPHER_AES_CCM;
-		break;
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		arg.key_cipher = WMI_CIPHER_AES_GCM;
+		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
 		break;
 	default:
 		ath12k_warn(ar->ab, "cipher %d is not supported\n", key->cipher);
@@ -7041,6 +7039,8 @@ static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_link_vif *arv
 	struct ath12k_base *ab = ar->ab;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info;
+	enum hal_encrypt_type enctype;
+	unsigned int mic_len;
 	dma_addr_t paddr;
 	int buf_id;
 	int ret;
@@ -7056,12 +7056,16 @@ static int ath12k_mac_mgmt_tx_wmi(struct ath12k *ar, struct ath12k_link_vif *arv
 		return -ENOSPC;
 
 	info = IEEE80211_SKB_CB(skb);
-	if (!(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
+	if ((ATH12K_SKB_CB(skb)->flags & ATH12K_SKB_CIPHER_SET) &&
+	    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)) {
 		if ((ieee80211_is_action(hdr->frame_control) ||
 		     ieee80211_is_deauth(hdr->frame_control) ||
 		     ieee80211_is_disassoc(hdr->frame_control)) &&
 		     ieee80211_has_protected(hdr->frame_control)) {
-			skb_put(skb, IEEE80211_CCMP_MIC_LEN);
+			enctype =
+			    ath12k_dp_tx_get_encrypt_type(ATH12K_SKB_CB(skb)->cipher);
+			mic_len = ath12k_dp_rx_crypto_mic_len(ar, enctype);
+			skb_put(skb, mic_len);
 		}
 	}
 
-- 
2.39.5



