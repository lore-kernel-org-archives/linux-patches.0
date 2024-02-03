Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21C81BF3A;
	Sat,  3 Feb 2024 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933804; cv=none; b=KL8VlKcaomiUQKa0BTHmn2DK9yeSji5ucKeDge3NdFsaKtisj8DNajY7jKGquy5RXT1gr7mZp+vso5UcAhgtcd0Un0hiBA5+IL+6+GZc9FneZvIVVBoywCyKfPnqWD9pPTtOTOH0TTEBTPK6+AzK9usalsCkPWIn0LKlzn0BTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933804; c=relaxed/simple;
	bh=qK/5v6FZlLfBUkK0SQ5xPX/MOHT8nPv7wHE2Ao+Tx1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChcxDSwTsykgUTUVPUVK6dE1DjfUZPDlOVoMXF45uTlX4RgcAjCxp5PUo0qGSDmKq2HDWbHkufC9jn+qb01yo0P93YF4mCn3ryW1Pck5T2GaBfDZgz9MOcm/ZkfmQGLTdtGjqk+9z6ZYfjhHY8tz6xsVXyvPmpp/8UpU/If58eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Umhow0uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Umhow0uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B16C43399;
	Sat,  3 Feb 2024 04:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933804;
	bh=qK/5v6FZlLfBUkK0SQ5xPX/MOHT8nPv7wHE2Ao+Tx1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Umhow0uyYLytKzK7LfLMUCfeKILLf0JJX93Yv0vwUKtSDo285jSz7G1TgeYhuhKTk
	 XkFbdEt2/ZOxHTAAz3l/yg+FDIAYErR1nH57lfW11WzdNi8TY0QEu3GyzM4RF1+5cP
	 MdPMTBPBB2LO9E3166hUL7ZvUbsIJK5xz865ewsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 093/353] wifi: rtw89: fix not entering PS mode after AP stops
Date: Fri,  2 Feb 2024 20:03:31 -0800
Message-ID: <20240203035406.742582488@linuxfoundation.org>
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

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 0052b3c401cdf39d3c3d12a0c3852175bc9a39c7 ]

The attempt to enter power save mode might fail if there are still
beacons pending in the queue. This sometimes happens after stopping
P2P GO or AP mode. Extend stop AP function and flush all beacons to
resolve this.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231129070046.18443-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 71 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw89/reg.h | 17 ++++++
 2 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 0c5768f41d55..add8a7ff01a5 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -3747,6 +3747,50 @@ static const struct rtw89_port_reg rtw89_port_base_ax = {
 		    R_AX_PORT_HGQ_WINDOW_CFG + 3},
 };
 
+static void rtw89_mac_check_packet_ctrl(struct rtw89_dev *rtwdev,
+					struct rtw89_vif *rtwvif, u8 type)
+{
+	u8 mask = B_AX_PTCL_DBG_INFO_MASK_BY_PORT(rtwvif->port);
+	u32 reg_info, reg_ctrl;
+	u32 val;
+	int ret;
+
+	reg_info = rtw89_mac_reg_by_idx(rtwdev, R_AX_PTCL_DBG_INFO, rtwvif->mac_idx);
+	reg_ctrl = rtw89_mac_reg_by_idx(rtwdev, R_AX_PTCL_DBG, rtwvif->mac_idx);
+
+	rtw89_write32_mask(rtwdev, reg_ctrl, B_AX_PTCL_DBG_SEL_MASK, type);
+	rtw89_write32_set(rtwdev, reg_ctrl, B_AX_PTCL_DBG_EN);
+	fsleep(100);
+
+	ret = read_poll_timeout(rtw89_read32_mask, val, val == 0, 1000, 100000,
+				true, rtwdev, reg_info, mask);
+	if (ret)
+		rtw89_warn(rtwdev, "Polling beacon packet empty fail\n");
+}
+
+static void rtw89_mac_bcn_drop(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
+{
+	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
+	const struct rtw89_port_reg *p = mac->port_base;
+
+	rtw89_write32_set(rtwdev, R_AX_BCN_DROP_ALL0, BIT(rtwvif->port));
+	rtw89_write32_port_mask(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_SETUP_MASK, 1);
+	rtw89_write32_port_mask(rtwdev, rtwvif, p->bcn_area, B_AX_BCN_MSK_AREA_MASK, 0);
+	rtw89_write32_port_mask(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_HOLD_MASK, 0);
+	rtw89_write32_port_mask(rtwdev, rtwvif, p->bcn_early, B_AX_BCNERLY_MASK, 2);
+	rtw89_write16_port_mask(rtwdev, rtwvif, p->tbtt_early, B_AX_TBTTERLY_MASK, 1);
+	rtw89_write32_port_mask(rtwdev, rtwvif, p->bcn_space, B_AX_BCN_SPACE_MASK, 1);
+	rtw89_write32_port_set(rtwdev, rtwvif, p->port_cfg, B_AX_BCNTX_EN);
+
+	rtw89_mac_check_packet_ctrl(rtwdev, rtwvif, AX_PTCL_DBG_BCNQ_NUM0);
+	if (rtwvif->port == RTW89_PORT_0)
+		rtw89_mac_check_packet_ctrl(rtwdev, rtwvif, AX_PTCL_DBG_BCNQ_NUM1);
+
+	rtw89_write32_clr(rtwdev, R_AX_BCN_DROP_ALL0, BIT(rtwvif->port));
+	rtw89_write32_port_clr(rtwdev, rtwvif, p->port_cfg, B_AX_TBTT_PROHIB_EN);
+	fsleep(2);
+}
+
 #define BCN_INTERVAL 100
 #define BCN_ERLY_DEF 160
 #define BCN_SETUP_DEF 2
@@ -3762,21 +3806,36 @@ static void rtw89_mac_port_cfg_func_sw(struct rtw89_dev *rtwdev,
 	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
 	const struct rtw89_port_reg *p = mac->port_base;
 	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif);
+	const struct rtw89_chip_info *chip = rtwdev->chip;
+	bool need_backup = false;
+	u32 backup_val;
 
 	if (!rtw89_read32_port_mask(rtwdev, rtwvif, p->port_cfg, B_AX_PORT_FUNC_EN))
 		return;
 
-	rtw89_write32_port_clr(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_SETUP_MASK);
-	rtw89_write32_port_mask(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_HOLD_MASK, 1);
-	rtw89_write16_port_clr(rtwdev, rtwvif, p->tbtt_early, B_AX_TBTTERLY_MASK);
-	rtw89_write16_port_clr(rtwdev, rtwvif, p->bcn_early, B_AX_BCNERLY_MASK);
+	if (chip->chip_id == RTL8852A && rtwvif->port != RTW89_PORT_0) {
+		need_backup = true;
+		backup_val = rtw89_read32_port(rtwdev, rtwvif, p->tbtt_prohib);
+	}
 
-	msleep(vif->bss_conf.beacon_int + 1);
+	if (rtwvif->net_type == RTW89_NET_TYPE_AP_MODE)
+		rtw89_mac_bcn_drop(rtwdev, rtwvif);
+
+	if (chip->chip_id == RTL8852A) {
+		rtw89_write32_port_clr(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_SETUP_MASK);
+		rtw89_write32_port_mask(rtwdev, rtwvif, p->tbtt_prohib, B_AX_TBTT_HOLD_MASK, 1);
+		rtw89_write16_port_clr(rtwdev, rtwvif, p->tbtt_early, B_AX_TBTTERLY_MASK);
+		rtw89_write16_port_clr(rtwdev, rtwvif, p->bcn_early, B_AX_BCNERLY_MASK);
+	}
 
+	msleep(vif->bss_conf.beacon_int + 1);
 	rtw89_write32_port_clr(rtwdev, rtwvif, p->port_cfg, B_AX_PORT_FUNC_EN |
 							    B_AX_BRK_SETUP);
 	rtw89_write32_port_set(rtwdev, rtwvif, p->port_cfg, B_AX_TSFTR_RST);
 	rtw89_write32_port(rtwdev, rtwvif, p->bcn_cnt_tmr, 0);
+
+	if (need_backup)
+		rtw89_write32_port(rtwdev, rtwvif, p->tbtt_prohib, backup_val);
 }
 
 static void rtw89_mac_port_cfg_tx_rpt(struct rtw89_dev *rtwdev,
@@ -4261,7 +4320,7 @@ void rtw89_mac_set_he_obss_narrow_bw_ru(struct rtw89_dev *rtwdev,
 
 void rtw89_mac_stop_ap(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 {
-	rtw89_mac_port_cfg_func_en(rtwdev, rtwvif, false);
+	rtw89_mac_port_cfg_func_sw(rtwdev, rtwvif);
 }
 
 int rtw89_mac_add_vif(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index ccd5481e8a3d..672010b9e026 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -2375,6 +2375,14 @@
 #define R_AX_TSFTR_HIGH_P4 0xC53C
 #define B_AX_TSFTR_HIGH_MASK GENMASK(31, 0)
 
+#define R_AX_BCN_DROP_ALL0 0xC560
+#define R_AX_BCN_DROP_ALL0_C1 0xE560
+#define B_AX_BCN_DROP_ALL_P4 BIT(4)
+#define B_AX_BCN_DROP_ALL_P3 BIT(3)
+#define B_AX_BCN_DROP_ALL_P2 BIT(2)
+#define B_AX_BCN_DROP_ALL_P1 BIT(1)
+#define B_AX_BCN_DROP_ALL_P0 BIT(0)
+
 #define R_AX_MBSSID_CTRL 0xC568
 #define R_AX_MBSSID_CTRL_C1 0xE568
 #define B_AX_P0MB_ALL_MASK GENMASK(23, 1)
@@ -2554,11 +2562,20 @@
 
 #define R_AX_PTCL_DBG_INFO 0xC6F0
 #define R_AX_PTCL_DBG_INFO_C1 0xE6F0
+#define B_AX_PTCL_DBG_INFO_MASK_BY_PORT(port) \
+({\
+	typeof(port) _port = (port); \
+	GENMASK((_port) * 2 + 1, (_port) * 2); \
+})
+
 #define B_AX_PTCL_DBG_INFO_MASK GENMASK(31, 0)
 #define R_AX_PTCL_DBG 0xC6F4
 #define R_AX_PTCL_DBG_C1 0xE6F4
 #define B_AX_PTCL_DBG_EN BIT(8)
 #define B_AX_PTCL_DBG_SEL_MASK GENMASK(7, 0)
+#define AX_PTCL_DBG_BCNQ_NUM0 8
+#define AX_PTCL_DBG_BCNQ_NUM1 9
+
 
 #define R_AX_DLE_CTRL 0xC800
 #define R_AX_DLE_CTRL_C1 0xE800
-- 
2.43.0



