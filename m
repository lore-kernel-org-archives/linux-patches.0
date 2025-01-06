Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF601D7E21;
	Mon,  6 Jan 2025 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177042; cv=none; b=FU4qiJ3MdLgduYu5O42mjW25fcX7m4nFbC049cnaGNOaaFQbZIp9cxSSV3gpmI/wsJCvvP+gQR+3oK0RskH2mPrulab9MzarmDP+cxsdeSHe/daGZS8b8ulXAxCidcUBqqMDT1Brcsi/df8J7x6f/d2eU527m6Zd0/GwBOQhEpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177042; c=relaxed/simple;
	bh=PqFZ3qrXx2EBdhvuqtI0aJZmFkw3f+MlwUWRzD516bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7YuParwFyJDVH9fe/3GdLARUbAG6DsacqH09owwEoA9xsvI8PnHdym+pNl+uddqXo7+Yx5Vudyzf7cwM7HzOaW1fMi2L6BBo5LCDa7veEw8J3VG7Xz7r1bi/ek39AVY0PWYBoIfPYg1RTg4PX82WPq3E62+oGhLhsQzGVLNUZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCxoeCMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCxoeCMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EEC0C4CED2;
	Mon,  6 Jan 2025 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177042;
	bh=PqFZ3qrXx2EBdhvuqtI0aJZmFkw3f+MlwUWRzD516bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCxoeCMZxQNXtyGmEaT/JeVsQIuXUXNUvKktZOFzndc5WSAF5RCAMkam6fOCITwRd
	 Gj6nvciJ/iz6NLScMcKIswJLa0hs7Cg0f2DTepPhOc1i8KVMotdKJTsfip9XZJFkRs
	 Ipcb4uBASgMDotDnSExSA8C7LiFnd695vEeCm3CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/222] wifi: ath12k: Optimize the mac80211 hw data access
Date: Mon,  6 Jan 2025 16:13:56 +0100
Message-ID: <20250106151151.819581527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit 842addae02089fce4731be1c8d7d539449d4d009 ]

Currently mac80211 hw data is accessed by convert the hw to radio (ar)
structure and then radio to hw structure which is not necessary in some
places where mac80211 hw data is already present. So in that kind of
places avoid the conversion and directly access the mac80211 hw data.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231120235812.2602198-2-quic_periyasa@quicinc.com
Stable-dep-of: 8fac3266c68a ("wifi: ath12k: fix atomic calls in ath12k_mac_op_set_bitrate_mask()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 14 +++++++-------
 drivers/net/wireless/ath/ath12k/reg.c |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index f90191a290c2..e4b8c45898d2 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4945,7 +4945,7 @@ static void ath12k_mac_op_tx(struct ieee80211_hw *hw,
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to queue management frame %d\n",
 				    ret);
-			ieee80211_free_txskb(ar->hw, skb);
+			ieee80211_free_txskb(hw, skb);
 		}
 		return;
 	}
@@ -4953,7 +4953,7 @@ static void ath12k_mac_op_tx(struct ieee80211_hw *hw,
 	ret = ath12k_dp_tx(ar, arvif, skb);
 	if (ret) {
 		ath12k_warn(ar->ab, "failed to transmit frame %d\n", ret);
-		ieee80211_free_txskb(ar->hw, skb);
+		ieee80211_free_txskb(hw, skb);
 	}
 }
 
@@ -5496,7 +5496,7 @@ static int ath12k_mac_op_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_del;
 
 	param_id = WMI_VDEV_PARAM_RTS_THRESHOLD;
-	param_value = ar->hw->wiphy->rts_threshold;
+	param_value = hw->wiphy->rts_threshold;
 	ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
 					    param_id, param_value);
 	if (ret) {
@@ -6676,7 +6676,7 @@ ath12k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 				    arvif->vdev_id, ret);
 			return ret;
 		}
-		ieee80211_iterate_stations_atomic(ar->hw,
+		ieee80211_iterate_stations_atomic(hw,
 						  ath12k_mac_disable_peer_fixed_rate,
 						  arvif);
 	} else if (ath12k_mac_bitrate_mask_get_single_nss(ar, band, mask,
@@ -6722,14 +6722,14 @@ ath12k_mac_op_set_bitrate_mask(struct ieee80211_hw *hw,
 			return -EINVAL;
 		}
 
-		ieee80211_iterate_stations_atomic(ar->hw,
+		ieee80211_iterate_stations_atomic(hw,
 						  ath12k_mac_disable_peer_fixed_rate,
 						  arvif);
 
 		mutex_lock(&ar->conf_mutex);
 
 		arvif->bitrate_mask = *mask;
-		ieee80211_iterate_stations_atomic(ar->hw,
+		ieee80211_iterate_stations_atomic(hw,
 						  ath12k_mac_set_bitrate_mask_iter,
 						  arvif);
 
@@ -6767,7 +6767,7 @@ ath12k_mac_op_reconfig_complete(struct ieee80211_hw *hw,
 		ath12k_warn(ar->ab, "pdev %d successfully recovered\n",
 			    ar->pdev->pdev_id);
 		ar->state = ATH12K_STATE_ON;
-		ieee80211_wake_queues(ar->hw);
+		ieee80211_wake_queues(hw);
 
 		if (ab->is_reset) {
 			recovery_count = atomic_inc_return(&ab->recovery_count);
diff --git a/drivers/net/wireless/ath/ath12k/reg.c b/drivers/net/wireless/ath/ath12k/reg.c
index 32bdefeccc24..837a3e1ec3a4 100644
--- a/drivers/net/wireless/ath/ath12k/reg.c
+++ b/drivers/net/wireless/ath/ath12k/reg.c
@@ -28,11 +28,11 @@ static const struct ieee80211_regdomain ath12k_world_regd = {
 	}
 };
 
-static bool ath12k_regdom_changes(struct ath12k *ar, char *alpha2)
+static bool ath12k_regdom_changes(struct ieee80211_hw *hw, char *alpha2)
 {
 	const struct ieee80211_regdomain *regd;
 
-	regd = rcu_dereference_rtnl(ar->hw->wiphy->regd);
+	regd = rcu_dereference_rtnl(hw->wiphy->regd);
 	/* This can happen during wiphy registration where the previous
 	 * user request is received before we update the regd received
 	 * from firmware.
@@ -71,7 +71,7 @@ ath12k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 		return;
 	}
 
-	if (!ath12k_regdom_changes(ar, request->alpha2)) {
+	if (!ath12k_regdom_changes(hw, request->alpha2)) {
 		ath12k_dbg(ar->ab, ATH12K_DBG_REG, "Country is already set\n");
 		return;
 	}
-- 
2.39.5



