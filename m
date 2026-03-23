Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F05C1EB9F2;
	Mon, 23 Mar 2026 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274683; cv=none; b=ARCOn0Y0jAmVaRrpTCdRI/BUXk9O1ZhAzXZbg7Tl2N05fivS9X8jAvFtlDdF/BpqeB8xC5v6dB/lozKPrctJOLU3uYt+cDneBFW0BkdbDf9oKU036pdVFHunL4MZAAlu4gYyL+QAHZCA2vhagR1ZtRSDGkG+DIv5t97GfPm8Hgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274683; c=relaxed/simple;
	bh=bp1mBU1r0dQCPG6Eq6Hqgh4Noc2bTg6zzH0Hmu1L6sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gaKrPMsF/YH8dS7zV0pbuGwbhjMIJpdrvEOcS1Z+UiAB0UzrU0yzy5BM6lsIIm2mcbWBHJ/OoPfTrGrv7AcW37RYp6THquMOaCVOJdZYOqEbgdSq2yAGMEnPPgaiKHDbg9frgdvnVMHLlVdf8ACojZBFVjA/qEY7s+1xQIq1LS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loCMInXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loCMInXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96865C4CEF7;
	Mon, 23 Mar 2026 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274683;
	bh=bp1mBU1r0dQCPG6Eq6Hqgh4Noc2bTg6zzH0Hmu1L6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loCMInXkAKCk2xccfWTEkmPl+eF6ZScN/W/GqU7k9TQPWf1vVtUDm2sBEz9iYYmEM
	 aH2BREtTAKHILNiSy+SvjcuJPoPyZEgmgJEnuQXR+Mvw/lnDZ5P72IS5DyVjPvvHj9
	 hxpMhBMBAB5KOwzekqxa02Ftci7HWMUOJDd65JCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 073/212] serial: 8250_dw: Rework dw8250_handle_irq() locking and IIR handling
Date: Mon, 23 Mar 2026 14:44:54 +0100
Message-ID: <20260323134506.074155377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 883c5a2bc934c165c4491d1ef7da0ac4e9765077 upstream.

dw8250_handle_irq() takes port's lock multiple times with no good
reason to release it in between and calls serial8250_handle_irq()
that also takes port's lock.

Take port's lock only once in dw8250_handle_irq() and use
serial8250_handle_irq_locked() to avoid releasing port's lock in
between.

As IIR_NO_INT check in serial8250_handle_irq() was outside of port's
lock, it has to be done already in dw8250_handle_irq().

DW UART can, in addition to IIR_NO_INT, report BUSY_DETECT (0x7) which
collided with the IIR_NO_INT (0x1) check in serial8250_handle_irq()
(because & is used instead of ==) meaning that no other work is done by
serial8250_handle_irq() during an BUSY_DETECT interrupt.

This allows reorganizing code in dw8250_handle_irq() to do both
IIR_NO_INT and BUSY_DETECT handling right at the start simplifying
the logic.

Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -9,6 +9,9 @@
  * LCR is written whilst busy.  If it is, then a busy detect interrupt is
  * raised, the LCR needs to be rewritten and the uart status register read.
  */
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -40,6 +43,8 @@
 #define RZN1_UART_RDMACR 0x110 /* DMA Control Register Receive Mode */
 
 /* DesignWare specific register fields */
+#define DW_UART_IIR_IID			GENMASK(3, 0)
+
 #define DW_UART_MCR_SIRE		BIT(6)
 
 /* Renesas specific register fields */
@@ -312,7 +317,19 @@ static int dw8250_handle_irq(struct uart
 	bool rx_timeout = (iir & 0x3f) == UART_IIR_RX_TIMEOUT;
 	unsigned int quirks = d->pdata->quirks;
 	unsigned int status;
-	unsigned long flags;
+
+	switch (FIELD_GET(DW_UART_IIR_IID, iir)) {
+	case UART_IIR_NO_INT:
+		return 0;
+
+	case UART_IIR_BUSY:
+		/* Clear the USR */
+		serial_port_in(p, d->pdata->usr_reg);
+
+		return 1;
+	}
+
+	guard(uart_port_lock_irqsave)(p);
 
 	/*
 	 * There are ways to get Designware-based UARTs into a state where
@@ -325,20 +342,15 @@ static int dw8250_handle_irq(struct uart
 	 * so we limit the workaround only to non-DMA mode.
 	 */
 	if (!up->dma && rx_timeout) {
-		uart_port_lock_irqsave(p, &flags);
 		status = serial_lsr_in(up);
 
 		if (!(status & (UART_LSR_DR | UART_LSR_BI)))
 			serial_port_in(p, UART_RX);
-
-		uart_port_unlock_irqrestore(p, flags);
 	}
 
 	/* Manually stop the Rx DMA transfer when acting as flow controller */
 	if (quirks & DW_UART_QUIRK_IS_DMA_FC && up->dma && up->dma->rx_running && rx_timeout) {
-		uart_port_lock_irqsave(p, &flags);
 		status = serial_lsr_in(up);
-		uart_port_unlock_irqrestore(p, flags);
 
 		if (status & (UART_LSR_DR | UART_LSR_BI)) {
 			dw8250_writel_ext(p, RZN1_UART_RDMACR, 0);
@@ -346,17 +358,9 @@ static int dw8250_handle_irq(struct uart
 		}
 	}
 
-	if (serial8250_handle_irq(p, iir))
-		return 1;
-
-	if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
-		/* Clear the USR */
-		serial_port_in(p, d->pdata->usr_reg);
+	serial8250_handle_irq_locked(p, iir);
 
-		return 1;
-	}
-
-	return 0;
+	return 1;
 }
 
 static void dw8250_clk_work_cb(struct work_struct *work)
@@ -865,6 +869,7 @@ static struct platform_driver dw8250_pla
 
 module_platform_driver(dw8250_platform_driver);
 
+MODULE_IMPORT_NS("SERIAL_8250");
 MODULE_AUTHOR("Jamie Iles");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Synopsys DesignWare 8250 serial port driver");


