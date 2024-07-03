Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA2F157E62;
	Wed,  3 Jul 2024 11:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004407; cv=none; b=skRxfSUQe2BM675XLBy/O+z5Bc31s6xpq3O/+oSxCkIkTbsiyQIoxaEkTLuSPyzq6gTzXVLoytCeIab6Vyi2jdom1Wdip7qe9BOsLc5ElWl9vXBXZCPleYPyOBL09OEkQ8nkByd3ZgRkIkr2hJMDpSqwVC2apDX3V95UvxF0ydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004407; c=relaxed/simple;
	bh=Ob+aW11RWUG2KPFp8Sm0mCA4Eh5766YjPDlbW7arATE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6s0Z4QmOJMiJTOiOfGSN+eZHgR+dt3k0gQ7BZ7BnvRa/Fp2rpeVYUPMx94+kihS6dmIMG6I4ck8n6zxaj4m+J03J1/+PPOFtZkKHNx4qKV7pSsC5cONJxinEmqDJYeykP03x/QJvEqM97BvVtOO8wc2UtZNQz/IxQT9D7tZGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvby8KFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvby8KFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC55C2BD10;
	Wed,  3 Jul 2024 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004406;
	bh=Ob+aW11RWUG2KPFp8Sm0mCA4Eh5766YjPDlbW7arATE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvby8KFrk00X5n7sD/po9X5PvyxXvBvoFvjUomzxAvUv1Ykzegy1NkvbhXVy1h1nz
	 crOkBIAMMsfYXvYYE+nFHJNe2OAywk+puIXg7rIrzIGVXoYk+ddYNkptbBaLRcBPyM
	 sXKbTKoz41T0XHbJn43yW1Phsa7BYl0igwQbFr48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/290] serial: sc16is7xx: fix bug in sc16is7xx_set_baud() when using prescaler
Date: Wed,  3 Jul 2024 12:36:53 +0200
Message-ID: <20240703102905.411581649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 88b84d43c2d62..4ea52426acf9e 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -490,16 +490,28 @@ static bool sc16is7xx_regmap_noinc(struct device *dev, unsigned int reg)
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
@@ -534,9 +546,10 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 
 	mutex_unlock(&s->efr_lock);
 
+	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,
-			      prescaler);
+			      prescaler == 1 ? 0 : SC16IS7XX_MCR_CLKSEL_BIT);
 
 	/* Open the LCR divisors for configuration */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG,
@@ -551,7 +564,7 @@ static int sc16is7xx_set_baud(struct uart_port *port, int baud)
 	/* Put LCR back to the normal mode */
 	sc16is7xx_port_write(port, SC16IS7XX_LCR_REG, lcr);
 
-	return DIV_ROUND_CLOSEST(clk / 16, div);
+	return DIV_ROUND_CLOSEST((clk / prescaler) / 16, div);
 }
 
 static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
-- 
2.43.0



