Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE353446C7;
	Tue, 21 Jul 2026 21:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669431; cv=none; b=k8mpF79U97T/g89QlDnQbBEiTlqaHr+9rlFawWN8ON7zkWDh66wkx/QU8+/aQD05NJjBifgOsQmEyzKa+EiblgmwisIOsFvRJvlcywqykhMsIIsIn2FV0ssdr5enY9gHro/cqIQ1ciMr61rI6MPwrEl53AtvfMRx9JhBHJ/JBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669431; c=relaxed/simple;
	bh=qm6k5DmSc0sX4b3PaOwG9RnBl7hcRFGvRKlgwFcmY3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGI/0LGtfG4Kx/T3TXqP8MdUzedxOa9fhRx3dAmKH53BQoTeTE4sAWhopnz07Rq12p57A3yVDJC9jaiJF8iANH8z8zv4kfXCNSdXywmb9fhmNuHsEwbFSnXt39tugAvt5BwLoqITskB3L2/RmAaiJh44l5JP3K6rfqV2XWKVmaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j55LVQYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j55LVQYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2911F000E9;
	Tue, 21 Jul 2026 21:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669430;
	bh=jjahKZGgwybg3804M8kRQ18b/77s2U21JD+0Rbq98kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j55LVQYzmthaYrk5N4fW2uE7a0pmKT8XY/8x1JQpN8XkoJUiJm7O9vaZaXIknQ5zu
	 WkuZAcd13hqaOsicd0TaGViNKCj4Syp+Jeu1GAZXUSxhu+K9M2KzCH6BQ4vIwq7Qe8
	 ndR1Fz7UR8j/bigl8dttaPDcUtk13QSMzVV2jXVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0551/1067] Revert "PCI/MSI: Unmap MSI-X region on error"
Date: Tue, 21 Jul 2026 17:19:12 +0200
Message-ID: <20260721152436.936080339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a2375585338bc..7110aed956c750 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -648,7 +648,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	ret = msix_setup_interrupts(dev, base, entries, nvec, affd);
 	if (ret)
-		goto out_unmap;
+		goto out_disable;
 
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
@@ -667,8 +667,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	pcibios_free_irq(dev);
 	return 0;
 
-out_unmap:
-	iounmap(dev->msix_base);
 out_disable:
 	dev->msix_enabled = 0;
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-- 
2.53.0



