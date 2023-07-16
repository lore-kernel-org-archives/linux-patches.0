Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4388F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1205BC433C8;
	Sun, 16 Jul 2023 20:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540585;
	bh=EPUugNGEoOEiXbf6hyw8+Co6lhlIrE+LZVv9fovfVMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYnSMD4q5gdjeqfPuIsxy3qbpIo1oKXLG6kqphH8RSrYHM2LffLDQaAzpSlUcYHK8
	 LPawjg/L8fsT8WrA49rX+EIBTchMb6M2nCzx9cIS75jGnajWeiwmnv46boS2lTLFW0
	 rLv4PRPaMuI6y2HylmBEVCkaepPn9Qgl8zHdnZic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/591] serial: core: lock port for stop_rx() in uart_suspend_port()
Date: Sun, 16 Jul 2023 21:49:15 +0200
Message-ID: <20230716194934.678544746@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit abcb0cf1f5b2d99b1d117a4dbce334120e358d6d ]

The uarts_ops stop_rx() callback expects that the port->lock is
taken and interrupts are disabled.

Fixes: c9d2325cdb92 ("serial: core: Do stop_rx in suspend path for console if console_suspend is disabled")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230525093159.223817-3-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 23a7ab0de4445..b0a4677172062 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2334,8 +2334,11 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 	 * able to Re-start_rx later.
 	 */
 	if (!console_suspend_enabled && uart_console(uport)) {
-		if (uport->ops->start_rx)
+		if (uport->ops->start_rx) {
+			spin_lock_irq(&uport->lock);
 			uport->ops->stop_rx(uport);
+			spin_unlock_irq(&uport->lock);
+		}
 		goto unlock;
 	}
 
-- 
2.39.2



