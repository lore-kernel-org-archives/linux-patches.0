Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1131A6192;
	Tue, 30 Jul 2024 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356822; cv=none; b=jAz0ZDuU9R9jfJts5DixawRYzL3635WeviH/HX6YU0XTo2PzdFUcVs2qR98DofJYSnWtH6kmbnU7iUnNUnZp6ZUYvhIggR22wQ6XCdipML+o8KNG3DakN+XgwOo0vl1dKfFZCZu2E8FCAiFqJrZyuixNEvu/G6Q1cPbatoxqZbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356822; c=relaxed/simple;
	bh=WBUeTOYfar2V1MJzIFL1VwKEgcbMyZh07iPTYO0yCeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B78G1Tv/LCrU53DrlDXNANdKc8cnHK5h+W1yTMuAOGwM8lCxUB2FqM/CGu0tG0heUoAeBpTsEbWh25Lv0/VY5BNXMkmLNqeiRYzgjwzUg3yYh0EXBvKTOloiGr1L9gpL9jzp2ayZmVnjQ8Gu3iimKy/mWmUkxi5ZflQ+GwBrXTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUkrKdiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUkrKdiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB9C4AF0F;
	Tue, 30 Jul 2024 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356821;
	bh=WBUeTOYfar2V1MJzIFL1VwKEgcbMyZh07iPTYO0yCeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUkrKdiWa9U8DLanIynIdJzyTukp3OWthNwf3tAd7tCi34gANITOkA4K0f/PQB3Cg
	 /LlA1svL5ZTedSeh6LvdkHbz4mUZufLyzV2T4SDoJdqGBvq/j+dt+Oe34YKu9ejeCT
	 xZUbNWvHJneK4WbEWfWPisdzrmuhT3sfIhebdmmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Isakov <yaroslav.isakov@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 190/809] wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers
Date: Tue, 30 Jul 2024 17:41:06 +0200
Message-ID: <20240730151732.114562231@linuxfoundation.org>
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

[ Upstream commit d2b0ca38d362ebf16ca79cd7f309d5bb8b581deb ]

Currently for CCMP256, GCMP128 and GCMP256 ciphers, in ath11k_install_key()
IEEE80211_KEY_FLAG_GENERATE_IV_MGMT is not set. And in ath11k_mac_mgmt_tx_wmi()
a length of IEEE80211_CCMP_MIC_LEN is reserved for all ciphers.

This results in unexpected management frame drop in case either of above 3 ciphers
is used. The reason is, without IEEE80211_KEY_FLAG_GENERATE_IV_MGMT set, mac80211
will not generate CCMP/GCMP headers in frame for ath11k. Also MIC length reserved
is wrong. Such frame is dropped later by hardware:

ath11k_pci 0000:5a:00.0: mac tx mgmt frame, buf id 0
ath11k_pci 0000:5a:00.0: mgmt tx compl ev pdev_id 1, desc_id 0, status 1

>From user point of view, we have observed very low throughput due to this issue:
action frames are all dropped so ADDBA response from DUT never reaches AP. AP
can not use aggregation thus throughput is low.

Fix this by setting IEEE80211_KEY_FLAG_GENERATE_IV_MGMT flag and by reserving proper
MIC length for those ciphers.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Reported-by: Yaroslav Isakov <yaroslav.isakov@gmail.com>
Tested-by: Yaroslav Isakov <yaroslav.isakov@gmail.com>
Closes: https://lore.kernel.org/all/CADS+iDX5=JtJr0apAtAQ02WWBxgOFEv8G063vuGYwDTC8AVZaw@mail.gmail.com
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240605014826.22498-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c |  3 +--
 drivers/net/wireless/ath/ath11k/dp_rx.h |  3 +++
 drivers/net/wireless/ath/ath11k/mac.c   | 15 +++++++++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index afd481f5858f0..aabde24d87632 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1877,8 +1877,7 @@ static void ath11k_dp_rx_h_csum_offload(struct ath11k *ar, struct sk_buff *msdu)
 			  CHECKSUM_NONE : CHECKSUM_UNNECESSARY;
 }
 
-static int ath11k_dp_rx_crypto_mic_len(struct ath11k *ar,
-				       enum hal_encrypt_type enctype)
+int ath11k_dp_rx_crypto_mic_len(struct ath11k *ar, enum hal_encrypt_type enctype)
 {
 	switch (enctype) {
 	case HAL_ENCRYPT_TYPE_OPEN:
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.h b/drivers/net/wireless/ath/ath11k/dp_rx.h
index 623da3bf9dc81..c322e30caa968 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2019 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #ifndef ATH11K_DP_RX_H
 #define ATH11K_DP_RX_H
@@ -95,4 +96,6 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 int ath11k_dp_rx_pktlog_start(struct ath11k_base *ab);
 int ath11k_dp_rx_pktlog_stop(struct ath11k_base *ab, bool stop_timer);
 
+int ath11k_dp_rx_crypto_mic_len(struct ath11k *ar, enum hal_encrypt_type enctype);
+
 #endif /* ATH11K_DP_RX_H */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 0c0444dc06f69..eaa53bc39ab2c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4229,6 +4229,7 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
 		/* TODO: Re-check if flag is valid */
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
@@ -4238,12 +4239,10 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
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
 		ath11k_warn(ar->ab, "cipher %d is not supported\n", key->cipher);
@@ -5903,7 +5902,10 @@ static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
 {
 	struct ath11k_base *ab = ar->ab;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath11k_skb_cb *skb_cb = ATH11K_SKB_CB(skb);
 	struct ieee80211_tx_info *info;
+	enum hal_encrypt_type enctype;
+	unsigned int mic_len;
 	dma_addr_t paddr;
 	int buf_id;
 	int ret;
@@ -5927,7 +5929,12 @@ static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
 		     ieee80211_is_deauth(hdr->frame_control) ||
 		     ieee80211_is_disassoc(hdr->frame_control)) &&
 		     ieee80211_has_protected(hdr->frame_control)) {
-			skb_put(skb, IEEE80211_CCMP_MIC_LEN);
+			if (!(skb_cb->flags & ATH11K_SKB_CIPHER_SET))
+				ath11k_warn(ab, "WMI management tx frame without ATH11K_SKB_CIPHER_SET");
+
+			enctype = ath11k_dp_tx_get_encrypt_type(skb_cb->cipher);
+			mic_len = ath11k_dp_rx_crypto_mic_len(ar, enctype);
+			skb_put(skb, mic_len);
 		}
 	}
 
-- 
2.43.0



