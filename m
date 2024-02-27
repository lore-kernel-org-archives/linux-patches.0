Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254DC13B79F;
	Tue, 27 Feb 2024 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042036; cv=none; b=iXzSqnN5QE5iMdW1LkbgpfleAIngFDNkz1rWteX9aS+ASqkFmlf6Cpmnj5H03Hb7tYYm6fgx/fNxNd7E5v1P/bYBWxQKRUGLZWCQTiEbUiNb+3C89U/rUbesiCwjzYRfMEP80eAh/mwFKEiFmt/tf/z5T2459XhFj88K/WxLL2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042036; c=relaxed/simple;
	bh=86QwbxP5UKYPw/rF2JoMWi8MaZS1HNNS/IrnF8S4QHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAmCe59OBnFbh33Ics8UOl/RdU1qSs0QjwkhPI8TcPjfksc5k+Kv4FzC+/Q/hdbs+oUWpjWB8dK9BeRixXDAAEd+QEYwnu2foth44z1xM/P3xDGcBN9SU29YRHw0umD1S67wn/pQxnr7gIwebVAmvITIhO79JbKy8elEn2xRsbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04Y1l7+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04Y1l7+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6682CC433F1;
	Tue, 27 Feb 2024 13:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042035;
	bh=86QwbxP5UKYPw/rF2JoMWi8MaZS1HNNS/IrnF8S4QHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04Y1l7+Z/harscf1Ni/9QiaBKw4SUwX2MrNThqLK2ZtrVnoBL35PZATaGELEh+wHz
	 UAgi6f4sm0bc3Qq/zskRU9VdcVOS3avJYNMf/GZAVvBnFQUyHLwsg439qRLXi8GGFE
	 VVQTqWRVp+nd0pjz1ASPXeLL9J6Y6X0XXP4VBbaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/299] xen/events: reduce externally visible helper functions
Date: Tue, 27 Feb 2024 14:23:59 +0100
Message-ID: <20240227131629.980265940@linuxfoundation.org>
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

[ Upstream commit 686464514fbebb6c8de4415238319e414c3500a4 ]

get_evtchn_to_irq() has only one external user while irq_from_evtchn()
provides the same functionality and is exported for a wider user base.
Modify the only external user of get_evtchn_to_irq() to use
irq_from_evtchn() instead and make get_evtchn_to_irq() static.

evtchn_from_irq() and irq_from_virq() have a single external user and
can easily be combined to a new helper irq_evtchn_from_virq() allowing
to drop irq_from_virq() and to make evtchn_from_irq() static.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Stable-dep-of: fa765c4b4aed ("xen/events: close evtchn after mapping cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/events/events_2l.c       |  8 ++++----
 drivers/xen/events/events_base.c     | 13 +++++++++----
 drivers/xen/events/events_internal.h |  1 -
 include/xen/events.h                 |  4 ++--
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index b8f2f971c2f0f..e3585330cf98b 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -171,11 +171,11 @@ static void evtchn_2l_handle_events(unsigned cpu, struct evtchn_loop_ctrl *ctrl)
 	int i;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
+	evtchn_port_t evtchn;
 
 	/* Timer interrupt has highest priority. */
-	irq = irq_from_virq(cpu, VIRQ_TIMER);
+	irq = irq_evtchn_from_virq(cpu, VIRQ_TIMER, &evtchn);
 	if (irq != -1) {
-		evtchn_port_t evtchn = evtchn_from_irq(irq);
 		word_idx = evtchn / BITS_PER_LONG;
 		bit_idx = evtchn % BITS_PER_LONG;
 		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx))
@@ -328,9 +328,9 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 	for (i = 0; i < EVTCHN_2L_NR_CHANNELS; i++) {
 		if (sync_test_bit(i, BM(sh->evtchn_pending))) {
 			int word_idx = i / BITS_PER_EVTCHN_WORD;
-			printk("  %d: event %d -> irq %d%s%s%s\n",
+			printk("  %d: event %d -> irq %u%s%s%s\n",
 			       cpu_from_evtchn(i), i,
-			       get_evtchn_to_irq(i),
+			       irq_from_evtchn(i),
 			       sync_test_bit(word_idx, BM(&v->evtchn_pending_sel))
 			       ? "" : " l2-clear",
 			       !sync_test_bit(i, BM(sh->evtchn_mask))
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index cd33a418344a8..57dfb512cdc5d 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -248,7 +248,7 @@ static int set_evtchn_to_irq(evtchn_port_t evtchn, unsigned int irq)
 	return 0;
 }
 
-int get_evtchn_to_irq(evtchn_port_t evtchn)
+static int get_evtchn_to_irq(evtchn_port_t evtchn)
 {
 	if (evtchn >= xen_evtchn_max_channels())
 		return -1;
@@ -415,7 +415,7 @@ static void xen_irq_info_cleanup(struct irq_info *info)
 /*
  * Accessors for packed IRQ information.
  */
-evtchn_port_t evtchn_from_irq(unsigned irq)
+static evtchn_port_t evtchn_from_irq(unsigned int irq)
 {
 	const struct irq_info *info = NULL;
 
@@ -433,9 +433,14 @@ unsigned int irq_from_evtchn(evtchn_port_t evtchn)
 }
 EXPORT_SYMBOL_GPL(irq_from_evtchn);
 
-int irq_from_virq(unsigned int cpu, unsigned int virq)
+int irq_evtchn_from_virq(unsigned int cpu, unsigned int virq,
+			 evtchn_port_t *evtchn)
 {
-	return per_cpu(virq_to_irq, cpu)[virq];
+	int irq = per_cpu(virq_to_irq, cpu)[virq];
+
+	*evtchn = evtchn_from_irq(irq);
+
+	return irq;
 }
 
 static enum ipi_vector ipi_from_irq(unsigned irq)
diff --git a/drivers/xen/events/events_internal.h b/drivers/xen/events/events_internal.h
index 4d3398eff9cdf..19ae31695edcf 100644
--- a/drivers/xen/events/events_internal.h
+++ b/drivers/xen/events/events_internal.h
@@ -33,7 +33,6 @@ struct evtchn_ops {
 
 extern const struct evtchn_ops *evtchn_ops;
 
-int get_evtchn_to_irq(evtchn_port_t evtchn);
 void handle_irq_for_port(evtchn_port_t port, struct evtchn_loop_ctrl *ctrl);
 
 unsigned int cpu_from_evtchn(evtchn_port_t evtchn);
diff --git a/include/xen/events.h b/include/xen/events.h
index 23932b0673dc7..7488cd51fbf4f 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -101,8 +101,8 @@ void xen_poll_irq_timeout(int irq, u64 timeout);
 
 /* Determine the IRQ which is bound to an event channel */
 unsigned int irq_from_evtchn(evtchn_port_t evtchn);
-int irq_from_virq(unsigned int cpu, unsigned int virq);
-evtchn_port_t evtchn_from_irq(unsigned irq);
+int irq_evtchn_from_virq(unsigned int cpu, unsigned int virq,
+			 evtchn_port_t *evtchn);
 
 int xen_set_callback_via(uint64_t via);
 int xen_evtchn_do_upcall(void);
-- 
2.43.0



