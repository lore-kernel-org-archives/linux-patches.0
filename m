Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C0C14388A;
	Tue, 23 Apr 2024 21:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908480; cv=none; b=KpUu24CsAueC1RhtwBHyEvH7JEa2rMDvXwgRtTxRjaJ9tZrZtxAuwRo8WordGlVg5OkbH0zkp4wKeib+ZRa4hwLlQWPM0Ke0xRVfZVDbP1tEKiwRaU4PV1tj6fj/w5yuBbMJtQjdsAbt0JxGBui+Pp3pQao/wlHsIhcFgEZJqaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908480; c=relaxed/simple;
	bh=gjQmQ5Lev0BE9Pm7N3CyqNlg8HMUg8JNg72X+z+OzR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnbfWVAoflTTuuoQsYxFQqjSfZ6q+3kB5hvQ3sDqh8MwMLUR1Pr0Lx2sElyHpPutNIg9bhI4er6pETGnOwLoibzxbX8pOSdNFvx5gY9jzE/lU0QXP1qp1LJiBZ/yiM/T9vWiGZqKdk/18w8ehNAfOnRp2Zd2EioWckSzBBtLuoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12qWn/mC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12qWn/mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32394C32782;
	Tue, 23 Apr 2024 21:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908480;
	bh=gjQmQ5Lev0BE9Pm7N3CyqNlg8HMUg8JNg72X+z+OzR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12qWn/mC5F4mHLBc3q9MZBmSARBfgeIgAwXgNhTtN1f5gcxRlC1SJPFTBJPkNZPru
	 nHYTAk6rMnsqNvoaDMruPT2lVbhwLj20wstKgQjQh4xwn9PqrmddswCMBfjk1fj3MK
	 H2jdIqIw3Ad3+SvVT+Cg9xGxXau9mBFNlhlHPzYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 049/158] net: ethernet: mtk_eth_soc: fix WED + wifi reset
Date: Tue, 23 Apr 2024 14:37:51 -0700
Message-ID: <20240423213857.497942136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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
index c895e265ae0eb..61334a71058c7 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1074,13 +1074,13 @@ mtk_wed_dma_disable(struct mtk_wed_device *dev)
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
 
 	if (!mtk_wed_get_rx_capa(dev))
 		return;
@@ -1093,7 +1093,6 @@ static void
 mtk_wed_deinit(struct mtk_wed_device *dev)
 {
 	mtk_wed_stop(dev);
-	mtk_wed_dma_disable(dev);
 
 	wed_clr(dev, MTK_WED_CTRL,
 		MTK_WED_CTRL_WDMA_INT_AGENT_EN |
@@ -2605,9 +2604,6 @@ mtk_wed_irq_get(struct mtk_wed_device *dev, u32 mask)
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



