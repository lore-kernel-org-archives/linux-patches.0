Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F293D405C3F;
	Fri,  4 Sep 2026 06:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501853; cv=none; b=FB5GhljDPqF5X4ucJHT//gL2YcWjwq8gd1cGc4Si31zyasT6TQJrWG4nJ2hh7wvn+pM19Wjsjon9nkybJob3okBB6IVKE9y+eW2RNF5wqz3AwpyAjvf2lvmFqK03sW9jwJPxptHa/7/nuuf6BuW1aWo2/+uAduXSK3JLt4tT4z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501853; c=relaxed/simple;
	bh=vGPwh/L1gYE7BGCE7onL50waEpZ1f1Flt7j5HNewwb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esOCBNc2Z7X16FKkSjYVl/DYtOIoDNR8kr0RX5hSGvulGG31/FuL+xazrzpmSw42MQVAgqRLMn4Yaqqb++VPKclq3oZYjruBmRVBfgyVug0AoHcfNDimzXQK1CIegP+IRb5oCs9MSN9v4JtMRG5YAvcwuCwfbCeaYWsLtf6HTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RoG+w8/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RoG+w8/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556421F00A3D;
	Fri,  4 Sep 2026 06:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501851;
	bh=xlYOEq4lnMsvRyZVZ50Sc6gJoVxlRjeCDd/3bqC2MpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RoG+w8/T9TfhuLyCuo014gCyEe34JpPHh+G6C2mMfj+UIRusRLgN30Xkqv+aG9PB+
	 phyijBaYTM3DY0yKI+ud9LRKaJNoNntpbddthE5owyIMLjk7Dvx0qbm4ILyadt2Rk6
	 HOXT86roMnbY3zE0f+8LtMewMfZaEUXXYhbJ3ZSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 536/552] wifi: mt76: mt7996: fix TX DMA mapping leak for AddBA req frames
Date: Fri,  4 Sep 2026 07:01:33 +0200
Message-ID: <20260904045802.766161181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit deaa2e3656937fbbe312f0ee2616c756c6e2511f upstream.

mt7996/mt7992 hand the firmware a HW MAC-TXP for AddBA req action frames
(MT_TXD7_MAC_TXD, set in mt7996_mac_write_txwi_80211()), but are otherwise
FW-TXP devices. On tx free mt76_connac_txp_skb_unmap() therefore decodes
the per-frame txp as a struct mt76_connac_fw_txp. For a MAC-TXP the
fw_txp.nbuf byte aliases the AddBA TID word (MT_TXP1_TID_ADDBA), which is
always zero, so the unmap loop runs zero times and the skb DMA mapping in
buf[1] is never unmapped. buf[1].skip_unmap is set unconditionally, so the
generic DMA-ring cleanup skips it as well.

Each AddBA req therefore leaks one TX DMA mapping, roughly one per
(re)association. With WED enabled these mappings are bounced through the
WED swiotlb pool, so under continuous client reconnect churn the pool is
exhausted after ~1-2 days, after which DMA mapping fails for WED, the WiFi
MCU and other on-SoC consumers.

Keep the deferred (token release) unmap that the design relies on, and add
an mt7996-specific txp unmap that inspects MT_TXD7_MAC_TXD and unmaps
buf[1] from the MAC-TXP layout for those frames, delegating to
mt76_connac_txp_skb_unmap() otherwise.

Cc: stable@vger.kernel.org
Fixes: cb6ebbdffef2 ("wifi: mt76: mt7996: support writing MAC TXD for AddBA Request")
Link: https://patch.msgid.link/20260722082610.2699628-13-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c |   26 +++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1279,6 +1279,30 @@ mt7996_tx_check_aggr(struct ieee80211_li
 }
 
 static void
+mt7996_txp_skb_unmap(struct mt76_dev *mdev, struct mt76_txwi_cache *t)
+{
+	u8 *txwi_ptr = mt76_get_txwi_ptr(mdev, t);
+	__le32 *txwi = (__le32 *)txwi_ptr;
+	__le32 *txp;
+	dma_addr_t addr;
+	u32 val;
+
+	if (!(le32_to_cpu(txwi[7]) & MT_TXD7_MAC_TXD)) {
+		mt76_connac_txp_skb_unmap(mdev, t);
+		return;
+	}
+
+	txp = (__le32 *)(txwi_ptr + MT_TXD_SIZE);
+	val = le32_to_cpu(txp[3]);
+	addr = le32_to_cpu(txp[2]);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	addr |= (dma_addr_t)FIELD_GET(MT_TXP3_DMA_ADDR_H, val) << 32;
+#endif
+	dma_unmap_single(mdev->dma_dev, addr, FIELD_GET(MT_TXP_BUF_LEN, val),
+			 DMA_TO_DEVICE);
+}
+
+static void
 mt7996_txwi_free(struct mt7996_dev *dev, struct mt76_txwi_cache *t,
 		 struct ieee80211_link_sta *link_sta,
 		 struct mt76_wcid *wcid, struct list_head *free_list)
@@ -1287,7 +1311,7 @@ mt7996_txwi_free(struct mt7996_dev *dev,
 	__le32 *txwi;
 	u16 wcid_idx;
 
-	mt76_connac_txp_skb_unmap(mdev, t);
+	mt7996_txp_skb_unmap(mdev, t);
 	if (!t->skb)
 		goto out;
 


