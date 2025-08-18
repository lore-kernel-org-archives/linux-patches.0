Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381E9322A01;
	Mon, 18 Aug 2025 13:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523573; cv=none; b=tNgDaDbyKHZaLZ+Qv5JfxUmT6ekj/kr6ra4fiujC0ljJCckPHXCvwXG150KOvlb+fSKFVw7bcPwbZR9cwGtVRsXgT3/0ZpmFj2b2a9wBYbaMz74YXqyKis6ojUm5wZ+NF6zZh4nojl3n3wZFKrO8lsw6quOdgF86GMR3RsI6trU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523573; c=relaxed/simple;
	bh=0YIGrY1VsGfODVe6mz0Yk6aUTssi0QYTBRqAvaWvt8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+3hBxG+IF7Xn8Wg17zyCDZXeL+J6dynUTRG6kccnFlNIjZtNieL5gpoe+a++XTzVvn5LOvfcKnOWt054008uCWyTNRYOCZ9lrefNgxOM02M6HAAPPOmaitjnF/a92zdV6LrU1TniFYsMsRm59DVDrKo7ffCy0T6Lt7VoGsRtZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQ2J+fgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQ2J+fgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3EBC4CEEB;
	Mon, 18 Aug 2025 13:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523573;
	bh=0YIGrY1VsGfODVe6mz0Yk6aUTssi0QYTBRqAvaWvt8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQ2J+fgPWKm52tjdQubvDM9JIpQCnyRRTGddiHj76c/YAq24odqzXjfBRWeybYjzg
	 +vPVUreyQMZI9ePX7yYdwdpLxOPdNDQ4XfYtojH321NjMunetN+esO5k5cmg9wPmvt
	 dh5Uwlx8DjEzzY3cowu8gPhQOnK4/tJ6g1CAnRLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 212/515] wifi: rtw89: wow: Add Basic Rate IE to probe request in scheduled scan mode
Date: Mon, 18 Aug 2025 14:43:18 +0200
Message-ID: <20250818124506.532043820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 37c23874d13eb369d8b384a1ce5992ff6c23d56f ]

In scheduled scan mode, the current probe request only includes the SSID
IE, but omits the Basic Rate IE. Some APs do not respond to such
incomplete probe requests, causing net-detect failures. To improve
interoperability and ensure APs respond correctly, add the Basic Rate IE
to the probe request in driver.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250716122926.6709-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 17eee58503cb..ea2d3ad8391a 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -1413,6 +1413,8 @@ static void rtw89_fw_release_pno_pkt_list(struct rtw89_dev *rtwdev,
 static int rtw89_pno_scan_update_probe_req(struct rtw89_dev *rtwdev,
 					   struct rtw89_vif_link *rtwvif_link)
 {
+	static const u8 basic_rate_ie[] = {WLAN_EID_SUPP_RATES, 0x08,
+		 0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c};
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
 	struct cfg80211_sched_scan_request *nd_config = rtw_wow->nd_config;
 	u8 num = nd_config->n_match_sets, i;
@@ -1424,10 +1426,11 @@ static int rtw89_pno_scan_update_probe_req(struct rtw89_dev *rtwdev,
 		skb = ieee80211_probereq_get(rtwdev->hw, rtwvif_link->mac_addr,
 					     nd_config->match_sets[i].ssid.ssid,
 					     nd_config->match_sets[i].ssid.ssid_len,
-					     nd_config->ie_len);
+					     nd_config->ie_len + sizeof(basic_rate_ie));
 		if (!skb)
 			return -ENOMEM;
 
+		skb_put_data(skb, basic_rate_ie, sizeof(basic_rate_ie));
 		skb_put_data(skb, nd_config->ie, nd_config->ie_len);
 
 		info = kzalloc(sizeof(*info), GFP_KERNEL);
-- 
2.39.5



