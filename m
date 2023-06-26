Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E263511CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AD9C433C8;
	Mon, 26 Jun 2023 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805128;
	bh=hkcHD/nxlAepqxYUrWHyvZbA4ZcM4Q/GWVroJj3Nims=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQTyNSdFkEzw4/GrSDvrcI8TWqEWz8SVc/vvTe+StH2iiy/jiZ9umO3VZ+h5hJtVl
	 pdjBNnhIc3lQBZSG6RHQW/jxx8yLlsLIslhg5F6V17W8OZ1rNdVrxrK57RWwK8LfbB
	 LPJ/O7+n2Kg761rDVl6wOkjeX3Ga3YnKDJjRV+Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/81] gpiolib: Fix GPIO chip IRQ initialization restriction
Date: Mon, 26 Jun 2023 20:12:41 +0200
Message-ID: <20230626180746.873827965@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 8c00914e5438e3636f26b4f814b3297ae2a1b9ee ]

In case of gpio-regmap, IRQ chip is added by regmap-irq and associated with
GPIO chip by gpiochip_irqchip_add_domain(). The initialization flag was not
added in gpiochip_irqchip_add_domain(), causing gpiochip_to_irq() to return
-EPROBE_DEFER.

Fixes: 5467801f1fcb ("gpio: Restrict usage of GPIO chip irq members before initialization")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7ac86037a4191..d10f621085e2e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1792,6 +1792,14 @@ int gpiochip_irqchip_add_domain(struct gpio_chip *gc,
 	gc->to_irq = gpiochip_to_irq;
 	gc->irq.domain = domain;
 
+	/*
+	 * Using barrier() here to prevent compiler from reordering
+	 * gc->irq.initialized before adding irqdomain.
+	 */
+	barrier();
+
+	gc->irq.initialized = true;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_irqchip_add_domain);
-- 
2.39.2



