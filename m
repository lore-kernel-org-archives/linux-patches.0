Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B47515956B;
	Mon, 29 Jan 2024 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548427; cv=none; b=OnMVZlb6tc8tf3Q4ieV5SKE+fFlFSaFzYzACzJhzHhBDhyZ/uM/NWIaHqkuRiFGyGkSNEu+7B3F7cMBYJn16lOVmOb+AZ4CvyKwQNs2MNDLVI/QioOKcRPzRP2YmWfVhUPtzQ/Jh3mvcLydfQZ+AfTzrP+SBe8LT2TXIlqThaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548427; c=relaxed/simple;
	bh=2IKtRSb8S1xpicig3AtGLudMCNrt0EfuochPviUyl00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq6dQr1O8xZS0dqN+JMaJm+N3UEWHfQq05RrxdjXernRBGG6tJNIoptpBVNhHu0k4Eoxzq/tJKvN/Br69z6qnqsWY1V35F/brPGjhPBsdpvH1WIsjbVxv6vSYS+Xj0bXH0f06He4fmnP7Gh9QTvmL2qmv1+wXqFxvxD2NVSfITI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X054Oyw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X054Oyw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3222C433C7;
	Mon, 29 Jan 2024 17:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548427;
	bh=2IKtRSb8S1xpicig3AtGLudMCNrt0EfuochPviUyl00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X054Oyw3Gd52GektU0Kdj4SlxJrOYzUK/gMm/amSsaVkflbmRRtuIvzIKjkVMyvSh
	 eUgf4hV0WzOH15PtTGyuOFawQgVt3dav0P0CX8o38iYXoy7qYayJU7k0Mv7CElYa4o
	 N44PgIX30IlMn9DM+yqq9AXMPYJcDYkAVxfed4m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/331] serial: core: Simplify uart_get_rs485_mode()
Date: Mon, 29 Jan 2024 09:01:08 -0800
Message-ID: <20240129170015.093132204@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

[ Upstream commit 7cda0b9eb6eb9e761f452e2ef4e81eca20b19938 ]

Simplify uart_get_rs485_mode() by using temporary variable for
the GPIO descriptor. With that, use proper type for the flags
of the GPIO descriptor.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231003142346.3072929-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1a33e33ca0e8 ("serial: core: set missing supported flag for RX during TX GPIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 18b49b1439a5..021e096bc4ed 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -3572,9 +3572,10 @@ int uart_get_rs485_mode(struct uart_port *port)
 {
 	struct serial_rs485 *rs485conf = &port->rs485;
 	struct device *dev = port->dev;
+	enum gpiod_flags dflags;
+	struct gpio_desc *desc;
 	u32 rs485_delay[2];
 	int ret;
-	int rx_during_tx_gpio_flag;
 
 	if (!(port->rs485_supported.flags & SER_RS485_ENABLED))
 		return 0;
@@ -3616,26 +3617,19 @@ int uart_get_rs485_mode(struct uart_port *port)
 	 * bus participants enable it, no communication is possible at all.
 	 * Works fine for short cables and users may enable for longer cables.
 	 */
-	port->rs485_term_gpio = devm_gpiod_get_optional(dev, "rs485-term",
-							GPIOD_OUT_LOW);
-	if (IS_ERR(port->rs485_term_gpio)) {
-		ret = PTR_ERR(port->rs485_term_gpio);
-		port->rs485_term_gpio = NULL;
-		return dev_err_probe(dev, ret, "Cannot get rs485-term-gpios\n");
-	}
+	desc = devm_gpiod_get_optional(dev, "rs485-term", GPIOD_OUT_LOW);
+	if (IS_ERR(desc))
+		return dev_err_probe(dev, PTR_ERR(desc), "Cannot get rs485-term-gpios\n");
+	port->rs485_term_gpio = desc;
 	if (port->rs485_term_gpio)
 		port->rs485_supported.flags |= SER_RS485_TERMINATE_BUS;
 
-	rx_during_tx_gpio_flag = (rs485conf->flags & SER_RS485_RX_DURING_TX) ?
-				 GPIOD_OUT_HIGH : GPIOD_OUT_LOW;
-	port->rs485_rx_during_tx_gpio = devm_gpiod_get_optional(dev,
-								"rs485-rx-during-tx",
-								rx_during_tx_gpio_flag);
-	if (IS_ERR(port->rs485_rx_during_tx_gpio)) {
-		ret = PTR_ERR(port->rs485_rx_during_tx_gpio);
-		port->rs485_rx_during_tx_gpio = NULL;
-		return dev_err_probe(dev, ret, "Cannot get rs485-rx-during-tx-gpios\n");
-	}
+	dflags = (rs485conf->flags & SER_RS485_RX_DURING_TX) ?
+		 GPIOD_OUT_HIGH : GPIOD_OUT_LOW;
+	desc = devm_gpiod_get_optional(dev, "rs485-rx-during-tx", dflags);
+	if (IS_ERR(desc))
+		return dev_err_probe(dev, PTR_ERR(desc), "Cannot get rs485-rx-during-tx-gpios\n");
+	port->rs485_rx_during_tx_gpio = desc;
 
 	return 0;
 }
-- 
2.43.0



