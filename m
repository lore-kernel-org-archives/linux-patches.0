Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E358A3A4F34;
	Tue, 31 Mar 2026 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976174; cv=none; b=qnPUDO0oauszqnrltLd5Jram97Uv3kOJMpe63P29dB4iUQ7evHYBDw+2C/FsNhWYzUxOZ8hHvWdSCThG7n3izSFsKPNMuedXv+dP620AQaDDc20kmonD2Z9yn9oIipxBHzqQ+UXCfDysNNOH931fY130IaxdI8IPkubB62NFKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976174; c=relaxed/simple;
	bh=f7FdtSOlVrLfM+4HcRn5ck0eV0OHh6BBg1lLlvjyMEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gevX7b0daYOKaKEWJ5EU9N5XSu3SkE6iYG5QAprqhX5wZDC3dqZdutkYDbP/bXL3gE9Q0GhbmMgHWEN7bxvNnbh3st+c3BlbT2pw/+i9XgohUF5CaAiU+738NLX6EN0Z5DJUbcH/Nae1Y3eqR8wdXI2q1HkGqvSMSDxOgvbhcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyzOIUZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyzOIUZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7137EC19423;
	Tue, 31 Mar 2026 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976173;
	bh=f7FdtSOlVrLfM+4HcRn5ck0eV0OHh6BBg1lLlvjyMEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyzOIUZ9VkWl3v0MLz52i1ArjUrRZnabkqiOkhdRUIUiF4MrkNay+utjI/IfpGjXd
	 5sEbKTpDN7S/qFkfnXOwOgx1yOIhgRgQRrd7sz/z8KZdCXdlPomc1RLu4yaZHm1A2y
	 zs1sh6mVMAYqfgL/GM64bMalDkqnnZUzJ+DDAfmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/244] dmaengine: xilinx_dma: Fix reset related timeout with two-channel AXIDMA
Date: Tue, 31 Mar 2026 18:23:05 +0200
Message-ID: <20260331161750.440317034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit a17ce4bc6f4f9acf77ba416c36791a15602e53aa ]

A single AXIDMA controller can have one or two channels. When it has two
channels, the reset for both are tied together: resetting one channel
resets the other as well. This creates a problem where resetting one
channel will reset the registers for both channels, including clearing
interrupt enable bits for the other channel, which can then lead  to
timeouts as the driver is waiting for an interrupt which never comes.

The driver currently has a probe-time work around for this: when a
channel is created, the driver also resets and enables the
interrupts. With two channels the reset for the second channel will
clear the interrupt enables for the first one. The work around in the
driver is just to manually enable the interrupts again in
xilinx_dma_alloc_chan_resources().

This workaround only addresses the probe-time issue. When channels are
reset at runtime (e.g., in xilinx_dma_terminate_all() or during error
recovery), there's no corresponding mechanism to restore the other
channel's interrupt enables. This leads to one channel having its
interrupts disabled while the driver expects them to work, causing
timeouts and DMA failures.

A proper fix is a complicated matter, as we should not reset the other
channel when it's operating normally. So, perhaps, there should be some
kind of synchronization for a common reset, which is not trivial to
implement. To add to the complexity, the driver also supports other DMA
types, like VDMA, CDMA and MCDMA, which don't have a shared reset.

However, when the two-channel AXIDMA is used in the (assumably) normal
use case, providing DMA for a single memory-to-memory device, the common
reset is a bit smaller issue: when something bad happens on one channel,
or when one channel is terminated, the assumption is that we also want
to terminate the other channel. And thus resetting both at the same time
is "ok".

With that line of thinking we can implement a bit better work around
than just the current probe time work around: let's enable the
AXIDMA interrupts at xilinx_dma_start_transfer() instead.
This ensures interrupts are enabled whenever a transfer starts,
regardless of any prior resets that may have cleared them.

This approach is also more logical: enable interrupts only when needed
for a transfer, rather than at resource allocation time, and, I think,
all the other DMA types should also use this model, but I'm reluctant to
do such changes as I cannot test them.

The reset function still enables interrupts even though it's not needed
for AXIDMA anymore, but it's common code for all DMA types (VDMA, CDMA,
MCDMA), so leave it unchanged to avoid affecting other variants.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Fixes: c0bba3a99f07 ("dmaengine: vdma: Add Support for Xilinx AXI Direct Memory Access Engine")
Link: https://patch.msgid.link/20260311-xilinx-dma-fix-v2-1-a725abb66e3c@ideasonboard.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index b1c540fbcd716..a0361bcee1201 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -1216,14 +1216,6 @@ static int xilinx_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	dma_cookie_init(dchan);
 
-	if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA) {
-		/* For AXI DMA resetting once channel will reset the
-		 * other channel as well so enable the interrupts here.
-		 */
-		dma_ctrl_set(chan, XILINX_DMA_REG_DMACR,
-			      XILINX_DMA_DMAXR_ALL_IRQ_MASK);
-	}
-
 	if ((chan->xdev->dma_config->dmatype == XDMA_TYPE_CDMA) && chan->has_sg)
 		dma_ctrl_set(chan, XILINX_DMA_REG_DMACR,
 			     XILINX_CDMA_CR_SGMODE);
@@ -1591,6 +1583,7 @@ static void xilinx_dma_start_transfer(struct xilinx_dma_chan *chan)
 			     head_desc->async_tx.phys);
 	reg  &= ~XILINX_DMA_CR_DELAY_MAX;
 	reg  |= chan->irq_delay << XILINX_DMA_CR_DELAY_SHIFT;
+	reg |= XILINX_DMA_DMAXR_ALL_IRQ_MASK;
 	dma_ctrl_write(chan, XILINX_DMA_REG_DMACR, reg);
 
 	xilinx_dma_start(chan);
-- 
2.53.0



