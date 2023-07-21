Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA3920F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307D2C433C8;
	Fri, 21 Jul 2023 19:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966730;
	bh=A68Y1jlvbs0v/ALc4xBQZpI9JKp1qdq/5ianAjkN7/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahSqkkC8I64qaVA4ZkP+G0SJicGE6yd/Xop4uDHsEkxDQuOXDn2g0uX1FfMMzG4OZ
	 L8GtDq/S/05R1UL9OFqv/QurP8xts3/ap/AfFcSAboPKymEVeoGxnhY6LJT9cf/Lkk
	 lqNFJQQvLOzGxatghudesKKLNmV+M7VnDVW20x8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.15 448/532] pinctrl: amd: Detect and mask spurious interrupts
Date: Fri, 21 Jul 2023 18:05:52 +0200
Message-ID: <20230721160638.844696072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kornel Dulęba <korneld@chromium.org>

commit 0cf9e48ff22e15f3f0882991f33d23ccc5ae1d01 upstream.

Leverage gpiochip_line_is_irq to check whether a pin has an irq
associated with it. The previous check ("irq == 0") didn't make much
sense. The irq variable refers to the pinctrl irq, and has nothing do to
with an individual pin.

On some systems, during suspend/resume cycle, the firmware leaves
an interrupt enabled on a pin that is not used by the kernel.
Without this patch that caused an interrupt storm.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230421120625.3366-4-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -653,21 +653,21 @@ static bool do_amd_gpio_irq_handler(int
 			 * We must read the pin register again, in case the
 			 * value was changed while executing
 			 * generic_handle_domain_irq() above.
-			 * If we didn't find a mapping for the interrupt,
-			 * disable it in order to avoid a system hang caused
-			 * by an interrupt storm.
+			 * If the line is not an irq, disable it in order to
+			 * avoid a system hang caused by an interrupt storm.
 			 */
 			raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 			regval = readl(regs + i);
-			if (irq == 0) {
-				regval &= ~BIT(INTERRUPT_ENABLE_OFF);
+			if (!gpiochip_line_is_irq(gc, irqnr + i)) {
+				regval &= ~BIT(INTERRUPT_MASK_OFF);
 				dev_dbg(&gpio_dev->pdev->dev,
 					"Disabling spurious GPIO IRQ %d\n",
 					irqnr + i);
+			} else {
+				ret = true;
 			}
 			writel(regval, regs + i);
 			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-			ret = true;
 		}
 	}
 	/* did not cause wake on resume context for shared IRQ */


