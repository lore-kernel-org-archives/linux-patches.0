Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591493;
	b=RLAZiQcngOdTmbNhdZ25LIn6S1jvoFyC1QxmzH6UPiqd9dW3lM/61qzmF4605GmE2PWv
	 QTUwThU21ZwcIF9H62mZPSouMJ1GLkNp1O+V1D+K/R1lT7GO76wscdFB8H8sduAYO8i4t
	 uu2tYcpmKPdAFQ6OUw2aJxe1KutnE0EnRan0SaOrtpduCsOf+XSvO670ezxa6gqJqL2sj
	 bDiy+IYEz9MeFDVRvGfFly2/NQ3HUrS6/Zbd6ZyFhwqCi52s9M3dw5qftsco7qskCRQ+4
	 MT1TUy2QGCrWbMtSjrS1CYVndK7jKN0CdWOnfK9FfoOJhyNFvpvp3ZQF/qRO/dp6BpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x9UcFEi/7s0qu33B9Zs/wgCbGjd/2n8hGp5iLZZ6n60=;
	b=Fc/xD8sY+/PLc2dwLJUsCvvLVneb1d7/JK6fcT/AQlKS3hU+GWLUcMGD4DrJ2K/oEXwd
	 R10AqRQ/5cZ8qYiEzKaLrOsXhdB9tWvWADWtt9G7D0FZgq+5rb/WtMmQ9K+f4CXi5z4e0
	 tEm9uC0qn+gZuJ6bLvVTisIYT/p4B0pnsCz7F34LJ714mX0TEVscu9hZXFWuobVhuC2lf
	 mhuEHkaz9UudUiocFo8oA60xWi0BL5hCO3zAzI+xK04uQ6S9M83P4XPO45KQJM7/xoBUs
	 mcLmTBqJN+6ysgMuqSUkFd6zE+svv+jKqrV6zbz7l4Q6hmZKqaJVxCAmxIOQNn8GIJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfHBF+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1857D606D487;
	Fri, 13 Nov 2026 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAfHBF+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B861B1F000C6;
	Fri, 13 Nov 2026 17:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591493;
	bh=x9UcFEi/7s0qu33B9Zs/wgCbGjd/2n8hGp5iLZZ6n60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAfHBF+Q2sR146LwKpH5fDJSt648nhjrQTWzLKi/VAel7rrg2jKc2KG1fQyCpBU5z
	 QhUf/evf/qD0HxTh8/rAULMQwkgy78ehZAqbXiRC+nOSLFdFAEpaaKiQI5+Au/r5VW
	 WBrUVfMeM2Tp47vMASEPE5s4da/36T4OPf7QIIqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris <hoopyfrood42@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 574/670] wifi: mt76: move the channel survey when the channel changes
Date: Fri, 13 Nov 2026 10:52:18 -0500
Message-ID: <20261113153831.305668326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 68342a7bd7e5e273e2969e3c0f4c62ee3d006ce8 ]

mt7921 and mt7925 report every survey counter against one channel and
never mark the one in use. With firmware channel management, both use
channel contexts and never call __mt76_set_channel(), so
phy->chan_state, phy->chandef and phy->main_chandef keep the first
channel of the band.

Update them when a context is assigned or changed, after booking the
time spent on the old channel. This also makes the legacy rate lookup
in mt76_connac2_mac_fill_txs() and mt7925_mac_add_txs_skb() use the
band of the current channel.

With two channel contexts (multi-channel or MLO), the survey follows
the context that was assigned or changed last, since the driver reads
the band 0 counters only.

Tested on MT7922 over PCIe, MT7921AU and MT7925 over USB.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Reported-by: Chris <hoopyfrood42@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com/
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261001003501.2425492-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: Changed phy->main_chandef = *chandef to phy->main_chan = chandef->chan. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 14 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h        |  2 ++
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |  2 ++
 drivers/net/wireless/mediatek/mt76/mt792x_core.c |  1 +
 5 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index cd02dff7ab347..13e6594945180 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -973,6 +973,20 @@ void mt76_update_survey(struct mt76_phy *phy)
 }
 EXPORT_SYMBOL_GPL(mt76_update_survey);
 
+void mt76_phy_chandef_set(struct mt76_phy *phy,
+			  struct cfg80211_chan_def *chandef)
+{
+	if (!chandef->chan)
+		return;
+
+	mt76_update_survey(phy);
+
+	phy->chandef = *chandef;
+	phy->main_chan = chandef->chan;
+	phy->chan_state = mt76_channel_state(phy, chandef->chan);
+}
+EXPORT_SYMBOL_GPL(mt76_phy_chandef_set);
+
 int mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		     bool offchannel)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8addbffa97c55..d709b74159689 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1400,6 +1400,8 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 int mt76_update_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
+void mt76_phy_chandef_set(struct mt76_phy *phy,
+			  struct cfg80211_chan_def *chandef);
 void mt76_update_survey_active_time(struct mt76_phy *phy, ktime_t time);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 99561094640f1..18eb934da570a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1394,6 +1394,7 @@ mt7921_change_chanctx(struct ieee80211_hw *hw,
 		mt7921_mcu_config_sniffer(mvif, ctx);
 	else
 		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->bss_conf.mt76, ctx);
+	mt76_phy_chandef_set(mvif->phy->mt76, &ctx->def);
 	mt792x_mutex_release(phy->dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 9a52607dc5a8f..dba0f48922072 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1873,6 +1873,7 @@ mt7925_change_chanctx(struct ieee80211_hw *hw,
 					     link_conf, ctx);
 		}
 	}
+	mt76_phy_chandef_set(mvif->phy->mt76, &ctx->def);
 
 	mt792x_mutex_release(phy->dev);
 }
@@ -2170,6 +2171,7 @@ static int mt7925_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	mconf->mt76.ctx = ctx;
 	mctx->bss_conf = mconf;
+	mt76_phy_chandef_set(mvif->phy->mt76, &ctx->def);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index a3ca93c9af63e..86b45807481fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -308,6 +308,7 @@ int mt792x_assign_vif_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 	mvif->bss_conf.mt76.ctx = ctx;
 	mctx->bss_conf = &mvif->bss_conf;
+	mt76_phy_chandef_set(&dev->mphy, &ctx->def);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
-- 
2.53.0



