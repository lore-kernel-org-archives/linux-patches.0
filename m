Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED931494C4;
	Thu, 11 Apr 2024 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831797; cv=none; b=QC0eJawkg5MFtH63JncASkSvBSY2v9mZPzVJvJX6WDfj+gTYbnFHKcN3/PWyie6Z2sv/VMAlH7LEVNuOx2TxAxItYmDuqduTsUAXobxdFlh8wS4qBvAlbHiB/ToL62L4jOerPw4mj0Xn2TsGX31MrkQriFj67nt5xR3l24hwgRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831797; c=relaxed/simple;
	bh=lfsH0OKIQszrkYfhymMXaP4jCi6OlgPpLK15jo6xK4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajTNBUs30x9Og2Fo15RNsZm9Lw0PuMxzOIvpQKtMxOHCxoZZ9dpJCKD5FQy9odLE+jL4aDGDz1JygOjc3vanWax3Ab/YDQ3S6V3jHXi9ctRuM+sueVX14P1luov9Bnr5aJRytfaAzhsSpwI09dhHmd1JjzThfvJiLfAsI7Btfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEgm9GZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEgm9GZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8882C433F1;
	Thu, 11 Apr 2024 10:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831797;
	bh=lfsH0OKIQszrkYfhymMXaP4jCi6OlgPpLK15jo6xK4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEgm9GZcIK5zUsmD5mB1EVVH4l19hIjBYnZaf4J0VQ0SatTfi29md3tCw6GSDMMzO
	 oCzvEg2d9iNhfVptU2O3ddCaYtRDiBaMLNZSH6kDODcKte+0Bm/dsx3Q7zX5R4EvEY
	 jTjkAEeKA3Ob+1LDKFwFy/ONTNpxz1hyQL4F+cp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>
Subject: [PATCH 5.10 129/294] tty: serial: fsl_lpuart: avoid idle preamble pending if CTS is enabled
Date: Thu, 11 Apr 2024 11:54:52 +0200
Message-ID: <20240411095439.545733675@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Sun <sherry.sun@nxp.com>

commit 74cb7e0355fae9641f825afa389d3fba3b617714 upstream.

If the remote uart device is not connected or not enabled after booting
up, the CTS line is high by default. At this time, if we enable the flow
control when opening the device(for example, using “stty -F /dev/ttyLP4
crtscts” command), there will be a pending idle preamble(first writing 0
and then writing 1 to UARTCTRL_TE will queue an idle preamble) that
cannot be sent out, resulting in the uart port fail to close(waiting for
TX empty), so the user space stty will have to wait for a long time or
forever.

This is an LPUART IP bug(idle preamble has higher priority than CTS),
here add a workaround patch to enable TX CTS after enabling UARTCTRL_TE,
so that the idle preamble does not get stuck due to CTS is deasserted.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Reviewed-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20240305015706.1050769-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2178,9 +2178,12 @@ lpuart32_set_termios(struct uart_port *p
 		       UARTCTRL);
 
 	lpuart32_serial_setbrg(sport, baud);
-	lpuart32_write(&sport->port, modem, UARTMODIR);
-	lpuart32_write(&sport->port, ctrl, UARTCTRL);
+	/* disable CTS before enabling UARTCTRL_TE to avoid pending idle preamble */
+	lpuart32_write(&sport->port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
 	/* restore control register */
+	lpuart32_write(&sport->port, ctrl, UARTCTRL);
+	/* re-enable the CTS if needed */
+	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	if (old && sport->lpuart_dma_rx_use) {
 		if (!lpuart_start_rx_dma(sport))


