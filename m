Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C131EABD5;
	Mon, 21 Oct 2024 10:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506813; cv=none; b=JYZEr+ySK0La/z12FY3Vgfl54P5HC2lkLK4+/1hCn5LgAGLKSI6AIRPNXT5HYzAnwryCxW2NxZzqDyMKIrbMwtIXBm4Vj40jxPaPXLNAmaycdcbGG8YJdC2b7koqm2nu6qOMdaZ7C3l6e78ry9Bqb39kQHsJ7PXo2GsiB3eWk6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506813; c=relaxed/simple;
	bh=G3P2B5kcslUPU20SBZXHfc3THmuziEn4CQPejZyvM2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSfv52tBYrHoWONLH2tB5nzyUFUNhWLscKkfZ6faD0j7qRpPXiHTX9Cf70t0LpJ4Y94Jh3pKucGw3nmE8sld4R+kU4uC+xQx4T4N8wc/W6bSLS56gmb2FW3oRhUMZA4nVAr54/F3UA0NAX9qULeoIsE60tE0KRgzzuowCezE0Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S60KB8D6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S60KB8D6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B23C4CEC3;
	Mon, 21 Oct 2024 10:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506812;
	bh=G3P2B5kcslUPU20SBZXHfc3THmuziEn4CQPejZyvM2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S60KB8D64BAptU2wJTd9WC/U8o7MLsGTVrw9Y83Vmeb161DbJyzeE9AL6cntOQLbu
	 6Mp8h+IsyLVa+YZXqVGrIdhHsCW/yEbVPLS/GflIhaxs3WhjSZm3IRWlDr6Sn62Lxl
	 qwHfWWZP5HhIrMjtRog3SIxw0yAYa81mPJ2gdXkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.11 129/135] serial: qcom-geni: fix polled console initialisation
Date: Mon, 21 Oct 2024 12:24:45 +0200
Message-ID: <20241021102304.390804398@linuxfoundation.org>
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

commit 4bef7c6f299910f19876ad8e7f5897514855f1d2 upstream.

The polled console (KGDB/KDB) implementation must not call port setup
unconditionally as the port may already be in use by the console or a
getty.

Only make sure that the receiver is enabled, but do not enable any
device interrupts.

Fixes: d8851a96ba25 ("tty: serial: qcom-geni-serial: Add a poll_init() function")
Cc: stable@vger.kernel.org	# 6.4
Cc: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20241009145110.16847-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -146,6 +146,7 @@ static struct uart_driver qcom_geni_cons
 static struct uart_driver qcom_geni_uart_driver;
 
 static void qcom_geni_serial_cancel_tx_cmd(struct uart_port *uport);
+static int qcom_geni_serial_port_setup(struct uart_port *uport);
 
 static inline struct qcom_geni_serial_port *to_dev_port(struct uart_port *uport)
 {
@@ -393,6 +394,23 @@ static void qcom_geni_serial_poll_put_ch
 	writel(M_TX_FIFO_WATERMARK_EN, uport->membase + SE_GENI_M_IRQ_CLEAR);
 	qcom_geni_serial_poll_tx_done(uport);
 }
+
+static int qcom_geni_serial_poll_init(struct uart_port *uport)
+{
+	struct qcom_geni_serial_port *port = to_dev_port(uport);
+	int ret;
+
+	if (!port->setup) {
+		ret = qcom_geni_serial_port_setup(uport);
+		if (ret)
+			return ret;
+	}
+
+	if (!qcom_geni_serial_secondary_active(uport))
+		geni_se_setup_s_cmd(&port->se, UART_START_READ, 0);
+
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_SERIAL_QCOM_GENI_CONSOLE
@@ -1564,7 +1582,7 @@ static const struct uart_ops qcom_geni_c
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char	= qcom_geni_serial_get_char,
 	.poll_put_char	= qcom_geni_serial_poll_put_char,
-	.poll_init = qcom_geni_serial_port_setup,
+	.poll_init = qcom_geni_serial_poll_init,
 #endif
 	.pm = qcom_geni_serial_pm,
 };


