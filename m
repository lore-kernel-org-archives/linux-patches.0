Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC81A282EE;
	Wed,  5 Feb 2025 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765208; cv=none; b=gS7ze3Z2d4puyoDfvkaNYsXgIMX7voTEkE7HrUSgQBNH29mXhREyyUIYQMGK7m/6iDuw1qaa7fIPC6RXnaT5ZD0hq/371FySe0mMVPbMm8EoelWq63BrraFtuUNIqKzfNUUU7M/oK9nBrcag7kviKVm+vFVNi1HCUSoOtK50tAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765208; c=relaxed/simple;
	bh=aaLNLNlDXzU4f4bW+4oI1gq7y99xG206/NrvCqVksSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGXajEfn40jkbjzHriKitfSsiPXcPLx7EdJ5zQQdYejr7R32EplF1tKIAz6hg2mEKgjbmhVQjQ93QB2Z/h9HXaUIQXOCL6rEpRiDbX+6WWqKzFf+WVaDwcE48QCnh9fmcSYDdatQA3CW0MHMuv/X873i91cQerAQi6Y91+SEykE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VR99WjLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VR99WjLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A190C4CED6;
	Wed,  5 Feb 2025 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765208;
	bh=aaLNLNlDXzU4f4bW+4oI1gq7y99xG206/NrvCqVksSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR99WjLEv2RZOoo1ha0Aej0w9U8rarPFd4N4+GawEYhiciDNJ0STu+oI55IWHbUab
	 mcc/R+FZNGZV1oANRmdmuxtrLCTz9gk5B4SN+EF7b+LntUF6ve2JbRYA5EMQH+aXdJ
	 910EXdXOXZEzuq1LncVjypuhtdckFyooP8Tos/hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 156/623] wifi: rtw89: correct header conversion rule for MLO only
Date: Wed,  5 Feb 2025 14:38:18 +0100
Message-ID: <20250205134502.205264187@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit b2658bf4d7f2f2e37ae9d2463ecc40618f587834 ]

Header conversion should only be used with MLO connections. Otherwise
P2P connection fails due to wrong probe responses sent. Fix it
accordingly.

Fixes: b8499664fca9 ("wifi: rtw89: Add header conversion for MLO connections")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241231004811.8646-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 9 ++++++++-
 drivers/net/wireless/realtek/rtw89/core.h | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index a524c3d06aeb2..4027cda39024c 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -931,6 +931,11 @@ rtw89_core_tx_update_desc_info(struct rtw89_dev *rtwdev,
 	bool is_bmc;
 	u16 seq;
 
+	if (tx_req->sta)
+		desc_info->mlo = tx_req->sta->mlo;
+	else if (tx_req->vif)
+		desc_info->mlo = ieee80211_vif_is_mld(tx_req->vif);
+
 	seq = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 	if (tx_req->tx_type != RTW89_CORE_TX_TYPE_FWCMD) {
 		tx_type = rtw89_core_get_tx_type(rtwdev, skb);
@@ -938,7 +943,7 @@ rtw89_core_tx_update_desc_info(struct rtw89_dev *rtwdev,
 
 		addr_cam = rtw89_get_addr_cam_of(tx_req->rtwvif_link,
 						 tx_req->rtwsta_link);
-		if (addr_cam->valid)
+		if (addr_cam->valid && desc_info->mlo)
 			upd_wlan_hdr = true;
 	}
 	is_bmc = (is_broadcast_ether_addr(hdr->addr1) ||
@@ -1078,6 +1083,8 @@ int rtw89_core_tx_write(struct rtw89_dev *rtwdev, struct ieee80211_vif *vif,
 	}
 
 	tx_req.skb = skb;
+	tx_req.vif = vif;
+	tx_req.sta = sta;
 	tx_req.rtwvif_link = rtwvif_link;
 	tx_req.rtwsta_link = rtwsta_link;
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 5ad32eacd0d50..41bec362ac229 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -1163,12 +1163,15 @@ struct rtw89_tx_desc_info {
 	bool stbc;
 	bool ldpc;
 	bool upd_wlan_hdr;
+	bool mlo;
 };
 
 struct rtw89_core_tx_request {
 	enum rtw89_core_tx_type tx_type;
 
 	struct sk_buff *skb;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *sta;
 	struct rtw89_vif_link *rtwvif_link;
 	struct rtw89_sta_link *rtwsta_link;
 	struct rtw89_tx_desc_info desc_info;
-- 
2.39.5



