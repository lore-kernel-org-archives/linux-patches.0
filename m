Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9054168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5078BC433EF;
	Mon,  8 May 2023 10:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540432;
	bh=+SPg38bGlIBb57QibYUbtlUgYHiaZoB6WhrLRjFV2OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP1NOWjRx5MUYTqi4gzyqyZRpmJHSa8IiA7+m/bMp8FLMbIoP62ydod8tXI4MQGUl
	 HnByXGwoIb77yx1pzyrnIZKG8+BtQ0Vqv3bm66S4GnJ+n1c3eo18iYVZV/BBr4P9EY
	 qCZ7yyIFeLzgZLmvIk6P89k0ZYJtBkB1H3DrX2MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/611] wifi: mt76: add flexible polling wait-interval support
Date: Mon,  8 May 2023 11:43:25 +0200
Message-Id: <20230508094434.186447279@linuxfoundation.org>
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

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 35effe6c0c24adcf0f732bb1c3d75573d4c88e63 ]

The default waiting unit is 10ms and the value is too much for
data path related control. Provide a new API mt76_poll_msec_tick()
to support different cases, such as 1ms polling waiting kick.

Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: c397fc1e6365 ("wifi: mt76: mt7921e: fix probe timeout after reboot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  9 +++++----
 drivers/net/wireless/mediatek/mt76/util.c | 10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 7bcf7a6b67df3..9c753c6aabeff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -904,10 +904,11 @@ bool __mt76_poll(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
 
 #define mt76_poll(dev, ...) __mt76_poll(&((dev)->mt76), __VA_ARGS__)
 
-bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
-		      int timeout);
-
-#define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
+bool ____mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+			int timeout, int kick);
+#define __mt76_poll_msec(...)         ____mt76_poll_msec(__VA_ARGS__, 10)
+#define mt76_poll_msec(dev, ...)      ____mt76_poll_msec(&((dev)->mt76), __VA_ARGS__, 10)
+#define mt76_poll_msec_tick(dev, ...) ____mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
 
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
 void mt76_pci_disable_aspm(struct pci_dev *pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
index 581964425468f..fc76c66ff1a5a 100644
--- a/drivers/net/wireless/mediatek/mt76/util.c
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -24,23 +24,23 @@ bool __mt76_poll(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
 }
 EXPORT_SYMBOL_GPL(__mt76_poll);
 
-bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
-		      int timeout)
+bool ____mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+			int timeout, int tick)
 {
 	u32 cur;
 
-	timeout /= 10;
+	timeout /= tick;
 	do {
 		cur = __mt76_rr(dev, offset) & mask;
 		if (cur == val)
 			return true;
 
-		usleep_range(10000, 20000);
+		usleep_range(1000 * tick, 2000 * tick);
 	} while (timeout-- > 0);
 
 	return false;
 }
-EXPORT_SYMBOL_GPL(__mt76_poll_msec);
+EXPORT_SYMBOL_GPL(____mt76_poll_msec);
 
 int mt76_wcid_alloc(u32 *mask, int size)
 {
-- 
2.39.2



