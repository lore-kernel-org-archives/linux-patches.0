Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEA532D43C;
	Mon, 13 Apr 2026 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099362; cv=none; b=TehR6BG02mVQBkQzL12LZp4bJQnPYDtqdb/lzhyasFUV23Lbd/LVv+RB+ZXGoC8+dQXjf3CRaKg5l1xhJhh9LgGM6NN3giSXyIlpk/4hhzWQBcrSUN6+v/oXUG7hZ8E1hVj+F4MuinnS2wsc5z3B77bAooJ54/2evrLngLxOtUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099362; c=relaxed/simple;
	bh=cPgOA4ZtCRdFW6F8e7iF+CizhqFZeO03Iw5phQrlaSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oecSl+qs1LCH2J2drEp75ekhBMJTmK9SeEEQBEyAXfFDuLzQEFe1aspDkbiYF7TjdaO4ww5gsL4lEZmi95wrNf4flKmzIXrw84u4G0IM2UtbfSyTSzCUL9YmUeX1MpXo6XYORNUsOW0/bYyMXa1MQkD/9SxQPeGZLFBZ1a6kP/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMZ/HO5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMZ/HO5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FBC2BCB0;
	Mon, 13 Apr 2026 16:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099362;
	bh=cPgOA4ZtCRdFW6F8e7iF+CizhqFZeO03Iw5phQrlaSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMZ/HO5d3c801juJyPkUBe73VG40/aV5RW5CzwTATx62WdHK+TWjsg/MqfI/Vw5ko
	 sb1LPa9fdMt2/nz91tyiGqeKYPU/fDeKmORC0dXkIDmWp1fMVZ5RZliHrkk1NEqYef
	 rZtKpOA5TzO/eg+370L7GjYZ8Wjm3NEvJQdPjIs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 310/491] dmaengine: xilinx: xilinx_dma: Fix residue calculation for cyclic DMA
Date: Mon, 13 Apr 2026 17:59:15 +0200
Message-ID: <20260413155830.646039744@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit f61d145999d61948a23cd436ebbfa4c3b9ab8987 ]

The cyclic DMA calculation is currently entirely broken and reports
residue only for the first segment. The problem is twofold.

First, when the first descriptor finishes, it is moved from active_list
to done_list, but it is never returned back into the active_list. The
xilinx_dma_tx_status() expects the descriptor to be in the active_list
to report any meaningful residue information, which never happens after
the first descriptor finishes. Fix this up in xilinx_dma_start_transfer()
and if the descriptor is cyclic, lift it from done_list and place it back
into active_list list.

Second, the segment .status fields of the descriptor remain dirty. Once
the DMA did one pass on the descriptor, the .status fields are populated
with data by the DMA, but the .status fields are not cleared before reuse
during the next cyclic DMA round. The xilinx_dma_get_residue() recognizes
that as if the descriptor was complete and had 0 residue, which is bogus.
Reinitialize the status field before placing the descriptor back into the
active_list.

Fixes: c0bba3a99f07 ("dmaengine: vdma: Add Support for Xilinx AXI Direct Memory Access Engine")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316221943.160375-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 0d0f3df71245d..ca80a1dee8489 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1514,8 +1514,29 @@ static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
 	if (chan->err)
 		return;
 
-	if (list_empty(&chan->pending_list))
+	if (list_empty(&chan->pending_list)) {
+		if (chan->cyclic) {
+			struct xilinx_dma_tx_descriptor *desc;
+			struct list_head *entry;
+
+			desc = list_last_entry(&chan->done_list,
+					       struct xilinx_dma_tx_descriptor, node);
+			list_for_each(entry, &desc->segments) {
+				struct xilinx_axidma_tx_segment *axidma_seg;
+				struct xilinx_axidma_desc_hw *axidma_hw;
+				axidma_seg = list_entry(entry,
+							struct xilinx_axidma_tx_segment,
+							node);
+				axidma_hw = &axidma_seg->hw;
+				axidma_hw->status = 0;
+			}
+
+			list_splice_tail_init(&chan->done_list, &chan->active_list);
+			chan->desc_pendingcount = 0;
+			chan->idle = false;
+		}
 		return;
+	}
 
 	if (!chan->idle)
 		return;
-- 
2.53.0



