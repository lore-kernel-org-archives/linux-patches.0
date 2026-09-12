Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C089F37AA97;
	Sat, 12 Sep 2026 08:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200788; cv=none; b=hqDil373dMhw0LoppKAv9zjwl18znBFRAUUFNygMYdn2WD4tqaHI2RIHYmr1mg+PCHkaY+HPKtyvPmiOsCx/1t7J7XJP+N5sp+rpnu4Wok+huGObbnCh1Alc4yBSOBqM3Ou4E9BgfmgoKate90MRmHWUBcYhrCKExiwAgtmZg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200788; c=relaxed/simple;
	bh=CIcKzWmJYkq1lv6S6UgNRKxo+7jcLPqDwYGrcQgaRvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljzutjTz2mZbdETnTFgiSW/xH1ukkwQmRxji3i6fQ43grJVZQen79P7C0saX0F8peJ1BinzdMLEcq+CcgxY69h0bgrMX5hl+m91k8nNNgF90fJTBTvQoofQWCeEwKLAY9wQCAxLtLtOVY++GFC8La5nxXrAu/vd3wY1jlWQnxbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjLLVz86; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjLLVz86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465D1F000FF;
	Sat, 12 Sep 2026 08:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200786;
	bh=mVWSavR5DbGjYnFj0SN9swZ7t6yOYFfTpjtEytCJTok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjLLVz86OfhTH6E4SBxbw2qoKyCb6NcMHEAat4OwDXfBF4i/8BXHkCBRf5OKd3ZgD
	 HKEsJ3Tv8x0Q9fvj9xxE6eDm4QHayAP/rNix99vwkoN5OPE7bUtKgQcu+iV35Nvggc
	 ApcLoK2HVaenl3LtgJeqLQ5YcPS7FKp7rHoPptGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0860/1815] wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()
Date: Sat, 12 Sep 2026 08:43:30 +0200
Message-ID: <20260912065709.114428105@linuxfoundation.org>
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
index 6edcb3b8f2798..28ad7bcaffd45 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -186,68 +186,74 @@ int mt76_switch_vif_chanctx(struct ieee80211_hw *hw,
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
 		if (mlink->beacon_mon_interval)
 			WRITE_ONCE(mlink->beacon_mon_last, jiffies);
 	}
-- 
2.53.0



