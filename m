Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15D711703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDD2C433CD;
	Mon, 21 Aug 2023 19:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647759;
	bh=jMn72kzjxq1D6Cq/XHrzziOx8T9Q77W37e/eSYvXVOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iskL1yxiF389R2PGC7r0W1d4A+uIKrc38sEpLhQHMwS/YLOlnkV7uT6d4Mxzl3E1D
	 TfXsCZn3omEoDt8DrBF+B9KqpRnqnOuwnZkzTH8jy3Jk1j8TpHDftCSW6/Gd62y4Hh
	 8YKkFKoczzFLQIwch1RnxwrMKiObzk3wbzrxj3lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 6.1 099/194] tty: serial: fsl_lpuart: Clear the error flags by writing 1 for lpuart32 platforms
Date: Mon, 21 Aug 2023 21:41:18 +0200
Message-ID: <20230821194127.040189270@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit 282069845af388b08d622ad192b831dcd0549c62 upstream.

Do not read the data register to clear the error flags for lpuart32
platforms, the additional read may cause the receive FIFO underflow
since the DMA has already read the data register.
Actually all lpuart32 platforms support write 1 to clear those error
bits, let's use this method to better clear the error flags.

Fixes: 42b68768e51b ("serial: fsl_lpuart: DMA support for 32-bit variant")
Cc: stable <stable@kernel.org>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230801022304.24251-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/fsl_lpuart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1125,8 +1125,8 @@ static void lpuart_copy_rx_to_tty(struct
 		unsigned long sr = lpuart32_read(&sport->port, UARTSTAT);
 
 		if (sr & (UARTSTAT_PE | UARTSTAT_FE)) {
-			/* Read DR to clear the error flags */
-			lpuart32_read(&sport->port, UARTDATA);
+			/* Clear the error flags */
+			lpuart32_write(&sport->port, sr, UARTSTAT);
 
 			if (sr & UARTSTAT_PE)
 				sport->port.icount.parity++;


