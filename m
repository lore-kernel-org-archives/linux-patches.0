Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6811A76A4;
	Tue, 30 Jul 2024 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359968; cv=none; b=GHRS8aqYkbeAyJr9VINTnrixmKYQvkhCNIbff/b/QnLCAPZVTxsn/Kai4/jgy1LNwtR6ojRVkHStQzzMSmH/ImHPcpA/xDi6EpsZOXL+CGCYVqIf28H+tYpYLP9BkCV3pnyTFSqu7zX/rrK0rwi5wI458shE7x+Hbfw3+f/27Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359968; c=relaxed/simple;
	bh=tKnQAozkZLsBawZ8aZZ6X/YgcWVZRxKHrmaDIUmbUNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ime/SwO4O5U8AtNMxIRay4YDk+k2h1nhPhlttYxJlW3y/jVHLQ1fn7OqI9I+ISyR6DdHe0o6FnNoZj3RLlCcpVobLzqy+CYVqVr/C5qS1VehEXfasijqM04aRIF5LxoYUnLTdwa4xlht0M5F3r4wCROwD+kO6xm5P1FXkUVw8DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15id0w+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15id0w+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76755C4AF0C;
	Tue, 30 Jul 2024 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359967;
	bh=tKnQAozkZLsBawZ8aZZ6X/YgcWVZRxKHrmaDIUmbUNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15id0w+MtSfXGUbkQGhQvlbadkA/CQMDFcqgjDA7LmqorOr178eCX2jIN36aCyGdJ
	 iXeFhscQwTdX5VGyXbWCgCmN/Fw39p/ZXU59q1kuKhzn/IFoa28/CR1/FMNhYtO2NR
	 ucMS9wPau0jfxdrhajEI/GAkimWGsREulH5Z0PVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 562/568] s390/pci: Refactor arch_setup_msi_irqs()
Date: Tue, 30 Jul 2024 17:51:09 +0200
Message-ID: <20240730151702.123700123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



