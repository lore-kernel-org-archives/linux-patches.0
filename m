Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835401E1C11;
	Mon, 21 Oct 2024 10:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507177; cv=none; b=ilwldgw0huRL3y8sLSTSSUVDNJnE6JKI2mkuIAucGY1g97o8SHpxTQDHDbhDv+9zeNOgSVWydPd+3TumQ+gl/9+8Atu1kOOfgbiRUBYVTq5L+L6vC6nTwr4OGWB2GsvBP+0yzfg+4dwimW2Wie3n2MvmNFAzkM61PUOBjwzQaAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507177; c=relaxed/simple;
	bh=Fr4e0Wrl/CECtdS0cTy6RBY7wDnHigJSfnZEnadkMS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBH4CRA3T9j7xrkkuq53iBti1xsT6tcuU3lb7YebwxoKElyfVvRyQdCy8iGEHVQl76R8kUAC0WwvmGgGolIDzZD79fQCwM5Mh5X6mxe0yu9vRnbxS/AeIyHGX9L74FM4NXXJi0a8AIwtAWNVzk+PED10O1Mj1qbaRi4LPXXmHEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMx46czJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMx46czJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03556C4CEC3;
	Mon, 21 Oct 2024 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507177;
	bh=Fr4e0Wrl/CECtdS0cTy6RBY7wDnHigJSfnZEnadkMS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMx46czJ7Pcf/6dTwTUhwB2916neiF+0CSKuFSMujjCz5dvO2eteYyOmar8hRG/6L
	 90NRPrDO+mgxtNZ3Kkxb/jj/fa0umiIU0rzosPehGwkFEgV4ygKD4V/MWpEYnYu73f
	 7vjQeFnV8zDq/vVGiliiQdzOumLoWa0lBSqVvUXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 6.6 115/124] serial: qcom-geni: fix polled console initialisation
Date: Mon, 21 Oct 2024 12:25:19 +0200
Message-ID: <20241021102301.162971180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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
 drivers/tty/serial/qcom_geni_serial.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -144,6 +144,8 @@ static const struct uart_ops qcom_geni_u
 static struct uart_driver qcom_geni_console_driver;
 static struct uart_driver qcom_geni_uart_driver;
 
+static int qcom_geni_serial_port_setup(struct uart_port *uport);
+
 static inline struct qcom_geni_serial_port *to_dev_port(struct uart_port *uport)
 {
 	return container_of(uport, struct qcom_geni_serial_port, uport);
@@ -385,6 +387,23 @@ static void qcom_geni_serial_poll_put_ch
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
@@ -1544,7 +1563,7 @@ static const struct uart_ops qcom_geni_c
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char	= qcom_geni_serial_get_char,
 	.poll_put_char	= qcom_geni_serial_poll_put_char,
-	.poll_init = qcom_geni_serial_port_setup,
+	.poll_init = qcom_geni_serial_poll_init,
 #endif
 	.pm = qcom_geni_serial_pm,
 };


