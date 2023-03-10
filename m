Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B76B882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA15FC433EF;
	Fri, 10 Mar 2023 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460920;
	bh=enUehwpb7JQskiuFoUQTqZp4FZ7hgJdHplGItTUZb4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYSS/3CA69GzeCn1Iws8VbUp9747tq/AN8RCsPPnSRXOvV2SzlH2FSpjijyrG3BxN
	 AygGLIFLa01CaXSalrUR2arxX1l5bMhqxiQhR3/+Z8jOiUrrOD1h4Gnyz9zZPBeWT+
	 xnplf9jPGgcT4BCdIgW55badYqPNad6dyGZZUpo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen-chien Jesse Sung <jesse.sung@canonical.com>,
	Isaac True <isaac.true@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/529] serial: sc16is7xx: setup GPIO controller later in probe
Date: Fri, 10 Mar 2023 14:40:38 +0100
Message-Id: <20230310133827.763577238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaac True <isaac.true@canonical.com>

[ Upstream commit c8f71b49ee4d28930c4a6798d1969fa91dc4ef3e ]

The GPIO controller component of the sc16is7xx driver is setup too
early, which can result in a race condition where another device tries
to utilise the GPIO lines before the sc16is7xx device has finished
initialising.

This issue manifests itself as an Oops when the GPIO lines are configured:

    Unable to handle kernel read from unreadable memory at virtual address
    ...
    pc : sc16is7xx_gpio_direction_output+0x68/0x108 [sc16is7xx]
    lr : sc16is7xx_gpio_direction_output+0x4c/0x108 [sc16is7xx]
    ...
    Call trace:
    sc16is7xx_gpio_direction_output+0x68/0x108 [sc16is7xx]
    gpiod_direction_output_raw_commit+0x64/0x318
    gpiod_direction_output+0xb0/0x170
    create_gpio_led+0xec/0x198
    gpio_led_probe+0x16c/0x4f0
    platform_drv_probe+0x5c/0xb0
    really_probe+0xe8/0x448
    driver_probe_device+0xe8/0x138
    __device_attach_driver+0x94/0x118
    bus_for_each_drv+0x8c/0xe0
    __device_attach+0x100/0x1b8
    device_initial_probe+0x28/0x38
    bus_probe_device+0xa4/0xb0
    deferred_probe_work_func+0x90/0xe0
    process_one_work+0x1c4/0x480
    worker_thread+0x54/0x430
    kthread+0x138/0x150
    ret_from_fork+0x10/0x1c

This patch moves the setup of the GPIO controller functions to later in the
probe function, ensuring the sc16is7xx device has already finished
initialising by the time other devices try to make use of the GPIO lines.
The error handling has also been reordered to reflect the new
initialisation order.

Co-developed-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Signed-off-by: Wen-chien Jesse Sung <jesse.sung@canonical.com>
Signed-off-by: Isaac True <isaac.true@canonical.com>
Link: https://lore.kernel.org/r/20221130105529.698385-1-isaac.true@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 51 +++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 04b4ed5d06341..7ece8d1a23cb3 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1243,25 +1243,6 @@ static int sc16is7xx_probe(struct device *dev,
 	}
 	sched_set_fifo(s->kworker_task);
 
-#ifdef CONFIG_GPIOLIB
-	if (devtype->nr_gpio) {
-		/* Setup GPIO cotroller */
-		s->gpio.owner		 = THIS_MODULE;
-		s->gpio.parent		 = dev;
-		s->gpio.label		 = dev_name(dev);
-		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
-		s->gpio.get		 = sc16is7xx_gpio_get;
-		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
-		s->gpio.set		 = sc16is7xx_gpio_set;
-		s->gpio.base		 = -1;
-		s->gpio.ngpio		 = devtype->nr_gpio;
-		s->gpio.can_sleep	 = 1;
-		ret = gpiochip_add_data(&s->gpio, s);
-		if (ret)
-			goto out_thread;
-	}
-#endif
-
 	/* reset device, purging any pending irq / data */
 	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG << SC16IS7XX_REG_SHIFT,
 			SC16IS7XX_IOCONTROL_SRESET_BIT);
@@ -1327,6 +1308,25 @@ static int sc16is7xx_probe(struct device *dev,
 				s->p[u].irda_mode = true;
 	}
 
+#ifdef CONFIG_GPIOLIB
+	if (devtype->nr_gpio) {
+		/* Setup GPIO cotroller */
+		s->gpio.owner		 = THIS_MODULE;
+		s->gpio.parent		 = dev;
+		s->gpio.label		 = dev_name(dev);
+		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
+		s->gpio.get		 = sc16is7xx_gpio_get;
+		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
+		s->gpio.set		 = sc16is7xx_gpio_set;
+		s->gpio.base		 = -1;
+		s->gpio.ngpio		 = devtype->nr_gpio;
+		s->gpio.can_sleep	 = 1;
+		ret = gpiochip_add_data(&s->gpio, s);
+		if (ret)
+			goto out_thread;
+	}
+#endif
+
 	/*
 	 * Setup interrupt. We first try to acquire the IRQ line as level IRQ.
 	 * If that succeeds, we can allow sharing the interrupt as well.
@@ -1346,18 +1346,19 @@ static int sc16is7xx_probe(struct device *dev,
 	if (!ret)
 		return 0;
 
-out_ports:
-	for (i--; i >= 0; i--) {
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
-	}
-
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
 
 out_thread:
 #endif
+
+out_ports:
+	for (i--; i >= 0; i--) {
+		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
+		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
+	}
+
 	kthread_stop(s->kworker_task);
 
 out_clk:
-- 
2.39.2



