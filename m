Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60865262BE;
	Mon, 27 May 2024 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838115; cv=none; b=HRybVvDRrBy1+pTwJv+rTHLPSf7eODh3dhTE3MOsg1ZCqlIuz1TU8vKrpc869Z8pFX9sohbJdz3AUCW1LOrQRfMXHwF6RpicEeIMSHX2Lr7lJng6AA2J3mn5dNtkWZvI/DvQ1A2yr1JzkoD9r7MpVjvOHms19P8Ejy/iVYkkEJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838115; c=relaxed/simple;
	bh=y287NQt5r+O65+4vficp4oauq4zGGt1H8p4sWvhUJ+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPQfSKJP4FQhi1S/eqaG1R3pg2lP42nAPm5wQjKKulH8JsCG11fD9bfBlNqPIfjjJyefH17Wn/SqBKYB+0a7rDGNqqkisRsg/G+ghPbkir2Q8R78AeRBbD+g+y28X3NorGn00n4/6O8MoNWemjCGwQOsqigZJmQAU6dgVrxNMWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7cT0yt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7cT0yt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35BEC2BBFC;
	Mon, 27 May 2024 19:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838115;
	bh=y287NQt5r+O65+4vficp4oauq4zGGt1H8p4sWvhUJ+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7cT0yt0Blt9xlx/gSUOymgiOW0uALzYuo2i7E9SsR2tsrNMPzkAYWhyAejpyLvgC
	 EBkRq7+EEokdBjbD9S+68f1ES6DdWkI1OX3zM/ZzKLhljFanvQzUzQ3tMd6+nvx9lg
	 ENbaizjzZ+Ap2UukLQ1AqpfbFu6i4ZAM9aC9OBbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 273/493] wifi: mt76: mt7996: fix uninitialized variable in mt7996_irq_tasklet()
Date: Mon, 27 May 2024 20:54:35 +0200
Message-ID: <20240527185639.216113694@linuxfoundation.org>
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
index efd4a767eb37d..c93f82548beeb 100644
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



