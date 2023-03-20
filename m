Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C941C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D9DC433EF;
	Mon, 20 Mar 2023 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325194;
	bh=qbo9XWNq23EDXEraNK0IGPnh/c0NhzeJ4C3PdkbwJwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dh/Z+NdQmUb4ddNUzyGpIBk8TD2+qhsQxqo+zUlYlYoMs8+iyPF7/rzY0Fgv6uIee
	 4lWTc3U6tH1vw0HhRDaRF59Vzg2qcX0ewP2V/Vhl23HyMcehL9m0NVLcvFN4Ya04AU
	 aV/YrsNY99gnVhane5tuze3FS43L7fGtTRkvuOd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 076/115] serial: 8250_fsl: fix handle_irq locking
Date: Mon, 20 Mar 2023 15:54:48 +0100
Message-Id: <20230320145452.609802090@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan@kernel.org>

commit 6e01f9a594ee0f69fb52cc8d11971612b4817f0b upstream.

The 8250 handle_irq callback is not just called from the interrupt
handler but also from a timer callback when polling (e.g. for ports
without an interrupt line). Consequently the callback must explicitly
disable interrupts to avoid a potential deadlock with another interrupt
in polled mode.

Fix up the two paths in the freescale callback that failed to re-enable
interrupts when polling.

Fixes: 853a9ae29e97 ("serial: 8250: fix handle_irq locking")
Cc: stable@vger.kernel.org	# 5.13
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y/xYzqp4ogmOF5t0@kili
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230227085046.24282-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_fsl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -38,7 +38,7 @@ int fsl8250_handle_irq(struct uart_port
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 0;
 	}
 
@@ -46,7 +46,7 @@ int fsl8250_handle_irq(struct uart_port
 	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
 		up->lsr_saved_flags &= ~UART_LSR_BI;
 		port->serial_in(port, UART_RX);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 1;
 	}
 


