Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72280BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F8AC433D2;
	Tue,  7 Mar 2023 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209185;
	bh=Sstslexe06+2YQqABB12lYoeHnlMhwc2CyluOvbVbpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ejZM25oQYq279UrqQaQ/PiJs2fWrOK2ccN5ULHBOj0YfgKJkhYLj8xAHB2HJkxPMf
	 jXCn/QThuzvCvdbxwfjcSo911h1KXBLDzZ2MlfU7vCZeumZqSz/AQhdE/rICs1PWXx
	 rlywYaX0LGWcyiImErWaOP6yJwXvL/7afogB0rHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0138/1001] wifi: mt76: mt7915: check return value before accessing free_block_num
Date: Tue,  7 Mar 2023 17:48:30 +0100
Message-Id: <20230307170028.044824644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 59b27a7d472f100ac8998e15a63c47a03cced12a ]

Check return value of mt7915_mcu_get_eeprom_free_block() first before
accessing free_block_num.

Fixes: bbc1d4154ec1 ("mt76: mt7915: add default calibrated data support")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.c    | 19 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 10 ++++++----
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 59069fb864147..24efa280dd868 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -110,18 +110,23 @@ static int mt7915_eeprom_load(struct mt7915_dev *dev)
 	} else {
 		u8 free_block_num;
 		u32 block_num, i;
+		u32 eeprom_blk_size = MT7915_EEPROM_BLOCK_SIZE;
 
-		mt7915_mcu_get_eeprom_free_block(dev, &free_block_num);
-		/* efuse info not enough */
+		ret = mt7915_mcu_get_eeprom_free_block(dev, &free_block_num);
+		if (ret < 0)
+			return ret;
+
+		/* efuse info isn't enough */
 		if (free_block_num >= 29)
 			return -EINVAL;
 
 		/* read eeprom data from efuse */
-		block_num = DIV_ROUND_UP(eeprom_size,
-					 MT7915_EEPROM_BLOCK_SIZE);
-		for (i = 0; i < block_num; i++)
-			mt7915_mcu_get_eeprom(dev,
-					      i * MT7915_EEPROM_BLOCK_SIZE);
+		block_num = DIV_ROUND_UP(eeprom_size, eeprom_blk_size);
+		for (i = 0; i < block_num; i++) {
+			ret = mt7915_mcu_get_eeprom(dev, i * eeprom_blk_size);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	return mt7915_check_eeprom(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index b2652de082baa..d9d6846ba8e02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2792,8 +2792,9 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset)
 	int ret;
 	u8 *buf;
 
-	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_QUERY(EFUSE_ACCESS), &req,
-				sizeof(req), true, &skb);
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_EXT_QUERY(EFUSE_ACCESS),
+					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
 
@@ -2818,8 +2819,9 @@ int mt7915_mcu_get_eeprom_free_block(struct mt7915_dev *dev, u8 *block_num)
 	struct sk_buff *skb;
 	int ret;
 
-	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_QUERY(EFUSE_FREE_BLOCK), &req,
-					sizeof(req), true, &skb);
+	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
+					MCU_EXT_QUERY(EFUSE_FREE_BLOCK),
+					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
 
-- 
2.39.2



