Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06722322A32;
	Mon, 18 Aug 2025 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523703; cv=none; b=qZBzMJX5BPZR+kwB5D/62jZcy7b+BD0jN8UBLfaE1KPJx06UlVmMCIz7oo+HytAIJqJj45Lq3yFeCTWsFc+jvvrXlaCMSh4GyKJlIIgTIgiFaQ6zlKkkbgbEVlGaGEN54KRBNgOfRxDMukXC1iAyuq581NjSx+cw8/JhiY3LTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523703; c=relaxed/simple;
	bh=zLp4qfuAlv66azCdtTE3QVQ0jFtRGDSq8GT0lQ1USsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JW8SK0xLY8qoCBlCJEYWDeesFRhO6bTp6MoT5tVWg1u4/rcAaxg/4eze4RCQadP1D+3r2MJCAm+hdUQIX8F0Edzwrf2Blu0xONKEz4h0pqRt/cRNEBbpXOxiIElkp3Hb5vvCXUrEI/Z3+7J9ht60jgbzHC2layeZBNF2vikSDpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBqOEoxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBqOEoxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1A9C4CEEB;
	Mon, 18 Aug 2025 13:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523702;
	bh=zLp4qfuAlv66azCdtTE3QVQ0jFtRGDSq8GT0lQ1USsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBqOEoxXdBDASUVDKxrkU6d7I7wjJ6EFrwcPbRtiYmCmpvrguFvXA0DZQ7GNfn0Q7
	 X2l6xful5sIvHWoxpStOXuFTVOkDZb+3A0E+GHgN+2lBn90s9C1BtsHbpyyHEMVE5N
	 CQez6dN+pjj8shKZ82NUsOo1UQpniOz2cJMviWOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 251/515] wifi: mt76: fix vif link allocation
Date: Mon, 18 Aug 2025 14:43:57 +0200
Message-ID: <20250818124508.056661327@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 53a5d72bdd70e262623b6009cc4754927b428bad ]

Reuse the vif deflink for link_id = 0 in order to avoid confusion with
vif->bss_conf, which also gets a link id of 0.

Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-1-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt76.h    | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index cc2d888e3f17..77b75792eb48 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -173,13 +173,13 @@ void mt76_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	if (!mlink)
 		goto out;
 
-	if (link_conf != &vif->bss_conf)
+	if (mlink != (struct mt76_vif_link *)vif->drv_priv)
 		rcu_assign_pointer(mvif->link[link_id], NULL);
 
 	dev->drv->vif_link_remove(phy, vif, link_conf, mlink);
 	mlink->ctx = NULL;
 
-	if (link_conf != &vif->bss_conf)
+	if (mlink != (struct mt76_vif_link *)vif->drv_priv)
 		kfree_rcu(mlink, rcu_head);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d7cd467b812f..cc92eb9e5b1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1852,6 +1852,9 @@ mt76_vif_link(struct mt76_dev *dev, struct ieee80211_vif *vif, int link_id)
 	struct mt76_vif_link *mlink = (struct mt76_vif_link *)vif->drv_priv;
 	struct mt76_vif_data *mvif = mlink->mvif;
 
+	if (!link_id)
+		return mlink;
+
 	return mt76_dereference(mvif->link[link_id], dev);
 }
 
@@ -1862,7 +1865,7 @@ mt76_vif_conf_link(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	struct mt76_vif_link *mlink = (struct mt76_vif_link *)vif->drv_priv;
 	struct mt76_vif_data *mvif = mlink->mvif;
 
-	if (link_conf == &vif->bss_conf)
+	if (link_conf == &vif->bss_conf || !link_conf->link_id)
 		return mlink;
 
 	return mt76_dereference(mvif->link[link_conf->link_id], dev);
-- 
2.39.5



