Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F360F22FAF8;
	Mon, 10 Mar 2025 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629256; cv=none; b=arXIfNu+1ueAPDTrl+gAEHjTJFwosiraMymrCqwOiXebuUR3gSJJ4jDgRW1lH+nE99HUnudFKUKRjAYSff6fr3zis5nOhu5o4zrZz4yDwDVyH/+FeeXy8D43hJIyGu6soJISp05+LzMw+ZnsOEq7rNPb+fohT5Y0PyCpVoB362E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629256; c=relaxed/simple;
	bh=UoE1jVe/HT8PvDGIFA72OB+w+3ewKfH2HKf163amsSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb1rAy9MQaMuNtsgiW+k3JJrWYIaoqoZzNxjn/o6pLX67QWzbbtqgUD8PQhKoAnP1JqxFPp5kUUmy28sA1qIYZETJatV/IW4QnwjrpzZvqA0BJssZLm/T52jwZix5vQeiD43bOgiB3v8TNSH23r4H9CPnAFdnXOy1vQMe8GBvso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2NCuXG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2NCuXG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F04EC4CEE5;
	Mon, 10 Mar 2025 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629255;
	bh=UoE1jVe/HT8PvDGIFA72OB+w+3ewKfH2HKf163amsSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2NCuXG0UxzhiuUa5QuFom19v0uSLdpXKqD8X30bYNw13CVm6ssttcMfkjfjW6Lsd
	 jSrw9rP4wDFUzHAFfrfirGd5yo9C+5fxxqz2jkW/0lRYcjONAtjR2DhfPwC9J4zQ3E
	 4PaF9k6QGBug/Y3TYeytCLijZD1sqtl3kMVHX9BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/620] gpio: Expose the gpiochip_irq_re[ql]res helpers
Date: Mon, 10 Mar 2025 18:01:18 +0100
Message-ID: <20250310170554.794470127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 704f08753b6dcd0e08c1953af0b2c7f3fac87111 ]

The GPIO subsystem has a couple of internal helpers to manage
resources on behalf of the irqchip. Expose them so that GPIO
drivers can use them directly.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220419141846.598305-3-maz@kernel.org
Stable-dep-of: 9860370c2172 ("gpio: xilinx: Convert gpio_lock to raw spinlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c      | 6 ++++--
 include/linux/gpio/driver.h | 4 ++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 631eaf2e418a7..d1e553529b354 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1432,19 +1432,21 @@ static int gpiochip_to_irq(struct gpio_chip *gc, unsigned int offset)
 	return irq_create_mapping(domain, offset);
 }
 
-static int gpiochip_irq_reqres(struct irq_data *d)
+int gpiochip_irq_reqres(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 
 	return gpiochip_reqres_irq(gc, d->hwirq);
 }
+EXPORT_SYMBOL(gpiochip_irq_reqres);
 
-static void gpiochip_irq_relres(struct irq_data *d)
+void gpiochip_irq_relres(struct irq_data *d)
 {
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 
 	gpiochip_relres_irq(gc, d->hwirq);
 }
+EXPORT_SYMBOL(gpiochip_irq_relres);
 
 static void gpiochip_irq_mask(struct irq_data *d)
 {
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 65df2ce96f0b1..b241fc23ff3a2 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -595,6 +595,10 @@ void gpiochip_relres_irq(struct gpio_chip *gc, unsigned int offset);
 void gpiochip_disable_irq(struct gpio_chip *gc, unsigned int offset);
 void gpiochip_enable_irq(struct gpio_chip *gc, unsigned int offset);
 
+/* irq_data versions of the above */
+int gpiochip_irq_reqres(struct irq_data *data);
+void gpiochip_irq_relres(struct irq_data *data);
+
 /* Line status inquiry for drivers */
 bool gpiochip_line_is_open_drain(struct gpio_chip *gc, unsigned int offset);
 bool gpiochip_line_is_open_source(struct gpio_chip *gc, unsigned int offset);
-- 
2.39.5



