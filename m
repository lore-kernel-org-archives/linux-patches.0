Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DE2168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AE1C433D2;
	Mon,  8 May 2023 10:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540435;
	bh=dXgEGa6BFCGhBUfTgbDhuBvUxQVevaVdPPhVVcsOdBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHbmpSBzuGZnN5Qxk0E3bNWbdZZG9gnkO/W1ds/GKCd6+7v+UuOiHE0cWkQYzqOmo
	 92HX7fGXYY9kmnq9cPxnhLkrEU/hL+rvHSPCDfekzOYyLUroHSrcZ7wVYlZRvtDLTx
	 MW+B3ZFQu7Jn4PPvZTxmaU0Ukg8ryiLpEPRNJ3Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 364/611] wifi: mt76: mt7921e: fix probe timeout after reboot
Date: Mon,  8 May 2023 11:43:26 +0200
Message-Id: <20230508094434.215597134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit c397fc1e6365a2a9e5540a85b2c1d4ea412aa0e2 ]

In system warm reboot scene, due to the polling timeout(now 1000us)
is too short to wait dma idle in time, it may make driver probe fail
with error code -ETIMEDOUT. Meanwhile, we also found the dma may take
around 70ms to enter idle state. Change the polling idle timeout to
100ms to avoid the probabilistic probe fail.

Tested pass with 5000 times warm reboot on x86 platform.

[4.477496] pci 0000:01:00.0: attach allowed to drvr mt7921e [internal device]
[4.478306] mt7921e 0000:01:00.0: ASIC revision: 79610010
[4.480063] mt7921e: probe of 0000:01:00.0 failed with error -110

Fixes: 0a1059d0f060 ("mt76: mt7921: move mt7921_dma_reset in dma.c")
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index d1f10f6d9adc3..dc4ccfef4b048 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -90,9 +90,9 @@ static int mt7921_dma_disable(struct mt7921_dev *dev, bool force)
 		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO |
 		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
 
-	if (!mt76_poll(dev, MT_WFDMA0_GLO_CFG,
-		       MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
-		       MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 1000))
+	if (!mt76_poll_msec_tick(dev, MT_WFDMA0_GLO_CFG,
+				 MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
+				 MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 100, 1))
 		return -ETIMEDOUT;
 
 	return 0;
-- 
2.39.2



