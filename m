Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384CD1DDCE;
	Tue, 16 Jul 2024 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145965; cv=none; b=ZUF/XIq+6quKMpbhQsXyHcqe2d90TsSn6nLkjnLBM/9FulF/FaoKGMiqIbM4Y3JDDw4Kj6aM4hBOR+BlLkHXdL7DBDdumwBKlDin5cL9O/G+SvXwvlKlAzHaJ/kbk1elZLrKrAKvimT+NH2hFIc8b8Nju0Lolg6rmIafMzSLlVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145965; c=relaxed/simple;
	bh=qoJ0rG1othCcS5ttfHp8AnKPk/G1+pVdoUgiuexWhkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoMOqxKv9I0TOB/PWn0LW6ErqD9l8REDsfTl5e0C4tyri+axfqZpeIkZNI5NQiqir9h9NfqX7D4MugkRK4PeqEtyFTY04KNhZlOn+59/cniFf95gNECbw4i2BzBtmh8A90Qcs9WGhPwj+IrmJnXRzLehMo+EslrrWCgKyHMgFcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6vulPb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6vulPb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A86C116B1;
	Tue, 16 Jul 2024 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145965;
	bh=qoJ0rG1othCcS5ttfHp8AnKPk/G1+pVdoUgiuexWhkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6vulPb9eaid689enwIY2LGVxeTeSPpb+I5qFiI06TDNmDgKfQlDIvTHVstsjSfa7
	 73tjOSzkLSVnu+upap/dehgbUV7Uy92tnVbYawg9+9Oayoe4LjLOEfgiNHU9tJcpgE
	 NV3yH99J+lYICfv/bLOaj+GFeNE63klnFATPMaMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/144] wifi: mt76: replace skb_put with skb_put_zero
Date: Tue, 16 Jul 2024 17:31:25 +0200
Message-ID: <20240716152753.158401239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 98f651fec3bf3..a5dda20f39f3a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -234,7 +234,7 @@ mt76_connac_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
 	};
 	u16 ntlv;
 
-	ptlv = skb_put(skb, len);
+	ptlv = skb_put_zero(skb, len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	ntlv = le16_to_cpu(ntlv_hdr->tlv_num);
@@ -1417,7 +1417,7 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	set_bit(MT76_HW_SCANNING, &phy->state);
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_hw_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_hw_scan_req *)skb_put_zero(skb, sizeof(*req));
 
 	req->seq_num = mvif->scan_seq_num | ext_phy << 7;
 	req->bss_idx = mvif->idx;
@@ -1535,7 +1535,7 @@ int mt76_connac_mcu_sched_scan_req(struct mt76_phy *phy,
 
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_sched_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_sched_scan_req *)skb_put_zero(skb, sizeof(*req));
 	req->version = 1;
 	req->seq_num = mvif->scan_seq_num | ext_phy << 7;
 
@@ -1985,7 +1985,7 @@ int mt76_connac_mcu_update_gtk_rekey(struct ieee80211_hw *hw,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put(skb,
+	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put_zero(skb,
 							 sizeof(*gtk_tlv));
 	gtk_tlv->tag = cpu_to_le16(UNI_OFFLOAD_OFFLOAD_GTK_REKEY);
 	gtk_tlv->len = cpu_to_le16(sizeof(*gtk_tlv));
@@ -2107,7 +2107,7 @@ mt76_connac_mcu_set_wow_pattern(struct mt76_dev *dev,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put(skb, sizeof(*ptlv));
+	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put_zero(skb, sizeof(*ptlv));
 	ptlv->tag = cpu_to_le16(UNI_SUSPEND_WOW_PATTERN);
 	ptlv->len = cpu_to_le16(sizeof(*ptlv));
 	ptlv->data_len = pattern->pattern_len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 1c900454cf58c..169055261e9b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -804,7 +804,7 @@ mt7915_mcu_add_nested_subtlv(struct sk_buff *skb, int sub_tag, int sub_len,
 		.len = cpu_to_le16(sub_len),
 	};
 
-	ptlv = skb_put(skb, sub_len);
+	ptlv = skb_put_zero(skb, sub_len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	le16_add_cpu(sub_ntlv, 1);
-- 
2.43.0



