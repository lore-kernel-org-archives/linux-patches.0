Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFCD3DB8D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7+ivlNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B709CC433CC;
	Wed, 15 Nov 2023 19:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076037;
	bh=oGoJVXLJ4rXzkgHk2aGArBKqiUlhNA23AOWr5LfHh6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7+ivlNpafq2ZHeLezCpz8e7vSwwxgeeE4tIQGyNiUwr74+Je6b9XAGd6wkITPN+o
	 k82h645mW+Jg8f8onjggsxFNF0awJCn4ocr4sVK8IO9AXWSGX7c6R3iHXmhITPbOaK
	 sAoiNxIyiJmBNAffZWtej7hsNGjhPqI3Zxni2tt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anup Patel <apatel@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 036/550] irqchip/sifive-plic: Fix syscore registration for multi-socket systems
Date: Wed, 15 Nov 2023 14:10:20 -0500
Message-ID: <20231115191603.216641620@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anup Patel <apatel@ventanamicro.com>

[ Upstream commit f99b926f6543faeadba1b4524d8dc9c102489135 ]

Multi-socket systems have a separate PLIC in each socket, so __plic_init()
is invoked for each PLIC. __plic_init() registers syscore operations, which
obviously fails on the second invocation.

Move it into the already existing condition for installing the CPU hotplug
state so it is only invoked once when the first PLIC is initialized.

[ tglx: Massaged changelog ]

Fixes: e80f0b6a2cf3 ("irqchip/irq-sifive-plic: Add syscore callbacks for hibernation")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20231025142820.390238-4-apatel@ventanamicro.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index e1484905b7bdb..5b7bc4fd9517c 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -532,17 +532,18 @@ static int __init __plic_init(struct device_node *node,
 	}
 
 	/*
-	 * We can have multiple PLIC instances so setup cpuhp state only
-	 * when context handler for current/boot CPU is present.
+	 * We can have multiple PLIC instances so setup cpuhp state
+	 * and register syscore operations only when context handler
+	 * for current/boot CPU is present.
 	 */
 	handler = this_cpu_ptr(&plic_handlers);
 	if (handler->present && !plic_cpuhp_setup_done) {
 		cpuhp_setup_state(CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
 				  "irqchip/sifive/plic:starting",
 				  plic_starting_cpu, plic_dying_cpu);
+		register_syscore_ops(&plic_irq_syscore_ops);
 		plic_cpuhp_setup_done = true;
 	}
-	register_syscore_ops(&plic_irq_syscore_ops);
 
 	pr_info("%pOFP: mapped %d interrupts with %d handlers for"
 		" %d contexts.\n", node, nr_irqs, nr_handlers, nr_contexts);
-- 
2.42.0



