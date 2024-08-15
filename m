Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419E41714A1;
	Thu, 15 Aug 2024 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730065; cv=none; b=lWMECJuoXeXcWdUyK74QJYFHQFppmzggH9bTxulda2uiz4SulK2yqaC5wVgKTOVY9LCRSAI+FGlK9SOLQyBy5qhJelkGUHUQ3M05yVjhXioEqxiXG7OX590HCnRWCgwYvgnXxd1Z2t+WyFjSJaqaIA8Hgg+MLZKEmTIsL1O3HYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730065; c=relaxed/simple;
	bh=bBNjhGbjL/DlKZ7YL8Cb59PCKDLw6ed5QYdkdmBLOz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrsistbddFgWbiOPHTJgL+v8s1tD6eBnOXGf+jfuH91ytLQo0JuzeEmV6st72pCTSk6JKcOVzZKviu6TL7kb3Lober7wOwGIJMUW7+wXofghNh1GZnzO2CJ+f5SHuy5qJLULQ7qD/RtJUXz0bHxaAoxIx5XF6tq5P9zCi/mLklA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAjTprjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAjTprjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEDBC32786;
	Thu, 15 Aug 2024 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730065;
	bh=bBNjhGbjL/DlKZ7YL8Cb59PCKDLw6ed5QYdkdmBLOz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAjTprjBWKYyQeVI3qVctYqih3EHchdzuh7nhwfNfLNg9tcUa26e/1gyn7ha4Mghe
	 0VdA1HoL6MZJFCS8gjgysVKOGtf8hLiIdTg2pnf3xi/Ccr7XGIWvHH2IM8vWOGEMDu
	 kUkdP2VzpnTJpr6OZY7NSN36fepsL5xOAqWAvEhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/484] s390/pci: Allow allocation of more than 1 MSI interrupt
Date: Thu, 15 Aug 2024 15:22:30 +0200
Message-ID: <20240815131952.686216001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 39c3c29f0d1d3..4a1dfce1a5cd2 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -292,8 +292,8 @@ static int __alloc_airq(struct zpci_dev *zdev, int msi_vecs,
 
 int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
+	unsigned int hwirq, msi_vecs, irqs_per_msi, i, cpu;
 	struct zpci_dev *zdev = to_zpci(pdev);
-	unsigned int hwirq, msi_vecs, cpu;
 	struct msi_desc *msi;
 	struct msi_msg msg;
 	unsigned long bit;
@@ -303,30 +303,46 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
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
@@ -339,31 +355,35 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
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
 
 	rc = zpci_set_irq(zdev);
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
@@ -373,8 +393,10 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 
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



