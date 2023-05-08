Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D98168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22FEC433D2;
	Mon,  8 May 2023 11:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544962;
	bh=2Sp0pLDeFJKodZZ4XHcd/TfSQpY0eSLzKb4Sa3up8T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8P9eTz+vvdDvqjAc8BEkZ6T2toBJ3/xMGCJJNGJTNFHCTsr6HdPe5p7EzVLTCyfO
	 vtDHUnwyYvF/MloEGCWuSKzlTaCbRQDK7FsE5m8UMKMN4u8Eg1TMhnf2K2ZgFskx3f
	 733SywGnBDjw5EUb80MsHrXnP6s+M/QkG7p/tgzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 549/694] serial: 8250: Add missing wakeup event reporting
Date: Mon,  8 May 2023 11:46:24 +0200
Message-Id: <20230508094452.362303718@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 0ba9e3a13c6adfa99e32b2576d20820ab10ad48a ]

An 8250 UART configured as a wake-up source would not have reported
itself through sysfs as being the source of wake-up, correct that.

Fixes: b3b708fa2780 ("wake up from a serial port")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230414170241.2016255-1-f.fainelli@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index dfbc501cf9d15..fe8d79c4ae95e 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -15,6 +15,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
+#include <linux/irq.h>
 #include <linux/console.h>
 #include <linux/gpio/consumer.h>
 #include <linux/sysrq.h>
@@ -1932,6 +1933,7 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
+	struct tty_port *tport = &port->state->port;
 	bool skip_rx = false;
 	unsigned long flags;
 	u16 status;
@@ -1957,6 +1959,8 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 		skip_rx = true;
 
 	if (status & (UART_LSR_DR | UART_LSR_BI) && !skip_rx) {
+		if (irqd_is_wakeup_set(irq_get_irq_data(port->irq)))
+			pm_wakeup_event(tport->tty->dev, 0);
 		if (!up->dma || handle_rx_dma(up, iir))
 			status = serial8250_rx_chars(up, status);
 	}
-- 
2.39.2



