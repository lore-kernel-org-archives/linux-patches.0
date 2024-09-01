Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57F33987;
	Sun,  1 Sep 2024 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208024; cv=none; b=cf96cpR0ctHukPe7iHz1aqhBke1YM5pj8e8hDwYW3r8El4TNnQRpUk0awmqM3UyAmhvL7zjn6yMrswSezjushdxGrPBwwbfWCuwjVzr0B5xskzcs72HCpddDcBAIIGetwNu7dfgmtgZCXbo+ls5r+7bg5kObqAByhYMh4mDHR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208024; c=relaxed/simple;
	bh=aUbNtGMm0wlfxgfZicZwG7di0ehBUmyYMJiqvAGQJ1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TICCoAqcUFsNxSebYYarA/KSeucZ6RhsBx/jLzmyyp1OBjCvM0ICY5y3MNd54IxN3jud0Lvv9BnMLtIg0z1mgxjs+A/oLkcbpF4QXm+cc40I/Q3VXv811EjuyMWP6Sijg/DQx7d7f7ei48+IYaa9Ab3XKlT/QGVX74ST0y9t6TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+kcHEnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+kcHEnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927BBC4CEC3;
	Sun,  1 Sep 2024 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208024;
	bh=aUbNtGMm0wlfxgfZicZwG7di0ehBUmyYMJiqvAGQJ1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+kcHEnmbyEa8nsDQq6jMcsDqyK3YKj3FCKkcgpwWqoP4FAvBEEMlFGAzeDuUw+qF
	 cw6xzboWn8WLLYBHRlEp5yUt6yrPoZF7gODeixDUlpaz2WeYW5aJnRMkIebF37sGhy
	 a3MCh/27u00b3fxhO//46i4BsRtX/riLhX7KruB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/93] dmaengine: dw: Add memory bus width verification
Date: Sun,  1 Sep 2024 18:16:37 +0200
Message-ID: <20240901160809.247695958@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit d04b21bfa1c50a2ade4816cab6fdc91827b346b1 ]

Currently in case of the DEV_TO_MEM or MEM_TO_DEV DMA transfers the memory
data width (single transfer width) is determined based on the buffer
length, buffer base address or DMA master-channel max address width
capability. It isn't enough in case of the channel disabling prior the
block transfer is finished. Here is what DW AHB DMA IP-core databook says
regarding the port suspension (DMA-transfer pause) implementation in the
controller:

"When CTLx.SRC_TR_WIDTH < CTLx.DST_TR_WIDTH and the CFGx.CH_SUSP bit is
high, the CFGx.FIFO_EMPTY is asserted once the contents of the FIFO do not
permit a single word of CTLx.DST_TR_WIDTH to be formed. However, there may
still be data in the channel FIFO, but not enough to form a single
transfer of CTLx.DST_TR_WIDTH. In this scenario, once the channel is
disabled, the remaining data in the channel FIFO is not transferred to the
destination peripheral."

So in case if the port gets to be suspended and then disabled it's
possible to have the data silently discarded even though the controller
reported that FIFO is empty and the CTLx.BLOCK_TS indicated the dropped
data already received from the source device. This looks as if the data
somehow got lost on a way from the peripheral device to memory and causes
problems for instance in the DW APB UART driver, which pauses and disables
the DMA-transfer as soon as the recv data timeout happens. Here is the way
it looks:

 Memory <------- DMA FIFO <------ UART FIFO <---------------- UART
  DST_TR_WIDTH -+--------|       |         |
                |        |       |         |                No more data
   Current lvl -+--------|       |---------+- DMA-burst lvl
                |        |       |---------+- Leftover data
                |        |       |---------+- SRC_TR_WIDTH
               -+--------+-------+---------+

In the example above: no more data is getting received over the UART port
and BLOCK_TS is not even close to be fully received; some data is left in
the UART FIFO, but not enough to perform a bursted DMA-xfer to the DMA
FIFO; some data is left in the DMA FIFO, but not enough to be passed
further to the system memory in a single transfer. In this situation the
8250 UART driver catches the recv timeout interrupt, pauses the
DMA-transfer and terminates it completely, after which the IRQ handler
manually fetches the leftover data from the UART FIFO into the
recv-buffer. But since the DMA-channel has been disabled with the data
left in the DMA FIFO, that data will be just discarded and the recv-buffer
will have a gap of the "current lvl" size in the recv-buffer at the tail
of the lately received data portion. So the data will be lost just due to
the misconfigured DMA transfer.

Note this is only relevant for the case of the transfer suspension and
_disabling_. No problem will happen if the transfer will be re-enabled
afterwards or the block transfer is fully completed. In the later case the
"FIFO flush mode" will be executed at the transfer final stage in order to
push out the data left in the DMA FIFO.

In order to fix the denoted problem the DW AHB DMA-engine driver needs to
make sure that the _bursted_ source transfer width is greater or equal to
the single destination transfer (note the HW databook describes more
strict constraint than actually required). Since the peripheral-device
side is prescribed by the client driver logic, the memory-side can be only
used for that. The solution can be easily implemented for the DEV_TO_MEM
transfers just by adjusting the memory-channel address width. Sadly it's
not that easy for the MEM_TO_DEV transfers since the mem-to-dma burst size
is normally dynamically determined by the controller. So the only thing
that can be done is to make sure that memory-side address width is greater
than the peripheral device address width.

Fixes: a09820043c9e ("dw_dmac: autoconfigure data_width or get it via platform data")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20240802075100.6475-3-fancer.lancer@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw/core.c | 51 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 11e269a31a092..b341a6f1b0438 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -622,12 +622,10 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	struct dw_desc		*prev;
 	struct dw_desc		*first;
 	u32			ctllo, ctlhi;
-	u8			m_master = dwc->dws.m_master;
-	u8			lms = DWC_LLP_LMS(m_master);
+	u8			lms = DWC_LLP_LMS(dwc->dws.m_master);
 	dma_addr_t		reg;
 	unsigned int		reg_width;
 	unsigned int		mem_width;
-	unsigned int		data_width = dw->pdata->data_width[m_master];
 	unsigned int		i;
 	struct scatterlist	*sg;
 	size_t			total_len = 0;
@@ -661,7 +659,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = __ffs(data_width | mem | len);
+			mem_width = __ffs(sconfig->src_addr_width | mem | len);
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -721,7 +719,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			lli_write(desc, sar, reg);
 			lli_write(desc, dar, mem);
 			lli_write(desc, ctlhi, ctlhi);
-			mem_width = __ffs(data_width | mem);
+			mem_width = __ffs(sconfig->dst_addr_width | mem);
 			lli_write(desc, ctllo, ctllo | DWC_CTLL_DST_WIDTH(mem_width));
 			desc->len = dlen;
 
@@ -813,6 +811,41 @@ static int dwc_verify_p_buswidth(struct dma_chan *chan)
 	return 0;
 }
 
+static int dwc_verify_m_buswidth(struct dma_chan *chan)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct dw_dma *dw = to_dw_dma(chan->device);
+	u32 reg_width, reg_burst, mem_width;
+
+	mem_width = dw->pdata->data_width[dwc->dws.m_master];
+
+	/*
+	 * It's possible to have a data portion locked in the DMA FIFO in case
+	 * of the channel suspension. Subsequent channel disabling will cause
+	 * that data silent loss. In order to prevent that maintain the src and
+	 * dst transfer widths coherency by means of the relation:
+	 * (CTLx.SRC_TR_WIDTH * CTLx.SRC_MSIZE >= CTLx.DST_TR_WIDTH)
+	 * Look for the details in the commit message that brings this change.
+	 *
+	 * Note the DMA configs utilized in the calculations below must have
+	 * been verified to have correct values by this method call.
+	 */
+	if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV) {
+		reg_width = dwc->dma_sconfig.dst_addr_width;
+		if (mem_width < reg_width)
+			return -EINVAL;
+
+		dwc->dma_sconfig.src_addr_width = mem_width;
+	} else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM) {
+		reg_width = dwc->dma_sconfig.src_addr_width;
+		reg_burst = rounddown_pow_of_two(dwc->dma_sconfig.src_maxburst);
+
+		dwc->dma_sconfig.dst_addr_width = min(mem_width, reg_width * reg_burst);
+	}
+
+	return 0;
+}
+
 static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
@@ -822,14 +855,18 @@ static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
 
 	dwc->dma_sconfig.src_maxburst =
-		clamp(dwc->dma_sconfig.src_maxburst, 0U, dwc->max_burst);
+		clamp(dwc->dma_sconfig.src_maxburst, 1U, dwc->max_burst);
 	dwc->dma_sconfig.dst_maxburst =
-		clamp(dwc->dma_sconfig.dst_maxburst, 0U, dwc->max_burst);
+		clamp(dwc->dma_sconfig.dst_maxburst, 1U, dwc->max_burst);
 
 	ret = dwc_verify_p_buswidth(chan);
 	if (ret)
 		return ret;
 
+	ret = dwc_verify_m_buswidth(chan);
+	if (ret)
+		return ret;
+
 	dw->encode_maxburst(dwc, &dwc->dma_sconfig.src_maxburst);
 	dw->encode_maxburst(dwc, &dwc->dma_sconfig.dst_maxburst);
 
-- 
2.43.0



