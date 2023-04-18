Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2B2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8F9C433D2;
	Tue, 18 Apr 2023 12:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820731;
	bh=hDoRuFjWfE8Srb84JAWadR9v0xdVv0XNUmJe7YhANkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpW4pQ0gMcW9cPCBhD2gK9IOdmVpWkdj9efQuTv936tsChzJMETfZ/BqewyAD/Wu0
	 AgYsmIPtf4i79SqJY8D6xkGwx9RDi+4pUanWY1Id2UWLa3IR0xYGNjQARxQeh9Cc53
	 0PITjWoyIUkPRcPMfJozp10tnMA79/yYd6hTT8VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Sandeep Singh <sandeep.singh@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/57] pinctrl: amd: Use irqchip template
Date: Tue, 18 Apr 2023 14:21:02 +0200
Message-Id: <20230418120258.811603994@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e81376ebbafc679a5cea65f25f5ab242172f52df ]

This makes the driver use the irqchip template to assign
properties to the gpio_irq_chip instead of using the
explicit call to gpiochip_irqchip_add().

The irqchip is instead added while adding the gpiochip.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: Sandeep Singh <sandeep.singh@amd.com>
Link: https://lore.kernel.org/r/20200722101545.144373-1-linus.walleij@linaro.org
Stable-dep-of: b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index d76e50bc9d85c..4d283ebaaf230 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -858,6 +858,7 @@ static int amd_gpio_probe(struct platform_device *pdev)
 	int irq_base;
 	struct resource *res;
 	struct amd_gpio *gpio_dev;
+	struct gpio_irq_chip *girq;
 
 	gpio_dev = devm_kzalloc(&pdev->dev,
 				sizeof(struct amd_gpio), GFP_KERNEL);
@@ -921,6 +922,15 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		return PTR_ERR(gpio_dev->pctrl);
 	}
 
+	girq = &gpio_dev->gc.irq;
+	girq->chip = &amd_gpio_irqchip;
+	/* This will let us handle the parent IRQ in the driver */
+	girq->parent_handler = NULL;
+	girq->num_parents = 0;
+	girq->parents = NULL;
+	girq->default_type = IRQ_TYPE_NONE;
+	girq->handler = handle_simple_irq;
+
 	ret = gpiochip_add_data(&gpio_dev->gc, gpio_dev);
 	if (ret)
 		return ret;
@@ -932,17 +942,6 @@ static int amd_gpio_probe(struct platform_device *pdev)
 		goto out2;
 	}
 
-	ret = gpiochip_irqchip_add(&gpio_dev->gc,
-				&amd_gpio_irqchip,
-				0,
-				handle_simple_irq,
-				IRQ_TYPE_NONE);
-	if (ret) {
-		dev_err(&pdev->dev, "could not add irqchip\n");
-		ret = -ENODEV;
-		goto out2;
-	}
-
 	ret = devm_request_irq(&pdev->dev, irq_base, amd_gpio_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, gpio_dev);
 	if (ret)
-- 
2.39.2



