Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018B446B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3FEC433F0;
	Mon, 16 Jan 2023 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886140;
	bh=oirjHvUm/24DGQLv4pPofWFz6LgNO1j6+Bh8e6KtH1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZt/dzXapxVP/zuKqHNWjH7/MVDtCQyZXwuBEH0nOdlqNYrAGmU6P2Nkql4+dhkab
	 wle9U4MeeHCbvfa1XW/LFUppqkfTRtrnwV8SgVBYFwIFYhC456t4yCwbbKQeec8ksv
	 v1fYg17krDKosIkWiq4FJlO037u9IgTLBQ3ZN4Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Klauser <tklauser@distanz.ch>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/658] tty: serial: clean up stop-tx part in altera_uart_tx_chars()
Date: Mon, 16 Jan 2023 16:46:16 +0100
Message-Id: <20230116154922.767465666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit d9c128117da41cf4cb0e80ae565b5d3ac79dffac ]

The "stop TX" path in altera_uart_tx_chars() is open-coded, so:
* use uart_circ_empty() to check if the buffer is empty, and
* when true, call altera_uart_stop_tx().

Cc: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220920052049.20507-3-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1307c5d33cce ("serial: altera_uart: fix locking in polling mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/altera_uart.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 0e487ce091ac..508a3c2b7781 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -274,10 +274,8 @@ static void altera_uart_tx_chars(struct altera_uart *pp)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (xmit->head == xmit->tail) {
-		pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
-		altera_uart_update_ctrl_reg(pp);
-	}
+	if (uart_circ_empty(xmit))
+		altera_uart_stop_tx(port);
 }
 
 static irqreturn_t altera_uart_interrupt(int irq, void *data)
-- 
2.35.1



