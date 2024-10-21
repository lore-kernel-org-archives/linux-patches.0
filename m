Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C58D1E47D3;
	Mon, 21 Oct 2024 10:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507189; cv=none; b=WskOHP2LM/gER0eRRjT7BQbeT6fB5RrQOdnkxw5K1MeTeUACNfBhvWNzb42dNDlpLFnhhOMooQWR2+4HyFZg1pGlFpTVlyI0+puGaz/J9pmi3WDHWZltaK9VuaXIn8FYcoqIYGynm5SENhVibfz0KLFdBJrjwtY3lBkBY/61h/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507189; c=relaxed/simple;
	bh=qqKJUV22mxvzwT5WBTCPrmvRxOthtUu68gzjFHovz10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwqwywmRlqb/X33QJNScLkyAcf2aTxxh9s/Laxwkw9GX7vI+dR7I5rzzFMV6Wzg0O9yq6czsRacEZ5APTqIa7sIJmFv3JRCJguR2L9RE+rZWQs5BMi03FxfuEX13PdoIGZoyh/1+ynZd9F1sf/dCUVb21O/O/9ejFxvTVLEcFBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwDCMhVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwDCMhVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FB5C4CEC3;
	Mon, 21 Oct 2024 10:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507189;
	bh=qqKJUV22mxvzwT5WBTCPrmvRxOthtUu68gzjFHovz10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwDCMhVl4GUXsSzDBN73fjnEePT1er3MPvm9EtuFgP+gciLCXzcXkVbT0hVmAvkfN
	 +f3DqqpWeWk1NDrl972XIS0AKSiz5jJl0JbI+UqulkzdpYf44+jBdXj0O58eaaxsT8
	 DO94GIGNjxk6lOPSCm6SBnd57MTa8JELoIfbhFPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 118/124] serial: qcom-geni: fix receiver enable
Date: Mon, 21 Oct 2024 12:25:22 +0200
Message-ID: <20241021102301.284425440@linuxfoundation.org>
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
@@ -1159,6 +1159,11 @@ static int qcom_geni_serial_startup(stru
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
@@ -1244,7 +1249,6 @@ static void qcom_geni_serial_set_termios
 	unsigned int avg_bw_core;
 	unsigned long timeout;
 
-	qcom_geni_serial_stop_rx(uport);
 	/* baud rate */
 	baud = uart_get_baud_rate(uport, termios, old, 300, 4000000);
 
@@ -1260,7 +1264,7 @@ static void qcom_geni_serial_set_termios
 		dev_err(port->se.dev,
 			"Couldn't find suitable clock rate for %u\n",
 			baud * sampling_rate);
-		goto out_restart_rx;
+		return;
 	}
 
 	dev_dbg(port->se.dev, "desired_rate = %u, clk_rate = %lu, clk_div = %u\n",
@@ -1351,8 +1355,6 @@ static void qcom_geni_serial_set_termios
 	writel(stop_bit_len, uport->membase + SE_UART_TX_STOP_BIT_LEN);
 	writel(ser_clk_cfg, uport->membase + GENI_SER_M_CLK_CFG);
 	writel(ser_clk_cfg, uport->membase + GENI_SER_S_CLK_CFG);
-out_restart_rx:
-	qcom_geni_serial_start_rx(uport);
 }
 
 #ifdef CONFIG_SERIAL_QCOM_GENI_CONSOLE


