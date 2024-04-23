Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA68D143888;
	Tue, 23 Apr 2024 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908631; cv=none; b=kbPhAd0PKzlMEMwBHvHty2vQbMeZyfy68kfZKS73zlrSroYBrlNr/14Vk18rH+URjsaCf5i3C/OhBpIN35akAHHwqezDGVGUsMrfU5c8CmhI/dFmR6gZOu5sE0owqPQFXiqYRl+G+EnprdMvoQwJsjruu0XKsqBC7kH8hDKQ7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908631; c=relaxed/simple;
	bh=MfoT0RlPWWbruz5KfyNMTjg0AtOLDXCTaWcdlBywGv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErQbOUxm8vIHuFZpUo+FGDK+AaJwEOoM2/SEM4RTgaU5gOQZDEMpqrTVGdO5rXAi/Q46eetocZSs1U/b3uNVFVgSA7r4U5dFiaCWiAyNWr/VIBJXowXo6aNRxKHno9+Q+5LqP0Wmru+MDa3wqtcSzE762AJxkZsHj2j7iH4Xk8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVRquKLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVRquKLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02E6C3277B;
	Tue, 23 Apr 2024 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908631;
	bh=MfoT0RlPWWbruz5KfyNMTjg0AtOLDXCTaWcdlBywGv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVRquKLewkyViWvvfEb0/Cb57vVt0nLZY0k+aE/oaP4YFg1eYmCAVQyzihcyPU1sb
	 p9uTIq+G3/+GsP7nCjqs34NhTtnIvPcw5o25eB6bKNbj6LISAbdMaA35vlNesVj+Z+
	 QaFme/kqOIk9WkaUt02g/MFrxRE6HpmnoutQHKLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 6.6 111/158] serial: stm32: Return IRQ_NONE in the ISR if no handling happend
Date: Tue, 23 Apr 2024 14:39:08 -0700
Message-ID: <20240423213859.352676091@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 13c785323b36b845300b256d0e5963c3727667d7 upstream.

If there is a stuck irq that the handler doesn't address, returning
IRQ_HANDLED unconditionally makes it impossible for the irq core to
detect the problem and disable the irq. So only return IRQ_HANDLED if
an event was handled.

A stuck irq is still problematic, but with this change at least it only
makes the UART nonfunctional instead of occupying the (usually only) CPU
by 100% and so stall the whole machine.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/5f92603d0dfd8a5b8014b2b10a902d91e0bb881f.1713344161.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -857,6 +857,7 @@ static irqreturn_t stm32_usart_interrupt
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	u32 sr;
 	unsigned int size;
+	irqreturn_t ret = IRQ_NONE;
 
 	sr = readl_relaxed(port->membase + ofs->isr);
 
@@ -865,11 +866,14 @@ static irqreturn_t stm32_usart_interrupt
 	    (sr & USART_SR_TC)) {
 		stm32_usart_tc_interrupt_disable(port);
 		stm32_usart_rs485_rts_disable(port);
+		ret = IRQ_HANDLED;
 	}
 
-	if ((sr & USART_SR_RTOF) && ofs->icr != UNDEF_REG)
+	if ((sr & USART_SR_RTOF) && ofs->icr != UNDEF_REG) {
 		writel_relaxed(USART_ICR_RTOCF,
 			       port->membase + ofs->icr);
+		ret = IRQ_HANDLED;
+	}
 
 	if ((sr & USART_SR_WUF) && ofs->icr != UNDEF_REG) {
 		/* Clear wake up flag and disable wake up interrupt */
@@ -878,6 +882,7 @@ static irqreturn_t stm32_usart_interrupt
 		stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_WUFIE);
 		if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
 			pm_wakeup_event(tport->tty->dev, 0);
+		ret = IRQ_HANDLED;
 	}
 
 	/*
@@ -892,6 +897,7 @@ static irqreturn_t stm32_usart_interrupt
 			uart_unlock_and_check_sysrq(port);
 			if (size)
 				tty_flip_buffer_push(tport);
+			ret = IRQ_HANDLED;
 		}
 	}
 
@@ -899,6 +905,7 @@ static irqreturn_t stm32_usart_interrupt
 		spin_lock(&port->lock);
 		stm32_usart_transmit_chars(port);
 		spin_unlock(&port->lock);
+		ret = IRQ_HANDLED;
 	}
 
 	/* Receiver timeout irq for DMA RX */
@@ -908,9 +915,10 @@ static irqreturn_t stm32_usart_interrupt
 		uart_unlock_and_check_sysrq(port);
 		if (size)
 			tty_flip_buffer_push(tport);
+		ret = IRQ_HANDLED;
 	}
 
-	return IRQ_HANDLED;
+	return ret;
 }
 
 static void stm32_usart_set_mctrl(struct uart_port *port, unsigned int mctrl)


