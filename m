Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B5A27BF8D;
	Tue, 27 May 2025 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368163; cv=none; b=g3tFYzBIUxViRoI+MXDhLgNtdlAFNvJq/1jOnlEJyiIgcKPVy+PhRvy1xs+1FtYoUW7ZEDxZxPDjrLxzfWouPaas+qeexe//Fm22EDrsnXqN9UWBgvYFsPqcrfSI4nB7rM8PO/NxxUrBspHBdw5evBDSilQJrme6r1puD8AQNYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368163; c=relaxed/simple;
	bh=KKGObGZxyHX6U5ppBlzY4jdwcknupnulzX74VwtMYzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1gfB9olvCWovEOcDp9yIPLGK+hBqqYwnX9xJ3aiQ5htws+jLQsxAckElxDvgDqGDJ732SoAXuT9hqou4F0ClripERVyoMOh+l8uLFnNsVkgBvMWwd1g83Xqe/jJ+Xq0CCuRp/3EVG7k4NGDNzaaanMTKCHLZQpzP0F3OJID1Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU/nCO65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU/nCO65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA5C4CEE9;
	Tue, 27 May 2025 17:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368163;
	bh=KKGObGZxyHX6U5ppBlzY4jdwcknupnulzX74VwtMYzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU/nCO65vnDtqhEz73Yc/Z2Efmln7xAAnkJzl9t75nR6tMvPr+gz6YOij2ICjXpjj
	 kWM/795O9BRbfetFA5v3N9rexv6KqI4v83D3TremoBvLHv1nSJYeX9IJzaTqmgtfFV
	 VsiRK8TWK+e/NQYY8qZW80uxTmt8ORGJmnhu1K+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 619/783] wifi: rtw89: coex: Add protect to avoid A2DP lag while Wi-Fi connecting
Date: Tue, 27 May 2025 18:26:56 +0200
Message-ID: <20250527162538.360275551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit 5251fd321684b591245a072b765d01a6c22a112c ]

To get a well Wi-Fi RF quality, Wi-Fi need to do RF calibrations. While
Wi-Fi is doing RF calibrations, driver will pause the Bluetooth traffic
to make sure the RF calibration will not be interfered by Bluetooth.
However, if the RF calibrations take too much time, Bluetooth audio
will perform a lag sound. Add a function to make Bluetooth can do
traffic between the individual calibrations to avoid Bluetooth sound
lag. And patch related A2DP coexistence mechanism actions.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250110015416.10704-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c     | 90 +++++++++++--------
 drivers/net/wireless/realtek/rtw89/coex.h     |  2 +
 drivers/net/wireless/realtek/rtw89/core.h     |  3 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c |  6 ++
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |  6 ++
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |  6 ++
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |  6 ++
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |  6 ++
 8 files changed, 85 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 7b10ee97c6277..86e8f78ec94a4 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -4587,17 +4587,16 @@ static void _action_bt_a2dp(struct rtw89_dev *rtwdev)
 
 	_set_ant(rtwdev, NM_EXEC, BTC_PHY_ALL, BTC_ANT_W2G);
 
+	if (a2dp.vendor_id == 0x4c || dm->leak_ap || bt_linfo->slave_role)
+		dm->slot_dur[CXST_W1] = 20;
+	else
+		dm->slot_dur[CXST_W1] = 40;
+
+	dm->slot_dur[CXST_B1] = BTC_B1_MAX;
+
 	switch (btc->cx.state_map) {
 	case BTC_WBUSY_BNOSCAN: /* wl-busy + bt-A2DP */
-		if (a2dp.vendor_id == 0x4c || dm->leak_ap) {
-			dm->slot_dur[CXST_W1] = 40;
-			dm->slot_dur[CXST_B1] = 200;
-			_set_policy(rtwdev,
-				    BTC_CXP_PAUTO_TDW1B1, BTC_ACT_BT_A2DP);
-		} else {
-			_set_policy(rtwdev,
-				    BTC_CXP_PAUTO_TD50B1, BTC_ACT_BT_A2DP);
-		}
+		_set_policy(rtwdev, BTC_CXP_PAUTO_TDW1B1, BTC_ACT_BT_A2DP);
 		break;
 	case BTC_WBUSY_BSCAN: /* wl-busy + bt-inq + bt-A2DP */
 		_set_policy(rtwdev, BTC_CXP_PAUTO2_TD3050, BTC_ACT_BT_A2DP);
@@ -4607,15 +4606,10 @@ static void _action_bt_a2dp(struct rtw89_dev *rtwdev)
 		break;
 	case BTC_WSCAN_BNOSCAN: /* wl-scan + bt-A2DP */
 	case BTC_WLINKING: /* wl-connecting + bt-A2DP */
-		if (a2dp.vendor_id == 0x4c || dm->leak_ap) {
-			dm->slot_dur[CXST_W1] = 40;
-			dm->slot_dur[CXST_B1] = 200;
-			_set_policy(rtwdev, BTC_CXP_AUTO_TDW1B1,
-				    BTC_ACT_BT_A2DP);
-		} else {
-			_set_policy(rtwdev, BTC_CXP_AUTO_TD50B1,
-				    BTC_ACT_BT_A2DP);
-		}
+		if (btc->cx.wl.rfk_info.con_rfk)
+			_set_policy(rtwdev, BTC_CXP_OFF_BT, BTC_ACT_BT_A2DP);
+		else
+			_set_policy(rtwdev, BTC_CXP_AUTO_TDW1B1, BTC_ACT_BT_A2DP);
 		break;
 	case BTC_WIDLE:  /* wl-idle + bt-A2DP */
 		_set_policy(rtwdev, BTC_CXP_AUTO_TD20B1, BTC_ACT_BT_A2DP);
@@ -4643,7 +4637,10 @@ static void _action_bt_a2dpsink(struct rtw89_dev *rtwdev)
 		_set_policy(rtwdev, BTC_CXP_FIX_TD2060, BTC_ACT_BT_A2DPSINK);
 		break;
 	case BTC_WLINKING: /* wl-connecting + bt-A2dp_Sink */
-		_set_policy(rtwdev, BTC_CXP_FIX_TD3030, BTC_ACT_BT_A2DPSINK);
+		if (btc->cx.wl.rfk_info.con_rfk)
+			_set_policy(rtwdev, BTC_CXP_OFF_BT, BTC_ACT_BT_A2DPSINK);
+		else
+			_set_policy(rtwdev, BTC_CXP_FIX_TD3030, BTC_ACT_BT_A2DPSINK);
 		break;
 	case BTC_WIDLE: /* wl-idle + bt-A2dp_Sink */
 		_set_policy(rtwdev, BTC_CXP_FIX_TD2080, BTC_ACT_BT_A2DPSINK);
@@ -4697,21 +4694,20 @@ static void _action_bt_a2dp_hid(struct rtw89_dev *rtwdev)
 
 	_set_ant(rtwdev, NM_EXEC, BTC_PHY_ALL, BTC_ANT_W2G);
 
+	if (a2dp.vendor_id == 0x4c || dm->leak_ap || bt_linfo->slave_role)
+		dm->slot_dur[CXST_W1] = 20;
+	else
+		dm->slot_dur[CXST_W1] = 40;
+
+	dm->slot_dur[CXST_B1] = BTC_B1_MAX;
+
 	switch (btc->cx.state_map) {
 	case BTC_WBUSY_BNOSCAN: /* wl-busy + bt-A2DP+HID */
 	case BTC_WIDLE:  /* wl-idle + bt-A2DP */
-		if (a2dp.vendor_id == 0x4c || dm->leak_ap) {
-			dm->slot_dur[CXST_W1] = 40;
-			dm->slot_dur[CXST_B1] = 200;
-			_set_policy(rtwdev,
-				    BTC_CXP_PAUTO_TDW1B1, BTC_ACT_BT_A2DP_HID);
-		} else {
-			_set_policy(rtwdev,
-				    BTC_CXP_PAUTO_TD50B1, BTC_ACT_BT_A2DP_HID);
-		}
+		_set_policy(rtwdev, BTC_CXP_PAUTO_TDW1B1, BTC_ACT_BT_A2DP_HID);
 		break;
 	case BTC_WBUSY_BSCAN: /* wl-busy + bt-inq + bt-A2DP+HID */
-		_set_policy(rtwdev, BTC_CXP_PAUTO2_TD3050, BTC_ACT_BT_A2DP_HID);
+		_set_policy(rtwdev, BTC_CXP_PAUTO2_TD3070, BTC_ACT_BT_A2DP_HID);
 		break;
 
 	case BTC_WSCAN_BSCAN: /* wl-scan + bt-inq + bt-A2DP+HID */
@@ -4719,15 +4715,10 @@ static void _action_bt_a2dp_hid(struct rtw89_dev *rtwdev)
 		break;
 	case BTC_WSCAN_BNOSCAN: /* wl-scan + bt-A2DP+HID */
 	case BTC_WLINKING: /* wl-connecting + bt-A2DP+HID */
-		if (a2dp.vendor_id == 0x4c || dm->leak_ap) {
-			dm->slot_dur[CXST_W1] = 40;
-			dm->slot_dur[CXST_B1] = 200;
-			_set_policy(rtwdev, BTC_CXP_AUTO_TDW1B1,
-				    BTC_ACT_BT_A2DP_HID);
-		} else {
-			_set_policy(rtwdev, BTC_CXP_AUTO_TD50B1,
-				    BTC_ACT_BT_A2DP_HID);
-		}
+		if (btc->cx.wl.rfk_info.con_rfk)
+			_set_policy(rtwdev, BTC_CXP_OFF_BT, BTC_ACT_BT_A2DP_HID);
+		else
+			_set_policy(rtwdev, BTC_CXP_AUTO_TDW1B1, BTC_ACT_BT_A2DP_HID);
 		break;
 	}
 }
@@ -7001,7 +6992,7 @@ void _run_coex(struct rtw89_dev *rtwdev, enum btc_reason_and_action reason)
 		goto exit;
 	}
 
-	if (wl->status.val & btc_scanning_map.val) {
+	if (wl->status.val & btc_scanning_map.val && !wl->rfk_info.con_rfk) {
 		_action_wl_scan(rtwdev);
 		bt->scan_rx_low_pri = true;
 		goto exit;
@@ -11040,3 +11031,24 @@ void rtw89_coex_recognize_ver(struct rtw89_dev *rtwdev)
 	rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC] use version def[%d] = 0x%08x\n",
 		    (int)(btc->ver - rtw89_btc_ver_defs), btc->ver->fw_ver_code);
 }
+
+void rtw89_btc_ntfy_preserve_bt_time(struct rtw89_dev *rtwdev, u32 ms)
+{
+	struct rtw89_btc_bt_link_info *bt_linfo = &rtwdev->btc.cx.bt.link_info;
+	struct rtw89_btc_bt_a2dp_desc a2dp = bt_linfo->a2dp_desc;
+
+	if (test_bit(RTW89_FLAG_SER_HANDLING, rtwdev->flags))
+		return;
+
+	if (!a2dp.exist)
+		return;
+
+	fsleep(ms * 1000);
+}
+EXPORT_SYMBOL(rtw89_btc_ntfy_preserve_bt_time);
+
+void rtw89_btc_ntfy_conn_rfk(struct rtw89_dev *rtwdev, bool state)
+{
+	rtwdev->btc.cx.wl.rfk_info.con_rfk = state;
+}
+EXPORT_SYMBOL(rtw89_btc_ntfy_conn_rfk);
diff --git a/drivers/net/wireless/realtek/rtw89/coex.h b/drivers/net/wireless/realtek/rtw89/coex.h
index dbdb56e063ef0..757d03675cf4e 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.h
+++ b/drivers/net/wireless/realtek/rtw89/coex.h
@@ -290,6 +290,8 @@ void rtw89_coex_power_on(struct rtw89_dev *rtwdev);
 void rtw89_btc_set_policy(struct rtw89_dev *rtwdev, u16 policy_type);
 void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type);
 void rtw89_coex_recognize_ver(struct rtw89_dev *rtwdev);
+void rtw89_btc_ntfy_preserve_bt_time(struct rtw89_dev *rtwdev, u32 ms);
+void rtw89_btc_ntfy_conn_rfk(struct rtw89_dev *rtwdev, bool state);
 
 static inline u8 rtw89_btc_phymap(struct rtw89_dev *rtwdev,
 				  enum rtw89_phy_idx phy_idx,
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index c493153ec77b3..963f0046f0bc3 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1762,7 +1762,8 @@ struct rtw89_btc_wl_rfk_info {
 	u32 phy_map: 2;
 	u32 band: 2;
 	u32 type: 8;
-	u32 rsvd: 14;
+	u32 con_rfk: 1;
+	u32 rsvd: 13;
 
 	u32 start_time;
 	u32 proc_time;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index a1df4ba97cd4d..546e88cd46493 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -1596,10 +1596,16 @@ static void rtw8851b_rfk_channel(struct rtw89_dev *rtwdev,
 	enum rtw89_chanctx_idx chanctx_idx = rtwvif_link->chanctx_idx;
 	enum rtw89_phy_idx phy_idx = rtwvif_link->phy_idx;
 
+	rtw89_btc_ntfy_conn_rfk(rtwdev, true);
+
 	rtw8851b_rx_dck(rtwdev, phy_idx, chanctx_idx);
 	rtw8851b_iqk(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8851b_tssi(rtwdev, phy_idx, true, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8851b_dpk(rtwdev, phy_idx, chanctx_idx);
+
+	rtw89_btc_ntfy_conn_rfk(rtwdev, false);
 }
 
 static void rtw8851b_rfk_band_changed(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index cd79a997fe022..e12e5bd402e5b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -1356,10 +1356,16 @@ static void rtw8852a_rfk_channel(struct rtw89_dev *rtwdev,
 	enum rtw89_chanctx_idx chanctx_idx = rtwvif_link->chanctx_idx;
 	enum rtw89_phy_idx phy_idx = rtwvif_link->phy_idx;
 
+	rtw89_btc_ntfy_conn_rfk(rtwdev, true);
+
 	rtw8852a_rx_dck(rtwdev, phy_idx, true, chanctx_idx);
 	rtw8852a_iqk(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852a_tssi(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852a_dpk(rtwdev, phy_idx, chanctx_idx);
+
+	rtw89_btc_ntfy_conn_rfk(rtwdev, false);
 }
 
 static void rtw8852a_rfk_band_changed(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index fcb69fa6cf86d..ab9365b0ec089 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -568,10 +568,16 @@ static void rtw8852b_rfk_channel(struct rtw89_dev *rtwdev,
 	enum rtw89_chanctx_idx chanctx_idx = rtwvif_link->chanctx_idx;
 	enum rtw89_phy_idx phy_idx = rtwvif_link->phy_idx;
 
+	rtw89_btc_ntfy_conn_rfk(rtwdev, true);
+
 	rtw8852b_rx_dck(rtwdev, phy_idx, chanctx_idx);
 	rtw8852b_iqk(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852b_tssi(rtwdev, phy_idx, true, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852b_dpk(rtwdev, phy_idx, chanctx_idx);
+
+	rtw89_btc_ntfy_conn_rfk(rtwdev, false);
 }
 
 static void rtw8852b_rfk_band_changed(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
index bc740e9abf263..412e633944f37 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
@@ -541,10 +541,16 @@ static void rtw8852bt_rfk_channel(struct rtw89_dev *rtwdev,
 	enum rtw89_chanctx_idx chanctx_idx = rtwvif_link->chanctx_idx;
 	enum rtw89_phy_idx phy_idx = rtwvif_link->phy_idx;
 
+	rtw89_btc_ntfy_conn_rfk(rtwdev, true);
+
 	rtw8852bt_rx_dck(rtwdev, phy_idx, chanctx_idx);
 	rtw8852bt_iqk(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852bt_tssi(rtwdev, phy_idx, true, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852bt_dpk(rtwdev, phy_idx, chanctx_idx);
+
+	rtw89_btc_ntfy_conn_rfk(rtwdev, false);
 }
 
 static void rtw8852bt_rfk_band_changed(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index 63a2bc88cdbcd..cd68f6cbeecbf 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -1853,10 +1853,16 @@ static void rtw8852c_rfk_channel(struct rtw89_dev *rtwdev,
 	enum rtw89_phy_idx phy_idx = rtwvif_link->phy_idx;
 
 	rtw8852c_mcc_get_ch_info(rtwdev, phy_idx);
+	rtw89_btc_ntfy_conn_rfk(rtwdev, true);
+
 	rtw8852c_rx_dck(rtwdev, phy_idx, false);
 	rtw8852c_iqk(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852c_tssi(rtwdev, phy_idx, chanctx_idx);
+	rtw89_btc_ntfy_preserve_bt_time(rtwdev, 30);
 	rtw8852c_dpk(rtwdev, phy_idx, chanctx_idx);
+
+	rtw89_btc_ntfy_conn_rfk(rtwdev, false);
 	rtw89_fw_h2c_rf_ntfy_mcc(rtwdev);
 }
 
-- 
2.39.5



