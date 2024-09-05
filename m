Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A109C83CC8;
	Thu,  5 Sep 2024 09:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530393; cv=none; b=HO726WfOxuMfZjx1HMjyvUGaoNLDWXd5vwFRp+5sbwqV4Tu6Pf2mhM8akMYETCKH/el6JnzQI03sgRhacsq0ceILKWX1N2IFiZhHjpGbtX4gt7ZGJ5JOkJXLfJvSr7CAnciU0xhAumvMfGtHoN7mxO/tPX2opc+rPZLTlG6eFq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530393; c=relaxed/simple;
	bh=BqWWmzcuoQnnNv+WWCu8iUS9trxwwORdTXrNKSe5GBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcTdspQmySZa7gIHBqzzsKJ+SNAMEaNw5hp/rP5SB54QWxG9tMWedcqewbKScg4eRhUrmIjhIcDo7sbHGeEvkaDO8u+CcVFk7XncY6PhdqQfMbzfHUcNgMLVm+j90O1SPablKkHrO1rTpTSbGtM/k5IGm0CzgdAW8fGuxYFCuU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTzyNd/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTzyNd/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2BFC4CEC6;
	Thu,  5 Sep 2024 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530393;
	bh=BqWWmzcuoQnnNv+WWCu8iUS9trxwwORdTXrNKSe5GBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTzyNd/C6yzCL1Vu/uYPaqrvzIjiTmCBAHeCA4RSkvmSB+e5cAI3Jhx7HMHdL/x/B
	 6Uk+N8CkHuDzUTOltY5lM2fEDSXR7Y7rIhiK92ERlEtjE+V4XPwWzh8oMuNOvdfsOz
	 dur672vBpXvrutgaUw9gvPeZx28mSRfkHBXF/qbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Mostafa Saleh <smostafa@google.com>,
	Bjorn Heelgas <bhelgaas@google.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 6.1 011/101] PCI/MSI: Fix UAF in msi_capability_init
Date: Thu,  5 Sep 2024 11:40:43 +0200
Message-ID: <20240905093716.532619154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

commit 9eee5330656bf92f51cb1f09b2dc9f8cf975b3d1 upstream.

KFENCE reports the following UAF:

 BUG: KFENCE: use-after-free read in __pci_enable_msi_range+0x2c0/0x488

 Use-after-free read at 0x0000000024629571 (in kfence-#12):
  __pci_enable_msi_range+0x2c0/0x488
  pci_alloc_irq_vectors_affinity+0xec/0x14c
  pci_alloc_irq_vectors+0x18/0x28

 kfence-#12: 0x0000000008614900-0x00000000e06c228d, size=104, cache=kmalloc-128

 allocated by task 81 on cpu 7 at 10.808142s:
  __kmem_cache_alloc_node+0x1f0/0x2bc
  kmalloc_trace+0x44/0x138
  msi_alloc_desc+0x3c/0x9c
  msi_domain_insert_msi_desc+0x30/0x78
  msi_setup_msi_desc+0x13c/0x184
  __pci_enable_msi_range+0x258/0x488
  pci_alloc_irq_vectors_affinity+0xec/0x14c
  pci_alloc_irq_vectors+0x18/0x28

 freed by task 81 on cpu 7 at 10.811436s:
  msi_domain_free_descs+0xd4/0x10c
  msi_domain_free_locked.part.0+0xc0/0x1d8
  msi_domain_alloc_irqs_all_locked+0xb4/0xbc
  pci_msi_setup_msi_irqs+0x30/0x4c
  __pci_enable_msi_range+0x2a8/0x488
  pci_alloc_irq_vectors_affinity+0xec/0x14c
  pci_alloc_irq_vectors+0x18/0x28

Descriptor allocation done in:
__pci_enable_msi_range
    msi_capability_init
        msi_setup_msi_desc
            msi_insert_msi_desc
                msi_domain_insert_msi_desc
                    msi_alloc_desc
                        ...

Freed in case of failure in __msi_domain_alloc_locked()
__pci_enable_msi_range
    msi_capability_init
        pci_msi_setup_msi_irqs
            msi_domain_alloc_irqs_all_locked
                msi_domain_alloc_locked
                    __msi_domain_alloc_locked => fails
                    msi_domain_free_locked
                        ...

That failure propagates back to pci_msi_setup_msi_irqs() in
msi_capability_init() which accesses the descriptor for unmasking in the
error exit path.

Cure it by copying the descriptor and using the copy for the error exit path
unmask operation.

[ tglx: Massaged change log ]

Fixes: bf6e054e0e3f ("genirq/msi: Provide msi_device_populate/destroy_sysfs()")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Heelgas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624203729.1094506-1-smostafa@google.com
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/msi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -431,7 +431,7 @@ static int msi_capability_init(struct pc
 			       struct irq_affinity *affd)
 {
 	struct irq_affinity_desc *masks = NULL;
-	struct msi_desc *entry;
+	struct msi_desc *entry, desc;
 	int ret;
 
 	/*
@@ -452,6 +452,12 @@ static int msi_capability_init(struct pc
 	/* All MSIs are unmasked by default; mask them all */
 	entry = msi_first_desc(&dev->dev, MSI_DESC_ALL);
 	pci_msi_mask(entry, msi_multi_mask(entry));
+	/*
+	 * Copy the MSI descriptor for the error path because
+	 * pci_msi_setup_msi_irqs() will free it for the hierarchical
+	 * interrupt domain case.
+	 */
+	memcpy(&desc, entry, sizeof(desc));
 
 	/* Configure MSI capability structure */
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSI);
@@ -471,7 +477,7 @@ static int msi_capability_init(struct pc
 	goto unlock;
 
 err:
-	pci_msi_unmask(entry, msi_multi_mask(entry));
+	pci_msi_unmask(&desc, msi_multi_mask(&desc));
 	free_msi_irqs(dev);
 fail:
 	dev->msi_enabled = 0;


