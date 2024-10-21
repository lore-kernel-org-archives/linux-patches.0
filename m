Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC321E570F;
	Mon, 21 Oct 2024 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506816; cv=none; b=DKm2IPp3ikBWf7p5SYONXm+0SpLzxObGnYs/NOFkLmvArCBZQEBC8jIWaeK2gsxTV24qBOKJkwJ67TM1FJ1ll3wecvGpbidFKo1ysOkeKUryjLdlnxrmDgusNgZSpeuDxLioumKdFmFDHNyVvF96itqxqYua9cAmEu8gM4ehJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506816; c=relaxed/simple;
	bh=9TtFgVmDIiWfcn1DUg2KUG9uaTZZWMCTNFHFJ1bBDLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwMGQnI1gBcezbqUILBhccZ5UNcNNSduLPv/iPZ/8VMakHgJP6JnnYHC4kl1yGftJNVGCIW4uvKI5YrJRyXkB5U5MO8gg8jjLdPtocrOJJSm+UxhBWKLRK1hBusccrSK3YXXU3+Nv0s9zZjDGXB1VDZNtd+yQ0jk9mCqI0eyGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIIz7er7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIIz7er7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C485C4CEC3;
	Mon, 21 Oct 2024 10:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506815;
	bh=9TtFgVmDIiWfcn1DUg2KUG9uaTZZWMCTNFHFJ1bBDLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIIz7er79EIOMka3BBshoJaLSmKd3GXemfPMf60+VeSEXuWN1il2HgxMXm2oIU8Cd
	 3SW7XNg1MtOv3monhAhjCt2kyeAu+CH0ww21pYgZ3WgZEM7F3LCRN0lfuVwezL4o6h
	 aS2zlS7LUObfa3rPrAluW1m/SFsYXrfJicdd3V20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Randive <quic_arandive@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.11 130/135] serial: qcom-geni: revert broken hibernation support
Date: Mon, 21 Oct 2024 12:24:46 +0200
Message-ID: <20241021102304.430907341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 19df76662a33d2f2fc41a66607cb8285fc02d6ec upstream.

This reverts commit 35781d8356a2eecaa6074ceeb80ee22e252fcdae.

Hibernation is not supported on Qualcomm platforms with mainline
kernels yet a broken vendor implementation for the GENI serial driver
made it upstream.

This is effectively dead code that cannot be tested and should just be
removed, but if these paths were ever hit for an open non-console port
they would crash the machine as the driver would fail to enable clocks
during restore() (i.e. all ports would have to be closed by drivers and
user space before hibernating the system to avoid this as a comment in
the code hinted at).

The broken implementation also added a random call to enable the
receiver in the port setup code where it does not belong and which
enables the receiver prematurely for console ports.

Fixes: 35781d8356a2 ("tty: serial: qcom-geni-serial: Add support for Hibernation feature")
Cc: stable@vger.kernel.org	# 6.2
Cc: Aniket Randive <quic_arandive@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241009145110.16847-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   41 +---------------------------------
 1 file changed, 2 insertions(+), 39 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1152,7 +1152,6 @@ static int qcom_geni_serial_port_setup(s
 			       false, true, true);
 	geni_se_init(&port->se, UART_RX_WM, port->rx_fifo_depth - 2);
 	geni_se_select_mode(&port->se, port->dev_data->mode);
-	qcom_geni_serial_start_rx(uport);
 	port->setup = true;
 
 	return 0;
@@ -1781,38 +1780,6 @@ static int qcom_geni_serial_sys_resume(s
 	return ret;
 }
 
-static int qcom_geni_serial_sys_hib_resume(struct device *dev)
-{
-	int ret = 0;
-	struct uart_port *uport;
-	struct qcom_geni_private_data *private_data;
-	struct qcom_geni_serial_port *port = dev_get_drvdata(dev);
-
-	uport = &port->uport;
-	private_data = uport->private_data;
-
-	if (uart_console(uport)) {
-		geni_icc_set_tag(&port->se, QCOM_ICC_TAG_ALWAYS);
-		geni_icc_set_bw(&port->se);
-		ret = uart_resume_port(private_data->drv, uport);
-		/*
-		 * For hibernation usecase clients for
-		 * console UART won't call port setup during restore,
-		 * hence call port setup for console uart.
-		 */
-		qcom_geni_serial_port_setup(uport);
-	} else {
-		/*
-		 * Peripheral register settings are lost during hibernation.
-		 * Update setup flag such that port setup happens again
-		 * during next session. Clients of HS-UART will close and
-		 * open the port during hibernation.
-		 */
-		port->setup = false;
-	}
-	return ret;
-}
-
 static const struct qcom_geni_device_data qcom_geni_console_data = {
 	.console = true,
 	.mode = GENI_SE_FIFO,
@@ -1824,12 +1791,8 @@ static const struct qcom_geni_device_dat
 };
 
 static const struct dev_pm_ops qcom_geni_serial_pm_ops = {
-	.suspend = pm_sleep_ptr(qcom_geni_serial_sys_suspend),
-	.resume = pm_sleep_ptr(qcom_geni_serial_sys_resume),
-	.freeze = pm_sleep_ptr(qcom_geni_serial_sys_suspend),
-	.poweroff = pm_sleep_ptr(qcom_geni_serial_sys_suspend),
-	.restore = pm_sleep_ptr(qcom_geni_serial_sys_hib_resume),
-	.thaw = pm_sleep_ptr(qcom_geni_serial_sys_hib_resume),
+	SYSTEM_SLEEP_PM_OPS(qcom_geni_serial_sys_suspend,
+					qcom_geni_serial_sys_resume)
 };
 
 static const struct of_device_id qcom_geni_serial_match_table[] = {


