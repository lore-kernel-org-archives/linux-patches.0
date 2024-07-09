Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5221F15884A;
	Tue,  9 Jul 2024 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524029; cv=none; b=EFNyH4osarFzLLwnpbQxjQa3GIgPMS7Sh4d0NTMW5eRmu/bpnH5omtEAfiRH3g8KRIcxsELzcZ+tQrmHhk84+o/0sq5nZwBZ4Wuy1v8Y/VfXa1qllMVitOkfD7icZoXwRXLv8Rhcy2VaCHHeSsHFMkPnm5wiifDLd2FfPQ7Ac6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524029; c=relaxed/simple;
	bh=ZwOIjZnF6vsE6VBSYCa8sc69TGjj0/5cIpjwMtlAbxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyQ6rmDXxE/nuXsAS/VT4DpvWaCFmOOjUVShrfXDln3fj3w6ozq8+++v3c9Rf4G7c/TEN+4KOIsLNl2SutJE/boSpOaLdivt8+at9bN+i9kI9zQtKxNbBaGnZa0yU+/3BWj4Q56nlk1jyt2BlwEGNlFTRF0h0VN7BW0n9e3zlcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WurX3wcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WurX3wcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC556C3277B;
	Tue,  9 Jul 2024 11:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524029;
	bh=ZwOIjZnF6vsE6VBSYCa8sc69TGjj0/5cIpjwMtlAbxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WurX3wcyF5oy475jYTNL+vB/42X0IQwBxoEoS1xFhO79VFL3NB10ume4aMNnLo2+Y
	 ZM5Re3ebkvf19hmBcWgmLl0QDmA9umIMjT60HdIjyzd1Bz3uS5j2w5C4uzkdLDBqoY
	 yZpXuYkwvvxYDZBbTffr6tvFryRodCwTaa2V7iJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/197] wifi: mt76: replace skb_put with skb_put_zero
Date: Tue,  9 Jul 2024 13:08:21 +0200
Message-ID: <20240709110710.784244774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index fb8bd50eb7de8..5521c0ea5b261 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -257,7 +257,7 @@ mt76_connac_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
 	};
 	u16 ntlv;
 
-	ptlv = skb_put(skb, len);
+	ptlv = skb_put_zero(skb, len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	ntlv = le16_to_cpu(ntlv_hdr->tlv_num);
@@ -1670,7 +1670,7 @@ int mt76_connac_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	set_bit(MT76_HW_SCANNING, &phy->state);
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_hw_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_hw_scan_req *)skb_put_zero(skb, sizeof(*req));
 
 	req->seq_num = mvif->scan_seq_num | mvif->band_idx << 7;
 	req->bss_idx = mvif->idx;
@@ -1798,7 +1798,7 @@ int mt76_connac_mcu_sched_scan_req(struct mt76_phy *phy,
 
 	mvif->scan_seq_num = (mvif->scan_seq_num + 1) & 0x7f;
 
-	req = (struct mt76_connac_sched_scan_req *)skb_put(skb, sizeof(*req));
+	req = (struct mt76_connac_sched_scan_req *)skb_put_zero(skb, sizeof(*req));
 	req->version = 1;
 	req->seq_num = mvif->scan_seq_num | mvif->band_idx << 7;
 
@@ -2321,7 +2321,7 @@ int mt76_connac_mcu_update_gtk_rekey(struct ieee80211_hw *hw,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put(skb,
+	gtk_tlv = (struct mt76_connac_gtk_rekey_tlv *)skb_put_zero(skb,
 							 sizeof(*gtk_tlv));
 	gtk_tlv->tag = cpu_to_le16(UNI_OFFLOAD_OFFLOAD_GTK_REKEY);
 	gtk_tlv->len = cpu_to_le16(sizeof(*gtk_tlv));
@@ -2446,7 +2446,7 @@ mt76_connac_mcu_set_wow_pattern(struct mt76_dev *dev,
 		return -ENOMEM;
 
 	skb_put_data(skb, &hdr, sizeof(hdr));
-	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put(skb, sizeof(*ptlv));
+	ptlv = (struct mt76_connac_wow_pattern_tlv *)skb_put_zero(skb, sizeof(*ptlv));
 	ptlv->tag = cpu_to_le16(UNI_SUSPEND_WOW_PATTERN);
 	ptlv->len = cpu_to_le16(sizeof(*ptlv));
 	ptlv->data_len = pattern->pattern_len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index d90f98c500399..b7157bdb3103f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -424,7 +424,7 @@ mt7915_mcu_add_nested_subtlv(struct sk_buff *skb, int sub_tag, int sub_len,
 		.len = cpu_to_le16(sub_len),
 	};
 
-	ptlv = skb_put(skb, sub_len);
+	ptlv = skb_put_zero(skb, sub_len);
 	memcpy(ptlv, &tlv, sizeof(tlv));
 
 	le16_add_cpu(sub_ntlv, 1);
-- 
2.43.0



