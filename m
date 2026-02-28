Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5514D4A341C;
	Sat, 28 Feb 2026 17:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301311; cv=none; b=s/BSFCH8uyp+/EBOTfNh9QLxvTXd+rBKK2iL30gXkJhSdPhxFGWEZix0p+qkCDiKtOg67nolnqddnlLe0go1zO0X1qL8Mzpw2+ER8nS0mPbHbdF5U9ddeCRS/o63D+Zz4Tqnox2LNSuLCAVOziANqXw3+4mb67t39kFG3fmjtwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301311; c=relaxed/simple;
	bh=uo0zheTrvVxNjJYDzhSfBNrPEoWnK7upvG0njhOADD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl60jP6TOQAD+U3Ty9H8wICNwb/AKyqG7Ara2x2Q5KegPMEOmucjdDJxazMdmAt6itzas9XAP9x4VnybzDwW5acv6Tqm6n83yLfjzfVd3lVRAtK5vVa2oGXT2daOM7IX4osZ7Zq1lY3KO5gcdSt+ptzygBgqLStYZQuedch9fNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8lvmkbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8lvmkbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90886C19424;
	Sat, 28 Feb 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301311;
	bh=uo0zheTrvVxNjJYDzhSfBNrPEoWnK7upvG0njhOADD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8lvmkbMFBDiQUnN8nBLAD1remlsCwHUSiFmN3eO7r7Ah/RqK8NRHKTogGXOQ0I6N
	 7/X8f5L/hAzIYIpmhndK2wAjnJeB7YpAh9SOs9wVvivTq33zPPMKT0zdwhLikNKY/0
	 xAFp7unW+rAL/YufRcoKg4XvqU5/aCP2K01CaqctlhvNSkqT+OBzg3igl4B0XGDHi/
	 P36uPA7Y5zzSF/G6EEIN8oc+V/yojc0kMZel/fBcYEMzTIUI0mpACvak+e6If+ThVf
	 ad2I7wZKGFbOoZtNzUETNJR9mDmtOF9xm2W27D7bOrZO5m2+sT7LRGdPkJ/1Ac+VeI
	 ZiRuStvVpUOIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nam Cao <namcao@linutronix.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	stable@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/752] powerpc/pseries: Fix MSI-X allocation failure when quota is exceeded
Date: Sat, 28 Feb 2026 12:43:27 -0500
Message-ID: <20260228174750.1542406-496-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit c0215e2d72debcd9cbc1c002fb012d50a3140387 ]

Nilay reported that since commit daaa574aba6f ("powerpc/pseries/msi: Switch
to msi_create_parent_irq_domain()"), the NVMe driver cannot enable MSI-X
when the device's MSI-X table size is larger than the firmware's MSI quota
for the device.

This is because the commit changes how rtas_prepare_msi_irqs() is called:

  - Before, it is called when interrupts are allocated at the global
    interrupt domain with nvec_in being the number of allocated interrupts.
    rtas_prepare_msi_irqs() can return a positive number and the allocation
    will be retried.

  - Now, it is called at the creation of per-device interrupt domain with
    nvec_in being the number of interrupts that the device supports. If
    rtas_prepare_msi_irqs() returns positive, domain creation just fails.

For Nilay's NVMe driver case, rtas_prepare_msi_irqs() returns a positive
number (the quota). This causes per-device interrupt domain creation to
fail and thus the NVMe driver cannot enable MSI-X.

Rework to make this scenario works again:

  - pseries_msi_ops_prepare() only prepares as many interrupts as the quota
    permit.

  - pseries_irq_domain_alloc() fails if the device's quota is exceeded.

Now, if the quota is exceeded, pseries_msi_ops_prepare() will only prepare
as allowed by the quota. If device drivers attempt to allocate more
interrupts than the quota permits, pseries_irq_domain_alloc() will return
an error code and msi_handle_pci_fail() will allow device drivers a retry.

Reported-by: Nilay Shroff <nilay@linux.ibm.com>
Closes: https://lore.kernel.org/linuxppc-dev/6af2c4c2-97f6-4758-be33-256638ef39e5@linux.ibm.com/
Fixes: daaa574aba6f ("powerpc/pseries/msi: Switch to msi_create_parent_irq_domain()")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Cc: stable@vger.kernel.org
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Acked-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260107100230.1466093-1-namcao@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/msi.c | 44 ++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index a82aaa786e9e0..edc30cda5dbcb 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -19,6 +19,11 @@
 
 #include "pseries.h"
 
+struct pseries_msi_device {
+	unsigned int msi_quota;
+	unsigned int msi_used;
+};
+
 static int query_token, change_token;
 
 #define RTAS_QUERY_FN		0
@@ -433,8 +438,28 @@ static int pseries_msi_ops_prepare(struct irq_domain *domain, struct device *dev
 	struct msi_domain_info *info = domain->host_data;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	int type = (info->flags & MSI_FLAG_PCI_MSIX) ? PCI_CAP_ID_MSIX : PCI_CAP_ID_MSI;
+	int ret;
+
+	struct pseries_msi_device *pseries_dev __free(kfree)
+		= kmalloc(sizeof(*pseries_dev), GFP_KERNEL);
+	if (!pseries_dev)
+		return -ENOMEM;
+
+	while (1) {
+		ret = rtas_prepare_msi_irqs(pdev, nvec, type, arg);
+		if (!ret)
+			break;
+		else if (ret > 0)
+			nvec = ret;
+		else
+			return ret;
+	}
 
-	return rtas_prepare_msi_irqs(pdev, nvec, type, arg);
+	pseries_dev->msi_quota = nvec;
+	pseries_dev->msi_used = 0;
+
+	arg->scratchpad[0].ptr = no_free_ptr(pseries_dev);
+	return 0;
 }
 
 /*
@@ -443,9 +468,13 @@ static int pseries_msi_ops_prepare(struct irq_domain *domain, struct device *dev
  */
 static void pseries_msi_ops_teardown(struct irq_domain *domain, msi_alloc_info_t *arg)
 {
+	struct pseries_msi_device *pseries_dev = arg->scratchpad[0].ptr;
 	struct pci_dev *pdev = to_pci_dev(domain->dev);
 
 	rtas_disable_msi(pdev);
+
+	WARN_ON(pseries_dev->msi_used);
+	kfree(pseries_dev);
 }
 
 static void pseries_msi_shutdown(struct irq_data *d)
@@ -546,12 +575,18 @@ static int pseries_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 				    unsigned int nr_irqs, void *arg)
 {
 	struct pci_controller *phb = domain->host_data;
+	struct pseries_msi_device *pseries_dev;
 	msi_alloc_info_t *info = arg;
 	struct msi_desc *desc = info->desc;
 	struct pci_dev *pdev = msi_desc_to_pci_dev(desc);
 	int hwirq;
 	int i, ret;
 
+	pseries_dev = info->scratchpad[0].ptr;
+
+	if (pseries_dev->msi_used + nr_irqs > pseries_dev->msi_quota)
+		return -ENOSPC;
+
 	hwirq = rtas_query_irq_number(pci_get_pdn(pdev), desc->msi_index);
 	if (hwirq < 0) {
 		dev_err(&pdev->dev, "Failed to query HW IRQ: %d\n", hwirq);
@@ -567,9 +602,10 @@ static int pseries_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 			goto out;
 
 		irq_domain_set_hwirq_and_chip(domain, virq + i, hwirq + i,
-					      &pseries_msi_irq_chip, domain->host_data);
+					      &pseries_msi_irq_chip, pseries_dev);
 	}
 
+	pseries_dev->msi_used++;
 	return 0;
 
 out:
@@ -582,9 +618,11 @@ static void pseries_irq_domain_free(struct irq_domain *domain, unsigned int virq
 				    unsigned int nr_irqs)
 {
 	struct irq_data *d = irq_domain_get_irq_data(domain, virq);
-	struct pci_controller *phb = irq_data_get_irq_chip_data(d);
+	struct pseries_msi_device *pseries_dev = irq_data_get_irq_chip_data(d);
+	struct pci_controller *phb = domain->host_data;
 
 	pr_debug("%s bridge %pOF %d #%d\n", __func__, phb->dn, virq, nr_irqs);
+	pseries_dev->msi_used -= nr_irqs;
 	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
 }
 
-- 
2.51.0

