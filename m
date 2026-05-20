Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FAE3BE165;
	Wed, 20 May 2026 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297742; cv=none; b=u9jzqOieGaQyPUT9vVjKniRIiYgpthXpH/FrG/PLY4eL5WMsPu/L0MrqQ4F5qD7ALDY5i5r69ltS9SyOXvcaEwwho9XEc+41pFYviS20HdM52XfuDvTN2sW+Cj78vRQgDB8mVO++hCNbN2Yc2YH1hDbwljcqnPF2KPv9M4R2BCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297742; c=relaxed/simple;
	bh=aEOnOGIIOHXVz3SAzdulmm/Gsza24RgN0hvLV2GvJMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNVm0o9ZE38rgBbhfWeKCDTr4FGX7anIwpE4BHuIUeakNb3W8wtWhQH2cErFoBjNQzk5ZCqZ+HJmbWb3zNjTy3iGCRiUEqF+o1k3z9LkMXcEGJamblzP98bt+upt3PZ0tiXfFLE8WrdYaVBMBnnt+4n70esU0WLaVT0eJF2WneU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBSiymU3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBSiymU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E5C1F00894;
	Wed, 20 May 2026 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297740;
	bh=lRCT1jBOwpvsceAZqHtoLlrfElDHjgWxYJU2E9b2tBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBSiymU3imDAjg8wKA7HboG4FfWLNrJb9icF+4YJhC2kFWnx8gRkTxOWtiF3z0Vpl
	 GLvCztdK7dwLgZDp2L+pX+piB3zp/wbMZ2lcU7o1O8/vVFyC1E529M9Q+tONJThnhA
	 0e3xALkXGgeZ0QpueE9iLeTPMjlJ9QchILF97/sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/957] wifi: ath10k: fix station lookup failure during disconnect
Date: Wed, 20 May 2026 18:10:12 +0200
Message-ID: <20260520162137.353278742@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16d07d619b4df..ba1294c8ee39f 100644
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



