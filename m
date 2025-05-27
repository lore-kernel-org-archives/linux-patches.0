Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB43C01;
	Tue, 27 May 2025 17:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367295; cv=none; b=ryj3mkZjamjyw+hgTi45o+0pqCC7Q5fTH2Jj/jGfsLeJPPgnSmhk1XTWc7HEB2TTDDIUn4WFF3V7W0XPilfd7GVafqwk/F+ITOFIDcvpZa9IpVskVIi4aHGSMUMzSLOcy+dUcgDQM04aHGVrOnUDI1I5LyJyk8Z28zdKM5GAnCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367295; c=relaxed/simple;
	bh=WxUNYzwH2M2DWlSVn1csG93S+v6sCvJ0tiGUOjKEVB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5V3GbvAAqaKy39u8z4M5cUmjEfb7suKBmW691QoatM2ddS1qLCiJZssu0CjTbO0eXDDn7BAJ3ZnpNsyG72eEgDrmbpjVi9wmCFaIWETMKcTHEaQLu7vqyW22/wPT4QvfLSokbG9cCFw5hdh780zh6z9wiKMhyU8VTaFz3MH5OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk3z7xOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk3z7xOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345F0C4CEE9;
	Tue, 27 May 2025 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367295;
	bh=WxUNYzwH2M2DWlSVn1csG93S+v6sCvJ0tiGUOjKEVB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk3z7xOkB98vJKd43YL76xxmIdenXSvkg27bZgwSUHaPWA4FBbDBQNepmXwK+CynB
	 /6RjOiY3BTm9CMGC6E1nz86rippzuaQMQnSbRcmfXWoQwVLLeKQbSWiZKAMABQpV/3
	 fskd/CAgEwsR4/M+s94t2DykWhXRpCMWE4vskPI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 341/783] wifi: rtw89: Parse channel from IE to correct invalid hardware reports during scanning
Date: Tue, 27 May 2025 18:22:18 +0200
Message-ID: <20250527162526.955070445@linuxfoundation.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit e16acf907a3c66b9996a5df43e177a5edec8e0a5 ]

For some packets, we could not get channel information from PPDU status.
And this causes wrong frequencies being reported. Parse the channel
information from IE if provided by AP to fix this.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250220064357.17962-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c     | 44 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/core.h     |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8851b.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |  1 +
 .../net/wireless/realtek/rtw89/rtw8852bt.c    |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |  1 +
 drivers/net/wireless/realtek/rtw89/rtw8922a.c |  1 +
 8 files changed, 51 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 85f739f1173d8..c84446ec9e4f4 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2381,6 +2381,49 @@ static void rtw89_core_validate_rx_signal(struct ieee80211_rx_status *rx_status)
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 }
 
+static void rtw89_core_update_rx_freq_from_ie(struct rtw89_dev *rtwdev,
+					      struct sk_buff *skb,
+					      struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+	size_t hdr_len, ielen;
+	u8 *variable;
+	int chan;
+
+	if (!rtwdev->chip->rx_freq_frome_ie)
+		return;
+
+	if (!rtwdev->scanning)
+		return;
+
+	if (ieee80211_is_beacon(mgmt->frame_control)) {
+		variable = mgmt->u.beacon.variable;
+		hdr_len = offsetof(struct ieee80211_mgmt,
+				   u.beacon.variable);
+	} else if (ieee80211_is_probe_resp(mgmt->frame_control)) {
+		variable = mgmt->u.probe_resp.variable;
+		hdr_len = offsetof(struct ieee80211_mgmt,
+				   u.probe_resp.variable);
+	} else {
+		return;
+	}
+
+	if (skb->len > hdr_len)
+		ielen = skb->len - hdr_len;
+	else
+		return;
+
+	/* The parsing code for both 2GHz and 5GHz bands is the same in this
+	 * function.
+	 */
+	chan = cfg80211_get_ies_channel_number(variable, ielen, NL80211_BAND_2GHZ);
+	if (chan == -1)
+		return;
+
+	rx_status->band = chan > 14 ? RTW89_BAND_5G : RTW89_BAND_2G;
+	rx_status->freq = ieee80211_channel_to_frequency(chan, rx_status->band);
+}
+
 static void rtw89_core_rx_to_mac80211(struct rtw89_dev *rtwdev,
 				      struct rtw89_rx_phy_ppdu *phy_ppdu,
 				      struct rtw89_rx_desc_info *desc_info,
@@ -2398,6 +2441,7 @@ static void rtw89_core_rx_to_mac80211(struct rtw89_dev *rtwdev,
 	rtw89_core_update_rx_status_by_ppdu(rtwdev, rx_status, phy_ppdu);
 	rtw89_core_update_radiotap(rtwdev, skb_ppdu, rx_status);
 	rtw89_core_validate_rx_signal(rx_status);
+	rtw89_core_update_rx_freq_from_ie(rtwdev, skb_ppdu, rx_status);
 
 	/* In low power mode, it does RX in thread context. */
 	local_bh_disable();
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 93e41def81b40..979587e92c849 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4273,6 +4273,7 @@ struct rtw89_chip_info {
 	bool support_ant_gain;
 	bool ul_tb_waveform_ctrl;
 	bool ul_tb_pwr_diff;
+	bool rx_freq_frome_ie;
 	bool hw_sec_hdr;
 	bool hw_mgmt_tx_encrypt;
 	u8 rf_path_num;
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851b.c b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
index c56f70267882a..24d48aced57ac 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851b.c
@@ -2485,6 +2485,7 @@ const struct rtw89_chip_info rtw8851b_chip_info = {
 	.support_ant_gain	= false,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
+	.rx_freq_frome_ie	= true,
 	.hw_sec_hdr		= false,
 	.hw_mgmt_tx_encrypt	= false,
 	.rf_path_num		= 1,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 9bd2842c27d50..eeb40a60c2b98 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2203,6 +2203,7 @@ const struct rtw89_chip_info rtw8852a_chip_info = {
 	.support_ant_gain	= false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
+	.rx_freq_frome_ie	= true,
 	.hw_sec_hdr		= false,
 	.hw_mgmt_tx_encrypt	= false,
 	.rf_path_num		= 2,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index dfb2bf61b0b83..4335fa85c334b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -839,6 +839,7 @@ const struct rtw89_chip_info rtw8852b_chip_info = {
 	.support_ant_gain	= true,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
+	.rx_freq_frome_ie	= true,
 	.hw_sec_hdr		= false,
 	.hw_mgmt_tx_encrypt	= false,
 	.rf_path_num		= 2,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
index bde3e1fb7ca62..7f64a5695486b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bt.c
@@ -772,6 +772,7 @@ const struct rtw89_chip_info rtw8852bt_chip_info = {
 	.support_ant_gain	= true,
 	.ul_tb_waveform_ctrl	= true,
 	.ul_tb_pwr_diff		= false,
+	.rx_freq_frome_ie	= true,
 	.hw_sec_hdr		= false,
 	.hw_mgmt_tx_encrypt     = false,
 	.rf_path_num		= 2,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c.c b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
index bc84b15e7826d..9778621d9bc41 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -2998,6 +2998,7 @@ const struct rtw89_chip_info rtw8852c_chip_info = {
 	.support_ant_gain	= true,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= true,
+	.rx_freq_frome_ie	= false,
 	.hw_sec_hdr		= true,
 	.hw_mgmt_tx_encrypt	= true,
 	.rf_path_num		= 2,
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 11d66bfceb15f..731bc6f18d38b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -2763,6 +2763,7 @@ const struct rtw89_chip_info rtw8922a_chip_info = {
 	.support_ant_gain	= false,
 	.ul_tb_waveform_ctrl	= false,
 	.ul_tb_pwr_diff		= false,
+	.rx_freq_frome_ie	= false,
 	.hw_sec_hdr		= true,
 	.hw_mgmt_tx_encrypt	= true,
 	.rf_path_num		= 2,
-- 
2.39.5



