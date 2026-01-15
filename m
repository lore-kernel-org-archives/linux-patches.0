Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFDA274FE3;
	Thu, 15 Jan 2026 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499030; cv=none; b=XqXPgNaxw9U7nGfvBv6Tw1bcUws3refyc9cvEuzi3Y1UFAs7xFK8/ZWrP8B5fajl8bJl4FTWX/Rs+tQ3QwID4/tUbhcJO8hrqh1cWmOvJkT6r57W/hwfI345CxuFuHaNlhvbAW8+fFnHUBgBCEAVJVdGe2CAXvQMmYCkH9bqpb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499030; c=relaxed/simple;
	bh=nz0ar0bhxMkxoCljRVPalxRKyfjzq+N64XcSXu40b8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt4VxibSVvAZYvbj8hfd+aVEebLzVj+Ir901Bw1SxwMRX6GxWIEff56/3ZaXz6K3hFxabZJxh/sryshVmdCDv+uDIHvC1zd4ICVmBdLeDthZnIZ/KdXUqYn/BvDdeklBb+uwefml8EXPuwjeRVP/D5I+09b5GU2i1g19vdCx/i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ga+uyYq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ga+uyYq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEE4C116D0;
	Thu, 15 Jan 2026 17:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499029;
	bh=nz0ar0bhxMkxoCljRVPalxRKyfjzq+N64XcSXu40b8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ga+uyYq3ZipzgohhQzpQgbwe7bcEq+kZAy8lOWANN8OWzVcX/jzcuvWL1Y3gcVh95
	 OUuFWI7s3Ni/2ycFw0armsACoGc3YTPWWegH2+wi3GRaVt90LV6dem48Hl54WPLGC0
	 81QJ1DK9j/hMOMxCGkT6Av2uZhHGhHbgXYueJFEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/451] wifi: rtl818x: Fix potential memory leaks in rtl8180_init_rx_ring()
Date: Thu, 15 Jan 2026 17:44:43 +0100
Message-ID: <20260115164233.882427146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 025619cd14e82..acd6743f3827f 100644
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



