Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1E4149E17;
	Tue, 25 Jun 2024 09:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309332; cv=none; b=KLXQApnsf0VhYEgf0UCQLHVHssb52YY8UXzDUkMcJhCVtFRWycFaWIdEkYIjdOrz7MuIK2s/BrPaAZqs45BQOHfZkKK9fw89iSAm1+cTlysznAbLlWCTDrVxRyQBRpRSDkUAJrx0HoKwFE9EqhbKFzWuZ/iZ8aMY//xvx+F1Mbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309332; c=relaxed/simple;
	bh=G0MRyG2uxceceOLFyEJbAzCYeeqrnScP0k8ThtL/w7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlnOPRE5tvI5ZvUllTyakZuTuYsxqSp/riEEnfLbJmTbCykLzHvWTTKIo7VQ3lRBgoOHbY9Ndfg1Th51fh8kBnWl0KltPvf1Nmsk/aNceass/JSK8XZK2Yc+rkW1dcP/ZCDvJDJ1frweDMB1mx/BP1KUQ0wKvMqSmNKH3EkabfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkeIr0KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkeIr0KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26824C32789;
	Tue, 25 Jun 2024 09:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309332;
	bh=G0MRyG2uxceceOLFyEJbAzCYeeqrnScP0k8ThtL/w7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkeIr0KQ+Ya68oz323dr4rxUpO9H/M/07xWRNZBovOPnefpxUITw7jLkIy0nUI00Z
	 Erd9bB6h+6VJ0zpbPip9xF1h5iLiKcL9gdpLfZkA6yj7rDvfgbXkuUDz5HNPmPHvjJ
	 AIeeBJJp8w6Ca38xxJYclqYDV0s8Na2zHTKKi6jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/192] wifi: rtl8xxxu: enable MFP support with security flag of RX descriptor
Date: Tue, 25 Jun 2024 11:34:05 +0200
Message-ID: <20240625085543.800413967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit cbfbb4ddbc8503478e0a138f9a31f61686cc5f11 ]

In order to connect to networks which require 802.11w, add the
MFP_CAPABLE flag and let mac80211 do the actual crypto in software.

When a robust management frame is received, rx_dec->swdec is not set,
even though the HW did not decrypt it. Extend the check and don't set
RX_FLAG_DECRYPTED for these frames in order to use SW decryption.

Use the security flag in the RX descriptor for this purpose, like it is
done in the rtw88 driver.

Cc: stable@vger.kernel.org
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240418071813.1883174-3-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 9 +++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4695fb4e2d2db..af541e52e683b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -121,6 +121,15 @@ enum rtl8xxxu_rx_type {
 	RX_TYPE_ERROR = -1
 };
 
+enum rtl8xxxu_rx_desc_enc {
+	RX_DESC_ENC_NONE	= 0,
+	RX_DESC_ENC_WEP40	= 1,
+	RX_DESC_ENC_TKIP_WO_MIC	= 2,
+	RX_DESC_ENC_TKIP_MIC	= 3,
+	RX_DESC_ENC_AES		= 4,
+	RX_DESC_ENC_WEP104	= 5,
+};
+
 struct rtl8xxxu_rxdesc16 {
 #ifdef __LITTLE_ENDIAN
 	u32 pktlen:14;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5422f8da29e61..6e47dde938909 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6319,7 +6319,8 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 			rx_status->mactime = rx_desc->tsfl;
 			rx_status->flag |= RX_FLAG_MACTIME_START;
 
-			if (!rx_desc->swdec)
+			if (!rx_desc->swdec &&
+			    rx_desc->security != RX_DESC_ENC_NONE)
 				rx_status->flag |= RX_FLAG_DECRYPTED;
 			if (rx_desc->crc32)
 				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -6419,7 +6420,8 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 			rx_status->mactime = rx_desc->tsfl;
 			rx_status->flag |= RX_FLAG_MACTIME_START;
 
-			if (!rx_desc->swdec)
+			if (!rx_desc->swdec &&
+			    rx_desc->security != RX_DESC_ENC_NONE)
 				rx_status->flag |= RX_FLAG_DECRYPTED;
 			if (rx_desc->crc32)
 				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -7654,6 +7656,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
-- 
2.43.0



