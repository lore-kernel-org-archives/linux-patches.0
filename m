Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180E2257AE7;
	Thu, 17 Apr 2025 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914312; cv=none; b=Ne+TPzNN8tvFeUitgOON9X+worXCsS1dzUUUL5KwAbM8CSsN+i0TyR9KzWYoGuzAZpz7VTsVryMce8W1wvdjlemj+XEXkKgBs99zvxs5CZrr8691OM8vffy+b+yPKPIS5KBFMw7jcAUavHGxHpcJKxoX8uCzE562gC+5vhTqtZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914312; c=relaxed/simple;
	bh=jXDlw44RLwCNsZCd4EfoEwe5jZIv7khC1Aa6cOuK7EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAxssOYsXEQX4wOrf5+AkwJj5yUYvj2hxlagJnvVgru5UmBJVCII8FTm2BeJ95LP1Vc2dnJ5eLV5sfZRwWdsVx0HbLAZJvLsE1CVZ6EyeKE0HxeLVUx816a5BwJJQ87O1cVBcqHnOQxmQ4+hHN9lY9wsgXPAA29oDEnxt1+ce6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4aGW6hS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4aGW6hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE17C4CEEA;
	Thu, 17 Apr 2025 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914312;
	bh=jXDlw44RLwCNsZCd4EfoEwe5jZIv7khC1Aa6cOuK7EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4aGW6hSH09vA6IrJSaMV/TwSr3bimKmzkUhtswOiOVDs4Gn9+BAVU7WMcAmCElYM
	 47v3LNBD0edhJgNLd/Rfym0QPfDCe+EtgYMqnAxwDPpRNncJLznXtCBtd5BFPOM9zz
	 ILj2HdcQ5RbiD9JyTXYirzFRF4XSEtTgJIbAcSV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 173/414] s390/pci: Fix s390_mmio_read/write syscall page fault handling
Date: Thu, 17 Apr 2025 19:48:51 +0200
Message-ID: <20250417175118.395526612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 41a0926e82f4963046876ed9a1b5f681be8087a8 ]

The s390 MMIO syscalls when using the classic PCI instructions do not
cause a page fault when follow_pfnmap_start() fails due to the page not
being present. Besides being a general deficiency this breaks vfio-pci's
mmap() handling once VFIO_PCI_MMAP gets enabled as this lazily maps on
first access. Fix this by following a failed follow_pfnmap_start() with
fixup_user_page() and retrying the follow_pfnmap_start(). Also fix
a VM_READ vs VM_WRITE mixup in the read syscall.

Link: https://lore.kernel.org/r/20250226-vfio_pci_mmap-v7-1-c5c0f1d26efd@linux.ibm.com
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 46f99dc164ade..1997d9b7965df 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -175,8 +175,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
 	args.address = mmio_addr;
 	args.vma = vma;
 	ret = follow_pfnmap_start(&args);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
+		ret = follow_pfnmap_start(&args);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
@@ -315,14 +319,18 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long, mmio_addr,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out_unlock_mmap;
 	ret = -EACCES;
-	if (!(vma->vm_flags & VM_WRITE))
+	if (!(vma->vm_flags & VM_READ))
 		goto out_unlock_mmap;
 
 	args.vma = vma;
 	args.address = mmio_addr;
 	ret = follow_pfnmap_start(&args);
-	if (ret)
-		goto out_unlock_mmap;
+	if (ret) {
+		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
+		ret = follow_pfnmap_start(&args);
+		if (ret)
+			goto out_unlock_mmap;
+	}
 
 	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
 			(mmio_addr & ~PAGE_MASK));
-- 
2.39.5



