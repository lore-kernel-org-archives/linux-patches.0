Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B5A38DE5;
	Mon,  1 Apr 2024 17:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991089; cv=none; b=aGecFlU56NalCJUwIRUIM8rNFvq82aNLvbgF8KDIWir4qEjWjjjouu25jeZ7RmzzNLWlFRK0tHXFw6iM6vGRYBoq6eokvvKDY7kN9eAfeOBqvNNPE+qu0hSdTuJFCOC9i+jCuUhspNWUxKdgyykwImYqVDZ8dAPYT/deXxvzyWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991089; c=relaxed/simple;
	bh=baZczth9mRZFnWqCfMes0BRjX3hT65DPe3hsxOmNd7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDhnlUxC7guxjHeEYNF7rDs7uNPnzNO38ogG+7h2ChTDuqrSh1J3x/NTYPeofdrNr1WLyK0hMqVE/Z66/dnRLhwl8rCv+HZEymihr7ZEY3ny6Lwy99pI14Nw/vNzONewoCLH6LxeYPd3p4c6TfPl9DCoO/Azgy/BUvhFbFQKjrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P+V4Y8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P+V4Y8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85959C43390;
	Mon,  1 Apr 2024 17:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991089;
	bh=baZczth9mRZFnWqCfMes0BRjX3hT65DPe3hsxOmNd7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0P+V4Y8w+/x8Du4TTx9/helkFt1KHWIgzo5AG+HF5lhZX9HazQ8+xcbUK5XitvJNT
	 SO/8nfk9RbT/7U1t52RiYGMN0I+I3quNbvUKTejw0GZCcdHhgjtyv8n9Y5nJ43uf5S
	 i9aTZzHn/KUwSl3RTJDpxMA46thkdgz1GOcD/rDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>
Subject: [PATCH 6.1 160/272] tty: serial: fsl_lpuart: avoid idle preamble pending if CTS is enabled
Date: Mon,  1 Apr 2024 17:45:50 +0200
Message-ID: <20240401152535.731323986@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2213,9 +2213,12 @@ lpuart32_set_termios(struct uart_port *p
 
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


