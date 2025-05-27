Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8420627FD6E;
	Tue, 27 May 2025 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366692; cv=none; b=Pw74tac41eNPGEnBUgPQBiAe0Degj6PSdUUDqEwmOI1c/X09y8Tc35JzOi0uuIbrcsjVIxXU9afTkxVSmelnbSjrFQDnSEGmzterj/8YS8C/rz6Pt1275nnlH8BeMKDpJJtEvxHtVkZUgWXKiV9PfJe0g0zPxraVjaaHjZwAnkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366692; c=relaxed/simple;
	bh=CimIsZoKUcMt+tFESbFN+ZspBRCiMOGX8MPXb6CHx98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJzQFLncmvv8Jh3WwiqqnSup074BelcoYsdowKKPUYx7LOygg/IXx1HwnWeGlFnWUKf9AXVlHo/LmpgKvKReTr7aPt6+wu/K5SLj/foi0351XVnT64zFdCL2rKTWpcqyrOkCaH+pOvesW1wdFa+cC8As09qWmqHQpU5hUwzHjbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrozxtlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrozxtlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF789C4CEED;
	Tue, 27 May 2025 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366692;
	bh=CimIsZoKUcMt+tFESbFN+ZspBRCiMOGX8MPXb6CHx98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrozxtlDkH2x530jJCeZDhv/IrDNFmm62LYYxYKfW+8K6yy8cB7IicjB3gD0Z6YHM
	 KKebxyRkK1wA4pf1MDYLE6+5+z70lBCUHUgS3+T+oZyJpTzgDbv6VXiPc0vP/qFJKo
	 YLZSpJkFxWKwR84MoxqdHlqb8la7Ft04n7BxuKY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 120/783] wifi: mt76: mt7996: revise TXS size
Date: Tue, 27 May 2025 18:18:37 +0200
Message-ID: <20250527162518.033398283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 593c829b4326f7b3b15a69e97c9044ecbad3c319 ]

Size of MPDU/PPDU TXS is 12 DWs.
In mt7996/mt7992, last 4 DWs are reserved, so TXS size was mistakenly
considered to be 8 DWs. However, in mt7990, 9th DW of TXS starts to be used.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20250311103646.43346-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c       | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
index db0c29e65185c..487ad716f872a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
@@ -314,6 +314,9 @@ enum tx_frag_idx {
 #define MT_TXFREE_INFO_COUNT		GENMASK(27, 24)
 #define MT_TXFREE_INFO_STAT		GENMASK(29, 28)
 
+#define MT_TXS_HDR_SIZE			4 /* Unit: DW */
+#define MT_TXS_SIZE			12 /* Unit: DW */
+
 #define MT_TXS0_BW			GENMASK(31, 29)
 #define MT_TXS0_TID			GENMASK(28, 26)
 #define MT_TXS0_AMPDU			BIT(25)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 88f9d9059d5f2..c7e8336027334 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1413,7 +1413,7 @@ bool mt7996_rx_check(struct mt76_dev *mdev, void *data, int len)
 		mt7996_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
-		for (rxd += 4; rxd + 8 <= end; rxd += 8)
+		for (rxd += MT_TXS_HDR_SIZE; rxd + MT_TXS_SIZE <= end; rxd += MT_TXS_SIZE)
 			mt7996_mac_add_txs(dev, rxd);
 		return false;
 	case PKT_TYPE_RX_FW_MONITOR:
@@ -1456,7 +1456,7 @@ void mt7996_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 		mt7996_mcu_rx_event(dev, skb);
 		break;
 	case PKT_TYPE_TXS:
-		for (rxd += 4; rxd + 8 <= end; rxd += 8)
+		for (rxd += MT_TXS_HDR_SIZE; rxd + MT_TXS_SIZE <= end; rxd += MT_TXS_SIZE)
 			mt7996_mac_add_txs(dev, rxd);
 		dev_kfree_skb(skb);
 		break;
-- 
2.39.5



