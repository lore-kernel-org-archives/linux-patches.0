Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D675383E2;
	Wed, 23 Sep 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174692; cv=none; b=lYZ/Npur+L+QnLCa3jzRPTlO0ZImW+dRknLztfEGKh3MPMsHIuCm4ZFe/8Zs4KlKGzRCxvUmerR9j/3c7hxVkr4s/BdxjibZldDXh7g3Afn60H40TV4L/QxnND8caXHtk7+fxN65nwu6wFhD3KFus4+dUUaqWCnVjPZC8kxN9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174692; c=relaxed/simple;
	bh=J6E78LIAy6Iq5DVcJ8bniiosLgGwwlP11co0Bw4f5cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPdYLhAL+bZl9dbNRxfx6UEIJWcRJmamaDKcs8smH8G+Uk9exePIWoSdsbIFMXChz2iTdd2PcwQ0YRatkNT7F8DRHOKiw0BhG8mZg6pWPm3afbUZmX/C+8JMOX6EVLzx23pkhkHMu2k36FscQzJ5PAxEz6lxqahEMJC6xLOV6cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SM8BLjWh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SM8BLjWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57A41F000FF;
	Wed, 23 Sep 2026 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174691;
	bh=N6MtzflRAW0K4+Ace0w967o5DgHpxZ7J7lwd/SIO/xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SM8BLjWh0FXBLFbRZnBZTUU8/a0oPMCzOYaRtypIcfMoc/U3X6usbRgu0MZOSf6qG
	 vql5Plu1YHtqzcJWIyYnC+f8Z6Pq/JU4Jw8beK3fLHu0bHeuWfb1lA+wlOrGAY5nPe
	 0qgijZUiqVd7m2crehEmlnX8qsDBYlNBEBM5jDnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/398] wifi: rtw88: TX QOS Null data the same way as Null data
Date: Wed, 23 Sep 2026 16:04:29 +0200
Message-ID: <20260923140648.478926656@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 737e980e12983bb7420a2c00b981a1e607079a84 ]

When filling out the TX descriptor, Null data frames are treated like
management frames, but QOS Null data frames are treated like normal
data frames. Somehow this causes a problem for the firmware.

When connected to a network in the 2.4 GHz band, wpa_supplicant (or
NetworkManager?) triggers a scan every five minutes. During these scans
mac80211 transmits many QOS Null frames in quick succession. Because
these frames are marked with IEEE80211_TX_CTL_REQ_TX_STATUS, rtw88
asks the firmware to report the TX ACK status for each of these frames.
Sometimes the firmware can't process the TX status requests quickly
enough, they add up, it only processes some of them, and then marks
every subsequent TX status report with the wrong number.

The symptom is that after a while the warning "failed to get tx report
from firmware" appears every five minutes.

This problem apparently happens only with the older RTL8723D, RTL8821A,
RTL8812A, and probably RTL8703B chips.

Treat QOS Null data frames the same way as Null data frames. This seems
to avoid the problem.

Tested with RTL8821AU, RTL8723DU, RTL8811CU, and RTL8812BU.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/2b53fb0d-b1ed-47b6-8caa-2bb9ae2acb80@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index 611dade1b1eb9..e73c06b268cfa 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -426,7 +426,7 @@ void rtw_tx_pkt_info_update(struct rtw_dev *rtwdev,
 		pkt_info->mac_id = rtwvif->mac_id;
 	}
 
-	if (ieee80211_is_mgmt(fc) || ieee80211_is_nullfunc(fc))
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_any_nullfunc(fc))
 		rtw_tx_mgmt_pkt_info_update(rtwdev, pkt_info, sta, skb);
 	else if (ieee80211_is_data(fc))
 		rtw_tx_data_pkt_info_update(rtwdev, pkt_info, sta, skb);
-- 
2.53.0



