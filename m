Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0723112BF;
	Mon, 13 Oct 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369047; cv=none; b=ESZaUi47ZwjkNV8HOboNC26ZqSQAu+pQavdw2rQf/JwvOkljoAmXC+eccFLd7Rq/je3MR6ka2JqoyM5ljRueynIjPkJbB8fIAlcLaESoXgtZJCyidDjXuQnWtObVK4imXx2S4U0kBUtfcwPSW67SAVjEn6iDmr9RqboWiZet3FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369047; c=relaxed/simple;
	bh=hUrk/ZsVHwGAs+V+3IzB4n4QBscUT/eIViNjbpr0mvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWGKEy4KlMWOGAp+nokHl6QmzR/WNCZFaqq1WG2AJDrNZ+x8wdiGm4pKCzdsUk491QSmxjv+B21kPxy4EXCMkHcay/PrJnFmcZKmcL4rG31AUjjTqYAOEauqvfoMb6FtoU4NBQMthknxzayiJr5GYZx2OxKP0GkkC8BYrHCNCF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE/VfEJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE/VfEJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBA6C4CEE7;
	Mon, 13 Oct 2025 15:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369046;
	bh=hUrk/ZsVHwGAs+V+3IzB4n4QBscUT/eIViNjbpr0mvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xE/VfEJdgfVMHoP5i6izxdZZU8X6tZ8mL4bvV03Lb9c2nQ9qPNrs5or/CI3rKcbXH
	 vCQr4Jh2REK8gub4T23ThgurHhsU/TT3CSEtXpCf6bLGIqkjx8TQoW8jOW+TKoOwAa
	 /KjPjZUQO487N5hB6c6pr+SBn/pe6EFpNcPPQbUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 109/563] irqchip/gic-v5: Fix error handling in gicv5_its_irq_domain_alloc()
Date: Mon, 13 Oct 2025 16:39:30 +0200
Message-ID: <20251013144415.242804139@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a186120c780e21e4cfd186a925e34f718e30de88 ]

Code in gicv5_its_irq_domain_alloc() has two issues:

 - it checks the wrong return value/variable when calling gicv5_alloc_lpi()

 - The cleanup code does not take previous loop iterations into account

Fix both issues at once by adding the right gicv5_alloc_lpi() variable
check and by reworking the function cleanup code to take into account
current and previous iterations.

[ lpieralisi: Reworded commit message ]

Fixes: 57d72196dfc8 ("irqchip/gic-v5: Add GICv5 ITS support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/all/20250908082745.113718-4-lpieralisi@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-its.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
index 4701ef62b8b27..2fb58d76f5214 100644
--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -949,15 +949,18 @@ static int gicv5_its_irq_domain_alloc(struct irq_domain *domain, unsigned int vi
 	device_id = its_dev->device_id;
 
 	for (i = 0; i < nr_irqs; i++) {
-		lpi = gicv5_alloc_lpi();
+		ret = gicv5_alloc_lpi();
 		if (ret < 0) {
 			pr_debug("Failed to find free LPI!\n");
-			goto out_eventid;
+			goto out_free_irqs;
 		}
+		lpi = ret;
 
 		ret = irq_domain_alloc_irqs_parent(domain, virq + i, 1, &lpi);
-		if (ret)
-			goto out_free_lpi;
+		if (ret) {
+			gicv5_free_lpi(lpi);
+			goto out_free_irqs;
+		}
 
 		/*
 		 * Store eventid and deviceid into the hwirq for later use.
@@ -977,8 +980,13 @@ static int gicv5_its_irq_domain_alloc(struct irq_domain *domain, unsigned int vi
 
 	return 0;
 
-out_free_lpi:
-	gicv5_free_lpi(lpi);
+out_free_irqs:
+	while (--i >= 0) {
+		irqd = irq_domain_get_irq_data(domain, virq + i);
+		gicv5_free_lpi(irqd->parent_data->hwirq);
+		irq_domain_reset_irq_data(irqd);
+		irq_domain_free_irqs_parent(domain, virq + i, 1);
+	}
 out_eventid:
 	gicv5_its_free_eventid(its_dev, event_id_base, nr_irqs);
 	return ret;
-- 
2.51.0



