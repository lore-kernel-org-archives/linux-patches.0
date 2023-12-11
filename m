Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EDF52F72;
	Mon, 11 Dec 2023 18:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkeSh9uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C12C433CB;
	Mon, 11 Dec 2023 18:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319756;
	bh=8emQgtLLFpahAm3MzJYenwFV+xPzAlif6M9QykqcHUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkeSh9uuLpZ4quJ5hkIsG+5IBaLXDq2OrIFa24wQvV9x4XNjHHko7GfljnHQFQxVa
	 U8Rlqkf+NbkWf9K7BEPfaHnUedQfNjmY9ukniGG5JJkui/HLECDoS5m/nTxqeEw8ga
	 zsvO8zy5OtPXjtgya1PQgWqZaPZW46bHrWyiykpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 222/244] serial: 8250: 8250_omap: Do not start RX DMA on THRI interrupt
Date: Mon, 11 Dec 2023 19:21:55 +0100
Message-ID: <20231211182055.949325881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Ronald Wahl <ronald.wahl@raritan.com>

commit c6bb057418876cdfdd29a6f7b8cef54539ee8811 upstream.

Starting RX DMA on THRI interrupt is too early because TX may not have
finished yet.

This change is inspired by commit 90b8596ac460 ("serial: 8250: Prevent
starting up DMA Rx on THRI interrupt") and fixes DMA issues I had with
an AM62 SoC that is using the 8250 OMAP variant.

Cc: stable@vger.kernel.org
Fixes: c26389f998a8 ("serial: 8250: 8250_omap: Add DMA support for UARTs on K3 SoCs")
Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20231101171431.16495-1-rwahl@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1282,10 +1282,12 @@ static int omap_8250_dma_handle_irq(stru
 
 	status = serial_port_in(port, UART_LSR);
 
-	if (priv->habit & UART_HAS_EFR2)
-		am654_8250_handle_rx_dma(up, iir, status);
-	else
-		status = omap_8250_handle_rx_dma(up, iir, status);
+	if ((iir & 0x3f) != UART_IIR_THRI) {
+		if (priv->habit & UART_HAS_EFR2)
+			am654_8250_handle_rx_dma(up, iir, status);
+		else
+			status = omap_8250_handle_rx_dma(up, iir, status);
+	}
 
 	serial8250_modem_status(up);
 	if (status & UART_LSR_THRE && up->dma->tx_err) {


