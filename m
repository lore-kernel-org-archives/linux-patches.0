Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739EA18DF60;
	Wed,  2 Oct 2024 13:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877001; cv=none; b=Rcro7JpJJMhk5xWh9R2aRdP9c1sLOoxYRValf1sHe5d5HavU0mjrS8XV+RIqQ6Ctjk02SWHrLenlKjHAw3DQdKMtRK3GSut2XXjUj1A4Ka4qbjUk8DXUcUcLYcJx+meVvPrpBk7qApctbFgmxJGWLxr+8CtEXilGd4fBks/MpZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877001; c=relaxed/simple;
	bh=jjkcJcgpHKB01itnZK57CGckHlKGfKxrAxymtWZp2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xzt2dBNAUCyCFQcLKOl5R3AJLuQcslqAk15Qv2qa706CGdSBf92adSeAPYDI1Mxkz6XM5SQuVBE8P3LLMe7L1DnITq/2ctXlfu63p9hlV/L4KJ5T1MInIf1xwd2fV4pP+SluBJuLlMQt3+DBN7ammmprdEoqnjIPlLth4CIq3JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7L25sM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7L25sM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6BBC4CEC2;
	Wed,  2 Oct 2024 13:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877000;
	bh=jjkcJcgpHKB01itnZK57CGckHlKGfKxrAxymtWZp2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7L25sM4QMr8vfk+bJCn8neXuWXJfOnkPT8TERWB3o8mrbks+7nHoUeItDpcLRnHX
	 yso8jKYbBai9O9jwzrVzQS57M3CRfU0MwD+lAxFJ3cdrhYP9HcN//y0TdHr1iHaqeY
	 vc5haZZ0dtlyk88itPxqEDVaC+SkcBg0JEGXzJ4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.11 599/695] serial: qcom-geni: fix false console tx restart
Date: Wed,  2 Oct 2024 14:59:57 +0200
Message-ID: <20241002125846.424094163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit f97cdbbf187fefcf1fe19689cd9fdca11fe9c3eb upstream.

Commit 663abb1a7a7f ("tty: serial: qcom_geni_serial: Fix UART hang")
addressed an issue with stalled tx after the console code interrupted
the last bytes of a tx command by reenabling the watermark interrupt if
there is data in write buffer. This can however break software flow
control by re-enabling tx after the user has stopped it.

Address the original issue by not clearing the CMD_DONE flag after
polling for command completion. This allows the interrupt handler to
start another transfer when the CMD_DONE interrupt has not been disabled
due to flow control.

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Fixes: 663abb1a7a7f ("tty: serial: qcom_geni_serial: Fix UART hang")
Cc: stable@vger.kernel.org	# 4.17
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240906131336.23625-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -306,18 +306,16 @@ static void qcom_geni_serial_setup_tx(st
 static void qcom_geni_serial_poll_tx_done(struct uart_port *uport)
 {
 	int done;
-	u32 irq_clear = M_CMD_DONE_EN;
 
 	done = qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_CMD_DONE_EN, true);
 	if (!done) {
 		writel(M_GENI_CMD_ABORT, uport->membase +
 						SE_GENI_M_CMD_CTRL_REG);
-		irq_clear |= M_CMD_ABORT_EN;
 		qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 							M_CMD_ABORT_EN, true);
+		writel(M_CMD_ABORT_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	}
-	writel(irq_clear, uport->membase + SE_GENI_M_IRQ_CLEAR);
 }
 
 static void qcom_geni_serial_abort_rx(struct uart_port *uport)
@@ -378,6 +376,7 @@ static void qcom_geni_serial_poll_put_ch
 							unsigned char c)
 {
 	writel(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(M_CMD_DONE_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	qcom_geni_serial_setup_tx(uport, 1);
 	WARN_ON(!qcom_geni_serial_poll_bit(uport, SE_GENI_M_IRQ_STATUS,
 						M_TX_FIFO_WATERMARK_EN, true));
@@ -422,6 +421,7 @@ __qcom_geni_serial_console_write(struct
 	}
 
 	writel(DEF_TX_WM, uport->membase + SE_GENI_TX_WATERMARK_REG);
+	writel(M_CMD_DONE_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	qcom_geni_serial_setup_tx(uport, bytes_to_send);
 	for (i = 0; i < count; ) {
 		size_t chars_to_write = 0;
@@ -463,7 +463,6 @@ static void qcom_geni_serial_console_wri
 	bool locked = true;
 	unsigned long flags;
 	u32 geni_status;
-	u32 irq_en;
 
 	WARN_ON(co->index < 0 || co->index >= GENI_UART_CONS_PORTS);
 
@@ -495,12 +494,6 @@ static void qcom_geni_serial_console_wri
 		 * has been sent, in which case we need to look for done first.
 		 */
 		qcom_geni_serial_poll_tx_done(uport);
-
-		if (!kfifo_is_empty(&uport->state->port.xmit_fifo)) {
-			irq_en = readl(uport->membase + SE_GENI_M_IRQ_EN);
-			writel(irq_en | M_TX_FIFO_WATERMARK_EN,
-					uport->membase + SE_GENI_M_IRQ_EN);
-		}
 	}
 
 	__qcom_geni_serial_console_write(uport, s, count);


