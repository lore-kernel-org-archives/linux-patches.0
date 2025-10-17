Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6332C937;
	Fri, 17 Oct 2025 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713800; cv=none; b=MQZ+OqhbfPOMvtKRYE9F6TW96u92OFsweoeGwYyBPwoUxr8FcgNhcvOAsrInRUsAo9DGyJe6OilEqHT0xvc6fsEN45sMmo3BAt4WUdoMKEqIgVykvlhsbdNku9wxUnQXxu5aXoCzi4xrzm2HSeQ7jrAfosCVv3FF2r/owMdvDpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713800; c=relaxed/simple;
	bh=dWH0NZNJmQJ7Aq5HQ2drt7jVg+OJWzXB+sSFdpIMaSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg5sC47uSdsp7g0EIOQ0+m/FJkCoDuV1qWt8alECHTc+KtjFxHwkzr7wo9Zly7LkyCwWeW/PIIWHakDOzWSV6tFhGKI1B09dV2a2O87ZdzDB+dByhlRJoFPP/UCvA7I99ZsgBWRDaLnJPIs4Ky31bDuAaotcamuBRQpemgfzJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6Iehm/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6Iehm/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21378C4CEE7;
	Fri, 17 Oct 2025 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713800;
	bh=dWH0NZNJmQJ7Aq5HQ2drt7jVg+OJWzXB+sSFdpIMaSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6Iehm/Ir4w0JdFWxem+lo2LcKO99csrlQHVXMqBAcJEGNPf6l5MBZx9xkS6jMJ0A
	 h7a1D0m+uhIax2+knvSEGknUHpDJ2Qa70Qw5ixGg4RqFXHt4kPJ2T8EQFi2tD8LBDZ
	 ciFa37ObC/VZA/Rgt5wuYy0wR+uaqqoSzt9Pfbao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 125/201] PCI: tegra: Convert struct tegra_msi mask_lock into raw spinlock
Date: Fri, 17 Oct 2025 16:53:06 +0200
Message-ID: <20251017145139.333268096@linuxfoundation.org>
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

commit 26fda92d3b56bf44a02bcb4001c5a5548e0ae8ee upstream.

The tegra_msi_irq_unmask() function may be called from a PCI driver
request_threaded_irq() function. This triggers kernel/irq/manage.c
__setup_irq() which locks raw spinlock &desc->lock descriptor lock
and with that descriptor lock held, calls tegra_msi_irq_unmask().

Since the &desc->lock descriptor lock is a raw spinlock, and the tegra_msi
.mask_lock is not a raw spinlock, this setup triggers 'BUG: Invalid wait
context' with CONFIG_PROVE_RAW_LOCK_NESTING=y.

Use scoped_guard() to simplify the locking.

Fixes: 2c99e55f7955 ("PCI: tegra: Convert to MSI domains")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://patchwork.kernel.org/project/linux-pci/patch/20250909162707.13927-2-marek.vasut+renesas@mailbox.org/#26574451
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250922150811.88450-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-tegra.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/pci/controller/pci-tegra.c
+++ b/drivers/pci/controller/pci-tegra.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/export.h>
@@ -269,7 +270,7 @@ struct tegra_msi {
 	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
 	struct irq_domain *domain;
 	struct mutex map_lock;
-	spinlock_t mask_lock;
+	raw_spinlock_t mask_lock;
 	void *virt;
 	dma_addr_t phys;
 	int irq;
@@ -1604,14 +1605,13 @@ static void tegra_msi_irq_mask(struct ir
 	struct tegra_msi *msi = irq_data_get_irq_chip_data(d);
 	struct tegra_pcie *pcie = msi_to_pcie(msi);
 	unsigned int index = d->hwirq / 32;
-	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
-	value = afi_readl(pcie, AFI_MSI_EN_VEC(index));
-	value &= ~BIT(d->hwirq % 32);
-	afi_writel(pcie, value, AFI_MSI_EN_VEC(index));
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &msi->mask_lock) {
+		value = afi_readl(pcie, AFI_MSI_EN_VEC(index));
+		value &= ~BIT(d->hwirq % 32);
+		afi_writel(pcie, value, AFI_MSI_EN_VEC(index));
+	}
 }
 
 static void tegra_msi_irq_unmask(struct irq_data *d)
@@ -1619,14 +1619,13 @@ static void tegra_msi_irq_unmask(struct
 	struct tegra_msi *msi = irq_data_get_irq_chip_data(d);
 	struct tegra_pcie *pcie = msi_to_pcie(msi);
 	unsigned int index = d->hwirq / 32;
-	unsigned long flags;
 	u32 value;
 
-	spin_lock_irqsave(&msi->mask_lock, flags);
-	value = afi_readl(pcie, AFI_MSI_EN_VEC(index));
-	value |= BIT(d->hwirq % 32);
-	afi_writel(pcie, value, AFI_MSI_EN_VEC(index));
-	spin_unlock_irqrestore(&msi->mask_lock, flags);
+	scoped_guard(raw_spinlock_irqsave, &msi->mask_lock) {
+		value = afi_readl(pcie, AFI_MSI_EN_VEC(index));
+		value |= BIT(d->hwirq % 32);
+		afi_writel(pcie, value, AFI_MSI_EN_VEC(index));
+	}
 }
 
 static int tegra_msi_set_affinity(struct irq_data *d, const struct cpumask *mask, bool force)
@@ -1742,7 +1741,7 @@ static int tegra_pcie_msi_setup(struct t
 	int err;
 
 	mutex_init(&msi->map_lock);
-	spin_lock_init(&msi->mask_lock);
+	raw_spin_lock_init(&msi->mask_lock);
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		err = tegra_allocate_domains(msi);


