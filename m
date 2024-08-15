Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8118D630;
	Thu, 15 Aug 2024 13:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730058; cv=none; b=bDwMaNFgGDXFuk7/SI7EGU7xgfzkU4uYo16W7gmX0h/kgzHT8DOs8vr+XbStjUsZ1V9NJUkseLTLGtdJhWZglGk23UAWoWBmvj4oF8Xt76weHDPSYuQJ4MYbGVm0wpCXd7mDGqaeBn6FXNX9ekYwUEzF1EI1nOgqG8KRJMuUS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730058; c=relaxed/simple;
	bh=m1hcY5W15qAb0pSnBYPsAN+iRVyMgaXPW7pSBo8wv88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIVo/7FFzHYqiMpcaujMRDGROi3dyVxk+TNfhJa56vDFhFdjoDEHTDFsDO4nOG861T2mPLTfjv+IGC1aC4UTrr7GzCTSdkLC37i2fZNwxOdgsEmhWqMKo+7deJuWz2oZBruYWWMLczEeAi1oM+VhrqXZ4ZxsGBa2ZSLFGQ2hYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pawy8AXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pawy8AXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93491C32786;
	Thu, 15 Aug 2024 13:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730058;
	bh=m1hcY5W15qAb0pSnBYPsAN+iRVyMgaXPW7pSBo8wv88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pawy8AXOCW4dnoHLqAVLGVOhj1pKDvOB9gR7V41e3i/BSTIueOohrNCJ+/a1QefAE
	 NN+4BnxlDcZnPbYGiDRYX3ynlqUNubvFfo/bN5K2sXweM3RHVodlpHM/8Pgiemid47
	 Ibf6TSs/YdIzwnHiTB+ZNpNPnIWC4QfIGpKsSnFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 290/484] s390/pci: Rework MSI descriptor walk
Date: Thu, 15 Aug 2024 15:22:28 +0200
Message-ID: <20240815131952.608760476@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2ca5e908d0f4cde61d9d3595e8314adca5d914a1 ]

Replace the about to vanish iterators and make use of the filtering.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Link: https://lore.kernel.org/r/20211206210748.305656158@linutronix.de
Stable-dep-of: ab42fcb511fd ("s390/pci: Allow allocation of more than 1 MSI interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 3823e159bf749..49e404c3e987a 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -303,7 +303,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 
 	/* Request MSI interrupts */
 	hwirq = bit;
-	for_each_pci_msi_entry(msi, pdev) {
+	msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
 		rc = -EIO;
 		if (hwirq - bit >= msi_vecs)
 			break;
@@ -362,9 +362,7 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 		return;
 
 	/* Release MSI interrupts */
-	for_each_pci_msi_entry(msi, pdev) {
-		if (!msi->irq)
-			continue;
+	msi_for_each_desc(msi, &pdev->dev, MSI_DESC_ASSOCIATED) {
 		irq_set_msi_desc(msi->irq, NULL);
 		irq_free_desc(msi->irq);
 		msi->msg.address_lo = 0;
-- 
2.43.0



