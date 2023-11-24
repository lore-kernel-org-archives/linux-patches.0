Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4B233090;
	Fri, 24 Nov 2023 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUDSzS9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9574C433C7;
	Fri, 24 Nov 2023 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850916;
	bh=z5yMem1OzlVwnegxkC6RVuewZFAvnzPwBV1tEVoSeXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUDSzS9jwBYPBw8rwi7BD6GVFSBFPnuAuCWJqX6nQxGlWwSb+wOhB50+beUt7uJVK
	 37YYrKAVRrVXfq+j2ulFYMnUCAlDcjBzVm/bCF486+OQ+g5iFRvAwR1QYPw0Dw9VC9
	 nD8+wFJxkFiomctYgleeR4Sau9+rJiTzA9XoayNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iain Lane <iain@orangesquash.org.uk>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.5 239/491] x86/PCI: Avoid PME from D3hot/D3cold for AMD Rembrandt and Phoenix USB4
Date: Fri, 24 Nov 2023 17:47:55 +0000
Message-ID: <20231124172031.740180520@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 7d08f21f8c6307cb05cabb8d86e90ff6ccba57e9 upstream.

Iain reports that USB devices can't be used to wake a Lenovo Z13 from
suspend.  This occurs because on some AMD platforms, even though the Root
Ports advertise PME_Support for D3hot and D3cold, wakeup events from
devices on a USB4 controller don't result in wakeup interrupts from the
Root Port when amd-pmc has put the platform in a hardware sleep state.

If amd-pmc will be involved in the suspend, remove D3hot and D3cold from
the PME_Support mask of Root Ports above USB4 controllers so we avoid those
states if we need wakeups.

Restore D3 support at resume so that it can be used by runtime suspend.

This affects both AMD Rembrandt and Phoenix SoCs.

"pm_suspend_target_state == PM_SUSPEND_ON" means we're doing runtime
suspend, and amd-pmc will not be involved.  In that case PMEs work as
advertised in D3hot/D3cold, so we don't need to do anything.

Note that amd-pmc is technically optional, and there's no need for this
quirk if it's not present, but we assume it's always present because power
consumption is so high without it.

Fixes: 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend")
Link: https://lore.kernel.org/r/20231004144959.158840-1-mario.limonciello@amd.com
Reported-by: Iain Lane <iain@orangesquash.org.uk>
Closes: https://forums.lenovo.com/t5/Ubuntu/Z13-can-t-resume-from-suspend-with-external-USB-keyboard/m-p/5217121
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[bhelgaas: commit log, move to arch/x86/pci/fixup.c, add #includes]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/pci/fixup.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -3,9 +3,11 @@
  * Exceptions for specific devices. Usually work-arounds for fatal design flaws.
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/pci.h>
+#include <linux/suspend.h>
 #include <linux/vgaarb.h>
 #include <asm/amd_nb.h>
 #include <asm/hpet.h>
@@ -904,3 +906,60 @@ static void chromeos_fixup_apl_pci_l1ss_
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x5ad6, chromeos_save_apl_pci_l1ss_capability);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL, 0x5ad6, chromeos_fixup_apl_pci_l1ss_capability);
+
+#ifdef CONFIG_SUSPEND
+/*
+ * Root Ports on some AMD SoCs advertise PME_Support for D3hot and D3cold, but
+ * if the SoC is put into a hardware sleep state by the amd-pmc driver, the
+ * Root Ports don't generate wakeup interrupts for USB devices.
+ *
+ * When suspending, remove D3hot and D3cold from the PME_Support advertised
+ * by the Root Port so we don't use those states if we're expecting wakeup
+ * interrupts.  Restore the advertised PME_Support when resuming.
+ */
+static void amd_rp_pme_suspend(struct pci_dev *dev)
+{
+	struct pci_dev *rp;
+
+	/*
+	 * PM_SUSPEND_ON means we're doing runtime suspend, which means
+	 * amd-pmc will not be involved so PMEs during D3 work as advertised.
+	 *
+	 * The PMEs *do* work if amd-pmc doesn't put the SoC in the hardware
+	 * sleep state, but we assume amd-pmc is always present.
+	 */
+	if (pm_suspend_target_state == PM_SUSPEND_ON)
+		return;
+
+	rp = pcie_find_root_port(dev);
+	if (!rp->pm_cap)
+		return;
+
+	rp->pme_support &= ~((PCI_PM_CAP_PME_D3hot|PCI_PM_CAP_PME_D3cold) >>
+				    PCI_PM_CAP_PME_SHIFT);
+	dev_info_once(&rp->dev, "quirk: disabling D3cold for suspend\n");
+}
+
+static void amd_rp_pme_resume(struct pci_dev *dev)
+{
+	struct pci_dev *rp;
+	u16 pmc;
+
+	rp = pcie_find_root_port(dev);
+	if (!rp->pm_cap)
+		return;
+
+	pci_read_config_word(rp, rp->pm_cap + PCI_PM_PMC, &pmc);
+	rp->pme_support = FIELD_GET(PCI_PM_CAP_PME_MASK, pmc);
+}
+/* Rembrandt (yellow_carp) */
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x162e, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x162e, amd_rp_pme_resume);
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x162f, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x162f, amd_rp_pme_resume);
+/* Phoenix (pink_sardine) */
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_resume);
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_resume);
+#endif /* CONFIG_SUSPEND */


