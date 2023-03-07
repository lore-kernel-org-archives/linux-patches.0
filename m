Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D24FBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A025C433D2;
	Tue,  7 Mar 2023 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213199;
	bh=FrKyh+tjljhwezt9WqS6MhAMttatdxu2QHrUIYCY510=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss807cCPUvIbjwGOG+s3f6tKoqHKQ3VCeOkBsTdTctpW2j5wjEZEW3qkzSspITMgm
	 ucMGkHg7YnD5Jm4xK90YwqUzbiYZdgOTYxAYkNXoKr3dz/2xkmnlemu1h0ynPhnW+X
	 6D50U5idfNcRuTBYw+R9bddl8fOTm98TZd9QImSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 430/885] tty: serial: fsl_lpuart: clear LPUART Status Register in lpuart32_shutdown()
Date: Tue,  7 Mar 2023 17:56:04 +0100
Message-Id: <20230307170021.089547777@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 4029dfc034febb54f6dd8ea83568accc943bc088 ]

The LPUART Status Register needs to be cleared when closing the uart
port to get a clean environment when reopening the uart.

Fixes: 380c966c093e ("tty: serial: fsl_lpuart: add 32-bit register interface support")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20221125101953.18753-4-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 262b059e3ee11..110c8720af47a 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1791,6 +1791,10 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* clear status */
+	temp = lpuart32_read(&sport->port, UARTSTAT);
+	lpuart32_write(&sport->port, temp, UARTSTAT);
+
 	/* disable Rx/Tx DMA */
 	temp = lpuart32_read(port, UARTBAUD);
 	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
-- 
2.39.2



