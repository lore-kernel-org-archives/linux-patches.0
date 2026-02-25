Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39611E2834;
	Wed, 25 Feb 2026 01:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983163; cv=none; b=O4xRPYwKASiWAeqcvSDRC+7IpytbndmdKDqzE7h6XVpQLWXENoETBP0zqUWlcVyOEIR6dBNub0lIlg0QV8I13IYJjB/LZASiuaVFchLJ7431C4pOeOR5z7LsHeItljH0QBOY0k5MSCWK35VAVxWiIaO+fSXqLhleapgxX6+v+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983163; c=relaxed/simple;
	bh=SKPPD2L5fx4DooGxqksmF1Ftvg2M0WhF7Hnlw2sF46I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9Mh3FBhn4McoBPN0L+Y3S/HvHdMZoU4djznFf+g97ugU9SjahpX78YpZgz3QOqNxLJ5YwC4Ng3070/N3/k6GGliBaergbnGN5iDQ8qEX7eVOQnUTD4Vw3/Jl592IxYMt6tdrLoMEyTx4lSTmZZG/Bf1BfGtA4yU9QCPY+12KE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wUt0jDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wUt0jDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B03C116D0;
	Wed, 25 Feb 2026 01:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983162;
	bh=SKPPD2L5fx4DooGxqksmF1Ftvg2M0WhF7Hnlw2sF46I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wUt0jDF0/PmWQjBySKtXY6T5T6LPyOOm66VlauF6LHq2Qmi88A6L3P6FA0VigmAf
	 RKzRsMOG6ERXsJdbbp1myuRe/U79lxvZaQRV4b1XC/F0TzKJbzVXvodMun1kVTopyM
	 VSpV0MYz03dTXXDk3UJUkNwPo+c3LIeXdxodFDOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 316/781] wifi: rtw89: correct use sequence of driver_data in skb->info
Date: Tue, 24 Feb 2026 17:17:05 -0800
Message-ID: <20260225012407.451822363@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit d3a9e132a4c6273a5254e743da14887502e928c8 ]

As ieee80211_tx_info is used to assist filling TX descriptor, and layout of
IEEE80211_SKB_CB(skb)->driver_data (accessing by RTW89_TX_SKB_CB()) is
union, so driver_data must be used by/after rtw89_hci_tx_write() or just
before calling rtw89_hci_tx_write(). Otherwise, ieee80211_tx_info::control
data is overwritten.

Found this by using injected packets which uses ieee80211_tx_info::control,
but always sending incorrect data rate.

Cc: Fedor Pchelkin <pchelkin@ispras.ru>
Fixes: d5da3d9fb05f ("wifi: rtw89: process TX wait skbs for USB via C2H handler")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20251217072646.43209-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 6 ++++--
 drivers/net/wireless/realtek/rtw89/core.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 0824940c91aee..53d32f3137ebe 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1207,7 +1207,7 @@ rtw89_core_tx_update_desc_info(struct rtw89_dev *rtwdev,
 	if (addr_cam->valid && desc_info->mlo)
 		upd_wlan_hdr = true;
 
-	if (rtw89_is_tx_rpt_skb(rtwdev, tx_req->skb))
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS || tx_req->with_wait)
 		rtw89_tx_rpt_init(rtwdev, tx_req);
 
 	is_bmc = (is_broadcast_ether_addr(hdr->addr1) ||
@@ -1342,13 +1342,15 @@ static int rtw89_core_tx_write_link(struct rtw89_dev *rtwdev,
 	tx_req.rtwvif_link = rtwvif_link;
 	tx_req.rtwsta_link = rtwsta_link;
 	tx_req.desc_info.sw_mld = sw_mld;
-	rcu_assign_pointer(skb_data->wait, wait);
+	tx_req.with_wait = !!wait;
 
 	rtw89_traffic_stats_accu(rtwdev, rtwvif, skb, true, true);
 	rtw89_wow_parse_akm(rtwdev, skb);
 	rtw89_core_tx_update_desc_info(rtwdev, &tx_req);
 	rtw89_core_tx_wake(rtwdev, &tx_req);
 
+	rcu_assign_pointer(skb_data->wait, wait);
+
 	ret = rtw89_hci_tx_write(rtwdev, &tx_req);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to transmit skb to HCI\n");
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index a9cb47ea0b935..92636cfc5ca58 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1211,6 +1211,8 @@ struct rtw89_core_tx_request {
 	struct rtw89_vif_link *rtwvif_link;
 	struct rtw89_sta_link *rtwsta_link;
 	struct rtw89_tx_desc_info desc_info;
+
+	bool with_wait;
 };
 
 struct rtw89_txq {
-- 
2.51.0



