Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD20E569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37190C433EF;
	Sun, 28 May 2023 19:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302427;
	bh=Z+vI4PnjYyIeqhykPJZIOZwqUrItmBdB1wSqnPYKPQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raqluVsXsP3G+T+Q3oyAwCOiMPQFxYEN5zGIe8+wzFu/YR/ba8wfj8f/iWQTFGyKj
	 5JYoTrGUDjqbhCUDm9I/RiNegb52zpfyHNuCxnnXvLayi1eSAWYWtOXCjoGiXWjHx3
	 bZ3hQfrxfzOWijmcrIbBTCbl3mVDVyMJTCSz25z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.3 097/127] x86/pci/xen: populate MSI sysfs entries
Date: Sun, 28 May 2023 20:11:13 +0100
Message-Id: <20230528190839.455434356@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maximilian Heyne <mheyne@amazon.de>

commit 335b4223466dd75f9f3ea4918187afbadd22e5c8 upstream.

Commit bf5e758f02fc ("genirq/msi: Simplify sysfs handling") reworked the
creation of sysfs entries for MSI IRQs. The creation used to be in
msi_domain_alloc_irqs_descs_locked after calling ops->domain_alloc_irqs.
Then it moved into __msi_domain_alloc_irqs which is an implementation of
domain_alloc_irqs. However, Xen comes with the only other implementation
of domain_alloc_irqs and hence doesn't run the sysfs population code
anymore.

Commit 6c796996ee70 ("x86/pci/xen: Fixup fallout from the PCI/MSI
overhaul") set the flag MSI_FLAG_DEV_SYSFS for the xen msi_domain_info
but that doesn't actually have an effect because Xen uses it's own
domain_alloc_irqs implementation.

Fix this by making use of the fallback functions for sysfs population.

Fixes: bf5e758f02fc ("genirq/msi: Simplify sysfs handling")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20230503131656.15928-1-mheyne@amazon.de
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/xen.c  |    8 +++++---
 include/linux/msi.h |    9 ++++++++-
 kernel/irq/msi.c    |    4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -198,7 +198,7 @@ static int xen_setup_msi_irqs(struct pci
 		i++;
 	}
 	kfree(v);
-	return 0;
+	return msi_device_populate_sysfs(&dev->dev);
 
 error:
 	if (ret == -ENOSYS)
@@ -254,7 +254,7 @@ static int xen_hvm_setup_msi_irqs(struct
 		dev_dbg(&dev->dev,
 			"xen: msi --> pirq=%d --> irq=%d\n", pirq, irq);
 	}
-	return 0;
+	return msi_device_populate_sysfs(&dev->dev);
 
 error:
 	dev_err(&dev->dev, "Failed to create MSI%s! ret=%d!\n",
@@ -346,7 +346,7 @@ static int xen_initdom_setup_msi_irqs(st
 		if (ret < 0)
 			goto out;
 	}
-	ret = 0;
+	ret = msi_device_populate_sysfs(&dev->dev);
 out:
 	return ret;
 }
@@ -394,6 +394,8 @@ static void xen_teardown_msi_irqs(struct
 			xen_destroy_irq(msidesc->irq + i);
 		msidesc->irq = 0;
 	}
+
+	msi_device_destroy_sysfs(&dev->dev);
 }
 
 static void xen_pv_teardown_msi_irqs(struct pci_dev *dev)
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -383,6 +383,13 @@ int arch_setup_msi_irq(struct pci_dev *d
 void arch_teardown_msi_irq(unsigned int irq);
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void arch_teardown_msi_irqs(struct pci_dev *dev);
+#endif /* CONFIG_PCI_MSI_ARCH_FALLBACKS */
+
+/*
+ * Xen uses non-default msi_domain_ops and hence needs a way to populate sysfs
+ * entries of MSI IRQs.
+ */
+#if defined(CONFIG_PCI_XEN) || defined(CONFIG_PCI_MSI_ARCH_FALLBACKS)
 #ifdef CONFIG_SYSFS
 int msi_device_populate_sysfs(struct device *dev);
 void msi_device_destroy_sysfs(struct device *dev);
@@ -390,7 +397,7 @@ void msi_device_destroy_sysfs(struct dev
 static inline int msi_device_populate_sysfs(struct device *dev) { return 0; }
 static inline void msi_device_destroy_sysfs(struct device *dev) { }
 #endif /* !CONFIG_SYSFS */
-#endif /* CONFIG_PCI_MSI_ARCH_FALLBACKS */
+#endif /* CONFIG_PCI_XEN || CONFIG_PCI_MSI_ARCH_FALLBACKS */
 
 /*
  * The restore hook is still available even for fully irq domain based
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -542,7 +542,7 @@ fail:
 	return ret;
 }
 
-#ifdef CONFIG_PCI_MSI_ARCH_FALLBACKS
+#if defined(CONFIG_PCI_MSI_ARCH_FALLBACKS) || defined(CONFIG_PCI_XEN)
 /**
  * msi_device_populate_sysfs - Populate msi_irqs sysfs entries for a device
  * @dev:	The device (PCI, platform etc) which will get sysfs entries
@@ -574,7 +574,7 @@ void msi_device_destroy_sysfs(struct dev
 	msi_for_each_desc(desc, dev, MSI_DESC_ALL)
 		msi_sysfs_remove_desc(dev, desc);
 }
-#endif /* CONFIG_PCI_MSI_ARCH_FALLBACK */
+#endif /* CONFIG_PCI_MSI_ARCH_FALLBACK || CONFIG_PCI_XEN */
 #else /* CONFIG_SYSFS */
 static inline int msi_sysfs_create_group(struct device *dev) { return 0; }
 static inline int msi_sysfs_populate_desc(struct device *dev, struct msi_desc *desc) { return 0; }


