Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7E343FD01;
	Thu, 30 Jul 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424071; cv=none; b=MXFqP8WCtSk2XBQrJDnYMwPKM3D7jXxnlR1mGWe8/C9bhtyBIcIwCXqnBmymtw1ZHr0vVExh+zfqwGguvC1AO0HePWE+7lZd38YnknbjMrWvas0y5BJTb/5FWZbXRK0//bT8abjDCpxV3BCRl1MqjitlTsvmzQ/DK8eLqjbF/Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424071; c=relaxed/simple;
	bh=iaNzAZeqlGs5aMzR4/9XWqCJf19IMwEpoqEboPIhC78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B26WjhoGzdqc8s0DRa6UeED366do4uxM6ptMKz/zTHQdn9bDuVfW7hHZH798y/OrYt6g+S1zC7SPEQqz1N4tQmpbd8iJoMOCOhALAKOuhXOmFC3x5YCwobJFLtnXCSSh4rU7ha4q0jYarmjmUUuLzDHjFwU6xeoc21cTTckoJhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uh7xraPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uh7xraPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96D01F000E9;
	Thu, 30 Jul 2026 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424070;
	bh=5P99+buoo/4mAKSLI/r1VUG/3TSHOJ5+J2nsrOenHnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uh7xraPTHxroE9T/hmRLiabpb2qRmx1VCxVUSDwYuL3qwtVBUj91Ks63wZprpY0/v
	 +fsv5XVVWdxyu6Cc4FD8kQ81Tc0Zh7RVm4moYfNkeGnxtFTiNtmRfAGq5tObeRt85R
	 i45nE+eFdbseUMLhRLZ0HDLLQ9SketekHcnJjsMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/675] wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
Date: Thu, 30 Jul 2026 16:09:53 +0200
Message-ID: <20260730141450.723981086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

[ Upstream commit e858cf6bf99880343348ff1e8c942aaff1d9d592 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-3-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index a3f813be107df7..87ec7e90dfeebe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -860,6 +860,8 @@ mt7996_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1659,17 +1661,18 @@ mt7996_mcu_sta_bfer_he(struct ieee80211_link_sta *link_sta,
 {
 	struct ieee80211_sta_he_cap *pc = &link_sta->he_cap;
 	struct ieee80211_he_cap_elem *pe = &pc->he_cap_elem;
-	const struct ieee80211_sta_he_cap *vc =
-		mt76_connac_get_he_phy_cap(phy->mt76, vif);
-	const struct ieee80211_he_cap_elem *ve = &vc->he_cap_elem;
 	u16 mcs_map = le16_to_cpu(pc->he_mcs_nss_supp.rx_mcs_80);
 	u8 nss_mcs = mt7996_mcu_get_sta_nss(mcs_map);
+	const struct ieee80211_he_cap_elem *ve;
+	const struct ieee80211_sta_he_cap *vc;
 	u8 snd_dim, sts;
 
+	vc = mt76_connac_get_he_phy_cap(phy->mt76, vif);
 	if (!vc)
 		return;
 
 	bf->tx_mode = MT_PHY_TYPE_HE_SU;
+	ve = &vc->he_cap_elem;
 
 	mt7996_mcu_sta_sounding_rate(bf, phy);
 
-- 
2.53.0



