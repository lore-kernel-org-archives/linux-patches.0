Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3AB3806B8;
	Tue, 10 Mar 2026 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141645; cv=none; b=q+pv3b4NGOCLfQBVs6/BmX6RYnLSqO9t33h1ON7l3NSS/XwGIl9fXr5EfIre9UoNe2NUdK4j03hfyhfd0nb1KLWZRRCTv9nsgayWdlL2jC8hBX42crA7l1zRTwuuWMpWcL5eSjtIVczWu2BhXPuDIMaqe9UNRuqo5SO7JO7fmHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141645; c=relaxed/simple;
	bh=BE74fN+FOZjaIuv2qKIDv1miYH6l402vrszMo7RQBwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjUCDyshg2MvIMj0GUBzLRTWFjHJ72P5zU502yQIeGuQSbJ+qV2a0B4m9R8Ze1hc8LfKv+MPI90XD5MR0ya/yilCdIynC6sZKVtZPdiYEuJrfn3dxUDCoklEnOAGJ6dk7h3l6b1Wa2/AeylFZKJyzkvyB00JD8AbtxEOB9mdcWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZkXesl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZkXesl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D55C2BC86;
	Tue, 10 Mar 2026 11:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141644;
	bh=BE74fN+FOZjaIuv2qKIDv1miYH6l402vrszMo7RQBwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZkXesl1ja1FDX1eAlXkpbssTPBsf6zupNdA1weA/B1s9TbbWQ1vN1WICiuTqY8Vq
	 Y13BhTgd13lumTj0g4Y6nu9/nBrwurXPmm8rS4oMxSp4rx+JvPTZ/OPdhN4C7JJTYb
	 5dwvq7MdpbZjQt6JpqKRbhSuJjRpuWcDakYRdOWBgTCHzX5pDjVrmmAe5FYgo+YrOk
	 zLElCrnIKd3RomZId42KBrbbAFGbinRlMS/knV0M0KjO0Y1uWoRUBWuzWpnlnWPkOI
	 eGEleAn8MApbwsdk29fpz7HoogOwrA/8nynWsgNl5hNY8CbNjROSI308kVA/ucVVBJ
	 xBPlOTQD29vTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/314] irqchip/sifive-plic: Fix frozen interrupt due to affinity setting
Date: Tue, 10 Mar 2026 07:14:29 -0400
Message-ID: <c000bf2f372f224d9d181945838ec4a15537c6bb.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 1072020685f4b81f6efad3b412cdae0bd62bb043 ]

PLIC ignores interrupt completion message for disabled interrupt, explained
by the specification:

    The PLIC signals it has completed executing an interrupt handler by
    writing the interrupt ID it received from the claim to the
    claim/complete register. The PLIC does not check whether the completion
    ID is the same as the last claim ID for that target. If the completion
    ID does not match an interrupt source that is currently enabled for
    the target, the completion is silently ignored.

This caused problems in the past, because an interrupt can be disabled
while still being handled and plic_irq_eoi() had no effect. That was fixed
by checking if the interrupt is disabled, and if so enable it, before
sending the completion message. That check is done with irqd_irq_disabled().

However, that is not sufficient because the enable bit for the handling
hart can be zero despite irqd_irq_disabled(d) being false. This can happen
when affinity setting is changed while a hart is still handling the
interrupt.

This problem is easily reproducible by dumping a large file to uart (which
generates lots of interrupts) and at the same time keep changing the uart
interrupt's affinity setting. The uart port becomes frozen almost
instantaneously.

Fix this by checking PLIC's enable bit instead of irqd_irq_disabled().

Fixes: cc9f04f9a84f ("irqchip/sifive-plic: Implement irq_set_affinity() for SMP host")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260212114125.3148067-1-namcao@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index cbd7697bc1481..0799c15c745d4 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -154,8 +154,13 @@ static void plic_irq_disable(struct irq_data *d)
 static void plic_irq_eoi(struct irq_data *d)
 {
 	struct plic_handler *handler = this_cpu_ptr(&plic_handlers);
+	u32 __iomem *reg;
+	bool enabled;
+
+	reg = handler->enable_base + (d->hwirq / 32) * sizeof(u32);
+	enabled = readl(reg) & BIT(d->hwirq % 32);
 
-	if (unlikely(irqd_irq_disabled(d))) {
+	if (unlikely(!enabled)) {
 		plic_toggle(handler, d->hwirq, 1);
 		writel(d->hwirq, handler->hart_base + CONTEXT_CLAIM);
 		plic_toggle(handler, d->hwirq, 0);
-- 
2.51.0

