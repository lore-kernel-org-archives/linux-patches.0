Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62C2449B2A;
	Thu, 30 Jul 2026 16:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427460; cv=none; b=tPXt93982OrK1HnqFdXFPWyXRumTjz7pC7XiWdwH8S8RoFv3N681di2/ciyxODEaz98oGvmhj1V54akTdKR42TIzXKkx/H7M8/I1aCoHpelnmg6Fw6t4pD3hPGSCPprhlKPRIHux/ioso0uxdN9og5SKwD3FwrwwhUEgYYPnr8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427460; c=relaxed/simple;
	bh=yvSK7oE3vSjZwBnusN5lRFRt/QfjGJz5e/vfq7bEzGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U324e/Id0Il4h4F/TcBzFNQlFQHmXMx/CfVOjVwNqTTe5lsp/2H0Y7FkiyJsZ6wfSGSVcSXxuWz7vUfdfKpMwv6D2JUEulK7J1oEJ1lvRueVHh9vhItltYu0wRREepnkKhJsj0+r7X//0AuKRUeWEFl6dmfkvYzpYmHOytuqHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDbq6FlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDbq6FlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8481F000E9;
	Thu, 30 Jul 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427459;
	bh=G60PBEkQ6ynr+kDS71oHNhOTWq1ExsselvRJgFll9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDbq6FlHEDIbncSTlor3ZFJiSKxyLiAzhO4bIQei5wlAvJxO/knZbc9zLsp1VSx/8
	 KE+BoYgmPm/MvUOtKsD9OnyYNpRdOFOWRmgiAsuk89v8CljYoWuF45xOJRcPQ8A+e7
	 /ePo+AfNzQe70TrJXm3ixecjFLEwaHL//Y7rFGFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/484] wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
Date: Thu, 30 Jul 2026 16:11:13 +0200
Message-ID: <20260730141427.291844579@linuxfoundation.org>
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
index 9f8c312b64d75c..ccbd9b9c409d82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -583,6 +583,8 @@ mt7996_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1293,17 +1295,18 @@ mt7996_mcu_sta_bfer_he(struct ieee80211_sta *sta, struct ieee80211_vif *vif,
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



