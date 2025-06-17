Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9430E2FA645;
	Tue, 17 Jun 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178069; cv=none; b=Us5TGtC7zKadMhfJU60ftbmfCIJoT6XB5zwgiaj68qI+matlE/wRfzdd7+EZeh4lbNPvP23hxjocxeg3yssm8+5Yuexvf2RzYrH0NNVFZPDSDswdgineLWBXI9V/yZzxwWr7pQZn3tVf0qlTJ6GPqMCoaI/OX4lnsup9TpAtH+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178069; c=relaxed/simple;
	bh=AJos5fd0734dbevzcQ4bYe5tZkSLHvP7iz0B0m9Ev34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j63hPKhBXHi1pPf/eX87lrXHIlTKxwvCpZ1AOm7a+ABgk3CLZPO0YR3n8Gf+Uhqr/bCErPSqyOFbZvaQ+pxkiB52cdSeIEAsYKauKrxaSAuqNj7ZJAuEhxa2j3V07oA4bpwWMfnFFPjeYDW6Z32SXAfu6jdQMxtWVuFxhe0JaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcDqtmaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcDqtmaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A100AC4CEE3;
	Tue, 17 Jun 2025 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178069;
	bh=AJos5fd0734dbevzcQ4bYe5tZkSLHvP7iz0B0m9Ev34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcDqtmaDL5ndUOIzNUijUMDSMq59WkqRgDwfNYe9ucTaUeFI1iRPULNlKnQVRZe2y
	 P2cgg+lVS73dI2ZS5v9wu/+AeIRHg56Pb9ofohuwQ+ZTrfIJkQZPfQ7/A40z4fySYg
	 ftmXmkoGas/iLMo0zMvkpcI6GuFpNIn00dlsHhVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 417/512] serial: sh-sci: Move runtime PM enable to sci_probe_single()
Date: Tue, 17 Jun 2025 17:26:23 +0200
Message-ID: <20250617152436.474113766@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 239f11209e5f282e16f5241b99256e25dd0614b6 ]

Relocate the runtime PM enable operation to sci_probe_single(). This change
prepares the codebase for upcoming fixes.

While at it, replace the existing logic with a direct call to
devm_pm_runtime_enable() and remove sci_cleanup_single(). The
devm_pm_runtime_enable() function automatically handles disabling runtime
PM during driver removal.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://lore.kernel.org/r/20250116182249.3828577-3-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3074,10 +3074,6 @@ static int sci_init_single(struct platfo
 		ret = sci_init_clocks(sci_port, &dev->dev);
 		if (ret < 0)
 			return ret;
-
-		port->dev = &dev->dev;
-
-		pm_runtime_enable(&dev->dev);
 	}
 
 	port->type		= p->type;
@@ -3104,11 +3100,6 @@ static int sci_init_single(struct platfo
 	return 0;
 }
 
-static void sci_cleanup_single(struct sci_port *port)
-{
-	pm_runtime_disable(port->port.dev);
-}
-
 #if defined(CONFIG_SERIAL_SH_SCI_CONSOLE) || \
     defined(CONFIG_SERIAL_SH_SCI_EARLYCON)
 static void serial_console_putchar(struct uart_port *port, unsigned char ch)
@@ -3278,8 +3269,6 @@ static void sci_remove(struct platform_d
 	sci_ports_in_use &= ~BIT(port->port.line);
 	uart_remove_one_port(&sci_uart_driver, &port->port);
 
-	sci_cleanup_single(port);
-
 	if (port->port.fifosize > 1)
 		device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 	if (type == PORT_SCIFA || type == PORT_SCIFB || type == PORT_HSCIF)
@@ -3444,6 +3433,11 @@ static int sci_probe_single(struct platf
 	if (ret)
 		return ret;
 
+	sciport->port.dev = &dev->dev;
+	ret = devm_pm_runtime_enable(&dev->dev);
+	if (ret)
+		return ret;
+
 	sciport->gpios = mctrl_gpio_init(&sciport->port, 0);
 	if (IS_ERR(sciport->gpios))
 		return PTR_ERR(sciport->gpios);
@@ -3457,13 +3451,7 @@ static int sci_probe_single(struct platf
 		sciport->port.flags |= UPF_HARD_FLOW;
 	}
 
-	ret = uart_add_one_port(&sci_uart_driver, &sciport->port);
-	if (ret) {
-		sci_cleanup_single(sciport);
-		return ret;
-	}
-
-	return 0;
+	return uart_add_one_port(&sci_uart_driver, &sciport->port);
 }
 
 static int sci_probe(struct platform_device *dev)


