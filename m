Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BC63DA7DD;
	Wed, 30 Sep 2026 19:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796036; cv=none; b=mocOIIEQGu9/xq6akynHNqTCdnNJV0kzAy9pUDTF2nIPNfhMJlf49AXnRE5WLoKN7Q/n/79DorOMxspTsq2Bw1xa1SZBC3CpK4rtiknJdiPLmBgQF6qjZ3tl8z3OBqXy0T0mjjQ7DN/9iVYwTCfTvqU6bdKQh3CpNk5lJMTqTjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796036; c=relaxed/simple;
	bh=LI5xdKT3j4KWBPL8pbzYLchlWBuUhgi0D+HWGoOEMHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC/BsRRA1QVnze0TYBtXsmZ+NmH1eUE5ZQSFLhyvgARVTJ9F0rYLjlOwCYny5aly1y/nAbCzz1uzFO6Nn/1CB2jyNW8mlXL7Yy/sATH44vaBbK90pWTt77Pi/DEHPBhgMMBtOTpDWg0vjGzP+PVn1rIQ5Muv0YskXq7eFlGkTDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUznUFB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUznUFB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6041F000FF;
	Wed, 30 Sep 2026 19:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796034;
	bh=+5euOAuKPWnOcJH1JUfKEJhvY2wB9euskiLv+tvwhLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUznUFB4HJgNsD+uQ6kpTCA18qJNOoulOpCrWSv5tYWKoCJTnUeA62is7PtRpCSPA
	 InBYNPIi8pSLz1cdNXOe9jZETJMmWadoxf3DqIUhFXq/pE3lhtGdG5cNtoUNCd8455
	 +cpK0zrFeGENye+vXyQf6O5oJf8tC/UZcKhfY7+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0772/1193] dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA
Date: Wed, 30 Sep 2026 17:24:16 +0200
Message-ID: <20260930152451.408557552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bereza <alex@bereza.email>

[ Upstream commit 7ed1e3070c9b4bbd67d5519e14711038dd53ab13 ]

Using the DMA in cyclic mode modifies the hardware buffer descriptor
chain in xilinx_dma_prep_dma_cyclic so that the last descriptor used by
the cyclic transfer points back to the first descriptor, but it never
restores the original descriptor ring. This breaks using non-cyclic mode
after cyclic mode with an error like:

  xilinx-vdma 86000000.dma: Channel 00000000354d5c8d has errors 100, cdr 6de40000 tdr 6de40400

The only way to get out of this error state is to rebuild the hardware
buffer descriptor ring by releasing and re-acquiring the channel.

Fix using non-cyclic mode after cyclic mode by always restoring the
original buffer descriptor ring in the same manner as it is set up by
xilinx_dma_alloc_chan_resources().

Fixes: 23059408b6a3 ("dmaengine: xilinx_dma: Fix race condition in the driver for multiple descriptor scenario")
Signed-off-by: Alex Bereza <alex@bereza.email>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Link: https://patch.msgid.link/20260817-fix-hw-buf-desc-after-cyclic-mode-v1-1-1fe47e701d6c@bereza.email
Link: https://patch.msgid.link/20260818-fix-hw-buf-desc-after-cyclic-mode-v2-1-530ff44c6a81@bereza.email
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 6191443a42b7e..1e1d8829cd815 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -751,15 +751,25 @@ xilinx_aximcdma_alloc_tx_segment(struct xilinx_dma_chan *chan)
 	return segment;
 }
 
-static void xilinx_dma_clean_hw_desc(struct xilinx_axidma_desc_hw *hw)
+static void xilinx_dma_clean_hw_desc(struct xilinx_dma_chan *chan,
+				     struct xilinx_axidma_tx_segment *segment)
 {
-	u32 next_desc = hw->next_desc;
-	u32 next_desc_msb = hw->next_desc_msb;
+	dma_addr_t next;
+	u32 i;
 
-	memset(hw, 0, sizeof(struct xilinx_axidma_desc_hw));
+	/*
+	 * Restore the buffer descriptor's next descriptor pointer to the value
+	 * set up in xilinx_dma_alloc_chan_resources(). Otherwise using the DMA
+	 * in cyclic mode leaves the next descriptor pointer altered and
+	 * prevents subsequent non-cyclic transfers.
+	 */
+	i = segment - chan->seg_v;
+	next = chan->seg_p +
+	       sizeof(*chan->seg_v) * ((i + 1) % XILINX_DMA_NUM_DESCS);
 
-	hw->next_desc = next_desc;
-	hw->next_desc_msb = next_desc_msb;
+	memset(&segment->hw, 0, sizeof(segment->hw));
+	segment->hw.next_desc = lower_32_bits(next);
+	segment->hw.next_desc_msb = upper_32_bits(next);
 }
 
 static void xilinx_mcdma_clean_hw_desc(struct xilinx_aximcdma_desc_hw *hw)
@@ -781,7 +791,7 @@ static void xilinx_mcdma_clean_hw_desc(struct xilinx_aximcdma_desc_hw *hw)
 static void xilinx_dma_free_tx_segment(struct xilinx_dma_chan *chan,
 				struct xilinx_axidma_tx_segment *segment)
 {
-	xilinx_dma_clean_hw_desc(&segment->hw);
+	xilinx_dma_clean_hw_desc(chan, segment);
 
 	list_add_tail(&segment->node, &chan->free_seg_list);
 }
-- 
2.53.0



