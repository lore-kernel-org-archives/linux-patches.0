Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539512F659A;
	Tue, 12 Aug 2025 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023704; cv=none; b=pyHnYpHdtIVmgYtgccyUa1Jf1yRpvSV8VLa1m10FAFbuFnpAyziXUZcuAI913wps4wvQvfrzMwyKq6URAKAW8L2PbN9TFxMjkHQNjBqveGQOkry4w4G+k7GXSuaHo9YrSIScpcxjgcKiayYUpzz9n5f+4wPvm7W+vSwzcEHq9s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023704; c=relaxed/simple;
	bh=MKFjTcJsT5I4Ukkp8JxnXPfwKYJLCMnpBs5GDgql0ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4HYPHhJHC/1ktvHmDld0cpaNGIdTp3MHveNhEcfFGYueUOfNrM2dt7ouBZvzZqqvrP5/oVIS84R6T+naCKyx79GV/8vRrsZg+bJ+kCaTfWupkYfO+qlTw73fkRDH8vNXgDDN3TMieVhpRwtkmXGYeeMO9Djj/q5J9OoRgwXKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/JnbbOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/JnbbOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46E7C4CEF0;
	Tue, 12 Aug 2025 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023704;
	bh=MKFjTcJsT5I4Ukkp8JxnXPfwKYJLCMnpBs5GDgql0ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/JnbbOABg42mu6J/Q7VUf6F68CUYj7iqV9p/NxKVxBhK5eKy9FDSwCQ9NwUJKUcA
	 qmo8Rbn0I20NM44RBCQGrX8VdlWAAxv+SmT5xZMKq0EiK8SFZ6CvnUrV2iX6vTykKm
	 +/VFlLi9v0Qq+EIjgRY5U9nNYMBo8PlCg96q2R9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 157/627] wifi: ath12k: Avoid accessing uninitialized arvif->ar during beacon miss
Date: Tue, 12 Aug 2025 19:27:32 +0200
Message-ID: <20250812173425.260243566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>

[ Upstream commit 36670b67de18f1e5d34900c5d2ac60a8970c293c ]

During beacon miss handling, ath12k driver iterates over active virtual
interfaces (vifs) and attempts to access the radio object (ar) via
arvif->deflink->ar.

However, after commit aa80f12f3bed ("wifi: ath12k: defer vdev creation for
MLO"), arvif is linked to a radio only after vdev creation, typically when
a channel is assigned or a scan is requested.
For P2P capable devices, a default P2P interface is created by
wpa_supplicant along with regular station interfaces, these serve as dummy
interfaces for P2P-capable stations, lack an associated netdev and initiate
frequent scans to discover neighbor p2p devices. When a scan is initiated
on such P2P vifs, driver selects destination radio (ar) based on scan
frequency, creates a scan vdev, and attaches arvif to the radio. Once the
scan completes or is aborted, the scan vdev is deleted, detaching arvif
from the radio and leaving arvif->ar uninitialized.

While handling beacon miss for station interfaces, P2P interface is also
encountered in the vif iteration and ath12k_mac_handle_beacon_miss_iter()
tries to dereference the uninitialized arvif->deflink->ar.

Fix this by verifying that vdev is created for the arvif before accessing
its ar during beacon miss handling and similar vif iterator callbacks.

==========================================================================
 wlp6s0: detected beacon loss from AP (missed 7 beacons) - probing
 KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]

 CPU: 5 UID: 0 PID: 0 Comm: swapper/5 Not tainted 6.16.0-rc1-wt-ath+ #2 PREEMPT(full)
 RIP: 0010:ath12k_mac_handle_beacon_miss_iter+0xb5/0x1a0 [ath12k]
 Call Trace:
  __iterate_interfaces+0x11a/0x410 [mac80211]
  ieee80211_iterate_active_interfaces_atomic+0x61/0x140 [mac80211]
  ath12k_mac_handle_beacon_miss+0xa1/0xf0 [ath12k]
  ath12k_roam_event+0x393/0x560 [ath12k]
  ath12k_wmi_op_rx+0x1486/0x28c0 [ath12k]
  ath12k_htc_process_trailer.isra.0+0x2fb/0x620 [ath12k]
  ath12k_htc_rx_completion_handler+0x448/0x830 [ath12k]
  ath12k_ce_recv_process_cb+0x549/0x9e0 [ath12k]
  ath12k_ce_per_engine_service+0xbe/0xf0 [ath12k]
  ath12k_pci_ce_workqueue+0x69/0x120 [ath12k]
  process_one_work+0xe3a/0x1430

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00284.1-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: aa80f12f3bed ("wifi: ath12k: defer vdev creation for MLO")
Signed-off-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250618185635.750470-1-rameshkumar.sundaram@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 15 +++++++++------
 drivers/net/wireless/ath/ath12k/p2p.c |  3 ++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 59ec422992d3..5be7b79db341 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -693,6 +693,9 @@ static void ath12k_get_arvif_iter(void *data, u8 *mac,
 		if (WARN_ON(!arvif))
 			continue;
 
+		if (!arvif->is_created)
+			continue;
+
 		if (arvif->vdev_id == arvif_iter->vdev_id &&
 		    arvif->ar == arvif_iter->ar) {
 			arvif_iter->arvif = arvif;
@@ -1755,7 +1758,7 @@ static void ath12k_mac_handle_beacon_iter(void *data, u8 *mac,
 	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
 	struct ath12k_link_vif *arvif = &ahvif->deflink;
 
-	if (vif->type != NL80211_IFTYPE_STATION)
+	if (vif->type != NL80211_IFTYPE_STATION || !arvif->is_created)
 		return;
 
 	if (!ether_addr_equal(mgmt->bssid, vif->bss_conf.bssid))
@@ -1778,16 +1781,16 @@ static void ath12k_mac_handle_beacon_miss_iter(void *data, u8 *mac,
 	u32 *vdev_id = data;
 	struct ath12k_vif *ahvif = ath12k_vif_to_ahvif(vif);
 	struct ath12k_link_vif *arvif = &ahvif->deflink;
-	struct ath12k *ar = arvif->ar;
-	struct ieee80211_hw *hw = ath12k_ar_to_hw(ar);
+	struct ieee80211_hw *hw;
 
-	if (arvif->vdev_id != *vdev_id)
+	if (!arvif->is_created || arvif->vdev_id != *vdev_id)
 		return;
 
 	if (!arvif->is_up)
 		return;
 
 	ieee80211_beacon_loss(vif);
+	hw = ath12k_ar_to_hw(arvif->ar);
 
 	/* Firmware doesn't report beacon loss events repeatedly. If AP probe
 	 * (done by mac80211) succeeds but beacons do not resume then it
@@ -9818,7 +9821,7 @@ ath12k_mac_change_chanctx_cnt_iter(void *data, u8 *mac,
 		if (WARN_ON(!arvif))
 			continue;
 
-		if (arvif->ar != arg->ar)
+		if (!arvif->is_created || arvif->ar != arg->ar)
 			continue;
 
 		link_conf = wiphy_dereference(ahvif->ah->hw->wiphy,
@@ -9853,7 +9856,7 @@ ath12k_mac_change_chanctx_fill_iter(void *data, u8 *mac,
 		if (WARN_ON(!arvif))
 			continue;
 
-		if (arvif->ar != arg->ar)
+		if (!arvif->is_created || arvif->ar != arg->ar)
 			continue;
 
 		link_conf = wiphy_dereference(ahvif->ah->hw->wiphy,
diff --git a/drivers/net/wireless/ath/ath12k/p2p.c b/drivers/net/wireless/ath/ath12k/p2p.c
index 84cccf7d91e7..59589748f1a8 100644
--- a/drivers/net/wireless/ath/ath12k/p2p.c
+++ b/drivers/net/wireless/ath/ath12k/p2p.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <net/mac80211.h>
@@ -124,7 +125,7 @@ static void ath12k_p2p_noa_update_vdev_iter(void *data, u8 *mac,
 
 	WARN_ON(!rcu_read_lock_any_held());
 	arvif = &ahvif->deflink;
-	if (arvif->ar != arg->ar || arvif->vdev_id != arg->vdev_id)
+	if (!arvif->is_created || arvif->ar != arg->ar || arvif->vdev_id != arg->vdev_id)
 		return;
 
 	ath12k_p2p_noa_update(arvif, arg->noa);
-- 
2.39.5



