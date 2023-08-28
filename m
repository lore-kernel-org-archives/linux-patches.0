Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A71C433C7;
	Mon, 28 Aug 2023 10:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219060;
	bh=m+BUAl6LhaYkuAodSCfmpT10dKFia7ztCb6jxH32Yzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLxH4qyTovvlbNhtEhlEGH/2kjZYpXk0se+lD6fMIYSgAGwWJNv7baws/X8LhwP0w
	 l4ecSDTMhzjkowzEbQJ3R5JlYCAB+fuuoW/L5qct+bAdh1cgPD4B9sE3+5kOcgTyPB
	 bwEO+488GSTi1HdJb1nCt6+n4pmMHHSRM4VRvb6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sherry Sun <sherry.sun@nxp.com>
Subject: [PATCH 5.4 058/158] tty: serial: fsl_lpuart: Clear the error flags by writing 1 for lpuart32 platforms
Date: Mon, 28 Aug 2023 12:12:35 +0200
Message-ID: <20230828101159.264700233@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
@@ -1023,8 +1023,8 @@ static void lpuart_copy_rx_to_tty(struct
 		unsigned long sr = lpuart32_read(&sport->port, UARTSTAT);
 
 		if (sr & (UARTSTAT_PE | UARTSTAT_FE)) {
-			/* Read DR to clear the error flags */
-			lpuart32_read(&sport->port, UARTDATA);
+			/* Clear the error flags */
+			lpuart32_write(&sport->port, sr, UARTSTAT);
 
 			if (sr & UARTSTAT_PE)
 				sport->port.icount.parity++;


