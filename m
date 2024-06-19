Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19DB1422B8;
	Wed, 19 Jun 2024 13:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802626; cv=none; b=b1Yc+nXvfL8omJ6nqIgVEwjXk2SnoHPWO82OSJbUglsQEk7GAJU+mjE6/kIZBwDPBNqjFYmeGBy9/5U30M7R+EbC//6o8xM+99TQCk49UYVkWM20VpcrkpQiSWg6nw1kf/l54ViHZbYQBTsa2U/tpyVmj4kTAdIVi0oM9cCiQJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802626; c=relaxed/simple;
	bh=cJQgjVF10pBRPllN7ZLPtvM0C+97xY6fs16EZ19UNnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gxyil1SMbX2DWQNVGcB6CT1E23c7UakbUfP8RJ1JY9Zda0ZWmPD69OvW17T3JSEfD1b9lNQEaSK2t6okXICJBEnjuIBomxmppvEGpwUQP1WykW5pCFqJHxewnibMyoQGGqhkfrVR5u4ocD8XnxNtZSPrMZ+QShTeS9azAvLqjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pD7V930r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pD7V930r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48278C2BBFC;
	Wed, 19 Jun 2024 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802626;
	bh=cJQgjVF10pBRPllN7ZLPtvM0C+97xY6fs16EZ19UNnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD7V930rkawhYctsTrfU7ptCYXbq36p8oNYSGk+7IUqCDf0PDsDppY+a6sBNtpVOm
	 5yD6pUjn36r851b1yr+IR1jPU/C7PdFnHIfXQfV9o1TZ6mKkW8YUj3rnQq6zdREjEH
	 u10Re9zyKNhy3oOF+VZ+leeEx7b6i0Pl0mMjpyPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 261/267] serial: 8250_dw: Replace ACPI device check by a quirk
Date: Wed, 19 Jun 2024 14:56:52 +0200
Message-ID: <20240619125616.332221957@linuxfoundation.org>
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

[ Upstream commit 173b097dcc8d74d6e135aed1bad38dbfa21c4d04 ]

Instead of checking for APMC0D08 ACPI device presence,
use a quirk based on driver data.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240306143322.3291123-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_dw.c | 51 ++++++++++++++++---------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 0446ac145cd4a..a7659e536d3c0 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -9,7 +9,6 @@
  * LCR is written whilst busy.  If it is, then a busy detect interrupt is
  * raised, the LCR needs to be rewritten and the uart status register read.
  */
-#include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -55,6 +54,7 @@
 #define DW_UART_QUIRK_ARMADA_38X	BIT(1)
 #define DW_UART_QUIRK_SKIP_SET_RATE	BIT(2)
 #define DW_UART_QUIRK_IS_DMA_FC		BIT(3)
+#define DW_UART_QUIRK_APMC0D08		BIT(4)
 
 static inline struct dw8250_data *clk_to_dw8250_data(struct notifier_block *nb)
 {
@@ -444,33 +444,29 @@ static void dw8250_prepare_rx_dma(struct uart_8250_port *p)
 
 static void dw8250_quirks(struct uart_port *p, struct dw8250_data *data)
 {
-	struct device_node *np = p->dev->of_node;
-
-	if (np) {
-		unsigned int quirks = data->pdata->quirks;
+	unsigned int quirks = data->pdata ? data->pdata->quirks : 0;
 
 #ifdef CONFIG_64BIT
-		if (quirks & DW_UART_QUIRK_OCTEON) {
-			p->serial_in = dw8250_serial_inq;
-			p->serial_out = dw8250_serial_outq;
-			p->flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
-			p->type = PORT_OCTEON;
-			data->skip_autocfg = true;
-		}
+	if (quirks & DW_UART_QUIRK_OCTEON) {
+		p->serial_in = dw8250_serial_inq;
+		p->serial_out = dw8250_serial_outq;
+		p->flags = UPF_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
+		p->type = PORT_OCTEON;
+		data->skip_autocfg = true;
+	}
 #endif
 
-		if (quirks & DW_UART_QUIRK_ARMADA_38X)
-			p->serial_out = dw8250_serial_out38x;
-		if (quirks & DW_UART_QUIRK_SKIP_SET_RATE)
-			p->set_termios = dw8250_do_set_termios;
-		if (quirks & DW_UART_QUIRK_IS_DMA_FC) {
-			data->data.dma.txconf.device_fc = 1;
-			data->data.dma.rxconf.device_fc = 1;
-			data->data.dma.prepare_tx_dma = dw8250_prepare_tx_dma;
-			data->data.dma.prepare_rx_dma = dw8250_prepare_rx_dma;
-		}
-
-	} else if (acpi_dev_present("APMC0D08", NULL, -1)) {
+	if (quirks & DW_UART_QUIRK_ARMADA_38X)
+		p->serial_out = dw8250_serial_out38x;
+	if (quirks & DW_UART_QUIRK_SKIP_SET_RATE)
+		p->set_termios = dw8250_do_set_termios;
+	if (quirks & DW_UART_QUIRK_IS_DMA_FC) {
+		data->data.dma.txconf.device_fc = 1;
+		data->data.dma.rxconf.device_fc = 1;
+		data->data.dma.prepare_tx_dma = dw8250_prepare_tx_dma;
+		data->data.dma.prepare_rx_dma = dw8250_prepare_rx_dma;
+	}
+	if (quirks & DW_UART_QUIRK_APMC0D08) {
 		p->iotype = UPIO_MEM32;
 		p->regshift = 2;
 		p->serial_in = dw8250_serial_in32;
@@ -772,13 +768,18 @@ static const struct of_device_id dw8250_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
 
+static const struct dw8250_platform_data dw8250_apmc0d08 = {
+	.usr_reg = DW_UART_USR,
+	.quirks = DW_UART_QUIRK_APMC0D08,
+};
+
 static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "80860F0A", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "8086228A", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "AMD0020", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "AMDI0020", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "AMDI0022", (kernel_ulong_t)&dw8250_dw_apb },
-	{ "APMC0D08", (kernel_ulong_t)&dw8250_dw_apb},
+	{ "APMC0D08", (kernel_ulong_t)&dw8250_apmc0d08 },
 	{ "BRCM2032", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "HISI0031", (kernel_ulong_t)&dw8250_dw_apb },
 	{ "INT33C4", (kernel_ulong_t)&dw8250_dw_apb },
-- 
2.43.0



