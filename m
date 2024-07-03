Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1080C1741C4;
	Wed,  3 Jul 2024 10:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003479; cv=none; b=j3ox6QKHZiInrma91N7FjCby6PXjuVSlrpK27TAsf7UlZ2/z9QnvTV9roitITwTyZLVZRh78ZL7PeLCwpBcdv0FTf/IG8FnslAqDZOVdxRLy2w2nmZ26uDXYTVtt0E+WzSDtDE0yFgwDSJP/ABnhQW1txscURSaAk1D9SIQKouc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003479; c=relaxed/simple;
	bh=lBxzU21X8YJHzmk/+ulnhgRnJywiKqxg/rYr8XQa6wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4t0XWLvjEcNzfUI81NDjdNYEr94K2XJTKPs1kbI1vBznv1x7c4e1zDT8+cAQh9pT3UixxWaItknM/NOEaqsr+0zEdWnwNhSRNN/SXYGotW9LaR8jkYC9+g9vWo/qD0ZeHZEXBSjr8XG8dCLMC4ANaQhiGmmFbwztmjhozxHhBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbixK8zM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbixK8zM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A18BC2BD10;
	Wed,  3 Jul 2024 10:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003478;
	bh=lBxzU21X8YJHzmk/+ulnhgRnJywiKqxg/rYr8XQa6wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbixK8zMnlHr3hBSAn6ZBtzJnoxnd6Xqq7gt1U+SSbBgxSau9uRhhdyiwQ4LSfwpN
	 GMPbIWEqwnvtUXGk/cNErQ7/DkiuChWqkWZuiBFXpcwdKofwabR3kAuiw4cOLfH66h
	 pN+Ox7b8G4LOgWss4jdbzq3+xPsWIlaoS8T6rlyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/139] serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler
Date: Wed,  3 Jul 2024 12:38:37 +0200
Message-ID: <20240703102831.203868955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a1331225cdc21..8e25e3e287535 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -489,16 +489,28 @@ static bool sc16is7xx_regmap_precious(struct device *dev, unsigned int reg)
 	return false;
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
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
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
@@ -533,9 +545,10 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 
 	mutex_unlock(&s->efr_lock);
 
+	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,
-			      prescaler);
+			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
 	/* Open the LCR divisors for configuration */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
@@ -550,7 +563,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	return DIV_ROUND_CLOSEST(clk / 16, div);
+	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
 
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
-- 
2.43.0



