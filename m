Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CDB3218CF;
	Mon, 18 Aug 2025 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521988; cv=none; b=lCx8WA7D5q57WFbv5QXv4LRPQAgmxTweuIzF9fqRrcuR8WbeRdEM9ZZgow1eYGTA06CBLTbGHUoxHy+o7Wv/w8DQGGj2g2OYAW2gbzh2nUnMhti49+LIBpfZI61EYifzGYu3fIy5vR3TbS0qiMD7dFKLJJd/7yKDUMb/38FlVoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521988; c=relaxed/simple;
	bh=eU7vc+gS93dxezLZZs5C/rcS0WiWvig9w3lm+cgN7Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iz9V1fP6vwZO7R2ll2w2JEoIf8L5EA+jN7QEyEWJDXTwpZgWimhH+IM76oJ2RIzlReCxozSD30jjrKT6DxMtljkei4bDqNyVSFKeELVQA2zmbbcV9Zfbw0If/iT8SDfkzX0pYQRmxdfLnrjbY2JV1zW2effK4BNl+H7I03O8rmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wygr+Rg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wygr+Rg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F1C4CEEB;
	Mon, 18 Aug 2025 12:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521987;
	bh=eU7vc+gS93dxezLZZs5C/rcS0WiWvig9w3lm+cgN7Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wygr+Rg9u/iotBQYmnyw5hflyleSShGbU6/gML08dR7Mabv89P6sO57wybXt4gMO9
	 NSZSWuTLi9qtJFmuqFUhHW+Ij43zi390u8rWMnugYlxMydkTlkqbeQxQg6XXBL7rt2
	 iRrpaG6FKvxJrDD0I70Qqr7UkPe0ic9Vrc1OtNtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/444] net: ag71xx: Add missing check after DMA map
Date: Mon, 18 Aug 2025 14:43:26 +0200
Message-ID: <20250818124455.624024256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 9586b6894f7e..bccc7e7b2a84 100644
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



