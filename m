Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C814D431;
	Tue, 10 Sep 2024 09:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961676; cv=none; b=sHycztUTVUj7gX85tW+dzeyD/WARylYSBpCQycKnt/xJNUqfFs1OK4GXBTMc2d/mVzqmfolPtt+cPg8InvhXGPufqP9yzqY1MSB3KlHbO/53oA1/ggJszfuGuqxOHTD6fBJdjhbp6jO/vWDt+8i9JRSwaXldBF2ERDzU2Ujzia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961676; c=relaxed/simple;
	bh=ZfYLA57BqHihGOq9lSZlYg2XJK4Rv6D9uwIo/29Gc+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+XPehhBhHkyeXG3xcQAGHl1AaivOl7CRKRlEFu9GuHQBVBoCCxo/WGKJ7gPuvQ44+8MIWr45q7BWdbdlMDru2ecln0PldKizThjH6T5+y4vA6m0MVwZSy1ccuvMkCY5Vs0OaXYa1ye+3Dtq7IMdRdk9KvUifu/IpLXvSEtz5MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUbmJnkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUbmJnkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0EEC4CEC6;
	Tue, 10 Sep 2024 09:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961676;
	bh=ZfYLA57BqHihGOq9lSZlYg2XJK4Rv6D9uwIo/29Gc+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUbmJnkYV+KZjliLLFCJ07B/mYyAxbSYyLKGkY5s4briJYcCmhAn7WvPl5rkxOXxU
	 aFUyMZKpXi2AMofd+0TRoLuIz8zL+Sekmsd636y8qrAc/CeQ8eCZkzPsc0fngfeDUj
	 RZ6wkRkJmfhx9BE3iqYp4zOtVlolBITW9jd0FS9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/375] can: m_can: Do not cancel timer from within timer
Date: Tue, 10 Sep 2024 11:29:08 +0200
Message-ID: <20240910092627.540127860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Schneider-Pargmann <msp@baylibre.com>

[ Upstream commit 4d5159bfafa8d1a205d8213b7434e0402588b9ed ]

On setups without interrupts, the interrupt handler is called from a
timer callback. For non-peripheral receives napi is scheduled,
interrupts are disabled and the timer is canceled with a blocking call.
In case of an error this can happen as well.

Check if napi is scheduled in the timer callback after the interrupt
handler executed. If napi is scheduled, the timer is disabled. It will
be reenabled by m_can_poll().

Return error values from the interrupt handler so that interrupt threads
and timer callback can deal differently with it. In case of the timer
we only disable the timer. The rest will be done when stopping the
interface.

Fixes: b382380c0d2d ("can: m_can: Add hrtimer to generate software interrupt")
Fixes: a163c5761019 ("can: m_can: Start/Cancel polling timer together with interrupts")
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20240805183047.305630-5-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 57 ++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2d73fa7f8258..d15655df6393 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -453,7 +453,7 @@ static inline void m_can_disable_all_interrupts(struct m_can_classdev *cdev)
 
 	if (!cdev->net->irq) {
 		dev_dbg(cdev->dev, "Stop hrtimer\n");
-		hrtimer_cancel(&cdev->hrtimer);
+		hrtimer_try_to_cancel(&cdev->hrtimer);
 	}
 }
 
@@ -1167,11 +1167,15 @@ static void m_can_coalescing_update(struct m_can_classdev *cdev, u32 ir)
 			      HRTIMER_MODE_REL);
 }
 
-static irqreturn_t m_can_isr(int irq, void *dev_id)
+/* This interrupt handler is called either from the interrupt thread or a
+ * hrtimer. This has implications like cancelling a timer won't be possible
+ * blocking.
+ */
+static int m_can_interrupt_handler(struct m_can_classdev *cdev)
 {
-	struct net_device *dev = (struct net_device *)dev_id;
-	struct m_can_classdev *cdev = netdev_priv(dev);
+	struct net_device *dev = cdev->net;
 	u32 ir;
+	int ret;
 
 	if (pm_runtime_suspended(cdev->dev))
 		return IRQ_NONE;
@@ -1198,11 +1202,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 			m_can_disable_all_interrupts(cdev);
 			napi_schedule(&cdev->napi);
 		} else {
-			int pkts;
-
-			pkts = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, ir);
-			if (pkts < 0)
-				goto out_fail;
+			ret = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, ir);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
@@ -1220,8 +1222,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	} else  {
 		if (ir & (IR_TEFN | IR_TEFW)) {
 			/* New TX FIFO Element arrived */
-			if (m_can_echo_tx_event(dev) != 0)
-				goto out_fail;
+			ret = m_can_echo_tx_event(dev);
+			if (ret != 0)
+				return ret;
 		}
 	}
 
@@ -1229,16 +1232,31 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		can_rx_offload_threaded_irq_finish(&cdev->offload);
 
 	return IRQ_HANDLED;
+}
 
-out_fail:
-	m_can_disable_all_interrupts(cdev);
-	return IRQ_HANDLED;
+static irqreturn_t m_can_isr(int irq, void *dev_id)
+{
+	struct net_device *dev = (struct net_device *)dev_id;
+	struct m_can_classdev *cdev = netdev_priv(dev);
+	int ret;
+
+	ret =  m_can_interrupt_handler(cdev);
+	if (ret < 0) {
+		m_can_disable_all_interrupts(cdev);
+		return IRQ_HANDLED;
+	}
+
+	return ret;
 }
 
 static enum hrtimer_restart m_can_coalescing_timer(struct hrtimer *timer)
 {
 	struct m_can_classdev *cdev = container_of(timer, struct m_can_classdev, hrtimer);
 
+	if (cdev->can.state == CAN_STATE_BUS_OFF ||
+	    cdev->can.state == CAN_STATE_STOPPED)
+		return HRTIMER_NORESTART;
+
 	irq_wake_thread(cdev->net->irq, cdev->net);
 
 	return HRTIMER_NORESTART;
@@ -1930,8 +1948,17 @@ static enum hrtimer_restart hrtimer_callback(struct hrtimer *timer)
 {
 	struct m_can_classdev *cdev = container_of(timer, struct
 						   m_can_classdev, hrtimer);
+	int ret;
+
+	if (cdev->can.state == CAN_STATE_BUS_OFF ||
+	    cdev->can.state == CAN_STATE_STOPPED)
+		return HRTIMER_NORESTART;
+
+	ret = m_can_interrupt_handler(cdev);
 
-	m_can_isr(0, cdev->net);
+	/* On error or if napi is scheduled to read, stop the timer */
+	if (ret < 0 || napi_is_scheduled(&cdev->napi))
+		return HRTIMER_NORESTART;
 
 	hrtimer_forward_now(timer, ms_to_ktime(HRTIMER_POLL_INTERVAL_MS));
 
-- 
2.43.0



