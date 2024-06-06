Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5446F19E7E1;
	Thu,  6 Jun 2024 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683110; cv=none; b=ImUVXdt7dRA0VYT6SM9EWxnbttVOGB8kHS1ac2+ugKsy+DF0lY8wNtWQXymPFgTmhBbGJl8xFJxNwlerv2nASYXsQHvQDo77CVs6Jq/uFJlGAeUSbOn48aNUFcrBOCyTAQYRCQGNFSiZ20FdJQH8hiNOOF2ulhvF4Taukml4je4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683110; c=relaxed/simple;
	bh=bjYexPajKL1CEx9LNCs6ga2LE29+VVZip74ZXfUqcqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8F7JIatmsKuFdENoNxjaDr+aRO2Yi8FK8Lq8Lx/c9+wtrRF30ML3IOE8/Uisx98GGKPwrSLy5Glx6FWcMNBlDv6ZjNaDL/lJZlm0/3dwDtMEH02XDCb8kvUHBIh47NSf3n6jb1SOTZVp4ud1EnJUd74CTuxIj9DWWJIyGGdBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8aeGCkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8aeGCkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3162AC32782;
	Thu,  6 Jun 2024 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683110;
	bh=bjYexPajKL1CEx9LNCs6ga2LE29+VVZip74ZXfUqcqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8aeGCkBRoOxvLrVQkm1OeYzVnj08jBguTbV0lWVKxw54EYsucBdYtDdg/bdKKk8Q
	 PYvoWdr0oQAb3n/Ub96w0DhwYSsQqdV1pGU0LGncc8iZBDPq6cvDvso2x/UPrtnTac
	 q4oLeD/eRA9/KhCcc1tQFoOFNiGiV8Yp5cJMR6DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH 6.6 008/744] serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup
Date: Thu,  6 Jun 2024 15:54:40 +0200
Message-ID: <20240606131732.715917625@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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


