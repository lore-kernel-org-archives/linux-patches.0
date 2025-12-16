Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AF9355027;
	Tue, 16 Dec 2025 11:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885847; cv=none; b=r5Ksykd0DSDMwwQw+ItGT0hxPV72Qrl/gv2grSHpcBmQk+hYFxKeJtLy/UtA91WADsJDwimJa43Qj5WKIAWOpPrXDZThKcpzEOpx9mn+BKzXUbgb8fB+ElMI2poK9sqNvDIc2I0BiIjjmD10DALFOpJERw24nPDv93MtbBnMYSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885847; c=relaxed/simple;
	bh=iNzDm+LT419HreyIbpWoliAa4MqZmoUk66EaWJu4Z38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNsTktNKn57w4IuI3Y5od/0giFlIzgvL/p2MFXaxWuByKLphiKljM0U1Y4BBuOrii/U45AJ2566AE1P88O7+VzKVeu+rRtJ/6PTsm502uvLwCCxIBzF59gZZfFDc0uwYhs4aBoCFqIB9d3D0YYB0eOkqRAY2YvbLMEakhHx6YzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDFjwqfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDFjwqfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A056C4CEF1;
	Tue, 16 Dec 2025 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885847;
	bh=iNzDm+LT419HreyIbpWoliAa4MqZmoUk66EaWJu4Z38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDFjwqfCbSNeI5yye11QrcuMDILLzKrE1y6Tx6wo2NuWbUswsINOL7iEPXIMEJPPu
	 3jat+kqd6Y86Ggug8+9xbua2jB3F7rIky+CoXc+DDFKqr5BK6FsliEmlH8d/bq2hT8
	 Mczx0Dk9sdU6qUtgQyk93JjW2se3034H8y5VXFtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 262/507] wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()
Date: Tue, 16 Dec 2025 12:11:43 +0100
Message-ID: <20251216111354.979363361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 9b5b9c042b30befc5b37e4539ace95af70843473 ]

In rtl8180_init_rx_ring(), memory is allocated for skb packets and DMA
allocations in a loop. When an allocation fails, the previously
successful allocations are not freed on exit.

Fix that by jumping to err_free_rings label on error, which calls
rtl8180_free_rx_ring() to free the allocations. Remove the free of
rx_ring in rtl8180_init_rx_ring() error path, and set the freed
priv->rx_buf entry to null, to avoid double free.

Fixes: f653211197f3 ("Add rtl8180 wireless driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251114094527.79842-1-nihaal@cse.iitm.ac.in
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index 2905baea62390..070c0431c4821 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1023,9 +1023,6 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		dma_addr_t *mapping;
 		entry = priv->rx_ring + priv->rx_ring_sz*i;
 		if (!skb) {
-			dma_free_coherent(&priv->pdev->dev,
-					  priv->rx_ring_sz * 32,
-					  priv->rx_ring, priv->rx_ring_dma);
 			wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
 			return -ENOMEM;
 		}
@@ -1037,9 +1034,7 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 
 		if (dma_mapping_error(&priv->pdev->dev, *mapping)) {
 			kfree_skb(skb);
-			dma_free_coherent(&priv->pdev->dev,
-					  priv->rx_ring_sz * 32,
-					  priv->rx_ring, priv->rx_ring_dma);
+			priv->rx_buf[i] = NULL;
 			wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
 			return -ENOMEM;
 		}
@@ -1130,7 +1125,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	ret = rtl8180_init_rx_ring(dev);
 	if (ret)
-		return ret;
+		goto err_free_rings;
 
 	for (i = 0; i < (dev->queues + 1); i++)
 		if ((ret = rtl8180_init_tx_ring(dev, i, 16)))
-- 
2.51.0



