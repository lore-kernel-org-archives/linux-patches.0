Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2935083A;
	Tue, 26 Aug 2025 14:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217609; cv=none; b=Vraqoo6x63v8PCkRb0sqB6fJS+DTfHO1milctgFwnXtbn6rppI7Bf6IwthHX0ubOodpxGQdpoh/J2EujWP+Y6F1N+5LbYcHU3fd+ipc8dVpMvWrCuFWaaq+TMzi0FIKiQVsuEFsuCYXczCtqnB2232lmnVgWV67tiEz0YHu2Hjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217609; c=relaxed/simple;
	bh=iLkbSHu866m4mvAOCnvvwvGKzubsubsSAnTgzo4NHyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8u6vGn2aWh490z1Q55JRyAJko18E4Xtr8thmjCpSEUwHeQutIOuSLpnfzepJRcYzQH1RphmCSlynih9+k8a2pL6PejKp3CVh3O9Y09t1e5AKRBrkFg6NqA7ODRFwpVu0DgIyVPEUfC6EqxH7/fGd6QdznTK5XPsUWZV3A1ITqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeTua7he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeTua7he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2775C4CEF1;
	Tue, 26 Aug 2025 14:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217609;
	bh=iLkbSHu866m4mvAOCnvvwvGKzubsubsSAnTgzo4NHyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeTua7he08WQByvOa5giEdvPcBlYJYnz0SGlcXRcnGqbmNuQhVR7z1R+LemghiMTk
	 ANk2w5Odxwi1cW2gkknrEGfzwq1hPIy0kLGi8tJ8KMzPJnaW81S0DpdA2KXLNXlLDN
	 NouZZLWcP5vlW4Mg0KyKWnvYSCCoS0jEPaR3rxmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/523] PCI: pnv_php: Fix surprise plug detection and recovery
Date: Tue, 26 Aug 2025 13:06:16 +0200
Message-ID: <20250826110928.563787453@linuxfoundation.org>
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

[ Upstream commit a2a2a6fc2469524caa713036297c542746d148dc ]

The existing PowerNV hotplug code did not handle surprise plug events
correctly, leading to a complete failure of the hotplug system after device
removal and a required reboot to detect new devices.

This comes down to two issues:

 1) When a device is surprise removed, often the bridge upstream
    port will cause a PE freeze on the PHB.  If this freeze is not
    cleared, the MSI interrupts from the bridge hotplug notification
    logic will not be received by the kernel, stalling all plug events
    on all slots associated with the PE.

 2) When a device is removed from a slot, regardless of surprise or
    programmatic removal, the associated PHB/PE ls left frozen.
    If this freeze is not cleared via a fundamental reset, skiboot
    is unable to clear the freeze and cannot retrain / rescan the
    slot.  This also requires a reboot to clear the freeze and redetect
    the device in the slot.

Issue the appropriate unfreeze and rescan commands on hotplug events,
and don't oops on hotplug if pci_bus_to_OF_node() returns NULL.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
[bhelgaas: tidy comments]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/171044224.1359864.1752615546988.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/pci-hotplug.c |   3 +
 drivers/pci/hotplug/pnv_php.c     | 110 +++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/pci-hotplug.c b/arch/powerpc/kernel/pci-hotplug.c
index 2fc12198ec07..62de678f9f50 100644
--- a/arch/powerpc/kernel/pci-hotplug.c
+++ b/arch/powerpc/kernel/pci-hotplug.c
@@ -110,6 +110,9 @@ void pci_hp_add_devices(struct pci_bus *bus)
 	struct pci_controller *phb;
 	struct device_node *dn = pci_bus_to_OF_node(bus);
 
+	if (!dn)
+		return;
+
 	phb = pci_bus_to_host(bus);
 
 	mode = PCI_PROBE_NORMAL;
diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index 7fa92cb51451..03c4d0d7f9b1 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -4,11 +4,13 @@
  *
  * Copyright Gavin Shan, IBM Corporation 2016.
  * Copyright (C) 2025 Raptor Engineering, LLC
+ * Copyright (C) 2025 Raptor Computing Systems, LLC
  */
 
 #include <linux/libfdt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <linux/pci_hotplug.h>
 
 #include <asm/opal.h>
@@ -467,6 +469,61 @@ static int pnv_php_set_attention_state(struct hotplug_slot *slot, u8 state)
 	return 0;
 }
 
+static int pnv_php_activate_slot(struct pnv_php_slot *php_slot,
+				 struct hotplug_slot *slot)
+{
+	int ret, i;
+
+	/*
+	 * Issue initial slot activation command to firmware
+	 *
+	 * Firmware will power slot on, attempt to train the link, and
+	 * discover any downstream devices. If this process fails, firmware
+	 * will return an error code and an invalid device tree. Failure
+	 * can be caused for multiple reasons, including a faulty
+	 * downstream device, poor connection to the downstream device, or
+	 * a previously latched PHB fence.  On failure, issue fundamental
+	 * reset up to three times before aborting.
+	 */
+	ret = pnv_php_set_slot_power_state(slot, OPAL_PCI_SLOT_POWER_ON);
+	if (ret) {
+		SLOT_WARN(
+			php_slot,
+			"PCI slot activation failed with error code %d, possible frozen PHB",
+			ret);
+		SLOT_WARN(
+			php_slot,
+			"Attempting complete PHB reset before retrying slot activation\n");
+		for (i = 0; i < 3; i++) {
+			/*
+			 * Slot activation failed, PHB may be fenced from a
+			 * prior device failure.
+			 *
+			 * Use the OPAL fundamental reset call to both try a
+			 * device reset and clear any potentially active PHB
+			 * fence / freeze.
+			 */
+			SLOT_WARN(php_slot, "Try %d...\n", i + 1);
+			pci_set_pcie_reset_state(php_slot->pdev,
+						 pcie_warm_reset);
+			msleep(250);
+			pci_set_pcie_reset_state(php_slot->pdev,
+						 pcie_deassert_reset);
+
+			ret = pnv_php_set_slot_power_state(
+				slot, OPAL_PCI_SLOT_POWER_ON);
+			if (!ret)
+				break;
+		}
+
+		if (i >= 3)
+			SLOT_WARN(php_slot,
+				  "Failed to bring slot online, aborting!\n");
+	}
+
+	return ret;
+}
+
 static int pnv_php_enable(struct pnv_php_slot *php_slot, bool rescan)
 {
 	struct hotplug_slot *slot = &php_slot->slot;
@@ -529,7 +586,7 @@ static int pnv_php_enable(struct pnv_php_slot *php_slot, bool rescan)
 		goto scan;
 
 	/* Power is off, turn it on and then scan the slot */
-	ret = pnv_php_set_slot_power_state(slot, OPAL_PCI_SLOT_POWER_ON);
+	ret = pnv_php_activate_slot(php_slot, slot);
 	if (ret)
 		return ret;
 
@@ -836,16 +893,63 @@ static int pnv_php_enable_msix(struct pnv_php_slot *php_slot)
 	return entry.vector;
 }
 
+static void
+pnv_php_detect_clear_suprise_removal_freeze(struct pnv_php_slot *php_slot)
+{
+	struct pci_dev *pdev = php_slot->pdev;
+	struct eeh_dev *edev;
+	struct eeh_pe *pe;
+	int i, rc;
+
+	/*
+	 * When a device is surprise removed from a downstream bridge slot,
+	 * the upstream bridge port can still end up frozen due to related EEH
+	 * events, which will in turn block the MSI interrupts for slot hotplug
+	 * detection.
+	 *
+	 * Detect and thaw any frozen upstream PE after slot deactivation.
+	 */
+	edev = pci_dev_to_eeh_dev(pdev);
+	pe = edev ? edev->pe : NULL;
+	rc = eeh_pe_get_state(pe);
+	if ((rc == -ENODEV) || (rc == -ENOENT)) {
+		SLOT_WARN(
+			php_slot,
+			"Upstream bridge PE state unknown, hotplug detect may fail\n");
+	} else {
+		if (pe->state & EEH_PE_ISOLATED) {
+			SLOT_WARN(
+				php_slot,
+				"Upstream bridge PE %02x frozen, thawing...\n",
+				pe->addr);
+			for (i = 0; i < 3; i++)
+				if (!eeh_unfreeze_pe(pe))
+					break;
+			if (i >= 3)
+				SLOT_WARN(
+					php_slot,
+					"Unable to thaw PE %02x, hotplug detect will fail!\n",
+					pe->addr);
+			else
+				SLOT_WARN(php_slot,
+					  "PE %02x thawed successfully\n",
+					  pe->addr);
+		}
+	}
+}
+
 static void pnv_php_event_handler(struct work_struct *work)
 {
 	struct pnv_php_event *event =
 		container_of(work, struct pnv_php_event, work);
 	struct pnv_php_slot *php_slot = event->php_slot;
 
-	if (event->added)
+	if (event->added) {
 		pnv_php_enable_slot(&php_slot->slot);
-	else
+	} else {
 		pnv_php_disable_slot(&php_slot->slot);
+		pnv_php_detect_clear_suprise_removal_freeze(php_slot);
+	}
 
 	kfree(event);
 }
-- 
2.39.5



