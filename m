Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C29320F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84177C433C8;
	Fri, 21 Jul 2023 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966425;
	bh=9xEA2+1sLF3saUGU6GKbySom5Po4Ui6wwq8iUnxf5pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbSxepEUUWHdlj+Upe8o29Ev1EeeLEl2cviaIP5wRaANhIVMyb0nwM30zVduzHK7i
	 4yfBQBAVocfABT4rfdNgmn4edr48lgNEV/cJa/pujC6Zez9SujhTzFzhCTNm1CpMo1
	 8rSXrRESoBPDEoMVrlEQyeujwZddWpBUx7MPsR80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/532] i2c: xiic: Defer xiic_wakeup() and __xiic_start_xfer() in xiic_process()
Date: Fri, 21 Jul 2023 18:04:03 +0200
Message-ID: <20230721160632.808779295@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 743e227a895923c37a333eb2ebf3e391f00c406d ]

The __xiic_start_xfer() manipulates the interrupt flags, xiic_wakeup()
may result in return from xiic_xfer() early. Defer both to the end of
the xiic_process() interrupt thread, so that they are executed after
all the other interrupt bits handling completed and once it completely
safe to perform changes to the interrupt bits in the hardware.

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: cb6e45c9a0ad ("i2c: xiic: Don't try to handle more interrupt events after error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 37 ++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 34b8da949462a..14926b193e0ee 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -375,6 +375,9 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 	struct xiic_i2c *i2c = dev_id;
 	u32 pend, isr, ier;
 	u32 clr = 0;
+	int xfer_more = 0;
+	int wakeup_req = 0;
+	int wakeup_code = 0;
 
 	/* Get the interrupt Status from the IPIF. There is no clearing of
 	 * interrupts in the IPIF. Interrupts must be cleared at the source.
@@ -411,10 +414,14 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 		 */
 		xiic_reinit(i2c);
 
-		if (i2c->rx_msg)
-			xiic_wakeup(i2c, STATE_ERROR);
-		if (i2c->tx_msg)
-			xiic_wakeup(i2c, STATE_ERROR);
+		if (i2c->rx_msg) {
+			wakeup_req = 1;
+			wakeup_code = STATE_ERROR;
+		}
+		if (i2c->tx_msg) {
+			wakeup_req = 1;
+			wakeup_code = STATE_ERROR;
+		}
 	}
 	if (pend & XIIC_INTR_RX_FULL_MASK) {
 		/* Receive register/FIFO is full */
@@ -448,8 +455,7 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 				i2c->tx_msg++;
 				dev_dbg(i2c->adap.dev.parent,
 					"%s will start next...\n", __func__);
-
-				__xiic_start_xfer(i2c);
+				xfer_more = 1;
 			}
 		}
 	}
@@ -463,11 +469,13 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 		if (!i2c->tx_msg)
 			goto out;
 
-		if ((i2c->nmsgs == 1) && !i2c->rx_msg &&
-			xiic_tx_space(i2c) == 0)
-			xiic_wakeup(i2c, STATE_DONE);
+		wakeup_req = 1;
+
+		if (i2c->nmsgs == 1 && !i2c->rx_msg &&
+		    xiic_tx_space(i2c) == 0)
+			wakeup_code = STATE_DONE;
 		else
-			xiic_wakeup(i2c, STATE_ERROR);
+			wakeup_code = STATE_ERROR;
 	}
 	if (pend & (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK)) {
 		/* Transmit register/FIFO is empty or ½ empty */
@@ -491,7 +499,7 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 			if (i2c->nmsgs > 1) {
 				i2c->nmsgs--;
 				i2c->tx_msg++;
-				__xiic_start_xfer(i2c);
+				xfer_more = 1;
 			} else {
 				xiic_irq_dis(i2c, XIIC_INTR_TX_HALF_MASK);
 
@@ -509,6 +517,13 @@ static irqreturn_t xiic_process(int irq, void *dev_id)
 	dev_dbg(i2c->adap.dev.parent, "%s clr: 0x%x\n", __func__, clr);
 
 	xiic_setreg32(i2c, XIIC_IISR_OFFSET, clr);
+	if (xfer_more)
+		__xiic_start_xfer(i2c);
+	if (wakeup_req)
+		xiic_wakeup(i2c, wakeup_code);
+
+	WARN_ON(xfer_more && wakeup_req);
+
 	mutex_unlock(&i2c->lock);
 	return IRQ_HANDLED;
 }
-- 
2.39.2



