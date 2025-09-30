Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549281AB6F1;
	Tue, 30 Sep 2025 14:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244124; cv=none; b=aN80KBiVc0vDjmkngLL3mwCwP9CNFjn8IcZbb0jOLXIvOwFCAuHsKriZAOlkUVBSh+SPJubQFVcbBCwYa0iBXElXHbxGTXWP0E8manjYUfNvHgFKZcDEJhoCcgj8LKDhmAN6R5ATKALE6fW6T9U9truhfK0sgFKqGuVftbYHVRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244124; c=relaxed/simple;
	bh=jgHNquUE0O19WyMvsdwMLlnc01VmsHxoAemG9X6lpqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9yP6Ig3efDJLSwNyx/d+GHeFNs1U61Ng6Rpw0Ak+bNAO6J+q+MjxrjQQ+S17v0JomgEyNH4V/k5KCKBB/ZM3KqXOZPBRfGL1P4xxY4oqtOglWcvE2ksj9FIgZby6mgeH3TikPrmgacwMi893WPUgToGuIaP4rOHShmDNthd7i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9RnM4X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9RnM4X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF338C4CEF0;
	Tue, 30 Sep 2025 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244124;
	bh=jgHNquUE0O19WyMvsdwMLlnc01VmsHxoAemG9X6lpqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9RnM4X9tVoj7zov8SKiBcnYC9lChlZTRIfRbSrZTKLqROD4cqrXbmLFMibf0b0N5
	 0pq2toERSMjBkMioQ4nQ7+O5JASfZIWrokVphrXra3zQH/7FoILg0RYMpXLZnQNqnO
	 EwnhqDzCwkLrnq/ZnS4K9d54ihr5rPMp5B7yddeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/122] genirq: Export affinity setter for modules
Date: Tue, 30 Sep 2025 16:46:05 +0200
Message-ID: <20250930143824.403249647@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d6f833b403d59..9c52e263ef399 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -318,39 +318,8 @@ struct irq_affinity_desc {
 
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
index 4ca4ab8ef2a5f..5cf1a32b74e24 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -456,7 +456,8 @@ int irq_update_affinity_desc(unsigned int irq,
 	return ret;
 }
 
-int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
+static int __irq_set_affinity(unsigned int irq, const struct cpumask *mask,
+			      bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -471,6 +472,36 @@ int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
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



