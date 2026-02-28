Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8EB43636C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301172; cv=none; b=lITzbGqzMNVzMaD4PJq702z4/HPflpmxUcNam1MjhKQ8KofsTQtEy/mpJVsjDiM0IM3DmbEPmme7ZyZ6TyfPYt0eWz3sQMudDUOAWJCA+76J8FxaWisVlrTlBl0+FQOAP3wJ/kJAqeUwa5BINDrlPaFrIYjnD5NPNKRPlQq+Lis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301172; c=relaxed/simple;
	bh=qYY5KZcVhFNSaC2+oVYe4f/Hum3GSfx7BicdPiwDZd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK1B1604Lbv1ubMUOz8Vv2nSc4KgAXkOrIhYFZQW4B8TeSleu8JK9SkhGXYgg+uQ3xskuYLNC0BdMgob73CMBWlxvfzUrAhTEq6RPhVxaomhwar6oXkWdPKwZUmGhhM+zGnZ0SvQR/ErBRjSrwmUOALPTcXm2LDB5SLgdPmPvFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGDG5Oy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGDG5Oy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9053C19423;
	Sat, 28 Feb 2026 17:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301172;
	bh=qYY5KZcVhFNSaC2+oVYe4f/Hum3GSfx7BicdPiwDZd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGDG5Oy0C/3Pf/t32oHGMcGlpaZ9qL0Z8f7hHziJ+RsU7idl+7LCYGDK5iAiChW4x
	 qKTukzbF9DPvLUJBFA2HQyqw5VNcgsxig4C3xnynX0zS0nj+VKcYf779/olMPlH25t
	 xpyF3pclnnqP1JkwodWO2RwQ2pHs1dehhwyK/EkW1J7qPG5pt90BmEdhTDVe2cZBAk
	 VaLC09WZnVlLNJY4C9VwB0eE0y6ofMPmnX8NIMABjGTUC55EUXrVkoEf7fjTh5HBOW
	 KTZIG6Lm9zUgCY+Qq7+3csRVg8z9FiAR/T79zQTlCTzaK26cZpr+1RenUQ3WaaS8zD
	 MDUjzGuzoT95w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 339/752] pinctrl: renesas: rzt2h: Allow .get_direction() for IRQ function GPIOs
Date: Sat, 28 Feb 2026 12:40:50 -0500
Message-ID: <20260228174750.1542406-339-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 49b039a61a314c18074c15a7047705399e1240e6 ]

Setting up an IRQ would normally be done in the .activate() and
.deactivate() ops of the IRQ domain, but for hierarchical IRQ domains
the .activate() and .deactivate() ops are overridden in the
gpiochip_hierarchy_setup_domain_ops() function.

As such, activating and deactivating need to be done in the .translate()
and .free() ops of the IRQ domain.

For RZ/T2H and RZ/N2H, interrupts go through the pin controller, into
the ICU, which level-translates them and forwards them to the GIC.

To use a GPIO as an interrupt it needs to be put into peripheral
function mode 0, which will connect it to the IRQ lines of the ICU.

The IRQ chip .child_to_parent_hwirq() callback is called as part of the
IRQ fwspec parsing logic (as part of irq_create_of_mapping()) which
happens before the IRQ is requested (as part of gpiochip_lock_as_irq()).

gpiochip_lock_as_irq() calls gpiod_get_direction() if the
.get_direction() callback is provided to ensure that the GPIO line is
set up as input.

In our case, IRQ function is separate from GPIO, and both cannot be true
at the same time.

Return GPIO_LINE_DIRECTION_IN even if pin is in IRQ function to allow
this setup to work.

Hold the spinlock to ensure atomicity between reading the PMC register
(which determines whether the pin is in GPIO mode or not) and reading
the function of the pin when it is not in GPIO mode.

Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251205150234.2958140-3-cosmin-gabriel.tanislav.xa@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzt2h.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzt2h.c b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
index 3872638f5ebb3..3161b2469c362 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzt2h.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzt2h.c
@@ -51,6 +51,7 @@
 
 #define PFC_MASK		GENMASK_ULL(5, 0)
 #define PFC_PIN_MASK(pin)	(PFC_MASK << ((pin) * 8))
+#define PFC_FUNC_INTERRUPT	0
 
 /*
  * Use 16 lower bits [15:0] for pin identifier
@@ -486,6 +487,7 @@ static int rzt2h_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 	struct rzt2h_pinctrl *pctrl = gpiochip_get_data(chip);
 	u8 port = RZT2H_PIN_ID_TO_PORT(offset);
 	u8 bit = RZT2H_PIN_ID_TO_PIN(offset);
+	u64 reg64;
 	u16 reg;
 	int ret;
 
@@ -493,8 +495,25 @@ static int rzt2h_gpio_get_direction(struct gpio_chip *chip, unsigned int offset)
 	if (ret)
 		return ret;
 
-	if (rzt2h_pinctrl_readb(pctrl, port, PMC(port)) & BIT(bit))
+	guard(spinlock_irqsave)(&pctrl->lock);
+
+	if (rzt2h_pinctrl_readb(pctrl, port, PMC(port)) & BIT(bit)) {
+		/*
+		 * When a GPIO is being requested as an IRQ, the pinctrl
+		 * framework expects to be able to read the GPIO's direction.
+		 * IRQ function is separate from GPIO, and enabling it takes the
+		 * pin out of GPIO mode.
+		 * At this point, .child_to_parent_hwirq() has already been
+		 * called to enable the IRQ function.
+		 * Default to input direction for IRQ function.
+		 */
+		reg64 = rzt2h_pinctrl_readq(pctrl, port, PFC(port));
+		reg64 = (reg64 >> (bit * 8)) & PFC_MASK;
+		if (reg64 == PFC_FUNC_INTERRUPT)
+			return GPIO_LINE_DIRECTION_IN;
+
 		return -EINVAL;
+	}
 
 	reg = rzt2h_pinctrl_readw(pctrl, port, PM(port));
 	reg = (reg >> (bit * 2)) & PM_MASK;
-- 
2.51.0

