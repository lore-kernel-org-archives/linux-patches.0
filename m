Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55A41BC53;
	Sat,  3 Feb 2024 04:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933786; cv=none; b=hZ0J7akW1twx6EXaNMALe3FU92PER0I7D/1MDkJjeUkesJPcTa83yfIbBygjUsp2S8aO8ei+XlO4Y4kI6QethvwSNmvaOmsB6vE3mlcbhmP74VE8T8aZZi8i3lk2CBD0zjX0RkndOOcy+qMMFAN2QlgkFUjCd7RtA5/AhBUmw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933786; c=relaxed/simple;
	bh=Y0PmSHZoU0z04W4oI7Efk/1of4KFDj7ro15G9nDF6sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diZKJzxlLFORBQCY0xqgB0XZlUCTx4TjMm5IMNcIn/YFush/tW86XnRZclY3k61m5tdSKPBJk8zsBLDsxuK1BfM3wLEd2BghTztU4/0Si+64b8x/iTflxOFASga2V+RUss5OKQBD9hAVkMka7RyNRiUNx3SJuome0M7hSA+U3pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZedW5mCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZedW5mCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F35BC433C7;
	Sat,  3 Feb 2024 04:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933786;
	bh=Y0PmSHZoU0z04W4oI7Efk/1of4KFDj7ro15G9nDF6sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZedW5mCzIbeUYda2IfHWnB9V6KrZ7QQV0Fnp9URez1yaqC8sQrIIJ3cwvtJuGntwp
	 EZtQp3crc0R+PFsXT/yWajiC9YcMmwlfNy4cGCnSm9/9bajr8MOpJrSkIevPC0oVlj
	 e2Kk3YlcOreJaoxX9HSJsBYEfHDcmLSPdbCfkZXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 094/353] wifi: rtw89: fix misbehavior of TX beacon in concurrent mode
Date: Fri,  2 Feb 2024 20:03:32 -0800
Message-ID: <20240203035406.772675062@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 756b31203d482d2dd1aa6c208978b0410dc7530f ]

In concurrent mode, when STA interface is scanning, it causes
AP interface TX beacon on wrong channel. We modified it to scan
with the operating channel when one of the interfaces is already
connected. Additionally, STA interface need to stop scan when AP
interface is starting to avoid TX beacon on wrong channel. Finally,
AP interface need to stop TX beacon when STA interface is scanning
and switching to non-OP channel,This prevent other device to get
beacons on wrong channel.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231129070046.18443-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c       | 17 +++++++++--
 drivers/net/wireless/realtek/rtw89/mac.c      | 29 +++++++++++++++----
 drivers/net/wireless/realtek/rtw89/mac.h      |  1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c |  3 ++
 4 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index a732c22a2d54..313ed4c45464 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -4043,6 +4043,7 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 	rtw89_core_scan_complete(rtwdev, vif, true);
 	ieee80211_scan_completed(rtwdev->hw, &info);
 	ieee80211_wake_queues(rtwdev->hw);
+	rtw89_mac_enable_beacon_for_ap_vifs(rtwdev, true);
 
 	rtw89_release_pkt_list(rtwdev);
 	rtwvif = (struct rtw89_vif *)vif->drv_priv;
@@ -4060,6 +4061,19 @@ void rtw89_hw_scan_abort(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif)
 	rtw89_hw_scan_complete(rtwdev, vif, true);
 }
 
+static bool rtw89_is_any_vif_connected_or_connecting(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_vif *rtwvif;
+
+	rtw89_for_each_rtwvif(rtwdev, rtwvif) {
+		/* This variable implies connected or during attempt to connect */
+		if (!is_zero_ether_addr(rtwvif->bssid))
+			return true;
+	}
+
+	return false;
+}
+
 int rtw89_hw_scan_offload(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 			  bool enable)
 {
@@ -4072,8 +4086,7 @@ int rtw89_hw_scan_offload(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 	if (!rtwvif)
 		return -EINVAL;
 
-	/* This variable implies connected or during attempt to connect */
-	connected = !is_zero_ether_addr(rtwvif->bssid);
+	connected = rtw89_is_any_vif_connected_or_connecting(rtwdev);
 	opt.enable = enable;
 	opt.target_ch_mode = connected;
 	if (enable) {
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index add8a7ff01a5..d0c7de4e80dc 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3916,12 +3916,10 @@ static void rtw89_mac_port_cfg_rx_sync(struct rtw89_dev *rtwdev,
 }
 
 static void rtw89_mac_port_cfg_tx_sw(struct rtw89_dev *rtwdev,
-				     struct rtw89_vif *rtwvif)
+				     struct rtw89_vif *rtwvif, bool en)
 {
 	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
 	const struct rtw89_port_reg *p = mac->port_base;
-	bool en = rtwvif->net_type == RTW89_NET_TYPE_AP_MODE ||
-		  rtwvif->net_type == RTW89_NET_TYPE_AD_HOC;
 
 	if (en)
 		rtw89_write32_port_set(rtwdev, rtwvif, p->port_cfg, B_AX_BCNTX_EN);
@@ -3929,6 +3927,24 @@ static void rtw89_mac_port_cfg_tx_sw(struct rtw89_dev *rtwdev,
 		rtw89_write32_port_clr(rtwdev, rtwvif, p->port_cfg, B_AX_BCNTX_EN);
 }
 
+static void rtw89_mac_port_cfg_tx_sw_by_nettype(struct rtw89_dev *rtwdev,
+						struct rtw89_vif *rtwvif)
+{
+	bool en = rtwvif->net_type == RTW89_NET_TYPE_AP_MODE ||
+		  rtwvif->net_type == RTW89_NET_TYPE_AD_HOC;
+
+	rtw89_mac_port_cfg_tx_sw(rtwdev, rtwvif, en);
+}
+
+void rtw89_mac_enable_beacon_for_ap_vifs(struct rtw89_dev *rtwdev, bool en)
+{
+	struct rtw89_vif *rtwvif;
+
+	rtw89_for_each_rtwvif(rtwdev, rtwvif)
+		if (rtwvif->net_type == RTW89_NET_TYPE_AP_MODE)
+			rtw89_mac_port_cfg_tx_sw(rtwdev, rtwvif, en);
+}
+
 static void rtw89_mac_port_cfg_bcn_intv(struct rtw89_dev *rtwdev,
 					struct rtw89_vif *rtwvif)
 {
@@ -4235,7 +4251,7 @@ int rtw89_mac_port_update(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	rtw89_mac_port_cfg_bcn_prct(rtwdev, rtwvif);
 	rtw89_mac_port_cfg_rx_sw(rtwdev, rtwvif);
 	rtw89_mac_port_cfg_rx_sync(rtwdev, rtwvif);
-	rtw89_mac_port_cfg_tx_sw(rtwdev, rtwvif);
+	rtw89_mac_port_cfg_tx_sw_by_nettype(rtwdev, rtwvif);
 	rtw89_mac_port_cfg_bcn_intv(rtwdev, rtwvif);
 	rtw89_mac_port_cfg_hiq_win(rtwdev, rtwvif);
 	rtw89_mac_port_cfg_hiq_dtim(rtwdev, rtwvif);
@@ -4397,8 +4413,10 @@ rtw89_mac_c2h_scanofld_rsp(struct rtw89_dev *rtwdev, struct sk_buff *c2h,
 
 	switch (reason) {
 	case RTW89_SCAN_LEAVE_CH_NOTIFY:
-		if (rtw89_is_op_chan(rtwdev, band, chan))
+		if (rtw89_is_op_chan(rtwdev, band, chan)) {
+			rtw89_mac_enable_beacon_for_ap_vifs(rtwdev, false);
 			ieee80211_stop_queues(rtwdev->hw);
+		}
 		return;
 	case RTW89_SCAN_END_SCAN_NOTIFY:
 		if (rtwvif && rtwvif->scan_req &&
@@ -4416,6 +4434,7 @@ rtw89_mac_c2h_scanofld_rsp(struct rtw89_dev *rtwdev, struct sk_buff *c2h,
 		if (rtw89_is_op_chan(rtwdev, band, chan)) {
 			rtw89_assign_entity_chan(rtwdev, rtwvif->sub_entity_idx,
 						 &rtwdev->scan_info.op_chan);
+			rtw89_mac_enable_beacon_for_ap_vifs(rtwdev, true);
 			ieee80211_wake_queues(rtwdev->hw);
 		} else {
 			rtw89_chan_create(&new, chan, chan, band,
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index c11c904f87fe..f9fef678f314 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -992,6 +992,7 @@ int rtw89_mac_port_get_tsf(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif,
 void rtw89_mac_set_he_obss_narrow_bw_ru(struct rtw89_dev *rtwdev,
 					struct ieee80211_vif *vif);
 void rtw89_mac_stop_ap(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif);
+void rtw89_mac_enable_beacon_for_ap_vifs(struct rtw89_dev *rtwdev, bool en);
 int rtw89_mac_remove_vif(struct rtw89_dev *rtwdev, struct rtw89_vif *vif);
 int rtw89_mac_enable_bb_rf(struct rtw89_dev *rtwdev);
 int rtw89_mac_disable_bb_rf(struct rtw89_dev *rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 31d1f7891675..b7ceaf5595eb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -477,6 +477,9 @@ static int rtw89_ops_start_ap(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 	}
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	ether_addr_copy(rtwvif->bssid, vif->bss_conf.bssid);
 	rtw89_cam_bssid_changed(rtwdev, rtwvif);
 	rtw89_mac_port_update(rtwdev, rtwvif);
-- 
2.43.0



