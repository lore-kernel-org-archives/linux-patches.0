Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292E0346A00;
	Mon, 18 Aug 2025 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525463; cv=none; b=u9VmNhpnzmQFaQqtsGmkX3RfUb4ccXzyZbFQqfhZFjyXcB95MAq1PT28NNhntKSr62sfHwNXHhfOsLOaoS5EajPDmzhOA6fru06pRRx60zArUN0CVgoZmCTIoksOlsnG1p+IPyXsJrDowVLDs8zpfZ86dcA1X+oXTlmT0ydhg2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525463; c=relaxed/simple;
	bh=Y6pu/6uw+s7f9QjsYXFMiP3iifAPed5jhCA03SpkjNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azqw96b+AxCxT9f+w8chI0euaQfCYRft3nUIr4vQVmLlrnzsrUDUg1DGkAJcKHtKYefALJBITDY3MQOsRbyyAvz+Tf9NNy1qeOiiLdmU8Pgc3qScdMyLT/+tLlZftX/o9bV6wrR5hx1uus6R6KnsM6HC7zMcp/IbsHFSiYUBPZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAMA+cgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAMA+cgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CDEC4CEEB;
	Mon, 18 Aug 2025 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525462;
	bh=Y6pu/6uw+s7f9QjsYXFMiP3iifAPed5jhCA03SpkjNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAMA+cgTqOTJAVXntlEXh1m1zx5Xoc1PML4WaFeoxRnI4MBVUkOKhKC2pe8nDIuZf
	 ZwDSKVhbva8Vd72JjOE0UCKR9haphrQ3HWVBnKW1fVKJafOLkRLfT1qTcfsX5f9GbU
	 BP2oN2MRsmqLlF6CFlTjudxLNx4Hb7MuEIlDeW04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 269/570] wifi: mt76: fix vif link allocation
Date: Mon, 18 Aug 2025 14:44:16 +0200
Message-ID: <20250818124516.210877163@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 74b75035d361..0ecf77fcbe3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1874,6 +1874,9 @@ mt76_vif_link(struct mt76_dev *dev, struct ieee80211_vif *vif, int link_id)
 	struct mt76_vif_link *mlink = (struct mt76_vif_link *)vif->drv_priv;
 	struct mt76_vif_data *mvif = mlink->mvif;
 
+	if (!link_id)
+		return mlink;
+
 	return mt76_dereference(mvif->link[link_id], dev);
 }
 
@@ -1884,7 +1887,7 @@ mt76_vif_conf_link(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	struct mt76_vif_link *mlink = (struct mt76_vif_link *)vif->drv_priv;
 	struct mt76_vif_data *mvif = mlink->mvif;
 
-	if (link_conf == &vif->bss_conf)
+	if (link_conf == &vif->bss_conf || !link_conf->link_id)
 		return mlink;
 
 	return mt76_dereference(mvif->link[link_conf->link_id], dev);
-- 
2.39.5



