Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE672D0C75;
	Sat, 12 Sep 2026 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213163; cv=none; b=Cne4MHDIZBPRAZsfDWKim40fjaEyaGSgCggyz/m+W68OWvMABMukXOeYrg9Pf8r3XKIKCleWpTIUlwVNgBC1S/7JmEaOX2I5nxOa6kQwMh4DjFbV6diZSFiYzU2oNFSg4KdwMtY6PknU3jfGTydDeumHJc0XQtzioz0NbQqYJ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213163; c=relaxed/simple;
	bh=Y03i3jEMuKrvaPMYCr2nMRfoJ7sk73IGEPmdld/ZW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JG64WK27viLtfKSt9hQ+rszHikXr3w+uhcgZEDFmhMIEsNSraL7kyp7Y++2pMG8EBG8Bzio1box646NhEwunHacm3l8Iqp6GSfk87mU0kmcnQMFN2Py8uIyUt0SBK0O6yP7ZE6GY+3oOWagJt4mszNQDpcN1L+vr/bemy1eMLJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iy1wXiDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iy1wXiDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055C91F000FF;
	Sat, 12 Sep 2026 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213162;
	bh=fN3K2IAH0UU9+hObTNxwbhC46QtOu0zklX7eLkeOKls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iy1wXiDhj5eKTdxRKB7+NjoiJyAxgStlLyobB5NTdkSkOL+EBFfCXpR66uRb7mQ6u
	 ccX28+X32itexdIGyJbLdXl9QwquyM+bwqcMez1CtdTT914xkUcXJV+BBlzsq4DhJB
	 WBYJa60kfsyxGBYsk/WlDNN7JXWj1Eb9a1XYfQUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hajo Noerenberg <hajo-linux-ide@noerenberg.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Pali Rohar <pali@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 0065/1376] ata: ahci: work around lost interrupts on Marvell 88SE61xx
Date: Sat, 12 Sep 2026 08:41:31 +0200
Message-ID: <20260912065609.009759146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Hajo Noerenberg <hajo-linux-ide@noerenberg.de>

commit dc3565a4ae538e584e5e63b3b3cd1eaf502593c1 upstream.

ahci_single_level_irq_intr() services the ports first and clears the
global HOST_IRQ_STAT afterwards, as recommended by AHCI 1.1 section
10.6.2.  The Marvell 88SE6111/6121/6145 family stops reporting interrupts
for a port when HOST_IRQ_STAT is cleared while PxIS still holds bits:
PxIS keeps its content, HOST_IRQ_STAT reads back as 0, the port is never
looked at again, and the command in flight only ends in a timeout.

Measured on a Seagate Blackarmor NAS440 (Marvell 88F6281 Kirkwood,
88SE6121 rev B2 behind PCIe) by polling the AHCI registers from userspace
while an IDENTIFY was outstanding:

  t=303.046  irqs 127  PxIS 0x00000000  PxCI 0x00000001
             IDENTIFY issued
  t=303.057  irqs 128  PxIS 0x00000020  PxCI 0x00000000
             CI cleared, DPS set, one interrupt taken
             ... PxIS stays 0x00000020, HOST_IRQ_STAT stays 0 ...
  t~308.05   qc timeout after 5000 msecs

The command had completed - PxCI was clear and PxIS had DPS set - so
ahci_qc_complete() would have completed it.  It never got the chance
because the handler read HOST_IRQ_STAT as 0 and returned IRQ_NONE.

Marvell's own driver for these chips clears the two registers in the
opposite order and says so ("clear global before channel"), and
ahci_xgene handles its broken edge latch the same way.  Since the
reordering costs at most one spurious interrupt per valid one on
conforming controllers, do it in a private interrupt handler selected for
board_ahci_mv instead of changing libahci for everyone.

With this applied, SATA-2 and SATA-3 disks work at 3.0 Gbps on the
88SE6121 without the drive-side 1.5 Gbps jumper that was needed before.
Time from link up to a successful IDENTIFY:

  WDC WD5000AADS-00S9B0  port 0    7 ms  (never identified before)
  WDC WD3202ABYS-01B7A0  port 1   28 ms
  WDC WD30EFRX-68EUZN0   port 1  200 ms  (3 TB, HPA detection ok)

Only the 88SE6121 was tested; board_ahci_mv also covers the 88SE6145,
which Marvell's driver treats identically.

Fixes: cd70c26617f4 ("[libata] AHCI: Add support for Marvell AHCI-like chips (initially 6145)")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-ide/db6b48b7-d69a-564b-24f0-75fbd6a9e543@noerenberg.de/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216094
Signed-off-by: Hajo Noerenberg <hajo-linux-ide@noerenberg.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Pali Rohar <pali@kernel.org>
Link: https://lore.kernel.org/r/20260831124303.920391-1-hajo-linux-ide@noerenberg.de
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1676,6 +1676,51 @@ static irqreturn_t ahci_thunderx_irq_han
 }
 #endif
 
+/*
+ * The Marvell 88SE6111/6121/6145 ("Thor") family stops reporting interrupts
+ * for a port when HOST_IRQ_STAT is cleared while PxIS still holds bits: PxIS
+ * keeps its content, HOST_IRQ_STAT reads back as 0, the port is never looked
+ * at again and the command in flight only ends in a timeout.  On a 88SE6121
+ * this makes every SATA-2 or SATA-3 disk fail to IDENTIFY, while SATA-1 disks
+ * happen to win the race often enough to work.
+ *
+ * Clearing the host status before servicing the ports avoids it.  Marvell's
+ * own driver for these chips does the same and says so ("clear global before
+ * channel"), and ahci_xgene handles its broken edge latch the same way.  The
+ * price is at most one spurious interrupt per valid one, which is why this is
+ * not the generic behaviour - see AHCI 1.1 section 10.6.2.
+ *
+ * Link: https://bugzilla.kernel.org/show_bug.cgi?id=216094
+ */
+static irqreturn_t ahci_mv_irq_handler(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	unsigned int rc;
+	u32 irq_stat, irq_masked;
+
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	spin_lock(&host->lock);
+
+	/*
+	 * Use the unmasked value to clear the interrupt, as a spurious pending
+	 * event on a dummy port might cause a screaming IRQ.
+	 */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	rc = ahci_handle_port_intr(host, irq_masked);
+
+	spin_unlock(&host->lock);
+
+	return IRQ_RETVAL(rc);
+}
+
 static void ahci_remap_check(struct pci_dev *pdev, int bar,
 		struct ahci_host_priv *hpriv)
 {
@@ -1948,6 +1993,10 @@ static int ahci_init_one(struct pci_dev
 		return -ENOMEM;
 	hpriv->flags |= (unsigned long)pi.private_data;
 
+	/* the Marvell "Thor" family needs HOST_IRQ_STAT cleared first */
+	if (board_id == board_ahci_mv)
+		hpriv->irq_handler = ahci_mv_irq_handler;
+
 	/* MCP65 revision A1 and A2 can't do MSI */
 	if (board_id == board_ahci_mcp65 &&
 	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))


