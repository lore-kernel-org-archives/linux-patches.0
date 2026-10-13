Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5CC47AF65;
	Tue, 13 Oct 2026 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894354; cv=none; b=QzTgIxVGzwmXn4ROnKeCIoPOEHVuYQWi011zB3BFVY2cxYqOR9AQdi3bt1cY6DbTtdFwlAN0JqG18wdBpqgA3PgoaShSK8AW+qOrYWtg65ywTnspSgdHytO34nPBXCLoN3aXVz/HdGM77ACtDagXrP0nu974fXhe7xQteVQSTV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894354; c=relaxed/simple;
	bh=D5mpenJ2EjObmNw+aUin5Eyggu/VzlGhS97vcKJknEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCAIMDpLWk19iTVeO5NJvOkLHLAwtsLCyWDcWEkOaWgwRxDPCF8QcWX8xGpUTKMZ1Q0tOX0jmwiml3EeeCX0Y2aFW3TADAcIf90nWUoh0wUN1RZcAgwoWjH7Pechr0HYOcUaELBJ/9zUJ4OjOnruJoTlhp9uhtyEj2G/Se6+I2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhfUihxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhfUihxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3231F000FF;
	Tue, 13 Oct 2026 12:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894353;
	bh=rKj2p715VMzo/NbHjI3gCj/R06xiqYEF/N/3AW+Bw+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhfUihxOL3uARHrDC2b35IukNl1aQUwNK3X0DOg4fGA3DHOlUNF45+ALEcWSnVUiq
	 xCedIW4DKlqDJ9uLsrslQzLCkVn8zazenKkNo7hJEk4C8vRcIClO/P7R0nhBzZxUgk
	 1lAzcHK6e9lApt67ZUW7kZfE/HYRBcSM1wg7c0N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alex Bereza <alex@bereza.email>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 488/621] dmaengine: xilinx_dma: Fix CPU stall in xilinx_dma_poll_timeout
Date: Tue, 13 Oct 2026 13:38:03 +0200
Message-ID: <20261013112932.410790972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8b010e0e0c5c4..94d2e5398dd69 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -167,6 +167,8 @@
 
 /* Delay loop counter to prevent hardware failure */
 #define XILINX_DMA_LOOP_COUNT		1000000
+/* Delay between polls (avoid a delay of 0 to prevent CPU stalls) */
+#define XILINX_DMA_POLL_DELAY_US	10
 
 /* AXI DMA Specific Registers/Offsets */
 #define XILINX_DMA_REG_SRCDSTADDR	0x18
@@ -1316,7 +1318,8 @@ static int xilinx_dma_stop_transfer(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to halt */
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_HALTED, 0,
+				       val & XILINX_DMA_DMASR_HALTED,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1331,7 +1334,8 @@ static int xilinx_cdma_stop_transfer(struct xilinx_dma_chan *chan)
 	u32 val;
 
 	return xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				       val & XILINX_DMA_DMASR_IDLE, 0,
+				       val & XILINX_DMA_DMASR_IDLE,
+				       XILINX_DMA_POLL_DELAY_US,
 				       XILINX_DMA_LOOP_COUNT);
 }
 
@@ -1348,7 +1352,8 @@ static void xilinx_dma_start(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to start */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMASR, val,
-				      !(val & XILINX_DMA_DMASR_HALTED), 0,
+				      !(val & XILINX_DMA_DMASR_HALTED),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
@@ -1783,7 +1788,8 @@ static int xilinx_dma_reset(struct xilinx_dma_chan *chan)
 
 	/* Wait for the hardware to finish reset */
 	err = xilinx_dma_poll_timeout(chan, XILINX_DMA_REG_DMACR, tmp,
-				      !(tmp & XILINX_DMA_DMACR_RESET), 0,
+				      !(tmp & XILINX_DMA_DMACR_RESET),
+				      XILINX_DMA_POLL_DELAY_US,
 				      XILINX_DMA_LOOP_COUNT);
 
 	if (err) {
-- 
2.53.0



