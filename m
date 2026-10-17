Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB85C22F767;
	Sat, 17 Oct 2026 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258172; cv=none; b=m1E3nLWaPmmds9c1Wgp4+0myGeoW7SgrG/FYocKznx4QTx0QtnAYj60QsxcZD9zIoaRf4L4uyCBFjsUeQE23tlN7qwPhBgQ6eaz7wmEcsJbhe0nk9MFKDedfMKdlXPJpNMgKnVcnaZurULvzktJUBS9DPFmfqMc9rYL8E5Fr5LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258172; c=relaxed/simple;
	bh=BVvxck37E0fRGQcqnINslUph/ILb4eRn7BwPXjHT6YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqzeq6rLM/CtQnT4kY6kgt05/1xOVhNoK+AHPOE9rdNCB2ikzWepMdPkEr1xBrPi89Q9OQMUEkf8L+eBCPyI9jEJPE/Q6TZNOvOD13aJpXul54lpqFkq855WsZu0fOWfvl4fai0X+FkUuOXjVmI0aCM6CaQCmSJsaYoXe9VW+7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOmdhMwC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOmdhMwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AD51F000C4;
	Sat, 17 Oct 2026 17:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258171;
	bh=NEN+haWmd7U0FNBGRWO6T/HV+VOg/TU12LWpAm4Np+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOmdhMwCMAU8CfK2KVYxN7ANoN6t9qCvQQydEtAaxULP1r1o8NSyCs8RYnMupvI+4
	 qPthQvY9v95NYWDTA+KjT1l8a48pVdauuDn/BHAPWkJNa1XV3WYn4SonA1tDdkKz60
	 4zet94ggxW9PTaUj2E4TtF7ieP8p1GMEvEkF69WE=
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
Subject: [PATCH 6.6 0794/1674] iommu/s390: Make attach succeed when the device was surprise removed
Date: Sat, 17 Oct 2026 17:51:06 +0200
Message-ID: <20261017160451.487384283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/iommu/s390-iommu.c       | 23 ++++++++++++++++++-----
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index e5f57cfe1d458..5b2ed051f4322 100644
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
+#define ZPCI_CC_BUSY			2
+#define ZPCI_CC_INVAL_HANDLE		3
 
 /* Load/Store address space identifiers */
 #define ZPCI_PCIAS_MEMIO_0			0
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index fbf59a8db29b1..9328ada882b7a 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -101,6 +101,23 @@ static void __s390_iommu_detach_device(struct zpci_dev *zdev)
 	zdev->dma_table = NULL;
 }
 
+static bool reg_ioat_propagate_error(int cc, u8 status)
+{
+	/*
+	 * If the device is in the error state the reset routine
+	 * will register the IOAT of the newly set domain on re-enable
+	 */
+	if (cc == ZPCI_CC_ERR && status == ZPCI_PCI_ST_FUNC_NOT_AVAIL)
+		return false;
+	/*
+	 * If the device was removed treat registration as success
+	 * and let the subsequent error event trigger tear down.
+	 */
+	if (cc == ZPCI_CC_INVAL_HANDLE)
+		return false;
+	return cc != ZPCI_CC_OK;
+}
+
 static int s390_iommu_attach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
@@ -124,11 +141,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 
 	cc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
 				virt_to_phys(s390_domain->dma_table), &status);
-	/*
-	 * If the device is undergoing error recovery the reset code
-	 * will re-establish the new domain.
-	 */
-	if (cc && status != ZPCI_PCI_ST_FUNC_NOT_AVAIL)
+	if (reg_ioat_propagate_error(cc, status))
 		return -EIO;
 	zdev->dma_table = s390_domain->dma_table;
 
-- 
2.53.0



