Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134B239A7FD;
	Tue, 21 Jul 2026 18:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659952; cv=none; b=Ko+BLTpCpc15jSY3FdWBMcWkElfT47lXl+kGbOlw/ycgzr0VJ283dt0DWHnofnoqiPW9D6HpgHjz3URd1rIJI+nsExPFDFmb6IDDvU8Xp5jCGoIr/V6+MCccjotVxgEXTcTd6jSt6eaDAbBFk3SoyWg5LUPx2wRwAUBlGLX1BgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659952; c=relaxed/simple;
	bh=bDERo2Y/qsJD/NXYxsMJ5xJJDOuTI39AIGLUOWfc5TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB9Tpfb9LK8ng3BDggHUwnSLxC1kpDGE0scdyBg90Pp7Fn/I/tRxWN3RSC83d5tO+GeO/JcFCXmpu7RZX3oIzUv6DdjeM/3iDPPSLG8MTTrZW34Bh0Wa990c3QhRkcFIhmxwmvlV2P5ymProf24O5cfV1ASMJjC/kdOMrg+hE1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbghFvMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbghFvMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796361F000E9;
	Tue, 21 Jul 2026 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659951;
	bh=w53UglwzplAW31wEhDGvkbaZWBp4ltqgHVpHetl5Pf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbghFvMKQarzmJJm/pTN8+l5JT3u1B3Cbw/5vGjf3C8jvl2xuCgKwc9+cXUYVWNw1
	 OXg9/ObcNYvhcZRCQpAtIYAz1Qw4Avg2HuPZF0Ci1M1rurzt4+PaRxOHMcMgP9H5gT
	 1zGxA/NOOe5yCeeRCxY7q7TX6+tEGJt3HTDb0LaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0796/2077] net: ti: icssg-prueth: Fix AF_XDP fill ring alloc and wakeup condition
Date: Tue, 21 Jul 2026 17:07:49 +0200
Message-ID: <20260721152611.569018881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit dfb787f7d157f97ba91344b584d33481f572530e ]

emac_rx_packet_zc() calls prueth_rx_alloc_zc() with count (frames
received in the current NAPI poll) as the allocation budget.  Two
problems arise from this:

1. When the CPPI5 descriptor pool is exhausted (avail_desc == 0,
   FDQ already holds the maximum number of descriptors), count > 0
   still triggers allocation attempts that all fail, spamming the
   kernel log with "rx push: failed to allocate descriptor" at
   high packet rates.

2. The XSK wakeup condition "ret < count" is wrong when avail_desc
   is zero: ret == 0 and count can be up to 64, so the condition is
   always true.  This causes ~200 spurious ndo_xsk_wakeup() calls
   per second even when the FDQ is already full, wasting CPU cycles
   in repeated NAPI invocations that process zero frames.

Fix both by introducing alloc_budget = min(budget, avail_desc):
- When avail_desc == 0 no allocation is attempted, avoiding pool
  exhaustion errors.  The wakeup condition "ret < alloc_budget"
  evaluates to 0 < 0 == false, correctly clearing the wakeup flag
  so the hardware IRQ re-arms NAPI without spurious kicks.
- In steady state avail_desc == count <= budget, so alloc_budget
  == count and behaviour is unchanged.
- After a dry-ring stall (count == 0, avail_desc > 0), alloc_budget
  > 0 causes new descriptors to be posted to the FDQ so the hardware
  can resume receiving immediately.

Fixes: 7a64bb388df3 ("net: ti: icssg-prueth: Add AF_XDP zero copy for RX")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Link: https://patch.msgid.link/20260611185744.2498070-2-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_common.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_common.c b/drivers/net/ethernet/ti/icssg/icssg_common.c
index a28a608f9bf4b9..55a696912811f6 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_common.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_common.c
@@ -927,6 +927,7 @@ static int emac_rx_packet_zc(struct prueth_emac *emac, u32 flow_id,
 	struct cppi5_host_desc_t *desc_rx;
 	struct prueth_swdata *swdata;
 	dma_addr_t desc_dma, buf_dma;
+	int avail_desc, alloc_budget;
 	struct xdp_buff *xdp;
 	int xdp_status = 0;
 	int count = 0;
@@ -993,16 +994,13 @@ static int emac_rx_packet_zc(struct prueth_emac *emac, u32 flow_id,
 	if (xdp_status & ICSSG_XDP_REDIR)
 		xdp_do_flush();
 
-	/* Allocate xsk buffers from the pool for the "count" number of
-	 * packets processed in order to be able to receive more packets.
-	 */
-	ret = prueth_rx_alloc_zc(emac, count);
+	avail_desc = k3_cppi_desc_pool_avail(rx_chn->desc_pool);
+	alloc_budget = min_t(int, budget, avail_desc);
+
+	ret = prueth_rx_alloc_zc(emac, alloc_budget);
 
 	if (xsk_uses_need_wakeup(rx_chn->xsk_pool)) {
-		/* If the user space doesn't provide enough buffers then it must
-		 * explicitly wake up the kernel when new buffers are available
-		 */
-		if (ret < count)
+		if (ret < alloc_budget)
 			xsk_set_rx_need_wakeup(rx_chn->xsk_pool);
 		else
 			xsk_clear_rx_need_wakeup(rx_chn->xsk_pool);
-- 
2.53.0



