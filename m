Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4662747126F;
	Tue, 21 Jul 2026 17:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656496; cv=none; b=dF5nq5h/YJwdv+1BmzzLWEpmuhNXZ3c33DGr8OyxbM1wGmoInoPKMeEjuFZMXgtSb2YonYCFnWPzoAM/XbygVBM0lDjT3jfP/6dI7Ah7ZB6WzcVSgew119cTNXEQi0l0FgMvfQAje4u87UP5M9cuklu9GyDXuXf1htHrIPLL+WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656496; c=relaxed/simple;
	bh=IWL4AYEOdedMZ70/Z/+IZT37Bf5+nPHwfocBlC2NH28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suUKbG+Jmw0yNFvAIGlFl3s+fEKiDxQ1nANmfMNW/UY60JoRqDA7HR4frYtqO5Z9+9KSUXR7vbyI0BV/ryghiRlvWxoe0Sb+kDlORZxgAKrrmcBsN6jdCFR59EDWIkIh0Mn90iPLhZ6IVsFI7NKGHQlcNVOP7yaa/knhjg74p4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZNeuWHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZNeuWHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC56F1F000E9;
	Tue, 21 Jul 2026 17:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656495;
	bh=GYU7qdianG+8BGsxnAfroDoAwNERTktAllIQ6XK+lWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dZNeuWHmZ7zOdBQfjBzozrq7RTPmhI9xqB7dlj8yPozj3AOKC6aNnTTheQoWUxAMF
	 dtqNJAkFL3tTKn/4r3H0Z7i1llIN3ea8oilKyP8jwAJ+VsVdqctP6Pr56zB18DRzhP
	 3XNGNzCsTtL2+ZVYIL4bYEVIK72WCDMe72yb73AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0408/1611] wifi: mt76: mt7996: Fix possible NULL pointer dereference in mt7996_mac_write_txwi_80211()
Date: Tue, 21 Jul 2026 17:08:44 +0200
Message-ID: <20260721152524.424959936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 61370e6674b5253de5686813ceeceebc35a7d3e5 ]

For injected frames (e.g. via radiotap), mac80211 can pass
info->control.vif = NULL, as explicitly noted in struct ieee80211_tx_info.
Check vif pointer before executing ieee80211_vif_is_mld() in
mt7996_mac_write_txwi_80211 routine in order to avoid a possible NULL
pointer dereference.

Fixes: f0b0b239b8f36 ("wifi: mt76: mt7996: rework mt7996_mac_write_txwi() for MLO support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260531-mt7996_mac_write_txwi_80211-null-ptr-deref-v1-1-6dd38e1d3422@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 989cf23f11142a..907e312562ab73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -796,6 +796,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	bool multicast = is_multicast_ether_addr(hdr->addr1);
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	__le16 fc = hdr->frame_control, sc = hdr->seq_ctrl;
+	struct ieee80211_vif *vif = info->control.vif;
 	u16 seqno = le16_to_cpu(sc);
 	bool hw_bigtk = false;
 	u8 fc_type, fc_stype;
@@ -858,7 +859,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 		txwi[3] |= cpu_to_le32(MT_TXD3_REM_TX_COUNT);
 	}
 
-	if (multicast && ieee80211_vif_is_mld(info->control.vif)) {
+	if (multicast && vif && ieee80211_vif_is_mld(vif)) {
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
@@ -878,12 +879,12 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 		txwi[3] &= ~cpu_to_le32(MT_TXD3_HW_AMSDU);
 	}
 
-	if (ieee80211_vif_is_mld(info->control.vif) &&
+	if (vif && ieee80211_vif_is_mld(vif) &&
 	    (multicast || unlikely(skb->protocol == cpu_to_be16(ETH_P_PAE))))
 		txwi[5] |= cpu_to_le32(MT_TXD5_FL);
 
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_a4(fc) &&
-	    ieee80211_vif_is_mld(info->control.vif)) {
+	    vif && ieee80211_vif_is_mld(vif)) {
 		txwi[5] |= cpu_to_le32(MT_TXD5_FL);
 		txwi[6] |= cpu_to_le32(MT_TXD6_DIS_MAT);
 	}
-- 
2.53.0



