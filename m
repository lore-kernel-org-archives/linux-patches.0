Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD411BEF8C
	for <patches@lists.linux.dev>; Wed, 11 Dec 2024 04:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891159; cv=none; b=sa8IidCO1fgPBY5trj7S1X99FPt2uYKdDA87k56HA3b2DvaecdnI8be1DG7q2RrWwI1plPSiur+uHAGtoBThvvzb8PE+lSF3ac6wvhKXaY68SeVjh6U+PqMaroHPYvHEuaB61FwWOtWnXTPhJN98wkbyhCHaAzQsWF3uCsurVK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891159; c=relaxed/simple;
	bh=WKxcf40qvmMdjLWsBWMK9H2qV8uVtkrnVMk4uRVNqMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CcZrzOB9at4fdb7SXzUnvXij+FESsxW93CI3SIp6NTFbUZUj4GXbHIbBBCGxfz4AnV9EN5CO9aQBS9TsRMzwKXRMChN6JuaqYRF1FbDwj4xMNUt7w9To1+m53Y/RFA5SNFQ0RDkifK/KsIhFRJqXKcFAI8um6X5JQ0e6BJ+bYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=LVW+IDtT; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="LVW+IDtT"
Received: from hwang4-ThinkPad-T14s-Gen-2a.. (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 11FBC3FB97;
	Wed, 11 Dec 2024 04:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733891154;
	bh=+KC07NWYR1pG2ZrVLPViIM27VKL9Qaxk+l7XbOZMWGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=LVW+IDtTaYXaRjBuYhTA6e6mii4tUTxqY3j9fAMrxK4JrxK2Uk0ED20D/a3gqTHS6
	 cr09C7lOJp29tfy14nsIZe7QWZeiR9IE1ISUXf5Ec81zq86u1HH0ygT4UVu6hhWqcQ
	 eyO2tr6n0D3+zgl3bRmRnpgvgGaA8HKPca+3AHnq2XP3p9D2N9eZAGtOt9e5A2LDsl
	 EZk2fEJykwrcSdar5iAXoYIVWVjsExpiTlALEiwNXYRFJvaHq5xXPnpZ5GYxJzJ/Il
	 vqIZhV4YKhSAYryQewxAaKQHWtbi9T/GBX4zyY55aw7n97brIn/raDr3a4Mvb6FggZ
	 WKei1//MXzZsQ==
From: Hui Wang <hui.wang@canonical.com>
To: stable@vger.kernel.org,
	patches@lists.linux.dev,
	gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: hvilleneuve@dimonoff.com,
	hui.wang@canonical.com
Subject: [stable-kernel][5.15.y][PATCH 1/5] serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Date: Wed, 11 Dec 2024 12:25:40 +0800
Message-Id: <20241211042545.202482-2-hui.wang@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241211042545.202482-1-hui.wang@canonical.com>
References: <20241211042545.202482-1-hui.wang@canonical.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 3837a0379533aabb9e4483677077479f7c6aa910 upstream.

With this current driver regmap implementation, it is hard to make sense
of the register addresses displayed using the regmap debugfs interface,
because they do not correspond to the actual register addresses documented
in the datasheet. For example, register 1 is displayed as registers 04 thru
07:

$ cat /sys/kernel/debug/regmap/spi0.0/registers
  04: 10 -> Port 0, register offset 1
  05: 10 -> Port 1, register offset 1
  06: 00 -> Port 2, register offset 1 -> invalid
  07: 00 -> port 3, register offset 1 -> invalid
  ...

The reason is that bits 0 and 1 of the register address correspond to the
channel (port) bits, so the register address itself starts at bit 2, and we
must 'mentally' shift each register address by 2 bits to get its real
address/offset.

Also, only channels 0 and 1 are supported by the chip, so channel mask
combinations of 10b and 11b are invalid, and the display of these
registers is useless.

This patch adds a separate regmap configuration for each port, similar to
what is done in the max310x driver, so that register addresses displayed
match the register addresses in the chip datasheet. Also, each port now has
its own debugfs entry.

Example with new regmap implementation:

$ cat /sys/kernel/debug/regmap/spi0.0-port0/registers
1: 10
2: 01
3: 00
...

$ cat /sys/kernel/debug/regmap/spi0.0-port1/registers
1: 10
2: 01
3: 00

As an added bonus, this also simplifies some operations (read/write/modify)
because it is no longer necessary to manually shift register addresses.

[Hui: Fixed some conflict when backporting to 5.15.y]

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231030211447.974779-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/tty/serial/sc16is7xx.c | 136 +++++++++++++++++++--------------
 1 file changed, 79 insertions(+), 57 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index d274a847c6ab..88adbd9d5002 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -292,8 +292,9 @@
 						  */
 
 /* Misc definitions */
+#define SC16IS7XX_SPI_READ_BIT		BIT(7)
 #define SC16IS7XX_FIFO_SIZE		(64)
-#define SC16IS7XX_REG_SHIFT		2
+#define SC16IS7XX_GPIOS_PER_BANK	4
 
 struct sc16is7xx_devtype {
 	char	name[10];
@@ -313,6 +314,7 @@ struct sc16is7xx_one_config {
 struct sc16is7xx_one {
 	struct uart_port		port;
 	u8				line;
+	struct regmap			*regmap;
 	struct kthread_work		tx_work;
 	struct kthread_work		reg_work;
 	struct sc16is7xx_one_config	config;
@@ -344,46 +346,35 @@ static struct uart_driver sc16is7xx_uart = {
 #define to_sc16is7xx_port(p,e)	((container_of((p), struct sc16is7xx_port, e)))
 #define to_sc16is7xx_one(p,e)	((container_of((p), struct sc16is7xx_one, e)))
 
-static int sc16is7xx_line(struct uart_port *port)
-{
-	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-
-	return one->line;
-}
-
 static u8 sc16is7xx_port_read(struct uart_port *port, u8 reg)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int val = 0;
-	const u8 line = sc16is7xx_line(port);
 
-	regmap_read(s->regmap, (reg << SC16IS7XX_REG_SHIFT) | line, &val);
+	regmap_read(one->regmap, reg, &val);
 
 	return val;
 }
 
 static void sc16is7xx_port_write(struct uart_port *port, u8 reg, u8 val)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	const u8 line = sc16is7xx_line(port);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regmap_write(s->regmap, (reg << SC16IS7XX_REG_SHIFT) | line, val);
+	regmap_write(one->regmap, reg, val);
 }
 
 static void sc16is7xx_fifo_read(struct uart_port *port, unsigned int rxlen)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	const u8 line = sc16is7xx_line(port);
-	u8 addr = (SC16IS7XX_RHR_REG << SC16IS7XX_REG_SHIFT) | line;
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regmap_noinc_read(s->regmap, addr, s->buf, rxlen);
+	regmap_noinc_read(one->regmap, SC16IS7XX_RHR_REG, s->buf, rxlen);
 }
 
 static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	const u8 line = sc16is7xx_line(port);
-	u8 addr = (SC16IS7XX_THR_REG << SC16IS7XX_REG_SHIFT) | line;
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
 	/*
 	 * Don't send zero-length data, at least on SPI it confuses the chip
@@ -392,17 +383,15 @@ static void sc16is7xx_fifo_write(struct uart_port *port, u8 to_send)
 	if (unlikely(!to_send))
 		return;
 
-	regmap_noinc_write(s->regmap, addr, s->buf, to_send);
+	regmap_noinc_write(one->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
 }
 
 static void sc16is7xx_port_update(struct uart_port *port, u8 reg,
 				  u8 mask, u8 val)
 {
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
-	const u8 line = sc16is7xx_line(port);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 
-	regmap_update_bits(s->regmap, (reg << SC16IS7XX_REG_SHIFT) | line,
-			   mask, val);
+	regmap_update_bits(one->regmap, reg, mask, val);
 }
 
 static int sc16is7xx_alloc_line(void)
@@ -457,7 +446,7 @@ static const struct sc16is7xx_devtype sc16is762_devtype = {
 
 static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 {
-	switch (reg >> SC16IS7XX_REG_SHIFT) {
+	switch (reg) {
 	case SC16IS7XX_RHR_REG:
 	case SC16IS7XX_IIR_REG:
 	case SC16IS7XX_LSR_REG:
@@ -475,7 +464,7 @@ static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)
 
 static bool sc16is7xx_regmap_precious(struct device *dev, unsigned int reg)
 {
-	switch (reg >> SC16IS7XX_REG_SHIFT) {
+	switch (reg) {
 	case SC16IS7XX_RHR_REG:
 		return true;
 	default:
@@ -505,6 +494,7 @@ static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	u8 lcr;
 	unsigned int prescaler = 1;
 	unsigned long clk = port->uartclk, div = clk / 16 / baud;
@@ -536,10 +526,10 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 			     SC16IS7XX_LCR_CONF_MODE_B);
 
 	/* Enable enhanced features */
-	regcache_cache_bypass(s->regmap, true);
+	regcache_cache_bypass(one->regmap, true);
 	sc16is7xx_port_write(port, SC16IS7XX_EFR_REG,
 			     SC16IS7XX_EFR_ENABLE_BIT);
-	regcache_cache_bypass(s->regmap, false);
+	regcache_cache_bypass(one->regmap, false);
 
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
@@ -556,10 +546,10 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 			     SC16IS7XX_LCR_CONF_MODE_A);
 
 	/* Write the new divisor */
-	regcache_cache_bypass(s->regmap, true);
+	regcache_cache_bypass(one->regmap, true);
 	sc16is7xx_port_write(port, SC16IS7XX_DLH_REG, div / 256);
 	sc16is7xx_port_write(port, SC16IS7XX_DLL_REG, div % 256);
-	regcache_cache_bypass(s->regmap, false);
+	regcache_cache_bypass(one->regmap, false);
 
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
@@ -891,6 +881,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 				  struct ktermios *old)
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
+	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	unsigned int lcr, flow = 0;
 	int baud;
 
@@ -951,7 +942,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 			     SC16IS7XX_LCR_CONF_MODE_B);
 
 	/* Configure flow control */
-	regcache_cache_bypass(s->regmap, true);
+	regcache_cache_bypass(one->regmap, true);
 	sc16is7xx_port_write(port, SC16IS7XX_XON1_REG, termios->c_cc[VSTART]);
 	sc16is7xx_port_write(port, SC16IS7XX_XOFF1_REG, termios->c_cc[VSTOP]);
 	if (termios->c_cflag & CRTSCTS)
@@ -963,7 +954,7 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 		flow |= SC16IS7XX_EFR_SWFLOW1_BIT;
 
 	sc16is7xx_port_write(port, SC16IS7XX_EFR_REG, flow);
-	regcache_cache_bypass(s->regmap, false);
+	regcache_cache_bypass(one->regmap, false);
 
 	/* Update LCR register */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
@@ -1018,7 +1009,6 @@ static int sc16is7xx_config_rs485(struct uart_port *port,
 static int sc16is7xx_startup(struct uart_port *port)
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	unsigned int val;
 
 	sc16is7xx_power(port, 1);
@@ -1034,7 +1024,7 @@ static int sc16is7xx_startup(struct uart_port *port)
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
 			     SC16IS7XX_LCR_CONF_MODE_B);
 
-	regcache_cache_bypass(s->regmap, true);
+	regcache_cache_bypass(one->regmap, true);
 
 	/* Enable write access to enhanced features and internal clock div */
 	sc16is7xx_port_write(port, SC16IS7XX_EFR_REG,
@@ -1051,7 +1041,7 @@ static int sc16is7xx_startup(struct uart_port *port)
 			     SC16IS7XX_TCR_RX_RESUME(24) |
 			     SC16IS7XX_TCR_RX_HALT(48));
 
-	regcache_cache_bypass(s->regmap, false);
+	regcache_cache_bypass(one->regmap, false);
 
 	/* Now, initialize the UART */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, SC16IS7XX_LCR_WORD_LEN_8);
@@ -1216,7 +1206,7 @@ static int sc16is7xx_gpio_direction_output(struct gpio_chip *chip,
 
 static int sc16is7xx_probe(struct device *dev,
 			   const struct sc16is7xx_devtype *devtype,
-			   struct regmap *regmap, int irq)
+			   struct regmap *regmaps[], int irq)
 {
 	unsigned long freq = 0, *pfreq = dev_get_platdata(dev);
 	unsigned int val;
@@ -1224,16 +1214,16 @@ static int sc16is7xx_probe(struct device *dev,
 	int i, ret;
 	struct sc16is7xx_port *s;
 
-	if (IS_ERR(regmap))
-		return PTR_ERR(regmap);
+	for (i = 0; i < devtype->nr_uart; i++)
+		if (IS_ERR(regmaps[i]))
+			return PTR_ERR(regmaps[i]);
 
 	/*
 	 * This device does not have an identification register that would
 	 * tell us if we are really connected to the correct device.
 	 * The best we can do is to check if communication is at all possible.
 	 */
-	ret = regmap_read(regmap,
-			  SC16IS7XX_LSR_REG << SC16IS7XX_REG_SHIFT, &val);
+	ret = regmap_read(regmaps[0], SC16IS7XX_LSR_REG, &val);
 	if (ret < 0)
 		return -EPROBE_DEFER;
 
@@ -1267,7 +1257,7 @@ static int sc16is7xx_probe(struct device *dev,
 			return -EINVAL;
 	}
 
-	s->regmap = regmap;
+	s->regmap = regmaps[0];
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
 	mutex_init(&s->efr_lock);
@@ -1282,8 +1272,8 @@ static int sc16is7xx_probe(struct device *dev,
 	sched_set_fifo(s->kworker_task);
 
 	/* reset device, purging any pending irq / data */
-	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG << SC16IS7XX_REG_SHIFT,
-			SC16IS7XX_IOCONTROL_SRESET_BIT);
+	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG,
+		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
 		s->p[i].line		= i;
@@ -1305,6 +1295,8 @@ static int sc16is7xx_probe(struct device *dev,
 		s->p[i].port.rs485_config = sc16is7xx_config_rs485;
 		s->p[i].port.ops	= &sc16is7xx_ops;
 		s->p[i].port.line	= sc16is7xx_alloc_line();
+		s->p[i].regmap		= regmaps[i];
+
 		if (s->p[i].port.line >= SC16IS7XX_MAX_DEVS) {
 			ret = -ENOMEM;
 			goto out_ports;
@@ -1326,13 +1318,13 @@ static int sc16is7xx_probe(struct device *dev,
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_LCR_REG,
 				     SC16IS7XX_LCR_CONF_MODE_B);
 
-		regcache_cache_bypass(s->regmap, true);
+		regcache_cache_bypass(regmaps[i], true);
 
 		/* Enable write access to enhanced features */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_EFR_REG,
 				     SC16IS7XX_EFR_ENABLE_BIT);
 
-		regcache_cache_bypass(s->regmap, false);
+		regcache_cache_bypass(regmaps[i], false);
 
 		/* Restore access to general registers */
 		sc16is7xx_port_write(&s->p[i].port, SC16IS7XX_LCR_REG, 0x00);
@@ -1447,21 +1439,38 @@ static const struct of_device_id __maybe_unused sc16is7xx_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, sc16is7xx_dt_ids);
 
 static struct regmap_config regcfg = {
-	.reg_bits = 7,
-	.pad_bits = 1,
+	.reg_bits = 5,
+	.pad_bits = 3,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
 	.volatile_reg = sc16is7xx_regmap_volatile,
 	.precious_reg = sc16is7xx_regmap_precious,
 	.writeable_noinc_reg = sc16is7xx_regmap_noinc,
 	.readable_noinc_reg = sc16is7xx_regmap_noinc,
+	.max_register = SC16IS7XX_EFCR_REG,
 };
 
+static const char *sc16is7xx_regmap_name(unsigned int port_id)
+{
+	static char buf[6];
+
+	snprintf(buf, sizeof(buf), "port%d", port_id);
+
+	return buf;
+}
+
+static unsigned int sc16is7xx_regmap_port_mask(unsigned int port_id)
+{
+	/* CH1,CH0 are at bits 2:1. */
+	return port_id << 1;
+}
+
 #ifdef CONFIG_SERIAL_SC16IS7XX_SPI
 static int sc16is7xx_spi_probe(struct spi_device *spi)
 {
 	const struct sc16is7xx_devtype *devtype;
-	struct regmap *regmap;
+	struct regmap *regmaps[2];
+	unsigned int i;
 	int ret;
 
 	/* Setup SPI bus */
@@ -1486,11 +1495,20 @@ static int sc16is7xx_spi_probe(struct spi_device *spi)
 		devtype = (struct sc16is7xx_devtype *)id_entry->driver_data;
 	}
 
-	regcfg.max_register = (0xf << SC16IS7XX_REG_SHIFT) |
-			      (devtype->nr_uart - 1);
-	regmap = devm_regmap_init_spi(spi, &regcfg);
+	for (i = 0; i < devtype->nr_uart; i++) {
+		regcfg.name = sc16is7xx_regmap_name(i);
+		/*
+		 * If read_flag_mask is 0, the regmap code sets it to a default
+		 * of 0x80. Since we specify our own mask, we must add the READ
+		 * bit ourselves:
+		 */
+		regcfg.read_flag_mask = sc16is7xx_regmap_port_mask(i) |
+			SC16IS7XX_SPI_READ_BIT;
+		regcfg.write_flag_mask = sc16is7xx_regmap_port_mask(i);
+		regmaps[i] = devm_regmap_init_spi(spi, &regcfg);
+	}
 
-	return sc16is7xx_probe(&spi->dev, devtype, regmap, spi->irq);
+	return sc16is7xx_probe(&spi->dev, devtype, regmaps, spi->irq);
 }
 
 static int sc16is7xx_spi_remove(struct spi_device *spi)
@@ -1529,7 +1547,8 @@ static int sc16is7xx_i2c_probe(struct i2c_client *i2c,
 			       const struct i2c_device_id *id)
 {
 	const struct sc16is7xx_devtype *devtype;
-	struct regmap *regmap;
+	struct regmap *regmaps[2];
+	unsigned int i;
 
 	if (i2c->dev.of_node) {
 		devtype = device_get_match_data(&i2c->dev);
@@ -1539,11 +1558,14 @@ static int sc16is7xx_i2c_probe(struct i2c_client *i2c,
 		devtype = (struct sc16is7xx_devtype *)id->driver_data;
 	}
 
-	regcfg.max_register = (0xf << SC16IS7XX_REG_SHIFT) |
-			      (devtype->nr_uart - 1);
-	regmap = devm_regmap_init_i2c(i2c, &regcfg);
+	for (i = 0; i < devtype->nr_uart; i++) {
+		regcfg.name = sc16is7xx_regmap_name(i);
+		regcfg.read_flag_mask = sc16is7xx_regmap_port_mask(i);
+		regcfg.write_flag_mask = sc16is7xx_regmap_port_mask(i);
+		regmaps[i] = devm_regmap_init_i2c(i2c, &regcfg);
+	}
 
-	return sc16is7xx_probe(&i2c->dev, devtype, regmap, i2c->irq);
+	return sc16is7xx_probe(&i2c->dev, devtype, regmaps, i2c->irq);
 }
 
 static int sc16is7xx_i2c_remove(struct i2c_client *client)
-- 
2.34.1

