Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C4476030;
	Mon, 29 Jan 2024 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548621; cv=none; b=E2MdUdhGDJeO/yg/+mEdXP1Ecl9NspfIBBxuoLQATELI/M0v7KBJPMe8JR4iO7RfUiZT6xWK6/lfWeUwxLLHwifI4QooXb2jKXNN5QcAUOwRg8m07tWJoLVmQY6lBgE/g9Pj4wcSqEY1/ryQiMYQjN0v6bJPmnFvRXcO2k8XPBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548621; c=relaxed/simple;
	bh=M5EGZmOpV61W+2XLBSBYmmLk+anOeGYcNhyPd/wxN6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTbxAd5z5vAz5MHDq5t8m9eWbQFEgRvrGZMkrrs90Xnu6usv92fpJLPgE5Z7+PWzhYegFjTgnnGGTA1lkXdWMDfIEbMFSbIMi0/DH1YREIA5pneQvohPaxBatvwfuokDZvOoijaIfWZO4TNlK8uShxT01wJDP4cIHvH68JQlv34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIJsZkF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIJsZkF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778D9C433F1;
	Mon, 29 Jan 2024 17:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548620;
	bh=M5EGZmOpV61W+2XLBSBYmmLk+anOeGYcNhyPd/wxN6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIJsZkF+j11v4weRqUSZCseDJCeBV7ySqA9ISbKL9p9O2A7/NONgT/hapWWseIi1l
	 nv6s6j0ZswhA/mjoTiSjiitZN2h+VUbf/8OxIRGA6fGYbaRN56NbCEo/uYlqG+xVfj
	 w0I6CUph+g6Bn9qatoc5BHivMVxSBUqRFZRd9+cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 290/331] serial: sc16is7xx: fix unconditional activation of THRI interrupt
Date: Mon, 29 Jan 2024 09:05:54 -0800
Message-ID: <20240129170023.345299173@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 9915753037eba7135b209fef4f2afeca841af816 ]

Commit cc4c1d05eb10 ("sc16is7xx: Properly resume TX after stop") changed
behavior to unconditionnaly set the THRI interrupt in sc16is7xx_tx_proc().

For example when sending a 65 bytes message, and assuming the Tx FIFO is
initially empty, sc16is7xx_handle_tx() will write the first 64 bytes of the
message to the FIFO and sc16is7xx_tx_proc() will then activate THRI. When
the THRI IRQ is fired, the driver will write the remaining byte of the
message to the FIFO, and disable THRI by calling sc16is7xx_stop_tx().

When sending a 2 bytes message, sc16is7xx_handle_tx() will write the 2
bytes of the message to the FIFO and call sc16is7xx_stop_tx(), disabling
THRI. After sc16is7xx_handle_tx() exits, control returns to
sc16is7xx_tx_proc() which will unconditionally set THRI. When the THRI IRQ
is fired, the driver simply acknowledges the interrupt and does nothing
more, since all the data has already been written to the FIFO. This results
in 2 register writes and 4 register reads all for nothing and taking
precious cycles from the I2C/SPI bus.

Fix this by enabling the THRI interrupt only when we fill the Tx FIFO to
its maximum capacity and there are remaining bytes to send in the message.

Fixes: cc4c1d05eb10 ("sc16is7xx: Properly resume TX after stop")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-7-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 425093ce3f24..f75b8bceb8ca 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -676,6 +676,8 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 
 	if (uart_circ_empty(xmit))
 		sc16is7xx_stop_tx(port);
+	else
+		sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
 	uart_port_unlock_irqrestore(port, flags);
 }
 
@@ -802,7 +804,6 @@ static void sc16is7xx_tx_proc(struct kthread_work *ws)
 {
 	struct uart_port *port = &(to_sc16is7xx_one(ws, tx_work)->port);
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
-	unsigned long flags;
 
 	if ((port->rs485.flags & SER_RS485_ENABLED) &&
 	    (port->rs485.delay_rts_before_send > 0))
@@ -811,10 +812,6 @@ static void sc16is7xx_tx_proc(struct kthread_work *ws)
 	mutex_lock(&one->efr_lock);
 	sc16is7xx_handle_tx(port);
 	mutex_unlock(&one->efr_lock);
-
-	uart_port_lock_irqsave(port, &flags);
-	sc16is7xx_ier_set(port, SC16IS7XX_IER_THRI_BIT);
-	uart_port_unlock_irqrestore(port, flags);
 }
 
 static void sc16is7xx_reconf_rs485(struct uart_port *port)
-- 
2.43.0



