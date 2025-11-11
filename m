Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E34C97;
	Tue, 11 Nov 2025 00:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822680; cv=none; b=eCEZNA857JYk8gt4UOwCFaOOnpYSu5spY/DZzMf3p2i7Nwby81RhchfRyViqbLfCLGTf7XfXPurp0khiLakdL/pYxU9Wl1ERssWm9LuIggGKGYjbh99tEIaBHlwD4f2+MjDi9bdafN7PPM142GU6k74TiKuOwE+2tWnDr2UWNBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822680; c=relaxed/simple;
	bh=LINQ30lL8F9A6No0gmmaZ+r5zT9Z5lGPJveDAznKwvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ss/+kOqryoVKavOs1r/9dRpcPsm+0KMERc9Vl+ZGur59x2qOaq1s4oyvcF939vIaQ1nclJePqAd1JOGTn99uyLryiz8m1xEJ4os8F8oJj4ePnVV6xKm6fP9mGBFOkUtKwFWCNFMsJ8x/wL2xYxt02H2j58BuEKR8ZAYfoZU64HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGG6TJWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGG6TJWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9995EC116B1;
	Tue, 11 Nov 2025 00:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822679;
	bh=LINQ30lL8F9A6No0gmmaZ+r5zT9Z5lGPJveDAznKwvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGG6TJWSKaV8GRs/GF+63guL5JVlTr9fpLsvBFT4E2wVWVQ7/tj2/RBLqubZxMduN
	 7qQs4jJQVdO/Kym3oHOkHn0f2kLXPrif37okMguh2obEXJ5eOsyKLJcdZNlk7qAkoX
	 AVAG92rrLJRWC/BxYSxZHjCyP6kdIKrH/skaerGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bruel <christian.bruel@foss.st.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 147/849] irqchip/gic-v2m: Handle Multiple MSI base IRQ Alignment
Date: Tue, 11 Nov 2025 09:35:17 +0900
Message-ID: <20251111004539.965594622@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 24ef5af569fe4..8a3410c2b7b57 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -153,14 +153,19 @@ static int gicv2m_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
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



