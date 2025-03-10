Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404A6231A2A;
	Mon, 10 Mar 2025 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629253; cv=none; b=e/Uh/wdCPYOEjV+lX+EHFJbYt4bfBmvBJR7SXkxxjk6rxuuvjJdNoladAAPXurmCBe8nx5ZJW6ronOl1HBgLTVWORyKxbeRQRZTJ9h0bgCgQXg2v0ct92hg6lUB1tRp3XRV2cVC4J8eqfZY/t7L0RDZ4PrMr4H7XH0j8GoE0DEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629253; c=relaxed/simple;
	bh=oPzarWIX/yqH8RsVUtzz4nLlersf9RZP+C3brK3gaZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlNKCcsViEpa+2WBhhRjkRCwwZp6K8/KCyke2Xlw5xj3VVlEI/DLy79BH/ekIPrYPUKp2KtIzvQRvym0aAiGyx/J106wHrSOrqO3+p1Jy1rzIEBf5NLEix6WxYM1/W/qw8gMVqgiho1caVH47KvUGucINSg0W//I1qy7JGBfkb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reJ9/EZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reJ9/EZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1F8C4CEE5;
	Mon, 10 Mar 2025 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629253;
	bh=oPzarWIX/yqH8RsVUtzz4nLlersf9RZP+C3brK3gaZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reJ9/EZx/PwBCmMkdqF5oKJLKFLNTQ21bur7p4LpVDG4oQl37lpaM/HA4QbSrzoCs
	 cJFR9u73jhFUrLgsRqFKG/s0Wan7hE3M5wAkXLxK1D20WiGdw2sUaTfBQ82TyaYlmC
	 oOwG64w3sMwRo3jmsG0N3IIO18ux/Xcq4LPz2jvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/620] gpio: Dont fiddle with irqchips marked as immutable
Date: Mon, 10 Mar 2025 18:01:17 +0100
Message-ID: <20250310170554.752785231@linuxfoundation.org>
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

[ Upstream commit 6c846d026d490b2383d395bc8e7b06336219667b ]

In order to move away from gpiolib messing with the internals of
unsuspecting irqchips, add a flag by which irqchips advertise
that they are not to be messed with, and do solemnly swear that
they correctly call into the gpiolib helpers when required.

Also nudge the users into converting their drivers to the
new model.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220419141846.598305-2-maz@kernel.org
Stable-dep-of: 9860370c2172 ("gpio: xilinx: Convert gpio_lock to raw spinlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 7 ++++++-
 include/linux/irq.h    | 2 ++
 kernel/irq/debugfs.c   | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5eb4edcf03bd4..631eaf2e418a7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1484,6 +1484,11 @@ static void gpiochip_set_irq_hooks(struct gpio_chip *gc)
 {
 	struct irq_chip *irqchip = gc->irq.chip;
 
+	if (irqchip->flags & IRQCHIP_IMMUTABLE)
+		return;
+
+	chip_warn(gc, "not an immutable chip, please consider fixing it!\n");
+
 	if (!irqchip->irq_request_resources &&
 	    !irqchip->irq_release_resources) {
 		irqchip->irq_request_resources = gpiochip_irq_reqres;
@@ -1651,7 +1656,7 @@ static void gpiochip_irqchip_remove(struct gpio_chip *gc)
 		irq_domain_remove(gc->irq.domain);
 	}
 
-	if (irqchip) {
+	if (irqchip && !(irqchip->flags & IRQCHIP_IMMUTABLE)) {
 		if (irqchip->irq_request_resources == gpiochip_irq_reqres) {
 			irqchip->irq_request_resources = NULL;
 			irqchip->irq_release_resources = NULL;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 4fd8d900a1b86..38399d7f508fd 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -570,6 +570,7 @@ struct irq_chip {
  * IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND:  Invokes __enable_irq()/__disable_irq() for wake irqs
  *                                    in the suspend path if they are in disabled state
  * IRQCHIP_AFFINITY_PRE_STARTUP:      Default affinity update before startup
+ * IRQCHIP_IMMUTABLE:		      Don't ever change anything in this chip
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED			= (1 <<  0),
@@ -583,6 +584,7 @@ enum {
 	IRQCHIP_SUPPORTS_NMI			= (1 <<  8),
 	IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND	= (1 <<  9),
 	IRQCHIP_AFFINITY_PRE_STARTUP		= (1 << 10),
+	IRQCHIP_IMMUTABLE			= (1 << 11),
 };
 
 #include <linux/irqdesc.h>
diff --git a/kernel/irq/debugfs.c b/kernel/irq/debugfs.c
index e4cff358b437e..7ff52d94b42c0 100644
--- a/kernel/irq/debugfs.c
+++ b/kernel/irq/debugfs.c
@@ -58,6 +58,7 @@ static const struct irq_bit_descr irqchip_flags[] = {
 	BIT_MASK_DESCR(IRQCHIP_SUPPORTS_LEVEL_MSI),
 	BIT_MASK_DESCR(IRQCHIP_SUPPORTS_NMI),
 	BIT_MASK_DESCR(IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND),
+	BIT_MASK_DESCR(IRQCHIP_IMMUTABLE),
 };
 
 static void
-- 
2.39.5



