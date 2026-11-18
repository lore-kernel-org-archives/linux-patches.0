Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039549;
	b=JQ80fg7KCt5dQsU/TT9K+ZIyVVDwbzZRwZZOYjSU8zvlUvodUFHC7npjXTMHvc+UH+sl
	 sQLLAAMUMnnVR1Misfd+hGGQyOoKU471lgYymnjRnCeJAfZCiLGL3RILv4KJu2g7BqLWh
	 AQ/ajieSSWW7t71cEM5IgpGXsPPK5XPFdRVV3S5ZbNiT/3OYWJmzmHKsCNsHlWEQ6hi3b
	 zpc8MLWXotVYSUVC4X0iYqeN2B1uEc8r/BCu/jngzpfjyEeft/uumqUfaC6fJVhNLZJsi
	 UgYeKHbRx5dC7m8HCdudHD2bw6ytaCCgrptVk94zAr8tmfo4qHzvoaJJSDcMjijOquw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4td4HqBwauMqIhC0ao17kLXD97HYH8sKOOMC6lJZndc=;
	b=Znh/2uBCmvMODE25RLSNdLGulQjtLfH+Wpo8yqyzQdDEgOLPm0WVN+oyvuWfW4iSwV2U
	 TBGf0zkqIJABP7xKkq49k7Wm24eaaUdwLyORqA1W1UuROasWh9TLk1sDWkbpSI42/jLtc
	 UC0WT/Rtpj228xosKCh6p8MKqdrdFs8d8OcISrRPcIZ4eRw/oJ+GWFvQ/1H0eHb/gMq8d
	 DnWZ8kDIfNnXfVp47pobGMC91JXRvxaSZl2DNmNl8mQQBknKijYWSFuwtw4T0QftEd2Ih
	 f6hmxMyyz6ozEqiwqVV9+b71ClqTcgINqsN9W2/LvDSe4tjF15p/LOpSklDEu5wlRvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IhoEUk/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5AB606A31C;
	Wed, 18 Nov 2026 22:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IhoEUk/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBB21F000C4;
	Wed, 18 Nov 2026 22:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039549;
	bh=4td4HqBwauMqIhC0ao17kLXD97HYH8sKOOMC6lJZndc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhoEUk/MO4W5Yoimf/8EEPgM3etme/i6481yYvWcz5KgbMCGt5fM4jenXK6oyRTbH
	 7RJsPj85qc5VrZoqVb37iV8Ufz3oPoHaUA/dS5jPAOa6W8lAgzmIKoPQnZ+8toJKND
	 e6qmpq4Mei7EVkqbuBfJh0oos8lfZXnFjzy39KoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2098/3318] dmaengine: xilinx_dma: Move descriptors to done list based on completion bit
Date: Wed, 18 Nov 2026 15:45:20 +0100
Message-ID: <20261118150425.026063925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Neeli <srinivas.neeli@amd.com>

[ Upstream commit 5b585cc8778185ae7a7c9903f8cd70d562b91282 ]

In AXI MCDMA, xilinx_dma_complete_descriptor() walks the channel's
active_list and unconditionally moves every entry to the done_list. The
MCDMA IOC interrupt handler invokes this function on every
interrupt-on-completion, but with interrupt coalescing (IRQThreshold > 1)
an IOC interrupt may fire after only a subset of the queued descriptors
have actually been processed by the hardware. As a result, descriptors
whose completion bit is not yet set in the BD status were being reported
as completed to client drivers.

Add a check for the descriptor completion bit before moving entries from
the active list to the done list, using the appropriate direction-
specific status field (s2mm_status for DMA_DEV_TO_MEM, mm2s_status for
DMA_MEM_TO_DEV).

This mirrors the AXIDMA fix in commit 7bcdaa658102 ("dmaengine:
xilinx_dma: Freeup active list based on descriptor completion bit").

Fixes: 6ccd692bfb7f ("dmaengine: xilinx_dma: Add Xilinx AXI MCDMA Engine driver support")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260818174151.1608971-3-srinivas.neeli@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 02bb2d8b7cda2..47d93ac0053c2 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1765,6 +1765,17 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
 					      struct xilinx_axidma_tx_segment, node);
 			if (!(seg->hw.status & XILINX_DMA_BD_COMP_MASK) && chan->has_sg)
 				break;
+		} else if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIMCDMA) {
+			struct xilinx_aximcdma_tx_segment *seg;
+			u32 status;
+
+			seg = list_last_entry(&desc->segments,
+					      struct xilinx_aximcdma_tx_segment,
+					      node);
+			status = (chan->direction == DMA_DEV_TO_MEM) ?
+				seg->hw.s2mm_status : seg->hw.mm2s_status;
+			if (!(status & XILINX_DMA_BD_COMP_MASK))
+				break;
 		}
 		if (chan->has_sg && chan->xdev->dma_config->dmatype !=
 		    XDMA_TYPE_VDMA)
-- 
2.53.0



