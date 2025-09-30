Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBC73C465;
	Tue, 30 Sep 2025 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243791; cv=none; b=GtFDqah1j7G6T91X+hgf3OSvuTx6dKp9xhC310O2Pj2ZPVtQbmnmmm5+k+XDRk7vZV855DLjntgc/etR0ajD4ew8Nvs9yGNN1SH4x+OuJ2CKSG6SpiLgEcOnUYaEIwicRYL9AQeDsenbLG506GkoqVo2K9QUob+RccWiQPSIrMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243791; c=relaxed/simple;
	bh=mADAgQTGpTJjGdFucB/kIR8x1vbP7mQRPvoTCKGHYXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQFU34DsO8/MNetpHs7O9XomacVugwbUQFEbt9URvyytaRHFbPHTZB/Oqzps6R0TgaR+FvrQuWrodCbYElEYxDSJA7VWm+pyNffqz8T1ZgjH7CUwpMiNcGPA7riBBllTMpoh1jyQ6IPFU5mCpcj/Qr6fWHoo3YCVNx4ihsCWP3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx+T986D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx+T986D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1996C4CEF0;
	Tue, 30 Sep 2025 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243791;
	bh=mADAgQTGpTJjGdFucB/kIR8x1vbP7mQRPvoTCKGHYXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx+T986DQKQEOReakgz8moriTji2litCR6fzz5MfdI45c2i+pEF1jfEV4FFhMUPY3
	 WxoQmJqFS2IT4bHtNs+D7aWDOUTZUh5WrzNPkA8teZWCWzxSBHCyRpnvYHwapLSJoJ
	 KMSCD8+T5bAuCQl+Ps8cX8bv+3TcU9nP3CDZ8VOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	John Garry <john.garry@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/81] genirq/affinity: Add irq_update_affinity_desc()
Date: Tue, 30 Sep 2025 16:46:21 +0200
Message-ID: <20250930143820.473385277@linuxfoundation.org>
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

From: John Garry <john.garry@huawei.com>

[ Upstream commit 1d3aec89286254487df7641c30f1b14ad1d127a5 ]

Add a function to allow the affinity of an interrupt be switched to
managed, such that interrupts allocated for platform devices may be
managed.

This new interface has certain limitations, and attempts to use it in the
following circumstances will fail:
- For when the kernel is configured for generic IRQ reservation mode (in
  config GENERIC_IRQ_RESERVATION_MODE). The reason being that it could
  conflict with managed vs. non-managed interrupt accounting.
- The interrupt is already started, which should not be the case during
  init
- The interrupt is already configured as managed, which means double init

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1606905417-183214-2-git-send-email-john.garry@huawei.com
Stable-dep-of: 915470e1b44e ("i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h |  8 +++++
 kernel/irq/manage.c       | 70 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 7b8bdc468492e..a601715279f50 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -341,6 +341,8 @@ extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
+extern int irq_update_affinity_desc(unsigned int irq,
+				    struct irq_affinity_desc *affinity);
 
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
@@ -376,6 +378,12 @@ static inline int irq_set_affinity_hint(unsigned int irq,
 	return -EINVAL;
 }
 
+static inline int irq_update_affinity_desc(unsigned int irq,
+					   struct irq_affinity_desc *affinity)
+{
+	return -EINVAL;
+}
+
 static inline int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2a8a5e1779c9c..44d77e834c229 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -332,6 +332,76 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
+/**
+ * irq_update_affinity_desc - Update affinity management for an interrupt
+ * @irq:	The interrupt number to update
+ * @affinity:	Pointer to the affinity descriptor
+ *
+ * This interface can be used to configure the affinity management of
+ * interrupts which have been allocated already.
+ *
+ * There are certain limitations on when it may be used - attempts to use it
+ * for when the kernel is configured for generic IRQ reservation mode (in
+ * config GENERIC_IRQ_RESERVATION_MODE) will fail, as it may conflict with
+ * managed/non-managed interrupt accounting. In addition, attempts to use it on
+ * an interrupt which is already started or which has already been configured
+ * as managed will also fail, as these mean invalid init state or double init.
+ */
+int irq_update_affinity_desc(unsigned int irq,
+			     struct irq_affinity_desc *affinity)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+	bool activated;
+	int ret = 0;
+
+	/*
+	 * Supporting this with the reservation scheme used by x86 needs
+	 * some more thought. Fail it for now.
+	 */
+	if (IS_ENABLED(CONFIG_GENERIC_IRQ_RESERVATION_MODE))
+		return -EOPNOTSUPP;
+
+	desc = irq_get_desc_buslock(irq, &flags, 0);
+	if (!desc)
+		return -EINVAL;
+
+	/* Requires the interrupt to be shut down */
+	if (irqd_is_started(&desc->irq_data)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Interrupts which are already managed cannot be modified */
+	if (irqd_affinity_is_managed(&desc->irq_data)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * Deactivate the interrupt. That's required to undo
+	 * anything an earlier activation has established.
+	 */
+	activated = irqd_is_activated(&desc->irq_data);
+	if (activated)
+		irq_domain_deactivate_irq(&desc->irq_data);
+
+	if (affinity->is_managed) {
+		irqd_set(&desc->irq_data, IRQD_AFFINITY_MANAGED);
+		irqd_set(&desc->irq_data, IRQD_MANAGED_SHUTDOWN);
+	}
+
+	cpumask_copy(desc->irq_common_data.affinity, &affinity->mask);
+
+	/* Restore the activation state */
+	if (activated)
+		irq_domain_activate_irq(&desc->irq_data, false);
+
+out_unlock:
+	irq_put_desc_busunlock(desc, flags);
+	return ret;
+}
+
 int __irq_set_affinity(unsigned int irq, const struct cpumask *mask, bool force)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-- 
2.51.0



