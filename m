Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6C83F076F;
	Sat, 12 Sep 2026 07:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197428; cv=none; b=SIHwAKK96lij62n9zVnLXupw1V5tk9E3Uu5hbTSEXpNoKwTFshzj/HcADlx1LZ8JAyb4mXM59td3YYHb5JGm2aXH3VUpDD1FVlUcy85rzMcdFZlJP6aCWoKB6nqgMEoi2PxQE6KSySixW7pezkZBY8OPOX3b83yLZYHAcvdeB20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197428; c=relaxed/simple;
	bh=OXWx+UIOziEAsgIC9CpeNgylu4qF1PUxFPLpLJC581o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIMPxobmcZGZhTLcpobI02w5sgHYkiTBVCreWnW6ch6hshG2zGqinUFjTUqlVePak8oJOuljv4PH+i6Q/c6DvGB+BoCElXUXrC7FpYQKHUbnvljH9Uku2oCvFzrFp3ihBvW8BHAfnnL4nopcl3Bc76eFy3KnXwTd+0eRVqVT740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7hHIuC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7hHIuC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C910E1F000FF;
	Sat, 12 Sep 2026 07:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197426;
	bh=qLRk5tG15WHlEnaxXkbAKh/FauTmjpjzQpDQPWdsEAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7hHIuC62FVMviNZofHex7SUZc+okOL5hGc0qSCa78iDG6C9njBgtHutwn2MORnrP
	 dBIcVNChe8Ds5f/L98ZB2HQxwbixLmj3VaqvFmdAypy6ZEaSpgPyF2c/rsy0yJxnd4
	 2W2txi08fb8q2uGIk3bz+UNk/Al2nhuz2wBzs3R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0171/1815] wifi: rtw89: check return values in rtw89_ops_start_ap()
Date: Sat, 12 Sep 2026 08:32:01 +0200
Message-ID: <20260912065653.021915266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Morgun <d.morgun@ispras.ru>

[ Upstream commit a8cddb62c573f28eef5f887a8f3156e8ee22776a ]

Several functions called in rtw89_ops_start_ap() may fail to allocate
skb or fail to send H2C command to firmware, returning -ENOMEM or an
error code. Their return values are ignored, so subsequent commands
are executed with incorrect state.

Check the return values and propagate errors.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a52e4f2ce0f5 ("rtw89: implement ieee80211_ops::start_ap and stop_ap")
Signed-off-by: Dmitry Morgun <d.morgun@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260629094452.8709-1-d.morgun@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 35 ++++++++++++++++---
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 9baedfde70854..c1be69a3c1926 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -826,11 +826,36 @@ static int rtw89_ops_start_ap(struct ieee80211_hw *hw,
 
 	ether_addr_copy(rtwvif_link->bssid, link_conf->bssid);
 	rtw89_cam_bssid_changed(rtwdev, rtwvif_link);
-	rtw89_mac_port_update(rtwdev, rtwvif_link);
-	rtw89_chip_h2c_assoc_cmac_tbl(rtwdev, rtwvif_link, NULL);
-	rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, NULL, RTW89_ROLE_TYPE_CHANGE);
-	rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
-	rtw89_fw_h2c_cam(rtwdev, rtwvif_link, NULL, NULL, RTW89_ROLE_TYPE_CHANGE);
+	ret = rtw89_mac_port_update(rtwdev, rtwvif_link);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to update mac port\n");
+		return ret;
+	}
+
+	ret = rtw89_chip_h2c_assoc_cmac_tbl(rtwdev, rtwvif_link, NULL);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c cmac table\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, NULL, RTW89_ROLE_TYPE_CHANGE);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c role info\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_join_info(rtwdev, rtwvif_link, NULL, true);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c join info\n");
+		return ret;
+	}
+
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif_link, NULL, NULL, RTW89_ROLE_TYPE_CHANGE);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to send h2c cam\n");
+		return ret;
+	}
+
 	rtw89_chip_rfk_channel(rtwdev, rtwvif_link);
 
 	if (RTW89_CHK_FW_FEATURE(NOTIFY_AP_INFO, &rtwdev->fw)) {
-- 
2.53.0



