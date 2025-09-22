Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC67311948;
	Mon, 22 Sep 2025 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570302; cv=none; b=dIf2BViu5kYebF2hKMdm360ykBhXzXJ9FIUexBvBRcd1LyWleAp+0osZft+2yC4Mn3lZNoSKElQIvHUF6QQhBE1DqgkmQAWf42TThcikOQWmB8AsCJ9zr8a8PmMV87z4EGexIU3DAgZTuKv3FIeUAi5BkoRG/ggRfb56EpQ0tgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570302; c=relaxed/simple;
	bh=2J6LTz6oAOpxeJpqg4vUPX5rNDi1gjxhEqsxqNF7oh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtsh4xQCaDoTUz52djg8iGEtjZwaWYy6gnPCvkx/BwGAUippPi9hhUfrA02BxBqCP62qlA3NlyS8tEVeygEXEFOcn7uy9uWOD86iodEx5lOqqYtGVwyTNsNlxmvw41bhDlP8uGAKWo5bO8psxJj5qazGb29hdDoAbrKXUs4RPF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/qACkGP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/qACkGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FB9C4CEF0;
	Mon, 22 Sep 2025 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570302;
	bh=2J6LTz6oAOpxeJpqg4vUPX5rNDi1gjxhEqsxqNF7oh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/qACkGPg5P1MXHnzCa5U8NLr6cr03T3AgxPUq0h4njBWe0nSXyznVG9hHuu8yLf7
	 rWk3RC6utg+AhxK9itCJWgrecpqxfbfPbUgaQtqPb62Z94DGe/p+m6FqjiHtJhluvC
	 K0Q6FN5bqE6EhDcNMQ48E7OmF8emXEqQ5X5up10w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.16 082/149] iommu/s390: Make attach succeed when the device was surprise removed
Date: Mon, 22 Sep 2025 21:29:42 +0200
Message-ID: <20250922192414.950747064@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 9ffaf5229055fcfbb3b3d6f1c7e58d63715c3f73 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci_insn.h |   10 +++++-----
 drivers/iommu/s390-iommu.c       |   26 +++++++++++++++++++-------
 2 files changed, 24 insertions(+), 12 deletions(-)

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
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -611,6 +611,23 @@ static u64 get_iota_region_flag(struct s
 	}
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
 static int s390_iommu_domain_reg_ioat(struct zpci_dev *zdev,
 				      struct iommu_domain *domain, u8 *status)
 {
@@ -695,7 +712,7 @@ static int s390_iommu_attach_device(stru
 
 	/* If we fail now DMA remains blocked via blocking domain */
 	cc = s390_iommu_domain_reg_ioat(zdev, domain, &status);
-	if (cc && status != ZPCI_PCI_ST_FUNC_NOT_AVAIL)
+	if (reg_ioat_propagate_error(cc, status))
 		return -EIO;
 	zdev->dma_table = s390_domain->dma_table;
 	zdev_s390_domain_update(zdev, domain);
@@ -1123,12 +1140,7 @@ static int s390_attach_dev_identity(stru
 
 	/* If we fail now DMA remains blocked via blocking domain */
 	cc = s390_iommu_domain_reg_ioat(zdev, domain, &status);
-
-	/*
-	 * If the device is undergoing error recovery the reset code
-	 * will re-establish the new domain.
-	 */
-	if (cc && status != ZPCI_PCI_ST_FUNC_NOT_AVAIL)
+	if (reg_ioat_propagate_error(cc, status))
 		return -EIO;
 
 	zdev_s390_domain_update(zdev, domain);


