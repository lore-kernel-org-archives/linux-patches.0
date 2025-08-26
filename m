Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4814435E4D0;
	Tue, 26 Aug 2025 14:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218993; cv=none; b=eLGMgTWhTrzrNxCPq52SLLnT3wYc+6MTPQQYI1vedoqE3LQn+eauQ7DrHuXLQX+9TWaxp87U/JN6styZC23PfAOF3+z8tXIFKCiXfQnOriUpXX7U9jZWRG+z5GOmmy9LWPWsFiADicM1itfyQh1e5XX13okPlaxzogrZN04O3fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218993; c=relaxed/simple;
	bh=9Db9kURQ4+HkMRvJmKU4Ur0PKGTJogpfqcrRaEhzMNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqsqAVyXGydsJF5rhawqa7OJYCqiJ3xG8QRqZ+7IKtVXQeMUrqAyWBk1KWdJFQgU7CUANvOPIak1jQdzgZ+vtW3bic2TUf21uONHYiy4bHpSJ0/b1h1Vn+V7fGHMLjEUnB8rT+aJKTwJOGzyfG0oyxct0eVxuZjf3UYmBEmWdWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5NV17fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5NV17fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B625C113CF;
	Tue, 26 Aug 2025 14:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218992;
	bh=9Db9kURQ4+HkMRvJmKU4Ur0PKGTJogpfqcrRaEhzMNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5NV17fo2y7VGAtvB5f7f68KuRep8DVya1W0yXPaZ/wTuWA+E04bGUNQGgLvKYMv1
	 olHrHuvUlqOvnGmLoLAm+lmxSbmBMpZCdMcVJBzTT7LTwM/4MxFmDf8jK9A2UVwaI4
	 0oTjWystz6CV/wyBCsdsBqmiQMizu153BgjXd4uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/403] net: ag71xx: Add missing check after DMA map
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826110912.672183598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 58a002dd758c..ba07817d0a22 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1049,6 +1049,11 @@ static bool ag71xx_fill_rx_buf(struct ag71xx *ag, struct ag71xx_buf *buf,
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
@@ -1343,6 +1348,10 @@ static netdev_tx_t ag71xx_hard_start_xmit(struct sk_buff *skb,
 
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



