Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB49370AFD;
	Wed, 23 Sep 2026 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172911; cv=none; b=DGvNFqRAhnKZ3645ERQN545isstKLFUjF37Id1qDim103fLj78Xtw58IU5mPy6V3R/0HyuFYzQsWeHcRfbKRsIfgJ30bnY5cyQHMb/gy5llEuJWTLgG8ERZbjijDtlHeFSE9jSRSh2/9Twx1ZqV1RaWubdgTfhLNCUyjrSZ3+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172911; c=relaxed/simple;
	bh=vSweNF9alXqDYIM+Uh5JsRqaYkRG3IwKH7ONzv4nX3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMzOpTBYZLkwmppf9EaYv07z0NQiFeUk8fPnyMvogoOGFS5mxKlTd7RBqGedgvpYcwl04evvrnKBVjAn85ImhQeXHdXHoBnFlz8mVoJ0ZiiOB69l8NToCRAPaYpBH+FUmt7V1G/AZHjuNy8JPz+MFwHX+/eOHnenYTTU1L54S+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdVeGLhl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdVeGLhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F561F00893;
	Wed, 23 Sep 2026 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172909;
	bh=eu5i573xkiwGQXdRlRSdTdVh8X7105tYhjP458sfRu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdVeGLhlaEDScNmltFuftcSZu2e0rSp293csGGVhuMhEoYBlpkk+H6E1dvkMJy9hy
	 NNXQuWTZSqQigEdHTtaTUGMgLoF3mwPP5TOIOkSI7Jv4litGrmG7Q2sDZM93wk615M
	 WNTfIWBVmj17L2Xxb0uYDUn8zlvUg1sZuxxM89zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 097/438] dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA
Date: Wed, 23 Sep 2026 16:01:58 +0200
Message-ID: <20260923140647.291940800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0e62e523d0ccd..12cf1ca3a98a1 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -756,15 +756,25 @@ xilinx_aximcdma_alloc_tx_segment(struct xilinx_dma_chan *chan)
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
@@ -786,7 +796,7 @@ static void xilinx_mcdma_clean_hw_desc(struct xilinx_aximcdma_desc_hw *hw)
 static void xilinx_dma_free_tx_segment(struct xilinx_dma_chan *chan,
 				struct xilinx_axidma_tx_segment *segment)
 {
-	xilinx_dma_clean_hw_desc(&segment->hw);
+	xilinx_dma_clean_hw_desc(chan, segment);
 
 	list_add_tail(&segment->node, &chan->free_seg_list);
 }
-- 
2.53.0



