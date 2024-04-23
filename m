Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2878F143889;
	Tue, 23 Apr 2024 21:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908595; cv=none; b=U3EBPXLygQdV/umOZ2PaGt191rCVlOfZVxyyJVQrnBIfuOyItOZQXD/GuUnqQ6XcXFNfV6y/JQVVonooC+xRuK9BLBxmpZNehsjjmDRsoVO7lXB1N+PA0DLWQPZ2FzcRmqGE3GK7Mm/jpJCyhfVbclSwyNWlpmxuJ8sDoKbZft4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908595; c=relaxed/simple;
	bh=6T+iYD1PUxrhDIAYXCMFdwNBOmiHv3LrTQ0Yk+rFMoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfACgBXcO6pOoZbWm0MuzctFRXjrt5NHh5wWDLHVT8rjRXPxlBiIvwTEXSiNPygABBdD8r4s5YmvliZ57sxUSsrTWN7VyntK5J/fr5pr8wJjiPhdRzw7p+FhSuKT5Ee+gj0t/op5kFQAvPfP0fe8YbD1vz2BU7ok8rjJqkKcAc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7MB17VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7MB17VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1100C116B1;
	Tue, 23 Apr 2024 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908595;
	bh=6T+iYD1PUxrhDIAYXCMFdwNBOmiHv3LrTQ0Yk+rFMoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7MB17VRsGiJ0Xk8lrMlLSA+pjnRGBrTKidRPIVmYwXqPROQ1J6r6aVROT2oXHCVQ
	 yJluk/J+n9NBLggYWhyabt10wRkGqXKp4Uek23DNmXkW6t5/czmsX/l77PN9yyxbx/
	 3CIuRnmCZaISdcj2TS2y4+wQKalVELF8mEMv9f1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/158] net: ethernet: mtk_eth_soc: fix WED + wifi reset
Date: Tue, 23 Apr 2024 14:38:14 -0700
Message-ID: <20240423213857.629633467@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94667949ec3bbb2218c46ad0a0e7274c8832e494 ]

The WLAN + WED reset sequence relies on being able to receive interrupts from
the card, in order to synchronize individual steps with the firmware.
When WED is stopped, leave interrupts running and rely on the driver turning
off unwanted ones.
WED DMA also needs to be disabled before resetting.

Fixes: f78cd9c783e0 ("net: ethernet: mtk_wed: update mtk_wed_stop")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20240416082330.82564-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 94376aa2b34c5..c7196055c8c98 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -598,13 +598,13 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
 static void
 mtk_wed_stop(struct mtk_wed_device *dev)
 {
+	mtk_wed_dma_disable(dev);
 	mtk_wed_set_ext_int(dev, false);
 
 	wed_w32(dev, MTK_WED_WPDMA_INT_TRIGGER, 0);
 	wed_w32(dev, MTK_WED_WDMA_INT_TRIGGER, 0);
 	wdma_w32(dev, MTK_WDMA_INT_MASK, 0);
 	wdma_w32(dev, MTK_WDMA_INT_GRP2, 0);
-	wed_w32(dev, MTK_WED_WPDMA_INT_MASK, 0);
 
 	if (dev->hw->version == 1)
 		return;
@@ -617,7 +617,6 @@ static void
 mtk_wed_deinit(struct mtk_wed_device *dev)
 {
 	mtk_wed_stop(dev);
-	mtk_wed_dma_disable(dev);
 
 	wed_clr(dev, MTK_WED_CTRL,
 		MTK_WED_CTRL_WDMA_INT_AGENT_EN |
@@ -1703,9 +1702,6 @@ mtk_wed_irq_get(struct mtk_wed_device *dev, u32 mask)
 static void
 mtk_wed_irq_set_mask(struct mtk_wed_device *dev, u32 mask)
 {
-	if (!dev->running)
-		return;
-
 	mtk_wed_set_ext_int(dev, !!mask);
 	wed_w32(dev, MTK_WED_INT_MASK, mask);
 }
-- 
2.43.0



