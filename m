Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD3C4315A;
	Mon, 23 Jun 2025 21:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714870; cv=none; b=milpbsU9UXXuFYIW6Eg83pRqr8W8wPecVTbsb9lqIXJEjTW/z8LuATGnXQFGX2mYVS7mciLQ5cJ6JUvmqycIo5fnrK525ySShgKUHydPjSNXCox81GZ768q0FuAwTLt+M2mVGkeSkX4yxQo5XQs6VFdUksPCQJ64rv7H+3GpfHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714870; c=relaxed/simple;
	bh=JE1tA0vpwKeU4qhd3X/6ti3ah0lbB3UkdHaMUS2OycU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoqZ4yzyYoy7xI946/KjVkn8tjpyOL2Y97sq1k5Udcrw4Pspg2wcPlvlcujlnNQ0+YLBRNzAfxSu+kptZbET7ZVhkgbuu2EvFd/1s+JWI/kJYbQqm8WRL0PU8FhbHGiG35N/rW9dW7ydNSYp+a3rlho4ezTumbnnpfTwnyYZd4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTkLsVc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTkLsVc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C24C4CEEA;
	Mon, 23 Jun 2025 21:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714870;
	bh=JE1tA0vpwKeU4qhd3X/6ti3ah0lbB3UkdHaMUS2OycU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTkLsVc3OAyXPE+/sTTPCqfQ1v2jncxAaUlkQh2EL83H1zOqMlsD/AdA42sahqlex
	 ZyAgOu48TEK05SUPt90Imw3MA+X6zz087yiMHsDtuegF6NlMxMQvW3CfczCNmX7Gpe
	 ay/8GBUsu/U/gJB9fNyBzoBi3rRR4WmyP7yXvWs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/508] serial: sh-sci: Move runtime PM enable to sci_probe_single()
Date: Mon, 23 Jun 2025 15:04:26 +0200
Message-ID: <20250623130650.701413987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f8f301db84339..48bc66e2c0444 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2982,10 +2982,6 @@ static int sci_init_single(struct platform_device *dev,
 		ret = sci_init_clocks(sci_port, &dev->dev);
 		if (ret < 0)
 			return ret;
-
-		port->dev = &dev->dev;
-
-		pm_runtime_enable(&dev->dev);
 	}
 
 	port->type		= p->type;
@@ -3015,11 +3011,6 @@ static int sci_init_single(struct platform_device *dev,
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
@@ -3177,8 +3168,6 @@ static int sci_remove(struct platform_device *dev)
 	sci_ports_in_use &= ~BIT(port->port.line);
 	uart_remove_one_port(&sci_uart_driver, &port->port);
 
-	sci_cleanup_single(port);
-
 	if (port->port.fifosize > 1)
 		device_remove_file(&dev->dev, &dev_attr_rx_fifo_trigger);
 	if (type == PORT_SCIFA || type == PORT_SCIFB || type == PORT_HSCIF)
@@ -3341,6 +3330,11 @@ static int sci_probe_single(struct platform_device *dev,
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
@@ -3354,13 +3348,7 @@ static int sci_probe_single(struct platform_device *dev,
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



