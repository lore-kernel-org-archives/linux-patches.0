Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D9F2253FC;
	Tue, 30 Sep 2025 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243797; cv=none; b=kKksSWC05oBE2ohJNIFHPkMfQ0GZx5+QpqzyEn/Y0jj9QTA+txzy0Q+JZaQtzsiwAJJgDsV1Yx0dy/BXdd4bHwWvkGoNbkRzFG8pG34tD4s6C83ftw8YfxbjfJEuHXUl23bnVY6/MRk8EnDjA4lnmRXHqY8SkF0oIdQnIWbgDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243797; c=relaxed/simple;
	bh=VvvAbIuOz+RDh5b2cY0PmcEvlbMimq95dIqGryxyVus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZu22sT1tW1olkBLX5uBhv3dCrGcTKD4AVPwMCnV2DQfkDtXBD8htHNL/GlR62Cx3FKaKyt5YXeBKKVmJdCbefOPHF4D4GBZH906Z/LldWMIIZrZ0Nay5A8d9hCg2A7WsRBIXRF2U6fllMMeA+jXVWHrze62SKDMOW5Y472Sgqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFQ6dnci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFQ6dnci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC73C4CEF0;
	Tue, 30 Sep 2025 14:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243797;
	bh=VvvAbIuOz+RDh5b2cY0PmcEvlbMimq95dIqGryxyVus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFQ6dncilWkru3k63jy/nzeW8ZBZwbzqQR8BGrOgxu2Ec3unao6acJMj7kj0j+0Hj
	 17UvOJ6layea15yoCywXbJZ7RL/Z04VDi7WBzuLH/2KPnY/8TKzYQKhT/NnXDjavZE
	 qZ6ZjSG+5PhsULSy36dgpq8I9vHqIGWBUP2F/UAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/81] genirq: Export affinity setter for modules
Date: Tue, 30 Sep 2025 16:46:22 +0200
Message-ID: <20250930143820.513768797@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 4d80d6ca5d77fde9880da8466e5b64f250e5bf82 ]

Perf modules abuse irq_set_affinity_hint() to set the affinity of system
PMU interrupts just because irq_set_affinity() was not exported.

The fact that irq_set_affinity_hint() actually sets the affinity is a
non-documented side effect and the name is clearly saying it's a hint.

To clean this up, export the real affinity setter.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210518093117.968251441@linutronix.de
Stable-dep-of: 915470e1b44e ("i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 35 ++---------------------------------
 kernel/irq/manage.c       | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a601715279f50..85a5d13a7dc9c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -303,39 +303,8 @@ struct irq_affinity_desc {
 
 extern cpumask_var_t irq_default_affinity;
 
-/* Internal implementation. Use the helpers below */
-extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
-			      bool force);
-
-/**
- * irq_set_affinity - Set the irq affinity of a given irq
- * @irq:	Interrupt to set affinity
- * @cpumask:	cpumask
- *
- * Fails if cpumask does not contain an online CPU
- */
-static inline int
-irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
-{
-	return __irq_set_affinity(irq, cpumask, false);
-}
-
-/**
- * irq_force_affinity - Force the irq affinity of a given irq
- * @irq:	Interrupt to set affinity
- * @cpumask:	cpumask
- *
- * Same as irq_set_affinity, but without checking the mask against
- * online cpus.
- *
- * Solely for low level cpu hotplug code, where we need to make per
- * cpu interrupts affine before the cpu becomes online.
- */
-static inline int
-irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
-{
-	return __irq_set_affinity(irq, cpumask, true);
-}
+extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
 
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 44d77e834c229..05601bcd30118 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -402,7 +402,8 @@ int irq_update_affinity_desc(unsigned int irq,
 	return ret;
 }
 
-int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
+static int __irq_set_affinity(unsigned int irq, const struct cpumask *mask,
+			      bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -417,6 +418,36 @@ int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 	return ret;
 }
 
+/**
+ * irq_set_affinity - Set the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @cpumask:	cpumask
+ *
+ * Fails if cpumask does not contain an online CPU
+ */
+int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, false);
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity);
+
+/**
+ * irq_force_affinity - Force the irq affinity of a given irq
+ * @irq:	Interrupt to set affinity
+ * @cpumask:	cpumask
+ *
+ * Same as irq_set_affinity, but without checking the mask against
+ * online cpus.
+ *
+ * Solely for low level cpu hotplug code, where we need to make per
+ * cpu interrupts affine before the cpu becomes online.
+ */
+int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return __irq_set_affinity(irq, cpumask, true);
+}
+EXPORT_SYMBOL_GPL(irq_force_affinity);
+
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
-- 
2.51.0



