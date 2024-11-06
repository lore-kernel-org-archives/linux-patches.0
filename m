Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1449A1DED49;
	Wed,  6 Nov 2024 12:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895532; cv=none; b=Wmov0sSTjOf0ovOHHE9MIBH+tTxuUQWT2LHPotPX071nXdck2x5yBC1i9cuIEqn9E036eNmZnAhAhcqbcOcpCi0+qtrm06hUh8xjq+wqlouKWc8R1KaHA452ZAWkVG7YNbH0kERFjc4vMRTW/zRkzOVHMmlfggjvuCWUwQwlrLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895532; c=relaxed/simple;
	bh=5bbjOjhh1CZ1hEYIetHziDGS8Pq4pJItNFX0TF+O1TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyiIet0Jy6KNg4IkGxpxcbAFtHd1pO1jyqRn3krEp+ap/IctwYy1ZdmaWOI3eC4ehsqVqfBMq/ufUgQjAQeALoTn3GeD5Gwq7qnTgaNWBpIUmEAAti/zV/ap2tnPL3AKIKb4leXbq88XgL1CZSkHNtgMI1jw+5GgPUl0XMm4t7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V3t6z/Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V3t6z/Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9027CC4CECD;
	Wed,  6 Nov 2024 12:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895532;
	bh=5bbjOjhh1CZ1hEYIetHziDGS8Pq4pJItNFX0TF+O1TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V3t6z/Dy/hF5zInmbnIUYIT3PZUutrf+dQHF5brBIceb8RtmHSXueWKguVdRrg0YX
	 xlTbtGXK750xTkWPVD5otC3i6Rw9xkU174Hg4D2QGrtZcG7U+HuDLZLr+qS7jGfI2X
	 D9lQG0zItOq9oe7lffrn8aScnUBM4rmfehD5Z/n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Keerthy <j-keerthy@ti.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 4.19 213/350] gpio: davinci: fix lazy disable
Date: Wed,  6 Nov 2024 13:02:21 +0100
Message-ID: <20241106120326.258013521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,7 +294,7 @@ err:
  * serve as EDMA event triggers.
  */
 
-static void gpio_irq_disable(struct irq_data *d)
+static void gpio_irq_mask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	u32 mask = (u32) irq_data_get_irq_handler_data(d);
@@ -303,7 +303,7 @@ static void gpio_irq_disable(struct irq_
 	writel_relaxed(mask, &g->clr_rising);
 }
 
-static void gpio_irq_enable(struct irq_data *d)
+static void gpio_irq_unmask(struct irq_data *d)
 {
 	struct davinci_gpio_regs __iomem *g = irq2regs(d);
 	u32 mask = (u32) irq_data_get_irq_handler_data(d);
@@ -329,8 +329,8 @@ static int gpio_irq_type(struct irq_data
 
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
-	.irq_enable	= gpio_irq_enable,
-	.irq_disable	= gpio_irq_disable,
+	.irq_unmask	= gpio_irq_unmask,
+	.irq_mask	= gpio_irq_mask,
 	.irq_set_type	= gpio_irq_type,
 	.flags		= IRQCHIP_SET_TYPE_MASKED | IRQCHIP_SKIP_SET_WAKE,
 };


