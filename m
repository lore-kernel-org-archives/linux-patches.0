Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8713161BF;
	Mon, 13 Apr 2026 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098944; cv=none; b=ameUEQ6AFfiHG9l532CblQ59xdVGVp78eHjMsNzsua6is4wcOQPgCMSJywTToKhWJ4BSCUv/DQ8k1+d56MUszPtDUKlDjSDGe9fltXrFYXJeg92DEh2VALM5Z1+aPtPUyO2OBdp8kNsNJOqIt8XN2ThKm0Zf1w+FLxpTpYNAZ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098944; c=relaxed/simple;
	bh=bHfKr70erzd/Z2pB+NQ9/Jc4UlRqhbtdH0qYSjh1+eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFPPSBH2ZP5CaxkjMLZNAP1SWGhYDjLfdeh/cJrLVX3x7LuAcD+M0tt4XGdFgC4wiC2dMcrEObiw1QGBlsEDVFYL/XpEm+WKeCqe3bIM4FQDkUsgy3z9QbscBtbvt4uSohSKQVTCz6AuV5ugwIin8QmJL4h9foyuCz4n0fJwIao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0HUAdKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0HUAdKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C912EC2BCAF;
	Mon, 13 Apr 2026 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098944;
	bh=bHfKr70erzd/Z2pB+NQ9/Jc4UlRqhbtdH0qYSjh1+eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0HUAdKb1nbRKFMHwrV9IvdSR4HTgeDiG+SGyFRCrHX9aiCBzvCjZ6QqdJreXWAlM
	 6SS7pUDxgdOiYHbW1WtrwlvlcwKxtL+qU00cabtRUrgwvJ/bng0nCuF3wyaB+ZwhKu
	 DfLhwd6iXdps4fSCWkNZ22HW89z3TkFa//klGBQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 5.10 150/491] serial: 8250: Add late synchronize_irq() to shutdown to handle DW UART BUSY
Date: Mon, 13 Apr 2026 17:56:35 +0200
Message-ID: <20260413155824.648462911@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit e0a368ae79531ff92105a2692f10d83052055856 upstream.

When DW UART is !uart_16550_compatible, it can indicate BUSY at any
point (when under constant Rx pressure) unless a complex sequence of
steps is performed. Any LCR write can run a foul with the condition
that prevents writing LCR while the UART is BUSY, which triggers
BUSY_DETECT interrupt that seems unmaskable using IER bits.

Normal flow is that dw8250_handle_irq() handles BUSY_DETECT condition
by reading USR register. This BUSY feature, however, breaks the
assumptions made in serial8250_do_shutdown(), which runs
synchronize_irq() after clearing IER and assumes no interrupts can
occur after that point but then proceeds to update LCR, which on DW
UART can trigger an interrupt.

If serial8250_do_shutdown() releases the interrupt handler before the
handler has run and processed the BUSY_DETECT condition by read the USR
register, the IRQ is not deasserted resulting in interrupt storm that
triggers "irq x: nobody cared" warning leading to disabling the IRQ.

Add late synchronize_irq() into serial8250_do_shutdown() to ensure
BUSY_DETECT from DW UART is handled before port's interrupt handler is
released. Alternative would be to add DW UART specific shutdown
function but it would mostly duplicate the generic code and the extra
synchronize_irq() seems pretty harmless in serial8250_do_shutdown().

Fixes: 7d4008ebb1c9 ("tty: add a DesignWare 8250 driver")
Cc: stable <stable@kernel.org>
Reported-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-7-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2485,6 +2485,12 @@ void serial8250_do_shutdown(struct uart_
 	 * the IRQ chain.
 	 */
 	serial_port_in(port, UART_RX);
+	/*
+	 * LCR writes on DW UART can trigger late (unmaskable) IRQs.
+	 * Handle them before releasing the handler.
+	 */
+	synchronize_irq(port->irq);
+
 	serial8250_rpm_put(up);
 
 	up->ops->release_irq(up);


