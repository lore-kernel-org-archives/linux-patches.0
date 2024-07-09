Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C2C154C07;
	Tue,  9 Jul 2024 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524647; cv=none; b=M/Fa0xM1B3uS+uOUew+O0IFJ+xN5Y/gSG1hV7XN+k3nThjOrkmW/ukXFLDcBn04LRmkeqUmaHDA3s7fdyYEEDhf2cPCDhP4nkgunHq/WBthpHgETeBJMPNsz1GGuVloq+e2st7EU5OHUcGy1wa37i1r3qogPAyIVC6FvNwpPciE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524647; c=relaxed/simple;
	bh=XvUjI7XSikJLWGjkf76Bio8a2XIM72BJWj6bAaboJnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcDW4H7ypGt4iulYkiXi8BV3T0UxbS5xWs1fgZpP8pgvMGpDXY26SgXKyaTiDTpvXmbmw9KKgR4Esn9uE15FXzO9VR8IYGQNVCHd9AEtnLZHLu08+PGKh4HcaFugfbDfrI8vq34MyXxuCLGVo20GBeOjHBBjHiJHfbSJx9kgTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcjcgnWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcjcgnWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3595BC3277B;
	Tue,  9 Jul 2024 11:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524647;
	bh=XvUjI7XSikJLWGjkf76Bio8a2XIM72BJWj6bAaboJnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcjcgnWOgCAbGjMckdZdFgqC0yTr1vnv3TC0NHy9mu1FlZrsYwRgeSfkvV1kMB26y
	 n9T3kZFUAzIkUOpF82eAFoSuIcTzIvDja8ne1DbmbNu4TtVpWbj5ODR/dvhq+2VB2x
	 l7g3rmAq6TwppgQSj1jUI03wKfFJi1Co0DKT/EaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/102] wifi: mt76: replace skb_put with skb_put_zero
Date: Tue,  9 Jul 2024 13:09:45 +0200
Message-ID: <20240709110652.232740476@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7f819a2f4fbc510e088b49c79addcf1734503578 ]

Avoid potentially reusing uninitialized data

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 10 +++++-----
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c      |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 546cbe21aab31..6b5bfdbec8b11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -254,7 +254,7 @@ mt76_connac_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
 	};
 	u16 ntlv;
 
-	ptlv = skb_put(skb, len);
+	ptlv = skb_put_zero(skb, len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	ntlv = le16_to_cpu(ntlv_hdr->tlv_num);
@@ -1532,7 +1532,7 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	set_bit(MT76_HW_SCANNING, &phy->state);
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_hw_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_hw_scan_req *)skb_put_zero(skb, sizeof(*req));
 
 	req->seq_num = mvif->scan_seq_num | mvif->band_idx << 7;
 	req->bss_idx = mvif->idx;
@@ -1660,7 +1660,7 @@ int mt76_connac_mcu_sched_scan_req(struct mt76_phy *phy,
 
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_sched_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_sched_scan_req *)skb_put_zero(skb, sizeof(*req));
 	req->version = 1;
 	req->seq_num = mvif->scan_seq_num | mvif->band_idx << 7;
 
@@ -2294,7 +2294,7 @@ int mt76_connac_mcu_update_gtk_rekey(struct ieee80211_hw *hw,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put(skb,
+	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put_zero(skb,
 							 sizeof(*gtk_tlv));
 	gtk_tlv->tag = cpu_to_le16(UNI_OFFLOAD_OFFLOAD_GTK_REKEY);
 	gtk_tlv->len = cpu_to_le16(sizeof(*gtk_tlv));
@@ -2417,7 +2417,7 @@ mt76_connac_mcu_set_wow_pattern(struct mt76_dev *dev,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put(skb, sizeof(*ptlv));
+	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put_zero(skb, sizeof(*ptlv));
 	ptlv->tag = cpu_to_le16(UNI_SUSPEND_WOW_PATTERN);
 	ptlv->len = cpu_to_le16(sizeof(*ptlv));
 	ptlv->data_len = pattern->pattern_len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index b2ea539f697f7..65f07cc2acdd4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -395,7 +395,7 @@ mt7915_mcu_add_nested_subtlv(struct sk_buff *skb, int sub_tag, int sub_len,
 		.len = cpu_to_le16(sub_len),
 	};
 
-	ptlv = skb_put(skb, sub_len);
+	ptlv = skb_put_zero(skb, sub_len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	le16_add_cpu(sub_ntlv, 1);
-- 
2.43.0



