Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABE73E9C0C;
	Wed, 20 May 2026 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294586; cv=none; b=GOcCgX7jnMObrh7kDdVC+dWUquHJ3gbpr0qwFA6Abj0df8FY6DMx0B8DqbqiwDq38WBUtv1VTHbFgL7ONQEpTf4Y/QXmv/5hOiq3YBSR4AfB3r8wZinq2P8/DDF1flKNAtEv0b1SKa8dyfI700VZ0emENv/0jQpEiE9NTZFvX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294586; c=relaxed/simple;
	bh=7mqt3+OvA77WpALoXf1sbu4/sL5L1BywvmjkCG+sLMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D87i/x1VI8btrAONBd7tYB0ZZaOn00OgO5a89KTHfqAjsT2wxNp0m8R4hyJhdc6ohhiV7EzcDY84Ha92D4oba79P4aAfWAdV+fjoccCI84MdkI4lb0xYyLSMPC1ovdlro7XT0oXLqR2Vhuf8Wf32R3AHBk7lopAJYxeDsM0RRww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cexp4I+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cexp4I+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8831F000E9;
	Wed, 20 May 2026 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294584;
	bh=zqk/Y5TqEmO/fr8/SgYV3PM0Q7pEBWT5XmlqrgkEw2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cexp4I+K/AaB1pTaHAhs0Kbxa0i+XyHDij8a6o7cCg3Sys2X3ePDE9YrzSiMV3tXk
	 LXsbIpjHyd/EYKaNuwHL3Q/3nys0wdaZr9PyYkb66OajkcOahPvaHArTISgLUef7cf
	 GsnVaaLthIvxk+3OUMvQpWD2ueR2+lKBiTuDn38w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0096/1146] wifi: mt76: mt7996: Reset mtxq->idx if primary link is removed in mt7996_vif_link_remove()
Date: Wed, 20 May 2026 18:05:46 +0200
Message-ID: <20260520162150.521069996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d75f48c61ce0f..c6204a8673ee7 100644
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



