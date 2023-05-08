Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DF4171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903A8C433AA;
	Mon,  8 May 2023 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546112;
	bh=oTlM6QwoHU60c8Rk06LcMqRQgGGh7eAg8gv0p/Gudpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf8atGGsSM7bUYauLdtIEHyxRdIVdDhQDaZF/Jg6YPLTQlvBV0DVy/urwnu6fUorw
	 62yZeoQWnhhBB7pfVSuyOr3of9IQcrRetS9zEB4Z1fTBBua+71sIbYZYhGy8TJNM0i
	 NK9JhSDRQskKmkx0HiWTou6gz7OsNyD5IPdS9VVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Wang Zhao <wang.zhao@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/371] wifi: mt76: mt7921e: improve reliability of dma reset
Date: Mon,  8 May 2023 11:47:02 +0200
Message-Id: <20230508094820.837459683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
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

[ Upstream commit 87714bf6ed1589813e473db5471e6e9857755764 ]

The hardware team has advised the driver that it is necessary to first put
WFDMA into an idle state before resetting the WFDMA. Otherwise, the WFDMA
may enter an unknown state where it cannot be polled with the right state
successfully. To ensure that the DMA can work properly while a stressful
cold reboot test was being made, we have reordered the programming sequence
in the driver based on the hardware team's guidance.

The patch would modify the WFDMA disabling flow from

"DMA reset -> disabling DMASHDL -> disabling WFDMA -> polling and waiting
until DMA idle" to "disabling WFDMA -> polling and waiting for DMA idle ->
disabling DMASHDL -> DMA reset.

Where he polling and waiting until WFDMA is idle is coordinated with the
operation of disabling WFDMA. Even while WFDMA is being disabled, it can
still handle Tx/Rx requests. The additional polling allows sufficient time
for WFDMA to process the last T/Rx request. When the idle state of WFDMA is
reached, it is a reliable indication that DMASHDL is also idle to ensure it
is safe to disable it and perform the DMA reset.

Fixes: 0a1059d0f060 ("mt76: mt7921: move mt7921_dma_reset in dma.c")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Co-developed-by: Wang Zhao <wang.zhao@mediatek.com>
Signed-off-by: Wang Zhao <wang.zhao@mediatek.com>
Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/dma.c   | 36 ++++++++++---------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index 7e39bcfdb0b7a..983861edc6834 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -120,22 +120,6 @@ static void mt7921_dma_prefetch(struct mt7921_dev *dev)
 
 static int mt7921_dma_disable(struct mt7921_dev *dev, bool force)
 {
-	if (force) {
-		/* reset */
-		mt76_clear(dev, MT_WFDMA0_RST,
-			   MT_WFDMA0_RST_DMASHDL_ALL_RST |
-			   MT_WFDMA0_RST_LOGIC_RST);
-
-		mt76_set(dev, MT_WFDMA0_RST,
-			 MT_WFDMA0_RST_DMASHDL_ALL_RST |
-			 MT_WFDMA0_RST_LOGIC_RST);
-	}
-
-	/* disable dmashdl */
-	mt76_clear(dev, MT_WFDMA0_GLO_CFG_EXT0,
-		   MT_WFDMA0_CSR_TX_DMASHDL_ENABLE);
-	mt76_set(dev, MT_DMASHDL_SW_CONTROL, MT_DMASHDL_DMASHDL_BYPASS);
-
 	/* disable WFDMA0 */
 	mt76_clear(dev, MT_WFDMA0_GLO_CFG,
 		   MT_WFDMA0_GLO_CFG_TX_DMA_EN | MT_WFDMA0_GLO_CFG_RX_DMA_EN |
@@ -149,6 +133,22 @@ static int mt7921_dma_disable(struct mt7921_dev *dev, bool force)
 				 MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 100, 1))
 		return -ETIMEDOUT;
 
+	/* disable dmashdl */
+	mt76_clear(dev, MT_WFDMA0_GLO_CFG_EXT0,
+		   MT_WFDMA0_CSR_TX_DMASHDL_ENABLE);
+	mt76_set(dev, MT_DMASHDL_SW_CONTROL, MT_DMASHDL_DMASHDL_BYPASS);
+
+	if (force) {
+		/* reset */
+		mt76_clear(dev, MT_WFDMA0_RST,
+			   MT_WFDMA0_RST_DMASHDL_ALL_RST |
+			   MT_WFDMA0_RST_LOGIC_RST);
+
+		mt76_set(dev, MT_WFDMA0_RST,
+			 MT_WFDMA0_RST_DMASHDL_ALL_RST |
+			 MT_WFDMA0_RST_LOGIC_RST);
+	}
+
 	return 0;
 }
 
@@ -354,6 +354,10 @@ void mt7921_dma_cleanup(struct mt7921_dev *dev)
 		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO |
 		   MT_WFDMA0_GLO_CFG_OMIT_RX_INFO_PFET2);
 
+	mt76_poll_msec_tick(dev, MT_WFDMA0_GLO_CFG,
+			    MT_WFDMA0_GLO_CFG_TX_DMA_BUSY |
+			    MT_WFDMA0_GLO_CFG_RX_DMA_BUSY, 0, 100, 1);
+
 	/* reset */
 	mt76_clear(dev, MT_WFDMA0_RST,
 		   MT_WFDMA0_RST_DMASHDL_ALL_RST |
-- 
2.39.2



