Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA648634E;
	Wed,  5 Feb 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765564; cv=none; b=lqy7thYlXTEK1AHO0/QNMGue9kw7r+9XUl34bXQkL0CBxx3PiZYTp77roZ1xzG8SJ0cuP8W31FsfBmikJnliYAipogSed/j2Auyuf4k6sK0+QuEz/Ke9we4k/4mqef5cRoYfbGPhA7ngH8wxIS+slaoSZIfxhWRulquJulEBCm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765564; c=relaxed/simple;
	bh=DgpNqQjjYPMvi+MRQgsPwDuTi+QI0dzxTnMS4v7vrIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4zNXuKQQuwIQwfltBeM7s/Kh2dTsGcMYNAEne8WJ8pFgCN1AR3FdDxLCbSyWKjIVQjfN6qIG3RTlDflN/WXhlnO+9gIIhsqh8mvXRQw8YrOVgGdsUBOKdleDhodrzHsrsQhSq3CRl35cEQPj2PGPx84geQw+JgST7JvSEWbbk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJqX6NCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJqX6NCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A467C4CED1;
	Wed,  5 Feb 2025 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765564;
	bh=DgpNqQjjYPMvi+MRQgsPwDuTi+QI0dzxTnMS4v7vrIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJqX6NCBVCD8WX7+etBinDXswqZA0kpcOn/s9FJRzzkhwRXVpZSWGif4LdgVpSC7Y
	 d1zr5RqJUyoHWfW0OCifIpgwxtHarqh2zholueYkbpgQLpvCbnVJzGEWroVatBMrTA
	 NVri/pNurlBgHEmYc+GX8eVeqh52W52X2FQfhOLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 189/623] wifi: mt76: mt7925: Fix incorrect WCID assignment for MLO
Date: Wed,  5 Feb 2025 14:38:51 +0100
Message-ID: <20250205134503.468627749@linuxfoundation.org>
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

[ Upstream commit 4911e4cb157cf87d5bdb3fa8e0c200032443371e ]

For MLO, each link must have a corresponding WCID.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index ddd406969061e..a095fb31e391a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -49,7 +49,7 @@ static void mt7925_mac_sta_poll(struct mt792x_dev *dev)
 			break;
 		mlink = list_first_entry(&sta_poll_list,
 					 struct mt792x_link_sta, wcid.poll_list);
-		msta = container_of(mlink, struct mt792x_sta, deflink);
+		msta = mlink->sta;
 		spin_lock_bh(&dev->mt76.sta_poll_lock);
 		list_del_init(&mlink->wcid.poll_list);
 		spin_unlock_bh(&dev->mt76.sta_poll_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index c45396b17a8af..cbc7a50810256 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -837,6 +837,7 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	u8 link_id = link_sta->link_id;
 	struct mt792x_link_sta *mlink;
 	struct mt792x_sta *msta;
+	struct mt76_wcid *wcid;
 	int ret, idx;
 
 	msta = (struct mt792x_sta *)link_sta->sta->drv_priv;
@@ -855,6 +856,15 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	mlink->last_txs = jiffies;
 	mlink->wcid.link_id = link_sta->link_id;
 	mlink->wcid.link_valid = !!link_sta->sta->valid_links;
+	mlink->sta = msta;
+
+	wcid = &mlink->wcid;
+	ewma_signal_init(&wcid->rssi);
+	rcu_assign_pointer(dev->mt76.wcid[wcid->idx], wcid);
+	mt76_wcid_init(wcid);
+	ewma_avg_signal_init(&mlink->avg_ack_signal);
+	memset(mlink->airtime_ac, 0,
+	       sizeof(msta->deflink.airtime_ac));
 
 	ret = mt76_connac_pm_wake(&dev->mphy, &dev->pm);
 	if (ret)
@@ -904,7 +914,6 @@ mt7925_mac_sta_add_links(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta, unsigned long new_links)
 {
 	struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
-	struct mt76_wcid *wcid;
 	unsigned int link_id;
 	int err = 0;
 
@@ -921,14 +930,6 @@ mt7925_mac_sta_add_links(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 				err = -ENOMEM;
 				break;
 			}
-
-			wcid = &mlink->wcid;
-			ewma_signal_init(&wcid->rssi);
-			rcu_assign_pointer(dev->mt76.wcid[wcid->idx], wcid);
-			mt76_wcid_init(wcid);
-			ewma_avg_signal_init(&mlink->avg_ack_signal);
-			memset(mlink->airtime_ac, 0,
-			       sizeof(msta->deflink.airtime_ac));
 		}
 
 		msta->valid_links |= BIT(link_id);
-- 
2.39.5



