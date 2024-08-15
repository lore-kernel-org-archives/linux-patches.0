Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B60E17BEC0;
	Thu, 15 Aug 2024 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732690; cv=none; b=VXGRw4oL/wPftcZ67ezSay6A6YAxvbFNcygXy++uaWMDk7N7gBuxt0V5IkkBQx548uofKnaCJ/8pAk6YB99jnx4qom4uezJD5ZwoANthc5ecxV9CBRQnNp+XTydTEHFYaP5U0kMcBjF26D41QqXrY8NorlQPj2yusQ3M8kowZ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732690; c=relaxed/simple;
	bh=vImAuHCCvHBwvnvnQNW4gWSlTxNeh5KNcLAxpRy3hK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvJzAS7p8rLr6zNW77GjGpOSSgGgjiCRndwdswo8kCkEguUs2ahgsR5PHEH7X/XxXuR4kwBfFTE3SN4OIyxzJJ5SD52UNPGCUqwjifNjJs+k+AJ7gWA/DLoZQ/8ZW2wswq2HuRPjyW4OF4IB2ixzyXg3R78DJ9B2Y7cBgjsBoq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNQwpnYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNQwpnYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFB1C32786;
	Thu, 15 Aug 2024 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732690;
	bh=vImAuHCCvHBwvnvnQNW4gWSlTxNeh5KNcLAxpRy3hK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNQwpnYh6fQa+BqjYVxooxIxtIeOUYgANTmlSdCdnGyJmn8QDX57N7stuex1yPpwy
	 1NA8m1etj6IlXSy2qF9+4RM++VJiWxUvoNj+qlgsr7AQgS+FBSa4TkBaQ5c1/37wLB
	 rStAHR0WzBhtUXlICsXa+0/3Q19XPvyl4S0giLi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 249/352] genirq: Allow irq_chip registration functions to take a const irq_chip
Date: Thu, 15 Aug 2024 15:25:15 +0200
Message-ID: <20240815131929.061439530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 393e1280f765661cf39785e967676a4e57324126 ]

In order to let a const irqchip be fed to the irqchip layer, adjust
the various prototypes. An extra cast in irq_set_chip()() is required
to avoid a warning.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220209162607.1118325-3-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq.h | 7 ++++---
 kernel/irq/chip.c   | 9 +++------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index b89a8ac83d1bc..eb7af809e6e53 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -708,10 +708,11 @@ extern struct irq_chip no_irq_chip;
 extern struct irq_chip dummy_irq_chip;
 
 extern void
-irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+irq_set_chip_and_handler_name(unsigned int irq, const struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name);
 
-static inline void irq_set_chip_and_handler(unsigned int irq, struct irq_chip *chip,
+static inline void irq_set_chip_and_handler(unsigned int irq,
+					    const struct irq_chip *chip,
 					    irq_flow_handler_t handle)
 {
 	irq_set_chip_and_handler_name(irq, chip, handle, NULL);
@@ -801,7 +802,7 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 }
 
 /* Set/get chip/data for an IRQ: */
-extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
+extern int irq_set_chip(unsigned int irq, const struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b8aa9e22105f9..09b91aebb90b1 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -38,7 +38,7 @@ struct irqaction chained_action = {
  *	@irq:	irq number
  *	@chip:	pointer to irq chip description structure
  */
-int irq_set_chip(unsigned int irq, struct irq_chip *chip)
+int irq_set_chip(unsigned int irq, const struct irq_chip *chip)
 {
 	unsigned long flags;
 	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
@@ -46,10 +46,7 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 	if (!desc)
 		return -EINVAL;
 
-	if (!chip)
-		chip = &no_irq_chip;
-
-	desc->irq_data.chip = chip;
+	desc->irq_data.chip = (struct irq_chip *)(chip ?: &no_irq_chip);
 	irq_put_desc_unlock(desc, flags);
 	/*
 	 * For !CONFIG_SPARSE_IRQ make the irq show up in
@@ -1102,7 +1099,7 @@ irq_set_chained_handler_and_data(unsigned int irq, irq_flow_handler_t handle,
 EXPORT_SYMBOL_GPL(irq_set_chained_handler_and_data);
 
 void
-irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+irq_set_chip_and_handler_name(unsigned int irq, const struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name)
 {
 	irq_set_chip(irq, chip);
-- 
2.43.0



