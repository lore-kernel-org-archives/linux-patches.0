Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DA71A6192;
	Tue, 30 Jul 2024 17:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358928; cv=none; b=inz0s2B1MhUe2hL9K9j8GytSFJd4xWtGO7qVYArfY3s49Qhw2S78ojL3R8wL4j2m03mbmgjrmWkh3k45dQQhOMT/x7x4uPh2fdGcNFyAsqvjf5ntS0Va8SNjGuyQSqqsYFRScOoEfaDFKRo75DuI1P6O7GuA1zc76T6EQaxHBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358928; c=relaxed/simple;
	bh=95pEBND/DwZnF3G+cncTCIEiBjmM3OOrgtHnA4UNFQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm10F4G3PLq5UwboCeLBGJUUoztqP/xzCe+6GWgkmJYgy03+6tuaHwYWGcaFqHUtvJ7crST3m9Y/t1nf0Gbe8VwDPnCRmfFd5qW1zIKt3DcBN+0Sny5lXlwTVozVKUisbicbTzbzzYDcs/sV1w66PcaCySdzy0y8DjIhgEKHD8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiH2hhLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiH2hhLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F9DC32782;
	Tue, 30 Jul 2024 17:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358928;
	bh=95pEBND/DwZnF3G+cncTCIEiBjmM3OOrgtHnA4UNFQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiH2hhLFMPP0zeKaTftqHYnZXwWbeaQomf0pZrXfpwrmGj4ihfkV3PaIw2bd6Ba5j
	 /mpcPb3ffN07EdbxYOXdrWche+XmEKcyi26WCqK6dFKGdqf5q959RpiaAka/PVtWGi
	 HkysnyL7S5w9xIH14cC0TXBuHzbU0VKlfagwMh6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/440] s390/pci: Refactor arch_setup_msi_irqs()
Date: Tue, 30 Jul 2024 17:51:07 +0200
Message-ID: <20240730151632.727018796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 04c19ab93a329..e5322432276b1 100644
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



