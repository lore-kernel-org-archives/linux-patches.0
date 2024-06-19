Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DD712FB31;
	Wed, 19 Jun 2024 13:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802665; cv=none; b=J3W9fK6/LQAVqy17kiCsKlka/f9QjXvQ24JfDzc2He0KENH0095l18oKD3tMTQ0SGoQDkRmW/eQUmKUkhu7hdAsb0WhcCZmss9uHOWylFkzdLIx1nKb6xYxZdiopF6t7NLXKplIrlAnI8ZqYvjIy4ATbGmI5AKO5boi+ieP82QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802665; c=relaxed/simple;
	bh=/vXV4t95s0B2f55fOplJj9wGJcFabYNjcRZ2aEXPcI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srS7IqzCWxDf4KNFYSoM4AOf0so9D9Pl/NVZt8F1vDWKBGayLYIv4OURjrwwyc0DXGumIsa7gonnQsUv9ST6sV5WuT0L7LCD0f6gGtDGKeq63rvvjNA7gjtr565J7dSHkKHYQWQBakRPB0jjTz6h2/5AL7aRU/G72A/D/7bTzLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQwumNBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQwumNBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99002C2BBFC;
	Wed, 19 Jun 2024 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802665;
	bh=/vXV4t95s0B2f55fOplJj9wGJcFabYNjcRZ2aEXPcI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQwumNBqRKr9HHKDn6Z4BOTy1kUFm38zXOyrV+KhjZp+0M5VxFmGI3EVAmQRzijrU
	 JxHSmew77Hwnon+jIGgIxU73lHgq/3oH+G70SC+k4BLFwO8tYFP8SYnK0o10phBej8
	 j6z+Fr8tDXbnAN5PyFekM+h4Kkz80JrrDd+DjFtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/267] serial: port: Introduce a common helper to read properties
Date: Wed, 19 Jun 2024 14:56:50 +0200
Message-ID: <20240619125616.256641904@linuxfoundation.org>
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

[ Upstream commit e894b6005dce0ed621b2788d6a249708fb6f95f9 ]

Several serial drivers want to read the same or similar set of
the port properties. Make a common helper for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240304123035.758700-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 87d80bfbd577 ("serial: 8250_dw: Don't use struct dw8250_data outside of 8250_dw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_port.c | 145 +++++++++++++++++++++++++++++++
 include/linux/serial_core.h      |   2 +
 2 files changed, 147 insertions(+)

diff --git a/drivers/tty/serial/serial_port.c b/drivers/tty/serial/serial_port.c
index ed3953bd04073..469ad26cde487 100644
--- a/drivers/tty/serial/serial_port.c
+++ b/drivers/tty/serial/serial_port.c
@@ -8,7 +8,10 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/property.h>
 #include <linux/serial_core.h>
 #include <linux/spinlock.h>
 
@@ -146,6 +149,148 @@ void uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 }
 EXPORT_SYMBOL(uart_remove_one_port);
 
+/**
+ * __uart_read_properties - read firmware properties of the given UART port
+ * @port: corresponding port
+ * @use_defaults: apply defaults (when %true) or validate the values (when %false)
+ *
+ * The following device properties are supported:
+ *   - clock-frequency (optional)
+ *   - fifo-size (optional)
+ *   - no-loopback-test (optional)
+ *   - reg-shift (defaults may apply)
+ *   - reg-offset (value may be validated)
+ *   - reg-io-width (defaults may apply or value may be validated)
+ *   - interrupts (OF only)
+ *   - serial [alias ID] (OF only)
+ *
+ * If the port->dev is of struct platform_device type the interrupt line
+ * will be retrieved via platform_get_irq() call against that device.
+ * Otherwise it will be assigned by fwnode_irq_get() call. In both cases
+ * the index 0 of the resource is used.
+ *
+ * The caller is responsible to initialize the following fields of the @port
+ *   ->dev (must be valid)
+ *   ->flags
+ *   ->mapbase
+ *   ->mapsize
+ *   ->regshift (if @use_defaults is false)
+ * before calling this function. Alternatively the above mentioned fields
+ * may be zeroed, in such case the only ones, that have associated properties
+ * found, will be set to the respective values.
+ *
+ * If no error happened, the ->irq, ->mapbase, ->mapsize will be altered.
+ * The ->iotype is always altered.
+ *
+ * When @use_defaults is true and the respective property is not found
+ * the following values will be applied:
+ *   ->regshift = 0
+ * In this case IRQ must be provided, otherwise an error will be returned.
+ *
+ * When @use_defaults is false and the respective property is found
+ * the following values will be validated:
+ *   - reg-io-width (->iotype)
+ *   - reg-offset (->mapsize against ->mapbase)
+ *
+ * Returns: 0 on success or negative errno on failure
+ */
+static int __uart_read_properties(struct uart_port *port, bool use_defaults)
+{
+	struct device *dev = port->dev;
+	u32 value;
+	int ret;
+
+	/* Read optional UART functional clock frequency */
+	device_property_read_u32(dev, "clock-frequency", &port->uartclk);
+
+	/* Read the registers alignment (default: 8-bit) */
+	ret = device_property_read_u32(dev, "reg-shift", &value);
+	if (ret)
+		port->regshift = use_defaults ? 0 : port->regshift;
+	else
+		port->regshift = value;
+
+	/* Read the registers I/O access type (default: MMIO 8-bit) */
+	ret = device_property_read_u32(dev, "reg-io-width", &value);
+	if (ret) {
+		port->iotype = UPIO_MEM;
+	} else {
+		switch (value) {
+		case 1:
+			port->iotype = UPIO_MEM;
+			break;
+		case 2:
+			port->iotype = UPIO_MEM16;
+			break;
+		case 4:
+			port->iotype = device_is_big_endian(dev) ? UPIO_MEM32BE : UPIO_MEM32;
+			break;
+		default:
+			if (!use_defaults) {
+				dev_err(dev, "Unsupported reg-io-width (%u)\n", value);
+				return -EINVAL;
+			}
+			port->iotype = UPIO_UNKNOWN;
+			break;
+		}
+	}
+
+	/* Read the address mapping base offset (default: no offset) */
+	ret = device_property_read_u32(dev, "reg-offset", &value);
+	if (ret)
+		value = 0;
+
+	/* Check for shifted address mapping overflow */
+	if (!use_defaults && port->mapsize < value) {
+		dev_err(dev, "reg-offset %u exceeds region size %pa\n", value, &port->mapsize);
+		return -EINVAL;
+	}
+
+	port->mapbase += value;
+	port->mapsize -= value;
+
+	/* Read optional FIFO size */
+	device_property_read_u32(dev, "fifo-size", &port->fifosize);
+
+	if (device_property_read_bool(dev, "no-loopback-test"))
+		port->flags |= UPF_SKIP_TEST;
+
+	/* Get index of serial line, if found in DT aliases */
+	ret = of_alias_get_id(dev_of_node(dev), "serial");
+	if (ret >= 0)
+		port->line = ret;
+
+	if (dev_is_platform(dev))
+		ret = platform_get_irq(to_platform_device(dev), 0);
+	else
+		ret = fwnode_irq_get(dev_fwnode(dev), 0);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	if (ret > 0)
+		port->irq = ret;
+	else if (use_defaults)
+		/* By default IRQ support is mandatory */
+		return ret;
+	else
+		port->irq = 0;
+
+	port->flags |= UPF_SHARE_IRQ;
+
+	return 0;
+}
+
+int uart_read_port_properties(struct uart_port *port)
+{
+	return __uart_read_properties(port, true);
+}
+EXPORT_SYMBOL_GPL(uart_read_port_properties);
+
+int uart_read_and_validate_port_properties(struct uart_port *port)
+{
+	return __uart_read_properties(port, false);
+}
+EXPORT_SYMBOL_GPL(uart_read_and_validate_port_properties);
+
 static struct device_driver serial_port_driver = {
 	.name = "port",
 	.suppress_bind_attrs = true,
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 412de73547521..5da5eb719f614 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -961,6 +961,8 @@ int uart_register_driver(struct uart_driver *uart);
 void uart_unregister_driver(struct uart_driver *uart);
 int uart_add_one_port(struct uart_driver *reg, struct uart_port *port);
 void uart_remove_one_port(struct uart_driver *reg, struct uart_port *port);
+int uart_read_port_properties(struct uart_port *port);
+int uart_read_and_validate_port_properties(struct uart_port *port);
 bool uart_match_port(const struct uart_port *port1,
 		const struct uart_port *port2);
 
-- 
2.43.0



