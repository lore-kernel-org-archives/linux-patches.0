Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6D03451BA;
	Tue, 16 Dec 2025 11:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886088; cv=none; b=MfVoTeUzmEq62VCjjTuJXEcxaBXcbLkS8QD9DOr5CG6pM2bc+NmAebmOYJHndmHEN9PY94n/u5LtpPh8HvOdboZgSfsMXI5lZLDgBBioM6rf/fbbA6HjXiqeO+yTEiXjqqtf0aD9Gm39YTi1enCXAKeqMxKmNArGTxlswoDixaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886088; c=relaxed/simple;
	bh=duwXP/iEnGDM8uPqsR3Po7pueXK78VvgjUvqFnup3FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBhiErLQ2KExcmHKCVK7rz6TKFCUB0/Yuh1cmgM+jkuMOuAuOGqWNg4yS3JQoMAZgvN3Uh4Dh57Mg5vZ+qi/6USrlCyA9ecniGgsE6L3uwGgSzh2uqo+vl91eso64i5mCU7OLZqYrUSLDgUrKpwkvGB5djrkdXNFv1jFGok8k/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yfs5vFSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yfs5vFSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EEFC4CEF1;
	Tue, 16 Dec 2025 11:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886088;
	bh=duwXP/iEnGDM8uPqsR3Po7pueXK78VvgjUvqFnup3FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yfs5vFSE5LTxYLaUG+I1D2bIc5GYXxEjuZFo2yFLa7xukqr+mUmEZrw5dwBbwf9uW
	 uFKlJIyliLCV97GXLJQbjTfeEETlhSXm1uLPtyy0Lm0k4B5O2ByawhXNEgmico4GN2
	 C1QfANJmHnxShvlcxEr3du3Tt3Cuj84b3PHl0f3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 334/507] wifi: mt76: mt7996: grab mt76 mutex in mt7996_mac_sta_event()
Date: Tue, 16 Dec 2025 12:12:55 +0100
Message-ID: <20251216111357.564801081@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 14e90ecf925e1..04b1d5f871376 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1140,12 +1140,15 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
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
@@ -1165,12 +1168,12 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
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
@@ -1179,7 +1182,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 						 link, msta_link,
 						 CONN_STATE_PORT_SECURE, false);
 			if (err)
-				return err;
+				goto unlock;
 			break;
 		case MT76_STA_EVENT_DISASSOC:
 			for (i = 0; i < ARRAY_SIZE(msta_link->twt.flow); i++)
@@ -1199,8 +1202,10 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
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



