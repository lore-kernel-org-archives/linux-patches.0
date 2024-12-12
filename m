Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1163921765E;
	Thu, 12 Dec 2024 15:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017651; cv=none; b=d5RPOn7Ogi+ac0aTojfMRXRxNyqRveASNVznYA985fuONOTvAiJjT5Zk8+XlM+6ckO36pQRl0GFb9avPoYXzxob310houBnMOoRfE64cM+hJAZd7jmRbcFovKPoc60gVDpqOx/n/5Ryt2uiKSsCV3uKLNGZMHOL2rDb4lBBDtnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017651; c=relaxed/simple;
	bh=0EIzCWmAMei+HYe4zNCPlH1KH07UjIg8+IISAOfM5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqHfabfDd+wEYxW75QfwHHKBnm5AR9ybwUGduksYHIhBn2yY2NcWD4clp87YI+a/y0zJjCycTlabVIdOqwy8fCTsvWIuNDP8062c6Q8MA18gH4GVhbPwOo8HZu0QOh75DYlFKtnd50kyGwCVYugyl9zW2ZchHg5iT/gHpx1ZYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NSjJbIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NSjJbIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293F5C4CECE;
	Thu, 12 Dec 2024 15:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017650;
	bh=0EIzCWmAMei+HYe4zNCPlH1KH07UjIg8+IISAOfM5ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NSjJbIGyCpGVTV6xLP9is70pw6WcUnyHQzbBlLEqm75EU1ASpdEmBVLQ/D9Rx2jL
	 qrz27k3fKXID6c98Du9/WtuN5MF2MvrH2dim102HPzwYXJrXCwE9To7z7NiJxx2nVo
	 VADc0QnOwEviYgvY3MkRcjflQNj5TpHsO/g6iYA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/356] serial: amba-pl011: Fix RX stall when DMA is used
Date: Thu, 12 Dec 2024 15:56:32 +0100
Message-ID: <20241212144247.514807793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 16c7703110694..08f80188f73dd 100644
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



