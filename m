Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435EA63D5;
	Thu, 15 Aug 2024 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732536; cv=none; b=pmSTmfwKT7czAYmqYksKq2fYoPNWqKE/pGPKszxAfWG0vVWQosGR7ozqy6X2emBIVpdD6fmCYyfCvzDFs2qSTnzjdiWIMQ8ok10FvLD5fkq29sdNunWu+WQdfsV/RS6yv1MpBYnoqNZ/Aqe/RWrzGfRbDGFSnYMr0R/wgFQgXB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732536; c=relaxed/simple;
	bh=KkziAjtAY9g54Qm7Hwf1cjJvHnOIbcAa5ycjwrUDtLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIO3X2kmhLzwS7y9ee7T70CRfRCadw3ZuJhrL8i1y2XeWFJ7WYBt1JW736tVFHSwY7Mg/FBpoxatF8ksr0bMYBFHndMYVrNmzg5URRE+tdf3jhDOgmX7EgDzRjaysSIq7Mvc8koQk/c7knfZ4PhgTnRyVbMSudpw8+qku5qK06k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEHpo2nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEHpo2nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A44C32786;
	Thu, 15 Aug 2024 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732536;
	bh=KkziAjtAY9g54Qm7Hwf1cjJvHnOIbcAa5ycjwrUDtLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEHpo2nw6w85f9r0DANJChMKfNoxCJOCd6wOlR8VTAJ9Vi653WJeUuJ/H2T/DwyKj
	 zNFt00mgCLZsAD5jKcPADK4RRkpgNVmMpktMkQ8Xgxg5z51/bWHxMUQ9mFsQuuWDUD
	 z4cenIBvbg6odkXWQVvgwC3mu/xKWMUCzxPKjXj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 209/352] s390/pci: Do not mask MSI[-X] entries on teardown
Date: Thu, 15 Aug 2024 15:24:35 +0200
Message-ID: <20240815131927.366001321@linuxfoundation.org>
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

[ Upstream commit 3998527d2e3ee2bfdf710a45b7b90968ff87babc ]

The PCI core already ensures that the MSI[-X] state is correct when MSI[-X]
is disabled. For MSI the reset state is all entries unmasked and for MSI-X
all vectors are masked.

S390 masks all MSI entries and masks the already masked MSI-X entries
again. Remove it and let the device in the correct state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Link: https://lore.kernel.org/r/20210729222542.939798136@linutronix.de
Stable-dep-of: ab42fcb511fd ("s390/pci: Allow allocation of more than 1 MSI interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_irq.c | 4 ----
 drivers/pci/msi.c       | 4 ++--
 include/linux/msi.h     | 2 --
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
index 75217fb63d7b3..5036e00b7ec1b 100644
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -341,10 +341,6 @@ void arch_teardown_msi_irqs(struct pci_dev *pdev)
 	for_each_pci_msi_entry(msi, pdev) {
 		if (!msi->irq)
 			continue;
-		if (msi->msi_attrib.is_msix)
-			__pci_msix_desc_mask_irq(msi, 1);
-		else
-			__pci_msi_desc_mask_irq(msi, 1, 1);
 		irq_set_msi_desc(msi->irq, NULL);
 		irq_free_desc(msi->irq);
 		msi->msg.address_lo = 0;
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 27377f2f9e84b..935969ea3ea07 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -171,7 +171,7 @@ static inline __attribute_const__ u32 msi_mask(unsigned x)
  * reliably as devices without an INTx disable bit will then generate a
  * level IRQ which will never be cleared.
  */
-void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
+static void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag)
 {
 	raw_spinlock_t *lock = &desc->dev->msi_lock;
 	unsigned long flags;
@@ -208,7 +208,7 @@ static void __iomem *pci_msix_desc_addr(struct msi_desc *desc)
  * file.  This saves a few milliseconds when initialising devices with lots
  * of MSI-X interrupts.
  */
-u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag)
+static u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag)
 {
 	u32 mask_bits = desc->masked;
 	void __iomem *desc_addr;
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 70c910b23e131..8647f5f214297 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -193,8 +193,6 @@ void free_msi_entry(struct msi_desc *entry);
 void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 
-u32 __pci_msix_desc_mask_irq(struct msi_desc *desc, u32 flag);
-void __pci_msi_desc_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
 void pci_msi_mask_irq(struct irq_data *data);
 void pci_msi_unmask_irq(struct irq_data *data);
 
-- 
2.43.0



