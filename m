Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537046AA8C;
	Tue, 21 Jul 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649470; cv=none; b=VyeVfnnDh7DFe9arPFVnjUdse4AcF5ahki+/Qf+wWqqkOA12NcDFAB0T+ISganPGTv3OX0GtCSkGlwvw9GT8d1qTaLVIT0n6F/u2Visg9RGRgiZk9arHmyzK6Fl9p1RpG4qLv0KbbJujECeyAWMFPqUhDodr2CjCTm0cGngO4II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649470; c=relaxed/simple;
	bh=fJiPDf/mFmdMQ+iUcsRXTPRyNArSmNku0me62Hoh9Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeZ+fEAKSpUVuSdJ0Q1FVkJdc0KFAUAkwciH3LHXCHC99uwh/vkb+Ebvk6l613IupaKqW5B0UcepRlYPLz+SWu6Zv1t5GyQMW80QU3vDadTV1IfxLN5nScZML3hGREb/tEAsEaFdwdOqmwuMqkYYNAIMcfPWL0q7StKmkZ4le5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgrOK3OE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgrOK3OE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8081F000E9;
	Tue, 21 Jul 2026 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649469;
	bh=l+vpCnkyQeommPpVNP9ZUBRTmiodkWwQmgx29D3+bxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgrOK3OEkaJHOd4IoLaXvom6PYWUjwUsCfz9Vgpo1x3fgmmJPdWY0I93mD7MQ4xAk
	 RKfkSLQUuT67GU2ntqn3qM1XBo1lgD9cw+/x8Q7B+EnX8OT/Qm6oee1IaSHzNcTLKC
	 0P17nNwv/yMA3fa51aMVT2h5gUfHux/ulwT20xus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0588/2077] wifi: mt76: mt7996: Fix possible NULL pointer dereference in mt7996_mac_write_txwi_80211()
Date: Tue, 21 Jul 2026 17:04:21 +0200
Message-ID: <20260721152606.680015471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09df505ee5a77e..7533146b772b35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -757,6 +757,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	bool multicast = is_multicast_ether_addr(hdr->addr1);
 	u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 	__le16 fc = hdr->frame_control, sc = hdr->seq_ctrl;
+	struct ieee80211_vif *vif = info->control.vif;
 	u16 seqno = le16_to_cpu(sc);
 	bool hw_bigtk = false;
 	u8 fc_type, fc_stype;
@@ -819,7 +820,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 		txwi[3] |= cpu_to_le32(MT_TXD3_REM_TX_COUNT);
 	}
 
-	if (multicast && ieee80211_vif_is_mld(info->control.vif)) {
+	if (multicast && vif && ieee80211_vif_is_mld(vif)) {
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
@@ -839,12 +840,12 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
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



