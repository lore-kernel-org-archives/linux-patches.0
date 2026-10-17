Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86074370ACE;
	Sat, 17 Oct 2026 16:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253319; cv=none; b=bPHTDiqpDbugY2kl0WJDqxu3IktD78CwJj50iqw61i8AMvtorPUbiJMFjf8k71JqIjN94dqZDzdgcujc7outF4+fuS8nrcpxBa76wNcTcIgZsKa7na0osMsDPGwQ4+sRyUD5a6CMv3w7IWwWHQXpyeyvh9MlIshRDkTETFweiMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253319; c=relaxed/simple;
	bh=GMVVwnCDM+gEFoE5PkgpffHaN4s7L7BHTFhea0usLaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQS+VMK2CHg1SNbvt3AswOsN0ThAtgHtUaZLFJOEvLWxFMrn9Rnpp+FBK+TyYS55Kfu+NtVgG5mWmqHSLhCSsQX0eQ/BbqITVc8P8/RXnDwC/d3v67Wo2DcSppBsQPy57EO+BGQh+nCNk4OkTZ/S1K+FEw/NZXHzN5I8Q3QdPlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8KSWj9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8KSWj9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865AD1F000C4;
	Sat, 17 Oct 2026 16:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253318;
	bh=PimKw8gSwOrwnpj1CddiBa8dmC4bkOxnCL6aJ923B7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8KSWj9X11Wrzpxy8Wdy+Ncpxi6KSMOokehMk/d8u5EforTlgXgoaKn+MaJoo9d5p
	 1GSn2kYVdN68f3L+aIezd8ZF6iP7CAR7nshwcA53TwaiN2ctJAKkGtka30dTPqUyvP
	 R36BPWuIgGPm4Bw3hRFG4aqylq1z0Wbtcvu4QZsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/869] wifi: ath12k: convert struct ath12k_sta::update_wk to use struct wiphy_work
Date: Sat, 17 Oct 2026 17:48:41 +0200
Message-ID: <20261017160039.079733265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit 58550cdda961dedad8ed08c5abf8367d5c020fb6 ]

For preparation to switch ath12k to use wiphy_lock() we can convert
ath12k_sta_rc_update_wk() to use wiphy_work_queue() for consistency. To avoid
any deadlocks do the struct ath12k_sta::update_wk conversion before switching
to using wiphy_lock() throughout the driver.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20241007165932.78081-3-kvalo@kernel.org
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Stable-dep-of: c426497fa205 ("wifi: ath12k: Fix memory leak due to multiple rx_stats allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.h |  2 +-
 drivers/net/wireless/ath/ath12k/mac.c  | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.h b/drivers/net/wireless/ath/ath12k/core.h
index 3faf3430effb9..3567150b49ffb 100644
--- a/drivers/net/wireless/ath/ath12k/core.h
+++ b/drivers/net/wireless/ath/ath12k/core.h
@@ -452,7 +452,7 @@ struct ath12k_sta {
 	u32 smps;
 	enum hal_pn_type pn_type;
 
-	struct work_struct update_wk;
+	struct wiphy_work update_wk;
 	struct rate_info txrate;
 	struct rate_info last_txrate;
 	u64 rx_duration;
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 8e8defddc8fa9..e5d3cfade4e1f 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4271,7 +4271,7 @@ static int ath12k_station_disassoc(struct ath12k *ar,
 	return 0;
 }
 
-static void ath12k_sta_rc_update_wk(struct work_struct *wk)
+static void ath12k_sta_rc_update_wk(struct wiphy *wiphy, struct wiphy_work *wk)
 {
 	struct ath12k *ar;
 	struct ath12k_vif *arvif;
@@ -4287,6 +4287,8 @@ static void ath12k_sta_rc_update_wk(struct work_struct *wk)
 	struct ath12k_wmi_peer_assoc_arg peer_arg;
 	enum wmi_phy_mode peer_phymode;
 
+	lockdep_assert_wiphy(wiphy);
+
 	arsta = container_of(wk, struct ath12k_sta, update_wk);
 	sta = container_of((void *)arsta, struct ieee80211_sta, drv_priv);
 	arvif = arsta->arvif;
@@ -4584,7 +4586,7 @@ static int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	/* cancel must be done outside the mutex to avoid deadlock */
 	if ((old_state == IEEE80211_STA_NONE &&
 	     new_state == IEEE80211_STA_NOTEXIST))
-		cancel_work_sync(&arsta->update_wk);
+		wiphy_work_cancel(hw->wiphy, &arsta->update_wk);
 
 	ar = ath12k_get_ar_by_vif(hw, vif);
 	if (!ar) {
@@ -4598,7 +4600,7 @@ static int ath12k_mac_op_sta_state(struct ieee80211_hw *hw,
 	    new_state == IEEE80211_STA_NONE) {
 		memset(arsta, 0, sizeof(*arsta));
 		arsta->arvif = arvif;
-		INIT_WORK(&arsta->update_wk, ath12k_sta_rc_update_wk);
+		wiphy_work_init(&arsta->update_wk, ath12k_sta_rc_update_wk);
 
 		ret = ath12k_mac_station_add(ar, vif, sta);
 		if (ret)
@@ -4809,7 +4811,7 @@ static void ath12k_mac_op_sta_rc_update(struct ieee80211_hw *hw,
 
 	spin_unlock_bh(&ar->data_lock);
 
-	ieee80211_queue_work(hw, &arsta->update_wk);
+	wiphy_work_queue(hw->wiphy, &arsta->update_wk);
 }
 
 static int ath12k_conf_tx_uapsd(struct ath12k_vif *arvif,
@@ -8119,7 +8121,7 @@ static void ath12k_mac_set_bitrate_mask_iter(void *data,
 	arsta->changed |= IEEE80211_RC_SUPP_RATES_CHANGED;
 	spin_unlock_bh(&ar->data_lock);
 
-	ieee80211_queue_work(ath12k_ar_to_hw(ar), &arsta->update_wk);
+	wiphy_work_queue(ath12k_ar_to_hw(ar)->wiphy, &arsta->update_wk);
 }
 
 static void ath12k_mac_disable_peer_fixed_rate(void *data,
-- 
2.53.0



