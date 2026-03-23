Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD343AC0C9;
	Mon, 23 Mar 2026 13:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273961; cv=none; b=rF3eiyY6icuYLSsx/ndQz9VLxRBqk1kQV+kqvTvD52APE88CIEa6MyvtZUsw5PH2qvFlSs9og8emB0rg0nmgbJEM4WHOBsC0gyBDIQEXtn0VpyGLzCFOIs26uo3W5e1nWiX0gRezvUCgckGl+MTLcWjJ0a4GZ9tWvcF0CRkzkI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273961; c=relaxed/simple;
	bh=T0rxlSycWTmnhfiTnWrYQwaQe3EDPdEMh5vfuGWj6co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtZfV3LCBRFJieLeEsL6/ilwaukikZAbn8W0GUzWGwbmd8aNtCknKxIoW6jS5zWTy/QMNC/QhCTzr07KFJh3fd2U9PsZ6fIDkcFrwAYWzi/e1YhpWQw9QJ/c86qNQ2K1a+7peoBLlQq3by9d3DMTxgq25BnOq3K6LLJHfoqA7e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRuvacnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRuvacnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36F9C4CEF7;
	Mon, 23 Mar 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273961;
	bh=T0rxlSycWTmnhfiTnWrYQwaQe3EDPdEMh5vfuGWj6co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRuvacnQjFlF7WCtQUarNhUOC6UGqezt5BKfAFWXaMLOgRK1hNn0GlI7L7jrBb8rw
	 RrLl7ifXBk/qeVySBahG9pnsAFcjEUrLLNJGLvvlbzpRvYSkOTUaht8YXeNOE39O6P
	 zjGSYB1S1OnS6XfbtX1X31KPkusBW6HTsd7n/JgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bandal, Shankar" <shankar.bandal@intel.com>,
	"Murthy, Shanth" <shanth.murthy@intel.com>,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.19 063/220] serial: 8250_dw: Avoid unnecessary LCR writes
Date: Mon, 23 Mar 2026 14:44:00 +0100
Message-ID: <20260323134506.582825175@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 8002d6d6d0d8a36a7d6ca523b17a51cb0fa7c3c3 upstream.

When DW UART is configured with BUSY flag, LCR writes may not always
succeed which can make any LCR write complex and very expensive.
Performing write directly can trigger IRQ and the driver has to perform
complex and distruptive sequence while retrying the write.

Therefore, it's better to avoid doing LCR write that would not change
the value of the LCR register. Add LCR write avoidance code into the
8250_dw driver's .serial_out() functions.

Reported-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Bandal, Shankar <shankar.bandal@intel.com>
Tested-by: Murthy, Shanth <shanth.murthy@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260203171049.4353-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -181,6 +181,22 @@ static void dw8250_check_lcr(struct uart
 	 */
 }
 
+/*
+ * With BUSY, LCR writes can be very expensive (IRQ + complex retry logic).
+ * If the write does not change the value of the LCR register, skip it entirely.
+ */
+static bool dw8250_can_skip_reg_write(struct uart_port *p, unsigned int offset, u32 value)
+{
+	struct dw8250_data *d = to_dw8250_data(p->private_data);
+	u32 lcr;
+
+	if (offset != UART_LCR || d->uart_16550_compatible)
+		return false;
+
+	lcr = serial_port_in(p, offset);
+	return lcr == value;
+}
+
 /* Returns once the transmitter is empty or we run out of retries */
 static void dw8250_tx_wait_empty(struct uart_port *p)
 {
@@ -207,12 +223,18 @@ static void dw8250_tx_wait_empty(struct
 
 static void dw8250_serial_out(struct uart_port *p, unsigned int offset, u32 value)
 {
+	if (dw8250_can_skip_reg_write(p, offset, value))
+		return;
+
 	writeb(value, p->membase + (offset << p->regshift));
 	dw8250_check_lcr(p, offset, value);
 }
 
 static void dw8250_serial_out38x(struct uart_port *p, unsigned int offset, u32 value)
 {
+	if (dw8250_can_skip_reg_write(p, offset, value))
+		return;
+
 	/* Allow the TX to drain before we reconfigure */
 	if (offset == UART_LCR)
 		dw8250_tx_wait_empty(p);
@@ -237,6 +259,9 @@ static u32 dw8250_serial_inq(struct uart
 
 static void dw8250_serial_outq(struct uart_port *p, unsigned int offset, u32 value)
 {
+	if (dw8250_can_skip_reg_write(p, offset, value))
+		return;
+
 	value &= 0xff;
 	__raw_writeq(value, p->membase + (offset << p->regshift));
 	/* Read back to ensure register write ordering. */
@@ -248,6 +273,9 @@ static void dw8250_serial_outq(struct ua
 
 static void dw8250_serial_out32(struct uart_port *p, unsigned int offset, u32 value)
 {
+	if (dw8250_can_skip_reg_write(p, offset, value))
+		return;
+
 	writel(value, p->membase + (offset << p->regshift));
 	dw8250_check_lcr(p, offset, value);
 }
@@ -261,6 +289,9 @@ static u32 dw8250_serial_in32(struct uar
 
 static void dw8250_serial_out32be(struct uart_port *p, unsigned int offset, u32 value)
 {
+	if (dw8250_can_skip_reg_write(p, offset, value))
+		return;
+
 	iowrite32be(value, p->membase + (offset << p->regshift));
 	dw8250_check_lcr(p, offset, value);
 }


