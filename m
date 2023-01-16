Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EC86FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DF1C433F0;
	Mon, 16 Jan 2023 16:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887807;
	bh=+/25qYP549VwN88J/GdyNNWUV/nAA73jjfj0By02NSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2KO1qtqRlvs+nO8/k2OtQj/Z07Lu+vpK7aHDKFCIihvbsSFh7hWojoByysv2pmiW
	 L4ZcfJwlHTd0hz2pMbaKRr40MKjlvngf1Tu2lpO/Mj7gfbRDbGWaInvNRWdSPL+Mo4
	 wvSyK2lHIcRIqQ6O0+TkxAxfEaMkWa6jlhnW74N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobroff <sbobroff@linux.ibm.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 289/521] powerpc/eeh: Improve debug messages around device addition
Date: Mon, 16 Jan 2023 16:49:11 +0100
Message-Id: <20230116154900.062539055@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 617082a4817a4354fa3de05c80b5f6088e2083b7 ]

Also remove useless comment.

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/59db84f4bf94718a12f206bc923ac797d47e4cc1.1565930772.git.sbobroff@linux.ibm.com
Stable-dep-of: 9aafbfa5f57a ("powerpc/pseries/eeh: use correct API for error log size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh.c                    |  2 +-
 arch/powerpc/platforms/powernv/eeh-powernv.c | 14 ++++++++----
 arch/powerpc/platforms/pseries/eeh_pseries.c | 23 +++++++++++++++-----
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 44bb522fb4a2..2b81e9a056b5 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -1178,7 +1178,7 @@ void eeh_add_device_late(struct pci_dev *dev)
 	pdn = pci_get_pdn_by_devfn(dev->bus, dev->devfn);
 	edev = pdn_to_eeh_dev(pdn);
 	if (edev->pdev == dev) {
-		pr_debug("EEH: Already referenced !\n");
+		pr_debug("EEH: Device %s already referenced!\n", pci_name(dev));
 		return;
 	}
 
diff --git a/arch/powerpc/platforms/powernv/eeh-powernv.c b/arch/powerpc/platforms/powernv/eeh-powernv.c
index 9dd5b8909178..4fa601feb860 100644
--- a/arch/powerpc/platforms/powernv/eeh-powernv.c
+++ b/arch/powerpc/platforms/powernv/eeh-powernv.c
@@ -50,10 +50,7 @@ void pnv_pcibios_bus_add_device(struct pci_dev *pdev)
 	if (!pdev->is_virtfn)
 		return;
 
-	/*
-	 * The following operations will fail if VF's sysfs files
-	 * aren't created or its resources aren't finalized.
-	 */
+	pr_debug("%s: EEH: Setting up device %s.\n", __func__, pci_name(pdev));
 	eeh_add_device_early(pdn);
 	eeh_add_device_late(pdev);
 	eeh_sysfs_add_device(pdev);
@@ -378,6 +375,10 @@ static void *pnv_eeh_probe(struct pci_dn *pdn, void *data)
 	int ret;
 	int config_addr = (pdn->busno << 8) | (pdn->devfn);
 
+	pr_debug("%s: probing %04x:%02x:%02x.%01x\n",
+		__func__, hose->global_number, pdn->busno,
+		PCI_SLOT(pdn->devfn), PCI_FUNC(pdn->devfn));
+
 	/*
 	 * When probing the root bridge, which doesn't have any
 	 * subordinate PCI devices. We don't have OF node for
@@ -478,6 +479,11 @@ static void *pnv_eeh_probe(struct pci_dn *pdn, void *data)
 	/* Save memory bars */
 	eeh_save_bars(edev);
 
+	pr_debug("%s: EEH enabled on %02x:%02x.%01x PHB#%x-PE#%x\n",
+		__func__, pdn->busno, PCI_SLOT(pdn->devfn),
+		PCI_FUNC(pdn->devfn), edev->pe->phb->global_number,
+		edev->pe->addr);
+
 	return NULL;
 }
 
diff --git a/arch/powerpc/platforms/pseries/eeh_pseries.c b/arch/powerpc/platforms/pseries/eeh_pseries.c
index 823cb27efa8b..b4f77bc5f8bf 100644
--- a/arch/powerpc/platforms/pseries/eeh_pseries.c
+++ b/arch/powerpc/platforms/pseries/eeh_pseries.c
@@ -65,6 +65,8 @@ void pseries_pcibios_bus_add_device(struct pci_dev *pdev)
 	if (!pdev->is_virtfn)
 		return;
 
+	pr_debug("%s: EEH: Setting up device %s.\n", __func__, pci_name(pdev));
+
 	pdn->device_id  =  pdev->device;
 	pdn->vendor_id  =  pdev->vendor;
 	pdn->class_code =  pdev->class;
@@ -251,6 +253,10 @@ static void *pseries_eeh_probe(struct pci_dn *pdn, void *data)
 	int enable = 0;
 	int ret;
 
+	pr_debug("%s: probing %04x:%02x:%02x.%01x\n",
+		__func__, pdn->phb->global_number, pdn->busno,
+		PCI_SLOT(pdn->devfn), PCI_FUNC(pdn->devfn));
+
 	/* Retrieve OF node and eeh device */
 	edev = pdn_to_eeh_dev(pdn);
 	if (!edev || edev->pe)
@@ -294,7 +300,12 @@ static void *pseries_eeh_probe(struct pci_dn *pdn, void *data)
 
 	/* Enable EEH on the device */
 	ret = eeh_ops->set_option(&pe, EEH_OPT_ENABLE);
-	if (!ret) {
+	if (ret) {
+		pr_debug("%s: EEH failed to enable on %02x:%02x.%01x PHB#%x-PE#%x (code %d)\n",
+			__func__, pdn->busno, PCI_SLOT(pdn->devfn),
+			PCI_FUNC(pdn->devfn), pe.phb->global_number,
+			pe.addr, ret);
+	} else {
 		/* Retrieve PE address */
 		edev->pe_config_addr = eeh_ops->get_pe_addr(&pe);
 		pe.addr = edev->pe_config_addr;
@@ -310,11 +321,6 @@ static void *pseries_eeh_probe(struct pci_dn *pdn, void *data)
 		if (enable) {
 			eeh_add_flag(EEH_ENABLED);
 			eeh_add_to_parent_pe(edev);
-
-			pr_debug("%s: EEH enabled on %02x:%02x.%01x PHB#%x-PE#%x\n",
-				__func__, pdn->busno, PCI_SLOT(pdn->devfn),
-				PCI_FUNC(pdn->devfn), pe.phb->global_number,
-				pe.addr);
 		} else if (pdn->parent && pdn_to_eeh_dev(pdn->parent) &&
 			   (pdn_to_eeh_dev(pdn->parent))->pe) {
 			/* This device doesn't support EEH, but it may have an
@@ -323,6 +329,11 @@ static void *pseries_eeh_probe(struct pci_dn *pdn, void *data)
 			edev->pe_config_addr = pdn_to_eeh_dev(pdn->parent)->pe_config_addr;
 			eeh_add_to_parent_pe(edev);
 		}
+		pr_debug("%s: EEH %s on %02x:%02x.%01x PHB#%x-PE#%x (code %d)\n",
+			__func__, (enable ? "enabled" : "unsupported"),
+			pdn->busno, PCI_SLOT(pdn->devfn),
+			PCI_FUNC(pdn->devfn), pe.phb->global_number,
+			pe.addr, ret);
 	}
 
 	/* Save memory bars */
-- 
2.35.1



