Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77D81D1E95;
	Wed,  2 Oct 2024 14:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878502; cv=none; b=NwJZsUokwrfu2L4FPRJYnogLtdrB7x7fk6D3TkTUHUYSV51rBx276HX2fKqlmMWgcNmQ6mPjMUiYzaKHCE3dmrJfniiJ1PXe25CBzHsrcop+Z6s/KE4vuuzIbLgBsotg46wD3xAV+qnMz3XiFyDLFzE3c+I7FMxmnB2x/O3Ok5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878502; c=relaxed/simple;
	bh=3UdTNRZ0Hns16AM2MY6kbTWnQwX9uTy3Z+bW5crIIY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKPH/5Zfot2tZ29/ewUgZJdlf+0CzRLnTUiVJVyHGRJSOKI68+gCaPxRuDYwJFnmZu5JyXepPt9otRaihS9ie72apQ7lqGCIZtZ/9Z6vlEtMsDRcOvTo2PVV8hhGx0Zc8sCy0SqTSOOUuwiAeJtOe2L9OBLSh0oKSIuC0Fuhea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGSBiCmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGSBiCmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2365C4CEC2;
	Wed,  2 Oct 2024 14:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878502;
	bh=3UdTNRZ0Hns16AM2MY6kbTWnQwX9uTy3Z+bW5crIIY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sGSBiCmQf6+AH455iejPSw7NvU1DQXvJ1iUzcKHjOBI02dpP3I2J688tTGs0MZOhb
	 olBCFxcFuaZzCus8sQmNKJx6ABRROB0zTzdTSAyAPr86c0uJMG0+UOvyLofg7b92LH
	 joDv7QK5CxcQ+A+naH2SsWluywhbVxhOQEESV++A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 434/634] net: xilinx: axienet: Schedule NAPI in two steps
Date: Wed,  2 Oct 2024 14:58:54 +0200
Message-ID: <20241002125828.232743652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit ba0da2dc934ec5ac32bbeecbd0670da16ba03565 ]

As advised by Documentation/networking/napi.rst, masking IRQs after
calling napi_schedule can be racy. Avoid this by only masking/scheduling
if napi_schedule_prep returns true.

Fixes: 9e2bc267e780 ("net: axienet: Use NAPI for TX completion path")
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240913145711.2284295-1-sean.anderson@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 88d7bc2ea7132..00b1a4cf7c4be 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1222,9 +1222,10 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		u32 cr = lp->tx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_tx);
+		if (napi_schedule_prep(&lp->napi_tx)) {
+			axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_tx);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -1266,9 +1267,10 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		u32 cr = lp->rx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_rx);
+		if (napi_schedule_prep(&lp->napi_rx)) {
+			axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_rx);
+		}
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



