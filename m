Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5791B2E264E;
	Tue, 17 Jun 2025 16:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178588; cv=none; b=Bp6CVy6/goFT25lsZjoHiotlB4xSaelEu5Q+54bmtIi9JYatfMH7aN4Nn81WtOspUJFpmGEWspDK1SmMZ1j9Rw/WgU8clsq03GWShXDl64ZJJnCXhPHKzxHDEu4zuNxldaWApxyJ2dY9NOkc4rXOFHZbT28t8urgYMaNYAO/CO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178588; c=relaxed/simple;
	bh=Xllw8cHwrt8xUjOI3Dcnu6Jejf8midajAwf012aMnfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1Pd3iu+g8JFgpWZNgQJWpo1alyS+pPHv+lPmtUNHmn5qScZwVfftJZFov3R9J5RzArRuD+cXRBATqSk95c1rnvTRke4EpJcTqKsVKAP19DhDWRzaBsDagAhruFlKvvTTHjPK3f8zX6WbekpZXV57MiT/VHKIBauRtCDiLA0i6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjWPVVCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjWPVVCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CB2C4CEE3;
	Tue, 17 Jun 2025 16:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178588;
	bh=Xllw8cHwrt8xUjOI3Dcnu6Jejf8midajAwf012aMnfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjWPVVCls3W+PwyzgnqM3FYGrNUk7jpetWZX9HKDxmpjp0cavb0QxpPtkNRfabC4Y
	 sRitLxWxsfzh8CXdw9ww9ipbPFBsBI0KRGO11dP5eGIPT6UF8Gci0zf2CWuvJTXWHW
	 ordHPUDcVxo1yK+THcJ1mxhfmX+uYE3In2lSigSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 493/780] PCI: pciehp: Ignore Presence Detect Changed caused by DPC
Date: Tue, 17 Jun 2025 17:23:21 +0200
Message-ID: <20250617152511.563322946@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit c3be50f7547ccb533284b22f74baf37d3379843e ]

Commit a97396c6eb13 ("PCI: pciehp: Ignore Link Down/Up caused by DPC")
amended PCIe hotplug to not bring down the slot upon Data Link Layer State
Changed events caused by Downstream Port Containment.

However Keith reports off-list that if the slot uses in-band presence
detect (i.e. Presence Detect State is derived from Data Link Layer Link
Active), DPC also causes a spurious Presence Detect Changed event.

This needs to be ignored as well.

Unfortunately there's no register indicating that in-band presence detect
is used.  PCIe r5.0 sec 7.5.3.10 introduced the In-Band PD Disable bit in
the Slot Control Register.  The PCIe hotplug driver sets this bit on
ports supporting it.  But older ports may still use in-band presence
detect.

If in-band presence detect can be disabled, Presence Detect Changed events
occurring during DPC must not be ignored because they signal device
replacement.  On all other ports, device replacement cannot be detected
reliably because the Presence Detect Changed event could be a side effect
of DPC.  On those (older) ports, perform a best-effort device replacement
check by comparing the Vendor ID, Device ID and other data in Config Space
with the values cached in struct pci_dev.  Use the existing helper
pciehp_device_replaced() to accomplish this.  It is currently #ifdef'ed to
CONFIG_PM_SLEEP in pciehp_core.c, so move it to pciehp_hpc.c where most
other functions accessing config space reside.

Reported-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/fa264ff71952915c4e35a53c89eb0cde8455a5c5.1744298239.git.lukas@wunner.de
Stable-dep-of: 2af781a9edc4 ("PCI: pciehp: Ignore Link Down/Up caused by Secondary Bus Reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp.h      |  1 +
 drivers/pci/hotplug/pciehp_core.c | 29 ------------------
 drivers/pci/hotplug/pciehp_hpc.c  | 49 ++++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 273dd8c66f4ef..debc79b0adfb2 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -187,6 +187,7 @@ int pciehp_card_present(struct controller *ctrl);
 int pciehp_card_present_or_link_active(struct controller *ctrl);
 int pciehp_check_link_status(struct controller *ctrl);
 int pciehp_check_link_active(struct controller *ctrl);
+bool pciehp_device_replaced(struct controller *ctrl);
 void pciehp_release_ctrl(struct controller *ctrl);
 
 int pciehp_sysfs_enable_slot(struct hotplug_slot *hotplug_slot);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 997841c698935..f59baa9129709 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -284,35 +284,6 @@ static int pciehp_suspend(struct pcie_device *dev)
 	return 0;
 }
 
-static bool pciehp_device_replaced(struct controller *ctrl)
-{
-	struct pci_dev *pdev __free(pci_dev_put) = NULL;
-	u32 reg;
-
-	if (pci_dev_is_disconnected(ctrl->pcie->port))
-		return false;
-
-	pdev = pci_get_slot(ctrl->pcie->port->subordinate, PCI_DEVFN(0, 0));
-	if (!pdev)
-		return true;
-
-	if (pci_read_config_dword(pdev, PCI_VENDOR_ID, &reg) ||
-	    reg != (pdev->vendor | (pdev->device << 16)) ||
-	    pci_read_config_dword(pdev, PCI_CLASS_REVISION, &reg) ||
-	    reg != (pdev->revision | (pdev->class << 8)))
-		return true;
-
-	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
-	    (pci_read_config_dword(pdev, PCI_SUBSYSTEM_VENDOR_ID, &reg) ||
-	     reg != (pdev->subsystem_vendor | (pdev->subsystem_device << 16))))
-		return true;
-
-	if (pci_get_dsn(pdev) != ctrl->dsn)
-		return true;
-
-	return false;
-}
-
 static int pciehp_resume_noirq(struct pcie_device *dev)
 {
 	struct controller *ctrl = get_service_data(dev);
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 8a09fb6083e27..388fbed25402b 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -563,18 +563,48 @@ void pciehp_power_off_slot(struct controller *ctrl)
 		 PCI_EXP_SLTCTL_PWR_OFF);
 }
 
+bool pciehp_device_replaced(struct controller *ctrl)
+{
+	struct pci_dev *pdev __free(pci_dev_put) = NULL;
+	u32 reg;
+
+	if (pci_dev_is_disconnected(ctrl->pcie->port))
+		return false;
+
+	pdev = pci_get_slot(ctrl->pcie->port->subordinate, PCI_DEVFN(0, 0));
+	if (!pdev)
+		return true;
+
+	if (pci_read_config_dword(pdev, PCI_VENDOR_ID, &reg) ||
+	    reg != (pdev->vendor | (pdev->device << 16)) ||
+	    pci_read_config_dword(pdev, PCI_CLASS_REVISION, &reg) ||
+	    reg != (pdev->revision | (pdev->class << 8)))
+		return true;
+
+	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
+	    (pci_read_config_dword(pdev, PCI_SUBSYSTEM_VENDOR_ID, &reg) ||
+	     reg != (pdev->subsystem_vendor | (pdev->subsystem_device << 16))))
+		return true;
+
+	if (pci_get_dsn(pdev) != ctrl->dsn)
+		return true;
+
+	return false;
+}
+
 static void pciehp_ignore_dpc_link_change(struct controller *ctrl,
-					  struct pci_dev *pdev, int irq)
+					  struct pci_dev *pdev, int irq,
+					  u16 ignored_events)
 {
 	/*
 	 * Ignore link changes which occurred while waiting for DPC recovery.
 	 * Could be several if DPC triggered multiple times consecutively.
 	 */
 	synchronize_hardirq(irq);
-	atomic_and(~PCI_EXP_SLTSTA_DLLSC, &ctrl->pending_events);
+	atomic_and(~ignored_events, &ctrl->pending_events);
 	if (pciehp_poll_mode)
 		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
-					   PCI_EXP_SLTSTA_DLLSC);
+					   ignored_events);
 	ctrl_info(ctrl, "Slot(%s): Link Down/Up ignored (recovered by DPC)\n",
 		  slot_name(ctrl));
 
@@ -584,8 +614,8 @@ static void pciehp_ignore_dpc_link_change(struct controller *ctrl,
 	 * Synthesize it to ensure that it is acted on.
 	 */
 	down_read_nested(&ctrl->reset_lock, ctrl->depth);
-	if (!pciehp_check_link_active(ctrl))
-		pciehp_request(ctrl, PCI_EXP_SLTSTA_DLLSC);
+	if (!pciehp_check_link_active(ctrl) || pciehp_device_replaced(ctrl))
+		pciehp_request(ctrl, ignored_events);
 	up_read(&ctrl->reset_lock);
 }
 
@@ -736,8 +766,13 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 	 */
 	if ((events & PCI_EXP_SLTSTA_DLLSC) && pci_dpc_recovered(pdev) &&
 	    ctrl->state == ON_STATE) {
-		events &= ~PCI_EXP_SLTSTA_DLLSC;
-		pciehp_ignore_dpc_link_change(ctrl, pdev, irq);
+		u16 ignored_events = PCI_EXP_SLTSTA_DLLSC;
+
+		if (!ctrl->inband_presence_disabled)
+			ignored_events |= events & PCI_EXP_SLTSTA_PDC;
+
+		events &= ~ignored_events;
+		pciehp_ignore_dpc_link_change(ctrl, pdev, irq, ignored_events);
 	}
 
 	/*
-- 
2.39.5



