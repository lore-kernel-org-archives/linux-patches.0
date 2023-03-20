Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926941C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BAC433EF;
	Mon, 20 Mar 2023 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324519;
	bh=1k1qFmyMCbgQrEl94A+jDTN2z9kUYp5EEEk7GzkB8yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uS9RVo0hrGZe3fHqc+DbTIUJseT9yLsCOBLRrlxbYHQFm8r2Yhjdeo9tvVmgl60kw
	 ADsZwuNIYDwkGfdoM2c9a/nk+xjJ5F8z98kHUKKZNNGYNstlSTFQnZJOfpq9CMqXap
	 fcKbcQrgZa6gifzlA+vqbpwO5ELLXCmiERYsRgew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 45/60] tty: serial: fsl_lpuart: skip waiting for transmission complete when UARTCTRL_SBK is asserted
Date: Mon, 20 Mar 2023 15:54:54 +0100
Message-Id: <20230320145432.785244884@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sherry Sun <sherry.sun@nxp.com>

commit 2411fd94ceaa6e11326e95d6ebf876cbfed28d23 upstream.

According to LPUART RM, Transmission Complete Flag becomes 0 if queuing
a break character by writing 1 to CTRL[SBK], so here need to skip
waiting for transmission complete when UARTCTRL_SBK is asserted,
otherwise the kernel may stuck here.
And actually set_termios() adds transmission completion waiting to avoid
data loss or data breakage when changing the baud rate, but we don't
need to worry about this when queuing break characters.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230223093941.31790-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2002,9 +2002,15 @@ lpuart32_set_termios(struct uart_port *p
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* wait transmit engin complete */
-	lpuart32_write(&sport->port, 0, UARTMODIR);
-	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
+	 * asserted.
+	 */
+	if (!(old_ctrl & UARTCTRL_SBK)) {
+		lpuart32_write(&sport->port, 0, UARTMODIR);
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	}
 
 	/* disable transmit and receive */
 	lpuart32_write(&sport->port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),


