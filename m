Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43EC34252D;
	Sat, 12 Sep 2026 09:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206356; cv=none; b=gkwPUiZdhtSV1URlDdLdYkA4MSNmSSXDQ9rEtSmBMTZKaKQD3Dbv8PtUgjziAA6+cHNBFPfd6z2r5IY8JCK9KMS2jNPzxyLjTV9oUhOTH+5/JXqBnMB0Kzr5OjJ1f57oKoBsgLVrlGQlDzxOZ+Iz3bDnoT8eOzSMI0+TM11aHs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206356; c=relaxed/simple;
	bh=UY1f+fSRQjas6nOAofeVfU76lNwiGVKDxFdD0RrmM0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soUokab1vkMcA9i+oTeu/F9gLAZnYaQSGo/whKH4B2z0IeZI+a41CFb3u3swhJv3xlUH9KIVpu3H0qa3D1N4yUakOOqdnStao+7xWJ7YLqiGXVCjBWTvSugaD/8kFUWiNWRRqB8x8X4DsueSElv40qMPOjtY5nl5n3MYe3NiGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vi8RjTOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vi8RjTOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B593C1F000FF;
	Sat, 12 Sep 2026 09:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206354;
	bh=fkw/yxoQvB7DvURWmCyDC++hoBaROjyz4903zFw23XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vi8RjTObcoWHZhBikroLvHlzZzUjTHdiLN7xGrIf1mTbDqJ0Hw7P8gkAQs1kHj57X
	 JxOyTWRQFjrYy9hoUVtRtM/dslzpwf+csbjrUzUCf4PHVIMEHMR4w++g937u1ZjIH1
	 G2yO0QbJjPVZvSUyApkH7FugStPaz1V7JHJLWyys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Morgun <d.morgun@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0191/1518] wifi: rtw89: check return values in rtw89_ops_start_ap()
Date: Sat, 12 Sep 2026 08:39:20 +0200
Message-ID: <20260912065627.811309578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7c8ec4f3c77e9..fd818d4b35314 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -800,11 +800,36 @@ static int rtw89_ops_start_ap(struct ieee80211_hw *hw,
 
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



