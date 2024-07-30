Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21485166315;
	Tue, 30 Jul 2024 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360798; cv=none; b=kwCJizWWgcAxAanMU7xBoohb0ldirD52Yg7VvcNtIDstQwfNTX6aXDFRffc++4VVtO/lNskM+WmZWuE2FAOz0k15PtAzGGivSfd134KdGdd9ZuCKRV/r06N5LU9wwYCyxJBzHNq/t4drjYWT1n5c9kINZG/hXOxfcVxiySdO3/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360798; c=relaxed/simple;
	bh=NkiTyx4aXI1lodrmLOeFOyyrZRJ6YJGk9urdnJIVdpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeGyqjtmj+19V9RmEXemd8YLmoZp/Uze1OIWwN7BNgtKUK+Oc4Z2lV57onuW9dAnXA02lLPJFI3rPBmVEpr6eMgAbcqrfDTvXtHTJX+W5oKswlRFgjTvndX4nscRnFm/mzDH+aiZ+r1k3c358o/tdl2Mv5wjYMTyINmoZnQ4MrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySUhSXWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySUhSXWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCBDC32782;
	Tue, 30 Jul 2024 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360797;
	bh=NkiTyx4aXI1lodrmLOeFOyyrZRJ6YJGk9urdnJIVdpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySUhSXWT5jTGuEtgQPzF6yfRfc/+Lf7yFBKPvqsk3VczZcuqi14GAtBCfv+SB4yQN
	 Em95Z1IaaggKGSj8Lz2LzYEbblyqtP/fu3phGXdvUmw+Io+bP5DD4wdU9eLOFncxRM
	 DeeGAcAyIrC/wAuG2tkt47Jl8PSzIsefF8yhMTZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 795/809] s390/pci: Refactor arch_setup_msi_irqs()
Date: Tue, 30 Jul 2024 17:51:11 +0200
Message-ID: <20240730151756.373564622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 5fd11b96b43708f2f6e3964412c301c1bd20ec0f ]

Factor out adapter interrupt allocation from arch_setup_msi_irqs() in
preparation for enabling registration of multiple MSIs. Code movement
only, no change of functionality intended.

Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: ab42fcb511fd ("s390/pci: Allow allocation of more than 1 MSI interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 54 ++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 0ef83b6ac0db7..979f776b09b8d 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -268,33 +268,20 @@ static void zpci_floating_irq_handler(struct airq_struct *airq,
 	}
 }
 
-int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+static int __alloc_airq(struct zpci_dev *zdev, int msi_vecs,
+			unsigned long *bit)
 {
-	struct zpci_dev *zdev = to_zpci(pdev);
-	unsigned int hwirq, msi_vecs, cpu;
-	unsigned long bit;
-	struct msi_desc *msi;
-	struct msi_msg msg;
-	int cpu_addr;
-	int rc, irq;
-
-	zdev->aisb = -1UL;
-	zdev->msi_first_bit = -1U;
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
-	msi_vecs = min_t(unsigned int, nvec, zdev->max_msi);
-
 	if (irq_delivery == DIRECTED) {
 		/* Allocate cpu vector bits */
-		bit = airq_iv_alloc(zpci_ibv[0], msi_vecs);
-		if (bit == -1UL)
+		*bit = airq_iv_alloc(zpci_ibv[0], msi_vecs);
+		if (*bit == -1UL)
 			return -EIO;
 	} else {
 		/* Allocate adapter summary indicator bit */
-		bit = airq_iv_alloc_bit(zpci_sbv);
-		if (bit == -1UL)
+		*bit = airq_iv_alloc_bit(zpci_sbv);
+		if (*bit == -1UL)
 			return -EIO;
-		zdev->aisb = bit;
+		zdev->aisb = *bit;
 
 		/* Create adapter interrupt vector */
 		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK, NULL);
@@ -302,10 +289,33 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			return -ENOMEM;
 
 		/* Wire up shortcut pointer */
-		zpci_ibv[bit] = zdev->aibv;
+		zpci_ibv[*bit] = zdev->aibv;
 		/* Each function has its own interrupt vector */
-		bit = 0;
+		*bit = 0;
 	}
+	return 0;
+}
+
+int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
+{
+	struct zpci_dev *zdev = to_zpci(pdev);
+	unsigned int hwirq, msi_vecs, cpu;
+	struct msi_desc *msi;
+	struct msi_msg msg;
+	unsigned long bit;
+	int cpu_addr;
+	int rc, irq;
+
+	zdev->aisb = -1UL;
+	zdev->msi_first_bit = -1U;
+
+	if (type == PCI_CAP_ID_MSI && nvec > 1)
+		return 1;
+	msi_vecs = min_t(unsigned int, nvec, zdev->max_msi);
+
+	rc = __alloc_airq(zdev, msi_vecs, &bit);
+	if (rc < 0)
+		return rc;
 
 	/* Request MSI interrupts */
 	hwirq = bit;
-- 
2.43.0



