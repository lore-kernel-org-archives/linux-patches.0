Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DE21576E;
	Thu, 12 Dec 2024 17:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023121; cv=none; b=Md/+rYBOzqjBLhdg9Y/T8MYFi5P0gQ1CZkZeKoYodIw2DS/XQ6GU+oE2dzPK0eF+geKfvuQkzaOLEG16HQNtaBcV4s9O0yBcXF/C37FqiWZJ+YdmK9MrCFTxZgWVDgcBaMefnJOpPJ7gSz7QtxI2wfgC78aLFnS5wYSwXR2RIh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023121; c=relaxed/simple;
	bh=yZgl0xnJefUlaN8Eu7aMYquTjTqWtwBoFi11iV39o38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP52eQb9egZY7AN8f+ZX9CQvldT9HBkOjHOXPCIRBjKcNDjRDTYY86Cq/5I+4imLU9LG3SnohhG0B9N3vJlCjBiUSK6gwfWSI4xHov0Dp/tyAlZfRBok19RJm5Qu9e6Qckw3+B547HEcOirMtYCMmftNgQRAXPiU1dfeACxA2jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8K6no64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8K6no64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3B0C4CECE;
	Thu, 12 Dec 2024 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023121;
	bh=yZgl0xnJefUlaN8Eu7aMYquTjTqWtwBoFi11iV39o38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8K6no640pm9d5HD4NNdng50y4yxAeV7ZEP+dOTdm3WuL9ry2jP+TEL0F9qoXj43P
	 lfM8y1JKErljNd35jClwDsu6p91FXwy/niawBpuyRs0nouLW0/x402Mn6B4f+GL2Bo
	 zZ10zBOKX3b9mVwHeebPvR/tB+mltsSMamixNXnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/565] serial: amba-pl011: Fix RX stall when DMA is used
Date: Thu, 12 Dec 2024 16:00:26 +0100
Message-ID: <20241212144328.723841879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

[ Upstream commit 2bcacc1c87acf9a8ebc17de18cb2b3cfeca547cf ]

Function pl011_throttle_rx() calls pl011_stop_rx() to disable RX, which
also disables the RX DMA by clearing the RXDMAE bit of the DMACR
register. However, to properly unthrottle RX when DMA is used, the
function pl011_unthrottle_rx() is expected to set the RXDMAE bit of
the DMACR register, which it currently lacks. This causes RX to stall
after the throttle API is called.

Set RXDMAE bit in the DMACR register while unthrottling RX if RX DMA is
used.

Fixes: 211565b10099 ("serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241113092629.60226-1-kkartik@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 16fc159bdf3b9..8ae8fb8132d5b 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1842,6 +1842,11 @@ static void pl011_unthrottle_rx(struct uart_port *port)
 
 	pl011_write(uap->im, uap, REG_IMSC);
 
+	if (uap->using_rx_dma) {
+		uap->dmacr |= UART011_RXDMAE;
+		pl011_write(uap->dmacr, uap, REG_DMACR);
+	}
+
 	uart_port_unlock_irqrestore(&uap->port, flags);
 }
 
-- 
2.43.0



