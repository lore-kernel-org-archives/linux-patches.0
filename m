Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019091;
	b=j+0W193mdog61O8Kk2g1kOOI1wfAf/1FOce8195ie4GnLjEGBJe22pnw4XNlMYsdSesY
	 jVCEoqLTY3qrwJ3pORIbZFAuIcNEF9CDQssjiWaWw28kNBuwcJFU8bzH/Y3g+cH9TvqEX
	 9+jowkKbNxqE5XJ0ZPRzMNNcbjqH+SMhICaZ1awB80zkbmEcOdvNNDi5AsOW5EZqK3oRp
	 vXDsqdlpM6IgyZ3ecXgS+dLu+gfsQyAReW+HwNpvB1M3URAVsyHazimCTVpUQQFPJEcJu
	 BcJPVWBB/iJoVm2dlZq3ZradNBlVuFTmzrjzfWCP3XqdqWtFXzng7OAdeGjQ9kk3jsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKqwVZ51JvPoS7cT0yxih09nziZIG4kCPLzzWElS/kw=;
	b=Hwp2seWjvNpOoKXAk5m0d0MrwNXSPOE6k7oqsYF+oiJ8NdFjsK+vBCRxJZsqLuMtgFjj
	 Ws01Qk3vQLYjdQkH+jpVWuYFlIgjnC0R9pTplI9NAEDhb8XlgKP4GaSptNAuAOLHBc6RS
	 d0OX8BwjQu5TW5brWbXeMb9MFFdWHJwKNMbRLKCUGkH7ACuI03Dp5uHE4iKatffMVtDc1
	 gdltnLZCrQNsRt6jAkxMCz1fJR3wQp1IUQfNyYKn8hj4UtlSQOAGxVckMicQrmAoXu7Fq
	 wbtF7FsONs8Js6RQjXZ4gzTz+xuvUNWlO7XympyGIU4t8AiXQcGV/2TEMvvoImnxbag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbwDo6x9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E1606A31C;
	Wed, 18 Nov 2026 16:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbwDo6x9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5EB1F000C4;
	Wed, 18 Nov 2026 16:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019091;
	bh=zKqwVZ51JvPoS7cT0yxih09nziZIG4kCPLzzWElS/kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbwDo6x9oFEahPpDs0obeNdgUs92YeG90rMvrI4qaD4AJtLabqXyEmgePZluoBzJX
	 okSXlicYLZ+sfo0Tfyy4dWy3O/gfCALQUFv7161Ss+tIHspTMDEISmrH9PjKFXkMXi
	 wHk90dF4lJaNaWpcv6Isi3xgUa6S7t78rncEpPOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1471/2651] wifi: mt76: mt7996: find the last MLD link among the links torn down
Date: Wed, 18 Nov 2026 15:45:11 +0100
Message-ID: <20261118150340.989593002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 90abe74d274fad080dffaf3c671e5f31cee53a5b ]

On disassociation, mt7996_mac_sta_event() sends STA_REC_MLD_OFF when
the link it handles is the last of sta->valid_links, but it handles
only active links with driver state. On a station interface with one
active link out of two valid links, no link is ever the last one, so
the firmware never gets STA_REC_MLD_OFF for the MLD.

Walk the same set of links that mt7996_mcu_sta_mld_setup_tlv()
describes, and detect the last link within that set. The per-link
event handling moves into a helper that takes the set of links, so
that a later change can bring up links that became active after
association.

Fixes: c1d6dd5d03eb ("wifi: mt76: mt7996: Add mt7996_mcu_teardown_mld_sta rouine")
Link: https://patch.msgid.link/20261006205936.669125-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index f8d294b691ba9..cfdb2c4c7771e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1406,34 +1406,26 @@ mt7996_mac_sta_add(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 }
 
 static int
-mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
-		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
+mt7996_mac_sta_links_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta, unsigned long links,
+			   enum mt76_sta_event ev)
 {
 	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
-	unsigned long links = sta->valid_links;
-	struct ieee80211_link_sta *link_sta;
+	unsigned long iter_links = links;
 	unsigned int link_id;
-	int err = 0;
-
-	mutex_lock(&dev->mt76.mutex);
+	int err;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_set_bit(link_id, &iter_links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct ieee80211_bss_conf *link_conf;
+		struct ieee80211_link_sta *link_sta;
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 		int i;
 
 		link_conf = link_conf_dereference_protected(vif, link_id);
-		if (!link_conf)
-			continue;
-
-		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
-
+		link_sta = link_sta_dereference_protected(sta, link_id);
 		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
-		if (!msta_link)
-			continue;
+		link = mt7996_vif_link(dev, vif, link_id);
 
 		switch (ev) {
 		case MT76_STA_EVENT_ASSOC:
@@ -1441,12 +1433,12 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_CONNECT, true);
 			if (err)
-				goto unlock;
+				return err;
 
 			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						       link_id, false);
 			if (err)
-				goto unlock;
+				return err;
 
 			msta_link->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 			break;
@@ -1455,7 +1447,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_PORT_SECURE, false);
 			if (err)
-				goto unlock;
+				return err;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
@@ -1476,7 +1468,20 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			break;
 		}
 	}
-unlock:
+
+	return 0;
+}
+
+static int
+mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
+		     struct ieee80211_sta *sta, enum mt76_sta_event ev)
+{
+	int err;
+
+	mutex_lock(&dev->mt76.mutex);
+	err = mt7996_mac_sta_links_event(dev, vif, sta,
+					 mt7996_mac_sta_links(dev, vif, sta),
+					 ev);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
-- 
2.53.0



