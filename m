Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232028C1D
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FE5C433CD;
	Mon, 26 Jun 2023 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804365;
	bh=WBr0WNKViwuNr+qWHHZC9kwY9xhA2LnqqlzLVY0tyXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lx5a9nfyLRoFE2n5kr1dGuHGCo9DoJzNPoYRLvBTgwH8cP4J+fSwWlEVtIFz5u9qW
	 putavjW45AnyGDwbscGpRiDfVPtJqQFiq7J3wu10CAWxURwT8DNmNOYSm3Ow3dPoUp
	 IjsFEc4rRHcfQEHS/2zW12Kh/dARaU9xcjvOY0lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Michael Walle <mwalle@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/170] gpiolib: Fix irq_domain resource tracking for gpiochip_irqchip_add_domain()
Date: Mon, 26 Jun 2023 20:11:40 +0200
Message-ID: <20230626180806.455251068@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit ff7a1790fbf92f1bdd0966d3f0da3ea808ede876 ]

Up until commit 6a45b0e2589f ("gpiolib: Introduce
gpiochip_irqchip_add_domain()") all irq_domains were allocated
by gpiolib itself and thus gpiolib also takes care of freeing it.

With gpiochip_irqchip_add_domain() a user of gpiolib can associate an
irq_domain with the gpio_chip. This irq_domain is not managed by
gpiolib and therefore must not be freed by gpiolib.

Fixes: 6a45b0e2589f ("gpiolib: Introduce gpiochip_irqchip_add_domain()")
Reported-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c      | 3 ++-
 include/linux/gpio/driver.h | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f2cb070931850..6d3e3454a6ed6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1650,7 +1650,7 @@ static void gpiochip_irqchip_remove(struct gpio_chip *gc)
 	}
 
 	/* Remove all IRQ mappings and delete the domain */
-	if (gc->irq.domain) {
+	if (!gc->irq.domain_is_allocated_externally && gc->irq.domain) {
 		unsigned int irq;
 
 		for (offset = 0; offset < gc->ngpio; offset++) {
@@ -1696,6 +1696,7 @@ int gpiochip_irqchip_add_domain(struct gpio_chip *gc,
 
 	gc->to_irq = gpiochip_to_irq;
 	gc->irq.domain = domain;
+	gc->irq.domain_is_allocated_externally = true;
 
 	/*
 	 * Using barrier() here to prevent compiler from reordering
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 6aeea1071b1b2..78bcb1639999e 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -244,6 +244,14 @@ struct gpio_irq_chip {
 	 */
 	bool initialized;
 
+	/**
+	 * @domain_is_allocated_externally:
+	 *
+	 * True it the irq_domain was allocated outside of gpiolib, in which
+	 * case gpiolib won't free the irq_domain itself.
+	 */
+	bool domain_is_allocated_externally;
+
 	/**
 	 * @init_hw: optional routine to initialize hardware before
 	 * an IRQ chip will be added. This is quite useful when
-- 
2.39.2



