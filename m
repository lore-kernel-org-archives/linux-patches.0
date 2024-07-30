Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0229918B49E;
	Tue, 30 Jul 2024 16:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355501; cv=none; b=CFyjJplR7fPdAvDAeo04IPhSa3dYoUEx3VROAm5PSZUip3Rbfd6BFb22ECXcGPI8ZpVcF6vygvFpfcXSni03SgcXGWe32BDGA/Y8GYLAiECA1bfaGxqXI4OPVmlUwZpoFT86FPmxrB+QBJpHJ0TTxodn2DHyIZvBNyfmkLYxfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355501; c=relaxed/simple;
	bh=QNmGaE+PrfwA7TmuIlDEKQCtY9tvmRQECMFcrSgeJ0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWyAn08xvkUNUzBkM/nPqcrWcqcw1LibdjP8gKg7xZ5hAqQd3tBMwBGyEybMpp+UA6pFoPkRqwmQ2CWaT/VW68JCMe6fu20TR65GZ/pIXGrEmNo/qBTHYryV/UDEQBNcRghHgejgaElMgycJnSoBNAmemdK4Ld+N3tZddl1GCZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCywfm+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCywfm+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223D5C4AF0A;
	Tue, 30 Jul 2024 16:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355500;
	bh=QNmGaE+PrfwA7TmuIlDEKQCtY9tvmRQECMFcrSgeJ0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCywfm+wNJykpgaPov/8fBUaeRxTB0O/B+FmBAsXW1PLdTnP2iZl2TktzRtH7EZ8h
	 mCZJscUaZMEb/R5ePgFMQFfYS29MnE/yove/p7fh3jk7PlXCYwULAYwr6V3ZtlOEJl
	 C6U86aYevxHa4hEwdN9E9CxXdXVHXgpmZ1xuKP1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaroslav Isakov <yaroslav.isakov@gmail.com>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/440] wifi: ath11k: fix wrong handling of CCMP256 and GCMP ciphers
Date: Tue, 30 Jul 2024 17:45:33 +0200
Message-ID: <20240730151619.791987075@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b1067bcdf88a5..3746f9c956969 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1879,8 +1879,7 @@ static void ath11k_dp_rx_h_csum_offload(struct ath11k *ar, struct sk_buff *msdu)
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
index b863ead198bda..8234e34269ed8 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -3748,6 +3748,7 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
 		arg.key_cipher = WMI_CIPHER_AES_CCM;
 		/* TODO: Re-check if flag is valid */
 		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV_MGMT;
@@ -3757,12 +3758,10 @@ static int ath11k_install_key(struct ath11k_vif *arvif,
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
@@ -5542,7 +5541,10 @@ static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
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
@@ -5566,7 +5568,12 @@ static int ath11k_mac_mgmt_tx_wmi(struct ath11k *ar, struct ath11k_vif *arvif,
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



