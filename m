Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C244F391B;
	Thu, 17 Sep 2026 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661070; cv=none; b=Bi5JZ8LX3m2kvgahrs0VKR3HsoNja0JXIi8KnJF209pdA6YtxkzfWPrSynS8VSlhrLCizEIo2kkUjIHJNKA5bnzBbhFaZ6qEdnwvgqlekS4OtsUVuxqpoctVWm22xA8wILt3AiJxKdOjfM19jphEvTrIg0uQP08pbSZr0367NBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661070; c=relaxed/simple;
	bh=CzAFTz/tOpyRuvacRR9GBjSwPlaqT5uovMqQcUsKdBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FawlaZv8gde+8FiU3KoQJeKkPweUdYXNIjaoqaQ7AlwV8NUpFlDvFXPlUFuAVrUNoNh4JRxEL0Nm39nInr6Nvk9e/iAJW/kg6y82r64HoLkVJKSJ5sthTOWZxOk6/O/mUj2O9/6YhmYOaOd1cQkx9WLXLOXpb/P9M3jeCkdjxAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjeJqWD9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjeJqWD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307DA1F000FF;
	Thu, 17 Sep 2026 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661068;
	bh=wi1jC8AR+R6GqJMUO8NFufr7lepElHn+YwI9ZYdXwgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjeJqWD90MbidBPMaywbFbXSzdSsaxRVYO5e8SUWEMdzPtrhYhM6v9WC/bfqlXHCk
	 UQtyKjEU3RHzpMhhd0vSFVRmdoGmyz8roEJ1lOBnzpWPFmMHi55lzcgnv/90FBV37K
	 N0fs9I7K6kc/MJYH/8b25GaPu3et535yEgTcmGZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0035/1250] wifi: rtw89: suspend DIG when remain-on-channel
Date: Thu, 17 Sep 2026 15:57:10 +0100
Message-ID: <20260917151552.886635151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 602b58bb45b2f2bf848215560406ff87dc9a0ab6 ]

The PD (Packet Detection) lower bound is set after the STA interface
connects. When the P2P interface attempts to find peers, it enters
the remain-on-channel flow to listen for probe requests. However, if
the RSSI of the connected AP is too high, the P2P interface fails to
receive it. To resolve this, suspend the DIG during the
remain-on-channel period.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260420034051.17666-15-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 46c5de687dfc0..3842b0e3bcb44 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4047,6 +4047,7 @@ void rtw89_roc_start(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	reg = rtw89_mac_reg_by_idx(rtwdev, mac->rx_fltr, rtwvif_link->mac_idx);
 	rtw89_write32_clr(rtwdev, reg, B_AX_A_UC_CAM_MATCH | B_AX_A_BC_CAM_MATCH);
 
+	rtw89_phy_dig_suspend(rtwdev);
 	ieee80211_ready_on_channel(hw);
 	wiphy_delayed_work_cancel(hw->wiphy, &rtwvif->roc.roc_work);
 	wiphy_delayed_work_queue(hw->wiphy, &rtwvif->roc.roc_work,
@@ -4094,6 +4095,7 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	rtw89_core_handle_sta_pending_tx(rtwdev, rtwvif_link);
 	queue_work(rtwdev->txq_wq, &rtwdev->txq_work);
+	rtw89_phy_dig_resume(rtwdev, true);
 
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
 		wiphy_delayed_work_queue(hw->wiphy, &roc->roc_work,
-- 
2.53.0



