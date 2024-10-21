Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB21E570D;
	Mon, 21 Oct 2024 10:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506828; cv=none; b=YF9EwnP8OMgJZwZBhgd0VkveAHSJdCyoWhzcVT6vLeTf6h1DP0rs0NK7xGhRD28MVaiPlAHq1+esWxvjuPKvbwfU9HJ2l0m9LhBqf9Ky+vV+t9dPJfW46ZYpIN1HlkKcVQkMlu9LFqTjKWE2imxG5a+7Aldhloz888PzL0Xqa+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506828; c=relaxed/simple;
	bh=LkFEXn9KjY//3+HihTfWG5ZySezlRm4M6LxkCNNwGSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMaJDqAJQ2jDFNsSKazX+sZxcZGxT+zsoV4cXu3UB7qvl5TZxz4B4jnK3NmcWyjxyT0Vlz7VSOGY42v541epZc/l0AdaPLgaxks/IkW9cM5/7HSJc+QT4NiIaL32XLOg3cwGwdz6llDvO9m3gl6p0pHH7SczDT4+E0bhKEhBfuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnObGRrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnObGRrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D48DC4CEC3;
	Mon, 21 Oct 2024 10:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506827;
	bh=LkFEXn9KjY//3+HihTfWG5ZySezlRm4M6LxkCNNwGSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnObGRrYC/392H5svSYDsRLLRlYgX0lvu2pXMrLqx8zfPQQxi0GBvA2Xfm391Quh0
	 s1SzY2WfpcOTL7Ui1lzE3uwWtD/xleiKHGnSC00+skdcIjrz0p4V96YUmLCJ+aZSvP
	 MTigyCnReDkMp3vs9WSIR8b8NcyHS4uIun0Do+EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.11 133/135] serial: qcom-geni: fix receiver enable
Date: Mon, 21 Oct 2024 12:24:49 +0200
Message-ID: <20241021102304.553714111@linuxfoundation.org>
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

commit fa103d2599e11e802c818684cff821baefe7f206 upstream.

The receiver is supposed to be enabled in the startup() callback and not
in set_termios() which is called also during console setup.

This specifically avoids accepting input before the port has been opened
(and interrupts enabled), something which can also break the GENI
firmware (cancel fails and after abort, the "stale" counter handling
appears to be broken so that later input is not processed until twelve
chars have been received).

There also does not appear to be any need to keep the receiver disabled
while updating the port settings.

Since commit 6f3c3cafb115 ("serial: qcom-geni: disable interrupts during
console writes") the calls to manipulate the secondary interrupts, which
were done without holding the port lock, can also lead to the receiver
being left disabled when set_termios() races with the console code (e.g.
when init opens the tty during boot). This can manifest itself as a
serial getty not accepting input.

The calls to stop and start rx in set_termios() can similarly race with
DMA completion and, for example, cause the DMA buffer to be unmapped
twice or the mapping to be leaked.

Fix this by only enabling the receiver during startup and while holding
the port lock to avoid racing with the console code.

Fixes: 6f3c3cafb115 ("serial: qcom-geni: disable interrupts during console writes")
Fixes: 2aaa43c70778 ("tty: serial: qcom-geni-serial: add support for serial engine DMA")
Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Cc: stable@vger.kernel.org      # 6.3
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20241009145110.16847-6-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1179,6 +1179,11 @@ static int qcom_geni_serial_startup(stru
 		if (ret)
 			return ret;
 	}
+
+	uart_port_lock_irq(uport);
+	qcom_geni_serial_start_rx(uport);
+	uart_port_unlock_irq(uport);
+
 	enable_irq(uport->irq);
 
 	return 0;
@@ -1264,7 +1269,6 @@ static void qcom_geni_serial_set_termios
 	unsigned int avg_bw_core;
 	unsigned long timeout;
 
-	qcom_geni_serial_stop_rx(uport);
 	/* baud rate */
 	baud = uart_get_baud_rate(uport, termios, old, 300, 4000000);
 
@@ -1280,7 +1284,7 @@ static void qcom_geni_serial_set_termios
 		dev_err(port->se.dev,
 			"Couldn't find suitable clock rate for %u\n",
 			baud * sampling_rate);
-		goto out_restart_rx;
+		return;
 	}
 
 	dev_dbg(port->se.dev, "desired_rate = %u, clk_rate = %lu, clk_div = %u\n",
@@ -1371,8 +1375,6 @@ static void qcom_geni_serial_set_termios
 	writel(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
 	writel(ser_clk_cfg, uport->membase + GENI_SER_M_CLK_CFG);
 	writel(ser_clk_cfg, uport->membase + GENI_SER_S_CLK_CFG);
-out_restart_rx:
-	qcom_geni_serial_start_rx(uport);
 }
 
 #ifdef CONFIG_SERIAL_QCOM_GENI_CONSOLE


