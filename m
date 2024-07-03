Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5416DEAC;
	Wed,  3 Jul 2024 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003638; cv=none; b=sZ5A/7670GCu5253ww64498xgIf8jool1tqn2CFLhy3x2CDGpp8ksTFNLt7w/4lPvsYwivBOoRbrttxZS1ALTRARrTPoGUoOEXFFvrefJWbZhkhg3ZkU6nDze+bPXUIJQyut52ATAuVG4d67Q/IyeYh8VoPy4bYL7I5kSvq2/p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003638; c=relaxed/simple;
	bh=wMzYo9q0LQZjXjUZF0kithG1IaABJiDVJT+J6LIiGX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwAM5Hn/kbRYXqz0aXXKstPHYZOyXgGVJo0HLAjzRER3n2yGApP4ZV2NgMqxfZWMGm2bLYgb/bm9pIC4qfxPzg6nvz/be8R808eQuJ+VUyxcynhPvNuIvGB5ssjt2p8oYkwkAfBv46qI06dD+xXFcUcE86Oo8eQzwtdjQy6gK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWW8lo30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWW8lo30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50A3C2BD10;
	Wed,  3 Jul 2024 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003638;
	bh=wMzYo9q0LQZjXjUZF0kithG1IaABJiDVJT+J6LIiGX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWW8lo30UoKjcIwo/dY6lBfvKOu6jlOvF200WqfWRb3TwvodUrrfLtXnwJ/PK0hy3
	 hl4SjXVA5fXnSCMTqpo0sHEDU3LCEAglAdeslhYFR5Ehs4JbYiRAgAGd3WQUuCqqOd
	 yMB3tJGgcJ3WW7vTyMWu8bGlTMCOJz8NtmrZmSaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Vaga <federico.vaga@cern.ch>,
	Andrew Lunn <andrew@lunn.ch>,
	Wolfram Sang <wsa@the-dreams.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/139] i2c: ocores: stop transfer on timeout
Date: Wed,  3 Jul 2024 12:40:11 +0200
Message-ID: <20240703102834.744635042@linuxfoundation.org>
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

From: Federico Vaga <federico.vaga@cern.ch>

[ Upstream commit e7663ef5ae0f02e3b902eb0305dec981333eb3e1 ]

Detecting a timeout is ok, but we also need to assert a STOP command on
the bus in order to prevent it from generating interrupts when there are
no on going transfers.

Example: very long transmission.

1. ocores_xfer: START a transfer
2. ocores_isr : handle byte by byte the transfer
3. ocores_xfer: goes in timeout [[bugfix here]]
4. ocores_xfer: return to I2C subsystem and to the I2C driver
5. I2C driver : it may clean up the i2c_msg memory
6. ocores_isr : receives another interrupt (pending bytes to be
                transferred) but the i2c_msg memory is invalid now

So, since the transfer was too long, we have to detect the timeout and
STOP the transfer.

Another point is that we have a critical region here. When handling the
timeout condition we may have a running IRQ handler. For this reason I
introduce a spinlock.

In order to make easier to understan locking I have:
- added a new function to handle timeout
- modified the current ocores_process() function in order to be protected
  by the new spinlock
Like this it is obvious at first sight that this locking serializes
the execution of ocores_process() and ocores_process_timeout()

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Stable-dep-of: 5a7247727306 ("i2c: ocores: set IACK bit after core is enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ocores.c | 54 +++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 87f9caacba856..aa852028d8c15 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -25,7 +25,12 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/log2.h>
+#include <linux/spinlock.h>
 
+/**
+ * @process_lock: protect I2C transfer process.
+ *     ocores_process() and ocores_process_timeout() can't run in parallel.
+ */
 struct ocores_i2c {
 	void __iomem *base;
 	u32 reg_shift;
@@ -36,6 +41,7 @@ struct ocores_i2c {
 	int pos;
 	int nmsgs;
 	int state; /* see STATE_ */
+	spinlock_t process_lock;
 	struct clk *clk;
 	int ip_clock_khz;
 	int bus_clock_khz;
@@ -141,19 +147,26 @@ static void ocores_process(struct ocores_i2c *i2c)
 {
 	struct i2c_msg *msg = i2c->msg;
 	u8 stat = oc_getreg(i2c, OCI2C_STATUS);
+	unsigned long flags;
+
+	/*
+	 * If we spin here is because we are in timeout, so we are going
+	 * to be in STATE_ERROR. See ocores_process_timeout()
+	 */
+	spin_lock_irqsave(&i2c->process_lock, flags);
 
 	if ((i2c->state == STATE_DONE) || (i2c->state == STATE_ERROR)) {
 		/* stop has been sent */
 		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_IACK);
 		wake_up(&i2c->wait);
-		return;
+		goto out;
 	}
 
 	/* error? */
 	if (stat & OCI2C_STAT_ARBLOST) {
 		i2c->state = STATE_ERROR;
 		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
-		return;
+		goto out;
 	}
 
 	if ((i2c->state == STATE_START) || (i2c->state == STATE_WRITE)) {
@@ -163,7 +176,7 @@ static void ocores_process(struct ocores_i2c *i2c)
 		if (stat & OCI2C_STAT_NACK) {
 			i2c->state = STATE_ERROR;
 			oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
-			return;
+			goto out;
 		}
 	} else
 		msg->buf[i2c->pos++] = oc_getreg(i2c, OCI2C_DATA);
@@ -184,14 +197,14 @@ static void ocores_process(struct ocores_i2c *i2c)
 
 				oc_setreg(i2c, OCI2C_DATA, addr);
 				oc_setreg(i2c, OCI2C_CMD,  OCI2C_CMD_START);
-				return;
+				goto out;
 			} else
 				i2c->state = (msg->flags & I2C_M_RD)
 					? STATE_READ : STATE_WRITE;
 		} else {
 			i2c->state = STATE_DONE;
 			oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
-			return;
+			goto out;
 		}
 	}
 
@@ -202,6 +215,9 @@ static void ocores_process(struct ocores_i2c *i2c)
 		oc_setreg(i2c, OCI2C_DATA, msg->buf[i2c->pos++]);
 		oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_WRITE);
 	}
+
+out:
+	spin_unlock_irqrestore(&i2c->process_lock, flags);
 }
 
 static irqreturn_t ocores_isr(int irq, void *dev_id)
@@ -213,9 +229,24 @@ static irqreturn_t ocores_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/**
+ * Process timeout event
+ * @i2c: ocores I2C device instance
+ */
+static void ocores_process_timeout(struct ocores_i2c *i2c)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&i2c->process_lock, flags);
+	i2c->state = STATE_ERROR;
+	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_STOP);
+	spin_unlock_irqrestore(&i2c->process_lock, flags);
+}
+
 static int ocores_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 {
 	struct ocores_i2c *i2c = i2c_get_adapdata(adap);
+	int ret;
 
 	i2c->msg = msgs;
 	i2c->pos = 0;
@@ -225,11 +256,14 @@ static int ocores_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	oc_setreg(i2c, OCI2C_DATA, i2c_8bit_addr_from_msg(i2c->msg));
 	oc_setreg(i2c, OCI2C_CMD, OCI2C_CMD_START);
 
-	if (wait_event_timeout(i2c->wait, (i2c->state == STATE_ERROR) ||
-			       (i2c->state == STATE_DONE), HZ))
-		return (i2c->state == STATE_DONE) ? num : -EIO;
-	else
+	ret = wait_event_timeout(i2c->wait, (i2c->state == STATE_ERROR) ||
+				 (i2c->state == STATE_DONE), HZ);
+	if (ret == 0) {
+		ocores_process_timeout(i2c);
 		return -ETIMEDOUT;
+	}
+
+	return (i2c->state == STATE_DONE) ? num : -EIO;
 }
 
 static int ocores_init(struct device *dev, struct ocores_i2c *i2c)
@@ -422,6 +456,8 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
+	spin_lock_init(&i2c->process_lock);
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	i2c->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(i2c->base))
-- 
2.43.0



