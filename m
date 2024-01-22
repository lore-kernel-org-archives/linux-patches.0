Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEE2134721;
	Tue, 23 Jan 2024 01:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971899; cv=none; b=TneMcWY94gKvOqt2Lzo/R7jTNUmhVq1KEeocrah6J9+wey50HpjMqced0PpBzK3D7H7IgVJbowItFEtfEUcsxptKyheFj15HFsfjfnRav5pDGcJ767zMKxlO2soGYiqjZa8cPWC5HT+pulLb3Bc1QhwT5lrmxeutqEOUG1V2cwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971899; c=relaxed/simple;
	bh=sYe+bmP46EovBsZpVFw1V1qxYPna20oxUlc0BlsQsXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqp73uU9KIFgXxswq46N/1J0TXSrcZR0ZDfmXTMsaSxMeRtVZvK/Crh4l8EoilK66Q/E1A/502kxNysw5a9G9UiO0dW5TnrG3uusFSf2OndRE1bWh/9OpATW0s8d9LA8aqseW5VPfjB50VJiDjDF5k8BDPTiOEf0SM2qd6WsLCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qD8fzLbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qD8fzLbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C66C433C7;
	Tue, 23 Jan 2024 01:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971899;
	bh=sYe+bmP46EovBsZpVFw1V1qxYPna20oxUlc0BlsQsXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qD8fzLbofs5UqMZw9U9Wy085xbaSHzCzEtgcVBlO/L6sHLyV3C1KUv7xO+cAu65Xa
	 c2Apra9WvvQEs2zmNpIKpJaoe8y2Fzma0STTDdFc6fibaVIGSRWBMgEaVEpTvZ+jXy
	 XOM3YLc1KdLpEODWBOTJywoHE7Os/1c+jqXlH5Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul_geurts@live.nl>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Eberhard Stoll <eberhard.stoll@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/417] serial: imx: fix tx statemachine deadlock
Date: Mon, 22 Jan 2024 15:58:33 -0800
Message-ID: <20240122235803.740766623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Paul Geurts <paul_geurts@live.nl>

[ Upstream commit 78d60dae9a0c9f09aa3d6477c94047df2fe6f7b0 ]

When using the serial port as RS485 port, the tx statemachine is used to
control the RTS pin to drive the RS485 transceiver TX_EN pin. When the
TTY port is closed in the middle of a transmission (for instance during
userland application crash), imx_uart_shutdown disables the interface
and disables the Transmission Complete interrupt. afer that,
imx_uart_stop_tx bails on an incomplete transmission, to be retriggered
by the TC interrupt. This interrupt is disabled and therefore the tx
statemachine never transitions out of SEND. The statemachine is in
deadlock now, and the TX_EN remains low, making the interface useless.

imx_uart_stop_tx now checks for incomplete transmission AND whether TC
interrupts are enabled before bailing to be retriggered. This makes sure
the state machine handling is reached, and is properly set to
WAIT_AFTER_SEND.

Fixes: cb1a60923609 ("serial: imx: implement rts delaying for rs485")
Signed-off-by: Paul Geurts <paul_geurts@live.nl>
Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Tested-by: Eberhard Stoll <eberhard.stoll@gmx.de>
Link: https://lore.kernel.org/r/AM0PR09MB26758F651BC1B742EB45775995B8A@AM0PR09MB2675.eurprd09.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 48c05fc1064e..c2cc104225ec 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -450,13 +450,13 @@ static void imx_uart_stop_tx(struct uart_port *port)
 	ucr1 = imx_uart_readl(sport, UCR1);
 	imx_uart_writel(sport, ucr1 & ~UCR1_TRDYEN, UCR1);
 
+	ucr4 = imx_uart_readl(sport, UCR4);
 	usr2 = imx_uart_readl(sport, USR2);
-	if (!(usr2 & USR2_TXDC)) {
+	if ((!(usr2 & USR2_TXDC)) && (ucr4 & UCR4_TCEN)) {
 		/* The shifter is still busy, so retry once TC triggers */
 		return;
 	}
 
-	ucr4 = imx_uart_readl(sport, UCR4);
 	ucr4 &= ~UCR4_TCEN;
 	imx_uart_writel(sport, ucr4, UCR4);
 
-- 
2.43.0



