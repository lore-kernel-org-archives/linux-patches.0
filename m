Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D3BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A83C433D2;
	Tue,  7 Mar 2023 19:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215604;
	bh=Qz3Tbn1fXcqseNvnHpqoT7rdbsO/cRgHmJBIKVQI4Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtoHRq0bJsHUrL9Xx2KBVh6Z+Pp09rtDepgj2YCHggIENH4si61EkWUi8Q3WwiyHS
	 wR1lTl/VgxZi2caJhWpSbBELFwefGtXW/4QhC47SqPi/WR6nW3Ep1OSoJFIO4/eTbG
	 g8MlgqJ9aVnRg+nHb/YJxxv3rlCrnjxhFN32fNEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/567] tty: serial: fsl_lpuart: Fix the wrong RXWATER setting for rx dma case
Date: Tue,  7 Mar 2023 18:00:51 +0100
Message-Id: <20230307165919.518610731@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit 9ad9df8447547febe9dd09b040f4528a09e495f0 ]

The RXWATER value must be greater than 0 according to the LPUART
reference manual. And when the number of datawords in the receive
FIFO is greater than RXWATER, an interrupt or a DMA request is
generated, so no need to set the different value for lpuart interrupt
case and dma case. Here delete the wrong RXWATER setting for dma case
directly.

Fixes: 42b68768e51b ("serial: fsl_lpuart: DMA support for 32-bit variant")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20230130064449.9564-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ccfd6dd5fbf4e..08096d33af8a6 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1700,12 +1700,6 @@ static void lpuart32_configure(struct lpuart_port *sport)
 {
 	unsigned long temp;
 
-	if (sport->lpuart_dma_rx_use) {
-		/* RXWATER must be 0 */
-		temp = lpuart32_read(&sport->port, UARTWATER);
-		temp &= ~(UARTWATER_WATER_MASK << UARTWATER_RXWATER_OFF);
-		lpuart32_write(&sport->port, temp, UARTWATER);
-	}
 	temp = lpuart32_read(&sport->port, UARTCTRL);
 	if (!sport->lpuart_dma_rx_use)
 		temp |= UARTCTRL_RIE;
-- 
2.39.2



