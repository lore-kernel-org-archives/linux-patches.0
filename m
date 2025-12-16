Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF31F36C5B7;
	Tue, 16 Dec 2025 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887983; cv=none; b=VQsDMH3Y4IzBimWK9op/lqZswvhfv43CGneAhy3/qoaxCiWDcBOhnfYwgKRlIVanAAxGglJbFJIIsuDgO9n4C7DjCfdBNH7AE6u+udwCaY4ipWpROoWsHTHlSykY4Sh353rON8Qymdttj3xoHJfJqkJQ2KYxp+5pAMKvj8V1b9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887983; c=relaxed/simple;
	bh=o6grrxKl8PdSo2lqNnjNJXAVXPtmsVXPsWFOVqj+e+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngvvLoDefo/UUMGh9til0fbGOmmP5vU/85tSfhMeCTg1XCBsRn/jrsn1H1HCD+GS0O4yZlhESZef8utA/wYAAa7MdhM+O2y+q30H+sRmQydmHirPT3ArzDlWqpKZqZiJ+QgXVt26Np4lHQ9qMXQDoBad0PbfSWOi2eRukmcXsY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enLGOGCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enLGOGCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C301C4CEF1;
	Tue, 16 Dec 2025 12:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887982;
	bh=o6grrxKl8PdSo2lqNnjNJXAVXPtmsVXPsWFOVqj+e+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enLGOGCxd4fwEQBPna5qePg+lm3NX3SPLqyg/gCy4F5cj/vOS6jQ62TPKICMlM2iZ
	 gYm39VvcNy/i3bQNndmT7+5tKHm85S9wBlvs5/PVqb+/42Kfc1VsUEqunnoaq+7ZEG
	 PzeyfQXk+cUS2v2OSlUQc2CC/3ZnLAAgU7SXQrds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/614] wifi: mt76: mt7996: grab mt76 mutex in mt7996_mac_sta_event()
Date: Tue, 16 Dec 2025 12:12:44 +0100
Message-ID: <20251216111415.758629656@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5a4bcba26e9fbea87507a81ad891e70bb525014f ]

Grab mt76 mutex in mt7996_mac_sta_event routine in order to rely on
mt76_dereference() utility macro.

Fixes: ecd72f9695e7e ("wifi: mt76: mt7996: Support MLO in mt7996_mac_sta_event()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20251114-mt76-fix-missing-mtx-v1-1-259ebf11f654@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index beb455185f904..ead56ce4c0362 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1150,12 +1150,15 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	unsigned long links = sta->valid_links;
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
+	int err = 0;
+
+	mutex_lock(&dev->mt76.mutex);
 
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf;
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
-		int i, err;
+		int i;
 
 		link_conf = link_conf_dereference_protected(vif, link_id);
 		if (!link_conf)
@@ -1175,12 +1178,12 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_CONNECT, true);
 			if (err)
-				return err;
+				goto unlock;
 
 			err = mt7996_mcu_add_rate_ctrl(dev, msta_link->sta, vif,
 						       link_id, false);
 			if (err)
-				return err;
+				goto unlock;
 
 			msta_link->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 			break;
@@ -1189,7 +1192,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_PORT_SECURE, false);
 			if (err)
-				return err;
+				goto unlock;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
@@ -1209,8 +1212,10 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			break;
 		}
 	}
+unlock:
+	mutex_unlock(&dev->mt76.mutex);
 
-	return 0;
+	return err;
 }
 
 static void
-- 
2.51.0



