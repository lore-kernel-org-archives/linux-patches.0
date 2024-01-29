Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E355372223;
	Mon, 29 Jan 2024 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548503; cv=none; b=UjRsrx6xXAkpgKsPKTA04Jmf+J0yrhIcBEBtPQGTEbk9x2U4thUAGvJEqx4bCO3bPMyHYmllNjr4h2RmCQ6jGqka8SKLVxeoGmS6ji0phQEfv+JAckB4mNWiYOkLkfHaOMvYjKBqKyq/sAFnQy6y2RK97faffXKRCHMS+pZ25uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548503; c=relaxed/simple;
	bh=ea5Iuqg5YMKgbCt6gnoiFv9A90//I0ClncSTY3HQ2uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJWoTt/DXH3kAR9gXZRtgR/YMq8/9DYqRxObEv0FLehY2uu+vJIM04oC8m365D3m6BrcvjOnOtA1QOtwEz9dXKI/d7QQaB0Xk6OnZaZ1HXQgMNmFE4sJYaHl10lSzY7NN46Z61XI/RJFpoAO80aW/pNlOs0ChIXxw58OQFA1bao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwiEVwb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwiEVwb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC405C43390;
	Mon, 29 Jan 2024 17:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548502;
	bh=ea5Iuqg5YMKgbCt6gnoiFv9A90//I0ClncSTY3HQ2uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwiEVwb3eFfI0k9KSbxJvyqb7Bn8QpHWYOm2ZetulhvXYmV+o3uWp+ghkElw9N8Fy
	 a97NS3aqmGQiD1epuCJ9RR4Z66VJzARg056pIGS3wmliWU1NLhactBeS/KJ7Z0FNS8
	 6Z52TNHT+QXQFu+MBJrh6xKbvX1U+hAcsRe55Kd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 130/331] serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
Date: Mon, 29 Jan 2024 09:03:14 -0800
Message-ID: <20240129170018.742960002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit f6959c5217bd799bcb770b95d3c09b3244e175c6 upstream.

Remove global struct regmap so that it is more obvious that this
regmap is to be used only in the probe function.

Also add a comment to that effect in probe function.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -335,7 +335,6 @@ struct sc16is7xx_one {
 
 struct sc16is7xx_port {
 	const struct sc16is7xx_devtype	*devtype;
-	struct regmap			*regmap;
 	struct clk			*clk;
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
@@ -1413,7 +1412,8 @@ static int sc16is7xx_setup_gpio_chip(str
 /*
  * Configure ports designated to operate as modem control lines.
  */
-static int sc16is7xx_setup_mctrl_ports(struct sc16is7xx_port *s)
+static int sc16is7xx_setup_mctrl_ports(struct sc16is7xx_port *s,
+				       struct regmap *regmap)
 {
 	int i;
 	int ret;
@@ -1442,7 +1442,7 @@ static int sc16is7xx_setup_mctrl_ports(s
 
 	if (s->mctrl_mask)
 		regmap_update_bits(
-			s->regmap,
+			regmap,
 			SC16IS7XX_IOCONTROL_REG,
 			SC16IS7XX_IOCONTROL_MODEM_A_BIT |
 			SC16IS7XX_IOCONTROL_MODEM_B_BIT, s->mctrl_mask);
@@ -1474,6 +1474,10 @@ static int sc16is7xx_probe(struct device
 	 * This device does not have an identification register that would
 	 * tell us if we are really connected to the correct device.
 	 * The best we can do is to check if communication is at all possible.
+	 *
+	 * Note: regmap[0] is used in the probe function to access registers
+	 * common to all channels/ports, as it is guaranteed to be present on
+	 * all variants.
 	 */
 	ret = regmap_read(regmaps[0], SC16IS7XX_LSR_REG, &val);
 	if (ret < 0)
@@ -1509,7 +1513,6 @@ static int sc16is7xx_probe(struct device
 			return -EINVAL;
 	}
 
-	s->regmap = regmaps[0];
 	s->devtype = devtype;
 	dev_set_drvdata(dev, s);
 	mutex_init(&s->efr_lock);
@@ -1524,7 +1527,7 @@ static int sc16is7xx_probe(struct device
 	sched_set_fifo(s->kworker_task);
 
 	/* reset device, purging any pending irq / data */
-	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG,
+	regmap_write(regmaps[0], SC16IS7XX_IOCONTROL_REG,
 		     SC16IS7XX_IOCONTROL_SRESET_BIT);
 
 	for (i = 0; i < devtype->nr_uart; ++i) {
@@ -1604,7 +1607,7 @@ static int sc16is7xx_probe(struct device
 				s->p[u].irda_mode = true;
 	}
 
-	ret = sc16is7xx_setup_mctrl_ports(s);
+	ret = sc16is7xx_setup_mctrl_ports(s, regmaps[0]);
 	if (ret)
 		goto out_ports;
 


