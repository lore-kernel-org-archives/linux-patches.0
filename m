Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82500148315;
	Tue, 25 Jun 2024 09:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308730; cv=none; b=miaRGPrifkg3zs9qvo2ZrYa5HOekk64fJ1IbqtBnpzMVnGZ/XkIMWR3rjqSuLAocOUZGIEj7zNZf8if+Mx6rc3Q5kzO50/pDQg99oZxl9N6VFKxkmFxy/mb1lvPcQAfi3Cyodr7o4hg9/vfmbNNNMtsQ8bAjDO9PKOu+g/yOg78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308730; c=relaxed/simple;
	bh=qLONA/CrCJRmHY2ca10H3gTpYbOSWHdid9opLv7ic3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbvdSkATbucEJ5705wWcv+FOZ7cvpO6bwfYAeZcDk/IUVozWw7VwVrlC2NGutSneUswPDq2pdGAz4TzoHilYw1byGRO02jurFxUBgEubBe1cCSqpBjwVgjyw78o8YLb/NKeeNTUX9AdYEqPmAff83P6RFL7oJXiuFoLjGM+AIkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFN9XT66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFN9XT66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09169C32781;
	Tue, 25 Jun 2024 09:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308730;
	bh=qLONA/CrCJRmHY2ca10H3gTpYbOSWHdid9opLv7ic3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFN9XT660XT2KnVm46iKplyn0sqTT018eG6aNQxxaHgMMu+ho8XT7vTsdpMcgU+OD
	 HHLE52EjZhgKyXltDvc2aWznX8aXVeuUf86RO6Z7zLQAGLs73FCUNieNdO15EOthql
	 Tj1tIqNBjcaPEW8Y++ZuQU/eT+0RdnAoOFXuACdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.9 220/250] serial: 8250_dw: Revert "Move definitions to the shared header"
Date: Tue, 25 Jun 2024 11:32:58 +0200
Message-ID: <20240625085556.496426615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


