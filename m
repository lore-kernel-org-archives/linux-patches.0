Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30CB196D90;
	Thu,  6 Jun 2024 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683666; cv=none; b=pdFb5MUOITjfb2F3G/gY/71JMfHW8MajNOPA/B/NTPvgp9Xe/s3LZMPS2qdwtKHSavD4mJE4+KEUxawbr0lg+PeagcGgg6z0GPCEbjXTI70CGjCzTP3+MpbKALyt3z0adYIiziHHizBejeJPMi7LMMJUgDRdR+9TirsHzHpImpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683666; c=relaxed/simple;
	bh=aFCJsvBx7h44O8o0DTiLm9No6mJxIOWKZSgygFpRHAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEkbkc04OkyWgmspFaV7QIjYxZeSx6K3d/zuP6eL+EY1gRFAPPDapj5OiGpFw1pFFPTttb0jywL5BSb2sbNbBBcTRs4tRNorVGumFkL+u0HQHAR+XQ8iXyl37lqcmtdKC17mxrAgzH2RaT2LpBPawOlDVE8oWvUGDgveFzjeWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VoLC7/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VoLC7/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C79C2BD10;
	Thu,  6 Jun 2024 14:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683666;
	bh=aFCJsvBx7h44O8o0DTiLm9No6mJxIOWKZSgygFpRHAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VoLC7/7fo4ZPK49fuZV6Y87SHPwCPHCYaPhobmkz/m13S7sgwAlklOaX/b76tCEt
	 lUa24pqQcQFwPjtZgee50YaKvxmH/ETEepOgKN+QxFNkc+ZqodtWypKtgKgUsOv3ja
	 KUfQFWDM/WUG26JkuSYl/eUyDaqNO7GTFmnSdsVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 552/744] serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler
Date: Thu,  6 Jun 2024 16:03:44 +0200
Message-ID: <20240606131750.165433238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 8492bd91aa055907c67ef04f2b56f6dadd1f44bf ]

When using a high speed clock with a low baud rate, the 4x prescaler is
automatically selected if required. In that case, sc16is7xx_set_baud()
properly configures the chip registers, but returns an incorrect baud
rate by not taking into account the prescaler value. This incorrect baud
rate is then fed to uart_update_timeout().

For example, with an input clock of 80MHz, and a selected baud rate of 50,
sc16is7xx_set_baud() will return 200 instead of 50.

Fix this by first changing the prescaler variable to hold the selected
prescaler value instead of the MCR bitfield. Then properly take into
account the selected prescaler value in the return value computation.

Also add better documentation about the divisor value computation.

Fixes: dfeae619d781 ("serial: sc16is7xx")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20240430200431.4102923-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 26ab1f042f5b8..7a9924d9b294e 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -482,16 +482,28 @@ static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
 	return reg == SC16IS7XX_RHR_REG;
 }
 
+/*
+ * Configure programmable baud rate generator (divisor) according to the
+ * desired baud rate.
+ *
+ * From the datasheet, the divisor is computed according to:
+ *
+ *              XTAL1 input frequency
+ *             -----------------------
+ *                    prescaler
+ * divisor = ---------------------------
+ *            baud-rate x sampling-rate
+ */
 static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 {
 	struct sc16is7xx_one *one = to_sc16is7xx_one(port, port);
 	u8 lcr;
-	u8 prescaler = 0;
+	unsigned int prescaler = 1;
 	unsigned long clk = port->uartclk, div = clk / 16 / baud;
 
 	if (div >= BIT(16)) {
-		prescaler = SC16IS7XX_MCR_CLKSEL_BIT;
-		div /= 4;
+		prescaler = 4;
+		div /= prescaler;
 	}
 
 	/* In an amazing feat of design, the Enhanced Features Register shares
@@ -528,9 +540,10 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 
 	mutex_unlock(&one->efr_lock);
 
+	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,
-			      prescaler);
+			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
 	/* Open the LCR divisors for configuration */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
@@ -545,7 +558,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	return DIV_ROUND_CLOSEST(clk / 16, div);
+	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
 
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
-- 
2.43.0



