Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DC3194A45;
	Tue, 27 May 2025 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366686; cv=none; b=PD2QAX/RLOquJSZfrhMvrVze9U+XSmd0cIUyPb6bTgs56qpch4lqon++sOcOfDvAKjkjBSiSlRxCfEESrdWRRMPzrQ6gPHTd+0SErj8HPQTMl26JkQuC7HVsVDjDN1cXGnkdMksZn1ZNHPoRk0fEfs7EegS7aSqFQfTvY5Nxy34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366686; c=relaxed/simple;
	bh=fe+XGCGfZig6PAuVI7uMuK7dR8ipsAhJYr/VamWHqSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5kgLHBJ2bIIlzdt6egIZVa3f9SMyMObmZoe9GgfYxI5/9gv0/NkFyx6MF2d7FoaARnGPGGU/Ljr+sFp3Q/EOzFM/N9cQe8FWyKMPkumeFmTiT0yoDkVbCyD47oqdwmDoJaAL9zcHbkP5j7iaQXJUH2djLvuGrK9UkDMw2CMFHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2Fp8Kxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2Fp8Kxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD694C4CEE9;
	Tue, 27 May 2025 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366686;
	bh=fe+XGCGfZig6PAuVI7uMuK7dR8ipsAhJYr/VamWHqSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2Fp8KxlT6h3Et36wX9PeOLauQVXpzasBKxa1oFJYYUirykmRUL6P53fde5Qcx94M
	 TxfcZDginbCPcKyCddBMOoe00h9NN2paJjsrJxTYCSY97KHOf5Yb1CJoQZCOgxyQM4
	 mKGYZ1G/jSaN5bfcSUlGMciBYXHNiI+lJcc4nHCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 118/783] wifi: mt76: scan: set vif offchannel link for scanning/roc
Date: Tue, 27 May 2025 18:18:35 +0200
Message-ID: <20250527162517.954809610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3ba20af886d1f604dceeb4d4c8ff872e2c4e885e ]

The driver needs to know what vif link to use

Link: https://patch.msgid.link/20250311103646.43346-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 3 +++
 drivers/net/wireless/mediatek/mt76/mt76.h    | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 6a35c6ebd823e..e7b839e742903 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -293,6 +293,7 @@ struct mt76_vif_link *mt76_get_vif_phy_link(struct mt76_phy *phy,
 		kfree(mlink);
 		return ERR_PTR(ret);
 	}
+	rcu_assign_pointer(mvif->offchannel_link, mlink);
 
 	return mlink;
 }
@@ -301,10 +302,12 @@ void mt76_put_vif_phy_link(struct mt76_phy *phy, struct ieee80211_vif *vif,
 			   struct mt76_vif_link *mlink)
 {
 	struct mt76_dev *dev = phy->dev;
+	struct mt76_vif_data *mvif = mlink->mvif;
 
 	if (IS_ERR_OR_NULL(mlink) || !mlink->offchannel)
 		return;
 
+	rcu_assign_pointer(mvif->offchannel_link, NULL);
 	dev->drv->vif_link_remove(phy, vif, &vif->bss_conf, mlink);
 	kfree(mlink);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8714418f3906c..e4ecd9cde36dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -351,6 +351,7 @@ struct mt76_wcid {
 	u8 hw_key_idx;
 	u8 hw_key_idx2;
 
+	u8 offchannel:1;
 	u8 sta:1;
 	u8 sta_disabled:1;
 	u8 amsdu:1;
@@ -788,6 +789,7 @@ struct mt76_vif_link {
 
 struct mt76_vif_data {
 	struct mt76_vif_link __rcu *link[IEEE80211_MLD_MAX_NUM_LINKS];
+	struct mt76_vif_link __rcu *offchannel_link;
 
 	struct mt76_phy *roc_phy;
 	u16 valid_links;
-- 
2.39.5



