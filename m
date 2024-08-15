Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E27F1A2564;
	Thu, 15 Aug 2024 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732542; cv=none; b=sfp7UDPFPDH/SWeTnjEe6Qe4Ri+HXvZqNUzEQoenyedt9kKuFJMHItJ+n+cg/lhRfWGIHFrQKOTZYI7CfS62Ur+g3Gmkvz4+yrlI+V5aoxbwopve/53pWD9qymSwQIcksCgWtYYycMKaK6LDKG3czr1N+6rIEvHnumZBuMAmhl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732542; c=relaxed/simple;
	bh=GaM1tb27/KiwRK0V1hqZO6Pej3W0N4NrhDVwzaCLUl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bta1zEZ7DrGE/DRe710uLxfRvRSpfcKNpmFUaak0ahuM5eZZVImOzOdTtS3YGypffAk6G3knMHW/OSecUHxsSmxYFPjC16wpG4IFUpcsp4+krwBcMQ+vNT+TgJPxWEzHkBSNPUaXtWCPUS/DNkgnUzcxEDLTXmIr29vdSfqa+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfFAKbpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfFAKbpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CD9C4AF0D;
	Thu, 15 Aug 2024 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732542;
	bh=GaM1tb27/KiwRK0V1hqZO6Pej3W0N4NrhDVwzaCLUl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfFAKbppJlChVFMc1xKSPfQuj+sJ8qGOVjS8pDtlrEeQLdrSJBXm2Tp10811ARgDw
	 Hua5eQt6TL8+npQdPkI87GBWf1FOSa+51FYo1viPukVVu/u14hRTiessT7EjdYD8Rh
	 SKhAucf+QOG0FvgIScMjIpg3U+pEZMYWstJavNYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/352] s390/pci: Rework MSI descriptor walk
Date: Thu, 15 Aug 2024 15:24:36 +0200
Message-ID: <20240815131927.403698704@linuxfoundation.org>
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
index 5036e00b7ec1b..9ed76fa9391cb 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -273,7 +273,7 @@ int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 
 	/* Request MSI interrupts */
 	hwirq = bit;
-	for_each_pci_msi_entry(msi, pdev) {
+	msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
 		rc = -EIO;
 		if (hwirq - bit >= msi_vecs)
 			break;
@@ -338,9 +338,7 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
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



