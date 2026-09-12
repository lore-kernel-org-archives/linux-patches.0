Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02D937CD32;
	Sat, 12 Sep 2026 08:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200938; cv=none; b=TM2yxq2Mfu9yVxdrZJyZYuH41jRBTF2l/EeJ9P9jwOWdLe0cbJenQ24u/VytmvYcFj+usYMcewWWEZszHBOTkuXcu+5o6CdQeI/J4m4PCSTkgdo3YCj/bwkAFq4AHV5+J1wm8Gtppcv0i73E5EhEfXIOl5/VQ9K38cVV9MKc7ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200938; c=relaxed/simple;
	bh=CqHhm2eSUyH4UaDozfkBPnYK9bFOoGL9Cg44hUIGgGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZqShZ3TuauiEUxvoGvGJkOggxmBd5mbJ2N2zWIFPy2DPFfcLD0cS8QNSM/o5NkPxXaXqv25iWcNYI8pYGh3a9yVjlxDYRREwBMUfM7DKUFIMBasweqfSxvmc1S512aIApKo/bp3hLrDJ84vuwkZSwLZS/kSvQUdWk8FxCaauRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxUcgYKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxUcgYKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16D71F000FF;
	Sat, 12 Sep 2026 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200936;
	bh=b+7JFX1BJGihTI2fqxOAAyGpkzb492cV2+dG0C37IPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxUcgYKI72IeMAW8nuNDSAo2zGCXXEqqUceQ8nZZyOUasspRKkWjmKlW213maFB1w
	 AZKGmR4P7OmKCoh3fSGAs5nmqfpnKJOsR6dwzAy6h2SzW2yMA4EkL3VEx9QyJFHKU2
	 JGPvt1rFsxWaO/cW5m3K8Y/YiWI/DhT78QtLr1NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0893/1815] wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
Date: Sat, 12 Sep 2026 08:44:03 +0200
Message-ID: <20260912065709.884328776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a1bae5db85007..f57d4a28cc272 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4445,21 +4445,31 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
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



