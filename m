Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8422FE18;
	Mon,  2 Jun 2025 14:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873939; cv=none; b=XaNWgiLB0kMH5mRK3YuyHrFKIavnbj/xIiXRyvltqUZh05os6BhiexO95ZeB0t7UBpnSl9tdUBY+V76etu0DF3YvB3PNR+6fm695mZs+dHzkrZ/g9jYzQ7Z/wwZ3yvZAi+UMg5RYRxdqjGQTQIWF9EbuGXTxU5gDObASE52kw7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873939; c=relaxed/simple;
	bh=vlsLGK3C+Ap8FFKJ83PAvcxKXKOqkRHypu0r0zBPItQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgrptFAINOnCGM/SgkjkoOgTot6Z4bNf/UM+XahvMYHxDBPeYYDXIQTUPCw7T3tS3dRbo1xiVWoGHyPBVfcbTsx28YQvyh5/tMB2w+BfgRklov6nmzfgOasDz0weA+KO/j95P6ddac8fsR4odw5qZkXg1V/2TKfx+lCDIsqOb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoBJHKTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoBJHKTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8399FC4CEEB;
	Mon,  2 Jun 2025 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873938;
	bh=vlsLGK3C+Ap8FFKJ83PAvcxKXKOqkRHypu0r0zBPItQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoBJHKTah00o5BsDfLPaxIQ0FEIw0k1HZ63BrzH8eClLytm+olnYxwSyDdQjUvJNQ
	 CquAl5anE5FgFaly4WMZzsNomeQDPp1QrUiXg3KOW7/1WX+BY+zTNrOLvapDrmly2H
	 BbwHU77O79CDhj0kY+x/cCc6e+UYoaf2bZReYh7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/444] spi: zynqmp-gqspi: Always acknowledge interrupts
Date: Mon,  2 Jun 2025 15:46:06 +0200
Message-ID: <20250602134353.198953439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 89785306453ce6d949e783f6936821a0b7649ee2 ]

RXEMPTY can cause an IRQ, even though we may not do anything about it
(such as if we are waiting for more received data). We must still handle
these IRQs because we can tell they were caused by the device.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250116224130.2684544-6-sean.anderson@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 3503e6c0a5c98..b5deb4fe3b832 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -799,7 +799,6 @@ static void zynqmp_process_dma_irq(struct zynqmp_qspi *xqspi)
 static irqreturn_t zynqmp_qspi_irq(int irq, void *dev_id)
 {
 	struct zynqmp_qspi *xqspi = (struct zynqmp_qspi *)dev_id;
-	irqreturn_t ret = IRQ_NONE;
 	u32 status, mask, dma_status = 0;
 
 	status = zynqmp_gqspi_read(xqspi, GQSPI_ISR_OFST);
@@ -814,27 +813,24 @@ static irqreturn_t zynqmp_qspi_irq(int irq, void *dev_id)
 				   dma_status);
 	}
 
-	if (mask & GQSPI_ISR_TXNOT_FULL_MASK) {
+	if (!mask && !dma_status)
+		return IRQ_NONE;
+
+	if (mask & GQSPI_ISR_TXNOT_FULL_MASK)
 		zynqmp_qspi_filltxfifo(xqspi, GQSPI_TX_FIFO_FILL);
-		ret = IRQ_HANDLED;
-	}
 
-	if (dma_status & GQSPI_QSPIDMA_DST_I_STS_DONE_MASK) {
+	if (dma_status & GQSPI_QSPIDMA_DST_I_STS_DONE_MASK)
 		zynqmp_process_dma_irq(xqspi);
-		ret = IRQ_HANDLED;
-	} else if (!(mask & GQSPI_IER_RXEMPTY_MASK) &&
-			(mask & GQSPI_IER_GENFIFOEMPTY_MASK)) {
+	else if (!(mask & GQSPI_IER_RXEMPTY_MASK) &&
+			(mask & GQSPI_IER_GENFIFOEMPTY_MASK))
 		zynqmp_qspi_readrxfifo(xqspi, GQSPI_RX_FIFO_FILL);
-		ret = IRQ_HANDLED;
-	}
 
 	if (xqspi->bytes_to_receive == 0 && xqspi->bytes_to_transfer == 0 &&
 	    ((status & GQSPI_IRQ_MASK) == GQSPI_IRQ_MASK)) {
 		zynqmp_gqspi_write(xqspi, GQSPI_IDR_OFST, GQSPI_ISR_IDR_MASK);
 		complete(&xqspi->data_completion);
-		ret = IRQ_HANDLED;
 	}
-	return ret;
+	return IRQ_HANDLED;
 }
 
 /**
-- 
2.39.5



