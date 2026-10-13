Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5484A389104;
	Tue, 13 Oct 2026 11:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892525; cv=none; b=b/37g2Zq8XLUzuIHQ/oLjhCYUyjKXYl/pkE94Ab/mptg7koaAxZJxjTBJRGycJay9eeYr6A5hzGCoNaL7Ay2LEL4OmsTZXl6cECedmoTSGcOJiuoJMcIw1gUizHtifzUaNQqSTII+TbMHnkhBFl56aPsz40EduUzoWrAwyYWabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892525; c=relaxed/simple;
	bh=Yo0u3LrrFhw91vNRR4FMQ9Gdchnuu9odA5RUv2EEt54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gioGN75nX8imS9xyd2wz0ydspJNQeAiyb7QTJRJfOM1mwM4qzAjdqHWpVIMLpZmmoKbxthcpT4/RNUnpQuEs6y+WNPIEijR/DBCwd90GA5Akdr7E0QOTTKXozj47tqv9vPdjl3i1putiWI6PnYWY5e/JucXpoT7JM+3LBG/lcRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypSt+tQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypSt+tQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D611F000FF;
	Tue, 13 Oct 2026 11:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892524;
	bh=9gm1YtknmSainLf39+seYCdXUtjC/GjjLRQe4FQWFpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypSt+tQ5rnX1AfraZLsS7erahOIcTzQeQbhJjbR903YvS4UtU/9FzGTb2oeSWfBRp
	 AvtV+UC6INyQnpLFpphwB4kKlg/j8gko8DhIZJOymQ17dl84+Z/squf2eak7g7Y20G
	 p3s/kkz3dv4PKSgYw5x9aghnQBQgXDB5Ra1cyhFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 201/281] wifi: mt76: mt7996: program a link again if the driver holds it
Date: Tue, 13 Oct 2026 13:38:37 +0200
Message-ID: <20261013112900.041370709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f5e0b20f6c6d548d985acdd620c5110776c915c2 ]

The firmware needs the driver to remove active links from the BSSINFO table
when it destroys the interface. A link therefore stays registered from its
first chanctx assignment until the interface goes away. If the driver holds
the link already, a second add does nothing.

mac80211 gives a non-AP MLD a new address each time it sets a link up. A link
that comes back after a failed attempt thus carries an address that the
hardware does not know, on a BSS that the driver never programs again. The
station then authenticates from an address that nothing answers. The failure
repeats until the driver tears the interface down for good.

Program the address and the BSS again. This is the pair that the initial add
sets up. For a station it does what mt7996_mcu_mld_link_oper() does for an AP.

Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Link: https://patch.msgid.link/20260818125825.395538-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index c6140412ed322..484fe880232b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -310,7 +310,14 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		if (vif->type == NL80211_IFTYPE_AP)
 			return mt7996_mcu_mld_link_oper(dev, link_conf, link,
 							true);
-		return 0;
+
+		/* update the link address */
+		ret = mt7996_mcu_add_dev_info(phy, vif, link_conf, mlink, true);
+		if (ret)
+			return ret;
+
+		return mt7996_mcu_add_bss_info(phy, vif, link_conf, mlink,
+					       msta_link, true);
 	}
 
 	mlink->idx = __ffs64(~dev->mt76.vif_mask);
-- 
2.53.0



