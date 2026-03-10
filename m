Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92534B197;
	Tue, 10 Mar 2026 11:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140776; cv=none; b=FtTCB/6zyHrBHRn9hAvYhuJfpDtFLqMoDPOALi23HoN/LWfYEvyTmSSX2mParDCwwCR5NKjwHjYRS95MU9rSYkw9AldxDYVQOvZMTIpbcR1W7ASc0ftKdhc4OF829szBLnL+VyFjUPEhqKCa8m1/KnAt/9CL1n7jw/Vhk0UOVM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140776; c=relaxed/simple;
	bh=DLOsGLDJnPqPJeL3NW6eoY4krzxmhzyx9QmW4ff8HNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsxBc7A4e6t2SxqJ9aSBqxIKC4xIJg0gF8/GtZo2/k14NnespNxVOROqO7s1iG0uC/VFkCc8Jb4VSNmyNcwGfqHh7az3JokbYe2t+x7JwF7acrRJkyl6rfnFcWhP1wEx7ToXCl0XChhCyPIZ+pIRsCN+k8FXi7Gr2JiKB5TKhIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATf0wWhO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATf0wWhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056E7C2BC86;
	Tue, 10 Mar 2026 11:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140776;
	bh=DLOsGLDJnPqPJeL3NW6eoY4krzxmhzyx9QmW4ff8HNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATf0wWhOAKIXuo9IOa2h7nJ0KJbfSYCbdZFxanA1yZsPwZFvuHRJYtdO9JE2Eigon
	 dcM3U1bEd/l9zd/1QSeQIIBPV4VZvWp3rG/OJbTLeF9fepZJLo/aoVUst6ca2CjzvB
	 kfgWJl/dRKr0OmB8wg9ae4zunDsztWAvaDlT4SPbpI6dGgUnS5hMu9lkS834zeGrrM
	 0n0qRALozS+jdUa4h0OqfXoxSiONSMvFHZhlEAcG8ks7O+yowjH2AB3fZKaruCQ8yY
	 FOc+ulRtzReX3gl/SSCIiqLnUrQez/QgYoby4hhsu2+jZd0dHuqfE74HgI/M9/K3T6
	 0JiUXaYWzQOgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 010/311] irqchip/sifive-plic: Fix frozen interrupt due to affinity setting
Date: Tue, 10 Mar 2026 07:00:57 -0400
Message-ID: <2891e6a95c21f5febd6284c88361659fb2b76f2d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 60fd8f91762b1..70058871d2fb6 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -172,8 +172,13 @@ static void plic_irq_disable(struct irq_data *d)
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

