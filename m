Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3C56EB61;
	Tue, 23 Jan 2024 02:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975419; cv=none; b=dTyQqOvaIuTUwwcrcC1sbWDvZfUS9pDcTBxwX1mA6W82zR3dbMS/gULPfr54IeOv1Ms+iaEo7KQD1LIbXrF4dEf0MSfSY8kICqAkJMN5b+Sls4pJ8EOkcDGW9RftyjE3XWIocPvkTSZcOMdcscGz6jiQpZ0dQLkLjlKDMVfPiec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975419; c=relaxed/simple;
	bh=sTmNAHE0BjYD50YvA+/ucgu40Yvz+8jLKdECi6SOzIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VbHGlXeldN9mP9uhfVEiDoWTQ1i9aSVWVrXnT07VdeOB7tGjj98YNEofs/WgLbxdO/J3egDFISWFHevfp8ITkDcLXYnT/05u0echo5lP6a8WT51zUYivMB0fQzelJowybXs61p1Mzef8Qz5IYVVCO/UMTmEpqqmHrjKY6WZCCsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2PazCkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2PazCkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7D8C433C7;
	Tue, 23 Jan 2024 02:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975419;
	bh=sTmNAHE0BjYD50YvA+/ucgu40Yvz+8jLKdECi6SOzIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2PazCkZ2k8ABUYxxYPtZpl8jaOPBZWDwhAWqgjbEOP76Gr0gzwntd+ZYgJA+ZAVf
	 7m2Nn0yHoN9zWtvZXa+fIRk0mSCV566EZHuHWUsfbqcsQP+WeBUMSNQnV+YjX9TuGk
	 zD816R0JiMUeE40eAVyKNFoQk+4OuA/g4Ah+Zb8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 378/583] serial: omap: do not override settings for RS485 support
Date: Mon, 22 Jan 2024 15:57:09 -0800
Message-ID: <20240122235823.577973688@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 51f93776b84dee23e44a7be880736669a01cec2b upstream.

The drivers RS485 support is deactivated if there is no RTS GPIO available.
This is done by nullifying the ports rs485_supported struct. After that
however the settings in serial_omap_rs485_supported are assigned to the
same structure unconditionally, which results in an unintended reactivation
of RS485 support.

Fix this by moving the assignment to the beginning of
serial_omap_probe_rs485() and thus before uart_get_rs485_mode() gets
called.

Also replace the assignment of rs485_config() to have the complete RS485
setup in one function.

Fixes: e2752ae3cfc9 ("serial: omap: Disallow RS-485 if rts-gpio is not specified")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240103061818.564-7-l.sanfilippo@kunbus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/omap-serial.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1483,6 +1483,13 @@ static struct omap_uart_port_info *of_ge
 	return omap_up_info;
 }
 
+static const struct serial_rs485 serial_omap_rs485_supported = {
+	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND |
+		 SER_RS485_RX_DURING_TX,
+	.delay_rts_before_send = 1,
+	.delay_rts_after_send = 1,
+};
+
 static int serial_omap_probe_rs485(struct uart_omap_port *up,
 				   struct device *dev)
 {
@@ -1497,6 +1504,9 @@ static int serial_omap_probe_rs485(struc
 	if (!np)
 		return 0;
 
+	up->port.rs485_config = serial_omap_config_rs485;
+	up->port.rs485_supported = serial_omap_rs485_supported;
+
 	ret = uart_get_rs485_mode(&up->port);
 	if (ret)
 		return ret;
@@ -1531,13 +1541,6 @@ static int serial_omap_probe_rs485(struc
 	return 0;
 }
 
-static const struct serial_rs485 serial_omap_rs485_supported = {
-	.flags = SER_RS485_ENABLED | SER_RS485_RTS_ON_SEND | SER_RS485_RTS_AFTER_SEND |
-		 SER_RS485_RX_DURING_TX,
-	.delay_rts_before_send = 1,
-	.delay_rts_after_send = 1,
-};
-
 static int serial_omap_probe(struct platform_device *pdev)
 {
 	struct omap_uart_port_info *omap_up_info = dev_get_platdata(&pdev->dev);
@@ -1604,17 +1607,11 @@ static int serial_omap_probe(struct plat
 		dev_info(up->port.dev, "no wakeirq for uart%d\n",
 			 up->port.line);
 
-	ret = serial_omap_probe_rs485(up, &pdev->dev);
-	if (ret < 0)
-		goto err_rs485;
-
 	sprintf(up->name, "OMAP UART%d", up->port.line);
 	up->port.mapbase = mem->start;
 	up->port.membase = base;
 	up->port.flags = omap_up_info->flags;
 	up->port.uartclk = omap_up_info->uartclk;
-	up->port.rs485_config = serial_omap_config_rs485;
-	up->port.rs485_supported = serial_omap_rs485_supported;
 	if (!up->port.uartclk) {
 		up->port.uartclk = DEFAULT_CLK_SPEED;
 		dev_warn(&pdev->dev,
@@ -1622,6 +1619,10 @@ static int serial_omap_probe(struct plat
 			 DEFAULT_CLK_SPEED);
 	}
 
+	ret = serial_omap_probe_rs485(up, &pdev->dev);
+	if (ret < 0)
+		goto err_rs485;
+
 	up->latency = PM_QOS_CPU_LATENCY_DEFAULT_VALUE;
 	up->calc_latency = PM_QOS_CPU_LATENCY_DEFAULT_VALUE;
 	cpu_latency_qos_add_request(&up->pm_qos_request, up->latency);


