Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C6446C9;
	Tue, 20 Feb 2024 21:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464842; cv=none; b=LD/sTR+giHwkVQjDmlEwuAEMkb/L1VawO+d/4VGISF+mRH6wiyBzGDicFK0Tgg+O8C7Q8MzpZKYXTtkPWKyXIjiA7tp00sXScN/DJlNLOgyX2r+fn3msqgaYkfdmq+Fr+JUMwJKQ5VuwekWshuHFw0eyENCi4NVaJ8ioWgJKaO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464842; c=relaxed/simple;
	bh=fSFzmjneES0SCgCMJownDOXyzeKCSd2X/WAhtYexp2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nasB1ucDzubPBNLmA1E/FeSI2xE7QKG3KcQwAQb6aRyH8N17q8QlRAeq60us35cL7rZRud+quQ7qpjNT54JhL1OeRYhm9YBb7zO8vEJsHdVHkB2FT778xmIQpN403a5zzbEC8WwT3uAG0abokUSI9iean0BMuv2O2sfYIuaaG6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nK396AjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nK396AjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D0BC433C7;
	Tue, 20 Feb 2024 21:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464842;
	bh=fSFzmjneES0SCgCMJownDOXyzeKCSd2X/WAhtYexp2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nK396AjTJfh0opfqGaDvVNbrobejE8mXGlOok3MsuFrzSnPgd1H/Zl+oAKavuNZUi
	 DzHy5Ew+vBoH42S3hUePUG6VZOHt0l/790vMRDNvQGNNSWzqa35tbFUV8aQXNpv2et
	 zyUKHz9k9lD7sFhP95X2lkVj/IxHLpHrdZIYEj2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.7 127/309] Revert "powerpc/pseries/iommu: Fix iommu initialisation during DLPAR add"
Date: Tue, 20 Feb 2024 21:54:46 +0100
Message-ID: <20240220205637.132547514@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 1fba2bf8e9d5a27b7394856181b6200de7260b79 upstream.

This reverts commit ed8b94f6e0acd652ce69bd69d678a0c769172df8.

Gaurav reported that there are still problems with the patch and it
should be reverted pending a fuller fix.

Link: https://lore.kernel.org/all/4f6fc1ac-7a76-4447-9d0e-f55c0be373f8@linux.ibm.com/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ppc-pci.h         |    3 ---
 arch/powerpc/kernel/iommu.c                |   21 +++++----------------
 arch/powerpc/platforms/pseries/pci_dlpar.c |    4 ----
 3 files changed, 5 insertions(+), 23 deletions(-)

--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -29,9 +29,6 @@ void *pci_traverse_device_nodes(struct d
 				void *(*fn)(struct device_node *, void *),
 				void *data);
 extern void pci_devs_phb_init_dynamic(struct pci_controller *phb);
-extern void ppc_iommu_register_device(struct pci_controller *phb);
-extern void ppc_iommu_unregister_device(struct pci_controller *phb);
-
 
 /* From rtas_pci.h */
 extern void init_pci_config_tokens (void);
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1390,21 +1390,6 @@ static const struct attribute_group *spa
 	NULL,
 };
 
-void ppc_iommu_register_device(struct pci_controller *phb)
-{
-	iommu_device_sysfs_add(&phb->iommu, phb->parent,
-				spapr_tce_iommu_groups, "iommu-phb%04x",
-				phb->global_number);
-	iommu_device_register(&phb->iommu, &spapr_tce_iommu_ops,
-				phb->parent);
-}
-
-void ppc_iommu_unregister_device(struct pci_controller *phb)
-{
-	iommu_device_unregister(&phb->iommu);
-	iommu_device_sysfs_remove(&phb->iommu);
-}
-
 /*
  * This registers IOMMU devices of PHBs. This needs to happen
  * after core_initcall(iommu_init) + postcore_initcall(pci_driver_init) and
@@ -1415,7 +1400,11 @@ static int __init spapr_tce_setup_phb_io
 	struct pci_controller *hose;
 
 	list_for_each_entry(hose, &hose_list, list_node) {
-		ppc_iommu_register_device(hose);
+		iommu_device_sysfs_add(&hose->iommu, hose->parent,
+				       spapr_tce_iommu_groups, "iommu-phb%04x",
+				       hose->global_number);
+		iommu_device_register(&hose->iommu, &spapr_tce_iommu_ops,
+				      hose->parent);
 	}
 	return 0;
 }
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -35,8 +35,6 @@ struct pci_controller *init_phb_dynamic(
 
 	pseries_msi_allocate_domains(phb);
 
-	ppc_iommu_register_device(phb);
-
 	/* Create EEH devices for the PHB */
 	eeh_phb_pe_create(phb);
 
@@ -78,8 +76,6 @@ int remove_phb_dynamic(struct pci_contro
 		}
 	}
 
-	ppc_iommu_unregister_device(phb);
-
 	pseries_msi_free_domains(phb);
 
 	/* Keep a reference so phb isn't freed yet */


