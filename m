Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA75765BA2;
	Tue, 23 Jan 2024 00:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971594; cv=none; b=jb4BO1FWYak+TwD5CPcz9iD2zZ3ECpo2yvt/ngIV2+qTjRWZj03ei0d53Tc9+sRhtL+unu35kFOTpUCguIjMZtE3vANRzN1WyaIihPRAqDv67FOBvyHy4736ASGIf1LrB8xmIHJ7yLgcqUtT2S8YKINXGC7OsW79iYcj9b+W6es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971594; c=relaxed/simple;
	bh=atVIhm+JIkYatXpXK0HmXMnNEH4k7x242RbVOXrMjVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MKNIQlX30/tazMdWam+fKkclABZyKe8hxmOh9MVmXfDhx6LSzNWF+AElcy1xH8W8EZe3sNF8DhdT6It1YYGV1bRMY1fYeE2Doo8HkKCrEfCX7xVTTsjFBfm/LSvEkWXtNp1EvA4z+2enqjqHBSB8Z/M5r4yeFO+GGnv+ZigAOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnbKn7OL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnbKn7OL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD96C433F1;
	Tue, 23 Jan 2024 00:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971594;
	bh=atVIhm+JIkYatXpXK0HmXMnNEH4k7x242RbVOXrMjVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnbKn7OLxwBZRT4WNNC8EhrpKk9uSUcu+gC8NnpI2Rxdjoe7rCBmWx/+xSxlU1/vb
	 EbsINiebf08xe+pYCSORyQislCjHdlC0utS76lVWUzaEYJWDaFnV1St+D2FEQMoCbg
	 r/FQ0UR1jXN1XJl72IHjeDRgPxSR11fAwQzRURJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 276/417] serial: omap: do not override settings for RS485 support
Date: Mon, 22 Jan 2024 15:57:24 -0800
Message-ID: <20240122235801.405706173@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1512,6 +1512,13 @@ static struct omap_uart_port_info *of_ge
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
@@ -1526,6 +1533,9 @@ static int serial_omap_probe_rs485(struc
 	if (!np)
 		return 0;
 
+	up->port.rs485_config = serial_omap_config_rs485;
+	up->port.rs485_supported = serial_omap_rs485_supported;
+
 	ret = uart_get_rs485_mode(&up->port);
 	if (ret)
 		return ret;
@@ -1560,13 +1570,6 @@ static int serial_omap_probe_rs485(struc
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
@@ -1634,17 +1637,11 @@ static int serial_omap_probe(struct plat
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
@@ -1652,6 +1649,10 @@ static int serial_omap_probe(struct plat
 			 DEFAULT_CLK_SPEED);
 	}
 
+	ret = serial_omap_probe_rs485(up, &pdev->dev);
+	if (ret < 0)
+		goto err_rs485;
+
 	up->latency = PM_QOS_CPU_LATENCY_DEFAULT_VALUE;
 	up->calc_latency = PM_QOS_CPU_LATENCY_DEFAULT_VALUE;
 	cpu_latency_qos_add_request(&up->pm_qos_request, up->latency);


