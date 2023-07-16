Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C655E8F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3AAC433CB;
	Sun, 16 Jul 2023 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538929;
	bh=rdIWD7r6DZi3hViVn9p/ycnfYlJvYh0/PwLuC+iNWEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOv4Gj+IJaTzQfwDLtvxbQw5jRG6pG/0Bax3EFbfUqJsxL9LB4UVFBoYmhllJoAkR
	 UFTMBLhTolmOjUDp2fQyrg+7Wa6XF6bTwoQFfHucqvjLTJppaipR2pTO2FAa0swcLq
	 KR/kwdmsQl/l64brLjd4y1kQKG3+1o7pQDG9r4ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 597/800] serial: core: lock port for start_rx() in uart_resume_port()
Date: Sun, 16 Jul 2023 21:47:30 +0200
Message-ID: <20230716195002.969685517@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 51e45fba14bf08b66bca764a083c7f2e2ff62f01 ]

The only user of the start_rx() callback (qcom_geni) directly calls
its own stop_rx() callback. Since stop_rx() requires that the
port->lock is taken and interrupts are disabled, the start_rx()
callback has the same requirement.

Fixes: cfab87c2c271 ("serial: core: Introduce callback for start_rx and do stop_rx in suspend only if this callback implementation is present.")
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230525093159.223817-5-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a664778492c46..ea4a70055ad9f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2430,8 +2430,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 		if (console_suspend_enabled)
 			uart_change_pm(state, UART_PM_STATE_ON);
 		uport->ops->set_termios(uport, &termios, NULL);
-		if (!console_suspend_enabled && uport->ops->start_rx)
+		if (!console_suspend_enabled && uport->ops->start_rx) {
+			spin_lock_irq(&uport->lock);
 			uport->ops->start_rx(uport);
+			spin_unlock_irq(&uport->lock);
+		}
 		if (console_suspend_enabled)
 			console_start(uport->cons);
 	}
-- 
2.39.2



