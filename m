Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD63ACEFE;
	Mon, 23 Mar 2026 14:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275144; cv=none; b=W/vCAPDpRi0yVRYbH0TPyPzNzJzBmJAm0kpJ9lA/VA4d01t5mYjF3a2ietZHQjY+s+jT7WsqjRTXaixo0qVMeaD2U2tDH8RuGV/ajhRguiNGwSb/abiELXhSvwkvE4C3v3+A0pwlE44cYusUNwsfxDAn6Lm2TN3hwpdkMUCostk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275144; c=relaxed/simple;
	bh=2IcMpzmMGEyup/DUxmFp7NTwau2lNttOH1OrC3qBblU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D99jXW0p8wAmAAVfkPzlFfEENRCfAYURNSnhl1maQ2yG5bp26TW+62+8pWtgTtGnhnYCmAjEJrFwYeodrlHnlccs3QFvuPPI3GyMWzzC0QICDW8dos0JTIWj513Z4WoMURVg2P0YFJ4OTFIyaIv5VImhp6zJbCuL1VPfKCQPSfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kyx9ya+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kyx9ya+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA317C4CEF7;
	Mon, 23 Mar 2026 14:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275144;
	bh=2IcMpzmMGEyup/DUxmFp7NTwau2lNttOH1OrC3qBblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kyx9ya+7OkdWW7CGTKiIk4SXr3VbAiSAi9WnQJTdYHTl/vCASk/h6AkF8DaYJOfiM
	 AYfUX78ZDp5wb7HS/b7bW7W7cG4/QtHLh9svBsO41VzjYYLo8PjwVcBWcLf6hJ337u
	 UNXzxQioOzoUrou535X8Va+DeZLHGIguLE5cF8VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/567] irqchip/sifive-plic: Fix frozen interrupt due to affinity setting
Date: Mon, 23 Mar 2026 14:38:44 +0100
Message-ID: <20260323134533.856906030@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index a8f5cfad16f7d..794bdb6d4d1e3 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -148,8 +148,13 @@ static void plic_irq_disable(struct irq_data *d)
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



