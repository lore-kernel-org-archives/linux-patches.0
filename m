Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309B233D9E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300953; cv=none; b=gqW+7v5cTA+iBVD4ew0k76uXaQohd+8jUd8KDXCv33H3CCcH+VXSTmTfwlv9Jftyvj2HGOJBQ7DsirGBnl08rQiPriDzCIaVaC+xP5NtFRgQSuaQD4R7FDEGOQiu9AOn6tGdOWU7nQxnR2ir/UvIqCa30tX3BQxondupSxPS3ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300953; c=relaxed/simple;
	bh=m2tzM23qpooa/hj94LA+r8cpmrUSZYKja2TuHEryIfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dM3vGaeWGus5jxMfpSoR1fRWwvc3gmHAiWnGROK/xU0nEzChb106qwfBlSrHc4LdiQd2vG3Bne+o3QLbgzsuhw2s8viXp2pD1fWsiRsGwyLY0GvLtTf8cknE/sbKPBAtFDTFQd9znwsLhRDTUngzvfjof+gu2lYTa4tYKAOaWqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dICQkoYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dICQkoYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A93C116D0;
	Sat, 28 Feb 2026 17:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300953;
	bh=m2tzM23qpooa/hj94LA+r8cpmrUSZYKja2TuHEryIfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dICQkoYNK39a37Kc+pPAb6Kr2EzPR+v+48SFI+qXZeljMZPQcTO4HxkwCoH43/zXm
	 48mldb1Fx5dNPPkXiYDwjpGkn4tuEioGj0t5DGwzpylVyJ10KmB8xCli0SieyChMec
	 AYWdDMohY1ker1SJaY5jk9gPCk6ddhYQeIjsGhpkQW67LgSTQxeJnmy6PECq5alysT
	 5LXeln5V5sdgqnbhjKO5vzBZeHXYeJvxCKq57ebxJbiPyUbBP4isvxvegpREIDj5Ht
	 GTI+QjWJnFzEzEZrP4yUKRIR+u/woaVNsFAtkNLgPRqI4k+fIJxjWb1VGZKa17l6iC
	 QadBwysT8+0Tg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nick Hu <nick.hu@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Cyan Yang <cyan.yang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Nutty Liu <liujingqi@lanxincomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/752] irqchip/riscv-imsic: Add a CPU pm notifier to restore the IMSIC on exit
Date: Sat, 28 Feb 2026 12:36:27 -0500
Message-ID: <20260228174750.1542406-76-sashal@kernel.org>
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

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit f48b4bd0915bf61ac12b8c65c7939ebd03bc8abf ]

The IMSIC might be reset when the system enters a low power state, but on
exit nothing restores the registers, which prevents interrupt delivery.

Solve this by registering a CPU power management notifier, which restores
the IMSIC on exit.

Signed-off-by: Nick Hu <nick.hu@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Nutty Liu <liujingqi@lanxincomputing.com>
Link: https://patch.msgid.link/20251202-preserve-aplic-imsic-v3-1-1844fbf1fe92@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-early.c | 39 ++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-early.c b/drivers/irqchip/irq-riscv-imsic-early.c
index 2c4c682627b8c..d1727c343c38f 100644
--- a/drivers/irqchip/irq-riscv-imsic-early.c
+++ b/drivers/irqchip/irq-riscv-imsic-early.c
@@ -7,6 +7,7 @@
 #define pr_fmt(fmt) "riscv-imsic: " fmt
 #include <linux/acpi.h>
 #include <linux/cpu.h>
+#include <linux/cpu_pm.h>
 #include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
@@ -128,14 +129,8 @@ static void imsic_handle_irq(struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-static int imsic_starting_cpu(unsigned int cpu)
+static void imsic_hw_states_init(void)
 {
-	/* Mark per-CPU IMSIC state as online */
-	imsic_state_online();
-
-	/* Enable per-CPU parent interrupt */
-	enable_percpu_irq(imsic_parent_irq, irq_get_trigger_type(imsic_parent_irq));
-
 	/* Setup IPIs */
 	imsic_ipi_starting_cpu();
 
@@ -147,6 +142,18 @@ static int imsic_starting_cpu(unsigned int cpu)
 
 	/* Enable local interrupt delivery */
 	imsic_local_delivery(true);
+}
+
+static int imsic_starting_cpu(unsigned int cpu)
+{
+	/* Mark per-CPU IMSIC state as online */
+	imsic_state_online();
+
+	/* Enable per-CPU parent interrupt */
+	enable_percpu_irq(imsic_parent_irq, irq_get_trigger_type(imsic_parent_irq));
+
+	/* Initialize the IMSIC registers to enable the interrupt delivery */
+	imsic_hw_states_init();
 
 	return 0;
 }
@@ -162,6 +169,22 @@ static int imsic_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+static int imsic_pm_notifier(struct notifier_block *self, unsigned long cmd, void *v)
+{
+	switch (cmd) {
+	case CPU_PM_EXIT:
+		/* Initialize the IMSIC registers to enable the interrupt delivery */
+		imsic_hw_states_init();
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block imsic_pm_notifier_block = {
+	.notifier_call = imsic_pm_notifier,
+};
+
 static int __init imsic_early_probe(struct fwnode_handle *fwnode)
 {
 	struct irq_domain *domain;
@@ -199,7 +222,7 @@ static int __init imsic_early_probe(struct fwnode_handle *fwnode)
 	cpuhp_setup_state(CPUHP_AP_IRQ_RISCV_IMSIC_STARTING, "irqchip/riscv/imsic:starting",
 			  imsic_starting_cpu, imsic_dying_cpu);
 
-	return 0;
+	return cpu_pm_register_notifier(&imsic_pm_notifier_block);
 }
 
 static int __init imsic_early_dt_init(struct device_node *node, struct device_node *parent)
-- 
2.51.0

