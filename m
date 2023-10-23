Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549015E86
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JunFaX07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918E6C433C8;
	Mon, 23 Oct 2023 11:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060482;
	bh=kvEYvfuyaemFN4ONFdOULRDgwmf3URQFLcgKbSK66Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JunFaX076SmsAX+KSa2ENb2lbV752yGaiPYmE2pr2KW4Jqq8vJxb0C6+BGaC3svNj
	 Ma+sYThEt2LG7l/NfDXWS7wfYZCwdjnPWRLiJW/NRXqynwwpD1AOrDHEzIWbq8DJzc
	 4xAyhPi+t5wtPk/Fjk37WF3ut01fI2a+XExocYs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/196] gpio: vf610: make irq_chip immutable
Date: Mon, 23 Oct 2023 12:57:31 +0200
Message-ID: <20231023104833.639248496@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e6ef4f8ede09f4af7cde000717b349b50bc62576 ]

Since recently, the kernel is nagging about mutable irq_chips:

    "not an immutable chip, please consider fixing it!"

Drop the unneeded copy, flag it as IRQCHIP_IMMUTABLE, add the new
helper functions and call the appropriate gpiolib functions.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 430232619791 ("gpio: vf610: mask the gpio irq in system suspend and support wakeup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 41 ++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 21704eda97ae2..e8e34d648eb2a 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -30,7 +30,6 @@ struct fsl_gpio_soc_data {
 
 struct vf610_gpio_port {
 	struct gpio_chip gc;
-	struct irq_chip ic;
 	void __iomem *base;
 	void __iomem *gpio_base;
 	const struct fsl_gpio_soc_data *sdata;
@@ -207,20 +206,24 @@ static int vf610_gpio_irq_set_type(struct irq_data *d, u32 type)
 
 static void vf610_gpio_irq_mask(struct irq_data *d)
 {
-	struct vf610_gpio_port *port =
-		gpiochip_get_data(irq_data_get_irq_chip_data(d));
-	void __iomem *pcr_base = port->base + PORT_PCR(d->hwirq);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct vf610_gpio_port *port = gpiochip_get_data(gc);
+	irq_hw_number_t gpio_num = irqd_to_hwirq(d);
+	void __iomem *pcr_base = port->base + PORT_PCR(gpio_num);
 
 	vf610_gpio_writel(0, pcr_base);
+	gpiochip_disable_irq(gc, gpio_num);
 }
 
 static void vf610_gpio_irq_unmask(struct irq_data *d)
 {
-	struct vf610_gpio_port *port =
-		gpiochip_get_data(irq_data_get_irq_chip_data(d));
-	void __iomem *pcr_base = port->base + PORT_PCR(d->hwirq);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct vf610_gpio_port *port = gpiochip_get_data(gc);
+	irq_hw_number_t gpio_num = irqd_to_hwirq(d);
+	void __iomem *pcr_base = port->base + PORT_PCR(gpio_num);
 
-	vf610_gpio_writel(port->irqc[d->hwirq] << PORT_PCR_IRQC_OFFSET,
+	gpiochip_enable_irq(gc, gpio_num);
+	vf610_gpio_writel(port->irqc[gpio_num] << PORT_PCR_IRQC_OFFSET,
 			  pcr_base);
 }
 
@@ -237,6 +240,17 @@ static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
 	return 0;
 }
 
+static const struct irq_chip vf610_irqchip = {
+	.name = "gpio-vf610",
+	.irq_ack = vf610_gpio_irq_ack,
+	.irq_mask = vf610_gpio_irq_mask,
+	.irq_unmask = vf610_gpio_irq_unmask,
+	.irq_set_type = vf610_gpio_irq_set_type,
+	.irq_set_wake = vf610_gpio_irq_set_wake,
+	.flags = IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
+};
+
 static void vf610_gpio_disable_clk(void *data)
 {
 	clk_disable_unprepare(data);
@@ -249,7 +263,6 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	struct vf610_gpio_port *port;
 	struct gpio_chip *gc;
 	struct gpio_irq_chip *girq;
-	struct irq_chip *ic;
 	int i;
 	int ret;
 
@@ -315,14 +328,6 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc->direction_output = vf610_gpio_direction_output;
 	gc->set = vf610_gpio_set;
 
-	ic = &port->ic;
-	ic->name = "gpio-vf610";
-	ic->irq_ack = vf610_gpio_irq_ack;
-	ic->irq_mask = vf610_gpio_irq_mask;
-	ic->irq_unmask = vf610_gpio_irq_unmask;
-	ic->irq_set_type = vf610_gpio_irq_set_type;
-	ic->irq_set_wake = vf610_gpio_irq_set_wake;
-
 	/* Mask all GPIO interrupts */
 	for (i = 0; i < gc->ngpio; i++)
 		vf610_gpio_writel(0, port->base + PORT_PCR(i));
@@ -331,7 +336,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	vf610_gpio_writel(~0, port->base + PORT_ISFR);
 
 	girq = &gc->irq;
-	girq->chip = ic;
+	gpio_irq_chip_set_chip(girq, &vf610_irqchip);
 	girq->parent_handler = vf610_gpio_irq_handler;
 	girq->num_parents = 1;
 	girq->parents = devm_kcalloc(&pdev->dev, 1,
-- 
2.42.0



