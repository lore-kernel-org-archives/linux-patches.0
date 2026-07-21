Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574D835DA40;
	Tue, 21 Jul 2026 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662681; cv=none; b=mffjHmMoiPlgi08p8nwHbvaALcdZjRRJTbJ24/MbeCnrXhwuDWi6/up6AxMNV2U9V+nB4vU37xMegyEJ8O9VZcfJcLRvJDYRs/9expS4eb3MTCbHooS7khMiRLrhOtcJf+rxrB654WhKPhONbjLyyEXdntnTZNtsKeD2P8WJ6lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662681; c=relaxed/simple;
	bh=V6cukyB53Hv9c2QTNKC+kJXwsLzNF/YOYaom8kw+QTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OY7QUC9Q7WfAM0AHwLl5AmOxitBuv/K6AT2VBIK15QJiUPlvJHcf2oH30mKQAhH8wyaSQ744gtkZeG3HTu1gYRUj9YcL/W17xFtCeKWMjC0Fk2EniYdHPe+gBehqGR4VtKxZP31wIgtVq6VPIc+uPNODxFBFEdGRiXkmSpXyWN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKz3Hnx+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKz3Hnx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15321F00A3A;
	Tue, 21 Jul 2026 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662679;
	bh=NL5ENBaB7QbNz5ZQBLGUF+wjyWpcY8i2JZN6k8bE2Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKz3Hnx+JSTi2G1xBiV4CTxTW+ujv0hi+zKsgxGCq2/7ijLQUyYmHfGabt0w+36ML
	 CMFjXCwltrC90Nx8kqrTO+qKAoKxjYBMNy1JrE13BeN6AnWHF7o/FvaX94q4rFl1wq
	 Pd1lThUsMujrKBtBlfGJid1OmNEgONBhFpGWIc18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0535/1276] Revert "PCI/MSI: Unmap MSI-X region on error"
Date: Tue, 21 Jul 2026 17:16:18 +0200
Message-ID: <20260721152458.096489863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Yuanhe Shu <xiangzao@linux.alibaba.com>

[ Upstream commit f64e03da0d83cb173743888bff4a7e61476a8fc2 ]

This reverts commit 1a8d4c6ecb4c81261bcdf13556abd4a958eca202.

Commit 1a8d4c6ecb4c ("PCI/MSI: Unmap MSI-X region on error") added an
iounmap(dev->msix_base) on the error path of msix_capability_init() to
release the MSI-X region when msix_setup_interrupts() fails.

When msix_setup_interrupts() fails, the call chain is:

  msix_setup_interrupts()
    -> __msix_setup_interrupts()
         struct pci_dev *dev __free(free_msi_irqs) = __dev;
         ...
         return ret;  // __free cleanup fires on error

The __free(free_msi_irqs) cleanup calls pci_free_msi_irqs(), which
already handles the unmap:

  void pci_free_msi_irqs(struct pci_dev *dev)
  {
      pci_msi_teardown_msi_irqs(dev);
      if (dev->msix_base) {
          iounmap(dev->msix_base);   // already unmapped here
          dev->msix_base = NULL;     // and set to NULL
      }
  }

So dev->msix_base is unmapped and set to NULL before
msix_setup_interrupts() returns to msix_capability_init(). The
"goto out_unmap" introduced by commit 1a8d4c6ecb4c ("PCI/MSI: Unmap
MSI-X region on error") then calls iounmap() a second time on a NULL
pointer.

This was reproduced on Intel Emerald Rapids (192 CPUs) while
running tools/testing/selftests/kexec/test_kexec_jump.sh:

  WARNING: CPU#44 at iounmap+0x2a/0xe0
  RIP: 0010:iounmap+0x2a/0xe0
  RDI: 0000000000000000
  Call Trace:
   msix_capability_init+0x317/0x3f0
   __pci_enable_msix_range+0x21d/0x2c0
   pci_alloc_irq_vectors_affinity+0xa9/0x130
   nvme_setup_io_queues+0x2a8/0x420 [nvme]
   nvme_reset_work+0x151/0x340 [nvme]
   ...

RDI=0 confirms iounmap() is called with NULL.

Restore the original "goto out_disable" and leave the unmap to the
existing __free(free_msi_irqs) cleanup.

Fixes: 1a8d4c6ecb4c ("PCI/MSI: Unmap MSI-X region on error")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://lore.kernel.org/all/20260610194406.GA380991@bhelgaas/
Link: https://patch.msgid.link/20260611025901.1105209-1-xiangzao@linux.alibaba.com
Closes: https://lore.kernel.org/all/4fc6208d-513b-4f41-a13a-4a0829ab50ad@roeck-us.net/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi/msi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 54627c3a2dc8c9..8b884878861842 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -739,7 +739,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	ret = msix_setup_interrupts(dev, entries, nvec, affd);
 	if (ret)
-		goto out_unmap;
+		goto out_disable;
 
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
@@ -760,8 +760,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	pcibios_free_irq(dev);
 	return 0;
 
-out_unmap:
-	iounmap(dev->msix_base);
 out_disable:
 	dev->msix_enabled = 0;
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-- 
2.53.0



