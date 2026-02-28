Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7833F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301177; cv=none; b=LY2wyplUq/DL+IT5/y4LsrqcLfYEsDr0MbUWRdv09D2MmsVE8fFBvCMIBwHC/1YwbLYj7PDQNF9dE9i/Vlx3qbVrNxbznKPL58lKklM36b0UtZX6xIcV72wEl969/SPpMvgFBUIoOA+uhR6udf0gnbt3ng4hnM1Oaw56/89uwGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301177; c=relaxed/simple;
	bh=i8/3pj5C23rWp+g8HgYnKimhcpObrbmR5Xq/logB+3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBo95CMD+1Qzqp97cN8BACBbxaQrJHvhfXFsm7C+cR749ob+yP9BBGB3TqfpQPbGhWhpy1vRsH+O2fHi8y+aouHWF3ACaTqfv90xQcDFU5Zm5dYXvLEfx9IKp5mB0aOrwsUlO4p2d7o7ZAGcwuIdux4MDelTaYcr3gfkcrRusFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3DeSBla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3DeSBla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D384CC19423;
	Sat, 28 Feb 2026 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301177;
	bh=i8/3pj5C23rWp+g8HgYnKimhcpObrbmR5Xq/logB+3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3DeSBlawNlusfMjNJdrH7Yn4V7T8mzLvBNpsheyCfmSKINcKIaSnzTkOt45OEcBH
	 8osi2n50nomv7mqTGIREem3KIFiTc+dG4h7ujA3t2SxA+fOj5xu/IhtFhzD3teQScm
	 Sgwz34m2Qh395MyLXjzYhMtE5RgYpb2nyRRsveOti+UbOCwT44iisGyX5lYuHpOp9F
	 lqbGYpiZLhrF8sewQ/W557h2qDo+MAwRGOXEg2jacEoXm/uWj/gg2JD5+pA9pbtzKR
	 lXVioh3jh0sxf9JMthSK1e6bS0biTQ3JlpK636SJCc1vDWaHhrfvhpPnPzKF6oFke0
	 kg5Ura7O2AFJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Moteen Shah <m-shah@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 345/752] serial: 8250: 8250_omap.c: Add support for handling UART error conditions
Date: Sat, 28 Feb 2026 12:40:56 -0500
Message-ID: <20260228174750.1542406-345-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Moteen Shah <m-shah@ti.com>

[ Upstream commit 623b07b370e9963122d167e04fdc1dc713ebfbaf ]

The DMA IRQ handler does not accounts for the overrun(OE) or any other
errors being reported by the IP before triggering a DMA transaction which
leads to the interrupts not being handled resulting into an IRQ storm.

The way to handle OE is to:
1. Reset the RX FIFO.
2. Read the UART_RESUME register, which clears the internal flag

Earlier, the driver issued DMA transations even in case of OE which shouldn't
be done according to the OE handling mechanism mentioned above, as we are
resetting the FIFO's, refer section: "12.1.6.4.8.1.3.6 Overrun During
Receive" [0].

[0] https://www.ti.com/lit/pdf/spruiu1

Signed-off-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260112081829.63049-2-m-shah@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 9e49ef48b851b..e26bae0a6488f 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -100,6 +100,9 @@
 #define OMAP_UART_REV_52 0x0502
 #define OMAP_UART_REV_63 0x0603
 
+/* Resume register */
+#define UART_OMAP_RESUME		0x0B
+
 /* Interrupt Enable Register 2 */
 #define UART_OMAP_IER2			0x1B
 #define UART_OMAP_IER2_RHR_IT_DIS	BIT(2)
@@ -119,7 +122,6 @@
 /* Timeout low and High */
 #define UART_OMAP_TO_L                 0x26
 #define UART_OMAP_TO_H                 0x27
-
 struct omap8250_priv {
 	void __iomem *membase;
 	int line;
@@ -1256,6 +1258,20 @@ static u16 omap_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir, u16 status
 	return status;
 }
 
+static void am654_8250_handle_uart_errors(struct uart_8250_port *up, u8 iir, u16 status)
+{
+	if (status & UART_LSR_OE) {
+		serial8250_clear_and_reinit_fifos(up);
+		serial_in(up, UART_LSR);
+		serial_in(up, UART_OMAP_RESUME);
+	} else {
+		if (status & (UART_LSR_FE | UART_LSR_PE | UART_LSR_BI))
+			serial_in(up, UART_RX);
+		if (iir & UART_IIR_XOFF)
+			serial_in(up, UART_IIR);
+	}
+}
+
 static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 				     u16 status)
 {
@@ -1266,7 +1282,8 @@ static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 	 * Queue a new transfer if FIFO has data.
 	 */
 	if ((status & (UART_LSR_DR | UART_LSR_BI)) &&
-	    (up->ier & UART_IER_RDI)) {
+	    (up->ier & UART_IER_RDI) && !(status & UART_LSR_OE)) {
+		am654_8250_handle_uart_errors(up, iir, status);
 		omap_8250_rx_dma(up);
 		serial_out(up, UART_OMAP_EFR2, UART_OMAP_EFR2_TIMEOUT_BEHAVE);
 	} else if ((iir & 0x3f) == UART_IIR_RX_TIMEOUT) {
@@ -1282,6 +1299,8 @@ static void am654_8250_handle_rx_dma(struct uart_8250_port *up, u8 iir,
 		serial_out(up, UART_OMAP_EFR2, 0x0);
 		up->ier |= UART_IER_RLSI | UART_IER_RDI;
 		serial_out(up, UART_IER, up->ier);
+	} else {
+		am654_8250_handle_uart_errors(up, iir, status);
 	}
 }
 
-- 
2.51.0

