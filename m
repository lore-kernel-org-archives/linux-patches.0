Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120FD2CCC5;
	Tue, 17 Jun 2025 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176223; cv=none; b=a6tzG+45dm+//6GjSXE70Dw5VLAY628By8/BACHspONjPQZiqH6P+l3yodz0OfU+PL4k8fDCWp9jrjK3ocitBjYMGxjmJWDM3Pao+BiQQ5uoTcOrFc93cRSFd/o/5JajssRGBFR9iM1OYSCQ0YPiOXWjk4KxM/HNphpYi3ANgK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176223; c=relaxed/simple;
	bh=x3Ea/XD/GSe+Mm3PXe7D55pzqdwz8qUgKEbzQltEJoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2awiTqscG/tYJkbGNuL2elT+I6gN5GpKN96IGxThrTptxshOikL1a0eZHXoNbF0CgX2mp7/tOwNtRrnnOokIaBVe88KXa5271kS5bHdHGtg5PG4a5GivSja6py2/NIjzk21wVR6VFqc2KsFd/0JnKVt/axaDyWpDLdYu7mKt1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAIzgwPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAIzgwPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B4AC4CEF4;
	Tue, 17 Jun 2025 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176222;
	bh=x3Ea/XD/GSe+Mm3PXe7D55pzqdwz8qUgKEbzQltEJoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAIzgwPI4ZyUKJIALcy2/fbnQkYER2HEUduINUKyg4sabtrupkyVVSghL/v0WN76M
	 TMLESIBm+vWFAgO7/jQMbBwpx8rfVwgdZzkpwmSissfawVhQYNsU7bzphfyAwTAlEQ
	 /pu+XMPvShwnaNOByhqZkbr3EEGvfBXLGkdPwOqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 166/780] wifi: ath12k: Fix invalid memory access while forming 802.11 header
Date: Tue, 17 Jun 2025 17:17:54 +0200
Message-ID: <20250617152458.245921537@linuxfoundation.org>
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

From: P Praneesh <praneesh.p@oss.qualcomm.com>

[ Upstream commit be908d2360341f8bbc982fff5a5e4f8030c17f74 ]

While forming the 802.11 header from the rx descriptor, skb_push() is
performed for the 802.11 header length and then calls
ath12k_dp_rx_desc_get_dot11_hdr(). Since skb_push() moves the skb->data
pointer backwards by the 802.11 header length, the rx descriptor points to
a different memory area than intended, causing invalid information to be
fetched from the rx descriptor.

Also, when IV and ICV are not stripped from the given MSDU, mac80211
performs PN validation for these MSDUs, which requires the crypto header.
Before forming the crypto header from the given rx descriptor, skb_push()
is performed for the crypto header length, which overwrites the memory
pointed to by the rx descriptor, causing invalid information to form the
802.11 header.

Fix these issues by moving all rx descriptor accesses before the skb_push()
operation which ensures the proper 802.11 headers are generated from the
given rx descriptor and removing ath12k_dp_rxdesc_get_mpdu_frame_ctrl()
for filling frame control, as this information is already fetched by
ath12k_dp_rx_desc_get_dot11_hdr().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Co-developed-by: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
Signed-off-by: Karthikeyan Periyasamy <karthikeyan.periyasamy@oss.qualcomm.com>
Signed-off-by: P Praneesh <praneesh.p@oss.qualcomm.com>
Link: https://patch.msgid.link/20250402180543.2670947-1-praneesh.p@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 27 +++++++++----------------
 drivers/net/wireless/ath/ath12k/hal.c   | 19 -----------------
 drivers/net/wireless/ath/ath12k/hal.h   |  1 -
 3 files changed, 9 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index 75bf4211ad422..21d240cc3aee4 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -228,12 +228,6 @@ static void ath12k_dp_rx_desc_get_crypto_header(struct ath12k_base *ab,
 	ab->hal_rx_ops->rx_desc_get_crypto_header(desc, crypto_hdr, enctype);
 }
 
-static u16 ath12k_dp_rxdesc_get_mpdu_frame_ctrl(struct ath12k_base *ab,
-						struct hal_rx_desc *desc)
-{
-	return ab->hal_rx_ops->rx_desc_get_mpdu_frame_ctl(desc);
-}
-
 static inline u8 ath12k_dp_rx_get_msdu_src_link(struct ath12k_base *ab,
 						struct hal_rx_desc *desc)
 {
@@ -2122,10 +2116,13 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 	struct hal_rx_desc *rx_desc = rxcb->rx_desc;
 	struct ath12k_base *ab = ar->ab;
 	size_t hdr_len, crypto_len;
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr hdr;
 	u16 qos_ctl;
-	__le16 fc;
-	u8 *crypto_hdr;
+	u8 *crypto_hdr, mesh_ctrl;
+
+	ath12k_dp_rx_desc_get_dot11_hdr(ab, rx_desc, &hdr);
+	hdr_len = ieee80211_hdrlen(hdr.frame_control);
+	mesh_ctrl = ath12k_dp_rx_h_mesh_ctl_present(ab, rx_desc);
 
 	if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
 		crypto_len = ath12k_dp_rx_crypto_param_len(ar, enctype);
@@ -2133,22 +2130,16 @@ static void ath12k_get_dot11_hdr_from_rx_desc(struct ath12k *ar,
 		ath12k_dp_rx_desc_get_crypto_header(ab, rx_desc, crypto_hdr, enctype);
 	}
 
-	fc = cpu_to_le16(ath12k_dp_rxdesc_get_mpdu_frame_ctrl(ab, rx_desc));
-	hdr_len = ieee80211_hdrlen(fc);
 	skb_push(msdu, hdr_len);
-	hdr = (struct ieee80211_hdr *)msdu->data;
-	hdr->frame_control = fc;
-
-	/* Get wifi header from rx_desc */
-	ath12k_dp_rx_desc_get_dot11_hdr(ab, rx_desc, hdr);
+	memcpy(msdu->data, &hdr, min(hdr_len, sizeof(hdr)));
 
 	if (rxcb->is_mcbc)
 		status->flag &= ~RX_FLAG_PN_VALIDATED;
 
 	/* Add QOS header */
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
+	if (ieee80211_is_data_qos(hdr.frame_control)) {
 		qos_ctl = rxcb->tid;
-		if (ath12k_dp_rx_h_mesh_ctl_present(ab, rx_desc))
+		if (mesh_ctrl)
 			qos_ctl |= IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT;
 
 		/* TODO: Add other QoS ctl fields when required */
diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index cd59ff8e6c7b0..178c242a840e3 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -511,11 +511,6 @@ static void ath12k_hw_qcn9274_rx_desc_get_crypto_hdr(struct hal_rx_desc *desc,
 	crypto_hdr[7] = HAL_RX_MPDU_INFO_PN_GET_BYTE2(desc->u.qcn9274.mpdu_start.pn[1]);
 }
 
-static u16 ath12k_hw_qcn9274_rx_desc_get_mpdu_frame_ctl(struct hal_rx_desc *desc)
-{
-	return __le16_to_cpu(desc->u.qcn9274.mpdu_start.frame_ctrl);
-}
-
 static int ath12k_hal_srng_create_config_qcn9274(struct ath12k_base *ab)
 {
 	struct ath12k_hal *hal = &ab->hal;
@@ -736,7 +731,6 @@ const struct hal_rx_ops hal_rx_qcn9274_ops = {
 	.rx_desc_is_da_mcbc = ath12k_hw_qcn9274_rx_desc_is_da_mcbc,
 	.rx_desc_get_dot11_hdr = ath12k_hw_qcn9274_rx_desc_get_dot11_hdr,
 	.rx_desc_get_crypto_header = ath12k_hw_qcn9274_rx_desc_get_crypto_hdr,
-	.rx_desc_get_mpdu_frame_ctl = ath12k_hw_qcn9274_rx_desc_get_mpdu_frame_ctl,
 	.dp_rx_h_msdu_done = ath12k_hw_qcn9274_dp_rx_h_msdu_done,
 	.dp_rx_h_l4_cksum_fail = ath12k_hw_qcn9274_dp_rx_h_l4_cksum_fail,
 	.dp_rx_h_ip_cksum_fail = ath12k_hw_qcn9274_dp_rx_h_ip_cksum_fail,
@@ -975,11 +969,6 @@ ath12k_hw_qcn9274_compact_rx_desc_get_crypto_hdr(struct hal_rx_desc *desc,
 		HAL_RX_MPDU_INFO_PN_GET_BYTE2(desc->u.qcn9274_compact.mpdu_start.pn[1]);
 }
 
-static u16 ath12k_hw_qcn9274_compact_rx_desc_get_mpdu_frame_ctl(struct hal_rx_desc *desc)
-{
-	return __le16_to_cpu(desc->u.qcn9274_compact.mpdu_start.frame_ctrl);
-}
-
 static bool ath12k_hw_qcn9274_compact_dp_rx_h_msdu_done(struct hal_rx_desc *desc)
 {
 	return !!le32_get_bits(desc->u.qcn9274_compact.msdu_end.info14,
@@ -1080,8 +1069,6 @@ const struct hal_rx_ops hal_rx_qcn9274_compact_ops = {
 	.rx_desc_is_da_mcbc = ath12k_hw_qcn9274_compact_rx_desc_is_da_mcbc,
 	.rx_desc_get_dot11_hdr = ath12k_hw_qcn9274_compact_rx_desc_get_dot11_hdr,
 	.rx_desc_get_crypto_header = ath12k_hw_qcn9274_compact_rx_desc_get_crypto_hdr,
-	.rx_desc_get_mpdu_frame_ctl =
-		ath12k_hw_qcn9274_compact_rx_desc_get_mpdu_frame_ctl,
 	.dp_rx_h_msdu_done = ath12k_hw_qcn9274_compact_dp_rx_h_msdu_done,
 	.dp_rx_h_l4_cksum_fail = ath12k_hw_qcn9274_compact_dp_rx_h_l4_cksum_fail,
 	.dp_rx_h_ip_cksum_fail = ath12k_hw_qcn9274_compact_dp_rx_h_ip_cksum_fail,
@@ -1330,11 +1317,6 @@ static void ath12k_hw_wcn7850_rx_desc_get_crypto_hdr(struct hal_rx_desc *desc,
 	crypto_hdr[7] = HAL_RX_MPDU_INFO_PN_GET_BYTE2(desc->u.wcn7850.mpdu_start.pn[1]);
 }
 
-static u16 ath12k_hw_wcn7850_rx_desc_get_mpdu_frame_ctl(struct hal_rx_desc *desc)
-{
-	return __le16_to_cpu(desc->u.wcn7850.mpdu_start.frame_ctrl);
-}
-
 static int ath12k_hal_srng_create_config_wcn7850(struct ath12k_base *ab)
 {
 	struct ath12k_hal *hal = &ab->hal;
@@ -1555,7 +1537,6 @@ const struct hal_rx_ops hal_rx_wcn7850_ops = {
 	.rx_desc_is_da_mcbc = ath12k_hw_wcn7850_rx_desc_is_da_mcbc,
 	.rx_desc_get_dot11_hdr = ath12k_hw_wcn7850_rx_desc_get_dot11_hdr,
 	.rx_desc_get_crypto_header = ath12k_hw_wcn7850_rx_desc_get_crypto_hdr,
-	.rx_desc_get_mpdu_frame_ctl = ath12k_hw_wcn7850_rx_desc_get_mpdu_frame_ctl,
 	.dp_rx_h_msdu_done = ath12k_hw_wcn7850_dp_rx_h_msdu_done,
 	.dp_rx_h_l4_cksum_fail = ath12k_hw_wcn7850_dp_rx_h_l4_cksum_fail,
 	.dp_rx_h_ip_cksum_fail = ath12k_hw_wcn7850_dp_rx_h_ip_cksum_fail,
diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 94e2e87359583..3156563c77e5b 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1068,7 +1068,6 @@ struct hal_rx_ops {
 	bool (*rx_desc_is_da_mcbc)(struct hal_rx_desc *desc);
 	void (*rx_desc_get_dot11_hdr)(struct hal_rx_desc *desc,
 				      struct ieee80211_hdr *hdr);
-	u16 (*rx_desc_get_mpdu_frame_ctl)(struct hal_rx_desc *desc);
 	void (*rx_desc_get_crypto_header)(struct hal_rx_desc *desc,
 					  u8 *crypto_hdr,
 					  enum hal_encrypt_type enctype);
-- 
2.39.5



