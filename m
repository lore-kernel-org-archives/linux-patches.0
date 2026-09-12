Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29991221FD4;
	Sat, 12 Sep 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224359; cv=none; b=Rsmgpf64GYBoGXZc+4ZwjJxKCJYNeXh8gm97Z+RET4U71tlLOr8H/m1TFS6Dqu2ysf9k7syLlQyEveGS+wbtowmzG67MlO0BRcmTB+xhm6KQvRc0oBe8DMbb8eS8TDX1O2meJXectnZgoA+LTVVQw8WcHmVkOG49zpaDpmEiA+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224359; c=relaxed/simple;
	bh=m41w4o91hiN0w5ONPU/d1LbA+cM2ekBBskYTBRZVg1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZ69KDvxDw31HAF6z222QpMPp8+hUI8RzvhDmGdnAwL5Dsgg5PclBH4t142Bjt8ARxCmjQ+gNxL1g2kCSOefvs1qX17W2Z0OXQi8tRNW/3n++cqcQPVpBL2Wg8X7n7kfeXbIlHFTxw1TQe4Vb+fCeSw+o5uD0oCmIZLYpyZQ7Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyPlMVOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyPlMVOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24BB1F000FF;
	Sat, 12 Sep 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224358;
	bh=G9cDsFaLEPEJ/EcJXPE+I+9BayMbBGGq5YKK/Nt/fxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyPlMVOcjKGwBoLhmwuV5L7EWGATjKon7oth3M7dyFrHF9m7wAInDDprQdfMhiiHU
	 ztY6UBQMZypgcd89oqHksFp4S2+9Laz+agV3OljSIHHg8YJIUMVYTgjeNfHV90ZeFd
	 iaerSTLvsuQe/EwwC0sb3P6bSxhHLwEPiWAuMYXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0977/1424] wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
Date: Sat, 12 Sep 2026 08:56:49 +0200
Message-ID: <20260912065629.194634079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 2abc8d15ea852..3699a43df5a9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3172,21 +3172,31 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
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



