Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716AF3DE428;
	Tue, 16 Jun 2026 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781637019; cv=none; b=IdZannwlZat03aREdzgF6ryl3b2p+8L2kHqQJBFs86A2gxAM9tgfsREEX/gwlHuo0M5Z4aBq2Hdm/m2Fa+8zSRzxyYCrHtQZ3o/eZYgJGMJ2dNt+fdyqoyR+8Bv5Wfk0zV1TjjqdnHyjufjjjyOa8XC7fjToL/Mm8RVvtSxP/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781637019; c=relaxed/simple;
	bh=c/dOxhIogakXzaljREY8zsHZay198n5OnPvRAMfW/qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoB2sWNSxq9BhdUfvLL/hZz//2ga30UVNLDkVxCQkG30yDAVKOEw+7cHfkyi1mazgjPNJPMLtw2I6jl/ERLF7JSp9Crj4veWD/rHP/uT2ubXPJRmTyANA6VaL9/jPxu8VwOsnFzwNckMD38GHRgRq4KW+UUZKD0bftEuK5mYfIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx3G0ZU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx3G0ZU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756A71F000E9;
	Tue, 16 Jun 2026 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781637018;
	bh=ZRaHk94nfJw2hTW2hy3ay3fEeQ8lgnplCVK8zynxw9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xx3G0ZU/1m4AHRi7G+YkV8e6EHuwHZiDafLe0c8Hk7WliaGLlnOA6TSU2QBdDUx+5
	 biAPc1jcGlH8iNWR6Ja6JNLggjKSATRGZYOYB8FFH0U8uq5pLo93RA/9WCcEeCwGnJ
	 JmvXKzVBDsSVslftTWzz+v3mjPJYmYosVHcC8yCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/342] tty: serial: samsung: use u32 for register interactions
Date: Tue, 16 Jun 2026 20:30:24 +0530
Message-ID: <20260616145103.869160173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit 032a725c16add79332d774348d7ad7d0d4b86479 ]

All registers of the IP have 32 bits. Use u32 variables when reading
or writing from/to the registers. The purpose of those variables becomes
clearer.

Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240119104526.1221243-9-tudor.ambarus@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a3bb136bff5e ("tty: serial: samsung: Remove redundant port lock acquisition in rx helpers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung_tty.c |   67 +++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -186,7 +186,7 @@ static void wr_reg(struct uart_port *por
 /* Byte-order aware bit setting/clearing functions. */
 
 static inline void s3c24xx_set_bit(struct uart_port *port, int idx,
-				   unsigned int reg)
+				   u32 reg)
 {
 	unsigned long flags;
 	u32 val;
@@ -199,7 +199,7 @@ static inline void s3c24xx_set_bit(struc
 }
 
 static inline void s3c24xx_clear_bit(struct uart_port *port, int idx,
-				     unsigned int reg)
+				     u32 reg)
 {
 	unsigned long flags;
 	u32 val;
@@ -242,8 +242,8 @@ static void s3c24xx_serial_rx_enable(str
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 	unsigned long flags;
-	unsigned int ucon, ufcon;
 	int count = 10000;
+	u32 ucon, ufcon;
 
 	uart_port_lock_irqsave(port, &flags);
 
@@ -266,7 +266,7 @@ static void s3c24xx_serial_rx_disable(st
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 	unsigned long flags;
-	unsigned int ucon;
+	u32 ucon;
 
 	uart_port_lock_irqsave(port, &flags);
 
@@ -551,7 +551,7 @@ static inline struct s3c2410_uartcfg
 }
 
 static int s3c24xx_serial_rx_fifocnt(struct s3c24xx_uart_port *ourport,
-				     unsigned long ufstat)
+				     u32 ufstat)
 {
 	struct s3c24xx_uart_info *info = ourport->info;
 
@@ -623,7 +623,7 @@ static void s3c64xx_start_rx_dma(struct
 static void enable_rx_dma(struct s3c24xx_uart_port *ourport)
 {
 	struct uart_port *port = &ourport->port;
-	unsigned int ucon;
+	u32 ucon;
 
 	/* set Rx mode to DMA mode */
 	ucon = rd_regl(port, S3C2410_UCON);
@@ -646,7 +646,7 @@ static void enable_rx_dma(struct s3c24xx
 static void enable_rx_pio(struct s3c24xx_uart_port *ourport)
 {
 	struct uart_port *port = &ourport->port;
-	unsigned int ucon;
+	u32 ucon;
 
 	/* set Rx mode to DMA mode */
 	ucon = rd_regl(port, S3C2410_UCON);
@@ -667,7 +667,6 @@ static void s3c24xx_serial_rx_drain_fifo
 
 static irqreturn_t s3c24xx_serial_rx_chars_dma(void *dev_id)
 {
-	unsigned int utrstat, received;
 	struct s3c24xx_uart_port *ourport = dev_id;
 	struct uart_port *port = &ourport->port;
 	struct s3c24xx_uart_dma *dma = ourport->dma;
@@ -675,6 +674,8 @@ static irqreturn_t s3c24xx_serial_rx_cha
 	struct tty_port *t = &port->state->port;
 	unsigned long flags;
 	struct dma_tx_state state;
+	unsigned int received;
+	u32 utrstat;
 
 	utrstat = rd_regl(port, S3C2410_UTRSTAT);
 	rd_regl(port, S3C2410_UFSTAT);
@@ -716,9 +717,10 @@ finish:
 static void s3c24xx_serial_rx_drain_fifo(struct s3c24xx_uart_port *ourport)
 {
 	struct uart_port *port = &ourport->port;
-	unsigned int ufcon, ch, flag, ufstat, uerstat;
+	unsigned int ch, flag;
 	unsigned int fifocnt = 0;
 	int max_count = port->fifosize;
+	u32 ufcon, ufstat, uerstat;
 
 	while (max_count-- > 0) {
 		/*
@@ -898,7 +900,7 @@ static irqreturn_t s3c64xx_serial_handle
 {
 	struct s3c24xx_uart_port *ourport = id;
 	struct uart_port *port = &ourport->port;
-	unsigned int pend = rd_regl(port, S3C64XX_UINTP);
+	u32 pend = rd_regl(port, S3C64XX_UINTP);
 	irqreturn_t ret = IRQ_HANDLED;
 
 	if (pend & S3C64XX_UINTM_RXD_MSK) {
@@ -915,8 +917,8 @@ static irqreturn_t s3c64xx_serial_handle
 static unsigned int s3c24xx_serial_tx_empty(struct uart_port *port)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-	unsigned long ufstat = rd_regl(port, S3C2410_UFSTAT);
-	unsigned long ufcon = rd_regl(port, S3C2410_UFCON);
+	u32 ufstat = rd_regl(port, S3C2410_UFSTAT);
+	u32 ufcon = rd_regl(port, S3C2410_UFCON);
 
 	if (ufcon & S3C2410_UFCON_FIFOMODE) {
 		if ((ufstat & info->tx_fifomask) != 0 ||
@@ -931,7 +933,7 @@ static unsigned int s3c24xx_serial_tx_em
 /* no modem control lines */
 static unsigned int s3c24xx_serial_get_mctrl(struct uart_port *port)
 {
-	unsigned int umstat = rd_reg(port, S3C2410_UMSTAT);
+	u32 umstat = rd_reg(port, S3C2410_UMSTAT);
 
 	if (umstat & S3C2410_UMSTAT_CTS)
 		return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
@@ -941,7 +943,7 @@ static unsigned int s3c24xx_serial_get_m
 
 static void s3c24xx_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	unsigned int umcon = rd_regl(port, S3C2410_UMCON);
+	u32 umcon = rd_regl(port, S3C2410_UMCON);
 
 	if (mctrl & TIOCM_RTS)
 		umcon |= S3C2410_UMCOM_RTS_LOW;
@@ -954,7 +956,7 @@ static void s3c24xx_serial_set_mctrl(str
 static void s3c24xx_serial_break_ctl(struct uart_port *port, int break_state)
 {
 	unsigned long flags;
-	unsigned int ucon;
+	u32 ucon;
 
 	uart_port_lock_irqsave(port, &flags);
 
@@ -1167,7 +1169,7 @@ static int s3c64xx_serial_startup(struct
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 	unsigned long flags;
-	unsigned int ufcon;
+	u32 ufcon;
 	int ret;
 
 	wr_regl(port, S3C64XX_UINTM, 0xf);
@@ -1210,6 +1212,7 @@ static int s3c64xx_serial_startup(struct
 	return ret;
 }
 
+
 /* power power management control */
 
 static void s3c24xx_serial_pm(struct uart_port *port, unsigned int level,
@@ -1261,7 +1264,7 @@ static void s3c24xx_serial_pm(struct uar
 static inline int s3c24xx_serial_getsource(struct uart_port *port)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-	unsigned int ucon;
+	u32 ucon;
 
 	if (info->num_clks == 1)
 		return 0;
@@ -1275,7 +1278,7 @@ static void s3c24xx_serial_setsource(str
 			unsigned int clk_sel)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-	unsigned int ucon;
+	u32 ucon;
 
 	if (info->num_clks == 1)
 		return;
@@ -1394,9 +1397,8 @@ static void s3c24xx_serial_set_termios(s
 	struct clk *clk = ERR_PTR(-EINVAL);
 	unsigned long flags;
 	unsigned int baud, quot, clk_sel = 0;
-	unsigned int ulcon;
-	unsigned int umcon;
 	unsigned int udivslot = 0;
+	u32 ulcon, umcon;
 
 	/*
 	 * We don't support modem control lines.
@@ -1712,7 +1714,7 @@ static void s3c24xx_serial_resetport(str
 				   struct s3c2410_uartcfg *cfg)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-	unsigned long ucon = rd_regl(port, S3C2410_UCON);
+	u32 ucon = rd_regl(port, S3C2410_UCON);
 	unsigned int ucon_mask;
 
 	ucon_mask = info->clksel_mask;
@@ -2150,7 +2152,7 @@ static int s3c24xx_serial_resume_noirq(s
 	if (port) {
 		/* restore IRQ mask */
 		if (s3c24xx_serial_has_interrupt_mask(port)) {
-			unsigned int uintm = 0xf;
+			u32 uintm = 0xf;
 
 			if (ourport->tx_enabled)
 				uintm &= ~S3C64XX_UINTM_TXD_MSK;
@@ -2188,10 +2190,10 @@ static const struct dev_pm_ops s3c24xx_s
 static struct uart_port *cons_uart;
 
 static int
-s3c24xx_serial_console_txrdy(struct uart_port *port, unsigned int ufcon)
+s3c24xx_serial_console_txrdy(struct uart_port *port, u32 ufcon)
 {
 	struct s3c24xx_uart_info *info = s3c24xx_port_to_info(port);
-	unsigned long ufstat, utrstat;
+	u32 ufstat, utrstat;
 
 	if (ufcon & S3C2410_UFCON_FIFOMODE) {
 		/* fifo mode - check amount of data in fifo registers... */
@@ -2207,7 +2209,7 @@ s3c24xx_serial_console_txrdy(struct uart
 }
 
 static bool
-s3c24xx_port_configured(unsigned int ucon)
+s3c24xx_port_configured(u32 ucon)
 {
 	/* consider the serial port configured if the tx/rx mode set */
 	return (ucon & 0xf) != 0;
@@ -2222,7 +2224,7 @@ s3c24xx_port_configured(unsigned int uco
 static int s3c24xx_serial_get_poll_char(struct uart_port *port)
 {
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
-	unsigned int ufstat;
+	u32 ufstat;
 
 	ufstat = rd_regl(port, S3C2410_UFSTAT);
 	if (s3c24xx_serial_rx_fifocnt(ourport, ufstat) == 0)
@@ -2234,8 +2236,8 @@ static int s3c24xx_serial_get_poll_char(
 static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 		unsigned char c)
 {
-	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
-	unsigned int ucon = rd_regl(port, S3C2410_UCON);
+	u32 ufcon = rd_regl(port, S3C2410_UFCON);
+	u32 ucon = rd_regl(port, S3C2410_UCON);
 
 	/* not possible to xmit on unconfigured port */
 	if (!s3c24xx_port_configured(ucon))
@@ -2251,7 +2253,7 @@ static void s3c24xx_serial_put_poll_char
 static void
 s3c24xx_serial_console_putchar(struct uart_port *port, int ch)
 {
-	unsigned int ufcon = rd_regl(port, S3C2410_UFCON);
+	u32 ufcon = rd_regl(port, S3C2410_UFCON);
 
 	while (!s3c24xx_serial_console_txrdy(port, ufcon))
 		cpu_relax();
@@ -2262,7 +2264,7 @@ static void
 s3c24xx_serial_console_write(struct console *co, const char *s,
 			     unsigned int count)
 {
-	unsigned int ucon = rd_regl(cons_uart, S3C2410_UCON);
+	u32 ucon = rd_regl(cons_uart, S3C2410_UCON);
 
 	/* not possible to xmit on unconfigured port */
 	if (!s3c24xx_port_configured(ucon))
@@ -2276,11 +2278,9 @@ s3c24xx_serial_get_options(struct uart_p
 			   int *parity, int *bits)
 {
 	struct clk *clk;
-	unsigned int ulcon;
-	unsigned int ucon;
-	unsigned int ubrdiv;
 	unsigned long rate;
 	unsigned int clk_sel;
+	u32 ulcon, ucon, ubrdiv;
 	char clk_name[MAX_CLK_NAME_LENGTH];
 
 	ulcon  = rd_regl(port, S3C2410_ULCON);
@@ -2677,6 +2677,7 @@ static void samsung_early_write(struct c
 	uart_console_write(&dev->port, s, n, samsung_early_putc);
 }
 
+
 static int __init samsung_early_console_setup(struct earlycon_device *device,
 					      const char *opt)
 {


