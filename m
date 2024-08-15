Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB4A1A256C;
	Thu, 15 Aug 2024 14:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731520; cv=none; b=WG3exCEQclvtx5fLH7KF2ByaxDmlPXU6WeWCqdZMh/AYNbufOECrtOrvpHaTQvhY0w9PdRjgc6oeL3XhRgjDd7BHBaxWtqPLk0PIrQvkFM8bgxXLYtip+3ddpvnsTO/CReYiJ0WbSn5wuuL9sFqbyAUMfeswwN+uoT0ZlWDqQZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731520; c=relaxed/simple;
	bh=aCSDu4uXOe9uDdnPgr7aP5L9lMBGvRGVVyveu+WTijU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVLqL9m3PGIAxCBN6erZe8a9gg2vc0W8q8JlusSN7D0TZRnRDL91dtYOUJQWMZdPGKr/pQ8Gv0ZEgDfuc3xVBxMEurySwJpfDB7pKiMsjf686PY6Buy8fePTNdDK05Srif7pzCrkoRgV6xtvQH2GBSErnKmw2YVB9kHG/h9pkd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhDCb9wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhDCb9wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110D0C32786;
	Thu, 15 Aug 2024 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731520;
	bh=aCSDu4uXOe9uDdnPgr7aP5L9lMBGvRGVVyveu+WTijU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhDCb9wgOiJz4hlH8X7UX8SKb8B+d1qrfcuw4JGfyFTCxyOsRXaXNYY1nXdIwz8b0
	 WBTgstSbmxaAMrJwXhWvxu31ic/8OhrzBM/fS/Z0mW/NF1RE4zikBCYqrDJ6SDQIsE
	 Da59e5IblxSDMWIl0UHYdtH2SeLfug2sIhZQpuUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/259] s390/pci: Refactor arch_setup_msi_irqs()
Date: Thu, 15 Aug 2024 15:24:48 +0200
Message-ID: <20240815131908.772330569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9ed76fa9391cb..b36f5ef34a6c1 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -232,33 +232,20 @@ static void zpci_floating_irq_handler(struct airq_struct *airq, bool floating)
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
 		zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA | AIRQ_IV_BITLOCK);
@@ -266,10 +253,33 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
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



