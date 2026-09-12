Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F394342E417;
	Sat, 12 Sep 2026 10:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209688; cv=none; b=ucsGZt8Pm8NNhQFaT9t/ME8gztHJ4m4d/apifsXiYjJpkkzaIV8wkyS5SNXfLN2yV/7yaD0Z6ADcDI9cQSEySTqz2YRvXHEadQqWsL65Glrc9eAzR/5/qVD1984qzSHVcjVmMSapYpQnnHXySOT39GEoV3u16UB/ypD8fkbJwHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209688; c=relaxed/simple;
	bh=IJtPhGtnUrcQdnSSkM5pJoep5/1VxXVeifdCtx/6BB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9AFAFLWKqXci4IFVIN4HYGyPpIPhcKoxm1VMmqJLdIO/CHLox9OtpgKMLqBf/YtouCUQWdyRLmo/tVs2gOL6JKIp0Y5e3GQQMMOc2CTOhHufP36CcNWV9Wfbu8xh06t12WEemQapYVHHh+aMHlCfk8P2qcA9H/6Xp/NlP74cK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzqsubZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzqsubZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96551F00893;
	Sat, 12 Sep 2026 10:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209686;
	bh=bEW5YAfdSDYdyu4C6mVuu9kw8LOlUcMEr83BcO3/Y6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzqsubZum0cagilmb2OoVn9fxY8nR9qPZrA/HxNmBfXywJ50SMl6QREYSrIC6Dnu8
	 bF+tFObCU/0zYUh1X2PMf50Ic+FWXAeSHPEkfjfy5ifwnGJf4E01C8kWyykAJJjPe/
	 IK2GOhL7N7RJQujG9g/FB3WR/QiXQFh1/9jc7luY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Byczkowski <by@by-online.de>,
	Calvin Owens <calvin@wbinvd.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0870/1518] pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler
Date: Sat, 12 Sep 2026 08:50:39 +0200
Message-ID: <20260912065643.130368856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Byczkowski <by@by-online.de>

[ Upstream commit 93781560b2fdd26fa8499d64db8a95a07e1dc902 ]

Split the pps-gpio interrupt handler into a primary (hardirq) handler that
captures the PPS timestamp at interrupt entry, and a threaded handler that
processes the event.  This produces the same two-part handler structure on
both PREEMPT_RT and non-RT kernels.

On non-RT kernels the threaded portion runs immediately after the primary,
with no behavioral change compared to the previous single-handler
implementation.

On PREEMPT_RT, where interrupt handlers are force-threaded by default, the
previous single-handler implementation captured the timestamp inside the
threaded portion, after IRQ-thread scheduling delay.  With the split, the
timestamp is captured in true hardirq context as it is on non-RT kernels,
eliminating a significant source of PPS jitter on RT systems.

Link: https://lore.kernel.org/2e32729029fbf6977ecf04665eb00f2efd3e2c17.1780359378.git.calvin@wbinvd.org
Signed-off-by: Michael Byczkowski <by@by-online.de>
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Michael Byczkowski <by@by-online.de>
Tested-by: Calvin Owens <calvin@wbinvd.org>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b899e0279f90 ("pps-gpio: remove dead capture_clear code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-gpio.c | 37 +++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 935da68610c70..ed111621ee5f9 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -35,33 +35,44 @@ struct pps_gpio_device_data {
 	bool capture_clear;
 	unsigned int echo_active_ms;	/* PPS echo active duration */
 	unsigned long echo_timeout;	/* timer timeout value in jiffies */
+	struct pps_event_time ts;	/* timestamp captured in hardirq */
 };
 
 /*
  * Report the PPS event
  */
 
-static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
+/*
+ * Primary hardirq handler -- runs in hardirq context even on PREEMPT_RT.
+ * Only captures the timestamp; all other work is deferred to the thread.
+ */
+static irqreturn_t pps_gpio_irq_hardirq(int irq, void *data)
 {
-	const struct pps_gpio_device_data *info;
-	struct pps_event_time ts;
-	int rising_edge;
+	struct pps_gpio_device_data *info = data;
+
+	pps_get_ts(&info->ts);
 
-	/* Get the time stamp first */
-	pps_get_ts(&ts);
+	return IRQ_WAKE_THREAD;
+}
 
-	info = data;
+/*
+ * Threaded handler -- processes the PPS event using the timestamp
+ * captured in hardirq context above.
+ */
+static irqreturn_t pps_gpio_irq_thread(int irq, void *data)
+{
+	struct pps_gpio_device_data *info = data;
+	int rising_edge;
 
-	/* Small trick to bypass the check on edge's direction when capture_clear is unset */
 	rising_edge = info->capture_clear ?
 		      gpiod_get_value(info->gpio_pin) : !info->assert_falling_edge;
 	if ((rising_edge && !info->assert_falling_edge) ||
 			(!rising_edge && info->assert_falling_edge))
-		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, data);
+		pps_event(info->pps, &info->ts, PPS_CAPTUREASSERT, data);
 	else if (info->capture_clear &&
 			((rising_edge && info->assert_falling_edge) ||
 			(!rising_edge && !info->assert_falling_edge)))
-		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, data);
+		pps_event(info->pps, &info->ts, PPS_CAPTURECLEAR, data);
 	else
 		dev_warn_ratelimited(&info->pps->dev, "IRQ did not trigger any PPS event\n");
 
@@ -210,8 +221,10 @@ static int pps_gpio_probe(struct platform_device *pdev)
 	}
 
 	/* register IRQ interrupt handler */
-	ret = request_irq(data->irq, pps_gpio_irq_handler,
-			  get_irqf_trigger_flags(data), data->info.name, data);
+	ret = request_threaded_irq(data->irq,
+			  pps_gpio_irq_hardirq, pps_gpio_irq_thread,
+			  get_irqf_trigger_flags(data) | IRQF_ONESHOT,
+			  data->info.name, data);
 	if (ret) {
 		pps_unregister_source(data->pps);
 		dev_err(dev, "failed to acquire IRQ %d\n", data->irq);
-- 
2.53.0



