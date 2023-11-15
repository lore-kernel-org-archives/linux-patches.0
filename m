Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861B39FC0
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Meb9dBAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B85FC4E777;
	Wed, 15 Nov 2023 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081565;
	bh=e1uGKLlK7MRaKDybEHm2mPHp7NUwKe4Zi736g34i+jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Meb9dBAwhpHGq1X8Z6ZZoqEiz5praeWfW4P+e8JkVCgVJJueYUKrWSZ2MBNNg5i4n
	 6Dc6IRbHxh7K9RKDgh9I/KgS0URUU3fGf5RPxxKXRTYkJk2bX5ka7D9wQxx+Bx406o
	 ADFlsaiqfMmR7/vG7jxL/y99gJ9PWBhbFYO8wj+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Bacik <roman.bacik@broadcom.com>,
	Ray Jui <ray.jui@broadcom.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/244] i2c: iproc: handle invalid slave state
Date: Wed, 15 Nov 2023 15:37:04 -0500
Message-ID: <20231115203602.264550549@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Bacik <roman.bacik@broadcom.com>

[ Upstream commit ba15a14399c262f91ce30c19fcbdc952262dd1be ]

Add the code to handle an invalid state when both bits S_RX_EVENT
(indicating a transaction) and S_START_BUSY (indicating the end
of transaction - transition of START_BUSY from 1 to 0) are set in
the interrupt status register during a slave read.

Signed-off-by: Roman Bacik <roman.bacik@broadcom.com>
Fixes: 1ca1b4516088 ("i2c: iproc: handle Master aborted error")
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c | 133 ++++++++++++++++-------------
 1 file changed, 75 insertions(+), 58 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bcm-iproc.c b/drivers/i2c/busses/i2c-bcm-iproc.c
index ec6571b82fff4..299dbcd4c8292 100644
--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -326,26 +326,44 @@ static void bcm_iproc_i2c_slave_init(
 	iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
 }
 
-static void bcm_iproc_i2c_check_slave_status(
-	struct bcm_iproc_i2c_dev *iproc_i2c)
+static bool bcm_iproc_i2c_check_slave_status
+	(struct bcm_iproc_i2c_dev *iproc_i2c, u32 status)
 {
 	u32 val;
+	bool recover = false;
 
-	val = iproc_i2c_rd_reg(iproc_i2c, S_CMD_OFFSET);
-	/* status is valid only when START_BUSY is cleared after it was set */
-	if (val & BIT(S_CMD_START_BUSY_SHIFT))
-		return;
+	/* check slave transmit status only if slave is transmitting */
+	if (!iproc_i2c->slave_rx_only) {
+		val = iproc_i2c_rd_reg(iproc_i2c, S_CMD_OFFSET);
+		/* status is valid only when START_BUSY is cleared */
+		if (!(val & BIT(S_CMD_START_BUSY_SHIFT))) {
+			val = (val >> S_CMD_STATUS_SHIFT) & S_CMD_STATUS_MASK;
+			if (val == S_CMD_STATUS_TIMEOUT ||
+			    val == S_CMD_STATUS_MASTER_ABORT) {
+				dev_warn(iproc_i2c->device,
+					 (val == S_CMD_STATUS_TIMEOUT) ?
+					 "slave random stretch time timeout\n" :
+					 "Master aborted read transaction\n");
+				recover = true;
+			}
+		}
+	}
+
+	/* RX_EVENT is not valid when START_BUSY is set */
+	if ((status & BIT(IS_S_RX_EVENT_SHIFT)) &&
+	    (status & BIT(IS_S_START_BUSY_SHIFT))) {
+		dev_warn(iproc_i2c->device, "Slave aborted read transaction\n");
+		recover = true;
+	}
 
-	val = (val >> S_CMD_STATUS_SHIFT) & S_CMD_STATUS_MASK;
-	if (val == S_CMD_STATUS_TIMEOUT || val == S_CMD_STATUS_MASTER_ABORT) {
-		dev_err(iproc_i2c->device, (val == S_CMD_STATUS_TIMEOUT) ?
-			"slave random stretch time timeout\n" :
-			"Master aborted read transaction\n");
+	if (recover) {
 		/* re-initialize i2c for recovery */
 		bcm_iproc_i2c_enable_disable(iproc_i2c, false);
 		bcm_iproc_i2c_slave_init(iproc_i2c, true);
 		bcm_iproc_i2c_enable_disable(iproc_i2c, true);
 	}
+
+	return recover;
 }
 
 static void bcm_iproc_i2c_slave_read(struct bcm_iproc_i2c_dev *iproc_i2c)
@@ -430,48 +448,6 @@ static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
 	u32 val;
 	u8 value;
 
-	/*
-	 * Slave events in case of master-write, master-write-read and,
-	 * master-read
-	 *
-	 * Master-write     : only IS_S_RX_EVENT_SHIFT event
-	 * Master-write-read: both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
-	 *                    events
-	 * Master-read      : both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
-	 *                    events or only IS_S_RD_EVENT_SHIFT
-	 *
-	 * iproc has a slave rx fifo size of 64 bytes. Rx fifo full interrupt
-	 * (IS_S_RX_FIFO_FULL_SHIFT) will be generated when RX fifo becomes
-	 * full. This can happen if Master issues write requests of more than
-	 * 64 bytes.
-	 */
-	if (status & BIT(IS_S_RX_EVENT_SHIFT) ||
-	    status & BIT(IS_S_RD_EVENT_SHIFT) ||
-	    status & BIT(IS_S_RX_FIFO_FULL_SHIFT)) {
-		/* disable slave interrupts */
-		val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
-		val &= ~iproc_i2c->slave_int_mask;
-		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
-
-		if (status & BIT(IS_S_RD_EVENT_SHIFT))
-			/* Master-write-read request */
-			iproc_i2c->slave_rx_only = false;
-		else
-			/* Master-write request only */
-			iproc_i2c->slave_rx_only = true;
-
-		/* schedule tasklet to read data later */
-		tasklet_schedule(&iproc_i2c->slave_rx_tasklet);
-
-		/*
-		 * clear only IS_S_RX_EVENT_SHIFT and
-		 * IS_S_RX_FIFO_FULL_SHIFT interrupt.
-		 */
-		val = BIT(IS_S_RX_EVENT_SHIFT);
-		if (status & BIT(IS_S_RX_FIFO_FULL_SHIFT))
-			val |= BIT(IS_S_RX_FIFO_FULL_SHIFT);
-		iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET, val);
-	}
 
 	if (status & BIT(IS_S_TX_UNDERRUN_SHIFT)) {
 		iproc_i2c->tx_underrun++;
@@ -503,8 +479,9 @@ static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
 		 * less than PKT_LENGTH bytes were output on the SMBUS
 		 */
 		iproc_i2c->slave_int_mask &= ~BIT(IE_S_TX_UNDERRUN_SHIFT);
-		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET,
-				 iproc_i2c->slave_int_mask);
+		val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
+		val &= ~BIT(IE_S_TX_UNDERRUN_SHIFT);
+		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
 
 		/* End of SMBUS for Master Read */
 		val = BIT(S_TX_WR_STATUS_SHIFT);
@@ -525,9 +502,49 @@ static bool bcm_iproc_i2c_slave_isr(struct bcm_iproc_i2c_dev *iproc_i2c,
 				 BIT(IS_S_START_BUSY_SHIFT));
 	}
 
-	/* check slave transmit status only if slave is transmitting */
-	if (!iproc_i2c->slave_rx_only)
-		bcm_iproc_i2c_check_slave_status(iproc_i2c);
+	/* if the controller has been reset, immediately return from the ISR */
+	if (bcm_iproc_i2c_check_slave_status(iproc_i2c, status))
+		return true;
+
+	/*
+	 * Slave events in case of master-write, master-write-read and,
+	 * master-read
+	 *
+	 * Master-write     : only IS_S_RX_EVENT_SHIFT event
+	 * Master-write-read: both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
+	 *                    events
+	 * Master-read      : both IS_S_RX_EVENT_SHIFT and IS_S_RD_EVENT_SHIFT
+	 *                    events or only IS_S_RD_EVENT_SHIFT
+	 *
+	 * iproc has a slave rx fifo size of 64 bytes. Rx fifo full interrupt
+	 * (IS_S_RX_FIFO_FULL_SHIFT) will be generated when RX fifo becomes
+	 * full. This can happen if Master issues write requests of more than
+	 * 64 bytes.
+	 */
+	if (status & BIT(IS_S_RX_EVENT_SHIFT) ||
+	    status & BIT(IS_S_RD_EVENT_SHIFT) ||
+	    status & BIT(IS_S_RX_FIFO_FULL_SHIFT)) {
+		/* disable slave interrupts */
+		val = iproc_i2c_rd_reg(iproc_i2c, IE_OFFSET);
+		val &= ~iproc_i2c->slave_int_mask;
+		iproc_i2c_wr_reg(iproc_i2c, IE_OFFSET, val);
+
+		if (status & BIT(IS_S_RD_EVENT_SHIFT))
+			/* Master-write-read request */
+			iproc_i2c->slave_rx_only = false;
+		else
+			/* Master-write request only */
+			iproc_i2c->slave_rx_only = true;
+
+		/* schedule tasklet to read data later */
+		tasklet_schedule(&iproc_i2c->slave_rx_tasklet);
+
+		/* clear IS_S_RX_FIFO_FULL_SHIFT interrupt */
+		if (status & BIT(IS_S_RX_FIFO_FULL_SHIFT)) {
+			val = BIT(IS_S_RX_FIFO_FULL_SHIFT);
+			iproc_i2c_wr_reg(iproc_i2c, IS_OFFSET, val);
+		}
+	}
 
 	return true;
 }
-- 
2.42.0



