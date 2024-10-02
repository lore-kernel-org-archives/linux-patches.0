Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AABE17B421;
	Wed,  2 Oct 2024 13:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876998; cv=none; b=MFcKKMAnVS/2Lg+nwqJ5QXxp6Lojnv6xDjHlQGdKB0llGSwu3u2IBzqVh43VYhBnVnUglSeYT+VJyDw2/UezqrmwtVcylEITWHGfsOLtg9aLEZd25bB6B3h550uiuqxMz06fAvAl57f1AiTKQeVcunhcIcOSOCrO2z9gasKK/RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876998; c=relaxed/simple;
	bh=ZqzDtRcGNtj8bKTKajIdavzMuL+vD4aNQ4LdCqqayJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DXaxLitU49B45QU+wtFeYfgmI3OZgdWnl/rXVwFkxKVSc7MY188bjh6gxbt6aKYuv3cnVXVvvS3q0uOh65EYCr/5U+n1u5ogOqbx/N5YfGxHdpTBIEIAfrUOu7hnq740pZ1DomoXSdtKPp8uswZZZi09KTysOddpEjxrMYWlRhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TblGk3rS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TblGk3rS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D76C4CEC2;
	Wed,  2 Oct 2024 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876998;
	bh=ZqzDtRcGNtj8bKTKajIdavzMuL+vD4aNQ4LdCqqayJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TblGk3rSiFlKfk6CVXO83EfQQDN/oHrUdyVar04lqvo1uUtW8PQT102UCLL2xL6Eb
	 kg+vxwlGfOO7KISkDSkJ/kFcF32TM6nPSOLUtHFRLrosRLo+XdOx1y2Hx9WYKBbK7N
	 yzXUf9ERv8au29Oy40uEFhggFlW4Q7oBn7PMjP5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.11 598/695] serial: qcom-geni: fix fifo polling timeout
Date: Wed,  2 Oct 2024 14:59:56 +0200
Message-ID: <20241002125846.383347944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit c80ee36ac8f9e9c27d8e097a2eaaf198e7534c83 upstream.

The qcom_geni_serial_poll_bit() can be used to wait for events like
command completion and is supposed to wait for the time it takes to
clear a full fifo before timing out.

As noted by Doug, the current implementation does not account for start,
stop and parity bits when determining the timeout. The helper also does
not currently account for the shift register and the two-word
intermediate transfer register.

A too short timeout can specifically lead to lost characters when
waiting for a transfer to complete as the transfer is cancelled on
timeout.

Instead of determining the poll timeout on every call, store the fifo
timeout when updating it in set_termios() and make sure to take the
shift and intermediate registers into account. Note that serial core has
already added a 20 ms margin to the fifo timeout.

Also note that the current uart_fifo_timeout() interface does
unnecessary calculations on every call and did not exist in earlier
kernels so only store its result once. This facilitates backports too as
earlier kernels can derive the timeout from uport->timeout, which has
since been removed.

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Cc: stable@vger.kernel.org	# 4.17
Reported-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240906131336.23625-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -124,7 +124,7 @@ struct qcom_geni_serial_port {
 	dma_addr_t tx_dma_addr;
 	dma_addr_t rx_dma_addr;
 	bool setup;
-	unsigned int baud;
+	unsigned long poll_timeout_us;
 	unsigned long clk_rate;
 	void *rx_buf;
 	u32 loopback;
@@ -270,22 +270,13 @@ static bool qcom_geni_serial_poll_bit(st
 {
 	u32 reg;
 	struct qcom_geni_serial_port *port;
-	unsigned int baud;
-	unsigned int fifo_bits;
 	unsigned long timeout_us = 20000;
 	struct qcom_geni_private_data *private_data = uport->private_data;
 
 	if (private_data->drv) {
 		port = to_dev_port(uport);
-		baud = port->baud;
-		if (!baud)
-			baud = 115200;
-		fifo_bits = port->tx_fifo_depth * port->tx_fifo_width;
-		/*
-		 * Total polling iterations based on FIFO worth of bytes to be
-		 * sent at current baud. Add a little fluff to the wait.
-		 */
-		timeout_us = ((fifo_bits * USEC_PER_SEC) / baud) + 500;
+		if (port->poll_timeout_us)
+			timeout_us = port->poll_timeout_us;
 	}
 
 	/*
@@ -1244,11 +1235,11 @@ static void qcom_geni_serial_set_termios
 	unsigned long clk_rate;
 	u32 ver, sampling_rate;
 	unsigned int avg_bw_core;
+	unsigned long timeout;
 
 	qcom_geni_serial_stop_rx(uport);
 	/* baud rate */
 	baud = uart_get_baud_rate(uport, termios, old, 300, 4000000);
-	port->baud = baud;
 
 	sampling_rate = UART_OVERSAMPLING;
 	/* Sampling rate is halved for IP versions >= 2.5 */
@@ -1326,9 +1317,21 @@ static void qcom_geni_serial_set_termios
 	else
 		tx_trans_cfg |= UART_CTS_MASK;
 
-	if (baud)
+	if (baud) {
 		uart_update_timeout(uport, termios->c_cflag, baud);
 
+		/*
+		 * Make sure that qcom_geni_serial_poll_bitfield() waits for
+		 * the FIFO, two-word intermediate transfer register and shift
+		 * register to clear.
+		 *
+		 * Note that uart_fifo_timeout() also adds a 20 ms margin.
+		 */
+		timeout = jiffies_to_usecs(uart_fifo_timeout(uport));
+		timeout += 3 * timeout / port->tx_fifo_depth;
+		WRITE_ONCE(port->poll_timeout_us, timeout);
+	}
+
 	if (!uart_console(uport))
 		writel(port->loopback,
 				uport->membase + SE_UART_LOOPBACK_CFG);


