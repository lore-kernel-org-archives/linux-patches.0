Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12693B7770;
	Sat, 17 Oct 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260442; cv=none; b=cmmu0KBFrQ+IqOp0AzgxXTLdSn70ZHp1/iG7dAFpP2sQLYyr9HB8JjosE8GvLqQOf3cuFFvSgKZ1pZAJOYxhls3M9KpJ9woTqmXDQnvvOBqKKx+Q8o61g5VUdfzfmg05pH4kWLcpNykgm+pAt994MCChBKl9Wu4iubvz+3eLA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260442; c=relaxed/simple;
	bh=dynGvXKALhde5vZgr7D96stqTuaMRK8AUFfe8T5nCVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f67JLiJhtzbHY9DVnIYQt4TAjysyHK4043f+9oSLO79tL7HVkPh9rfajATO96vOhscDmvtGfRfPlYLTux1Q81heHnvBcpzhwJhIfgHfnzNf4TlLbSs07S8SWcvXwLUbo7+25BA0OahJG8izr4iRrry/AfZFOg04y4QTlcFAN2AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wndVJTEG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wndVJTEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584041F000C4;
	Sat, 17 Oct 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260440;
	bh=b9NuCs8YXxnULq0MKooPJAURfS40OfO9gsh7DbNna7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wndVJTEGL+g3/4Iu7k/LAn2UsQruUpRBw3TB//y9AtVtBj5XyWNhXDFxr7tWjRT7S
	 KUV2Gy7qRSTHw8B8lQN2biWvmO11451edn6Q8aWLe+QR55nKIWV39l5fsu3zVD8Dei
	 lMqEBctA3+mq2QiacsR8bytpP+N3FovFMV+3wXlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alex Bereza <alex@bereza.email>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1495/1674] dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout
Date: Sat, 17 Oct 2026 18:02:47 +0200
Message-ID: <20261017160509.515266982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 1e1d8829cd815..ee15da19515a0 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -164,6 +164,8 @@
 
 /* Delay loop counter to prevent hardware failure */
 #define XILINX_DMA_LOOP_COUNT		1000000
+/* Delay between polls (avoid a delay of 0 to prevent CPU stalls) */
+#define XILINX_DMA_POLL_DELAY_US	10
 
 /* AXI DMA Specific Registers/Offsets */
 #define XILINX_DMA_REG_SRCDSTADDR	0x18
@@ -1313,7 +1315,8 @@ static int xilinx_dma_stop_transfer(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to halt */
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_HALTED, 0,
+				       val & XILINX_DMA_DMASR_HALTED,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1328,7 +1331,8 @@ static int xilinx_cdma_stop_transfer(struct xilinx_dma_chan *chan)
 	u32 val;
 
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_IDLE, 0,
+				       val & XILINX_DMA_DMASR_IDLE,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1345,7 +1349,8 @@ static void xilinx_dma_start(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to start */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				      !(val & XILINX_DMA_DMASR_HALTED), 0,
+				      !(val & XILINX_DMA_DMASR_HALTED),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
@@ -1778,7 +1783,8 @@ static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to finish reset */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMACR, tmp,
-				      !(tmp & XILINX_DMA_DMACR_RESET), 0,
+				      !(tmp & XILINX_DMA_DMACR_RESET),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
-- 
2.53.0



