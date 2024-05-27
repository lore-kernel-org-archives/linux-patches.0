Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913115FD01;
	Mon, 27 May 2024 18:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836332; cv=none; b=RMHCqesCcYGFqd+8MEwp2VRj8udQO9lqEh5bJmS6rlPZYfTDGE571izH0tjF+MGWQvIgVj+S+07aStYrNqLiQ66uPO8xvsldb1exVEi9uiyoNfAjt5HLYiVHhIaq4phMgHXKIMB1ox7+UkqO64jdbYq0mPnhvXCVCnut2/pk4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836332; c=relaxed/simple;
	bh=FJP1J6ZsneHlLdYb1mYQdmk8t8xd1XCau/ErAd2I748=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNo3ng7+nvhJYxXzrI+ZY+CyOwUcp8aKUlm0ThN1bwmLnPlKb8sd13Qtqp1CmvyCbYxC+kjN1UBLWHEEkj217xkypJRQcMREz05PVOtTiUI45ORoUQdbFi2N56ENg9hbpRrBuXIg55pTmlWZzYeY2FT4+FgPdRl83IdzwI/sSAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1m9pY48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1m9pY48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C0AC2BBFC;
	Mon, 27 May 2024 18:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836332;
	bh=FJP1J6ZsneHlLdYb1mYQdmk8t8xd1XCau/ErAd2I748=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1m9pY48hakk1G9w32zQB3b3U3H1zsfH0wpyB2JzRjRLRcTtZZ6QVFr1fNK2x1W3T
	 q1dj2Xcp8qa1LOYRyErBmqv9wKfyf+xM9emoeoH/uyglMDg0BXxX6So4h0Szl7yrkh
	 XwaS6CIQf9XFOHHAkKEZbCrQA6AGx1Vx+pu5iiZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH 6.9 013/427] serial: 8520_mtk: Set RTS on shutdown for Rx in-band wakeup
Date: Mon, 27 May 2024 20:51:00 +0200
Message-ID: <20240527185602.993741078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


