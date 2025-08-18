Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7C8322A07;
	Mon, 18 Aug 2025 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523585; cv=none; b=aeFbf5TT1+AgpbASA0gAYsHVSbqE63yb78WAC7y4v6In7EwmqubWU86mHuD7tYGx9as2zbbMErVMOLvWGwuo4sDmfx9X3pQwGUFVEw8d5NwzYq99nKgQ1vQy9c7na7sd3Cdi0hAg29yaxnNfIChA1IPujGn0lNPFyTDqRqZhGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523585; c=relaxed/simple;
	bh=rxMF7g2jlaGJsl05a5P9ltISdQKX5YGTyJa9FfeipE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwVwyJGi8khvMq/chMY/cwSgy19OkhHwJ9/OxTvbvfbZ2NG9RYG7iQw4EVmDm+AtfV+XkkHc3xC7shcx6T8WZbaAmA+LqYtEam4eliAb5TMVXnUSIkPHQN9rjHS+kMPKkyvnhKdVMjubbKUJF4Ksbp7s21c84pstrffyx/Dh1ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrBSFz2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrBSFz2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41CBC4CEEB;
	Mon, 18 Aug 2025 13:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523585;
	bh=rxMF7g2jlaGJsl05a5P9ltISdQKX5YGTyJa9FfeipE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrBSFz2Yd/ST+AHOSqcr38188T1pY7GIjWyz0crpax2o82BlyAFdQAdE2h1d3DxBe
	 IoUlYVZF3iEO+NBJva9ZkY+imdNjvO3tqWHLHQTstbeS3hFH8azXjMx1pjjcc7Ez1Q
	 KCgoR8KUaLhLOSLL5nHu/9XQ5m6aMyQiiZWA2ibQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 215/515] net: ag71xx: Add missing check after DMA map
Date: Mon, 18 Aug 2025 14:43:21 +0200
Message-ID: <20250818124506.648952861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 96a1e15e60216b52da0e6da5336b6d7f5b0188b0 ]

The DMA map functions can fail and should be tested for errors.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250716095733.37452-3-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 67b654889cae..d1be8928b985 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1213,6 +1213,11 @@ static bool ag71xx_fill_rx_buf(struct ag71xx *ag, struct ag71xx_buf *buf,
 	buf->rx.rx_buf = data;
 	buf->rx.dma_addr = dma_map_single(&ag->pdev->dev, data, ag->rx_buf_size,
 					  DMA_FROM_DEVICE);
+	if (dma_mapping_error(&ag->pdev->dev, buf->rx.dma_addr)) {
+		skb_free_frag(data);
+		buf->rx.rx_buf = NULL;
+		return false;
+	}
 	desc->data = (u32)buf->rx.dma_addr + offset;
 	return true;
 }
@@ -1511,6 +1516,10 @@ static netdev_tx_t ag71xx_hard_start_xmit(struct sk_buff *skb,
 
 	dma_addr = dma_map_single(&ag->pdev->dev, skb->data, skb->len,
 				  DMA_TO_DEVICE);
+	if (dma_mapping_error(&ag->pdev->dev, dma_addr)) {
+		netif_dbg(ag, tx_err, ndev, "DMA mapping error\n");
+		goto err_drop;
+	}
 
 	i = ring->curr & ring_mask;
 	desc = ag71xx_ring_desc(ring, i);
-- 
2.39.5



