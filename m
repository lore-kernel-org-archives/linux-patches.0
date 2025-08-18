Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227822AE7A;
	Mon, 18 Aug 2025 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524751; cv=none; b=BX+G9V0238RdZTFRRf7legUx8+5j5E51h2ZAZp9ARmKRe/gtH+JXdt4yJXjW2eufi85Iko5gvoiB1UKUs2x3mOUI6/q0I0dSMD/0+6nLoKmO7MccfJG8M7ZCx3bkerz8ERwr2rR8MVsUvC6Yn9vCeLu2O33b5xXMI+KM7tbiBoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524751; c=relaxed/simple;
	bh=8g1OVVR0C1f6/ZHhlk+gdo0vpvdFIsm4rNxDb3YVzJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piQw2axeE76sLhC2GtoLIDAkCPYuON6He7J7fvfOWMKmZTvAicwBAs8apKzuddmmAE81oQdRVg1vlzks9RzS/PrvY2Ndv6MUh3ygHJuFYjoqo618Qp4mI/Pv0o7jwofDzHP2STZmvAPisimB9bkbfZySLpl+PxGJoOxucnQCEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTSlqcuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTSlqcuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFCFC4CEEB;
	Mon, 18 Aug 2025 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524751;
	bh=8g1OVVR0C1f6/ZHhlk+gdo0vpvdFIsm4rNxDb3YVzJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTSlqcuoOl2eqDYR0CYPYxkfUIRHiocPH7Kszhhmpa/P82ZCACd3Z63ImfzCNJWJZ
	 pc3eaUH4bRAvVOQc7uhdgRPeH8h3ka+jXCnGqLQ96p7FU00iTra8Knp8JZVrZJcBYf
	 XkXanzWZ9/UU3Yfh8SUJjpNv5+y/HwSMg7TYP4MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Bigonville <bigon@bigon.be>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH 6.16 051/570] PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports
Date: Mon, 18 Aug 2025 14:40:38 +0200
Message-ID: <20250818124507.780392277@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 6cff20ce3b92ffbf2fc5eb9e5a030b3672aa414a upstream.

pci_bridge_d3_possible() is called from both pcie_portdrv_probe() and
pcie_portdrv_remove() to determine whether runtime power management shall
be enabled (on probe) or disabled (on remove) on a PCIe port.

The underlying assumption is that pci_bridge_d3_possible() always returns
the same value, else a runtime PM reference imbalance would occur.  That
assumption is not given if the PCIe port is inaccessible on remove due to
hot-unplug:  pci_bridge_d3_possible() calls pciehp_is_native(), which
accesses Config Space to determine whether the port is Hot-Plug Capable.
An inaccessible port returns "all ones", which is converted to "all
zeroes" by pcie_capability_read_dword().  Hence the port no longer seems
Hot-Plug Capable on remove even though it was on probe.

The resulting runtime PM ref imbalance causes warning messages such as:

  pcieport 0000:02:04.0: Runtime PM usage count underflow!

Avoid the Config Space access (and thus the runtime PM ref imbalance) by
caching the Hot-Plug Capable bit in struct pci_dev.

The struct already contains an "is_hotplug_bridge" flag, which however is
not only set on Hot-Plug Capable PCIe ports, but also Conventional PCI
Hot-Plug bridges and ACPI slots.  The flag identifies bridges which are
allocated additional MMIO and bus number resources to allow for hierarchy
expansion.

The kernel is somewhat sloppily using "is_hotplug_bridge" in a number of
places to identify Hot-Plug Capable PCIe ports, even though the flag
encompasses other devices.  Subsequent commits replace these occurrences
with the new flag to clearly delineate Hot-Plug Capable PCIe ports from
other kinds of hotplug bridges.

Document the existing "is_hotplug_bridge" and the new "is_pciehp" flag
and document the (non-obvious) requirement that pci_bridge_d3_possible()
always returns the same value across the entire lifetime of a bridge,
including its hot-removal.

Fixes: 5352a44a561d ("PCI: pciehp: Make pciehp_is_native() stricter")
Reported-by: Laurent Bigonville <bigon@bigon.be>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220216
Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Closes: https://lore.kernel.org/r/20250609020223.269407-3-superm1@kernel.org/
Link: https://lore.kernel.org/all/20250620025535.3425049-3-superm1@kernel.org/T/#u
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: stable@vger.kernel.org # v4.18+
Link: https://patch.msgid.link/fe5dcc3b2e62ee1df7905d746bde161eb1b3291c.1752390101.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-acpi.c |    4 +---
 drivers/pci/pci.c      |    6 +++++-
 drivers/pci/probe.c    |    2 +-
 include/linux/pci.h    |    6 ++++++
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -816,13 +816,11 @@ int pci_acpi_program_hp_params(struct pc
 bool pciehp_is_native(struct pci_dev *bridge)
 {
 	const struct pci_host_bridge *host;
-	u32 slot_cap;
 
 	if (!IS_ENABLED(CONFIG_HOTPLUG_PCI_PCIE))
 		return false;
 
-	pcie_capability_read_dword(bridge, PCI_EXP_SLTCAP, &slot_cap);
-	if (!(slot_cap & PCI_EXP_SLTCAP_HPC))
+	if (!bridge->is_pciehp)
 		return false;
 
 	if (pcie_ports_native)
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3030,8 +3030,12 @@ static const struct dmi_system_id bridge
  * pci_bridge_d3_possible - Is it possible to put the bridge into D3
  * @bridge: Bridge to check
  *
- * This function checks if it is possible to move the bridge to D3.
  * Currently we only allow D3 for some PCIe ports and for Thunderbolt.
+ *
+ * Return: Whether it is possible to move the bridge to D3.
+ *
+ * The return value is guaranteed to be constant across the entire lifetime
+ * of the bridge, including its hot-removal.
  */
 bool pci_bridge_d3_possible(struct pci_dev *bridge)
 {
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1678,7 +1678,7 @@ void set_pcie_hotplug_bridge(struct pci_
 
 	pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &reg32);
 	if (reg32 & PCI_EXP_SLTCAP_HPC)
-		pdev->is_hotplug_bridge = 1;
+		pdev->is_hotplug_bridge = pdev->is_pciehp = 1;
 }
 
 static void set_pcie_thunderbolt(struct pci_dev *dev)
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -328,6 +328,11 @@ struct rcec_ea;
  *			determined (e.g., for Root Complex Integrated
  *			Endpoints without the relevant Capability
  *			Registers).
+ * @is_hotplug_bridge:	Hotplug bridge of any kind (e.g. PCIe Hot-Plug Capable,
+ *			Conventional PCI Hot-Plug, ACPI slot).
+ *			Such bridges are allocated additional MMIO and bus
+ *			number resources to allow for hierarchy expansion.
+ * @is_pciehp:		PCIe Hot-Plug Capable bridge.
  */
 struct pci_dev {
 	struct list_head bus_list;	/* Node in per-bus list */
@@ -451,6 +456,7 @@ struct pci_dev {
 	unsigned int	is_physfn:1;
 	unsigned int	is_virtfn:1;
 	unsigned int	is_hotplug_bridge:1;
+	unsigned int	is_pciehp:1;
 	unsigned int	shpc_managed:1;		/* SHPC owned by shpchp */
 	unsigned int	is_thunderbolt:1;	/* Thunderbolt controller */
 	/*


