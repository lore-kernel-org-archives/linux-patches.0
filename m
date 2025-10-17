Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C96C330B1D;
	Fri, 17 Oct 2025 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715640; cv=none; b=VKKXjCrcFeLgjvL1C0UQ0cVHYFKWLJ0n+eLiCupUAARol10RsD8Qgph0a6HD0zvbK51gqQtxn1vs8mIID6cuP1P2zmoVGqWpBWebvYZff7Tqwrrr2+HTm3LCK8dpd2ZKyZiyuEQBgwZCJWHhEsST8iKrx7rAAlQ/p9lrn6vr4NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715640; c=relaxed/simple;
	bh=/3BriervIbLgKhUleLvdeClfYH8CJqcAa1a6G0kL8+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhzSd2V8HhglCQQ/hGV5tGMFaNkG28uKNQ33U3gY0Zxpi6IXv1C17imGCbHEdBFkan2Oei7SMG6UEQsf4BcCoOo6K2SerE03zECUh+XMIiYjwrjRqrlUS1WTGohDwmLIS2ROiukIhyvZY5n7pHTvu3zPg2xg2993QME1pmFHTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkhVp57Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkhVp57Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027D6C4CEE7;
	Fri, 17 Oct 2025 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715640;
	bh=/3BriervIbLgKhUleLvdeClfYH8CJqcAa1a6G0kL8+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nkhVp57ZClJkKUuRUKXGM182XCtwJ7PjvysMSrc2M1R/zwEF5b/zBIkaaTQ0awQ3C
	 yekQHE77EDexMY+mOQNacbJBzVldMX72zOdMulukjV8uOZVW6jbpPQvdw31LOUlnBj
	 c4X1bwEn8+XxFDDgfnQydhpfOhjZKP3i+u8xIO8I=
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
Subject: [PATCH 6.17 287/371] PCI: rcar-host: Convert struct rcar_msi mask_lock into raw spinlock
Date: Fri, 17 Oct 2025 16:54:22 +0200
Message-ID: <20251017145212.457561614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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
@@ -38,7 +39,7 @@ struct rcar_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	struct mutex map_lock;
-	spinlock_t mask_lock;
+	raw_spinlock_t mask_lock;
 	int irq1;
 	int irq2;
 };
@@ -602,28 +603,26 @@ static void rcar_msi_irq_mask(struct irq
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
 
 static void rcar_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
@@ -736,7 +735,7 @@ static int rcar_pcie_enable_msi(struct r
 	int err;
 
 	mutex_init(&msi->map_lock);
-	spin_lock_init(&msi->mask_lock);
+	raw_spin_lock_init(&msi->mask_lock);
 
 	err = of_address_to_resource(dev->of_node, 0, &res);
 	if (err)


