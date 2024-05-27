Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129BD168C4;
	Mon, 27 May 2024 19:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837436; cv=none; b=DH/l8PJuaxU0j1HrHKsq0e3kJeZ5UahNj3bnZhenQLCe6UDW9JDMCO/uFORhEeXArCMPCPgvv+B1iCVPGjhSmOCIfXDwXDCMFg1tQM5+LmKWvUIRHOCn+I1qu4+/oYRAgjq5Qa0eJK19W0PfoLWKeABMOUToLZRS9kOiGdouVMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837436; c=relaxed/simple;
	bh=0EhNdlFocAvM17hqxIqbhhOQO2YiXDYJtdu4Kpy9AYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiMtkFmgbwTuLdUOcnJiXOEVeeb2nX+eJUh+BOl8GVdnkyTHg++rLybLd5kVesbArLaJWahvbyOMzNGQ8PqZTnRO/tWh5Or6m4//ctobPqwyuodrygpwUR+Lgrb/gtxK3Tl9z5hEM7FE4Wotca7bc8+r0GpM1ZCk0kutgpEsuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xfWMp8IW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xfWMp8IW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F157C2BBFC;
	Mon, 27 May 2024 19:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837436;
	bh=0EhNdlFocAvM17hqxIqbhhOQO2YiXDYJtdu4Kpy9AYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xfWMp8IWTPTojzBlqqlcGo1MnTCBXx4uw55h0GbKY47vhBFjzUZIv+b7VznFYXcDr
	 EWjUwlZUAfPick7S6C6GvMQAWaEXrtnXO87H5qI7NCIhzKcQc2DYfnOIlXX5+nvFnC
	 KLHv+TpXIIBCKFnXvVTN6ua+mhKhL9b1dFpI/Cww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH 6.8 013/493] serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup
Date: Mon, 27 May 2024 20:50:15 +0200
Message-ID: <20240527185627.798710820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

commit 4244f830a56058ee0670d80e7ac9fd7c982eb480 upstream.

When Rx in-band wakeup is enabled, set RTS to true in mtk8250_shutdown()
so the connected device can still send message and trigger IRQ when the
system is suspended.

Fixes: 18c9d4a3c249 ("serial: When UART is suspended, set RTS to false")
Cc: stable <stable@kernel.org>
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Link: https://lore.kernel.org/r/20240424130619.2924456-1-treapking@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -209,15 +209,19 @@ static int mtk8250_startup(struct uart_p
 
 static void mtk8250_shutdown(struct uart_port *port)
 {
-#ifdef CONFIG_SERIAL_8250_DMA
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct mtk8250_data *data = port->private_data;
+	int irq = data->rx_wakeup_irq;
 
+#ifdef CONFIG_SERIAL_8250_DMA
 	if (up->dma)
 		data->rx_status = DMA_RX_SHUTDOWN;
 #endif
 
-	return serial8250_do_shutdown(port);
+	serial8250_do_shutdown(port);
+
+	if (irq >= 0)
+		serial8250_do_set_mctrl(&up->port, TIOCM_RTS);
 }
 
 static void mtk8250_disable_intrs(struct uart_8250_port *up, int mask)


