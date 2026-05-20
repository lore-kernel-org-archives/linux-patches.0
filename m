Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4CC356748;
	Wed, 20 May 2026 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297565; cv=none; b=JCGm2pDoUltCMYxqKNDFfcuw7Y5XKQulKUHGkxmBGHLri6HwzGDzdJBozBmNDTT/wib7+Qe1RFhZxmoIuWgTH/0Q9tOcU76hxNDrycnK8muh3FS9d93ie8XyWbk0OkBkHlj8WZZzo32jkHLXf2SMsmRU4lHKxrpGZ985ydqQ4ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297565; c=relaxed/simple;
	bh=ACqZcqs0mZQpMezPqIIY0ruasgstDi1V3N8GSQha1m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGF/1eZC7W9dq6Te0gIRwFGvucCjQyI/pnpRb2etwicIP09NEJ98Fp/dQ3XIkDUFuwymQVU6LJD8Hj3U+PjCzQpoSCpGwnt5yn8jNG1TxXyuSaPdUmM9quIHj0mWqlBxG0mvcgeXI7gALxL+ipyLQ2yoGKReqGMG5d5aFlWZb1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKqn0t5l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKqn0t5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FB81F000E9;
	Wed, 20 May 2026 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297564;
	bh=QWAQlqR/AQjnb+JIILeZRyDz2m+g3FJ6Rtxl2gEuKCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FKqn0t5lehpozoHz1pt6iQ0MgeO0MmVkYOov1wpLGZpI5jcKYKV3eipI3vc8vXB0o
	 1+L8+M0PcJyTdNwrqrYWaHZOM+32ZzOzdLNg11rFBIkfjHI+JxfRAVue/M21H0sIa5
	 CdmSLjUU+vNkhDaKUQbFGMwRyPGGV9QU1AkDUwpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/957] wifi: mt76: mt7996: Reset mtxq->idx if primary link is removed in mt7996_vif_link_remove()
Date: Wed, 20 May 2026 18:09:20 +0200
Message-ID: <20260520162136.233002293@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

[ Upstream commit 751a2679b15e3a0fa8fc9175862f0ec40643db68 ]

Reset WCID index in mt76_txq struct if primary link is removed in
mt7996_vif_link_remove routine.

Fixes: a3316d2fc669f ("wifi: mt76: mt7996: set vif default link_id adding/removing vif links")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251205-mt76-txq-wicd-fix-v2-2-f19ba48af7c1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 44c52062c640b..5d4b1d8f3335b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -402,17 +402,28 @@ void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 
-	if (!mlink->wcid->offchannel &&
+	if (vif->txq && !mlink->wcid->offchannel &&
 	    mvif->mt76.deflink_id == link_conf->link_id) {
 		struct ieee80211_bss_conf *iter;
+		struct mt76_txq *mtxq;
 		unsigned int link_id;
 
 		mvif->mt76.deflink_id = IEEE80211_LINK_UNSPECIFIED;
+		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
+		/* Primary link will be removed, look for a new one */
 		for_each_vif_active_link(vif, iter, link_id) {
-			if (link_id != IEEE80211_LINK_UNSPECIFIED) {
-				mvif->mt76.deflink_id = link_id;
-				break;
-			}
+			struct mt7996_vif_link *link;
+
+			if (link_id == link_conf->link_id)
+				continue;
+
+			link = mt7996_vif_link(dev, vif, link_id);
+			if (!link)
+				continue;
+
+			mtxq->wcid = link->msta_link.wcid.idx;
+			mvif->mt76.deflink_id = link_id;
+			break;
 		}
 	}
 
-- 
2.53.0



