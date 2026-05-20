Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7D33A5435;
	Wed, 20 May 2026 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294775; cv=none; b=JdM0Wip46/BVfXcBLHD9PqLuWTkbldvlhITXKBhH04JNC0jHSPDQ6/6MPn+UQt7L3rOk7BouueD3f98jUUCdlUMJFJu9Lcc/iWvJL8UXYCwpBvkG3dprxICQLbU16Dy6FMwWnuFOj6UDOLtCq6utV+zjZ2MDieLoOagz4hy/dy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294775; c=relaxed/simple;
	bh=ZVmnnam9seoNeucRX9pYy80YkKbh3V93AzMkazmRCDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfjKUVnPAOjkm1OFes/xeVdaDCmpGC9qrEpPAw2NsiZUiiteIVZCwY/CulMfzr9TKwnyTqwr86OUDKwyvP+MDRw/k/XglY3KE+WFBLgWCcQYcFlZbgV9cizcc5kmuecyG6A9mV/dTVb24BpdUymEMPvu8C64X87+N+FcFeHu5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TO1I8ePc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TO1I8ePc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45261F000E9;
	Wed, 20 May 2026 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294774;
	bh=lqZhYqncS2FI1LUsljPIFTUG4L7KOrXgyXKHfWAo7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TO1I8ePcHBdTZNeKlrisBsjMBIThEDz5Gu70JdN37KLF7reaC2kCYtsZmHrxf/wIj
	 cWP13Sf+vHtzq9IAOBJF+9VnVaBUJkiGE5OXEPCIyexswE4Ycpj4wmahBbKTMWcRue
	 JVDI1YjT/0lm4F+RlaMgK0iuSWNalbDdpBk5Z8fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0127/1146] wifi: mt76: mt7996: Decrement sta counter removing the link in mt7996_mac_reset_sta_iter()
Date: Wed, 20 May 2026 18:06:17 +0200
Message-ID: <20260520162151.200571864@linuxfoundation.org>
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

[ Upstream commit e648051d52afbdb360bd586218961f5fffff63e8 ]

Fixes tracking per-phy stations for offchannel switching.

Fixes: ace5d3b6b49e8 ("wifi: mt76: mt7996: improve hardware restart reliability")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260308-mt7996_mac_reset_vif_iter-fix-v1-1-57f640aa2dcf@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 5797412962b85..7f0d7c797a531 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2400,6 +2400,7 @@ mt7996_mac_reset_sta_iter(void *data, struct ieee80211_sta *sta)
 
 	for (i = 0; i < ARRAY_SIZE(msta->link); i++) {
 		struct mt7996_sta_link *msta_link = NULL;
+		struct mt7996_phy *phy;
 
 		msta_link = rcu_replace_pointer(msta->link[i], msta_link,
 						lockdep_is_held(&dev->mt76.mutex));
@@ -2407,6 +2408,10 @@ mt7996_mac_reset_sta_iter(void *data, struct ieee80211_sta *sta)
 			continue;
 
 		mt7996_mac_sta_deinit_link(dev, msta_link);
+		phy = __mt7996_phy(dev, msta_link->wcid.phy_idx);
+		if (phy)
+			phy->mt76->num_sta--;
+
 		if (msta_link != &msta->deflink)
 			kfree_rcu(msta_link, rcu_head);
 	}
-- 
2.53.0



