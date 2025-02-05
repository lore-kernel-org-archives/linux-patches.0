Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867BB4A28;
	Wed,  5 Feb 2025 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764963; cv=none; b=m6ewvAEbfSmdWeW7SZYwNu/0bsEhsLgZjzzeGfyAuzsL9hLBYYAVG6bqN90TE3vj6TAmhyCmt1vl5PMoOVgQAokpJPuSqeCW2S2nlwZ5/y+sVWGN3geU+8+OAhdsf+ZEpW7LHZ5xfbbfYUVxidsyST0eB25x0fd/IkRYR2yS3As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764963; c=relaxed/simple;
	bh=HMW8TK/SwqyCFliShmM7w8ULGsINfTJ81cw4MdIcn5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndX4bjslD8L3b0VuBJJs0sZM2XBcPETWv3B7+yX92V55UZWMYJVgG7lfItfDihg5XPBC+rNcl9oX3CCbFS7MlLGDaX6/Z8Bp4EXqSb48behHRtW01e0IF4ztRXVId3KhiRjAhlef90UvWhdlW1Sm893S4xQ267ljom0d6xg51MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BswGqaOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BswGqaOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FAFC4CED1;
	Wed,  5 Feb 2025 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764963;
	bh=HMW8TK/SwqyCFliShmM7w8ULGsINfTJ81cw4MdIcn5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BswGqaOd9L5FGEkFWQHEfVZOw46UMgUN9X4MguWN9ru8tBYIuFDgXerNif7F9iB3S
	 9tt2i5LdN4wIP8dtne5+5C5JewwKetJbGTwMQ7wl5a+6Nb2cPndzcg48AFbQZy0A/L
	 lU2VGS6zjh9nRlAHu5p+J2wdeCisLEgP4K0X4aog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/590] wifi: mt76: mt7925: fix get wrong chip cap from incorrect pointer
Date: Wed,  5 Feb 2025 14:38:52 +0100
Message-ID: <20250205134502.053572907@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit 4d264f31b3074d361f65702dd7969861bcf1c158 ]

Use tlv instead of skb, because using skb will get valid data
with wrong offset.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20241104051447.4286-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index a78883d4d6df0..b43617dbd5fde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -823,7 +823,7 @@ mt7925_mcu_get_nic_capability(struct mt792x_dev *dev)
 			mt7925_mcu_parse_phy_cap(dev, tlv->data);
 			break;
 		case MT_NIC_CAP_CHIP_CAP:
-			memcpy(&dev->phy.chip_cap, (void *)skb->data, sizeof(u64));
+			dev->phy.chip_cap = le64_to_cpu(*(__le64 *)tlv->data);
 			break;
 		case MT_NIC_CAP_EML_CAP:
 			mt7925_mcu_parse_eml_cap(dev, tlv->data);
-- 
2.39.5



