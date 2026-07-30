Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44B274650;
	Thu, 30 Jul 2026 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425838; cv=none; b=O1D+bNfwi2nfdqnFFfGn715qxHPHKiK3ec9rvwy8Bf21ze8JRIx3cdImmLB33Ht6UvTVIRiN4fhLZPpvvAHXzUN525XzS8yIBzy6rjNavWPzenMPnpXlY8fYk7KNv5FMnKhHGcdYq7IHkrUZ9Q/ZEK5upbtiFP3ZOe11mfzX2Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425838; c=relaxed/simple;
	bh=7Z+aWOFbV/h+slMYx3bPcdZlAlAd1lP0Aqnip7kCKa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFlCs6Rcl0bYJ2v84oLv2DyF9B/TbICzZhphR+D24TBF8P8n1ZARRfB9/U2ENv6DsJPKbui0kfNfOU77o+ao2V/5UdDY51w3KuEpPRQI8/VKUTEJw2SveOHQBe5CX9RpKF7/jiSZRJO7PAod0PraaL0b55nay34RJjkPA0HIk2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSTNbBVV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSTNbBVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D151F000E9;
	Thu, 30 Jul 2026 15:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425837;
	bh=bn1MqffzsujU884vjcG6gn+ujzxuiSyJ/AvuXkkp8S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JSTNbBVVWKU6jKMiXXQOjhui8IpPGAjBHPG/MW6TgnIiAx3TzJdt6X3z8unmu8I1w
	 Ki/T4nA0OgRLykEXeuDQn1X3rzEDG7NDnnhIM79qdne/zXnb7IZVmvLiXTTIJf9tia
	 eKZzx9wkjsAvADPG+/CkTk9tOS1adUO1LkfsMaXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/602] wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
Date: Thu, 30 Jul 2026 16:10:01 +0200
Message-ID: <20260730141440.348160970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 54567a5893449e..5730980fdc64eb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -798,6 +798,8 @@ mt7996_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1537,17 +1539,18 @@ mt7996_mcu_sta_bfer_he(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
 {
 	struct ieee80211_sta_he_cap *pc = &sta->deflink.he_cap;
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
 
 	mt7996_mcu_sta_sounding_rate(bf);
 
-- 
2.53.0



