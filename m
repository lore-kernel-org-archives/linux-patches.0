Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598793CB2DB;
	Fri,  4 Sep 2026 06:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502677; cv=none; b=CFDZ53SfHHvpIuKwqpj1qgN0M8/PgF1PwfAMU3ixjlRRu+eUEJr5QOBWl6pEwOpIFmRcbKi4mKWD6sUCDbhofbWyqQSQp0y4XhV3wMaMDLCM6KG2EMx1rhDXLqAkQ5JtL2rQBnzx/j5bPwLOI4bSjly6JN9cUuut9za54dQHSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502677; c=relaxed/simple;
	bh=jSh7c2xPmM46QkHQaV0R2xt8xLgL3jKt1nNVPOvx1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNVaEndhAnyCo8r4G3UsUXDkqrtnDPgA1LTzd2zi64AgQ1bbUsv8eMpApFrodgke314z00BQTVypNBlTNX5hgnW1Ii/ve8AMfB6+n62vBVpgoKEeBm34Fu4hVJSytv/HC/jPl0rkddW6T3l52juJzz9oEmeWf8I0OKEe3vws6wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyxHH4e0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyxHH4e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D8E1F00A3D;
	Fri,  4 Sep 2026 06:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502676;
	bh=JEMibYRnoNix5y0O87ALPCDKp5XZJFTU0BfKZRRw+KM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyxHH4e0Ni3eD+01rmtkzXbJ/O+EfKUvDICAjzDs7moq6xp7j8ATTktIXW6Z8yTsi
	 XSBJR1kvpNBJbP7YX46FgqJi1GKuqtu6qKmZClFw7I/IFLCUKA5DuNOF10A9Siw7jk
	 LopxHUg6CTzx6PpobaI3riT1D2K1nRNdBoiJqs3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Tariq <alitariq45892@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.12 291/403] PCI: plda: Fix use-after-free of event IRQs during teardown
Date: Fri,  4 Sep 2026 07:01:34 +0200
Message-ID: <20260904045741.468221194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Ali Tariq <alitariq45892@gmail.com>

commit 26b73bae01d6eb81a4a38f36101812f20b2639de upstream.

plda_pcie_irq_domain_deinit() removes pcie->event_domain via
irq_domain_remove(), but the per-event IRQs mapped from that domain
are requested with devm_request_irq() in plda_init_interrupts(). The
actual free_irq() for a devm-managed IRQ is deferred by devres until
after the calling probe()/remove() function returns.

This means irq_domain_remove() can free the domain's internal data
before the deferred free_irq() for IRQs still mapped into it has run.
When devres later processes that deferred cleanup, it can end up
dereferencing the already-freed domain.

Free each event IRQ explicitly with devm_free_irq() before removing
the domain. This triggers the free immediately and removes the IRQ
from the devres tracking list, so devres will not attempt to free it
a second time later.

Also dispose of the event, INTx, and MSI IRQ mappings with
irq_dispose_mapping() before their owning domains are removed.

Finally, guard the calls to irq_set_chained_handler_and_data() for
pcie->irq, pcie->msi_irq, and pcie->intx_irq so they only run when
those fields hold a valid (>0) IRQ number.

This is a pre-existing issue, flagged by automated review during work
on an earlier, unrelated patch to this driver.

Build-tested and boot-tested on StarFive VisionFive v1.2A board

Fixes: 76c911396807 ("PCI: plda: Add host init/deinit and map bus functions")
Closes: https://lore.kernel.org/linux-pci/20260714115343.4D49E1F000E9@smtp.kernel.org/
Signed-off-by: Ali Tariq <alitariq45892@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260723140434.675512-2-alitariq45892@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-plda-host.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -561,9 +561,27 @@ EXPORT_SYMBOL_GPL(plda_pcie_setup_iomems
 
 static void plda_pcie_irq_domain_deinit(struct plda_pcie_rp *pcie)
 {
-	irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
-	irq_set_chained_handler_and_data(pcie->msi_irq, NULL, NULL);
-	irq_set_chained_handler_and_data(pcie->intx_irq, NULL, NULL);
+	u32 i, event_irq;
+
+	if (pcie->irq > 0)
+		irq_set_chained_handler_and_data(pcie->irq, NULL, NULL);
+	if (pcie->msi_irq > 0)
+		irq_set_chained_handler_and_data(pcie->msi_irq, NULL, NULL);
+	if (pcie->intx_irq > 0)
+		irq_set_chained_handler_and_data(pcie->intx_irq, NULL, NULL);
+
+	for_each_set_bit(i, &pcie->events_bitmap, pcie->num_events) {
+		event_irq = irq_find_mapping(pcie->event_domain, i);
+		if (event_irq) {
+			devm_free_irq(pcie->dev, event_irq, pcie);
+			irq_dispose_mapping(event_irq);
+		}
+	}
+
+	if (pcie->intx_irq)
+		irq_dispose_mapping(pcie->intx_irq);
+	if (pcie->msi_irq)
+		irq_dispose_mapping(pcie->msi_irq);
 
 	irq_domain_remove(pcie->msi.msi_domain);
 	irq_domain_remove(pcie->msi.dev_domain);


