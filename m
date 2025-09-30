Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11D2199939;
	Tue, 30 Sep 2025 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243801; cv=none; b=fF0gXY/MHPF1PXgx2yygYWO54Xl9Zo0XWy+GmAmHR/EWxjWw1M4RxavxRS4K3ofIIpdS4hYHOO8SMcZVnS/ktrrVMB9AhPQM3vdAZnrTxq0S29YxvyoyVG9BR0x1fCnX5pTKY1MP/1qjX5imyFdGX/FT3/yffRWT54oY1eAo1eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243801; c=relaxed/simple;
	bh=BnrGFrI3wpHR297IEV4jvW2GUn+A0f8jL0+pmeidA8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoBqD7kvrYREXgVraKBZ3Ns+qFRA2V/aeFlndjsC4J56UP0RzwN8Q4TOQcjc2CaZQp7mMXGMSP65cpCzsi8Lw+tBzWDcieHNfZxjdJEhaLq9dSRLzsWkOnTRX0td35fVUlhzSj2LfoBd+xKyBziFJJZnrAToGK1t0pIilYSQKy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPTjUSKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPTjUSKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE80CC4CEF0;
	Tue, 30 Sep 2025 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243801;
	bh=BnrGFrI3wpHR297IEV4jvW2GUn+A0f8jL0+pmeidA8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPTjUSKxH00XsSDJmKRIGc1crRcPcr3qmIh1HbvHFHGEbMAb90FMQN0fclXKeCtF6
	 qCCWi4sR5NZL3nwEDaU4pOLShX7LBHJrnlshDiZH17F3YVwx2cKDmmZ5nQTXROFJGh
	 Q7MhXvFaq5pCHlQqAg9ApBAB63rWooAeeBq37+bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Nitesh Narayan Lal <nitesh@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/81] genirq: Provide new interfaces for affinity hints
Date: Tue, 30 Sep 2025 16:46:23 +0200
Message-ID: <20250930143820.554277816@linuxfoundation.org>
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

[ Upstream commit 65c7cdedeb3026fabcc967a7aae2f755ad4d0783 ]

The discussion about removing the side effect of irq_set_affinity_hint() of
actually applying the cpumask (if not NULL) as affinity to the interrupt,
unearthed a few unpleasantries:

  1) The modular perf drivers rely on the current behaviour for the very
     wrong reasons.

  2) While none of the other drivers prevents user space from changing
     the affinity, a cursorily inspection shows that there are at least
     expectations in some drivers.

#1 needs to be cleaned up anyway, so that's not a problem

#2 might result in subtle regressions especially when irqbalanced (which
   nowadays ignores the affinity hint) is disabled.

Provide new interfaces:

  irq_update_affinity_hint()  - Only sets the affinity hint pointer
  irq_set_affinity_and_hint() - Set the pointer and apply the affinity to
                                the interrupt

Make irq_set_affinity_hint() a wrapper around irq_apply_affinity_hint() and
document it to be phased out.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20210501021832.743094-1-jesse.brandeburg@intel.com
Link: https://lore.kernel.org/r/20210903152430.244937-2-nitesh@redhat.com
Stable-dep-of: 915470e1b44e ("i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 53 ++++++++++++++++++++++++++++++++++++++-
 kernel/irq/manage.c       |  8 +++---
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 85a5d13a7dc9c..7c06e33ad05ec 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -309,7 +309,46 @@ extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
-extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+extern int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+				     bool setaffinity);
+
+/**
+ * irq_update_affinity_hint - Update the affinity hint
+ * @irq:	Interrupt to update
+ * @m:		cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint, but does not change the affinity of the interrupt.
+ */
+static inline int
+irq_update_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, false);
+}
+
+/**
+ * irq_set_affinity_and_hint - Update the affinity hint and apply the provided
+ *			     cpumask to the interrupt
+ * @irq:	Interrupt to update
+ * @m:		cpumask pointer (NULL to clear the hint)
+ *
+ * Updates the affinity hint and if @m is not NULL it applies it as the
+ * affinity of that interrupt.
+ */
+static inline int
+irq_set_affinity_and_hint(unsigned int irq, const struct cpumask *m)
+{
+	return __irq_apply_affinity_hint(irq, m, true);
+}
+
+/*
+ * Deprecated. Use irq_update_affinity_hint() or irq_set_affinity_and_hint()
+ * instead.
+ */
+static inline int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	return irq_set_affinity_and_hint(irq, m);
+}
+
 extern int irq_update_affinity_desc(unsigned int irq,
 				    struct irq_affinity_desc *affinity);
 
@@ -341,6 +380,18 @@ static inline int irq_can_set_affinity(unsigned int irq)
 
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
+static inline int irq_update_affinity_hint(unsigned int irq,
+					   const struct cpumask *m)
+{
+	return -EINVAL;
+}
+
+static inline int irq_set_affinity_and_hint(unsigned int irq,
+					    const struct cpumask *m)
+{
+	return -EINVAL;
+}
+
 static inline int irq_set_affinity_hint(unsigned int irq,
 					const struct cpumask *m)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 05601bcd30118..32513a2e26eb0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -448,7 +448,8 @@ int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
 }
 EXPORT_SYMBOL_GPL(irq_force_affinity);
 
-int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+int __irq_apply_affinity_hint(unsigned int irq, const struct cpumask *m,
+			      bool setaffinity)
 {
 	unsigned long flags;
 	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, IRQ_GET_DESC_CHECK_GLOBAL);
@@ -457,12 +458,11 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 		return -EINVAL;
 	desc->affinity_hint = m;
 	irq_put_desc_unlock(desc, flags);
-	/* set the initial affinity to prevent every interrupt being on CPU0 */
-	if (m)
+	if (m && setaffinity)
 		__irq_set_affinity(irq, m, false);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+EXPORT_SYMBOL_GPL(__irq_apply_affinity_hint);
 
 static void irq_affinity_notify(struct work_struct *work)
 {
-- 
2.51.0



