Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03B262BE;
	Mon, 27 May 2024 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838118; cv=none; b=CguU6EGMxyPeyj05+Z40CvtdbiXFgMiK+sDhnDdlMW6c7cFN58kcBR8SJJ+csqWuuyl1FpZiFvK//dT0zpO1ZRuGsqvRlwEAU0nrU0+Tc28i9nnmKCzBfth3EMe0F+EBwIi8y3KJEluiewqP30Us6uVrERaAqNar/p/X7llEfKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838118; c=relaxed/simple;
	bh=Bq01vfZ63inoYRXc7dpNuwKZVGBKub5DoCiO4rC47dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/taCbxy7re3CfxqsvDVqAqvlgTJuCRlEFT8i/HtW5teSB2CyO3kFFIP0qkAYapk8YKXlnf1Gs2mVSu5HtHpeJkabzSrG+RTLsWVs0peD0/i5JYK9VgHv12oTOi+5HB9exsidvUXJ8HlSG7Dyq+qJfKcX0BAGu0+V89X4+NQYzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uE7GkiAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uE7GkiAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B175C2BBFC;
	Mon, 27 May 2024 19:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838118;
	bh=Bq01vfZ63inoYRXc7dpNuwKZVGBKub5DoCiO4rC47dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uE7GkiAYPoVnE+8nXPTXoOjlQt5mw04PAeXmRJ4zT3Xg903jP2elj9jDwWTnCv01y
	 0eUveq8q8tqxr1fdFijsKygU09TzeB4o5LOePyhX1lL/Tabsw2l4S7kNqUdSFVG3Op
	 tYDNU1dsP2UtOTXJgR1Kjv6kSIstmUvuwmlk58jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 274/493] wifi: mt76: mt7996: fix potential memory leakage when reading chip temperature
Date: Mon, 27 May 2024 20:54:36 +0200
Message-ID: <20240527185639.249987646@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 474b9412f33be87076b40a49756662594598a85e ]

Without this commit, reading chip temperature will cause memory leakage.

Fixes: 6879b2e94172 ("wifi: mt76: mt7996: add thermal sensor device support")
Reported-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 25ea81ecdab9b..10d13fa45c5a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3733,6 +3733,7 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy)
 	} __packed * res;
 	struct sk_buff *skb;
 	int ret;
+	u32 temp;
 
 	ret = mt76_mcu_send_and_get_msg(&phy->dev->mt76, MCU_WM_UNI_CMD(THERMAL),
 					&req, sizeof(req), true, &skb);
@@ -3740,8 +3741,10 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy)
 		return ret;
 
 	res = (void *)skb->data;
+	temp = le32_to_cpu(res->temperature);
+	dev_kfree_skb(skb);
 
-	return le32_to_cpu(res->temperature);
+	return temp;
 }
 
 int mt7996_mcu_set_thermal_throttling(struct mt7996_phy *phy, u8 state)
-- 
2.43.0



