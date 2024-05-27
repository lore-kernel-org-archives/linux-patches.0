Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C6E17E90E;
	Mon, 27 May 2024 19:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836822; cv=none; b=YG9IMIxBIURwp3vO31vsVTo3rbxm7fmJwV4y43r5D+yVWe+riAes4o2URljELk2lgn5qssaYWwPYVweu9McokqlhR8f96ZFiX+QYCPT8BBvTZV3wM0+ELOmGg0ArekIPJCtfesMcs2C5WBlVyctWai7khwf2buwwp7svFgu11hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836822; c=relaxed/simple;
	bh=PFu+NSr8S/KPE/+UQR9uXGEvFffl5v1fAUFT2/1Trv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzWK2SBek4Jl/abh38C+Bvyl00b02BOIYlGlR4o32Ui8YnN+7gpiENudlBZUo+kbyQcaEJtzT8q/VWYub3jj0EkzWd0tE3TWBjwIwhCNBg39frVVPhfaWnkc4tMcTBYsn4RLtme3stcvmvXMDIrZDuf0dqfeG7utM6pDWJ5C/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owvXLwe2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owvXLwe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5B6C2BBFC;
	Mon, 27 May 2024 19:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836822;
	bh=PFu+NSr8S/KPE/+UQR9uXGEvFffl5v1fAUFT2/1Trv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owvXLwe2nV+j99/Bb77sYngYI+zq9l/YgufDjC9CgHINGpBO8ASHq+0Y7yFJBz6Xd
	 i5Acf4G/Rz/nap5XcQt5AgzVo5hazjfp90Kzy9RaznYwmstnTMRwkocOARfixN2jk4
	 ketYdBjxIV3ZqWZElf2eb5yntLpoMbQmQ0Ufkpag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 201/427] wifi: mt76: mt7925: ensure 4-byte alignment for suspend & wow command
Date: Mon, 27 May 2024 20:54:08 +0200
Message-ID: <20240527185621.033247253@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit fa46bd62c9a8ab195d9c5108a91abf0680fec10e ]

Before sending suspend & wow command to FW, its length should be
4-bytes alignd.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 7af60eebe517a..990738a23eee5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2527,6 +2527,7 @@ int mt76_connac_mcu_set_hif_suspend(struct mt76_dev *dev, bool suspend)
 			__le16 tag;
 			__le16 len;
 			u8 suspend;
+			u8 pad[7];
 		} __packed hif_suspend;
 	} req = {
 		.hif_suspend = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 2a0bbfe7bfa5e..b8315a89f4a9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -535,7 +535,7 @@ struct mt7925_wow_pattern_tlv {
 	u8 offset;
 	u8 mask[MT76_CONNAC_WOW_MASK_MAX_LEN];
 	u8 pattern[MT76_CONNAC_WOW_PATTEN_MAX_LEN];
-	u8 rsv[4];
+	u8 rsv[7];
 } __packed;
 
 static inline enum connac3_mcu_cipher_type
-- 
2.43.0



