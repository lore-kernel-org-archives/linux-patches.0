Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FB84F4CEA;
	Thu, 17 Sep 2026 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661286; cv=none; b=Ujay/VlLrNuELQZtNJAKEfogrGnu8E2glgfsQclt201hwSHQdnEdF1Cra3FFzngNyzIr9Jywsbibqjh+C6DlB8eIsS0iXb7SPOzQ09vXdo/FZqDxSEyFjNJPKogIRefl2J9KTjOLHuviq+VEVTpnXkWc9+sgUoSTPjMJAOacJMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661286; c=relaxed/simple;
	bh=6YQyYStRkp82QSoyCbVS2LSJCVzG9PyxaPTUx1/61Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR+nPjyBcfJnv+2PDW7qGWSI7sFlkstsEHPpUnJ376a2Rm8/1mYV1LQcNdHp2kpI31k+aYpGW874O4pIyoCpvSw46pZJm/eElnbJrou6eVMFpTbbWVfuGw/U2v7mp37lUs0b8LAG4cIIP2/6+ffeYBQYOufKWp/IWpnLZsARkIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6pQGIGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6pQGIGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41781F00893;
	Thu, 17 Sep 2026 16:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661285;
	bh=MoDz3R++YPwMMiYKcfZdZhe3HKOqoHmhdDOSKWI7PbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6pQGIGZ1VgR9Y7r5hZiyEGEPChgiMo/A/fVyIyIH5L3mYFe7Odc/7igtKQFaxReJ
	 dzYbcBjWSPsa1FOP9FmJyFoK7Z0Iy7gAAmSYfJQjVw0BGXwOty6Hk3Ikd8XXkhgcZe
	 HYXlU98+8Jt02BT1gpgAWtmz3OZAZFMeNG8y7SDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0145/1250] arm64: panic from init_IRQ if IRQ handler stacks cannot be allocated
Date: Thu, 17 Sep 2026 15:59:00 +0100
Message-ID: <20260917151555.989373100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

[ Upstream commit 7dc6922f7fdd3496de4e7d8fb99284fc08f98003 ]

init_irq_stacks() and init_irq_scs() may fail when arch_alloc_vmap_stack
or scs_alloc return NULL. Return -ENOMEM from both and call panic() once
from init_IRQ(), covering per-CPU IRQ stacks and shadow IRQ stacks
consistently.

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/irq.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index c0065a1d77cf3..00ebbf18b1c18 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -10,6 +10,7 @@
  * Copyright (C) 2012 ARM Ltd.
  */
 
+#include <linux/errno.h>
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/irq.h>
@@ -32,34 +33,43 @@ DEFINE_PER_CPU(struct nmi_ctx, nmi_contexts);
 
 DEFINE_PER_CPU(unsigned long *, irq_stack_ptr);
 
-
 DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
 
 #ifdef CONFIG_SHADOW_CALL_STACK
 DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
 #endif
 
-static void init_irq_scs(void)
+static int __init init_irq_scs(void)
 {
 	int cpu;
+	void *s;
 
 	if (!scs_is_enabled())
-		return;
+		return 0;
+
+	for_each_possible_cpu(cpu) {
+		s = scs_alloc(early_cpu_to_node(cpu));
+		if (!s)
+			return -ENOMEM;
+		per_cpu(irq_shadow_call_stack_ptr, cpu) = s;
+	}
 
-	for_each_possible_cpu(cpu)
-		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			scs_alloc(early_cpu_to_node(cpu));
+	return 0;
 }
 
-static void __init init_irq_stacks(void)
+static int __init init_irq_stacks(void)
 {
 	int cpu;
 	unsigned long *p;
 
 	for_each_possible_cpu(cpu) {
 		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, early_cpu_to_node(cpu));
+		if (!p)
+			return -ENOMEM;
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
+
+	return 0;
 }
 
 #ifndef CONFIG_PREEMPT_RT
@@ -109,8 +119,9 @@ int __init set_handle_fiq(void (*handle_fiq)(struct pt_regs *))
 
 void __init init_IRQ(void)
 {
-	init_irq_stacks();
-	init_irq_scs();
+	if (init_irq_stacks() || init_irq_scs())
+		panic("Failed to allocate IRQ stack resources\n");
+
 	irqchip_init();
 
 	if (system_uses_irq_prio_masking()) {
-- 
2.53.0



