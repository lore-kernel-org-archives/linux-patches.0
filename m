Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD2E39EF05;
	Mon, 17 Aug 2026 15:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979204; cv=none; b=ANyV+RVeEDb/VrI8Iq6Fzpum5OyXjTzE7Q+9Bug9YztKo48+8l7l6y1qtdvGQ6qz580GLRMQfYLmRbqUEJ6IDBLRCaqi5cbpQqOQlIELFXKsO3qw1ycBq8445Itjoz24hispTVadbt+L2F78FVVDpOXA51H5kAtWXptRnCmSC3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979204; c=relaxed/simple;
	bh=9HJOZYJ1i03rPAEUB7k8n3TwrsAjquegwrY+CKkExLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnIeEEfobWTGtuBalyFfOC+VW1f64ZPdMgkUwYu1ay9UEeiGfo4kLoTw7m1JdQ/fa6DdzK8SWwMpvfO+dWPUzMFrJMaf6ofAhQZHFu8Q0FoWl/QuTJTqvomN5kzLjK86R4kQAyWRRBiDKyLUO43hg1XeRfOg7E01sIU4CmgneWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kldu1hnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kldu1hnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C518C1F000E9;
	Mon, 17 Aug 2026 15:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979203;
	bh=77Ef5qB7tAl6lgMvMGYtfUuEbvYp1DTY4DBnaVfhHE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kldu1hnhWp9p7xUdC/OMUk0zpXaqb4bg/vbgNgXGmOmqHFW54p2QCxyuwSZpM8rbn
	 nirIFe9i8QrtvgbY0HVDcwW/828GjxhrZNTgzG5ZMaQa5hsLCHfVi/9Q7pLnqA6msJ
	 dfPE4NdnvasrBtMhE/8x0axB6E0XjRwOVpyDUPMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/609] wifi: mt76: mt7915: guard HE capability lookups
Date: Mon, 17 Aug 2026 15:27:19 +0200
Message-ID: <20260817132548.787480038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 8e9db062654a388d0fa587acbeeae68dd33eba41 ]

mt7915_mcu_bss_he_tlv() and mt7915_mcu_sta_bfer_tlv() both run after
checking HE support, then dereference the HE PHY capability returned by
mt76_connac_get_he_phy_cap(). That helper can return NULL when no
capability entry matches the vif type.

Fetch the capability before appending the TLV and skip the HE-specific
setup when no matching capability is available.

Fixes: e6d557a78b60 ("mt76: mt7915: rely on mt76_connac_get_phy utilities")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260620155332.81120-1-ruoyuw560@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 44fbfe3775e060..777ae8206df0ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -518,6 +518,8 @@ mt7915_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1098,13 +1100,12 @@ mt7915_mcu_sta_bfer_vht(struct ieee80211_sta *sta, struct mt7915_phy *phy,
 }
 
 static void
-mt7915_mcu_sta_bfer_he(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
-		       struct mt7915_phy *phy, struct sta_rec_bf *bf)
+mt7915_mcu_sta_bfer_he(struct ieee80211_sta *sta,
+		       const struct ieee80211_sta_he_cap *vc,
+		       struct sta_rec_bf *bf)
 {
 	struct ieee80211_sta_he_cap *pc = &sta->deflink.he_cap;
 	struct ieee80211_he_cap_elem *pe = &pc->he_cap_elem;
-	const struct ieee80211_sta_he_cap *vc =
-		mt76_connac_get_he_phy_cap(phy->mt76, vif);
 	const struct ieee80211_he_cap_elem *ve = &vc->he_cap_elem;
 	u16 mcs_map = le16_to_cpu(pc->he_mcs_nss_supp.rx_mcs_80);
 	u8 nss_mcs = mt7915_mcu_get_sta_nss(mcs_map);
@@ -1163,6 +1164,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 {
 	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
 	struct mt7915_phy *phy = mvif->phy;
+	const struct ieee80211_sta_he_cap *vc = NULL;
 	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
@@ -1181,6 +1183,12 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 	if (!ebf && !dev->ibf)
 		return;
 
+	if (sta->deflink.he_cap.has_he && ebf) {
+		vc = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+		if (!vc)
+			return;
+	}
+
 	tlv = mt76_connac_mcu_add_tlv(skb, STA_REC_BF, sizeof(*bf));
 	bf = (struct sta_rec_bf *)tlv;
 
@@ -1189,7 +1197,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 	 * ht: iBF only, since mac80211 lacks of eBF support
 	 */
 	if (sta->deflink.he_cap.has_he && ebf)
-		mt7915_mcu_sta_bfer_he(sta, vif, phy, bf);
+		mt7915_mcu_sta_bfer_he(sta, vc, bf);
 	else if (sta->deflink.vht_cap.vht_supported)
 		mt7915_mcu_sta_bfer_vht(sta, phy, bf, ebf);
 	else if (sta->deflink.ht_cap.ht_supported)
-- 
2.53.0



