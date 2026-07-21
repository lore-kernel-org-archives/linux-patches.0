Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D7E2EBB8D;
	Tue, 21 Jul 2026 20:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666584; cv=none; b=kZDOefbUkG9A615G7hWdF4EPsqR1Ti1aiWlGE/WUjLLN58EwABGqfpTs/M+SZt+G1IhFIZqiisMzDXI7JTMDlwfyDRvbWZWXuL2z9tRClT86yhfCBrCyHSJeU8TcWIeHBxRWL38Wy5OrXT51w0vLvsUIRfgXGGaNBN79VrVV+bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666584; c=relaxed/simple;
	bh=USDjQoyiG7qgzCwI1u/YVeJXF9qEVdi+LXOqCCrCQX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K56ego6EnW/WBmUx/olQiYkPfTcSnGpyIa0/lHT+NxN5rsJdMWpyCfDTcb9aZbyZpiWMzlNKydFjOjuGHQsLG0TN1eV+Mwwxxid/KN9AFgwYKzNKblEvPxqqIOwRrJNQ/mDAEwPi3tPnj+TQcSgFhvIM/g1v3U1z0ECoCHoC6g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mjtx6fyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mjtx6fyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBA61F000E9;
	Tue, 21 Jul 2026 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666583;
	bh=26mvFB4eE/58A5ktnOaura1saD5eiccWWGLwJHWskoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mjtx6fySEpqI7pS39mJpJTQnP3TB9gM+61eBnoj+WQjYVPx0unuN2ZsZD8D0bgWQl
	 FPasiKPueLeSu+R5pp39juxriND+uC8Rv1I8iI+yV6i80/2ijKThs+WQ5zWIvIWCvV
	 gHo/aT6SomrL0eikS20bb9qzFZOSmB6pD6jHBHDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0695/1266] Revert "PCI/MSI: Unmap MSI-X region on error"
Date: Tue, 21 Jul 2026 17:18:52 +0200
Message-ID: <20260721152457.410553105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f6f4a778a98678..b638731aa5ff2f 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -737,7 +737,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	ret = msix_setup_interrupts(dev, entries, nvec, affd);
 	if (ret)
-		goto out_unmap;
+		goto out_disable;
 
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
@@ -756,8 +756,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	pcibios_free_irq(dev);
 	return 0;
 
-out_unmap:
-	iounmap(dev->msix_base);
 out_disable:
 	dev->msix_enabled = 0;
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-- 
2.53.0



