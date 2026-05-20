Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECE73F9280;
	Wed, 20 May 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299981; cv=none; b=lCIEmEEPdWyRVXj/2FXwqR108eG5YKzazwr/vbPCC1TCk+Fc3JjevkV5w7bO/loLXSdYeg6oEqJD8ZPvb55ujFX6eYpa+Pl8ZnclRMs9dqVIe8uJooiMyicutrSkYnFa0MBu5VWDOaGqTzoIbgqcUQ9uIA1jXMghHjcgWjr83SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299981; c=relaxed/simple;
	bh=fJrck+QPqq48zQyDp7LV9Z/wF8FPgBPIBDBJKhb7ooc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG4sSMptJLfJ7XjTMcM+MhWf3QwzqeBi0oDGLSU5spTPptUrCymBlwSYN9dOdjHAQvAqgGsLhqFS20NJV7/64Al7FyJ+DBkjk1rRxRWtDcYUKy5bM8rAy8to/z+0sGHDJ/OeGkFgOYm4PPS4H1fx3yCxOs+zf+wTTDGAeFHtqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/hW8AJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/hW8AJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6581C1F00893;
	Wed, 20 May 2026 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299978;
	bh=jbV+sR+PpAyQJbMlvHG3LmQhqb048YI3qB8Fj/QNfBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/hW8AJYSusfHKbAEBNC5A243JReVndmSHnyrPFYkQ8rXFAM5V6RqA40USbS5O1VL
	 UWvXa5Jwo92BVNsPo7iMrs4ro/r7GisUlAWPCqSNvveThzZXN0B1D3LetJWyEHOxSN
	 iu6/tVVuRrQmsTSfSncvxTX/wPF/OK3wVHYnfUyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 6.18 932/957] irqchip/gic-v5: Allocate ITS parent LPIs as a range
Date: Wed, 20 May 2026 18:23:35 +0200
Message-ID: <20260520162154.801050522@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

commit a7c7e42654b6a8676610ee09d22901432c4851af upstream.

The ITS MSI domain no longer manages LPI allocation directly. LPIs are
allocated and freed by the parent LPI domain, which can now handle a
full range of interrupts and unwind partial allocations internally.

Make the ITS domain request and release the parent IRQs as a single
range instead of iterating over each interrupt. The ITS allocation
path then only needs to reserve EventIDs, allocate the parent range,
and fill in the ITS irq_data for each MSI. Since no operation in the
per-MSI loop can fail, the partial parent-free unwind becomes
unnecessary.

On teardown, reset the ITS irq_data for the range and then release the
parent range in one call, leaving LPI teardown to the LPI domain.

Fixes: 0f0101325876 ("irqchip/gic-v5: Add GICv5 LPI/IPI support")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260506093634.382062-4-sascha.bischoff@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v5-its.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -935,6 +935,7 @@ static int gicv5_its_irq_domain_alloc(st
 	int ret, i;
 
 	its_dev = info->scratchpad[0].ptr;
+	device_id = its_dev->device_id;
 
 	ret = gicv5_its_alloc_eventid(its_dev, info, nr_irqs, &event_id_base);
 	if (ret)
@@ -944,14 +945,11 @@ static int gicv5_its_irq_domain_alloc(st
 	if (ret)
 		goto out_eventid;
 
-	device_id = its_dev->device_id;
+	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, NULL);
+	if (ret)
+		goto out_eventid;
 
 	for (i = 0; i < nr_irqs; i++) {
-		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, NULL);
-		if (ret) {
-			goto out_free_irqs;
-		}
-
 		/*
 		 * Store eventid and deviceid into the hwirq for later use.
 		 *
@@ -970,12 +968,6 @@ static int gicv5_its_irq_domain_alloc(st
 
 	return 0;
 
-out_free_irqs:
-	while (--i >= 0) {
-		irqd = irq_domain_get_irq_data(domain, virq + i);
-		irq_domain_reset_irq_data(irqd);
-		irq_domain_free_irqs_parent(domain, virq + i, 1);
-	}
 out_eventid:
 	gicv5_its_free_eventid(its_dev, event_id_base, nr_irqs);
 	return ret;
@@ -998,14 +990,14 @@ static void gicv5_its_irq_domain_free(st
 	bitmap_release_region(its_dev->event_map, event_id_base,
 			      get_count_order(nr_irqs));
 
-	/*  Hierarchically free irq data */
 	for (i = 0; i < nr_irqs; i++) {
 		d = irq_domain_get_irq_data(domain, virq + i);
-
 		irq_domain_reset_irq_data(d);
-		irq_domain_free_irqs_parent(domain, virq + i, 1);
 	}
 
+	/*  Hierarchically free irq data */
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+
 	gicv5_its_syncr(its, its_dev);
 	gicv5_irs_syncr();
 }


