Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03503AFB1B;
	Sat, 17 Oct 2026 16:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255240; cv=none; b=fYcKlppOP/0KJEyua4fosMaYg3CmaVzWh5ucNcU9zA1Nsqyxoy7iNt+hYzm0v+On7SNYCTRpBzhRlJFtjSVwWIBPH4+8cvepI3PyOmpCRg8k3oYwlXqypESI77yFiWBn3f4CqxovEXYsskNIskasmROJV0tk5jXYX/HYmiorrV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255240; c=relaxed/simple;
	bh=y8mcLzLid8heQ76joK+Uh2vNjXus+OQSMA181yD0i/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njII5GUOvdGoZyg7F649fU8Zt7jv2gHGXTfpbGudoFKbQe4LxQmMzBDMD+02euzFd9n0c2VkWz/3/6CHXCyOiR3GB+U/xyom20Xf9uLBVgUDurfefaPU500DYF9Vt9n8sOR7Ap1keao/KRpq/BFJ1lMLG7Ka/JLA/Q50ou06ccA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/1ISG2j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/1ISG2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7FB1F000C6;
	Sat, 17 Oct 2026 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255239;
	bh=UGcRsw4ZIRfSPESSp1AJbjWv+Tv6AoSBdp2AfGA1qjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/1ISG2jAsrW+/fPFlpAeYbz5zLodOAXKXHe0aUAe9g32iwo9g9sKGSN5MX8J9PW1
	 xzNg7nmt+ggPSSYciGTOf7Ej+dnpNzFOnYVaoYBwzuXQatLtqMLeKwY2l3Wt/Mr+Ew
	 nzWSNWVVgwgF9iHpC13xig7xlIDidldSAY3+dQ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alex Bereza <alex@bereza.email>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 712/869] dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout
Date: Sat, 17 Oct 2026 17:59:13 +0200
Message-ID: <20261017160055.216278951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Alex Bereza <alex@bereza.email>

[ Upstream commit aa99c4d1d63bbc26a5fc4c667d89b2595743c19d ]

Currently when calling xilinx_dma_poll_timeout with delay_us=0 and a
condition that is never fulfilled, the CPU busy-waits for prolonged time
and the timeout triggers only with a massive delay causing a CPU stall.

This happens due to a huge underestimation of wall clock time in
poll_timeout_us_atomic. Commit 7349a69cf312 ("iopoll: Do not use
timekeeping in read_poll_timeout_atomic()") changed the behavior to no
longer use ktime_get at the expense of underestimation of wall clock
time which appears to be very large for delay_us=0. Instead of timing
out after approximately XILINX_DMA_LOOP_COUNT microseconds, the timeout
takes XILINX_DMA_LOOP_COUNT * 1000 * (time that the overhead of the for
loop in poll_timeout_us_atomic takes) which is in the range of several
minutes for XILINX_DMA_LOOP_COUNT=1000000. Fix this by using a non-zero
value for delay_us. Use delay_us=10 to keep the delay in the hot path of
starting DMA transfers minimal but still avoid CPU stalls in case of
unexpected hardware failures.

One-off measurement with delay_us=0 causes the cpu to busy wait around 7
minutes in the timeout case. After applying this patch with delay_us=10
the measured timeout was 1053428 microseconds which is roughly
equivalent to the expected 1000000 microseconds specified in
XILINX_DMA_LOOP_COUNT.

Add a constant XILINX_DMA_POLL_DELAY_US for delay_us value.

Fixes: 9495f2648287 ("dmaengine: xilinx_vdma: Use readl_poll_timeout instead of do while loop's")
Fixes: 7349a69cf312 ("iopoll: Do not use timekeeping in read_poll_timeout_atomic()")
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Alex Bereza <alex@bereza.email>
Link: https://patch.msgid.link/20260402-fix-atomic-poll-timeout-regression-v4-1-f30d6a6c13cb@bereza.email
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 4a89ad8c90a34..39e6625c143cc 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -166,6 +166,8 @@
 
 /* Delay loop counter to prevent hardware failure */
 #define XILINX_DMA_LOOP_COUNT		1000000
+/* Delay between polls (avoid a delay of 0 to prevent CPU stalls) */
+#define XILINX_DMA_POLL_DELAY_US	10
 
 /* AXI DMA Specific Registers/Offsets */
 #define XILINX_DMA_REG_SRCDSTADDR	0x18
@@ -1315,7 +1317,8 @@ static int xilinx_dma_stop_transfer(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to halt */
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_HALTED, 0,
+				       val & XILINX_DMA_DMASR_HALTED,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1330,7 +1333,8 @@ static int xilinx_cdma_stop_transfer(struct xilinx_dma_chan *chan)
 	u32 val;
 
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_IDLE, 0,
+				       val & XILINX_DMA_DMASR_IDLE,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1347,7 +1351,8 @@ static void xilinx_dma_start(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to start */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				      !(val & XILINX_DMA_DMASR_HALTED), 0,
+				      !(val & XILINX_DMA_DMASR_HALTED),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
@@ -1780,7 +1785,8 @@ static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to finish reset */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMACR, tmp,
-				      !(tmp & XILINX_DMA_DMACR_RESET), 0,
+				      !(tmp & XILINX_DMA_DMACR_RESET),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
-- 
2.53.0



