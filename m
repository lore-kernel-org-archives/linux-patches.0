Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38D47CA72;
	Sat, 12 Sep 2026 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217372; cv=none; b=M6DA6wGU2deNJp+5A6fDwTxGriSlUyIgosod3dRTT4ooFRlclCpgPj0R9QbviWUPGml4aXBKhxAiUCbrOz/qZdubYUSKMbtctuqm0d5FWnje8s5fUvh8J8WMVoaPo+fBHImrRCPjOvTrW7L2gR03YCbCdPpVOlVi9fxHCc6MD2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217372; c=relaxed/simple;
	bh=limLTWBlCspiCOYx8ALCEKt1H5gaOs9AQii81CqtNwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp4fS+NLllVvgMDCKrwuQcH+6PR77Q7KMiYECZfkMOpBd9aj7D5YlDfr0eYKda1cNr6NFjaVqdlbncwXAWP9jyAQcseiv5IKuYpLvqLa/jyBfFpjniEZkOuT1R+rJcK9Sb25Id3tNkldwaCN7Nv6l7cRJs9anGlkUO1impA4ixo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yx9V1vxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yx9V1vxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C681F000FF;
	Sat, 12 Sep 2026 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217370;
	bh=bTykpHvLWowkM/+0GCaYg2gts787Nter5qz4WyInrUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yx9V1vxBYz3281m6RD54VrlwHw1UK7DTRV7LW4EoVNp2Cym4lbcicS/0kOUa5jd6c
	 PHbdNMPKK0dqYhBmaWB7ItMvAYtOCljUIZXhV8228mOq06qnhlf0YeXhQpcTRRgQaF
	 Q9tMsdaa2gLA0qRRlalU2cpDuafmCLQFwGTkXCU0=
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
Subject: [PATCH 6.12 0885/1376] pps: pps-gpio: split IRQ handler into hardirq timestamper + threaded handler
Date: Sat, 12 Sep 2026 08:55:11 +0200
Message-ID: <20260912065627.287081491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 027759e2d563c..99b4ca57a3ab4 100644
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



