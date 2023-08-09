Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC80F17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE00C433C9;
	Wed,  9 Aug 2023 11:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579232;
	bh=voBZVc5ho4g9F3rUTQ+vg+CRcWntCWG49gESofRyHIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA4JZz5CX7vKdpbCaRNPFgLkVIjJfMTWNlk52lfsTLRgavGT2e7oOkmE8dwDmGaCI
	 KQdI/nosCQHJmgECj9bzT/lDi7/e4ZDPc/mRCIQyJIcRurdhcymen6/D7xHRIBhI2U
	 8WPRZZuHKv3g4izgGrfVolXiQIcDnQbOBt7rtmBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Richard Genoud <richard.genoud@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.14 123/204] serial: atmel: dont enable IRQs prematurely
Date: Wed,  9 Aug 2023 12:41:01 +0200
Message-ID: <20230809103646.722995391@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 27a826837ec9a3e94cc44bd9328b8289b0fcecd7 upstream.

The atmel_complete_tx_dma() function disables IRQs at the start
of the function by calling spin_lock_irqsave(&port->lock, flags);
There is no need to disable them a second time using the
spin_lock_irq() function and, in fact, doing so is a bug because
it will enable IRQs prematurely when we call spin_unlock_irq().

Just use spin_lock/unlock() instead without disabling or enabling
IRQs.

Fixes: 08f738be88bb ("serial: at91: add tx dma support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Link: https://lore.kernel.org/r/cb7c39a9-c004-4673-92e1-be4e34b85368@moroto.mountain
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -798,11 +798,11 @@ static void atmel_complete_tx_dma(void *
 
 	port->icount.tx += atmel_port->tx_len;
 
-	spin_lock_irq(&atmel_port->lock_tx);
+	spin_lock(&atmel_port->lock_tx);
 	async_tx_ack(atmel_port->desc_tx);
 	atmel_port->cookie_tx = -EINVAL;
 	atmel_port->desc_tx = NULL;
-	spin_unlock_irq(&atmel_port->lock_tx);
+	spin_unlock(&atmel_port->lock_tx);
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);


