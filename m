Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF0022F767;
	Sat, 17 Oct 2026 16:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253463; cv=none; b=CRQ4fHGBFacLXn7Z40mNEoB+UCjtmeMlF7NzU1PajFcyk3ug6cbOjv/iRoeTLu2krtWXaqIz2BaoQelnbPQVmrko3+eAIGo/rvPZPDXIU/I/I6Y8uMDHLxlXabTGDcZ5C2hv1NDrN1MI+yMnvfzxl/yK9ELhm0eg8b2mOxpJ4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253463; c=relaxed/simple;
	bh=D66ij6lp6dOSng9+RYsNKwJd5gYPuiGwn9meeNY49Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdNlJrRe21a3u/BKJT1t1xBxGmQaW0alsJesqKSQYwyjg+hzZlhSSn1khNALSy+oeDjY0DCFkkvErjKfbiN44vj4ufMIvQviLe4QO/vyPV4yBM3tQVPXfmXDlKbkmiO11jpdVp/7NxhE3J+HLyJJXvYfdZxXYlA9PI+3cAiJbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml+FMQ01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml+FMQ01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA801F000C4;
	Sat, 17 Oct 2026 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253462;
	bh=wfCwJfi5LDrEPs286R5dsCvddJYuVwlEETwfxUws0W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ml+FMQ01Os/ONiXJ/1mMBDCulamUbGKfYNzUhwpF3R26laWW7yCN61V7bUKfULX6n
	 fx2j10fqn1s73isFL8BNTOe05SydBts847J01ssO6Nlhw1PSE3hJMGwdFmQcyRctrl
	 +/HvmgRs2i1prEz/DiV7e4n+/TwI3m9EiXhNGbMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/869] iommu/s390: Make attach succeed when the device was surprise removed
Date: Sat, 17 Oct 2026 17:49:28 +0200
Message-ID: <20261017160040.297255604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 9ffaf5229055fcfbb3b3d6f1c7e58d63715c3f73 ]

When a PCI device is removed with surprise hotplug, there may still be
attempts to attach the device to the default domain as part of tear down
via (__iommu_release_dma_ownership()), or because the removal happens
during probe (__iommu_probe_device()). In both cases zpci_register_ioat()
fails with a cc value indicating that the device handle is invalid. This
is because the device is no longer part of the instance as far as the
hypervisor is concerned.

Currently this leads to an error return and s390_iommu_attach_device()
fails. This triggers the WARN_ON() in __iommu_group_set_domain_nofail()
because attaching to the default domain must never fail.

With the device fenced by the hypervisor no DMAs to or from memory are
possible and the IOMMU translations have no effect. Proceed as if the
registration was successful and let the hotplug event handling clean up
the device.

This is similar to how devices in the error state are handled since
commit 59bbf596791b ("iommu/s390: Make attach succeed even if the device
is in error state") except that for removal the domain will not be
registered later. This approach was also previously discussed at the
link.

Handle both cases, error state and removal, in a helper which checks if
the error needs to be propagated or ignored. Avoid magic number
condition codes by using the pre-existing, but never used, defines for
PCI load/store condition codes and rename them to reflect that they
apply to all PCI instructions.

Cc: stable@vger.kernel.org # v6.2
Link: https://lore.kernel.org/linux-iommu/20240808194155.GD1985367@ziepe.ca/
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Link: https://lore.kernel.org/r/20250904-iommu_succeed_attach_removed-v1-1-e7f333d2f80f@linux.ibm.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/pci_insn.h | 10 +++++-----
 drivers/iommu/s390-iommu.c       |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index e5f57cfe1d458..025c6dcbf8933 100644
--- a/arch/s390/include/asm/pci_insn.h
+++ b/arch/s390/include/asm/pci_insn.h
@@ -16,11 +16,11 @@
 #define ZPCI_PCI_ST_FUNC_NOT_AVAIL		40
 #define ZPCI_PCI_ST_ALREADY_IN_RQ_STATE		44
 
-/* Load/Store return codes */
-#define ZPCI_PCI_LS_OK				0
-#define ZPCI_PCI_LS_ERR				1
-#define ZPCI_PCI_LS_BUSY			2
-#define ZPCI_PCI_LS_INVAL_HANDLE		3
+/* PCI instruction condition codes */
+#define ZPCI_CC_OK				0
+#define ZPCI_CC_ERR				1
+#define ZPCI_CC_BUSY				2
+#define ZPCI_CC_INVAL_HANDLE			3
 
 /* Load/Store address space identifiers */
 #define ZPCI_PCIAS_MEMIO_0			0
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 3df6b3e322271..067b175231ad1 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -480,7 +480,8 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 
 	/* If we fail now DMA remains blocked via blocking domain */
 	cc = s390_iommu_domain_reg_ioat(zdev, domain, &status);
-	if (cc && status != ZPCI_PCI_ST_FUNC_NOT_AVAIL)
+	if (cc != ZPCI_CC_OK && cc != ZPCI_CC_INVAL_HANDLE &&
+	    (cc != ZPCI_CC_ERR || status != ZPCI_PCI_ST_FUNC_NOT_AVAIL))
 		return -EIO;
 	zdev->dma_table = s390_domain->dma_table;
 	zdev_s390_domain_update(zdev, domain);
-- 
2.53.0



