Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C92B149DF4;
	Tue, 25 Jun 2024 09:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309293; cv=none; b=dWfeTdliGGdrfMIn0YTMlzcCTiqnjPmrEVzZLHZuBARFzi9cFSMXHmx5odsa6oylsr/jAb78ujghCekiYAB/eTnvEBAx8N+1g3kwVPNsSWaoF6nHvXHsTLTxRDI3DBnXgb8uZoF3G7DIJUsombTFTg28FCYUv/DKY6y2Nag8SQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309293; c=relaxed/simple;
	bh=dCF1yXeMES2yFJhXqHlpmhAsUFyCC9hS8ypBaEtWH4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEMIYNSRwvlkVWdYIMx2uHpCmGBinX8dc0c45I/CDK5BEIuvz55DpKHJNHFAef4B5aOqAWQym2B9TRS+L2oeM67ifg1SKw6ZdsVCwH+h+Dr8fJSoD+PlPT2W3eT9l9a0QR2agPEU4vk26Z/fj2NC/R2lcblp8eyIKUVt/OfRtqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyQU7MYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyQU7MYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F18C32781;
	Tue, 25 Jun 2024 09:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309293;
	bh=dCF1yXeMES2yFJhXqHlpmhAsUFyCC9hS8ypBaEtWH4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyQU7MYO3fhc9JxyI2mzyDUdmJZsC4oMkvc058T6dDDgi3fq0DZkMYGmGJGtKJJC3
	 51tr0XW8YBALC5KVZEtwU+g1/C/DZFsYYmP5GKsUrYr4szZE5wKIcPNY4KzmlvTXib
	 giH6Pq0pyl4YpkJSjLUNeDIBmTbqPwZ7fuOCRP6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 161/192] serial: 8250_dw: Revert "Move definitions to the shared header"
Date: Tue, 25 Jun 2024 11:33:53 +0200
Message-ID: <20240625085543.342260306@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

commit 2c94512055f362dd789e0f87b8566feeddec83c9 upstream.

This reverts commit d9666dfb314e1ffd6eb9c3c4243fe3e094c047a7.

The container of the struct dw8250_port_data is private to the actual
driver. In particular, 8250_lpss and 8250_dw use different data types
that are assigned to the UART port private_data. Hence, it must not
be used outside the specific driver.

Fix the mistake made in the past by moving the respective definitions
to the specific driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240514190730.2787071-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c    |   27 +++++++++++++++++++++++++++
 drivers/tty/serial/8250/8250_dwlib.h |   32 --------------------------------
 2 files changed, 27 insertions(+), 32 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -57,6 +57,33 @@
 #define DW_UART_QUIRK_APMC0D08		BIT(4)
 #define DW_UART_QUIRK_CPR_VALUE		BIT(5)
 
+struct dw8250_platform_data {
+	u8 usr_reg;
+	u32 cpr_value;
+	unsigned int quirks;
+};
+
+struct dw8250_data {
+	struct dw8250_port_data	data;
+	const struct dw8250_platform_data *pdata;
+
+	int			msr_mask_on;
+	int			msr_mask_off;
+	struct clk		*clk;
+	struct clk		*pclk;
+	struct notifier_block	clk_notifier;
+	struct work_struct	clk_work;
+	struct reset_control	*rst;
+
+	unsigned int		skip_autocfg:1;
+	unsigned int		uart_16550_compatible:1;
+};
+
+static inline struct dw8250_data *to_dw8250_data(struct dw8250_port_data *data)
+{
+	return container_of(data, struct dw8250_data, data);
+}
+
 static inline struct dw8250_data *clk_to_dw8250_data(struct notifier_block *nb)
 {
 	return container_of(nb, struct dw8250_data, clk_notifier);
--- a/drivers/tty/serial/8250/8250_dwlib.h
+++ b/drivers/tty/serial/8250/8250_dwlib.h
@@ -2,15 +2,10 @@
 /* Synopsys DesignWare 8250 library header file. */
 
 #include <linux/io.h>
-#include <linux/notifier.h>
 #include <linux/types.h>
-#include <linux/workqueue.h>
 
 #include "8250.h"
 
-struct clk;
-struct reset_control;
-
 struct dw8250_port_data {
 	/* Port properties */
 	int			line;
@@ -26,36 +21,9 @@ struct dw8250_port_data {
 	bool			hw_rs485_support;
 };
 
-struct dw8250_platform_data {
-	u8 usr_reg;
-	u32 cpr_value;
-	unsigned int quirks;
-};
-
-struct dw8250_data {
-	struct dw8250_port_data	data;
-	const struct dw8250_platform_data *pdata;
-
-	int			msr_mask_on;
-	int			msr_mask_off;
-	struct clk		*clk;
-	struct clk		*pclk;
-	struct notifier_block	clk_notifier;
-	struct work_struct	clk_work;
-	struct reset_control	*rst;
-
-	unsigned int		skip_autocfg:1;
-	unsigned int		uart_16550_compatible:1;
-};
-
 void dw8250_do_set_termios(struct uart_port *p, struct ktermios *termios, const struct ktermios *old);
 void dw8250_setup_port(struct uart_port *p);
 
-static inline struct dw8250_data *to_dw8250_data(struct dw8250_port_data *data)
-{
-	return container_of(data, struct dw8250_data, data);
-}
-
 static inline u32 dw8250_readl_ext(struct uart_port *p, int offset)
 {
 	if (p->iotype == UPIO_MEM32BE)


