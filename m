Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E22C9D;
	Mon, 23 Jun 2025 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713619; cv=none; b=nVGkHMfqx9GxSTCtyBRCCP0Oav+NWbo3dnkAVFJsE7amP2aqAQ35fioweTzauosqzLnGTc9n+nuTix8LutSBn0vUdq6b6Cs9SUA+nSeF3VedoKy4YcpKF5rKC5D7/WNQN9I4LXsDP/CfaD0yqgbjmJaXydN/yAR4qhQt2FuCgv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713619; c=relaxed/simple;
	bh=RnVEhhhQ3nKoBcwRndQPBL+WH4EogCXtBIcw8F52FoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3/dshH66FGWHizaH2WinomAMznF5JvA+Y/w8zPlB7Pa0SXmhUebkFYc1hxbnbPoa/O/RAZ23JHE89CXTyRFltjdO4ABPUomIaD5ndM1xrIdYrjJuQk63SWp8sWOP0rCcW3WQ86DMzOgjdttHtarvBemLHNo/IDZXWryopoo/AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7gfiSEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7gfiSEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50F3C4CEEA;
	Mon, 23 Jun 2025 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713619;
	bh=RnVEhhhQ3nKoBcwRndQPBL+WH4EogCXtBIcw8F52FoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7gfiSEBwkqL5xBr4oF8kpwqqi1yG61Qf/BUqVaJhz0TMwPPIhdZdq1ilydidWioT
	 ueaMEQNpEfpT7jckdGacRIstceMBhYNUAIp1LuIiGBwLnQhZa5Z4vgKPDqOjc2cyls
	 0j9iPJ952HJypBsuta25Mx3tAFzEQ7s5CO18EmGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/411] serial: sh-sci: Move runtime PM enable to sci_probe_single()
Date: Mon, 23 Jun 2025 15:04:41 +0200
Message-ID: <20250623130637.035039683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 239f11209e5f282e16f5241b99256e25dd0614b6 upstream.

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
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index a276efa103192..a24fcd702f6cd 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2993,10 +2993,6 @@ static int sci_init_single(struct platform_device *dev,
 		ret = sci_init_clocks(sci_port, &dev->dev);
 		if (ret < 0)
 			return ret;
-
-		port->dev = &dev->dev;
-
-		pm_runtime_enable(&dev->dev);
 	}
 
 	port->type		= p->type;
@@ -3026,11 +3022,6 @@ static int sci_init_single(struct platform_device *dev,
 	return 0;
 }
 
-static void sci_cleanup_single(struct sci_port *port)
-{
-	pm_runtime_disable(port->port.dev);
-}
-
 #if defined(CONFIG_SERIAL_SH_SCI_CONSOLE) || \
     defined(CONFIG_SERIAL_SH_SCI_EARLYCON)
 static void serial_console_putchar(struct uart_port *port, int ch)
@@ -3188,8 +3179,6 @@ static int sci_remove(struct platform_device *dev)
 	sci_ports_in_use &= ~BIT(port->port.line);
 	uart_remove_one_port(&sci_uart_driver, &port->port);
 
-	sci_cleanup_single(port);
-
 	if (port->port.fifosize > 1)
 		device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 	if (type == PORT_SCIFA || type == PORT_SCIFB || type == PORT_HSCIF)
@@ -3324,6 +3313,11 @@ static int sci_probe_single(struct platform_device *dev,
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
@@ -3337,13 +3331,7 @@ static int sci_probe_single(struct platform_device *dev,
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
-- 
2.39.5



