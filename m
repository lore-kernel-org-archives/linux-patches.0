Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625E2DC76C;
	Wed, 20 May 2026 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297630; cv=none; b=Y1awPFJEXHY8UkL+YTftl79JX0yOzqd6b2QeRmsB/fCT27brvkvmXkqVef1tt6PdoMJg4RWDtxXNlwoRg06EZtbRZ00P1cH2sEwWsamOkCjf2YqUMV/LyRV8WSLEKDFWPsyV4VvKgRb4/XNRJ+nUPKfjBm8RKTyzuYKEAfJxVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297630; c=relaxed/simple;
	bh=dKdZZYaIczxDul7bpKF7zXEfgAjZLDL6ulfhbPXYJrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPj2bLAnvE4tL/+5dPOiJvZg3rV23kiHuBsKd2noa5U2mo/ubWtoksMnOM7g41E9mEIzoiIIlPf8GLHozX+nVlDkXQehAtkjOgGtNtI3VigVcVUCx7v7p86J2YLTOnMUPuP3U+X6EAJiO3NuW5OJpxWYmpgW+NDADdCby0g8lk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjHbRq6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjHbRq6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E38C1F000E9;
	Wed, 20 May 2026 17:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297629;
	bh=6f8cAZT2ollrjn8riBJy+y3bWJOUe+RNvdwhTPYHBdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjHbRq6xRTTu4oe2/lHuOLh/bXVmGEaz615Z3XBaq1HcHyEsyXiVwdN7HL7BB58yv
	 kVnxgvxUN+iAl6v16LXuaCZH9OhyKMT9S8j81KfTe5aAvCnH41bjt30thP0MdB2q4F
	 8ocQxm2CkcQMfhWeMXM1AiKKHg6v6NIuKkuVW6uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/957] wifi: mt76: mt7996: Decrement sta counter removing the link in mt7996_mac_reset_sta_iter()
Date: Wed, 20 May 2026 18:09:47 +0200
Message-ID: <20260520162136.816837486@linuxfoundation.org>
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
index 3280446f7caa8..dce9f48637927 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2399,6 +2399,7 @@ mt7996_mac_reset_sta_iter(void *data, struct ieee80211_sta *sta)
 
 	for (i = 0; i < ARRAY_SIZE(msta->link); i++) {
 		struct mt7996_sta_link *msta_link = NULL;
+		struct mt7996_phy *phy;
 
 		msta_link = rcu_replace_pointer(msta->link[i], msta_link,
 						lockdep_is_held(&dev->mt76.mutex));
@@ -2406,6 +2407,10 @@ mt7996_mac_reset_sta_iter(void *data, struct ieee80211_sta *sta)
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



