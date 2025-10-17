Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1E23328E7;
	Fri, 17 Oct 2025 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713823; cv=none; b=tIc9oFCnJJB4U/eRHGijnZx8VE91pxjsVlr3j2cuUcunBOvoz5dUQ9yxHCxbT8JwJAhqOZVuV500jMC+7Ud8X6KaLIKIgBZSa4R6EGlIjAjihxfzGBTnFpPgYK7w53Hwy2KaeGr4X4hz9P6hGuL/Q77woyuVMNsR7S3FnJ2iY1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713823; c=relaxed/simple;
	bh=nlFIHTv2pDU42LOS5c2LejGpylN5iZcj04UgA4HMRg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjbL9wTlS87tI+yOWyYWJT1hOZq/LCczCGQpG3m43vfBcaKEQmSKsSlPucX3f3scGfA6XANsFvpGgqciZRO2l9ucaW8FJgXtq090H7boEDYcr35FDxO8Dhq1cFydpN5rrFfyEYoFYP5n+nGDOp75oafFjEjZsg20bdgAqUHD8NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11usalfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11usalfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3248C4CEE7;
	Fri, 17 Oct 2025 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713823;
	bh=nlFIHTv2pDU42LOS5c2LejGpylN5iZcj04UgA4HMRg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11usalfNxOQ4SwDxdgRM9ZoPk/iu1vJ/oEw6vT4YP0xSbdpiJn6lz/R5JXouYxoIP
	 Ubv8HmgW5aGd5q4ShYCFJ8o8YspgaAdCNmoZ1JBKBVvrnrK/EcBU0P45kIHfq2MdWO
	 GlSVGJc8GsBkcXmiyb7t1UnfvxfMSIxB6eVwnJns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 133/201] PCI: rcar-host: Convert struct rcar_msi mask_lock into raw spinlock
Date: Fri, 17 Oct 2025 16:53:14 +0200
Message-ID: <20251017145139.625476184@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit 5ed35b4d490d8735021cce9b715b62a418310864 upstream.

The rcar_msi_irq_unmask() function may be called from a PCI driver
request_threaded_irq() function. This triggers kernel/irq/manage.c
__setup_irq() which locks raw spinlock &desc->lock descriptor lock
and with that descriptor lock held, calls rcar_msi_irq_unmask().

Since the &desc->lock descriptor lock is a raw spinlock, and the rcar_msi
.mask_lock is not a raw spinlock, this setup triggers 'BUG: Invalid wait
context' with CONFIG_PROVE_RAW_LOCK_NESTING=y.

Use scoped_guard() to simplify the locking.

Fixes: 83ed8d4fa656 ("PCI: rcar: Convert to MSI domains")
Reported-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Reported-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250909162707.13927-2-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rcar-host.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/delay.h>
@@ -36,7 +37,7 @@ struct rcar_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	struct mutex map_lock;
-	spinlock_t mask_lock;
+	raw_spinlock_t mask_lock;
 	int irq1;
 	int irq2;
 };
@@ -624,28 +625,26 @@ static void rcar_msi_irq_mask(struct irq
 {
 	struct rcar_msi *msi = irq_data_get_irq_chip_data(d);
 	struct rcar_pcie *pcie = &msi_to_host(msi)->pcie;
-	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
-	value = rcar_pci_read_reg(pcie, PCIEMSIIER);
-	value &= ~BIT(d->hwirq);
-	rcar_pci_write_reg(pcie, value, PCIEMSIIER);
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &msi->mask_lock) {
+		value = rcar_pci_read_reg(pcie, PCIEMSIIER);
+		value &= ~BIT(d->hwirq);
+		rcar_pci_write_reg(pcie, value, PCIEMSIIER);
+	}
 }
 
 static void rcar_msi_irq_unmask(struct irq_data *d)
 {
 	struct rcar_msi *msi = irq_data_get_irq_chip_data(d);
 	struct rcar_pcie *pcie = &msi_to_host(msi)->pcie;
-	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
-	value = rcar_pci_read_reg(pcie, PCIEMSIIER);
-	value |= BIT(d->hwirq);
-	rcar_pci_write_reg(pcie, value, PCIEMSIIER);
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &msi->mask_lock) {
+		value = rcar_pci_read_reg(pcie, PCIEMSIIER);
+		value |= BIT(d->hwirq);
+		rcar_pci_write_reg(pcie, value, PCIEMSIIER);
+	}
 }
 
 static int rcar_msi_set_affinity(struct irq_data *d, const struct cpumask *mask, bool force)
@@ -761,7 +760,7 @@ static int rcar_pcie_enable_msi(struct r
 	int err;
 
 	mutex_init(&msi->map_lock);
-	spin_lock_init(&msi->mask_lock);
+	raw_spin_lock_init(&msi->mask_lock);
 
 	err = of_address_to_resource(dev->of_node, 0, &res);
 	if (err)


