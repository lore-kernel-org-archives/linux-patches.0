Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6109A2F2346;
	Tue, 17 Jun 2025 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176028; cv=none; b=HBV/IOXqMwgqqCiqw/wcQi4lu3SoXfB8XZlEAfnM9l3ywC/tGqHOmdDZBVtj/FLv9fiWCf+kv7LH/Y0l8CP6LgTjKyf84kSbUbW3UTxyWzI66YfFxPkzxOiu0hm9UNqdhRF/2aUYdqDaDq7itu90MA2RQsg/1zq0EWd66e1mwFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176028; c=relaxed/simple;
	bh=9FUMA3PFEytFAjW9vMDwgc40h+V7hDQPe1JlAQsGCQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl6WmM0j/XtgQiiXn7wAm5jWmiEf4lBfOxiU8GFJBJOgld6ajfqL3ApGimKVYQrU7ltucLJUu7j2f+hWM/D9JOGMAP1XOap4P2HKlSAlQco5B3kTVjKmHlvxUR9cbMeVxvUXfikxvsDhoEcE8nNNoYJqETTRYbZT8BNU/8/chr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4NQIbjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4NQIbjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35FEC4CEE3;
	Tue, 17 Jun 2025 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176028;
	bh=9FUMA3PFEytFAjW9vMDwgc40h+V7hDQPe1JlAQsGCQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4NQIbjsQXlAqBOb+AxNALNOZ26WKPPONiMTFsGzY4GgWAfRJlNMLUuIbgkckeZCp
	 cZgm8BWC3dsHROoO9IrOPz4JfXl3BGXXF2HPjViuu420tg44yKUGQveXunVZzpIadC
	 hFqwKmvRUmZEi3bnXDVMteoJEM1dAXP4L8KQ9XDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/512] wifi: mt76: mt7996: fix RX buffer size of MCU event
Date: Tue, 17 Jun 2025 17:22:35 +0200
Message-ID: <20250617152427.298075072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 42cb27af34de4acf680606fad2c1f2932110591f ]

Some management frames are first processed by the firmware and then
passed to the driver through the MCU event rings. In CONNAC3, event rings
do not support scatter-gather and have a size limitation of 2048 bytes.
If a packet sized between 1728 and 2048 bytes arrives from an event ring,
the ring will hang because the driver attempts to use scatter-gather to
process it.

To fix this, include the size of struct skb_shared_info in the MCU RX
buffer size to prevent scatter-gather from being used for event skb in
mt76_dma_rx_fill_buf().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Co-developed-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-7-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
index 69a7d9b2e38bd..4b68d2fc5e094 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
@@ -493,7 +493,7 @@ int mt7996_dma_init(struct mt7996_dev *dev)
 	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU],
 			       MT_RXQ_ID(MT_RXQ_MCU),
 			       MT7996_RX_MCU_RING_SIZE,
-			       MT_RX_BUF_SIZE,
+			       MT7996_RX_MCU_BUF_SIZE,
 			       MT_RXQ_RING_BASE(MT_RXQ_MCU));
 	if (ret)
 		return ret;
@@ -502,7 +502,7 @@ int mt7996_dma_init(struct mt7996_dev *dev)
 	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU_WA],
 			       MT_RXQ_ID(MT_RXQ_MCU_WA),
 			       MT7996_RX_MCU_RING_SIZE_WA,
-			       MT_RX_BUF_SIZE,
+			       MT7996_RX_MCU_BUF_SIZE,
 			       MT_RXQ_RING_BASE(MT_RXQ_MCU_WA));
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index ab8c9070630b0..425fd030bee00 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -28,6 +28,9 @@
 #define MT7996_RX_RING_SIZE		1536
 #define MT7996_RX_MCU_RING_SIZE		512
 #define MT7996_RX_MCU_RING_SIZE_WA	1024
+/* scatter-gather of mcu event is not supported in connac3 */
+#define MT7996_RX_MCU_BUF_SIZE		(2048 + \
+					 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
 #define MT7996_FIRMWARE_WA		"mediatek/mt7996/mt7996_wa.bin"
 #define MT7996_FIRMWARE_WM		"mediatek/mt7996/mt7996_wm.bin"
-- 
2.39.5



