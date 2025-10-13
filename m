Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9E025784F;
	Mon, 13 Oct 2025 15:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368496; cv=none; b=eLyEhjf1n9OmIpVW6WrFafpx81fPUF25zOHpOtRxdBeM3jyHG07fe2FNupSOWH511Dm0O2+TV20RRdRFLfDnQuwtsSs2R9XdBxQJ/9XOreO1A0gHx+VXUfV2vJ+8SLwbcxmJugDswfEWyiIfrVCOy8i+R0ZaG/5+stVccuyRGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368496; c=relaxed/simple;
	bh=sZUCb8oTRc87XteldyDzXsITG3PmFNcp04t4xV6IGU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR7e3L7iFoVbe8sDNVUsqudxEVzbR/g82wRF+v/W6TMXnXgypMcqS1pWWwCaLdiv1rb0k+kD/1u66KUFQwymwab/qgYA5rHVxtnISouHm0AyeIer8q0jEO5NCm4zza6pGmTCH7jBuK9HJY1Q+9XHgxPqeiN7ea3/YsURUSE106g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PraTtu5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PraTtu5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2336AC4CEE7;
	Mon, 13 Oct 2025 15:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368496;
	bh=sZUCb8oTRc87XteldyDzXsITG3PmFNcp04t4xV6IGU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PraTtu5a+AWTjM7ZvfaLwdkJEOPheeUY5EUeq2jLEx29Fl25UrGrOJ9a0mZPwuxZR
	 frBzF7z1Ra+NO1etGXe+vScR8Cxp7QmTaZdeBmud1eR2vyZA0J4iYeMqBimTeBdrGb
	 xeOvNkUl9lrysQxbP5qMUIyl45wwYE49XmaoYkzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/262] wifi: mt76: mt7996: Convert mt7996_wed_rro_addr to LE
Date: Mon, 13 Oct 2025 16:44:51 +0200
Message-ID: <20251013144331.487511731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 809054a60d613ccca6e7f243bc68966b58044163 ]

Do not use bitmask in mt7996_wed_rro_addr DMA descriptor in order to not
break endianness

Fixes: 950d0abb5cd94 ("wifi: mt76: mt7996: add wed rx support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250909-mt7996-rro-rework-v5-11-7d66f6eb7795@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  8 +++++---
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 11 +++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index c550385541143..91b7d35bdb431 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -679,6 +679,7 @@ void mt7996_wfsys_reset(struct mt7996_dev *dev)
 static int mt7996_wed_rro_init(struct mt7996_dev *dev)
 {
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
+	u32 val = FIELD_PREP(WED_RRO_ADDR_SIGNATURE_MASK, 0xff);
 	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
 	u32 reg = MT_RRO_ADDR_ELEM_SEG_ADDR0;
 	struct mt7996_wed_rro_addr *addr;
@@ -718,7 +719,7 @@ static int mt7996_wed_rro_init(struct mt7996_dev *dev)
 
 		addr = dev->wed_rro.addr_elem[i].ptr;
 		for (j = 0; j < MT7996_RRO_WINDOW_MAX_SIZE; j++) {
-			addr->signature = 0xff;
+			addr->data = cpu_to_le32(val);
 			addr++;
 		}
 
@@ -736,7 +737,7 @@ static int mt7996_wed_rro_init(struct mt7996_dev *dev)
 	dev->wed_rro.session.ptr = ptr;
 	addr = dev->wed_rro.session.ptr;
 	for (i = 0; i < MT7996_RRO_WINDOW_MAX_LEN; i++) {
-		addr->signature = 0xff;
+		addr->data = cpu_to_le32(val);
 		addr++;
 	}
 
@@ -836,6 +837,7 @@ static void mt7996_wed_rro_free(struct mt7996_dev *dev)
 static void mt7996_wed_rro_work(struct work_struct *work)
 {
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
+	u32 val = FIELD_PREP(WED_RRO_ADDR_SIGNATURE_MASK, 0xff);
 	struct mt7996_dev *dev;
 	LIST_HEAD(list);
 
@@ -872,7 +874,7 @@ static void mt7996_wed_rro_work(struct work_struct *work)
 				MT7996_RRO_WINDOW_MAX_LEN;
 reset:
 			elem = ptr + elem_id * sizeof(*elem);
-			elem->signature = 0xff;
+			elem->data |= cpu_to_le32(val);
 		}
 		mt7996_mcu_wed_rro_reset_sessions(dev, e->id);
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 425fd030bee00..29e7289c3a169 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -194,13 +194,12 @@ struct mt7996_hif {
 	int irq;
 };
 
+#define WED_RRO_ADDR_SIGNATURE_MASK	GENMASK(31, 24)
+#define WED_RRO_ADDR_COUNT_MASK		GENMASK(14, 4)
+#define WED_RRO_ADDR_HEAD_HIGH_MASK	GENMASK(3, 0)
 struct mt7996_wed_rro_addr {
-	u32 head_low;
-	u32 head_high : 4;
-	u32 count: 11;
-	u32 oor: 1;
-	u32 rsv : 8;
-	u32 signature : 8;
+	__le32 head_low;
+	__le32 data;
 };
 
 struct mt7996_wed_rro_session_id {
-- 
2.51.0



