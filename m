Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3FE3BFE26;
	Sat, 17 Oct 2026 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255502; cv=none; b=mT+AQ158XXz1DpxFgAVVrubz6+uKHG8eEVoboJqTrWOWUuCTnCgPjU3QEPa7gzpONEKEsL1hrMdPQgu1vzLOMyUdPYcKxrgteKzVdOUpwq/lvrKjn7nnbZrKRJNxy5urrd0AizkmJ79AaScFt3Q2fiDIhP6hbV4QZEYBFU5ZqeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255502; c=relaxed/simple;
	bh=tR7soLFXOTKrbVRcFbtlHfNL62uy/Js7OvxAr/JrrPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+e7BKtFSAm0bXy5MSYsd6r0D+AcnddgKYGlHBbz08NFdkfhi34pVSJhKE9RdnZ6i1xPlDC4tL9nkqGN6OG0JA7ZxXlaImgWixbZXgzVMvHnzeninArO9AgNI8fzZ6FHEOmvA/W8JneAaENObEWqfZeI3R6NM80HI9+PpRrJGgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdBfZpIG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdBfZpIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262AC1F000C4;
	Sat, 17 Oct 2026 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255500;
	bh=+jygAY5atYAfwnR/psmQa/WWsrawgygj5uEvWa9dDGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdBfZpIGlfQT2wDX6KRqY0B1z4F+lqY/XjUuKSWjMH1XVUUdnEQQMu68XjjDYwrVp
	 38gkR8MaeRfXAqWjv9TjmioTGkbSKSHUhCzAZY6ohZion7B9BRQp0PWIrHCrIBqvdp
	 hJniBRkUmO9nByw9YWGRUJ8UmyI/5dK8xFsTeVIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 755/869] genirq/proc: Switch to lock guards
Date: Sat, 17 Oct 2026 17:59:56 +0200
Message-ID: <20261017160056.287044544@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 659ff9c9d77b8ad9d9c18e264abc9a56bd19230e ]

Convert all lock/unlock pairs to guards and tidy up the code.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/20250429065420.373998838@linutronix.de
Stable-dep-of: c2c7983c93f5 ("genirq/proc: Size interrupt directory names for 10-digit interrupt numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/proc.c | 65 +++++++++++++++++------------------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 9081ada81c3d0..24fe3bd56d86f 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -81,20 +81,18 @@ static int show_irq_affinity(int type, struct seq_file *m)
 static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	unsigned long flags;
 	cpumask_var_t mask;
 
 	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	if (desc->affinity_hint)
-		cpumask_copy(mask, desc->affinity_hint);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	scoped_guard(raw_spinlock_irq, &desc->lock) {
+		if (desc->affinity_hint)
+			cpumask_copy(mask, desc->affinity_hint);
+	}
 
 	seq_printf(m, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
-
 	return 0;
 }
 
@@ -295,23 +293,18 @@ static int irq_spurious_proc_show(struct seq_file *m, void *v)
 
 #define MAX_NAMELEN 128
 
-static int name_unique(unsigned int irq, struct irqaction *new_action)
+static bool name_unique(unsigned int irq, struct irqaction *new_action)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irqaction *action;
-	unsigned long flags;
-	int ret = 1;
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
+	guard(raw_spinlock_irq)(&desc->lock);
 	for_each_action_of_desc(desc, action) {
 		if ((action != new_action) && action->name &&
-				!strcmp(new_action->name, action->name)) {
-			ret = 0;
-			break;
-		}
+		    !strcmp(new_action->name, action->name))
+			return false;
 	}
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	return ret;
+	return true;
 }
 
 void register_handler_proc(unsigned int irq, struct irqaction *action)
@@ -319,8 +312,7 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 	char name [MAX_NAMELEN];
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	if (!desc->dir || action->dir || !action->name ||
-					!name_unique(irq, action))
+	if (!desc->dir || action->dir || !action->name || !name_unique(irq, action))
 		return;
 
 	snprintf(name, MAX_NAMELEN, "%s", action->name);
@@ -347,17 +339,16 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 	 * added, not when the descriptor is created, so multiple
 	 * tasks might try to register at the same time.
 	 */
-	mutex_lock(&register_lock);
+	guard(mutex)(&register_lock);
 
 	if (desc->dir)
-		goto out_unlock;
-
-	sprintf(name, "%d", irq);
+		return;
 
 	/* create /proc/irq/1234 */
+	sprintf(name, "%d", irq);
 	desc->dir = proc_mkdir(name, root_irq_dir);
 	if (!desc->dir)
-		goto out_unlock;
+		return;
 
 #ifdef CONFIG_SMP
 	umode_t umode = S_IRUGO;
@@ -366,31 +357,27 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 		umode |= S_IWUSR;
 
 	/* create /proc/irq/<irq>/smp_affinity */
-	proc_create_data("smp_affinity", umode, desc->dir,
-			 &irq_affinity_proc_ops, irqp);
+	proc_create_data("smp_affinity", umode, desc->dir, &irq_affinity_proc_ops, irqp);
 
 	/* create /proc/irq/<irq>/affinity_hint */
 	proc_create_single_data("affinity_hint", 0444, desc->dir,
-			irq_affinity_hint_proc_show, irqp);
+				irq_affinity_hint_proc_show, irqp);
 
 	/* create /proc/irq/<irq>/smp_affinity_list */
 	proc_create_data("smp_affinity_list", umode, desc->dir,
 			 &irq_affinity_list_proc_ops, irqp);
 
-	proc_create_single_data("node", 0444, desc->dir, irq_node_proc_show,
-			irqp);
+	proc_create_single_data("node", 0444, desc->dir, irq_node_proc_show, irqp);
 # ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
 	proc_create_single_data("effective_affinity", 0444, desc->dir,
-			irq_effective_aff_proc_show, irqp);
+				irq_effective_aff_proc_show, irqp);
 	proc_create_single_data("effective_affinity_list", 0444, desc->dir,
-			irq_effective_aff_list_proc_show, irqp);
+				irq_effective_aff_list_proc_show, irqp);
 # endif
 #endif
 	proc_create_single_data("spurious", 0444, desc->dir,
-			irq_spurious_proc_show, (void *)(long)irq);
+				irq_spurious_proc_show, (void *)(long)irq);
 
-out_unlock:
-	mutex_unlock(&register_lock);
 }
 
 void unregister_irq_proc(unsigned int irq, struct irq_desc *desc)
@@ -467,7 +454,6 @@ int show_interrupts(struct seq_file *p, void *v)
 	int i = *(loff_t *) v, j;
 	struct irqaction *action;
 	struct irq_desc *desc;
-	unsigned long flags;
 
 	if (i > ACTUAL_NR_IRQS)
 		return 0;
@@ -486,19 +472,19 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
-	rcu_read_lock();
+	guard(rcu)();
 	desc = irq_to_desc(i);
 	if (!desc || irq_settings_is_hidden(desc))
-		goto outsparse;
+		return 0;
 
 	if (!desc->action || irq_desc_is_chained(desc) || !desc->kstat_irqs)
-		goto outsparse;
+		return 0;
 
 	seq_printf(p, "%*d: ", prec, i);
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", desc->kstat_irqs ? per_cpu(desc->kstat_irqs->cnt, j) : 0);
 
-	raw_spin_lock_irqsave(&desc->lock, flags);
+	guard(raw_spinlock_irq)(&desc->lock);
 	if (desc->irq_data.chip) {
 		if (desc->irq_data.chip->irq_print_chip)
 			desc->irq_data.chip->irq_print_chip(&desc->irq_data, p);
@@ -527,9 +513,6 @@ int show_interrupts(struct seq_file *p, void *v)
 	}
 
 	seq_putc(p, '\n');
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-outsparse:
-	rcu_read_unlock();
 	return 0;
 }
 #endif
-- 
2.53.0



