Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010213F006;
	Tue, 27 Feb 2024 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042041; cv=none; b=mYhb4hv2ayhmwsYMjKwZvlKw89hkwo0yL9EiHVyLg9RwRjid2eOcKa4dcoCdBsaoIdHzEl9lzrRWjtoQngfLef8CCpFH41CTypXlzRB2qn2T9wnWOgII7K+Htm9vUIrmW2vTF3uKPqD/WQlv/y5Fjtw7UvU5f8xmp7QGnqSCrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042041; c=relaxed/simple;
	bh=LALDyFAg38E7b92c3bXWRdX7d6pOk9s8gyFC4jPZVmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExDzr7KFheuVeJsnO5Z8NFgOI9hHywZnyz39SofKdDOvevbUeE4vP3UepKe4RcMhtKtiDNfvLZMZSrW7ZIAvskhi58l9/DKINpqe6NHrv5y/xymdGiXWJ5hQ6HLYfY+KuLCEuupef8RT9JXPAOjvEwc7ziL8zFoFPS/JnezZflA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wc7PuWPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wc7PuWPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB021C433F1;
	Tue, 27 Feb 2024 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042041;
	bh=LALDyFAg38E7b92c3bXWRdX7d6pOk9s8gyFC4jPZVmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wc7PuWPEZ+jpJKBQkv+xH2lh9DlDgOjQ6WEf0fLOBJ+N01ALBkM1xPXYbQU/b2BAA
	 HShnE8QT/leKNyIqJ7dO6yRA+rcNkDjDnS0w3Y8H9HgB3LDm7BJrUCDcbqs2Tekdxk
	 JkTrPN4c7B4Z4YpFLGIUUfeOyPz8ckjsTw8j69qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/299] xen/events: drop xen_allocate_irqs_dynamic()
Date: Tue, 27 Feb 2024 14:24:01 +0100
Message-ID: <20240227131630.041663857@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 5dd9ad32d7758b1a76742f394acf0eb3ac8a636a ]

Instead of having a common function for allocating a single IRQ or a
consecutive number of IRQs, split up the functionality into the callers
of xen_allocate_irqs_dynamic().

This allows to handle any allocation error in xen_irq_init() gracefully
instead of panicing the system. Let xen_irq_init() return the irq_info
pointer or NULL in case of an allocation error.

Additionally set the IRQ into irq_info already at allocation time, as
otherwise the IRQ would be '0' (which is a valid IRQ number) until
being set.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: fa765c4b4aed ("xen/events: close evtchn after mapping cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 74 +++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index d3d7501628381..4dfd68382465b 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -304,6 +304,13 @@ static void channels_on_cpu_inc(struct irq_info *info)
 	info->is_accounted = 1;
 }
 
+static void xen_irq_free_desc(unsigned int irq)
+{
+	/* Legacy IRQ descriptors are managed by the arch. */
+	if (irq >= nr_legacy_irqs())
+		irq_free_desc(irq);
+}
+
 static void delayed_free_irq(struct work_struct *work)
 {
 	struct irq_info *info = container_of(to_rcu_work(work), struct irq_info,
@@ -315,9 +322,7 @@ static void delayed_free_irq(struct work_struct *work)
 
 	kfree(info);
 
-	/* Legacy IRQ descriptors are managed by the arch. */
-	if (irq >= nr_legacy_irqs())
-		irq_free_desc(irq);
+	xen_irq_free_desc(irq);
 }
 
 /* Constructors for packed IRQ information. */
@@ -332,7 +337,6 @@ static int xen_irq_info_common_setup(struct irq_info *info,
 	BUG_ON(info->type != IRQT_UNBOUND && info->type != type);
 
 	info->type = type;
-	info->irq = irq;
 	info->evtchn = evtchn;
 	info->cpu = cpu;
 	info->mask_reason = EVT_MASK_REASON_EXPLICIT;
@@ -733,47 +737,45 @@ void xen_irq_lateeoi(unsigned int irq, unsigned int eoi_flags)
 }
 EXPORT_SYMBOL_GPL(xen_irq_lateeoi);
 
-static void xen_irq_init(unsigned irq)
+static struct irq_info *xen_irq_init(unsigned int irq)
 {
 	struct irq_info *info;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (info == NULL)
-		panic("Unable to allocate metadata for IRQ%d\n", irq);
+	if (info) {
+		info->irq = irq;
+		info->type = IRQT_UNBOUND;
+		info->refcnt = -1;
+		INIT_RCU_WORK(&info->rwork, delayed_free_irq);
 
-	info->type = IRQT_UNBOUND;
-	info->refcnt = -1;
-	INIT_RCU_WORK(&info->rwork, delayed_free_irq);
+		set_info_for_irq(irq, info);
+		/*
+		 * Interrupt affinity setting can be immediate. No point
+		 * in delaying it until an interrupt is handled.
+		 */
+		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
 
-	set_info_for_irq(irq, info);
-	/*
-	 * Interrupt affinity setting can be immediate. No point
-	 * in delaying it until an interrupt is handled.
-	 */
-	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
+		INIT_LIST_HEAD(&info->eoi_list);
+		list_add_tail(&info->list, &xen_irq_list_head);
+	}
 
-	INIT_LIST_HEAD(&info->eoi_list);
-	list_add_tail(&info->list, &xen_irq_list_head);
+	return info;
 }
 
-static int __must_check xen_allocate_irqs_dynamic(int nvec)
+static inline int __must_check xen_allocate_irq_dynamic(void)
 {
-	int i, irq = irq_alloc_descs(-1, 0, nvec, -1);
+	int irq = irq_alloc_desc_from(0, -1);
 
 	if (irq >= 0) {
-		for (i = 0; i < nvec; i++)
-			xen_irq_init(irq + i);
+		if (!xen_irq_init(irq)) {
+			xen_irq_free_desc(irq);
+			irq = -1;
+		}
 	}
 
 	return irq;
 }
 
-static inline int __must_check xen_allocate_irq_dynamic(void)
-{
-
-	return xen_allocate_irqs_dynamic(1);
-}
-
 static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 {
 	int irq;
@@ -793,7 +795,10 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 	else
 		irq = irq_alloc_desc_at(gsi, -1);
 
-	xen_irq_init(irq);
+	if (!xen_irq_init(irq)) {
+		xen_irq_free_desc(irq);
+		irq = -1;
+	}
 
 	return irq;
 }
@@ -963,6 +968,11 @@ static void __unbind_from_irq(unsigned int irq)
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
 	struct irq_info *info = info_for_irq(irq);
 
+	if (!info) {
+		xen_irq_free_desc(irq);
+		return;
+	}
+
 	if (info->refcnt > 0) {
 		info->refcnt--;
 		if (info->refcnt != 0)
@@ -1101,11 +1111,14 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = xen_allocate_irqs_dynamic(nvec);
+	irq = irq_alloc_descs(-1, 0, nvec, -1);
 	if (irq < 0)
 		goto out;
 
 	for (i = 0; i < nvec; i++) {
+		if (!xen_irq_init(irq + i))
+			goto error_irq;
+
 		irq_set_chip_and_handler_name(irq + i, &xen_pirq_chip, handle_edge_irq, name);
 
 		ret = xen_irq_info_pirq_setup(irq + i, 0, pirq + i, 0, domid,
@@ -1753,6 +1766,7 @@ void rebind_evtchn_irq(evtchn_port_t evtchn, int irq)
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
 
+	info->irq = irq;
 	(void)xen_irq_info_evtchn_setup(irq, evtchn, NULL);
 
 	mutex_unlock(&irq_mapping_update_lock);
-- 
2.43.0



