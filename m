Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C6B30216D;
	Sat, 17 Oct 2026 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253865; cv=none; b=PMrcj22Z4XO5CtTfMky1dCjK1heI3HXsNukIauExUyZynWycI3rMdNMuFCBFBirylQhUIA21+tZembmUNG+BGfxxAOHU1lnLQo1+QvtwUquTO/HXF3e7ycVt8dQLjRiX+VK1PhDNEDreaXD2PJPKn6l/EzX/bptScgKB9y9Uu/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253865; c=relaxed/simple;
	bh=Yr4PqVdo6Emododu0erYS9ua1EHlHha0ROyEkqWTixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMrzR4iKSf7tpEp+0/WI01JO0DM4PC8RckkvPw5AGIO4MUPDj+hX9ZstU7jbOj3SYNiJ3tIb6TNA91uOTHoai9w8MfOYVDzowgLzNulhp//6s/biSnO9duzSw+Cc+GMXFIb3yw5Opc1oDFc9aHQikpagfpx/CgwI/FgJWEIRKSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jirxefWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jirxefWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE7E1F000C5;
	Sat, 17 Oct 2026 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253863;
	bh=8A9YUpdA7Ryz6k9mACrP49zOpQFdsOCWgmE2IRVtZlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jirxefWvwEALr4LjfXE/OCfJRNm2Pof28CTni4Fdphx9C70lblMkyRvG/hhj7Ix6X
	 vDPMF6CXKZq8KU6WGL8QmNne7lCJ76LslvsV8XxRgSfoW4WfnPudAMrBvYlrEKdDUy
	 1C666IBl99F3gjuWQmcQmAuiKjq0YW5lwc7veSVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petlozu Pravareshwar <petlozup@nvidia.com>,
	Prathamesh Shete <pshete@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 259/869] soc/tegra: pmc: Fix unsafe generic_handle_irq() call
Date: Sat, 17 Oct 2026 17:51:40 +0200
Message-ID: <20261017160043.700802754@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit e6d96073af681780820c94079b978474a8a44413 ]

Currently, when resuming from system suspend on Tegra platforms,
the following warning is observed:

WARNING: CPU: 0 PID: 14459 at kernel/irq/irqdesc.c:666
Call trace:
 handle_irq_desc+0x20/0x58 (P)
 tegra186_pmc_wake_syscore_resume+0xe4/0x15c
 syscore_resume+0x3c/0xb8
 suspend_devices_and_enter+0x510/0x540
 pm_suspend+0x16c/0x1d8

The warning occurs because generic_handle_irq() is being called from
a non-interrupt context which is considered as unsafe.

Fix this warning by deferring generic_handle_irq() call to an IRQ work
which gets executed in hard IRQ context where generic_handle_irq()
can be called safely.

When PREEMPT_RT kernels are used, regular IRQ work (initialized with
init_irq_work) is deferred to run in per-CPU kthreads in preemptible
context rather than hard IRQ context. Hence, use the IRQ_WORK_INIT_HARD
variant so that with PREEMPT_RT kernels, the IRQ work is processed in
hardirq context instead of being deferred to a thread which is required
for calling generic_handle_irq().

On non-PREEMPT_RT kernels, both init_irq_work() and IRQ_WORK_INIT_HARD()
execute in IRQ context, so this change has no functional impact for
standard kernel configurations.

Signed-off-by: Petlozu Pravareshwar <petlozup@nvidia.com>
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
[treding@nvidia.com: miscellaneous cleanups]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 104 ++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 30 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index bed58b78d13dc..0cca72e18437d 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -28,6 +28,7 @@
 #include <linux/iopoll.h>
 #include <linux/irqdomain.h>
 #include <linux/irq.h>
+#include <linux/irq_work.h>
 #include <linux/kernel.h>
 #include <linux/of_address.h>
 #include <linux/of_clk.h>
@@ -468,6 +469,10 @@ struct tegra_pmc {
 	unsigned long *wake_sw_status_map;
 	unsigned long *wake_cntrl_level_map;
 	struct syscore syscore;
+
+	/* Pending wake IRQ processing */
+	struct irq_work wake_work;
+	u32 *wake_status;
 };
 
 static struct tegra_pmc *pmc = &(struct tegra_pmc) {
@@ -1905,6 +1910,50 @@ static int tegra_pmc_parse_dt(struct tegra_pmc *pmc, struct device_node *np)
 	return 0;
 }
 
+/* translate sc7 wake sources back into IRQs to catch edge triggered wakeups */
+static void tegra186_pmc_wake_handler(struct irq_work *work)
+{
+	struct tegra_pmc *pmc = container_of(work, struct tegra_pmc, wake_work);
+	unsigned int i, wake;
+
+	for (i = 0; i < pmc->soc->max_wake_vectors; i++) {
+		unsigned long status = pmc->wake_status[i];
+
+		for_each_set_bit(wake, &status, 32) {
+			irq_hw_number_t hwirq = wake + (i * 32);
+			struct irq_desc *desc;
+			unsigned int irq;
+
+			irq = irq_find_mapping(pmc->domain, hwirq);
+			if (!irq) {
+				dev_warn(pmc->dev,
+					 "No IRQ found for WAKE#%lu!\n",
+					 hwirq);
+				continue;
+			}
+
+			dev_dbg(pmc->dev,
+				"Resume caused by WAKE#%lu mapped to IRQ#%u\n",
+				hwirq, irq);
+
+			desc = irq_to_desc(irq);
+			if (!desc) {
+				dev_warn(pmc->dev,
+					 "No descriptor found for IRQ#%u\n",
+					 irq);
+				continue;
+			}
+
+			if (!desc->action || !desc->action->name)
+				continue;
+
+			generic_handle_irq(irq);
+		}
+
+		pmc->wake_status[i] = 0;
+	}
+}
+
 static int tegra_pmc_init(struct tegra_pmc *pmc)
 {
 	if (pmc->soc->max_wake_events > 0) {
@@ -1923,6 +1972,18 @@ static int tegra_pmc_init(struct tegra_pmc *pmc)
 		pmc->wake_cntrl_level_map = bitmap_zalloc(pmc->soc->max_wake_events, GFP_KERNEL);
 		if (!pmc->wake_cntrl_level_map)
 			return -ENOMEM;
+
+		pmc->wake_status = kcalloc(pmc->soc->max_wake_vectors, sizeof(u32), GFP_KERNEL);
+		if (!pmc->wake_status)
+			return -ENOMEM;
+
+		/*
+		 * Initialize IRQ work for processing wake IRQs. Must use
+		 * HARD_IRQ variant to run in hard IRQ context on PREEMPT_RT
+		 * because we call generic_handle_irq() which requires hard
+		 * IRQ context.
+		 */
+		pmc->wake_work = IRQ_WORK_INIT_HARD(tegra186_pmc_wake_handler);
 	}
 
 	if (pmc->soc->init)
@@ -3122,47 +3183,30 @@ static void wke_clear_wake_status(struct tegra_pmc *pmc)
 	}
 }
 
-/* translate sc7 wake sources back into IRQs to catch edge triggered wakeups */
-static void tegra186_pmc_process_wake_events(struct tegra_pmc *pmc, unsigned int index,
-					     unsigned long status)
-{
-	unsigned int wake;
-
-	dev_dbg(pmc->dev, "Wake[%d:%d]  status=%#lx\n", (index * 32) + 31, index * 32, status);
-
-	for_each_set_bit(wake, &status, 32) {
-		irq_hw_number_t hwirq = wake + 32 * index;
-		struct irq_desc *desc;
-		unsigned int irq;
-
-		irq = irq_find_mapping(pmc->domain, hwirq);
-
-		desc = irq_to_desc(irq);
-		if (!desc || !desc->action || !desc->action->name) {
-			dev_dbg(pmc->dev, "Resume caused by WAKE%ld, IRQ %d\n", hwirq, irq);
-			continue;
-		}
-
-		dev_dbg(pmc->dev, "Resume caused by WAKE%ld, %s\n", hwirq, desc->action->name);
-		generic_handle_irq(irq);
-	}
-}
-
 static void tegra186_pmc_wake_syscore_resume(void *data)
 {
-	u32 status, mask;
 	unsigned int i;
+	u32 mask;
 
 	for (i = 0; i < pmc->soc->max_wake_vectors; i++) {
 		mask = readl(pmc->wake + WAKE_AOWAKE_TIER2_ROUTING(i));
-		status = readl(pmc->wake + WAKE_AOWAKE_STATUS_R(i)) & mask;
-
-		tegra186_pmc_process_wake_events(pmc, i, status);
+		pmc->wake_status[i] = readl(pmc->wake + WAKE_AOWAKE_STATUS_R(i)) & mask;
 	}
+
+	/* Schedule IRQ work to process wake IRQs (if any) */
+	irq_work_queue(&pmc->wake_work);
 }
 
 static int tegra186_pmc_wake_syscore_suspend(void *data)
 {
+	unsigned int i;
+
+	/* Check if there are unhandled wake IRQs */
+	for (i = 0; i < pmc->soc->max_wake_vectors; i++)
+		if (pmc->wake_status[i])
+			dev_warn(pmc->dev,
+				 "Unhandled wake IRQs pending vector[%u]: 0x%x\n",
+				 i, pmc->wake_status[i]);
 	wke_read_sw_wake_status(pmc);
 
 	/* flip the wakeup trigger for dual-edge triggered pads
-- 
2.53.0



