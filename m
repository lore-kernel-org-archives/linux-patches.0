Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2138F259;
	Sat, 12 Sep 2026 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201236; cv=none; b=EAKsz8/zQVjCWIMU+tbX63IEivIphPbGmXPCvgxKvwEPZ4pGEMC+OT+V8GKLwLe34vZDsS/Plj2UXgXug31jScqMtScKDfVFMCxNWcTjzLF5zTIrQ6nVMLBobwTl3Au0a/Rpk1V2v3AJBMOi+zWXFf3GFFLaG4a9FOi04t0S4O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201236; c=relaxed/simple;
	bh=yWwTXVwclmFbkg4lK5leybO7vPW4oW1SLuhrCSk5ZrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDsJV2D3p0sEXpUoAHoR+Wfdv5/aY5j4NK1EkyVrryBFt329kuZ9DXJBUQajTk5cEZJV4Ctz1Hl0ewBOKVt9jn6uhn74+2NcXTw8ktpxtPm9tjnyIQWDZkKHYPGbUfciDaJw3XgoKd5iStD3Rnfz1ghNEyTLN/Iu0MFeGje2V7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kH0AaaDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kH0AaaDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E671F000FF;
	Sat, 12 Sep 2026 08:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201235;
	bh=+7ruBSvMJrSejCSnDO3DXjMwj8Z0h+Osuv2BSWNVfSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kH0AaaDqgiv9/q11Ofs6in9haZVtRFYYawA+ivpoflIA0qJIWoC1h6idw3K3H0dzd
	 ze/K5UlAjAtu67BwievR9WYtjPSSi2Oc69kXEp7phOkulkTFtBP/+WcOFl5RFyQclu
	 fXUOtIMA7HIY0KVSkfOMr5+gtQpo4xFbdW283Clo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0953/1815] wifi: ath12k: fix encrypted EAPOL TX in encap offload mode
Date: Sat, 12 Sep 2026 08:45:03 +0200
Message-ID: <20260912065711.341721038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>

[ Upstream commit 1e33f8acd837420160ea088160d8648a3db54c3b ]

When a vif operates with IEEE80211_OFFLOAD_ENCAP_ENABLED,
mac80211 delivers EAPOL frames to ath12k in native-WiFi format.

Unencrypted EAPOL frames used during the initial 4-way
handshake are already handled through the existing
is_diff_encap path. However, EAPOL frames transmitted during
GTK rekeying carry ATH12K_SKB_CIPHER_SET and continue through
the normal native-WiFi transmit path.

Firmware encryption requires RAW frames with cipher-specific IV and ICV
fields correctly provisioned in the skb. Passing encrypted EAPOL frames
in native-WiFi format results in incorrect IV provisioning, leading to
an invalid ICV and frame drop.

Fix this by detecting the EAPOL frames that need HW encryption and
converting them to firmware-encrypted RAW frames before transmission.
Reserve IV space after the MAC header, append ICV space at the tail,
select the appropriate firmware encryption type and request
firmware-side encryption.

Introduce ath12k_dp_tx_crypto_iv_len() and ath12k_dp_tx_crypto_icv_len()
helpers in the TX path to obtain cipher-specific IV and ICV lengths.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1

Fixes: d29591d5b52e ("wifi: ath12k: Advertise encapsulation/decapsulation offload support to mac80211")
Signed-off-by: Reshma Immaculate Rajkumar <reshma.rajkumar@oss.qualcomm.com>
Reviewed-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260729171732.668367-1-reshma.rajkumar@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c       | 46 +++++++++++++
 drivers/net/wireless/ath/ath12k/dp_tx.h       |  2 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 64 ++++++++++++++++++-
 3 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index c10da6195c9c3..9644f9ef2c749 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -82,6 +82,52 @@ enum hal_encrypt_type ath12k_dp_tx_get_encrypt_type(u32 cipher)
 }
 EXPORT_SYMBOL(ath12k_dp_tx_get_encrypt_type);
 
+u8 ath12k_dp_tx_crypto_iv_len(enum hal_encrypt_type enc_type)
+{
+	switch (enc_type) {
+	case HAL_ENCRYPT_TYPE_TKIP_NO_MIC:
+	case HAL_ENCRYPT_TYPE_TKIP_MIC:
+		return IEEE80211_TKIP_IV_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_128:
+		return IEEE80211_CCMP_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_256:
+		return IEEE80211_CCMP_256_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_GCMP_128:
+	case HAL_ENCRYPT_TYPE_AES_GCMP_256:
+		return IEEE80211_GCMP_HDR_LEN;
+	case HAL_ENCRYPT_TYPE_WEP_40:
+	case HAL_ENCRYPT_TYPE_WEP_104:
+	case HAL_ENCRYPT_TYPE_WEP_128:
+		return IEEE80211_WEP_IV_LEN;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(ath12k_dp_tx_crypto_iv_len);
+
+u8 ath12k_dp_tx_crypto_icv_len(enum hal_encrypt_type enc_type)
+{
+	switch (enc_type) {
+	case HAL_ENCRYPT_TYPE_CCMP_128:
+		return IEEE80211_CCMP_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_CCMP_256:
+		return IEEE80211_CCMP_256_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_GCMP_128:
+	case HAL_ENCRYPT_TYPE_AES_GCMP_256:
+		return IEEE80211_GCMP_MIC_LEN;
+	case HAL_ENCRYPT_TYPE_TKIP_NO_MIC:
+	case HAL_ENCRYPT_TYPE_TKIP_MIC:
+		return IEEE80211_TKIP_ICV_LEN;
+	case HAL_ENCRYPT_TYPE_WEP_40:
+	case HAL_ENCRYPT_TYPE_WEP_104:
+	case HAL_ENCRYPT_TYPE_WEP_128:
+		return IEEE80211_WEP_ICV_LEN;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(ath12k_dp_tx_crypto_icv_len);
+
 void ath12k_dp_tx_release_txbuf(struct ath12k_dp *dp,
 				struct ath12k_tx_desc_info *tx_desc,
 				u8 pool_id)
diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.h b/drivers/net/wireless/ath/ath12k/dp_tx.h
index 7cef20540179f..1af79af2ada26 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.h
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.h
@@ -19,6 +19,8 @@ enum hal_tcl_encap_type
 ath12k_dp_tx_get_encap_type(struct ath12k_base *ab, struct sk_buff *skb);
 void ath12k_dp_tx_encap_nwifi(struct sk_buff *skb);
 u8 ath12k_dp_tx_get_tid(struct sk_buff *skb);
+u8 ath12k_dp_tx_crypto_iv_len(enum hal_encrypt_type enc_type);
+u8 ath12k_dp_tx_crypto_icv_len(enum hal_encrypt_type enc_type);
 void *ath12k_dp_metadata_align_skb(struct sk_buff *skb, u8 tail_len);
 int ath12k_dp_tx_align_payload(struct ath12k_dp *dp, struct sk_buff **pskb);
 void ath12k_dp_tx_release_txbuf(struct ath12k_dp *dp,
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index d2749de445534..587d58eeccfa5 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -13,6 +13,49 @@
 #include "hal.h"
 #include "hal_tx.h"
 
+/*
+ * Convert an encrypted EAPOL frame from native-WiFi format to
+ * the layout expected by the firmware RAW encrypt pipeline:
+ *
+ *   [802.11 hdr][IV (zeroed)][LLC/SNAP][EAPOL payload][ICV (zeroed)]
+ *
+ * mac80211 delivers the frame as [802.11 hdr][LLC/SNAP][EAPOL payload].
+ * The MAC header length is read from the unmodified skb and is safe because
+ * ieee80211_hdrlen() only inspects the 2-byte frame_control field.
+ * pskb_expand_head() is used to grow both head (for the IV) and tail
+ * (for the ICV) in a single call and allocation.
+ */
+static int
+ath12k_wifi7_dp_tx_encap_eapol(struct sk_buff *skb,
+			       struct hal_tx_info *ti,
+			       struct ath12k_skb_cb *skb_cb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	enum hal_encrypt_type enc_type =
+				ath12k_dp_tx_get_encrypt_type(skb_cb->cipher);
+	u16 mac_hdr_len = ieee80211_hdrlen(hdr->frame_control);
+	u8 iv_len = ath12k_dp_tx_crypto_iv_len(enc_type);
+	u8 icv_len = ath12k_dp_tx_crypto_icv_len(enc_type);
+
+	if (pskb_expand_head(skb, iv_len, icv_len, GFP_ATOMIC))
+		return -ENOMEM;
+
+	if (iv_len) {
+		skb_push(skb, iv_len);
+		memmove(skb->data, skb->data + iv_len, mac_hdr_len);
+		memset(skb->data + mac_hdr_len, 0, iv_len);
+	}
+
+	if (icv_len)
+		memset(skb_put(skb, icv_len), 0, icv_len);
+
+	ti->flags0 |= u32_encode_bits(1, HAL_TCL_DATA_CMD_INFO2_TO_FW);
+	ti->encap_type = HAL_TCL_ENCAP_TYPE_RAW;
+	ti->encrypt_type = enc_type;
+
+	return 0;
+}
+
 static void
 ath12k_wifi7_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
 				       struct hal_tx_msdu_ext_desc *tcl_ext_cmd,
@@ -91,6 +134,7 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	u32 iova_mask = dp->hw_params->iova_mask;
 	bool is_diff_encap = false;
 	bool is_null_frame = false;
+	bool eapol_encap_done = false;
 
 	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
 		return -ESHUTDOWN;
@@ -211,9 +255,27 @@ int ath12k_wifi7_dp_tx(struct ath12k_pdev_dp *dp_pdev, struct ath12k_link_vif *a
 	case HAL_TCL_ENCAP_TYPE_NATIVE_WIFI:
 		is_null_frame = ieee80211_is_nullfunc(hdr->frame_control);
 		if (ahvif->vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED) {
-			if (skb->protocol == cpu_to_be16(ETH_P_PAE) || is_null_frame)
+			if ((skb->protocol == cpu_to_be16(ETH_P_PAE) &&
+			     !(skb_cb->flags & ATH12K_SKB_CIPHER_SET)) || is_null_frame)
 				is_diff_encap = true;
 
+			if (skb->protocol == cpu_to_be16(ETH_P_PAE) &&
+			    (skb_cb->flags & ATH12K_SKB_CIPHER_SET)) {
+				if (!eapol_encap_done) {
+					ret = ath12k_wifi7_dp_tx_encap_eapol(skb, &ti,
+									     skb_cb);
+					if (ret)
+						goto fail_remove_tx_buf;
+					hdr = (void *)skb->data;
+					eapol_encap_done = true;
+				} else {
+					ti.flags0 |= u32_encode_bits(1,
+							HAL_TCL_DATA_CMD_INFO2_TO_FW);
+					ti.encap_type = HAL_TCL_ENCAP_TYPE_RAW;
+					ti.encrypt_type =
+						ath12k_dp_tx_get_encrypt_type(skb_cb->cipher);
+				}
+			}
 			/* Firmware expects msdu ext descriptor for nwifi/raw packets
 			 * received in ETH mode. Without this, observed tx fail for
 			 * Multicast packets in ETH mode.
-- 
2.53.0



