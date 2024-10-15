Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB1F1D0492;
	Tue, 15 Oct 2024 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993382; cv=none; b=tv+YyAyFfVKu0uBWfSWQOIDqZnkUBXy5TY6jgDGKNrWZD79izi3/JgymwoKR205SZEdEt7GWWN9P9J4wrfHhMPf6fVt6NLiC2GNmlSSLrVNnvadx4JfTYl73do+kFVaDgBA7cfHmn0POZRNgi2TPy/TGDISXHL978PC3QSVenC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993382; c=relaxed/simple;
	bh=CsdLgKMFPWc4QnWYMOKM7E9oYr9069iye8Hv3ZmS98c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOu49jPjY2dyP02gDU7Ao+kn+gNzBLuy9NPI+j6L0UChDIE0nMdDgM9PwZsXAplqNgxLVGm89FBm/RLLXwQj8GXelFyZW+DRVX8dW7KekI/dRmsVc8iiiaTTbgOhcXqdHRNgD0uC/e6lospgu6DXOcKbyOEaooPAdCEAdq7sSOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/ZQWSZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/ZQWSZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AC8C4CEC6;
	Tue, 15 Oct 2024 11:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993382;
	bh=CsdLgKMFPWc4QnWYMOKM7E9oYr9069iye8Hv3ZmS98c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/ZQWSZ/vmNh9r8f48d02OSB/4NdTuS7oCB/0oW3yvZ9ooYRc05OOLM6oVEdiU+R3
	 btVlrwbkdvtL53TFOGqrn7bj3yFONmeSJ/7xL/sb8EH5tOSjhaaErju1B0GKCGj0s/
	 Y5u2mdF1g524RRhjfSyxDzCydurNG+cCuUKtclFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/691] i2c: xiic: Switch from waitqueue to completion
Date: Tue, 15 Oct 2024 13:25:43 +0200
Message-ID: <20241015112456.017246190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit fdacc3c7405d1fc33c1f2771699a4fc24551e480 ]

There will never be threads queueing up in the xiic_xmit(), use
completion synchronization primitive to wait for the interrupt
handler thread to complete instead as it is much better fit and
there is no need to overload it for this purpose.

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 7b9ec379733eb..b5368d11b5240 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -23,7 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
-#include <linux/wait.h>
+#include <linux/completion.h>
 #include <linux/platform_data/i2c-xiic.h>
 #include <linux/io.h>
 #include <linux/slab.h>
@@ -48,7 +48,7 @@ enum xiic_endian {
  * struct xiic_i2c - Internal representation of the XIIC I2C bus
  * @dev: Pointer to device structure
  * @base: Memory base of the HW registers
- * @wait: Wait queue for callers
+ * @completion:	Completion for callers
  * @adap: Kernel adapter representation
  * @tx_msg: Messages from above to be sent
  * @lock: Mutual exclusion
@@ -64,7 +64,7 @@ enum xiic_endian {
 struct xiic_i2c {
 	struct device *dev;
 	void __iomem *base;
-	wait_queue_head_t wait;
+	struct completion completion;
 	struct i2c_adapter adap;
 	struct i2c_msg *tx_msg;
 	struct mutex lock;
@@ -160,6 +160,9 @@ struct xiic_i2c {
 #define XIIC_PM_TIMEOUT		1000	/* ms */
 /* timeout waiting for the controller to respond */
 #define XIIC_I2C_TIMEOUT	(msecs_to_jiffies(1000))
+/* timeout waiting for the controller finish transfers */
+#define XIIC_XFER_TIMEOUT	(msecs_to_jiffies(10000))
+
 /*
  * The following constant is used for the device global interrupt enable
  * register, to enable all interrupts for the device, this is the only bit
@@ -367,7 +370,7 @@ static void xiic_wakeup(struct xiic_i2c *i2c, int code)
 	i2c->rx_msg = NULL;
 	i2c->nmsgs = 0;
 	i2c->state = code;
-	wake_up(&i2c->wait);
+	complete(&i2c->completion);
 }
 
 static irqreturn_t xiic_process(int irq, void *dev_id)
@@ -714,6 +717,7 @@ static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num)
 	i2c->tx_msg = msgs;
 	i2c->rx_msg = NULL;
 	i2c->nmsgs = num;
+	init_completion(&i2c->completion);
 
 	ret = xiic_reinit(i2c);
 	if (!ret)
@@ -740,23 +744,23 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	err = xiic_start_xfer(i2c, msgs, num);
 	if (err < 0) {
 		dev_err(adap->dev.parent, "Error xiic_start_xfer\n");
-		goto out;
+		return err;
 	}
 
-	if (wait_event_timeout(i2c->wait, (i2c->state == STATE_ERROR) ||
-		(i2c->state == STATE_DONE), HZ)) {
-		mutex_lock(&i2c->lock);
-		err = (i2c->state == STATE_DONE) ? num : -EIO;
-		goto out;
-	} else {
-		mutex_lock(&i2c->lock);
+	err = wait_for_completion_timeout(&i2c->completion, XIIC_XFER_TIMEOUT);
+	mutex_lock(&i2c->lock);
+	if (err == 0) {	/* Timeout */
 		i2c->tx_msg = NULL;
 		i2c->rx_msg = NULL;
 		i2c->nmsgs = 0;
 		err = -ETIMEDOUT;
-		goto out;
+	} else if (err < 0) {	/* Completion error */
+		i2c->tx_msg = NULL;
+		i2c->rx_msg = NULL;
+		i2c->nmsgs = 0;
+	} else {
+		err = (i2c->state == STATE_DONE) ? num : -EIO;
 	}
-out:
 	mutex_unlock(&i2c->lock);
 	pm_runtime_mark_last_busy(i2c->dev);
 	pm_runtime_put_autosuspend(i2c->dev);
@@ -819,7 +823,6 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 		 DRIVER_NAME " %s", pdev->name);
 
 	mutex_init(&i2c->lock);
-	init_waitqueue_head(&i2c->wait);
 
 	i2c->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(i2c->clk))
-- 
2.43.0



