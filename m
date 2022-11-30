Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC92C433C1;
	Wed, 30 Nov 2022 18:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833930;
	bh=/ApldcrwEy3b93W7SEjHgjxUdaWVd+G5O7Z/Vn3YiH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW2QBFEOzcUs3Sgdnm9QEJyRMSab7J9/wN5ZJ4XHJ6gQu9AzfahsxaBLSlEFaRF/P
	 PwJvRpNDTr2xUNiEXwaatzU6eGy0xqJ7xtpaQfWNw/r45CRtru+fP6MMFLlGx0hYcN
	 ZDKxPhCTDGlBneK4vKyJgvv+jAsaIrfWmbZyPdF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 067/289] bus: sunxi-rsb: Support atomic transfers
Date: Wed, 30 Nov 2022 19:20:52 +0100
Message-Id: <20221130180545.648116547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 077686da0e2162c4ea5ae0df205849c2a7a84479 ]

When communicating with a PMIC during system poweroff (pm_power_off()),
IRQs are disabled and we are in a RCU read-side critical section, so we
cannot use wait_for_completion_io_timeout(). Instead, poll the status
register for transfer completion.

Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221114015749.28490-3-samuel@sholland.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 17343cd75338..3aa91aed3bf7 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -267,6 +267,9 @@ EXPORT_SYMBOL_GPL(sunxi_rsb_driver_register);
 /* common code that starts a transfer */
 static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 {
+	u32 int_mask, status;
+	bool timeout;
+
 	if (readl(rsb->regs + RSB_CTRL) & RSB_CTRL_START_TRANS) {
 		dev_dbg(rsb->dev, "RSB transfer still in progress\n");
 		return -EBUSY;
@@ -274,13 +277,23 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 
 	reinit_completion(&rsb->complete);
 
-	writel(RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER,
-	       rsb->regs + RSB_INTE);
+	int_mask = RSB_INTS_LOAD_BSY | RSB_INTS_TRANS_ERR | RSB_INTS_TRANS_OVER;
+	writel(int_mask, rsb->regs + RSB_INTE);
 	writel(RSB_CTRL_START_TRANS | RSB_CTRL_GLOBAL_INT_ENB,
 	       rsb->regs + RSB_CTRL);
 
-	if (!wait_for_completion_io_timeout(&rsb->complete,
-					    msecs_to_jiffies(100))) {
+	if (irqs_disabled()) {
+		timeout = readl_poll_timeout_atomic(rsb->regs + RSB_INTS,
+						    status, (status & int_mask),
+						    10, 100000);
+		writel(status, rsb->regs + RSB_INTS);
+	} else {
+		timeout = !wait_for_completion_io_timeout(&rsb->complete,
+							  msecs_to_jiffies(100));
+		status = rsb->status;
+	}
+
+	if (timeout) {
 		dev_dbg(rsb->dev, "RSB timeout\n");
 
 		/* abort the transfer */
@@ -292,18 +305,18 @@ static int _sunxi_rsb_run_xfer(struct sunxi_rsb *rsb)
 		return -ETIMEDOUT;
 	}
 
-	if (rsb->status & RSB_INTS_LOAD_BSY) {
+	if (status & RSB_INTS_LOAD_BSY) {
 		dev_dbg(rsb->dev, "RSB busy\n");
 		return -EBUSY;
 	}
 
-	if (rsb->status & RSB_INTS_TRANS_ERR) {
-		if (rsb->status & RSB_INTS_TRANS_ERR_ACK) {
+	if (status & RSB_INTS_TRANS_ERR) {
+		if (status & RSB_INTS_TRANS_ERR_ACK) {
 			dev_dbg(rsb->dev, "RSB slave nack\n");
 			return -EINVAL;
 		}
 
-		if (rsb->status & RSB_INTS_TRANS_ERR_DATA) {
+		if (status & RSB_INTS_TRANS_ERR_DATA) {
 			dev_dbg(rsb->dev, "RSB transfer data error\n");
 			return -EIO;
 		}
-- 
2.35.1



