Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF48637F31F;
	Sat, 12 Sep 2026 12:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216839; cv=none; b=nPVFwuUeWruYPDBNa4VuY0gnBUvw5HgzKdRDpw7FvJ2KzX/CQOYkwA8cPQfnXeAxcH24XWzAYaRO6cM63wUayPz9rwc5AahJQdpLH/Y+pUY+xZR7HvEQLMLDGpcDoHhOdl8K+GleAxf9hQcsZuZffrg808hzNukdErbVkD4Pk1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216839; c=relaxed/simple;
	bh=l/PQr5tBdB9s4zbFbb1fEvwBG0FioPtLU6rqWDhrtB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3035Beh8x+XPoASWp5V2SHF9tC+8bE+ZTwa8zsX0isvjb8encdC2LUMCwBj/+1azkPqjUH8jxY3maz+yUvpG95k9N57LdjEoOlZgXoDmPe6jEw/UUlGxCyjXMASKeB2UTLStnf0yIwHrvx6Iqlj3ZDeNHoboJ+ljnSVEvKupyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4AA1S+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4AA1S+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE161F000FF;
	Sat, 12 Sep 2026 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216837;
	bh=EVd1c4i5bLhkgtteY5BJctUt5N17Rvs7jN3HxTFRt4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4AA1S+A+8Kz1Xn0m5AYyk0d7bdgsntSKhBJ/sWrh1BPhTf8NsruyW5kpbT4NJ8Ut
	 lIG/ap74bYJN+Km4+Pd6f9Vs1VZNcNuQMPuYNZc9/WPpyO/dbIp1WJ7RKAnlAJM3He
	 WxXGbk3YrBfvJl2ED4VQbXSOY/d57Ft7CftEkMoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0817/1376] wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
Date: Sat, 12 Sep 2026 08:54:03 +0200
Message-ID: <20260912065625.751878940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5693efee74b8..e3f5b2b2e3674 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3651,21 +3651,31 @@ int mt7996_mcu_get_chip_config(struct mt7996_dev *dev, u32 *cap)
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



