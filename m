Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF32E3380;
	Tue, 15 Jul 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586756; cv=none; b=t8dq5Jd/j1puWri3Dby2rNN45mFlAyY1nG7o5kqCslK67ZsbQoTeeMCEpXpPSpWu2zx/ZiPMsfUF2kNB+fIPhmVm3ac8DimJaYyJy8wUo7YkdyHMWRc3NQYNrIgI+LsQpJleVeA6kixqx0E6qmJgm7zJzjA8iycqiLCaTcqwop4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586756; c=relaxed/simple;
	bh=P5SmTFDGW7qxjtsLR5GTbi0vET46VM9Uet5s9MxYltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CROkA78UNlDYKdw3j2zZ087WR515pq0RT8zje2iOR836AkXkQQhgRRYp/cDfn0StCDrDR1lTH+n7d1vD+ZCDaAfRoLGkAeKxbLpJmaZ5wj/N5IPD8EMGti2wWBnQQmH9/nzh6K7f5YXgmynBicHbdKR2paRF9uxez3kqoURulIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrlKHlAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrlKHlAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8C3C4CEE3;
	Tue, 15 Jul 2025 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586756;
	bh=P5SmTFDGW7qxjtsLR5GTbi0vET46VM9Uet5s9MxYltU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrlKHlAwn8HSmjXBn+JBpvGhUnzEmYNQ3WZNi+wUcIE7RDX3XXqXpaHaB44Lk/BxZ
	 pZaN1AzpxuFi/KaWmC1s4utMzxVUtncMDgqOvsJdfy2LIwCm0Pqy4543sFDY8N2QXV
	 PtQ+BdDvxpuPDEhWuWnjuZ+eveykFV3Jho2eWDXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	EricChan <chenchuangyu@xiaomi.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 037/192] net: stmmac: Fix interrupt handling for level-triggered mode in DWC_XGMAC2
Date: Tue, 15 Jul 2025 15:12:12 +0200
Message-ID: <20250715130816.346187112@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: EricChan <chenchuangyu@xiaomi.com>

[ Upstream commit 78b7920a03351a8402de2f81914c1d2e2bdf24b7 ]

According to the Synopsys Controller IP XGMAC-10G Ethernet MAC Databook
v3.30a (section 2.7.2), when the INTM bit in the DMA_Mode register is set
to 2, the sbd_perch_tx_intr_o[] and sbd_perch_rx_intr_o[] signals operate
in level-triggered mode. However, in this configuration, the DMA does not
assert the XGMAC_NIS status bit for Rx or Tx interrupt events.

This creates a functional regression where the condition
if (likely(intr_status & XGMAC_NIS)) in dwxgmac2_dma_interrupt() will
never evaluate to true, preventing proper interrupt handling for
level-triggered mode. The hardware specification explicitly states that
"The DMA does not assert the NIS status bit for the Rx or Tx interrupt
events" (Synopsys DWC_XGMAC2 Databook v3.30a, sec. 2.7.2).

The fix ensures correct handling of both edge and level-triggered
interrupts while maintaining backward compatibility with existing
configurations. It has been tested on the hardware device (not publicly
available), and it can properly trigger the RX and TX interrupt handling
in both the INTM=0 and INTM=2 configurations.

Fixes: d6ddfacd95c7 ("net: stmmac: Add DMA related callbacks for XGMAC2")
Tested-by: EricChan <chenchuangyu@xiaomi.com>
Signed-off-by: EricChan <chenchuangyu@xiaomi.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250703020449.105730-1-chenchuangyu@xiaomi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 7840bc403788e..5dcc95bc0ad28 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -364,19 +364,17 @@ static int dwxgmac2_dma_interrupt(struct stmmac_priv *priv,
 	}
 
 	/* TX/RX NORMAL interrupts */
-	if (likely(intr_status & XGMAC_NIS)) {
-		if (likely(intr_status & XGMAC_RI)) {
-			u64_stats_update_begin(&stats->syncp);
-			u64_stats_inc(&stats->rx_normal_irq_n[chan]);
-			u64_stats_update_end(&stats->syncp);
-			ret |= handle_rx;
-		}
-		if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
-			u64_stats_update_begin(&stats->syncp);
-			u64_stats_inc(&stats->tx_normal_irq_n[chan]);
-			u64_stats_update_end(&stats->syncp);
-			ret |= handle_tx;
-		}
+	if (likely(intr_status & XGMAC_RI)) {
+		u64_stats_update_begin(&stats->syncp);
+		u64_stats_inc(&stats->rx_normal_irq_n[chan]);
+		u64_stats_update_end(&stats->syncp);
+		ret |= handle_rx;
+	}
+	if (likely(intr_status & (XGMAC_TI | XGMAC_TBU))) {
+		u64_stats_update_begin(&stats->syncp);
+		u64_stats_inc(&stats->tx_normal_irq_n[chan]);
+		u64_stats_update_end(&stats->syncp);
+		ret |= handle_tx;
 	}
 
 	/* Clear interrupts */
-- 
2.39.5



