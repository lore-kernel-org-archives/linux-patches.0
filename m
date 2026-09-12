Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C82419FC9;
	Sat, 12 Sep 2026 10:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209118; cv=none; b=kWxts03G/YySrk1yOdJcTGBhltnQI0OH/9JESfgueAOyv5zw4J+9RdEGmWE8OGfqmP6gZFtKxSdEjTSSogJOHS5pL2em/7ntjZr1J3+i4Ue5WoVqO2BtLG2MmKBc181l3cacQQJ0KMqr5FLGqKG/T9Dp1GzAEjd7lEr7t3bKKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209118; c=relaxed/simple;
	bh=2WplxitdqFv5brsr+GnGaK7O91mA6E9yg7vLEPiH7CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfzGL3r21vXTOiCQf/KqK7gC1XLzioKs2Tbp0LaV2qblSYKTIzBx/5aleVSGliomeHcQWh2FFtMzpl4Ao0yEhgUxshDiClXH1PFuWDwaeH3ucg/5OwnPd96ueAPhRQ5zqxFtc5A2HZx/fEadkOTR5QriP6fT0XW4P1DwHFbwebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTN0RS1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTN0RS1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB171F000FF;
	Sat, 12 Sep 2026 10:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209117;
	bh=gdHn39kiRTigR9uHy86sfcCI4utKzRD9IykSONvIhI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sTN0RS1koaecI/ZJaSOYbLH5VO0Xp+ymcV7ncTYJz4X/Xy/x6PSV7EE0YKwW5SBTL
	 s4SF9kDdRFplNQze5llSd7f/0yN345rWsnhDKY8xW7BCuoLSfQ7yW7OGjNQ78x6C6m
	 ffugQ2UcLY6SSvPEMe+WXcyWxjtBfjNxmE93tQxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0756/1518] wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
Date: Sat, 12 Sep 2026 08:48:45 +0200
Message-ID: <20260912065640.531222950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 44af52467e72094351a362bf69effd52f1d9c186 ]

The response TLV loop advanced by tlv->len without a minimum, so a
theoretical firmware response containing a zero-length TLV could spin
forever, hanging the CPU during device probe.
The u32 payload was also read without bounds checking.
Reject a short fixed field, stop on a TLV whose length underruns the
header or overruns the skb.

Fixes: 5d33053be609 ("wifi: mt76: mt7996: add variants support")
Link: https://patch.msgid.link/20260724124813.3961474-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 5df5c3a2121f5..95c2a2a5f5bcf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4001,21 +4001,31 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
 		return ret;
 
 	/* fixed field */
+	if (skb->len < 4) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 	skb_pull(skb, 4);
 
 	buf = skb->data;
-	while (buf - skb->data < skb->len) {
+	while (buf - skb->data + sizeof(struct tlv) <= skb->len) {
 		struct tlv *tlv = (struct tlv *)buf;
+		u16 tlv_len = le16_to_cpu(tlv->len);
+
+		if (tlv_len < sizeof(*tlv) ||
+		    tlv_len > skb->len - (buf - skb->data))
+			break;
 
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_CHIP_CONFIG_EFUSE_VERSION:
-			*cap = le32_to_cpu(*(__le32 *)(buf + sizeof(*tlv)));
+			if (tlv_len >= sizeof(*tlv) + sizeof(__le32))
+				*cap = le32_to_cpu(*(__le32 *)(buf + sizeof(*tlv)));
 			break;
 		default:
 			break;
 		}
 
-		buf += le16_to_cpu(tlv->len);
+		buf += tlv_len;
 	}
 
 	dev_kfree_skb(skb);
-- 
2.53.0



