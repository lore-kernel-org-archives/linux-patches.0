Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196DD53365;
	Thu, 12 Dec 2024 16:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020860; cv=none; b=Y36UKy6bCZI9pGt66yEPnawo5lIj0C7sEsCUQvyjNQxxVByEWi63bKbsOuDwGuq44xx8ikNAc8q6kCXU5MDpHp9wjHdyUI4e1c2Zu4UjbqITdYSBHLoCckp2XiIBBOF+ccJ5RYOFdWbLqSK1qQTqRaOi0NYuXLUjlTaMm0mjHDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020860; c=relaxed/simple;
	bh=tZ4ec7X4Ay4omzzCS3Vhs1VhkQKnsWbiUpoQVcBlfD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgmZEUnO7h/e/CWsUTltwqevU/F8wJn3iYyjtnHLrmEa+7/5KBqqvLoX6XcuvSoIj9eqju3wg6SLwCRXgSsJZUA9A75ATO/pmXXirD14H7tlNldMl8KMhUrC1vsE5MjF7y2zRgTB8F3cY9lpUK13Xvisr2wvibFSjXNyHU7zIuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxtSG7pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxtSG7pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C84C4CED3;
	Thu, 12 Dec 2024 16:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020859;
	bh=tZ4ec7X4Ay4omzzCS3Vhs1VhkQKnsWbiUpoQVcBlfD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxtSG7pUK9/SSaphrxsRS55GmFT5n8rZz6GVCVOLWGvHEzG2TnmMbAkzpvRRqnXAF
	 2BTwxqv590gnhvmUa8qJ7F6Jo9eIoREU9uNHbOMyHY0ZfGJzX0MPhY8qBnQB7pcnqx
	 rTb0+xbXcB+WV7gtmLo/yGOYj4Y+3YjOyIFgLtyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 552/772] serial: amba-pl011: Fix RX stall when DMA is used
Date: Thu, 12 Dec 2024 15:58:17 +0100
Message-ID: <20241212144412.768385056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

[ Upstream commit 2bcacc1c87acf9a8ebc17de18cb2b3cfeca547cf ]

Function pl011_throttle_rx() calls pl011_stop_rx() to disable RX, which
also disables the RX DMA by clearing the RXDMAE bit of the DMACR
register. However, to properly unthrottle RX when DMA is used, the
function pl011_unthrottle_rx() is expected to set the RXDMAE bit of
the DMACR register, which it currently lacks. This causes RX to stall
after the throttle API is called.

Set RXDMAE bit in the DMACR register while unthrottling RX if RX DMA is
used.

Fixes: 211565b10099 ("serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241113092629.60226-1-kkartik@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl011.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index c95351d24f363..3eb7185994134 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1837,6 +1837,11 @@ static void pl011_unthrottle_rx(struct uart_port *port)
 
 	pl011_write(uap->im, uap, REG_IMSC);
 
+	if (uap->using_rx_dma) {
+		uap->dmacr |= UART011_RXDMAE;
+		pl011_write(uap->dmacr, uap, REG_DMACR);
+	}
+
 	uart_port_unlock_irqrestore(&uap->port, flags);
 }
 
-- 
2.43.0



