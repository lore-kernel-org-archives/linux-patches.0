Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC28F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA63C433C8;
	Sun, 16 Jul 2023 19:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537563;
	bh=p593Vb3epzf+j41ABWxUfUQaXHKJqVKfP5qhnNLkCgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw6NVnjp+Lxq6vhJFVzVDFtDSgx7+Fkw1FurpVZRiHb5jYdIctCeAQBTTmH/0Rvvj
	 8IWenppyWarXGifT7BVMQpfdTugyqFCvQdX1AbuYFptOxMgvHuyj+DJuDS9ykK/5AB
	 WEflnce0zDZMHnqKiW4qEbHwrcwIKVkjVdHahav8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youghandhar Chintala <quic_youghand@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 140/800] wifi: ath10k: Trigger STA disconnect after reconfig complete on hardware restart
Date: Sun, 16 Jul 2023 21:39:53 +0200
Message-ID: <20230716194952.348319763@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Youghandhar Chintala <quic_youghand@quicinc.com>

[ Upstream commit 75bd32f5ce94bc365ba0b9b68bcf9de84a391d37 ]

Currently, on WCN3990, the station disconnect after hardware recovery is
not working as expected. This is because of setting the
IEEE80211_SDATA_DISCONNECT_HW_RESTART flag very early in the hardware
recovery process even before the driver invokes ieee80211_hw_restart().
On the contrary, mac80211 expects this flag to be set after
ieee80211_hw_restart() is invoked for it to trigger station disconnect.

Set the IEEE80211_SDATA_DISCONNECT_HW_RESTART flag in
ath10k_reconfig_complete() instead to fix this.

The other targets are not affected by this change, since the hardware
params flag is not set.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1

Fixes: 2c3fc50591ff ("ath10k: Trigger sta disconnect on hardware restart")
Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230518101515.3820-1-quic_youghand@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 9 ---------
 drivers/net/wireless/ath/ath10k/mac.c  | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5eb131ab916fd..b6052dcc45ebf 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2504,7 +2504,6 @@ EXPORT_SYMBOL(ath10k_core_napi_sync_disable);
 static void ath10k_core_restart(struct work_struct *work)
 {
 	struct ath10k *ar = container_of(work, struct ath10k, restart_work);
-	struct ath10k_vif *arvif;
 	int ret;
 
 	set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
@@ -2543,14 +2542,6 @@ static void ath10k_core_restart(struct work_struct *work)
 		ar->state = ATH10K_STATE_RESTARTING;
 		ath10k_halt(ar);
 		ath10k_scan_finish(ar);
-		if (ar->hw_params.hw_restart_disconnect) {
-			list_for_each_entry(arvif, &ar->arvifs, list) {
-				if (arvif->is_up &&
-				    arvif->vdev_type == WMI_VDEV_TYPE_STA)
-					ieee80211_hw_restart_disconnect(arvif->vif);
-			}
-		}
-
 		ieee80211_restart_hw(ar->hw);
 		break;
 	case ATH10K_STATE_OFF:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7675858f069bd..8c59d7ac92873 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8107,6 +8107,7 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 				     enum ieee80211_reconfig_type reconfig_type)
 {
 	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif;
 
 	if (reconfig_type != IEEE80211_RECONFIG_TYPE_RESTART)
 		return;
@@ -8121,6 +8122,12 @@ static void ath10k_reconfig_complete(struct ieee80211_hw *hw,
 		ar->state = ATH10K_STATE_ON;
 		ieee80211_wake_queues(ar->hw);
 		clear_bit(ATH10K_FLAG_RESTARTING, &ar->dev_flags);
+		if (ar->hw_params.hw_restart_disconnect) {
+			list_for_each_entry(arvif, &ar->arvifs, list) {
+				if (arvif->is_up && arvif->vdev_type == WMI_VDEV_TYPE_STA)
+					ieee80211_hw_restart_disconnect(arvif->vif);
+				}
+		}
 	}
 
 	mutex_unlock(&ar->conf_mutex);
-- 
2.39.2



