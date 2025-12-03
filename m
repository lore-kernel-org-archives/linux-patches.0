Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DF6305978;
	Wed,  3 Dec 2025 15:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775995; cv=none; b=ASqIUcV3PTTV+hpxMNvTk/1fTW8pVP85ecnuVjIA5rzYm0s7fsIGxoKNZkhV07JjQ0t2AH7LNzPtur27PkQvmLJuEsBRfROmNYgwtufIbWHiAZZNZw8b7Rz4kehcw4TcuoIQ3ZRtaU+JlFVAOq2s3uMkU5rDQWKu/hhWQPAAIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775995; c=relaxed/simple;
	bh=vXqavLvhY9pWmV9QDH2At740zO9Y7lykNQosjGsjgqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbfCdmKjQz6XlzjZImrsL8UFoMz+83oiVKpw7Y0G+8BiB98Ucf6te3rXTI2hhOkzA5mBLmUMCLtYKktL8y8JXS0CDlUXXyFYk2HkrR8pM5VMrl9xEDPNnIHC53153TKgMcL9FaYup3cK7uaTo8Z8d8lvQZsT743VR3PuGytaR1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6Oy1GvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6Oy1GvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64A4C4CEF5;
	Wed,  3 Dec 2025 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775995;
	bh=vXqavLvhY9pWmV9QDH2At740zO9Y7lykNQosjGsjgqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6Oy1GvFPCbW2IICZnd0UUoebFWhAELERAJ9N56jYs9YMc8Hr/NmafzezkyAB+QbR
	 ZI0k4lN5spy6wik5jJh7ermpMfpeSIUokiUNrUUUX0xInSh74wPYO/7upaqdHhD4go
	 d9L+8Go35N+pPo6zW9a621pUVXm0u/j/T4uQr8IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/300] irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment
Date: Wed,  3 Dec 2025 16:24:13 +0100
Message-ID: <20251203152402.433648958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Christian Bruel <christian.bruel@foss.st.com>

[ Upstream commit 2ef3886ce626dcdab0cbc452dbbebc19f57133d8 ]

The PCI Local Bus Specification 3.0 (section 6.8.1.6) allows modifying the
low-order bits of the MSI Message DATA register to encode nr_irqs interrupt
numbers in the log2(nr_irqs) bits for the domain.

The problem arises if the base vector (GICV2m base spi) is not aligned with
nr_irqs; in this case, the low-order log2(nr_irqs) bits from the base
vector conflict with the nr_irqs masking, causing the wrong MSI interrupt
to be identified.

To fix this, use bitmap_find_next_zero_area_off() instead of
bitmap_find_free_region() to align the initial base vector with nr_irqs.

Signed-off-by: Christian Bruel <christian.bruel@foss.st.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20250902091045.220847-1-christian.bruel@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v2m.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index b17deec1c5d4d..06c5087a439d7 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -179,14 +179,19 @@ static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
 {
 	msi_alloc_info_t *info = args;
 	struct v2m_data *v2m = NULL, *tmp;
-	int hwirq, offset, i, err = 0;
+	int hwirq, i, err = 0;
+	unsigned long offset;
+	unsigned long align_mask = nr_irqs - 1;
 
 	spin_lock(&v2m_lock);
 	list_for_each_entry(tmp, &v2m_nodes, entry) {
-		offset = bitmap_find_free_region(tmp->bm, tmp->nr_spis,
-						 get_count_order(nr_irqs));
-		if (offset >= 0) {
+		unsigned long align_off = tmp->spi_start - (tmp->spi_start & ~align_mask);
+
+		offset = bitmap_find_next_zero_area_off(tmp->bm, tmp->nr_spis, 0,
+							nr_irqs, align_mask, align_off);
+		if (offset < tmp->nr_spis) {
 			v2m = tmp;
+			bitmap_set(v2m->bm, offset, nr_irqs);
 			break;
 		}
 	}
-- 
2.51.0



