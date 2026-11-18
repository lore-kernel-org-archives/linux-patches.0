Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038442;
	b=ZjqOOmKj9jmsfql2MBqTOmKzZce6hthABSg65d8i8n9NJPPGhBOzviIK22IKYXEtHRKu
	 S898qwBUcF7PBoM9+PGE2PiCiS7HUYd6y/aL1V94LuNgYn28sU8QSEgE6uJh0J5uMu5TW
	 4aVanflZYc9OECxx02pbVuIzXSRapQy/hehAiR7RD2CFZ4p89ugwJB9A8CPtvSCXprXms
	 vD/uNQ3TLV/N2RI6GN69huy3pO3/CcNE1mmslrEgmltLNIBhXeaPmKgsyGfGoFac2tTKo
	 bJE3/nYGtyGYIrAuch2nDqdWRwNxBTF+V7BeOMdZVhZl+86Hb9Hu5ic0DTaV/+N3BaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+tW0Mn5RHE0p7tSV1GwhnY9iKPCjWzX3WxCKjBf9pg=;
	b=CWbPjGvSvSD/8mm/gdQSYHmCWoyrKl1F1lZNaKhvoex5YWvdNx668H2dh2DY+xFY/thP
	 wScLNVVndu55CaWPXyXrpnWL83+oF+O+lSDMDnSoTLNJH45UCmCCiubvMlc9nNY+7msk5
	 MHJqdgVhzGdmKrYExKUN7cMznAYgPE6IZTGsdvnupFi9zzCtjCPaK/SBR+jVH9BBipJlf
	 0nb3zw2n0KJOL/q4o32RGnAsBtUzXZIdnuUyzOYDp9XQ0/jO1yLAFJfQMrdyyzb1+IP//
	 qM8PDlCK82u5LfIcfk0ulANI/wPKmRlt4dqlUCOsHs6kdGb3gHsZYt45Y/jxnlkqdZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTRIupSx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACD606A325;
	Wed, 18 Nov 2026 21:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTRIupSx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1600D1F000C4;
	Wed, 18 Nov 2026 21:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038442;
	bh=w+tW0Mn5RHE0p7tSV1GwhnY9iKPCjWzX3WxCKjBf9pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTRIupSxbBUvQi8sz2XGm/7iJ7HGuf0T5RyazY+cxLqoVll1C2UwHf3tve0bxPbCM
	 jmNA1xWxKIH0gPTKaDN45+Qmd5jzFVdUA9DkeN02MymCdDb/oQn6Tw+lW6bN+svSac
	 WtR33TWV8rD0apq5iX62jen3fa30JkgsE60rgU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris <hoopyfrood42@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1746/3318] wifi: mt76: move the channel survey when the channel changes
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118150414.239722525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted channel survey integration to the existing main_chan field and MT7921 context layout. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 14 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h        |  2 ++
 drivers/net/wireless/mediatek/mt76/mt7921/main.c |  1 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c |  1 +
 4 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3f09bf58130d4..379eecd09d0f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -945,6 +945,20 @@ void mt76_update_survey(struct mt76_phy *phy)
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
 void mt76_set_channel(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5050f640530f8..37ba676ca9038 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1297,6 +1297,8 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 void mt76_set_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
+void mt76_phy_chandef_set(struct mt76_phy *phy,
+			  struct cfg80211_chan_def *chandef);
 void mt76_update_survey_active_time(struct mt76_phy *phy, ktime_t time);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 8f0976e9c295e..acf54f27332f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1292,6 +1292,7 @@ static void mt7921_ctx_iter(void *priv, u8 *mac,
 		mt7921_mcu_config_sniffer(mvif, ctx);
 	else
 		mt76_connac_mcu_uni_set_chctx(mvif->phy->mt76, &mvif->mt76, ctx);
+	mt76_phy_chandef_set(mvif->phy->mt76, &ctx->def);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index d990e34cfcd23..aa76ca4be33a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -244,6 +244,7 @@ int mt792x_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	mutex_lock(&dev->mt76.mutex);
 	mvif->mt76.ctx = ctx;
+	mt76_phy_chandef_set(&dev->mphy, &ctx->def);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
-- 
2.53.0



