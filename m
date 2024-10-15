Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F9E1E6329;
	Tue, 15 Oct 2024 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998220; cv=none; b=YpODJGi6tDZPvxpfWYt3+17Is+U+CyPzgVsKMzO9oiD/h+Ytk9CNdBDZ39g4lOiPkR0zb9DLlxQAKa8pBddxtv0JdrKZq9X4hmKFeQ+7+GiYdYDDp+f7FJZN5Ep1BMUe57qQs9OhSBXerbp0PR4QePZnLRlxOeMIOWUItsUWmLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998220; c=relaxed/simple;
	bh=ttI6mlqxlmrqu/cGc6BTRupd7ghjM6i5t4VA6uN+LJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxNFXaV1cjbVg6VghkbA1scb+CoUyTXPmJk6JREq8KY2sfIaWagtiPOn3b3ix35EBWQIqva1frf3rrgSMsccjyxoxHhyCIhrfDwkyd+inQRRm5Mb7ySm2yzo09g47nDzPkyQDJbqUSZfge8UddV0zNmZ8/mpEhBCjFxkQ3fo9qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2xjVyF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2xjVyF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A3CC4CEC6;
	Tue, 15 Oct 2024 13:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998220;
	bh=ttI6mlqxlmrqu/cGc6BTRupd7ghjM6i5t4VA6uN+LJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2xjVyF637C007Q+EidqR9Hj3nTp4vimXjODveKWGe6zV74sJ6qDwnqzk1dzqZ0xN
	 MfFvdR/VJKKeMLTCbBDHnNB7ODrf6rFtTGvN0s/Llpi9etDmzIgnupCGAawUXrZsR4
	 9QKUOOOd7U5rh5ZpO2n4TWCpT6NDFwJurRHQ/XdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Keerthy <j-keerthy@ti.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 5.10 414/518] gpio: davinci: fix lazy disable
Date: Tue, 15 Oct 2024 14:45:18 +0200
Message-ID: <20241015123932.973680237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -293,7 +293,7 @@ static int davinci_gpio_probe(struct pla
  * serve as EDMA event triggers.
  */
 
-static void gpio_irq_disable(struct irq_data *d)
+static void gpio_irq_mask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -302,7 +302,7 @@ static void gpio_irq_disable(struct irq_
 	writel_relaxed(mask, &g->clr_rising);
 }
 
-static void gpio_irq_enable(struct irq_data *d)
+static void gpio_irq_unmask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -328,8 +328,8 @@ static int gpio_irq_type(struct irq_data
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
-	.irq_enable	= gpio_irq_enable,
-	.irq_disable	= gpio_irq_disable,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_mask	= gpio_irq_mask,
 	.irq_set_type	= gpio_irq_type,
 	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };


