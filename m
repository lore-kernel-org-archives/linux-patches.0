Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDC6522A;
	Wed,  5 Feb 2025 14:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765603; cv=none; b=tylBs472va5WWMCc7ZLL+yP3X3wdI+xFOzLcT/TWFCRnZE/eBE28SHg7trGu78HaTbjDG/ENW7znW6VVaF26bBDkqUceP8pwixgVGH5Er8I2pyK4LgkaN17M4kvLo9uqa/5ebUzmhMNO+hH/iJpFILB+UxN7jVr+F6zu0NZwsUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765603; c=relaxed/simple;
	bh=L+vrpBKNbvfYs/Gz3TAmERESAdSF9rrsxrS8Bxeo1aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+y2/45YNVrgmmUjAdQZ+qC7yNdl9tLLlB7OudySXue5x3z2MDX23R4/UrFaz27oFVSoz102K1AZekXgrddNs+THr6l5sn0ToEJW75MAQooFRMtknr4VSUb++TytWOScsR9joDwHW1qD502pHFXvWzuOpo2rCjXixRUpkh3pyOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7mPub5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7mPub5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BA5C4CED1;
	Wed,  5 Feb 2025 14:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765603;
	bh=L+vrpBKNbvfYs/Gz3TAmERESAdSF9rrsxrS8Bxeo1aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7mPub5X4wquku8kAI72zsUZtEHgSQ9vf7x7mOyqhBQrCjZY7anf4LhOj6EMxTx8Z
	 MYZHO4AnZuSAnbs8W34PodhoMj7gmbYS270mZ15hW7AXc197nBG3M9HAh9n+VH+P1M
	 cfoxuCQ+YfxlFHwP+UofIKSpusSQ9yD3gMyqWYBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 197/623] wifi: mt76: mt7925: Update mt7925_unassign_vif_chanctx for per-link BSS
Date: Wed,  5 Feb 2025 14:38:59 +0100
Message-ID: <20250205134503.770738720@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 30b721467c9c2510e26af6e78e92d7cc08a14bc4 ]

Update mt7925_unassign_vif_chanctx to support per-link BSS.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-12-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 1140af6577937..a78aae7d10886 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2081,18 +2081,16 @@ static void mt7925_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt792x_chanctx *mctx = (struct mt792x_chanctx *)ctx->drv_priv;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
-	struct ieee80211_bss_conf *pri_link_conf;
 	struct mt792x_bss_conf *mconf;
 
 	mutex_lock(&dev->mt76.mutex);
 
 	if (ieee80211_vif_is_mld(vif)) {
 		mconf = mt792x_vif_to_link(mvif, link_conf->link_id);
-		pri_link_conf = mt792x_vif_to_bss_conf(vif, mvif->deflink_id);
 
 		if (vif->type == NL80211_IFTYPE_STATION &&
 		    mconf == &mvif->bss_conf)
-			mt7925_mcu_add_bss_info(&dev->phy, NULL, pri_link_conf,
+			mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf,
 						NULL, false);
 	} else {
 		mconf = &mvif->bss_conf;
-- 
2.39.5



