Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF1F27D766;
	Tue, 27 May 2025 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364805; cv=none; b=YKbMDYnBhG72USoYZ2zigKvpzbq4BA5y4JD4QcCsIQithR2fSoH/25MbBI1361DCv6FioMZFkfg+xers4RrhPoAA/WsQn0JFI5uQ3DEdEyeF2c6e/IlkvwlwGIogxCRtviZrF3C0tppNWN/b9BXI/vPHeKEQxuqxi+8z+/USKKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364805; c=relaxed/simple;
	bh=kIVTGS7q3KyU37wqvTxqrsRx7MtY5hwKC4xXHfjfe0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLXpZ9cIjKqoPVie1io2IwMH9TELlt6N19YzsAVhHWvWir6bmshmO0Xq99yLKE/qrANCabRMamDynAQ4WgqALyZSUCRjWu6bgZlYa7PCV0yFkWfMqzFqw3qJzEutTH5ZhP4iigMGxyShTq1ahQbP6DZK2PNo52zIUPV/PE4fSEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXEzI3qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXEzI3qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0A6C4CEF2;
	Tue, 27 May 2025 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364804;
	bh=kIVTGS7q3KyU37wqvTxqrsRx7MtY5hwKC4xXHfjfe0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXEzI3qahAnVj6L9JKuiCedCYHZepgtneajFWiUM9cCmoQmyle2i1AAY+rvMrWRFs
	 sPsexvUiSkD7eEluL5ma/MPk+otPcajPnLUhlqoZHg+7bxaKIP2Tue31o2eJuI9pTS
	 /AxfUOs3K0ynJyvAn2gG2XGavjViK4saniup4UUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 171/626] wifi: rtw89: set force HE TB mode when connecting to 11ax AP
Date: Tue, 27 May 2025 18:21:04 +0200
Message-ID: <20250527162451.967168650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit a9b56f219a0fa550f92e65ac58443a7892380e09 ]

Some of 11ax AP set the UL HE-SIG-A2 reserved subfield to all 0s, which
will cause the 11be chip to recognize trigger frame as EHT. We propose
a method to bypass the "UL HE-SIG-A2 reserved subfield" and always uses
HE TB in response to the AP's trigger frame.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250306021144.12854-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c      | 26 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/mac.h      |  2 ++
 drivers/net/wireless/realtek/rtw89/mac80211.c |  1 +
 drivers/net/wireless/realtek/rtw89/reg.h      |  4 +++
 4 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 4574aa62839b0..04e254bd6b17f 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4745,6 +4745,32 @@ void rtw89_mac_set_he_obss_narrow_bw_ru(struct rtw89_dev *rtwdev,
 		rtw89_write32_set(rtwdev, reg, mac->narrow_bw_ru_dis.mask);
 }
 
+void rtw89_mac_set_he_tb(struct rtw89_dev *rtwdev,
+			 struct rtw89_vif_link *rtwvif_link)
+{
+	struct ieee80211_bss_conf *bss_conf;
+	bool set;
+	u32 reg;
+
+	if (rtwdev->chip->chip_gen != RTW89_CHIP_BE)
+		return;
+
+	rcu_read_lock();
+
+	bss_conf = rtw89_vif_rcu_dereference_link(rtwvif_link, true);
+	set = bss_conf->he_support && !bss_conf->eht_support;
+
+	rcu_read_unlock();
+
+	reg = rtw89_mac_reg_by_idx(rtwdev, R_BE_CLIENT_OM_CTRL,
+				   rtwvif_link->mac_idx);
+
+	if (set)
+		rtw89_write32_set(rtwdev, reg, B_BE_TRIG_DIS_EHTTB);
+	else
+		rtw89_write32_clr(rtwdev, reg, B_BE_TRIG_DIS_EHTTB);
+}
+
 void rtw89_mac_stop_ap(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_link)
 {
 	rtw89_mac_port_cfg_func_sw(rtwdev, rtwvif_link);
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 0c269961a5731..5ba1133b79d64 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1160,6 +1160,8 @@ void rtw89_mac_port_cfg_rx_sync(struct rtw89_dev *rtwdev,
 				struct rtw89_vif_link *rtwvif_link, bool en);
 void rtw89_mac_set_he_obss_narrow_bw_ru(struct rtw89_dev *rtwdev,
 					struct rtw89_vif_link *rtwvif_link);
+void rtw89_mac_set_he_tb(struct rtw89_dev *rtwdev,
+			 struct rtw89_vif_link *rtwvif_link);
 void rtw89_mac_stop_ap(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_link);
 void rtw89_mac_enable_beacon_for_ap_vifs(struct rtw89_dev *rtwdev, bool en);
 int rtw89_mac_remove_vif(struct rtw89_dev *rtwdev, struct rtw89_vif_link *vif);
diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 8351a70d325d4..3a1a2b243adf0 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -669,6 +669,7 @@ static void __rtw89_ops_bss_link_assoc(struct rtw89_dev *rtwdev,
 	rtw89_chip_cfg_txpwr_ul_tb_offset(rtwdev, rtwvif_link);
 	rtw89_mac_port_update(rtwdev, rtwvif_link);
 	rtw89_mac_set_he_obss_narrow_bw_ru(rtwdev, rtwvif_link);
+	rtw89_mac_set_he_tb(rtwdev, rtwvif_link);
 }
 
 static void __rtw89_ops_bss_assoc(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 69678eab23093..9fbcc7fee290f 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -7093,6 +7093,10 @@
 #define B_BE_MACLBK_RDY_NUM_MASK GENMASK(7, 3)
 #define B_BE_MACLBK_EN BIT(0)
 
+#define R_BE_CLIENT_OM_CTRL 0x11040
+#define R_BE_CLIENT_OM_CTRL_C1 0x15040
+#define B_BE_TRIG_DIS_EHTTB BIT(24)
+
 #define R_BE_WMAC_NAV_CTL 0x11080
 #define R_BE_WMAC_NAV_CTL_C1 0x15080
 #define B_BE_WMAC_NAV_UPPER_EN BIT(26)
-- 
2.39.5



