Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C15268C66;
	Tue,  8 Apr 2025 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112053; cv=none; b=fBhL3NZXdTdVSLAvoUJcbE5y17CQycw6tyyCK4BFX7iKU1E01Kx2s6dSg8daPYZJ5WlC3M8SGnLJPLiob7WMxgEkn9/DhEQ7NUmmIkwQk/jLUtZAstZ3aArQ3cqeM+z6sr6tNm90lOLZGi2YG2Q4pqZHQJYbc1Z4oEOJ2UQM8fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112053; c=relaxed/simple;
	bh=w2jKuiTQR2FBMNVzNNC8eRP0F0J1XLQ0wBwD82w1WkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Opa/BSI1FFjI6EIegXJKKOFXVHWpFtGGuwChu+l+RkmhL6hOU+WDjmcWy9IaOELf/CyCGbw34d+wAiY1+nDTigoe6bBg7rRRluBKmjRe09HVhgeAKcjUviIp/5q4RKl33NYq2uKyP77X/BYUoRI0FHj+u/UsYjbLJ57uNNS6TLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h42PamHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h42PamHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60063C4CEE5;
	Tue,  8 Apr 2025 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112053;
	bh=w2jKuiTQR2FBMNVzNNC8eRP0F0J1XLQ0wBwD82w1WkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h42PamHafAsAWR9G++6OytUbp8ibEmj8s2BqIr8NQpVyAkBxqZCMH/YZvtM9FhoPB
	 Axm5+9xiXAPkeAwNP5bLDnUiPibVe2La9FqseDrj4P0Pg086AiytrJQaXIYju7NdbA
	 EFqMf6G7duaDfwMaC9rUd8xeNxbF4oPAFF6+WJAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 658/731] tty: serial: lpuart: only disable CTS instead of overwriting the whole UARTMODIR register
Date: Tue,  8 Apr 2025 12:49:15 +0200
Message-ID: <20250408104929.572976049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit e98ab45ec5182605d2e00114cba3bbf46b0ea27f ]

No need to overwrite the whole UARTMODIR register before waiting the
transmit engine complete, actually our target here is only to disable
CTS flow control to avoid the dirty data in TX FIFO may block the
transmit engine complete.
Also delete the following duplicate CTS disable configuration.

Fixes: d5a2e0834364 ("tty: serial: lpuart: disable flow control while waiting for the transmit engine to complete")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20250307065446.1122482-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index f26162d98db62..9fdb66f2fcb81 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2346,15 +2346,19 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
+	/*
+	 * disable CTS to ensure the transmit engine is not blocked by the flow
+	 * control when there is dirty data in TX FIFO
+	 */
+	lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+
 	/*
 	 * LPUART Transmission Complete Flag may never be set while queuing a break
 	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
 	 * asserted.
 	 */
-	if (!(old_ctrl & UARTCTRL_SBK)) {
-		lpuart32_write(port, 0, UARTMODIR);
+	if (!(old_ctrl & UARTCTRL_SBK))
 		lpuart32_wait_bit_set(port, UARTSTAT, UARTSTAT_TC);
-	}
 
 	/* disable transmit and receive */
 	lpuart32_write(port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),
@@ -2362,8 +2366,6 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	lpuart32_write(port, bd, UARTBAUD);
 	lpuart32_serial_setbrg(sport, baud);
-	/* disable CTS before enabling UARTCTRL_TE to avoid pending idle preamble */
-	lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
 	/* restore control register */
 	lpuart32_write(port, ctrl, UARTCTRL);
 	/* re-enable the CTS if needed */
-- 
2.39.5



