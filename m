Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41901422B8;
	Wed, 19 Jun 2024 13:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802629; cv=none; b=LrbjulmitpjSwSy1T1KQrcgfxVc2lrqnyqp4b74kODuy4fNphb6NBqPWcSSf5A8BCKb6bPwzyYaV7A62Xmor54RqFdAQKN9trQpxn7chV4ybeGpTLv4TMAjGWjI8RM5fAnyRiJp/EgAaJzcs8VeDjCAWZyZtRfn1GvR+PkDbryc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802629; c=relaxed/simple;
	bh=wzwR5XgiJ7/j1Sdn3VlYMXpbn0DyjJnYOdmkG/VtD1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VY2PXw2qutW9k5dLwfrWbVQRAR5sqGJd14W7b7wLuKxJLuRjRMGwyMj+9bHthe+9F0miVH5ZX13k7BXhiva8JwH4txzugXYGn18gpv+Mrvs4j0cvtKP4VSIC+mZ2pgSYkhZ8CL4ZEYNJq63oilOZXkt2sNP6EcIc86SA8RUfHsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4JtjUby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4JtjUby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310B4C2BBFC;
	Wed, 19 Jun 2024 13:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802629;
	bh=wzwR5XgiJ7/j1Sdn3VlYMXpbn0DyjJnYOdmkG/VtD1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4JtjUbyrv/PsYmwN8AaXzjeSifhohrhNG356h0dYo5Qoh5ktLkgMVAndhoLnXrvt
	 8mWZQu6jSYdUZIfG4TbL72xKUH1SWkZFpzK2ex/VsT7yAjXLdu3ZwHVbuth2KPaVpu
	 gjaocy3at6X3L26a5AjVJJTSdxc2i/93tr/2Rd1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/267] serial: 8250_dw: Dont use struct dw8250_data outside of 8250_dw
Date: Wed, 19 Jun 2024 14:56:53 +0200
Message-ID: <20240619125616.378349109@linuxfoundation.org>
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

[ Upstream commit 87d80bfbd577912462061b1a45c0ed9c7fcb872f ]

The container of the struct dw8250_port_data is private to the actual
driver. In particular, 8250_lpss and 8250_dw use different data types
that are assigned to the UART port private_data. Hence, it must not
be used outside the specific driver.

Currently the only cpr_val is required by the common code, make it
be available via struct dw8250_port_data.

This fixes the UART breakage on Intel Galileo boards.

Fixes: 593dea000bc1 ("serial: 8250: dw: Allow to use a fallback CPR value if not synthesized")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240514190730.2787071-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c    | 9 +++++++--
 drivers/tty/serial/8250/8250_dwlib.c | 3 +--
 drivers/tty/serial/8250/8250_dwlib.h | 3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index a7659e536d3c0..777bea835b114 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -55,6 +55,7 @@
 #define DW_UART_QUIRK_SKIP_SET_RATE	BIT(2)
 #define DW_UART_QUIRK_IS_DMA_FC		BIT(3)
 #define DW_UART_QUIRK_APMC0D08		BIT(4)
+#define DW_UART_QUIRK_CPR_VALUE		BIT(5)
 
 static inline struct dw8250_data *clk_to_dw8250_data(struct notifier_block *nb)
 {
@@ -445,6 +446,10 @@ static void dw8250_prepare_rx_dma(struct uart_8250_port *p)
 static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 {
 	unsigned int quirks = data->pdata ? data->pdata->quirks : 0;
+	u32 cpr_value = data->pdata ? data->pdata->cpr_value : 0;
+
+	if (quirks & DW_UART_QUIRK_CPR_VALUE)
+		data->data.cpr_value = cpr_value;
 
 #ifdef CONFIG_64BIT
 	if (quirks & DW_UART_QUIRK_OCTEON) {
@@ -749,8 +754,8 @@ static const struct dw8250_platform_data dw8250_armada_38x_data = {
 
 static const struct dw8250_platform_data dw8250_renesas_rzn1_data = {
 	.usr_reg = DW_UART_USR,
-	.cpr_val = 0x00012f32,
-	.quirks = DW_UART_QUIRK_IS_DMA_FC,
+	.cpr_value = 0x00012f32,
+	.quirks = DW_UART_QUIRK_CPR_VALUE | DW_UART_QUIRK_IS_DMA_FC,
 };
 
 static const struct dw8250_platform_data dw8250_starfive_jh7100_data = {
diff --git a/drivers/tty/serial/8250/8250_dwlib.c b/drivers/tty/serial/8250/8250_dwlib.c
index 84843e204a5e8..8fc8b6753148b 100644
--- a/drivers/tty/serial/8250/8250_dwlib.c
+++ b/drivers/tty/serial/8250/8250_dwlib.c
@@ -242,7 +242,6 @@ static const struct serial_rs485 dw8250_rs485_supported = {
 void dw8250_setup_port(struct uart_port *p)
 {
 	struct dw8250_port_data *pd = p->private_data;
-	struct dw8250_data *data = to_dw8250_data(pd);
 	struct uart_8250_port *up = up_to_u8250p(p);
 	u32 reg, old_dlf;
 
@@ -284,7 +283,7 @@ void dw8250_setup_port(struct uart_port *p)
 
 	reg = dw8250_readl_ext(p, DW_UART_CPR);
 	if (!reg) {
-		reg = data->pdata->cpr_val;
+		reg = pd->cpr_value;
 		dev_dbg(p->dev, "CPR is not available, using 0x%08x instead\n", reg);
 	}
 	if (!reg)
diff --git a/drivers/tty/serial/8250/8250_dwlib.h b/drivers/tty/serial/8250/8250_dwlib.h
index f13e91f2cace9..794a9014cdac1 100644
--- a/drivers/tty/serial/8250/8250_dwlib.h
+++ b/drivers/tty/serial/8250/8250_dwlib.h
@@ -19,6 +19,7 @@ struct dw8250_port_data {
 	struct uart_8250_dma	dma;
 
 	/* Hardware configuration */
+	u32			cpr_value;
 	u8			dlf_size;
 
 	/* RS485 variables */
@@ -27,7 +28,7 @@ struct dw8250_port_data {
 
 struct dw8250_platform_data {
 	u8 usr_reg;
-	u32 cpr_val;
+	u32 cpr_value;
 	unsigned int quirks;
 };
 
-- 
2.43.0



