Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF911A00E7;
	Thu, 15 Aug 2024 14:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732549; cv=none; b=fWmv6jsishvcacbrKSdQbWO5VsKqDedZPfA6R0U/J2Ea4qveTsioq138NOcJqK3jw1bEVZhDZesrCMatazVkPN43IrnBz6vTLMlAHDaAAbkMoqv00jRwH9vRMxmKfJJC1z4wnG0EU/KHjfgYWg2Jio2E1h9J4B1EOOwT0ZZFFDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732549; c=relaxed/simple;
	bh=BS3CNXMfO70eQyZBqIZpkpb2fVWWU8hpig3GaalZsm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGJrymcuiHjpH/JSEyU8FJ7LH1TL0wyuODlLiawirunQUXh/HXkNNqpz3I/Z8rP3CtdIckpH7wPm93mUbibTrcErwpas0hBkEWWj7mCDt3+oDdBo7ZfeTahVSHp7rCiqV0MDezI47q+DBY/HGvFYbL8Vy6X6nfr2igwp/6bCKsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs7ag6GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs7ag6GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4EFC32786;
	Thu, 15 Aug 2024 14:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732548;
	bh=BS3CNXMfO70eQyZBqIZpkpb2fVWWU8hpig3GaalZsm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs7ag6GScMpeuqkXfYPaKQXjMk0gbrF1E8KtiIW1HAjWN5S82YI0ZIIMSjf6NNnu4
	 QweVFN3NksHRbXmf9G9fg3rfZjHB24ggUPpwsXgLyTYc0Yl2XMkHdX+iF3adbdRjns
	 J2Tn5npf0G42Lbez8/1nzYk+ne/Y8iRLhbdFHEUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/352] s390/pci: Allow allocation of more than 1 MSI interrupt
Date: Thu, 15 Aug 2024 15:24:38 +0200
Message-ID: <20240815131927.483343739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit ab42fcb511fd9d241bbab7cc3ca04e34e9fc0666 ]

On a PCI adapter that provides up to 8 MSI interrupt sources the s390
implementation of PCI interrupts rejected to accommodate them, although
the underlying hardware is able to support that.

For MSI-X it is sufficient to allocate a single irq_desc per msi_desc,
but for MSI multiple irq descriptors are attached to and controlled by
a single msi descriptor. Add the appropriate loops to maintain multiple
irq descriptors and tie/untie them to/from the appropriate AIBV bit, if
a device driver allocates more than 1 MSI interrupt.

Common PCI code passes on requests to allocate a number of interrupt
vectors based on the device drivers' demand and the PCI functions'
capabilities. However, the root-complex of s390 systems support just a
limited number of interrupt vectors per PCI function.
Produce a kernel log message to inform about any architecture-specific
capping that might be done.

With this change, we had a PCI adapter successfully raising
interrupts to its device driver via all 8 sources.

Fixes: a384c8924a8b ("s390/PCI: Fix single MSI only check")
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 62 ++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index b36f5ef34a6c1..690f6999287bc 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -262,8 +262,8 @@ static int __alloc_airq(struct zpci_dev *zdev, int msi_vecs,
 
 int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
+	unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
 	struct zpci_dev *zdev = to_zpci(pdev);
-	unsigned int hwirq, msi_vecs, cpu;
 	struct msi_desc *msi;
 	struct msi_msg msg;
 	unsigned long bit;
@@ -273,30 +273,46 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	zdev->aisb = -1UL;
 	zdev->msi_first_bit = -1U;
 
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
 	msi_vecs = min_t(unsigned int, nvec, zdev->max_msi);
+	if (msi_vecs < nvec) {
+		pr_info("%s requested %d irqs, allocate system limit of %d",
+			pci_name(pdev), nvec, zdev->max_msi);
+	}
 
 	rc = __alloc_airq(zdev, msi_vecs, &bit);
 	if (rc < 0)
 		return rc;
 
-	/* Request MSI interrupts */
+	/*
+	 * Request MSI interrupts:
+	 * When using MSI, nvec_used interrupt sources and their irq
+	 * descriptors are controlled through one msi descriptor.
+	 * Thus the outer loop over msi descriptors shall run only once,
+	 * while two inner loops iterate over the interrupt vectors.
+	 * When using MSI-X, each interrupt vector/irq descriptor
+	 * is bound to exactly one msi descriptor (nvec_used is one).
+	 * So the inner loops are executed once, while the outer iterates
+	 * over the MSI-X descriptors.
+	 */
 	hwirq = bit;
 	msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
-		rc = -EIO;
 		if (hwirq - bit >= msi_vecs)
 			break;
-		irq = __irq_alloc_descs(-1, 0, 1, 0, THIS_MODULE,
-				(irq_delivery == DIRECTED) ?
-				msi->affinity : NULL);
+		irqs_per_msi = min_t(unsigned int, msi_vecs, msi->nvec_used);
+		irq = __irq_alloc_descs(-1, 0, irqs_per_msi, 0, THIS_MODULE,
+					(irq_delivery == DIRECTED) ?
+					msi->affinity : NULL);
 		if (irq < 0)
 			return -ENOMEM;
-		rc = irq_set_msi_desc(irq, msi);
-		if (rc)
-			return rc;
-		irq_set_chip_and_handler(irq, &zpci_irq_chip,
-					 handle_percpu_irq);
+
+		for (i = 0; i < irqs_per_msi; i++) {
+			rc = irq_set_msi_desc_off(irq, i, msi);
+			if (rc)
+				return rc;
+			irq_set_chip_and_handler(irq + i, &zpci_irq_chip,
+						 handle_percpu_irq);
+		}
+
 		msg.data = hwirq - bit;
 		if (irq_delivery == DIRECTED) {
 			if (msi->affinity)
@@ -309,19 +325,22 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			msg.address_lo |= (cpu_addr << 8);
 
 			for_each_possible_cpu(cpu) {
-				airq_iv_set_data(zpci_ibv[cpu], hwirq, irq);
+				for (i = 0; i < irqs_per_msi; i++)
+					airq_iv_set_data(zpci_ibv[cpu],
+							 hwirq + i, irq + i);
 			}
 		} else {
 			msg.address_lo = zdev->msi_addr & 0xffffffff;
-			airq_iv_set_data(zdev->aibv, hwirq, irq);
+			for (i = 0; i < irqs_per_msi; i++)
+				airq_iv_set_data(zdev->aibv, hwirq + i, irq + i);
 		}
 		msg.address_hi = zdev->msi_addr >> 32;
 		pci_write_msi_msg(irq, &msg);
-		hwirq++;
+		hwirq += irqs_per_msi;
 	}
 
 	zdev->msi_first_bit = bit;
-	zdev->msi_nr_irqs = msi_vecs;
+	zdev->msi_nr_irqs = hwirq - bit;
 
 	if (irq_delivery == DIRECTED)
 		rc = zpci_set_directed_irq(zdev);
@@ -330,13 +349,14 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	if (rc)
 		return rc;
 
-	return (msi_vecs == nvec) ? 0 : msi_vecs;
+	return (zdev->msi_nr_irqs == nvec) ? 0 : zdev->msi_nr_irqs;
 }
 
 void arch_teardown_msi_irqs(struct pci_dev *pdev)
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 	struct msi_desc *msi;
+	unsigned int i;
 	int rc;
 
 	/* Disable interrupts */
@@ -349,8 +369,10 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 
 	/* Release MSI interrupts */
 	msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
-		irq_set_msi_desc(msi->irq, NULL);
-		irq_free_desc(msi->irq);
+		for (i = 0; i < msi->nvec_used; i++) {
+			irq_set_msi_desc(msi->irq + i, NULL);
+			irq_free_desc(msi->irq + i);
+		}
 		msi->msg.address_lo = 0;
 		msi->msg.address_hi = 0;
 		msi->msg.data = 0;
-- 
2.43.0



