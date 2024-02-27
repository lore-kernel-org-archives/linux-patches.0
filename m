Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0BD1420A2;
	Tue, 27 Feb 2024 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042038; cv=none; b=KfhwH1+n/oys1HkYK/8rCbEZambcwpPLXlsd1lZmBfpIzW9wYWHs/lJE0kbWaYSfF6O07SHfial2fYvicqDkiGyvSIfP8YGG25lO24mQjmBs6q2wjvJqpuKrefw9H9eil85TZ9fc5CoGwUEYxAQs+enCQd8pEfdoLk7ZgTKYSQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042038; c=relaxed/simple;
	bh=NMiLemjLUQt/9mYnTy4qggHJPPto3Ln/M/VYRJuwMlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNmk3fO4pdtbnluml5kSpLK9zJ/l0lczqM8mmqz51At78znEIQYjb8HKeH1phuoY54pnG4xscLl+KmTv+LICd8EycLizA5XuEa51ZdCpznobkzsRsk3/teFi5EwhjPfYH5FSuczBHSXVapz86vTZSXEtqrsRjk6sAumOcFnqYhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbnvVAit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbnvVAit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34829C43390;
	Tue, 27 Feb 2024 13:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042038;
	bh=NMiLemjLUQt/9mYnTy4qggHJPPto3Ln/M/VYRJuwMlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbnvVAitW5PRAzUX9C5+JhsoHZV0+VTfh5QPTn35BeQdTAUNpYoqrgPZvcv+yT5aV
	 DPo7cnAnuwclzJ3NY8H0BYtgU36hHffN1ZzsXk6PL+o62fG/EiZJUK3bHcvdzcmSqw
	 D94DGIWft2DvRM0/2FyR8lqnl3Ly1PhND3fQ300s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/299] xen/events: remove some simple helpers from events_base.c
Date: Tue, 27 Feb 2024 14:24:00 +0100
Message-ID: <20240227131630.011371260@linuxfoundation.org>
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

[ Upstream commit 3bdb0ac350fe5e6301562143e4573971dd01ae0b ]

The helper functions type_from_irq() and cpu_from_irq() are just one
line functions used only internally.

Open code them where needed. At the same time modify and rename
get_evtchn_to_irq() to return a struct irq_info instead of the IRQ
number.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: fa765c4b4aed ("xen/events: close evtchn after mapping cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_base.c | 97 +++++++++++++-------------------
 1 file changed, 38 insertions(+), 59 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 57dfb512cdc5d..d3d7501628381 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -248,15 +248,6 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 	return 0;
 }
 
-static int get_evtchn_to_irq(evtchn_port_t evtchn)
-{
-	if (evtchn >= xen_evtchn_max_channels())
-		return -1;
-	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
-		return -1;
-	return READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
-}
-
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
 {
@@ -274,6 +265,19 @@ static void set_info_for_irq(unsigned int irq, struct irq_info *info)
 		irq_set_chip_data(irq, info);
 }
 
+static struct irq_info *evtchn_to_info(evtchn_port_t evtchn)
+{
+	int irq;
+
+	if (evtchn >= xen_evtchn_max_channels())
+		return NULL;
+	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
+		return NULL;
+	irq = READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
+
+	return (irq < 0) ? NULL : info_for_irq(irq);
+}
+
 /* Per CPU channel accounting */
 static void channels_on_cpu_dec(struct irq_info *info)
 {
@@ -429,7 +433,9 @@ static evtchn_port_t evtchn_from_irq(unsigned int irq)
 
 unsigned int irq_from_evtchn(evtchn_port_t evtchn)
 {
-	return get_evtchn_to_irq(evtchn);
+	struct irq_info *info = evtchn_to_info(evtchn);
+
+	return info ? info->irq : -1;
 }
 EXPORT_SYMBOL_GPL(irq_from_evtchn);
 
@@ -473,25 +479,11 @@ static unsigned pirq_from_irq(unsigned irq)
 	return info->u.pirq.pirq;
 }
 
-static enum xen_irq_type type_from_irq(unsigned irq)
-{
-	return info_for_irq(irq)->type;
-}
-
-static unsigned cpu_from_irq(unsigned irq)
-{
-	return info_for_irq(irq)->cpu;
-}
-
 unsigned int cpu_from_evtchn(evtchn_port_t evtchn)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	unsigned ret = 0;
-
-	if (irq != -1)
-		ret = cpu_from_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
-	return ret;
+	return info ? info->cpu : 0;
 }
 
 static void do_mask(struct irq_info *info, u8 reason)
@@ -540,13 +532,12 @@ static bool pirq_needs_eoi_flag(unsigned irq)
 static void bind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
 			       bool force_affinity)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	struct irq_info *info = info_for_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
-	BUG_ON(irq == -1);
+	BUG_ON(info == NULL);
 
 	if (IS_ENABLED(CONFIG_SMP) && force_affinity) {
-		struct irq_data *data = irq_get_irq_data(irq);
+		struct irq_data *data = irq_get_irq_data(info->irq);
 
 		irq_data_update_affinity(data, cpumask_of(cpu));
 		irq_data_update_effective_affinity(data, cpumask_of(cpu));
@@ -979,13 +970,13 @@ static void __unbind_from_irq(unsigned int irq)
 	}
 
 	if (VALID_EVTCHN(evtchn)) {
-		unsigned int cpu = cpu_from_irq(irq);
+		unsigned int cpu = info->cpu;
 		struct xenbus_device *dev;
 
 		if (!info->is_static)
 			xen_evtchn_close(evtchn);
 
-		switch (type_from_irq(irq)) {
+		switch (info->type) {
 		case IRQT_VIRQ:
 			per_cpu(virq_to_irq, cpu)[virq_from_irq(irq)] = -1;
 			break;
@@ -1208,15 +1199,16 @@ static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip,
 {
 	int irq;
 	int ret;
+	struct irq_info *info;
 
 	if (evtchn >= xen_evtchn_max_channels())
 		return -ENOMEM;
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = get_evtchn_to_irq(evtchn);
+	info = evtchn_to_info(evtchn);
 
-	if (irq == -1) {
+	if (!info) {
 		irq = xen_allocate_irq_dynamic();
 		if (irq < 0)
 			goto out;
@@ -1239,9 +1231,9 @@ static int bind_evtchn_to_irq_chip(evtchn_port_t evtchn, struct irq_chip *chip,
 		 */
 		bind_evtchn_to_cpu(evtchn, 0, false);
 	} else {
-		struct irq_info *info = info_for_irq(irq);
-		if (!WARN_ON(!info || info->type != IRQT_EVTCHN))
+		if (!WARN_ON(info->type != IRQT_EVTCHN))
 			info->refcnt++;
+		irq = info->irq;
 	}
 
 out:
@@ -1579,13 +1571,7 @@ EXPORT_SYMBOL_GPL(xen_set_irq_priority);
 
 int evtchn_make_refcounted(evtchn_port_t evtchn, bool is_static)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	struct irq_info *info;
-
-	if (irq == -1)
-		return -ENOENT;
-
-	info = info_for_irq(irq);
+	struct irq_info *info = evtchn_to_info(evtchn);
 
 	if (!info)
 		return -ENOENT;
@@ -1601,7 +1587,6 @@ EXPORT_SYMBOL_GPL(evtchn_make_refcounted);
 
 int evtchn_get(evtchn_port_t evtchn)
 {
-	int irq;
 	struct irq_info *info;
 	int err = -ENOENT;
 
@@ -1610,11 +1595,7 @@ int evtchn_get(evtchn_port_t evtchn)
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	irq = get_evtchn_to_irq(evtchn);
-	if (irq == -1)
-		goto done;
-
-	info = info_for_irq(irq);
+	info = evtchn_to_info(evtchn);
 
 	if (!info)
 		goto done;
@@ -1634,10 +1615,11 @@ EXPORT_SYMBOL_GPL(evtchn_get);
 
 void evtchn_put(evtchn_port_t evtchn)
 {
-	int irq = get_evtchn_to_irq(evtchn);
-	if (WARN_ON(irq == -1))
+	struct irq_info *info = evtchn_to_info(evtchn);
+
+	if (WARN_ON(!info))
 		return;
-	unbind_from_irq(irq);
+	unbind_from_irq(info->irq);
 }
 EXPORT_SYMBOL_GPL(evtchn_put);
 
@@ -1667,12 +1649,10 @@ struct evtchn_loop_ctrl {
 
 void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 {
-	int irq;
-	struct irq_info *info;
+	struct irq_info *info = evtchn_to_info(port);
 	struct xenbus_device *dev;
 
-	irq = get_evtchn_to_irq(port);
-	if (irq == -1)
+	if (!info)
 		return;
 
 	/*
@@ -1697,7 +1677,6 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 		}
 	}
 
-	info = info_for_irq(irq);
 	if (xchg_acquire(&info->is_active, 1))
 		return;
 
@@ -1711,7 +1690,7 @@ void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl)
 		info->eoi_time = get_jiffies_64() + event_eoi_delay;
 	}
 
-	generic_handle_irq(irq);
+	generic_handle_irq(info->irq);
 }
 
 int xen_evtchn_do_upcall(void)
@@ -1769,7 +1748,7 @@ void rebind_evtchn_irq(evtchn_port_t evtchn, int irq)
 	mutex_lock(&irq_mapping_update_lock);
 
 	/* After resume the irq<->evtchn mappings are all cleared out */
-	BUG_ON(get_evtchn_to_irq(evtchn) != -1);
+	BUG_ON(evtchn_to_info(evtchn));
 	/* Expect irq to have been bound before,
 	   so there should be a proper type */
 	BUG_ON(info->type == IRQT_UNBOUND);
-- 
2.43.0



