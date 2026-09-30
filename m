Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3341A37A825;
	Wed, 30 Sep 2026 16:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785950; cv=none; b=cwUrK/13MH8b7jITNXBM767fF3cxJrfmZG6xNGzk77Gjq+MHHRZzdVhkBXfxJVARAs/KIyPbf5qrpa/+lvwIDWnWpgOxpVa0hFhfqHKfpysI52+yqE9xqvRii4xlOtnhgVPTPbe032jHhjd12HvoB9pD7m+a8rSb2op0ozKXAik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785950; c=relaxed/simple;
	bh=mc3MJs0IOSiA5HMrGGMQwasxYBqlVvt3G6r5myp11Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7k76lXqQgqrc6tvFo2r8gyEdhtjfCzReMyEfuy19k9BYdvT2xxw4W6p8DKkE910FRHPEETBqY1fcyTVhhFjUx7b1UvJymyk8hQbBZ75oEy5sPz44rXXQCUZ8zPm5CpxDkb2rU27/HtAtAh1knMqOi+QvvOGVmXcbVM63DvmkoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8lsSleT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8lsSleT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED751F000FF;
	Wed, 30 Sep 2026 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785949;
	bh=R4UOIxHBIgSmOkky5TJ+brLGJlJKArKHih+xzwc/Eeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8lsSleT4Gm3XwkW48+sGuBXVJWzQdF1zq7XZMZM135k4WqZUpiHgJ35c1ZjVjtJ4
	 03P9oUnvbnik5XKsvxVh/pbdDOSuMgbILCsLEhu7tjz5b7+TYpvhqnvAiR5JujlkhP
	 1kFLh1uuyrttKdgOusR28rxWgBJyQy7Dqyf56LGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bereza <alex@bereza.email>,
	Frank Li <Frank.Li@nxp.com>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 644/982] dmaengine: xilinx_dma: Fix hardware buffer descriptor chain after cyclic DMA
Date: Wed, 30 Sep 2026 17:23:00 +0200
Message-ID: <20260930152430.598659745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 53e791513b7e0..5fb423261c3f0 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -725,15 +725,25 @@ xilinx_aximcdma_alloc_tx_segment(struct xilinx_dma_chan *chan)
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
@@ -755,7 +765,7 @@ static void xilinx_mcdma_clean_hw_desc(struct xilinx_aximcdma_desc_hw *hw)
 static void xilinx_dma_free_tx_segment(struct xilinx_dma_chan *chan,
 				struct xilinx_axidma_tx_segment *segment)
 {
-	xilinx_dma_clean_hw_desc(&segment->hw);
+	xilinx_dma_clean_hw_desc(chan, segment);
 
 	list_add_tail(&segment->node, &chan->free_seg_list);
 }
-- 
2.53.0



