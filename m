Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8E29DB64;
	Sat, 12 Sep 2026 10:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209114; cv=none; b=K8M4DVSCGGeI6KgxDZGOgkUevYvNdmWea/f4ZnvyI8HNcweDfFlAaX8N2AQmI2bAj1HtpPz2qWdFB+468fHf7inDuCUCDKnHZ4SLQnSkxrnCg+oJ983Y8OwLASZfibwImG9KumZQ5d5SBU6dWycZfsRP7yLz6pY5AhoxnEY0GD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209114; c=relaxed/simple;
	bh=e0Es/grdDKB5JXBUCGdHGSFG1xJESkGKwn+NJuYDzQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPV1j5dvrs7AMSOR6jEqf52iXddarSs6mWrna3eE5IvLEt2gp5G4/I3TggyYoburhiDwXONEv8oBxcEpznRImgpLRjjsO9PmGuSudJj1M2bbwnMYBzsZj4vk1yABtt/+daXyM86yatkWuDjKuBkH57fqgysK2+i8zXuFjGHnL8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpKpx22D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpKpx22D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C911F000FF;
	Sat, 12 Sep 2026 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209112;
	bh=JmxgEJhjVd4we4yXDBIPORPtuuokXQ8q7sis6HDDBsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FpKpx22D9VpyO7isXB4rAixzFZWU74Mts8ahdWmyfOIiybQZUPVyYTyb7jSCK8oo4
	 ouWaFPs7ctA0ejMQzqpwfoQbeT+Qb0AI+wgM/vG5GXjngi0t70PcGZHirWEmMzaD5l
	 SckdyC+oqFiky7CGaYAx423ROVYe+ddHkAJHAYvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0755/1518] wifi: mt76: check txfree done event on the WED hw path
Date: Sat, 12 Sep 2026 08:48:44 +0200
Message-ID: <20260912065640.509147525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Lu <rex.lu@mediatek.com>

[ Upstream commit 3310e71a74b176d3613dfb42b6bc630d99e90cbb ]

Check the txfree done event DW1 bit 15 when WED is enabled, to avoid
the driver reading a txfree done event before WED has finished reading
it. No need to check this flag on WED v2, otherwise SER will occur.

The bit position was previously defined as MT_DMA_CTL_BURST, which is
unused; rename it to match its function on the txfree ring.

Fixes: 83eafc9251d6 ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260722082610.2699628-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 +++++++++
 drivers/net/wireless/mediatek/mt76/dma.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f1048e3dff1d3..13a3885a0a92d 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -608,6 +608,15 @@ mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 			q->desc[idx].ctrl |= cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 		else if (!(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_DMA_DONE)))
 			return NULL;
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+		/* on WED v3 the M_DONE bit signals that WED is done reading
+		 * the txfree descriptor; WED v2 does not set it
+		 */
+		else if (dev->mmio.wed.version > 2 &&
+			 mt76_queue_is_wed_tx_free(q) &&
+			 !(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_M_DONE)))
+			return NULL;
+#endif
 	}
 done:
 	q->tail = (q->tail + 1) % q->ndesc;
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 27eefc9e56f22..1c556c8c86347 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -11,7 +11,7 @@
 
 #define MT_DMA_CTL_SD_LEN1		GENMASK(13, 0)
 #define MT_DMA_CTL_LAST_SEC1		BIT(14)
-#define MT_DMA_CTL_BURST		BIT(15)
+#define MT_DMA_CTL_M_DONE		BIT(15)
 #define MT_DMA_CTL_SD_LEN0		GENMASK(29, 16)
 #define MT_DMA_CTL_LAST_SEC0		BIT(30)
 #define MT_DMA_CTL_DMA_DONE		BIT(31)
-- 
2.53.0



