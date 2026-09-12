Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601EF3148DA;
	Sat, 12 Sep 2026 07:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199708; cv=none; b=t6s/xEFzHYbB+oFk9OUdsLqsr6Ua25XM72TgIadJWlOHwnZ6BW4mFfMa/CgKck5xROE3w/a02S9sVn2mArtsNfrImgHC0TxBvGRxmMXMK6z2GfqEMatLSF3yI/VZOcC2id811pjOQ89B8Hek8V4qtshMrRuY+89YcIhJjICGfr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199708; c=relaxed/simple;
	bh=ing0rnh3lmu4Qm28vy2ai6EmJlVIC2EWxETp+A1Bvjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPp5op9fOV7yni0Fx7EXiDlXSDLLVg+6T/00Cckh1YA8OLWKgdUXuagGhr6ChDVaqT/ctGRDQgM6fHvtMaRzh1RZ88yGofpxdaZAHlNzSAG9VZwYm3rOXWkFM+jTp1AOJ0kjcZ5A8bH1hZGYwrKC8u+RIYhFgUgTnuHq+t1zuNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=berJI9hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="berJI9hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D2E1F000FF;
	Sat, 12 Sep 2026 07:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199707;
	bh=F84V2z8KeIa9S2fd3yPgTXnqCzBk37xez36MmCM3uSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=berJI9hyt8nmPLju8W8WcwjCDUxE8/BhIxyqQ4NcWO7BKhZn+0ITf9cfcArYTgpt4
	 yaDWxDQeRSn1oVUt5iHGE2F/HzShsbsHYYs0ufPlUhCBo4Q6h1SOw7G3ds/6B84vKO
	 6h/19yTqSagL7R76fCQRlpLIPCilDm0hVD+wwvdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0598/1815] wifi: ath12k: Advertise multicast Ethernet encapsulation offload support
Date: Sat, 12 Sep 2026 08:39:08 +0200
Message-ID: <20260912065702.922186077@linuxfoundation.org>
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

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit e47d6c9bb4165721f61356f5fccae8f7dd78876b ]

Advertise IEEE80211_OFFLOAD_ENCAP_MCAST to inform mac80211 that
multicast frame encapsulation is handled in hardware. This allows
mac80211 to pass Ethernet-formatted multicast frames directly to
the driver.

In ath12k_wifi7_mac_op_tx(), refine the logic that selects the MLO
multicast replication path. Add a sta pointer check so that only unicast
Hardware-encap frames use the direct transmit path, while multicast
Hardware-encap frames fall through to the MLO replication loop and are
transmitted on each active link.

In the MLO replication loop, use skb_clone() for Hardware-encap frames.
These frames are already in Ethernet format and do not require
802.11 link address rewriting by ath12k_mlo_mcast_update_tx_link_address().

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623100501.2100119-1-tamizh.raja@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Stable-dep-of: be72d6aecea4 ("wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c      |  6 ++-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 61 +++++++++++++++++-----
 2 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index f06656f8f2688..6ce3add492355 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -10169,7 +10169,8 @@ static void ath12k_mac_update_vif_offload(struct ath12k_link_vif *arvif)
 	if (vif->type != NL80211_IFTYPE_STATION &&
 	    vif->type != NL80211_IFTYPE_AP)
 		vif->offload_flags &= ~(IEEE80211_OFFLOAD_ENCAP_ENABLED |
-					IEEE80211_OFFLOAD_DECAP_ENABLED);
+					IEEE80211_OFFLOAD_DECAP_ENABLED |
+					IEEE80211_OFFLOAD_ENCAP_MCAST);
 
 	if (vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED) {
 		ahvif->dp_vif.tx_encap_type = ATH12K_HW_TXRX_ETHERNET;
@@ -10188,6 +10189,9 @@ static void ath12k_mac_update_vif_offload(struct ath12k_link_vif *arvif)
 		vif->offload_flags &= ~IEEE80211_OFFLOAD_ENCAP_ENABLED;
 	}
 
+	if (vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
+		vif->offload_flags |= IEEE80211_OFFLOAD_ENCAP_MCAST;
+
 	param_id = WMI_VDEV_PARAM_RX_DECAP_TYPE;
 	if (vif->offload_flags & IEEE80211_OFFLOAD_DECAP_ENABLED)
 		param_value = ATH12K_HW_TXRX_ETHERNET;
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 03dedfd907fc7..855bdfca34b11 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -918,6 +918,7 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 	struct ethhdr *eth;
 	bool is_prb_rsp;
 	u16 mcbc_gsn;
+	u8 cb_flags;
 	u8 link_id;
 	int ret;
 	struct ath12k_dp *tmp_dp;
@@ -1011,8 +1012,13 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 	    ieee80211_has_protected(hdr->frame_control))
 		is_dvlan = true;
 
+	/*
+	 * Add a sta pointer check to differentiate multicast encapsulation
+	 * offload packets, as the ATH12K_SKB_HW_80211_ENCAP flag is also set
+	 * for such packets.
+	 */
 	if (!vif->valid_links || !is_mcast || is_dvlan ||
-	    (skb_cb->flags & ATH12K_SKB_HW_80211_ENCAP) ||
+	    ((skb_cb->flags & ATH12K_SKB_HW_80211_ENCAP) && sta) ||
 	    test_bit(ATH12K_FLAG_RAW_MODE, &ar->ab->dev_flags)) {
 		ret = ath12k_wifi7_dp_tx(dp_pdev, arvif, arsta, skb, false, 0, is_mcast);
 		if (unlikely(ret)) {
@@ -1024,6 +1030,7 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 		mcbc_gsn = atomic_inc_return(&ahvif->dp_vif.mcbc_gsn) & 0xfff;
 
 		links_map = ahvif->links_map;
+		cb_flags = skb_cb->flags;
 		for_each_set_bit(link_id, &links_map,
 				 IEEE80211_MLD_MAX_NUM_LINKS) {
 			tmp_arvif = rcu_dereference(ahvif->link[link_id]);
@@ -1031,21 +1038,45 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 				continue;
 
 			tmp_ar = tmp_arvif->ar;
-			tmp_dp_pdev = ath12k_dp_to_pdev_dp(tmp_ar->ab->dp,
+			tmp_dp = ath12k_ab_to_dp(tmp_ar->ab);
+			tmp_dp_pdev = ath12k_dp_to_pdev_dp(tmp_dp,
 							   tmp_ar->pdev_idx);
 			if (!tmp_dp_pdev)
 				continue;
-			msdu_copied = skb_copy(skb, GFP_ATOMIC);
-			if (!msdu_copied) {
-				ath12k_err(ar->ab,
-					   "skb copy failure link_id 0x%X vdevid 0x%X\n",
-					   link_id, tmp_arvif->vdev_id);
-				continue;
-			}
 
-			ath12k_mlo_mcast_update_tx_link_address(vif, link_id,
-								msdu_copied,
-								info_flags);
+			if (cb_flags & ATH12K_SKB_HW_80211_ENCAP) {
+				/*
+				 * skb->data may be modified for the iova_mask devices.
+				 * It is better to use skb_copy() for such devices
+				 * to avoid any potential skb corruption related issues.
+				 */
+				if (tmp_dp->hw_params->iova_mask)
+					msdu_copied = skb_copy(skb, GFP_ATOMIC);
+				else
+					/*
+					 * ath12k_wifi7_dp_tx() should treat cloned HW-encap
+					 * Ethernet multicast frames as read-only.
+					 */
+					msdu_copied = skb_clone(skb, GFP_ATOMIC);
+				if (!msdu_copied) {
+					ath12k_err(ar->ab,
+						   "skb copy/clone failure link_id 0x%X vdevid 0x%X\n",
+						   link_id, tmp_arvif->vdev_id);
+					continue;
+				}
+			} else {
+				msdu_copied = skb_copy(skb, GFP_ATOMIC);
+				if (!msdu_copied) {
+					ath12k_err(ar->ab,
+						   "skb copy failure link_id 0x%X vdevid 0x%X\n",
+						   link_id, tmp_arvif->vdev_id);
+					continue;
+				}
+
+				ath12k_mlo_mcast_update_tx_link_address(vif, link_id,
+									msdu_copied,
+									info_flags);
+			}
 
 			skb_cb = ATH12K_SKB_CB(msdu_copied);
 			skb_cb->link_id = link_id;
@@ -1061,7 +1092,6 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 			if (unlikely(!ahvif->dp_vif.key_cipher))
 				goto skip_peer_find;
 
-			tmp_dp = ath12k_ab_to_dp(tmp_ar->ab);
 			spin_lock_bh(&tmp_dp->dp_lock);
 			peer = ath12k_dp_link_peer_find_by_addr(tmp_dp,
 								tmp_arvif->bssid);
@@ -1080,11 +1110,16 @@ static void ath12k_wifi7_mac_op_tx(struct ieee80211_hw *hw,
 				skb_cb->cipher = key->cipher;
 				skb_cb->flags |= ATH12K_SKB_CIPHER_SET;
 
+				if (skb_cb->flags & ATH12K_SKB_HW_80211_ENCAP)
+					goto skip_fctl_protected_check;
+
 				hdr = (struct ieee80211_hdr *)msdu_copied->data;
 				if (!ieee80211_has_protected(hdr->frame_control))
 					hdr->frame_control |=
 						cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 			}
+
+skip_fctl_protected_check:
 			spin_unlock_bh(&tmp_dp->dp_lock);
 
 skip_peer_find:
-- 
2.53.0



