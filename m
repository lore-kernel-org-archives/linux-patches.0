Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3115219F47A;
	Thu, 15 Aug 2024 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730264; cv=none; b=apVRkwaU08lj4Tnda2t45dVg61N2Ftjk7LCarTjqFcPcoZTamvZljILs7ph6WArDkXjHaNMBvmhgjYhrbCnNvQhMPL46aF/LCzx2puaknOdCbKkVNyEr1KL/Ud9T73kEyhGNZQt3BkFNRxxwH6kOVtqXckc53PdXfNfHvkUBhqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730264; c=relaxed/simple;
	bh=WF8zw4iQ9ad+Aj2yuZI7PjkyM51jXSzIiBrHIDTwixI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajjCUjGnOsaI+DtV32rZo5v1iU/ytmgKb2mOiBxR+zHnsrUG0e1GBJiFD8hLf/8gFONT0aW6m/lbM+NFFmKOCsLpYUdixiEFCg7009HvLNwiDkgtfuz3ZAkIeM7E7cSp32INKZvei/pJI0TOivCQdS1S7+pW0yBzIk+yvVB5rJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SAs9HH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SAs9HH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D82C32786;
	Thu, 15 Aug 2024 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730264;
	bh=WF8zw4iQ9ad+Aj2yuZI7PjkyM51jXSzIiBrHIDTwixI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SAs9HH7GKxfvgPlwjyRllQ3XG7DIJhHCUqnFL3238h+YUBoiyllajqMjcjVcydwZ
	 DozLElFXwngUaa/jAFgiQdW8Q0jjOPetv+S3XPbEBMNR2tkEn9RdSJdPNGgwpKewOh
	 1rpfKRPKfV3EMEZbusGiO3KVAGmNAwwpFYX34UAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/484] genirq: Allow irq_chip registration functions to take a const irq_chip
Date: Thu, 15 Aug 2024 15:23:32 +0200
Message-ID: <20240815131955.100470699@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f9e6449fbbbae..4fd8d900a1b86 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -709,10 +709,11 @@ extern struct irq_chip no_irq_chip;
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
@@ -802,7 +803,7 @@ static inline void irq_set_percpu_devid_flags(unsigned int irq)
 }
 
 /* Set/get chip/data for an IRQ: */
-extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
+extern int irq_set_chip(unsigned int irq, const struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
 extern int irq_set_chip_data(unsigned int irq, void *data);
 extern int irq_set_irq_type(unsigned int irq, unsigned int type);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 7ea66e55ef86b..0a893df1b8099 100644
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
@@ -1075,7 +1072,7 @@ irq_set_chained_handler_and_data(unsigned int irq, irq_flow_handler_t handle,
 EXPORT_SYMBOL_GPL(irq_set_chained_handler_and_data);
 
 void
-irq_set_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
+irq_set_chip_and_handler_name(unsigned int irq, const struct irq_chip *chip,
 			      irq_flow_handler_t handle, const char *name)
 {
 	irq_set_chip(irq, chip);
-- 
2.43.0



