Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBFD1E0B84;
	Wed,  6 Nov 2024 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898557; cv=none; b=YJWWOV/rFNIWCK6plNyhETKPIdZk0UMOC/t3zPT8N7exBr6Tg3/4J1r0krRyrWltjpNVej3BuZc4Wm2rUWX3ipU/CI8lmqw5g89dNvtI0pzKrPhezqn6c7D57/A7dWnwOU619xGkJEnCkMRY31GguxCwFTjAHjqgJv9XDom0/WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898557; c=relaxed/simple;
	bh=bFWtiqE5monq4WVUZZnTlEXx9riq4G+Todjs830zeJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSEaLjIzebR5JW7cWzYY1dM7VtmBlfshuauywCc+iOF9KOZ75C3j9sssK0i5URSitinlW6ivPgO3cMwpQHvrciZC7Y1SvJpwt3YU3+d2vBe2X/yX4NYUx1AmX5UTQuK/3bBUseR39xI/Gwg7gdbrGaVSHpEn3iuNTfHOcl0ZrCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxB6io4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxB6io4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51EAC4CED3;
	Wed,  6 Nov 2024 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898557;
	bh=bFWtiqE5monq4WVUZZnTlEXx9riq4G+Todjs830zeJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxB6io4kejZivcvl7qyXFr5d/HpHXjBlwsPD85QJTqo0iS1xL773pNFidGSCmY0x6
	 oka6jPLtj/6SPPaHckfys1YOcNizjHzYVwqDJIF1D/liA6UeNbuHAtRpm1nJ6+rQeZ
	 1ESdYASt3zTYu25qg9FuvOu6E34IzIsEwEZ5HZw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Keerthy <j-keerthy@ti.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.4 279/462] gpio: davinci: fix lazy disable
Date: Wed,  6 Nov 2024 13:02:52 +0100
Message-ID: <20241106120338.417440165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

commit 3360d41f4ac490282fddc3ccc0b58679aa5c065d upstream.

On a few platforms such as TI's AM69 device, disable_irq() fails to keep
track of the interrupts that happen between disable_irq() and
enable_irq() and those interrupts are missed. Use the ->irq_unmask() and
->irq_mask() methods instead of ->irq_enable() and ->irq_disable() to
correctly keep track of edges when disable_irq is called.

This solves the issue of disable_irq() not working as expected on such
platforms.

Fixes: 23265442b02b ("ARM: davinci: irq_data conversion.")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Parth Pancholi <parth.pancholi@toradex.com>
Acked-by: Keerthy <j-keerthy@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240828133207.493961-1-parth105105@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-davinci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -300,7 +300,7 @@ static int davinci_gpio_probe(struct pla
  * serve as EDMA event triggers.
  */
 
-static void gpio_irq_disable(struct irq_data *d)
+static void gpio_irq_mask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -309,7 +309,7 @@ static void gpio_irq_disable(struct irq_
 	writel_relaxed(mask, &g->clr_rising);
 }
 
-static void gpio_irq_enable(struct irq_data *d)
+static void gpio_irq_unmask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -335,8 +335,8 @@ static int gpio_irq_type(struct irq_data
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
-	.irq_enable	= gpio_irq_enable,
-	.irq_disable	= gpio_irq_disable,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_mask	= gpio_irq_mask,
 	.irq_set_type	= gpio_irq_type,
 	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };


