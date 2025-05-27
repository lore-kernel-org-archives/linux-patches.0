Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6AC2CCC0;
	Tue, 27 May 2025 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364592; cv=none; b=pQPHYcHxqaocTbv3uP3DlkJrIuNL+d4y+tUVvcwvBY8Hl3uYqCBBwE0AMMyRqrHggTCur2+UdPGM2L0872+4eY7Y7N1/GC3agZVLEGsgAEUak4yZFs7zuHKJoA5f+Otu6WDNnE4SczfizYu1E89sEmuFW3nH8dmateBJ4n3DXfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364592; c=relaxed/simple;
	bh=Tr2AWLViBpbTZ4bimV6Nx2CuFx1DwoYPEb4ykzP+JXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbuhoNlIR7/skVnXOtaajVIsl3JomsS3b0pvm6ZEdBV9a3/k7UqzpObRIZUjoDyf4SY2n8SnM6BEcSt16xrbUOy+Uk2LFEb3Q9SjhQwNtYjVxGHUaHaN3U41WBRmKpK5QgpbZMasWWbWTeHVEZNIEaDIj8OlY4ZRyoDjW/eRDFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJUIH6h6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJUIH6h6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD84C4CEE9;
	Tue, 27 May 2025 16:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364592;
	bh=Tr2AWLViBpbTZ4bimV6Nx2CuFx1DwoYPEb4ykzP+JXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJUIH6h6bnRjrZj5SSC76z3g45OUw72jjmae3nE2z+fner1rzXEnB9u/naDYM6zkz
	 hwq8TM+uqKPgVg4a+QwAcXvgOYkHlweWIcoqWEZUhNWFMO17shltXqlE7utrWFA6AM
	 Pac2NNlOE4eFYqnR2zvyqPiOWLm1izY7po1Qaybo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/626] wifi: mt76: mt7925: load the appropriate CLC data based on hardware type
Date: Tue, 27 May 2025 18:19:58 +0200
Message-ID: <20250527162449.310126545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit f2027ef3f733d3f0bb7f27fa3343784058f946ab ]

Read the EEPROM to determine the hardware type and uses this to load the
correct CLC data.

Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250304113649.867387-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 61 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  3 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8476f9caa98db..5b14bf434df36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -616,6 +616,54 @@ int mt7925_mcu_uni_rx_ba(struct mt792x_dev *dev,
 	return ret;
 }
 
+static int mt7925_mcu_read_eeprom(struct mt792x_dev *dev, u32 offset, u8 *val)
+{
+	struct {
+		u8 rsv[4];
+
+		__le16 tag;
+		__le16 len;
+
+		__le32 addr;
+		__le32 valid;
+		u8 data[MT7925_EEPROM_BLOCK_SIZE];
+	} __packed req = {
+		.tag = cpu_to_le16(1),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.addr = cpu_to_le32(round_down(offset,
+				    MT7925_EEPROM_BLOCK_SIZE)),
+	};
+	struct evt {
+		u8 rsv[4];
+
+		__le16 tag;
+		__le16 len;
+
+		__le32 ver;
+		__le32 addr;
+		__le32 valid;
+		__le32 size;
+		__le32 magic_num;
+		__le32 type;
+		__le32 rsv1[4];
+		u8 data[32];
+	} __packed *res;
+	struct sk_buff *skb;
+	int ret;
+
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_WM_UNI_CMD_QUERY(EFUSE_CTRL),
+					&req, sizeof(req), true, &skb);
+	if (ret)
+		return ret;
+
+	res = (struct evt *)skb->data;
+	*val = res->data[offset % MT7925_EEPROM_BLOCK_SIZE];
+
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
 static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 {
 	const struct mt76_connac2_fw_trailer *hdr;
@@ -624,13 +672,20 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 	struct mt76_dev *mdev = &dev->mt76;
 	struct mt792x_phy *phy = &dev->phy;
 	const struct firmware *fw;
+	u8 *clc_base = NULL, hw_encap = 0;
 	int ret, i, len, offset = 0;
-	u8 *clc_base = NULL;
 
 	if (mt7925_disable_clc ||
 	    mt76_is_usb(&dev->mt76))
 		return 0;
 
+	if (mt76_is_mmio(&dev->mt76)) {
+		ret = mt7925_mcu_read_eeprom(dev, MT_EE_HW_TYPE, &hw_encap);
+		if (ret)
+			return ret;
+		hw_encap = u8_get_bits(hw_encap, MT_EE_HW_TYPE_ENCAP);
+	}
+
 	ret = request_firmware(&fw, fw_name, mdev->dev);
 	if (ret)
 		return ret;
@@ -675,6 +730,10 @@ static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
 		if (phy->clc[clc->idx])
 			continue;
 
+		/* header content sanity */
+		if (u8_get_bits(clc->type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
+			continue;
+
 		phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
 						  le32_to_cpu(clc->len),
 						  GFP_KERNEL);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index df3c705d1cb3f..4ad779329b8f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -147,9 +147,12 @@ enum mt7925_eeprom_field {
 	MT_EE_CHIP_ID =		0x000,
 	MT_EE_VERSION =		0x002,
 	MT_EE_MAC_ADDR =	0x004,
+	MT_EE_HW_TYPE =		0xa71,
 	__MT_EE_MAX =		0x9ff
 };
 
+#define MT_EE_HW_TYPE_ENCAP     GENMASK(1, 0)
+
 enum {
 	TXPWR_USER,
 	TXPWR_EEPROM,
-- 
2.39.5



