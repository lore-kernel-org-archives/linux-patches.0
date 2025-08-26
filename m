Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88852BE058;
	Tue, 26 Aug 2025 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217487; cv=none; b=Eimlcr2ziwJ+4Hmg2Dl0TZacNCr1tUL/Hbyevrq3/bOCsIs7LVMa3Bx0XIhPYqGTHD1WZqBfiQnf3C8Yhio0G2eE7r4TFWacF5B7lsNMbyyHQ53ATZYs37oIO4h89GpfDUN+dSnh+SbObyD87ejIAeb3mrkrItJbnefUt+Wdup4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217487; c=relaxed/simple;
	bh=pHj8EupmXHWfTn9zZNU5ynGR4WU/HVjSw4dApN0QOPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuIfQbPjugY+zGgPu3p8Wy/w/IWPPWB2d0mxf9Yz0FBK/eSW549bs0DPwrIeAQeH1LPeh9BrkBGfpH2+TcL/JvDX5nG0h782wwHKqpaDN6aEWYOb/i7kfp8klBjX80HARJwdpIbOCWKuywfr9XF1HSQ+k/3JL0hSdqC4und8XSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4rMXUiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4rMXUiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C49C4CEF1;
	Tue, 26 Aug 2025 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217487;
	bh=pHj8EupmXHWfTn9zZNU5ynGR4WU/HVjSw4dApN0QOPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4rMXUiNpYsnLWMJiIM7IDnNGKzXkMpQFRYZ0U77jZH81fN8UkoN7lPZPkEw1KCa5
	 P3C/GdefK9N6QriDGKBC1Mpo9Vipv+zSrl6CllcCjHTcBsWtLxf7MKHDb59uNeEhAM
	 VT0W+Bi2z4W45ZMeUOmSS0PYgGGv6ds2/fsUDVkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Anastasio <sanastasio@raptorengineering.com>,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/523] PCI: pnv_php: Clean up allocated IRQs on unplug
Date: Tue, 26 Aug 2025 13:06:11 +0200
Message-ID: <20250826110928.445001809@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit 4668619092554e1b95c9a5ac2941ca47ba6d548a ]

When the root of a nested PCIe bridge configuration is unplugged, the
pnv_php driver leaked the allocated IRQ resources for the child bridges'
hotplug event notifications, resulting in a panic.

Fix this by walking all child buses and deallocating all its IRQ resources
before calling pci_hp_remove_devices().

Also modify the lifetime of the workqueue at struct pnv_php_slot::wq so
that it is only destroyed in pnv_php_free_slot(), instead of
pnv_php_disable_irq(). This is required since pnv_php_disable_irq() will
now be called by workers triggered by hot unplug interrupts, so the
workqueue needs to stay allocated.

The abridged kernel panic that occurs without this patch is as follows:

  WARNING: CPU: 0 PID: 687 at kernel/irq/msi.c:292 msi_device_data_release+0x6c/0x9c
  CPU: 0 UID: 0 PID: 687 Comm: bash Not tainted 6.14.0-rc5+ #2
  Call Trace:
   msi_device_data_release+0x34/0x9c (unreliable)
   release_nodes+0x64/0x13c
   devres_release_all+0xc0/0x140
   device_del+0x2d4/0x46c
   pci_destroy_dev+0x5c/0x194
   pci_hp_remove_devices+0x90/0x128
   pci_hp_remove_devices+0x44/0x128
   pnv_php_disable_slot+0x54/0xd4
   power_write_file+0xf8/0x18c
   pci_slot_attr_store+0x40/0x5c
   sysfs_kf_write+0x64/0x78
   kernfs_fop_write_iter+0x1b0/0x290
   vfs_write+0x3bc/0x50c
   ksys_write+0x84/0x140
   system_call_exception+0x124/0x230
   system_call_vectored_common+0x15c/0x2ec

Signed-off-by: Shawn Anastasio <sanastasio@raptorengineering.com>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
[bhelgaas: tidy comments]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/2013845045.1359852.1752615367790.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c | 96 ++++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index cf9c0e75f0be..1ccd8a8e7c71 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -3,6 +3,7 @@
  * PCI Hotplug Driver for PowerPC PowerNV platform.
  *
  * Copyright Gavin Shan, IBM Corporation 2016.
+ * Copyright (C) 2025 Raptor Engineering, LLC
  */
 
 #include <linux/libfdt.h>
@@ -34,8 +35,10 @@ static void pnv_php_register(struct device_node *dn);
 static void pnv_php_unregister_one(struct device_node *dn);
 static void pnv_php_unregister(struct device_node *dn);
 
+static void pnv_php_enable_irq(struct pnv_php_slot *php_slot);
+
 static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
-				bool disable_device)
+				bool disable_device, bool disable_msi)
 {
 	struct pci_dev *pdev = php_slot->pdev;
 	u16 ctrl;
@@ -51,19 +54,15 @@ static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
 		php_slot->irq = 0;
 	}
 
-	if (php_slot->wq) {
-		destroy_workqueue(php_slot->wq);
-		php_slot->wq = NULL;
-	}
-
-	if (disable_device) {
+	if (disable_device || disable_msi) {
 		if (pdev->msix_enabled)
 			pci_disable_msix(pdev);
 		else if (pdev->msi_enabled)
 			pci_disable_msi(pdev);
+	}
 
+	if (disable_device)
 		pci_disable_device(pdev);
-	}
 }
 
 static void pnv_php_free_slot(struct kref *kref)
@@ -72,7 +71,8 @@ static void pnv_php_free_slot(struct kref *kref)
 					struct pnv_php_slot, kref);
 
 	WARN_ON(!list_empty(&php_slot->children));
-	pnv_php_disable_irq(php_slot, false);
+	pnv_php_disable_irq(php_slot, false, false);
+	destroy_workqueue(php_slot->wq);
 	kfree(php_slot->name);
 	kfree(php_slot);
 }
@@ -559,8 +559,58 @@ static int pnv_php_reset_slot(struct hotplug_slot *slot, int probe)
 static int pnv_php_enable_slot(struct hotplug_slot *slot)
 {
 	struct pnv_php_slot *php_slot = to_pnv_php_slot(slot);
+	u32 prop32;
+	int ret;
+
+	ret = pnv_php_enable(php_slot, true);
+	if (ret)
+		return ret;
+
+	/* (Re-)enable interrupt if the slot supports surprise hotplug */
+	ret = of_property_read_u32(php_slot->dn, "ibm,slot-surprise-pluggable",
+				   &prop32);
+	if (!ret && prop32)
+		pnv_php_enable_irq(php_slot);
 
-	return pnv_php_enable(php_slot, true);
+	return 0;
+}
+
+/*
+ * Disable any hotplug interrupts for all slots on the provided bus, as well as
+ * all downstream slots in preparation for a hot unplug.
+ */
+static int pnv_php_disable_all_irqs(struct pci_bus *bus)
+{
+	struct pci_bus *child_bus;
+	struct pci_slot *slot;
+
+	/* First go down child buses */
+	list_for_each_entry(child_bus, &bus->children, node)
+		pnv_php_disable_all_irqs(child_bus);
+
+	/* Disable IRQs for all pnv_php slots on this bus */
+	list_for_each_entry(slot, &bus->slots, list) {
+		struct pnv_php_slot *php_slot = to_pnv_php_slot(slot->hotplug);
+
+		pnv_php_disable_irq(php_slot, false, true);
+	}
+
+	return 0;
+}
+
+/*
+ * Disable any hotplug interrupts for all downstream slots on the provided
+ * bus in preparation for a hot unplug.
+ */
+static int pnv_php_disable_all_downstream_irqs(struct pci_bus *bus)
+{
+	struct pci_bus *child_bus;
+
+	/* Go down child buses, recursively deactivating their IRQs */
+	list_for_each_entry(child_bus, &bus->children, node)
+		pnv_php_disable_all_irqs(child_bus);
+
+	return 0;
 }
 
 static int pnv_php_disable_slot(struct hotplug_slot *slot)
@@ -577,6 +627,13 @@ static int pnv_php_disable_slot(struct hotplug_slot *slot)
 	    php_slot->state != PNV_PHP_STATE_REGISTERED)
 		return 0;
 
+	/*
+	 * Free all IRQ resources from all child slots before remove.
+	 * Note that we do not disable the root slot IRQ here as that
+	 * would also deactivate the slot hot (re)plug interrupt!
+	 */
+	pnv_php_disable_all_downstream_irqs(php_slot->bus);
+
 	/* Remove all devices behind the slot */
 	pci_lock_rescan_remove();
 	pci_hp_remove_devices(php_slot->bus);
@@ -645,6 +702,15 @@ static struct pnv_php_slot *pnv_php_alloc_slot(struct device_node *dn)
 		return NULL;
 	}
 
+	/* Allocate workqueue for this slot's interrupt handling */
+	php_slot->wq = alloc_workqueue("pciehp-%s", 0, 0, php_slot->name);
+	if (!php_slot->wq) {
+		SLOT_WARN(php_slot, "Cannot alloc workqueue\n");
+		kfree(php_slot->name);
+		kfree(php_slot);
+		return NULL;
+	}
+
 	if (dn->child && PCI_DN(dn->child))
 		php_slot->slot_no = PCI_SLOT(PCI_DN(dn->child)->devfn);
 	else
@@ -841,14 +907,6 @@ static void pnv_php_init_irq(struct pnv_php_slot *php_slot, int irq)
 	u16 sts, ctrl;
 	int ret;
 
-	/* Allocate workqueue */
-	php_slot->wq = alloc_workqueue("pciehp-%s", 0, 0, php_slot->name);
-	if (!php_slot->wq) {
-		SLOT_WARN(php_slot, "Cannot alloc workqueue\n");
-		pnv_php_disable_irq(php_slot, true);
-		return;
-	}
-
 	/* Check PDC (Presence Detection Change) is broken or not */
 	ret = of_property_read_u32(php_slot->dn, "ibm,slot-broken-pdc",
 				   &broken_pdc);
@@ -867,7 +925,7 @@ static void pnv_php_init_irq(struct pnv_php_slot *php_slot, int irq)
 	ret = request_irq(irq, pnv_php_interrupt, IRQF_SHARED,
 			  php_slot->name, php_slot);
 	if (ret) {
-		pnv_php_disable_irq(php_slot, true);
+		pnv_php_disable_irq(php_slot, true, true);
 		SLOT_WARN(php_slot, "Error %d enabling IRQ %d\n", ret, irq);
 		return;
 	}
-- 
2.39.5



