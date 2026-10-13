Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58413CB2EA;
	Tue, 13 Oct 2026 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894137; cv=none; b=p67O9crbAEEoI81zQnc0PQR0oiEnWc2ogNymuyXPIWa5m8/d32hrQ5AE4CCr5VYPrBE/AVdQgxoDaTKRHCRiDgQmnuYASu+YW18EKeXkCAiiZompQ3DtJ54WWTh7rpXzLlgBcyLlN78ul/WYTVRRaYUiEH1E44Ne+HM9NdRhABg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894137; c=relaxed/simple;
	bh=ePcyoFTO6PRN4UDO/DVK1KWl+p/dLXBV8mOGMfnJlqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCedLuOqBoJaCWlyBtCbf0WJtA6bvNZo/0ZnCeIeVjAZ2ZxI2LDs4RP5bMpeKVk56HvASLGQ+pnWrr0vNytd6duB5zYzVW9IsAiw7cVF6XB4fWTUbyAgmrFmDcmMv7ey3nsEOruSFrd0UGWvPCmwRyDc+MoB4eJBiwR1FJhPGtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGV/N0Hm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGV/N0Hm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4FB1F000FF;
	Tue, 13 Oct 2026 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894136;
	bh=NqImaaxdGaM+W65aqGQiwzacxtbf8IcVmuE83EqDKQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGV/N0HmAX7uCULUKfykUm7XJlAA50VZpQ81nzbyNBDM9jGt1kR9eQ4nzBcBAceMu
	 8V2wcEXg4yWJqeI6pTyn/4jE1K1EQ06fJSEEWc7jiGPR5owHEAZlrt6iSNxY1eo3Y8
	 3KNbOdM2Ej8Jf22/s6ZI1wKaV98bzEAMlv5uiLwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/621] wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()
Date: Tue, 13 Oct 2026 13:37:34 +0200
Message-ID: <20261013112931.724830199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 70869cc429fffc77de51e7777c0ecb651e8fca07 ]

When performing channel switches on different radios within a short
timeframe, channel contexts with different bands can be carried for
each struct ieee80211_vif_chanctx_switch.

Rework mt76_switch_vif_chanctx() to properly handle this scenario.

Fixes: 82334623af0c ("wifi: mt76: add chanctx functions for multi-channel phy support")
Co-developed-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260720090102.190729-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 92 +++++++++++---------
 1 file changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 6adaeaf63e46a..065e613289e02 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -192,68 +192,74 @@ int mt76_switch_vif_chanctx(struct ieee80211_hw *hw,
 			    int n_vifs,
 			    enum ieee80211_chanctx_switch_mode mode)
 {
-	struct mt76_chanctx *old_ctx = (struct mt76_chanctx *)vifs->old_ctx->drv_priv;
-	struct mt76_chanctx *new_ctx = (struct mt76_chanctx *)vifs->new_ctx->drv_priv;
-	struct ieee80211_chanctx_conf *conf = vifs->new_ctx;
-	struct mt76_phy *old_phy = old_ctx->phy;
-	struct mt76_phy *phy = hw->priv;
+	struct ieee80211_vif_chanctx_switch *v;
+	struct mt76_chanctx *old_ctx, *new_ctx;
+	struct mt76_phy *old_phy, *phy = hw->priv;
 	struct mt76_dev *dev = phy->dev;
 	struct mt76_vif_link *mlink;
-	bool update_chan;
+	bool need_update[__MT_MAX_BAND] = {};
 	int i, ret = 0;
 
-	if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS)
-		phy = new_ctx->phy = dev->band_phys[conf->def.chan->band];
-	else
-		phy = new_ctx->phy;
-	if (!phy)
-		return -EINVAL;
+	for (i = 0; i < n_vifs; i++) {
+		v = &vifs[i];
+		new_ctx = (struct mt76_chanctx *)v->new_ctx->drv_priv;
+		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS)
+			phy = new_ctx->phy = dev->band_phys[v->new_ctx->def.chan->band];
+		else
+			phy = new_ctx->phy;
 
-	update_chan = phy->chanctx != new_ctx;
-	if (update_chan) {
-		if (dev->scan.phy == phy)
-			mt76_abort_scan(dev);
+		if (!phy)
+			return -EINVAL;
 
-		cancel_delayed_work_sync(&phy->mac_work);
+		if (need_update[phy->band_idx])
+			continue;
+
+		if (phy->chanctx != new_ctx) {
+			if (dev->scan.phy == phy)
+				mt76_abort_scan(dev);
+
+			cancel_delayed_work_sync(&phy->mac_work);
+			need_update[phy->band_idx] = true;
+		}
 	}
 
 	mutex_lock(&dev->mutex);
 
-	if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS &&
-	    phy != old_phy && old_phy->chanctx == old_ctx)
-		old_phy->chanctx = NULL;
+	for (i = 0; i < n_vifs; i++) {
+		v = &vifs[i];
+		old_ctx = (struct mt76_chanctx *)v->old_ctx->drv_priv;
+		old_phy = old_ctx->phy;
+
+		new_ctx = (struct mt76_chanctx *)v->new_ctx->drv_priv;
+		phy = new_ctx->phy;
 
-	if (update_chan)
-		ret = mt76_phy_update_channel(phy, vifs->new_ctx);
+		if (mode == CHANCTX_SWMODE_SWAP_CONTEXTS && old_phy->chanctx &&
+		    old_phy->chanctx == old_ctx && phy != old_phy)
+			old_phy->chanctx = NULL;
 
-	if (ret)
-		goto out;
+		if (need_update[phy->band_idx]) {
+			ret = mt76_phy_update_channel(phy, v->new_ctx);
+			if (ret)
+				goto out;
 
-	if (old_phy == phy)
-		goto skip_link_replace;
+			need_update[phy->band_idx] = false;
+		}
 
-	for (i = 0; i < n_vifs; i++) {
-		mlink = mt76_vif_conf_link(dev, vifs[i].vif, vifs[i].link_conf);
+		mlink = mt76_vif_conf_link(dev, v->vif, v->link_conf);
 		if (!mlink)
 			continue;
 
-		dev->drv->vif_link_remove(old_phy, vifs[i].vif,
-					  vifs[i].link_conf, mlink);
-
-		ret = dev->drv->vif_link_add(phy, vifs[i].vif,
-					     vifs[i].link_conf, mlink);
-		if (ret)
-			goto out;
-
-	}
+		if (old_phy != phy) {
+			dev->drv->vif_link_remove(old_phy, v->vif, v->link_conf,
+						  mlink);
 
-skip_link_replace:
-	for (i = 0; i < n_vifs; i++) {
-		mlink = mt76_vif_conf_link(dev, vifs[i].vif, vifs[i].link_conf);
-		if (!mlink)
-			continue;
+			ret = dev->drv->vif_link_add(phy, v->vif, v->link_conf,
+						     mlink);
+			if (ret)
+				goto out;
+		}
 
-		mlink->ctx = vifs->new_ctx;
+		mlink->ctx = v->new_ctx;
 	}
 
 out:
-- 
2.53.0



