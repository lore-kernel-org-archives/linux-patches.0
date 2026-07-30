Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B644AB81;
	Thu, 30 Jul 2026 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427455; cv=none; b=qmbBUr/4ai8Yzq58OYN29hvo/6BtWm6JmrxVu9t8leNCYH1hihdBxi8Yz0bOoNK60n0Q4aXRnqD5OXlfx/t+J3Oe8bI0L8FLO2U54wVsHZZNF/4hWHf2j9aoSZnjIxFGW9h8V11vJh6vycz6m1zMQt3fagrn7i5Mfq4cv55/9LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427455; c=relaxed/simple;
	bh=eUdihRF1NrJqbYZ/bA9smj8w5V648Mt25Zwoikkroew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxydmqmpOH6Ym3WnhKcSw2AKfJZV3vPHCvk/sPs+g4oIUSO8RX4tpvvHFVcw23djKEJtOUyeCMk9t89jcyBmwB6OreLJE3/PLnotZU+9a1aMhmjc21PdBbFgXJ49sVvpbGowrdYw7Ng5yvJCPPis4CVrywWrUN1JxPs2Sx18bWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wax72E5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wax72E5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480F81F00A3D;
	Thu, 30 Jul 2026 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427453;
	bh=lqIQhCc7LmnKg9xMBb7ZDYoZ+VMoAX3gFfPgLY91rzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wax72E5XDVSJPZ7yUBH3c9nykdww3lHqVRMBzaIvljS4fipafa0KnWPRl7swk9Z1X
	 N8oyH4pctQLCvRSGsxb4FQyn/p7VoyE4oCmi34qihbbDdPqt8iD+vfkoryJdenJcqt
	 yT96Q0S+/xsNkG5GSJa2I8XQ9KBXg5uir5O/GsmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/484] wifi: mt76: mt7915: guard HE capability lookups
Date: Thu, 30 Jul 2026 16:11:11 +0200
Message-ID: <20260730141427.248171621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f826089396e489..9ac95f14fdaf9f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -545,6 +545,8 @@ mt7915_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt76_connac_mcu_add_tlv(skb, BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1125,13 +1127,12 @@ mt7915_mcu_sta_bfer_vht(struct ieee80211_sta *sta, struct mt7915_phy *phy,
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
@@ -1190,6 +1191,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
 {
 	struct mt7915_vif *mvif = (struct mt7915_vif *)vif->drv_priv;
 	struct mt7915_phy *phy = mvif->phy;
+	const struct ieee80211_sta_he_cap *vc = NULL;
 	int tx_ant = hweight8(phy->mt76->chainmask) - 1;
 	struct sta_rec_bf *bf;
 	struct tlv *tlv;
@@ -1208,6 +1210,12 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
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
 
@@ -1216,7 +1224,7 @@ mt7915_mcu_sta_bfer_tlv(struct mt7915_dev *dev, struct sk_buff *skb,
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



