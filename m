Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0617E90E;
	Mon, 27 May 2024 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836824; cv=none; b=bPBsUer9oEabAXdaIcJVSOn4crqEKWrQIUVPrWxhxpyKTdR43HPXfppOd9Y5FSIWHxXaukowZuZz4TnLhWbpQJUOTsasN33yHH8X37bSYM56U4N8okqDYO2mJ/zuUD6rTs3ib9Vf10t6OtK/h2WWMuJngxX2cG+WTbzw89BGU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836824; c=relaxed/simple;
	bh=+4hc+G6NYtea/ZD6zcYhsTAbgL3gy2eMOVuZfeySY98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPRloki39LS+MHa/8JB2/HmlOSccjXPHayuBl0NDJUgJbfBh/D/yoygOsL8Wwjo8DlwIv0VzhfQl6elarrg1zeCjPhdMP6XBUT+AQVNAjJw/cJ16ROy1HGmsxWljjBNQOmmBhWiB0P/r4SnQu/89G9SElmgnKrFmYOjpcCE475E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9vRo+TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9vRo+TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541C5C2BBFC;
	Mon, 27 May 2024 19:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836824;
	bh=+4hc+G6NYtea/ZD6zcYhsTAbgL3gy2eMOVuZfeySY98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9vRo+TJ2fQHUvmqv+7QuPaoBanW86GSwdFjwp04sChwowM1HWULCu22pa/yrUvsM
	 3V0SSU9Sl7/aRDgcMpXnMtSdRn6uYUmfCezIzGAh63lWH9JRUz5N4Vd9hGxEPsypZU
	 pDFcaU+4qF+VYCLYNDP+SlPhSAwMzcZgqYguoPps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 202/427] wifi: mt76: mt7996: fix uninitialized variable in mt7996_irq_tasklet()
Date: Mon, 27 May 2024 20:54:09 +0200
Message-ID: <20240527185621.168945454@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 1ac710a6e8545c6df7a292f167dd088880a74c05 ]

Set intr1 to 0 in mt7996_irq_tasklet() in order to avoid possible
uninitialized variable usage if wed is not active for hif2.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index 304e5fd148034..928a9663b49e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -519,7 +519,7 @@ static void mt7996_irq_tasklet(struct tasklet_struct *t)
 	struct mt7996_dev *dev = from_tasklet(dev, t, mt76.irq_tasklet);
 	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
 	struct mtk_wed_device *wed_hif2 = &dev->mt76.mmio.wed_hif2;
-	u32 i, intr, mask, intr1;
+	u32 i, intr, mask, intr1 = 0;
 
 	if (dev->hif2 && mtk_wed_device_active(wed_hif2)) {
 		mtk_wed_device_irq_set_mask(wed_hif2, 0);
-- 
2.43.0



