Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76480FC0B;
	Wed,  5 Feb 2025 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764662; cv=none; b=QN8DvkfoTHIUMoeRbvsrwfd11bq8SpWwl0hXZ8jRCmV53DUGi69ek1wEFXnm1FkFbSa/pG/zvnXUN6JMYbgsQL9n7g6VJCwTCmbY0jSSZGzZcv3YkdmqUP6QIDokbcJyXYBOj6WuSsAM6me1NpLEF+SZgu57Ae+xwYOyUP5RXHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764662; c=relaxed/simple;
	bh=elBhsDXo5rPiOepJt1MB4npUXkcVlkqPl28tiV7IIUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUAI4b5LFjOoXGLXyPjo2Qxvvr8MayIKZYoHjI1AQzPW6H0PRnT9w2GHx/l9yMpXWqPX5grOrofxJpABNxAL/IFJo9Hc5FP/3g5AWVY3WX/3F1bLnif6cAqNIJPUtVu+m4UmRQI1dXU11ivyCcloXXeqgXhyzVg3vvpAyThA90k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ge7pRAhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ge7pRAhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBC1C4CED1;
	Wed,  5 Feb 2025 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764661;
	bh=elBhsDXo5rPiOepJt1MB4npUXkcVlkqPl28tiV7IIUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ge7pRAhzvdXdLgokhGnKmKcFrwg4ej39QKGNpCWIl3GqzfPzbaQU4za8sOsKca1Wq
	 efnplPq3HI/gbFRWk8sBMi5q+6RlHt8WlZBMkjaVUK/zHRd0zIZng0H6f0l2Mm0tNL
	 GHDvtYnlRE9ea4QxEb+l1hqPMQvXhe8lErK+Mu+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/590] wifi: rtw89: handle entity active flag per PHY
Date: Wed,  5 Feb 2025 14:38:22 +0100
Message-ID: <20250205134500.899878049@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit ad95bb3b92c65849a6101402197e2cbeb2910a4a ]

Originally, we have an active flag to record whether we have set PHY once.
After impending MLO support, there will be dual-PHY and they can be set
individually on Wi-Fi 7 chips. So, we now have active flag per PHY and
handle them individually.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240925020119.13170-3-pkshih@realtek.com
Stable-dep-of: e47f0a589854 ("wifi: rtw89: fix proceeding MCC with wrong scanning state after sequence changes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.h | 11 +++++++----
 drivers/net/wireless/realtek/rtw89/core.c | 15 ++++++++-------
 drivers/net/wireless/realtek/rtw89/core.h |  2 +-
 drivers/net/wireless/realtek/rtw89/mac.c  |  3 ++-
 4 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.h b/drivers/net/wireless/realtek/rtw89/chan.h
index 4ed777ea50648..74de13a2e7da9 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.h
+++ b/drivers/net/wireless/realtek/rtw89/chan.h
@@ -43,18 +43,21 @@ struct rtw89_entity_weight {
 	unsigned int active_roles;
 };
 
-static inline bool rtw89_get_entity_state(struct rtw89_dev *rtwdev)
+static inline bool rtw89_get_entity_state(struct rtw89_dev *rtwdev,
+					  enum rtw89_phy_idx phy_idx)
 {
 	struct rtw89_hal *hal = &rtwdev->hal;
 
-	return READ_ONCE(hal->entity_active);
+	return READ_ONCE(hal->entity_active[phy_idx]);
 }
 
-static inline void rtw89_set_entity_state(struct rtw89_dev *rtwdev, bool active)
+static inline void rtw89_set_entity_state(struct rtw89_dev *rtwdev,
+					  enum rtw89_phy_idx phy_idx,
+					  bool active)
 {
 	struct rtw89_hal *hal = &rtwdev->hal;
 
-	WRITE_ONCE(hal->entity_active, active);
+	WRITE_ONCE(hal->entity_active[phy_idx], active);
 }
 
 static inline
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 5b8e65f6de6a4..37d2bcba1b315 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -352,10 +352,6 @@ void rtw89_core_set_chip_txpwr(struct rtw89_dev *rtwdev)
 	enum rtw89_entity_mode mode;
 	bool entity_active;
 
-	entity_active = rtw89_get_entity_state(rtwdev);
-	if (!entity_active)
-		return;
-
 	mode = rtw89_get_entity_mode(rtwdev);
 	switch (mode) {
 	case RTW89_ENTITY_MODE_SCC:
@@ -375,6 +371,11 @@ void rtw89_core_set_chip_txpwr(struct rtw89_dev *rtwdev)
 		chanctx_idx = roc_idx;
 
 	phy_idx = RTW89_PHY_0;
+
+	entity_active = rtw89_get_entity_state(rtwdev, phy_idx);
+	if (!entity_active)
+		return;
+
 	chan = rtw89_chan_get(rtwdev, chanctx_idx);
 	chip->ops->set_txpwr(rtwdev, chan, phy_idx);
 }
@@ -393,8 +394,6 @@ int rtw89_set_channel(struct rtw89_dev *rtwdev)
 	enum rtw89_entity_mode mode;
 	bool entity_active;
 
-	entity_active = rtw89_get_entity_state(rtwdev);
-
 	mode = rtw89_entity_recalc(rtwdev);
 	switch (mode) {
 	case RTW89_ENTITY_MODE_SCC:
@@ -416,6 +415,8 @@ int rtw89_set_channel(struct rtw89_dev *rtwdev)
 	mac_idx = RTW89_MAC_0;
 	phy_idx = RTW89_PHY_0;
 
+	entity_active = rtw89_get_entity_state(rtwdev, phy_idx);
+
 	chan = rtw89_chan_get(rtwdev, chanctx_idx);
 	chan_rcd = rtw89_chan_rcd_get(rtwdev, chanctx_idx);
 
@@ -432,7 +433,7 @@ int rtw89_set_channel(struct rtw89_dev *rtwdev)
 		rtw89_chip_rfk_band_changed(rtwdev, phy_idx, chan);
 	}
 
-	rtw89_set_entity_state(rtwdev, true);
+	rtw89_set_entity_state(rtwdev, phy_idx, true);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index de33320b1354c..0ed31b37d10fe 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4668,7 +4668,7 @@ struct rtw89_hal {
 	struct rtw89_chanctx chanctx[NUM_OF_RTW89_CHANCTX];
 	struct cfg80211_chan_def roc_chandef;
 
-	bool entity_active;
+	bool entity_active[RTW89_PHY_MAX];
 	bool entity_pause;
 	enum rtw89_entity_mode entity_mode;
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 4e15d539e3d1c..4574aa62839b0 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1483,7 +1483,8 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 		clear_bit(RTW89_FLAG_CMAC1_FUNC, rtwdev->flags);
 		clear_bit(RTW89_FLAG_FW_RDY, rtwdev->flags);
 		rtw89_write8(rtwdev, R_AX_SCOREBOARD + 3, MAC_AX_NOTIFY_PWR_MAJOR);
-		rtw89_set_entity_state(rtwdev, false);
+		rtw89_set_entity_state(rtwdev, RTW89_PHY_0, false);
+		rtw89_set_entity_state(rtwdev, RTW89_PHY_1, false);
 	}
 
 	return 0;
-- 
2.39.5



