Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A23369D64;
	Wed, 20 May 2026 16:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294754; cv=none; b=ow/k3bNdI5JGOfSMAi7/uQOfMTwdZQE3b2ld9exOv7DccZij+zswNGbY5kdqFdOicR2Ujp8DLjCEIeyGOYRneOKXVezSJ4w+gIFX/C3XdmSAOA/pkdfciiSv4JZtXlcPhdpa/uBnnEiCeU7K1WrdXcw6lvv8i00Si4XW7ZRkK04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294754; c=relaxed/simple;
	bh=IufcGeJ9XiT2Mv/wlgjG1d9kOofn4HZihsgNB2yLlmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEFuCt+wHgH2Btym4Xwti2XeMtm4qCQEqAHGVoS0IRy7dXGTfU2I3Ys56nxsQ8uWI5Lj4c8ihyK7hwIp9xlY8Dakd9mfZXYO9JCsd2oyZI8uJiwv8WrqZCQL5tLzgzBScNCRkJmiDI4aNht8iR9WSbrPDlJNYfSzz7N+arDAEW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWUF5ydH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWUF5ydH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4961F000E9;
	Wed, 20 May 2026 16:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294753;
	bh=Fm7K4FhNkydDkP3Z8PiLBPLL3y1a3XKAWNr3dJbwego=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWUF5ydH1sVbsaA4e7nEV/wa+2siIgpOdxAvlPO5BuwFFJL3d8wJ9SXHXF+z1PxDJ
	 5Y8l2xzHFiuPaQDH4KD3QHEbU3RpA20sWS6BMRRDvW+Mu4IqDqWOuKhdLdnTUm7ShQ
	 I3xEEXXjLKu3M7y8esmuvbGUiQ+r1u40oDEpvglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0158/1146] wifi: ath10k: fix station lookup failure during disconnect
Date: Wed, 20 May 2026 18:06:48 +0200
Message-ID: <20260520162151.874232832@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 9a34a59c6086ae731a06b3e61b0951feef758648 ]

Recent commit [1] moved station statistics collection to an earlier stage
of the disconnect flow. With this change in place, ath10k fails to resolve
the station entry when handling a peer stats event triggered during
disconnect, resulting in log messages such as:

wlp58s0: deauthenticating from 74:1a:e0:e7:b4:c8 by local choice (Reason: 3=DEAUTH_LEAVING)
ath10k_pci 0000:3a:00.0: not found station for peer stats
ath10k_pci 0000:3a:00.0: failed to parse stats info tlv: -22

The failure occurs because ath10k relies on ieee80211_find_sta_by_ifaddr()
for station lookup. That function uses local->sta_hash, but by the time
the peer stats request is triggered during disconnect, mac80211 has
already removed the station from that hash table, leading to lookup
failure.

Before commit [1], this issue was not visible because the transition from
IEEE80211_STA_NONE to IEEE80211_STA_NOTEXIST prevented ath10k from sending
a peer stats request at all: ath10k_mac_sta_get_peer_stats_info() would
fail early to find the peer and skip requesting statistics.

Fix this by switching the lookup path to ath10k_peer_find(), which queries
ath10k's internal peer table. At the point where the firmware emits the
peer stats event, the peer entry is still present in the driver's list,
ensuring lookup succeeds.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00309-QCARMSWPZ-1

Fixes: a203dbeeca15 ("wifi: mac80211: collect station statistics earlier when disconnect") # [1]
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://lore.kernel.org/ath10k/57671b89-ec9f-4e6c-992c-45eb8e75929c@molgen.mpg.de
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://patch.msgid.link/20260325-ath10k-station-lookup-failure-v1-1-2e0c970f25d5@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 26 +++++++++++++----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index ec8e91707f84a..01f2d1fa9d7d9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
- * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 #include "core.h"
 #include "debug.h"
@@ -14,6 +14,7 @@
 #include "wmi-tlv.h"
 #include "p2p.h"
 #include "testmode.h"
+#include "txrx.h"
 #include <linux/bitfield.h>
 
 /***************/
@@ -224,8 +225,9 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 						const void *ptr, void *data)
 {
 	const struct wmi_tlv_peer_stats_info *stat = ptr;
-	struct ieee80211_sta *sta;
+	u32 vdev_id = *(u32 *)data;
 	struct ath10k_sta *arsta;
+	struct ath10k_peer *peer;
 
 	if (tag != WMI_TLV_TAG_STRUCT_PEER_STATS_INFO)
 		return -EPROTO;
@@ -241,20 +243,20 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 		   __le32_to_cpu(stat->last_tx_rate_code),
 		   __le32_to_cpu(stat->last_tx_bitrate_kbps));
 
-	rcu_read_lock();
-	sta = ieee80211_find_sta_by_ifaddr(ar->hw, stat->peer_macaddr.addr, NULL);
-	if (!sta) {
-		rcu_read_unlock();
-		ath10k_warn(ar, "not found station for peer stats\n");
+	guard(spinlock_bh)(&ar->data_lock);
+
+	peer = ath10k_peer_find(ar, vdev_id, stat->peer_macaddr.addr);
+	if (!peer || !peer->sta) {
+		ath10k_warn(ar, "not found %s with vdev id %u mac addr %pM for peer stats\n",
+			    peer ? "sta" : "peer", vdev_id, stat->peer_macaddr.addr);
 		return -EINVAL;
 	}
 
-	arsta = (struct ath10k_sta *)sta->drv_priv;
+	arsta = (struct ath10k_sta *)peer->sta->drv_priv;
 	arsta->rx_rate_code = __le32_to_cpu(stat->last_rx_rate_code);
 	arsta->rx_bitrate_kbps = __le32_to_cpu(stat->last_rx_bitrate_kbps);
 	arsta->tx_rate_code = __le32_to_cpu(stat->last_tx_rate_code);
 	arsta->tx_bitrate_kbps = __le32_to_cpu(stat->last_tx_bitrate_kbps);
-	rcu_read_unlock();
 
 	return 0;
 }
@@ -266,6 +268,7 @@ static int ath10k_wmi_tlv_op_pull_peer_stats_info(struct ath10k *ar,
 	const struct wmi_tlv_peer_stats_info_ev *ev;
 	const void *data;
 	u32 num_peer_stats;
+	u32 vdev_id;
 	int ret;
 
 	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
@@ -284,15 +287,16 @@ static int ath10k_wmi_tlv_op_pull_peer_stats_info(struct ath10k *ar,
 	}
 
 	num_peer_stats = __le32_to_cpu(ev->num_peers);
+	vdev_id = __le32_to_cpu(ev->vdev_id);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
 		   "wmi tlv peer stats info update peer vdev id %d peers %i more data %d\n",
-		   __le32_to_cpu(ev->vdev_id),
+		   vdev_id,
 		   num_peer_stats,
 		   __le32_to_cpu(ev->more_data));
 
 	ret = ath10k_wmi_tlv_iter(ar, data, ath10k_wmi_tlv_len(data),
-				  ath10k_wmi_tlv_parse_peer_stats_info, NULL);
+				  ath10k_wmi_tlv_parse_peer_stats_info, &vdev_id);
 	if (ret)
 		ath10k_warn(ar, "failed to parse stats info tlv: %d\n", ret);
 
-- 
2.53.0



