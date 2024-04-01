Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF5440876;
	Mon,  1 Apr 2024 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990030; cv=none; b=O1vVVp3zAcRp+JRwGK7rfQ25XQOSCZ5CSsU0+qqq4cujt8c8Oh9d/hSgyYPnAPKtTDR+OFU+z6sQGlZo0bQxTUJQG3GZjL38obCchHaG10vCJ4cFIM75+GeLR5NWd37OIqP5kQiN0WjjIsPKJLcE1Vj5yqrqrKe9Y4uz8MoQI34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990030; c=relaxed/simple;
	bh=ApU9Y2W4M0hdbw7TIMcl4OHlD6Dq5DOo5Uu/O0C9A1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXPNc+6GloCrd5KKWH0m6Xh6sqa1uUoD35jOn6LXkNOtBbzLWMbXxUemYgG48I7G9N8PS4qkJEjsay2AIdWgAOzbuCwfivHj5nb3etLjulMkmdZ3P5FTfwepvpRqE0CT7vkJlqW/5Xtn6NxQhvWFgVea3Ron592xFqMDyuUGyok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+VuTsKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+VuTsKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D25C433C7;
	Mon,  1 Apr 2024 16:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990030;
	bh=ApU9Y2W4M0hdbw7TIMcl4OHlD6Dq5DOo5Uu/O0C9A1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+VuTsKXFHPAberhaKNmXIAWNVzp7v6PNhuFxJKNf/Yi06QW4Q1F68yPt0hDqANPC
	 VjUouaSCidD46UHuEuhhr4qrHNFNOoO0FUoeKjEN6ozM9ydpCPfwlLOfzCV2mBfzP6
	 K3o8vPf+k9gc5ox0E+ZPGtv7ISwx7Kl2qw/2U14M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>
Subject: [PATCH 6.6 226/396] tty: serial: fsl_lpuart: avoid idle preamble pending if CTS is enabled
Date: Mon,  1 Apr 2024 17:44:35 +0200
Message-ID: <20240401152554.658289799@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2345,9 +2345,12 @@ lpuart32_set_termios(struct uart_port *p
 
 	lpuart32_write(&sport->port, bd, UARTBAUD);
 	lpuart32_serial_setbrg(sport, baud);
-	lpuart32_write(&sport->port, modem, UARTMODIR);
-	lpuart32_write(&sport->port, ctrl, UARTCTRL);
+	/* disable CTS before enabling UARTCTRL_TE to avoid pending idle preamble */
+	lpuart32_write(&sport->port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
 	/* restore control register */
+	lpuart32_write(&sport->port, ctrl, UARTCTRL);
+	/* re-enable the CTS if needed */
+	lpuart32_write(&sport->port, modem, UARTMODIR);
 
 	if ((ctrl & (UARTCTRL_PE | UARTCTRL_M)) == UARTCTRL_PE)
 		sport->is_cs7 = true;


