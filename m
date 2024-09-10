Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911518C039;
	Tue, 10 Sep 2024 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961582; cv=none; b=SxBKRLGo/QcXDlwtZ4Hff6j5VsmV8q1+hOQMbTCkC1PXLqu8aYB6OlynCoxVpHBuszMGYqQ9QKQlYF2l0MB+KDlQ9B/RBkSS30kH8aHXjMZRzEI6am0VFsVVwlNzL7ULqIIguMgayFq8lDYFUWf1KrJf7Io+klRLbtmMevsq+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961582; c=relaxed/simple;
	bh=RjIEzxGQ1n+UcwMSR9oJdT815yxNt/g4oA5W+rWYIwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOaAHNL/YY2PNPL8XPONWkBdfs2+WF4xLwkuLO81Ed0yQn6E1vSs+55SGnGWEdSPJzTGRn77i2yvV3SFI+PFlVAqnUyldWGRpupDVkTO4txH16k3kas8V9T0Ob5GOqxMX5uO3b3W/HEl1iBv2EgO/GXGv3dRYz5Nv7GcP3Yc90U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUyFdWBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUyFdWBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20DBC4CEC3;
	Tue, 10 Sep 2024 09:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961582;
	bh=RjIEzxGQ1n+UcwMSR9oJdT815yxNt/g4oA5W+rWYIwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUyFdWBiRwnSIaVnesf6j8QZYmjljbYgyLkOT99ZcEWgxkia5g535Z6V01ohz1xlA
	 9UzT8gWyikJas+BjKM/d+Fb29PqsnqB35goUIQTyHLDTR0JkGL1v8cR42qqc0k0F/A
	 gwAWWIflzcIO9RHWTu2JS8j73SeHo92HK5q4GEo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 119/375] wifi: rtw89: wow: prevent to send unexpected H2C during download Firmware
Date: Tue, 10 Sep 2024 11:28:36 +0200
Message-ID: <20240910092626.429416122@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 60757f28408bcc63c4c0676b2a69a38adce30fc7 ]

While downloading Firmware in the resume flow, it is possible to receive
beacon and send H2C to Firmware. However, if Firmware receives unexpected
H2C during the download process, it will fail. Therefore, we prevent to
send unexpected H2C during download Firmware in WoWLAN mode.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240620055825.17592-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index ddc390d24ec1..ddf45828086d 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1917,7 +1917,8 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 		return;
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
-		if (vif->type == NL80211_IFTYPE_STATION) {
+		if (vif->type == NL80211_IFTYPE_STATION &&
+		    !test_bit(RTW89_FLAG_WOWLAN, rtwdev->flags)) {
 			rtw89_vif_sync_bcn_tsf(rtwvif, hdr, skb->len);
 			rtw89_fw_h2c_rssi_offload(rtwdev, phy_ppdu);
 		}
-- 
2.43.0



