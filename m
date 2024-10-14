Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45C94CDEC;
	Mon, 14 Oct 2024 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919429; cv=none; b=g9q9x1VPe5nlcG6eTc6JFtkgTeXagJs7jmJ6gbLr96AYUydb5rL9MA7kYPGP5BoMRJ3uSRVybwBnDHkLThH6OEXX4iDc85F1GClyD3xe1G2MZPtdYLi1mUFrQKbdrMX5M7JsLSWjqj/mNTeaulPn7f6qBLM/XfbpPsz9YTTxEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919429; c=relaxed/simple;
	bh=88mrUCNG/pQAPtuTwI/qFxXC8R6C9/LhkgLaWKovz2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPZTfuYchluiYbCBv5qGjd8KL/o7SijIPWZ/33Ybw4hpM1jGF+6DANiTxv8i85PDs6OwiU8Mq8W0EPRVR/rDVZOUaylFYBsdBaEpIIdf+mjrAmCR7r+8DX/zHv/Hqtw9CPhASEImKjFyagtCOvpuE071nAykqyiElC2IEFLdyRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc0GNMcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc0GNMcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243A2C4CEC3;
	Mon, 14 Oct 2024 15:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919429;
	bh=88mrUCNG/pQAPtuTwI/qFxXC8R6C9/LhkgLaWKovz2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oc0GNMcUAuL5NLFcWBLdsLNOL11ikJNBThwNVufPGnf22hCcVZtgsHW9/YcTlic/7
	 6PD1p8YZpRVIWP7qeqOhAGbL8yKvQwAWuhFT2i8Gediz1S7U0eNCK1ntFviGdPgxa6
	 ZAjTJNXXLtt+pLBJ/Kbo7Q8wNQMhF9z2j+IRAHiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Keerthy <j-keerthy@ti.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 607/798] gpio: davinci: fix lazy disable
Date: Mon, 14 Oct 2024 16:19:21 +0200
Message-ID: <20241014141241.860357092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -295,7 +295,7 @@ static int davinci_gpio_probe(struct pla
  * serve as EDMA event triggers.
  */
 
-static void gpio_irq_disable(struct irq_data *d)
+static void gpio_irq_mask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -304,7 +304,7 @@ static void gpio_irq_disable(struct irq_
 	writel_relaxed(mask, &g->clr_rising);
 }
 
-static void gpio_irq_enable(struct irq_data *d)
+static void gpio_irq_unmask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	uintptr_t mask = (uintptr_t)irq_data_get_irq_handler_data(d);
@@ -330,8 +330,8 @@ static int gpio_irq_type(struct irq_data
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
-	.irq_enable	= gpio_irq_enable,
-	.irq_disable	= gpio_irq_disable,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_mask	= gpio_irq_mask,
 	.irq_set_type	= gpio_irq_type,
 	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };


