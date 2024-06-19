Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F83146D49;
	Wed, 19 Jun 2024 13:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802668; cv=none; b=szAt35JbbRjzvfY+JKo6wbACvmiBRa/ASaTpTl1iagLdJkhOqIsfaxDriAX8ONCqMCA9Yoom4DiHrAqZqclYBW6HpkzxaI1L3L6SqRsAdKRA6XVLEUJmgRSgvVsiTgJnm/UiTXP5ohyD0FSXgLxBx0mh8syF9YK5KgVRBRpSFUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802668; c=relaxed/simple;
	bh=zAbkVeKMRYnlvDx0pxbFjZuOYe+MaIbfPkJ4RnYQj1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7lvM7b0VSiHgpHinrjxLuAjhNA6wiusXFboxKBmfdgI9m6HkvXeYXscGIjXZyy+ejJmymL8+7P/aoqTP37bwOm5Revd0iUTXzmtMKq26a+W52lzuqsGTHnpcdG9+9OXBKTjfhRoyH6O4z06zmH5/ecOj1CQ9tReUXo8Ne3q4pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N90+AWbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N90+AWbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F7CC4AF1A;
	Wed, 19 Jun 2024 13:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802668;
	bh=zAbkVeKMRYnlvDx0pxbFjZuOYe+MaIbfPkJ4RnYQj1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N90+AWblUnc/p2MUQxssFdBjIE4NMOra5zRdN+YJg2ZgR34fPOGt4Apxlb7ZsAyqd
	 yXFIvzpiU8ABTOogGEyG6FfcPwjycN75DXKD2TlSIEqXkwuNtZ+80IgF9TbF6koXDU
	 w6Al9dtxqsqDTvcwmKn8VBPqLp5hgCTlTemTnVm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/267] serial: 8250_dw: Switch to use uart_read_port_properties()
Date: Wed, 19 Jun 2024 14:56:51 +0200
Message-ID: <20240619125616.294445975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e6a46d073e11baba785245860c9f51adbbb8b68d ]

Since we have now a common helper to read port properties
use it instead of sparse home grown solution.

Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240304123035.758700-8-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 67 +++++++++++++------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index a1f2259cc9a98..0446ac145cd4a 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -17,7 +17,6 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
-#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/property.h>
@@ -449,12 +448,7 @@ static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 
 	if (np) {
 		unsigned int quirks = data->pdata->quirks;
-		int id;
 
-		/* get index of serial line, if found in DT aliases */
-		id = of_alias_get_id(np, "serial");
-		if (id >= 0)
-			p->line = id;
 #ifdef CONFIG_64BIT
 		if (quirks & DW_UART_QUIRK_OCTEON) {
 			p->serial_in = dw8250_serial_inq;
@@ -465,12 +459,6 @@ static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 		}
 #endif
 
-		if (of_device_is_big_endian(np)) {
-			p->iotype = UPIO_MEM32BE;
-			p->serial_in = dw8250_serial_in32be;
-			p->serial_out = dw8250_serial_out32be;
-		}
-
 		if (quirks & DW_UART_QUIRK_ARMADA_38X)
 			p->serial_out = dw8250_serial_out38x;
 		if (quirks & DW_UART_QUIRK_SKIP_SET_RATE)
@@ -515,39 +503,21 @@ static int dw8250_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct dw8250_data *data;
 	struct resource *regs;
-	int irq;
 	int err;
-	u32 val;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs)
 		return dev_err_probe(dev, -EINVAL, "no registers defined\n");
 
-	irq = platform_get_irq_optional(pdev, 0);
-	/* no interrupt -> fall back to polling */
-	if (irq == -ENXIO)
-		irq = 0;
-	if (irq < 0)
-		return irq;
-
 	spin_lock_init(&p->lock);
-	p->mapbase	= regs->start;
-	p->irq		= irq;
 	p->handle_irq	= dw8250_handle_irq;
 	p->pm		= dw8250_do_pm;
 	p->type		= PORT_8250;
-	p->flags	= UPF_SHARE_IRQ | UPF_FIXED_PORT;
+	p->flags	= UPF_FIXED_PORT;
 	p->dev		= dev;
-	p->iotype	= UPIO_MEM;
-	p->serial_in	= dw8250_serial_in;
-	p->serial_out	= dw8250_serial_out;
 	p->set_ldisc	= dw8250_set_ldisc;
 	p->set_termios	= dw8250_set_termios;
 
-	p->membase = devm_ioremap(dev, regs->start, resource_size(regs));
-	if (!p->membase)
-		return -ENOMEM;
-
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -559,15 +529,35 @@ static int dw8250_probe(struct platform_device *pdev)
 	data->uart_16550_compatible = device_property_read_bool(dev,
 						"snps,uart-16550-compatible");
 
-	err = device_property_read_u32(dev, "reg-shift", &val);
-	if (!err)
-		p->regshift = val;
+	p->mapbase = regs->start;
+	p->mapsize = resource_size(regs);
 
-	err = device_property_read_u32(dev, "reg-io-width", &val);
-	if (!err && val == 4) {
-		p->iotype = UPIO_MEM32;
+	p->membase = devm_ioremap(dev, p->mapbase, p->mapsize);
+	if (!p->membase)
+		return -ENOMEM;
+
+	err = uart_read_port_properties(p);
+	/* no interrupt -> fall back to polling */
+	if (err == -ENXIO)
+		err = 0;
+	if (err)
+		return err;
+
+	switch (p->iotype) {
+	case UPIO_MEM:
+		p->serial_in = dw8250_serial_in;
+		p->serial_out = dw8250_serial_out;
+		break;
+	case UPIO_MEM32:
 		p->serial_in = dw8250_serial_in32;
 		p->serial_out = dw8250_serial_out32;
+		break;
+	case UPIO_MEM32BE:
+		p->serial_in = dw8250_serial_in32be;
+		p->serial_out = dw8250_serial_out32be;
+		break;
+	default:
+		return -ENODEV;
 	}
 
 	if (device_property_read_bool(dev, "dcd-override")) {
@@ -594,9 +584,6 @@ static int dw8250_probe(struct platform_device *pdev)
 		data->msr_mask_off |= UART_MSR_TERI;
 	}
 
-	/* Always ask for fixed clock rate from a property. */
-	device_property_read_u32(dev, "clock-frequency", &p->uartclk);
-
 	/* If there is separate baudclk, get the rate from it. */
 	data->clk = devm_clk_get_optional(dev, "baudclk");
 	if (data->clk == NULL)
-- 
2.43.0



