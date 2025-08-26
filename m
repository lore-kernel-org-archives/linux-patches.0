Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C87184540;
	Tue, 26 Aug 2025 13:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213691; cv=none; b=A58jmgyulfiLIPm8rnjQvG33ebyOYWRj/jUXd0f4/WrTit4P7XcjhoB0uK7onZEFQ+tboLgFTI6FL4kd+J0zbqKJvOPIUpeskIIZs8IXMY4d+RU41oyd8D+761TBZkliKm744TvmiUqRu4Oi61Xmh9Sjv0LoStm8Hjj/ub/urMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213691; c=relaxed/simple;
	bh=O7el+eekOKPGNIsTXoA1cYKtLXGGCoQYEfn0GGIENL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfO3oqi8vEjVPnvfyH+v+2a9q1iPwBCdRQ43bWPc+4NREYlyDrenwupk/pkkuVajgg8cXrng6zBWebomdOGzRGDluI5Vq4Se7Git/Jfjzh79bvQ5Z/SidUfYS7E4f0d3IPBt3YkymVj/7yBWL9frMmV6LQ2XHJ3epCfTjZOv+nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EFWnl19C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EFWnl19C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D0BC4CEF1;
	Tue, 26 Aug 2025 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213691;
	bh=O7el+eekOKPGNIsTXoA1cYKtLXGGCoQYEfn0GGIENL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EFWnl19C3HhxD3cn7H9xpZWbuhG6ph2j17+DPINxj+vembac9D4LLVCHbAioltLEs
	 Fr6XKiCVfYnt5vsbDltx3tDwGSVSE7QpNIFlRAJhIIX3kOsY0am9Cpq+qqFJkRf5K+
	 /7BGjZSZSVKozTlpBq4UlibBS3Bislv77rnMink4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Bigonville <bigon@bigon.be>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 442/587] PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports
Date: Tue, 26 Aug 2025 13:09:51 +0200
Message-ID: <20250826111004.200426493@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 6cff20ce3b92ffbf2fc5eb9e5a030b3672aa414a ]

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
[ changed "recent enough PCIe ports" comment to "some PCIe ports" ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-acpi.c |    4 +---
 drivers/pci/pci.c      |    8 ++++++--
 drivers/pci/probe.c    |    2 +-
 include/linux/pci.h    |   10 +++++++++-
 4 files changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -793,13 +793,11 @@ int pci_acpi_program_hp_params(struct pc
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
@@ -3065,8 +3065,12 @@ static const struct dmi_system_id bridge
  * pci_bridge_d3_possible - Is it possible to put the bridge into D3
  * @bridge: Bridge to check
  *
- * This function checks if it is possible to move the bridge to D3.
- * Currently we only allow D3 for recent enough PCIe ports and Thunderbolt.
+ * Currently we only allow D3 for some PCIe ports and for Thunderbolt.
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
@@ -1594,7 +1594,7 @@ void set_pcie_hotplug_bridge(struct pci_
 
 	pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &reg32);
 	if (reg32 & PCI_EXP_SLTCAP_HPC)
-		pdev->is_hotplug_bridge = 1;
+		pdev->is_hotplug_bridge = pdev->is_pciehp = 1;
 }
 
 static void set_pcie_thunderbolt(struct pci_dev *dev)
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -318,7 +318,14 @@ struct pci_sriov;
 struct pci_p2pdma;
 struct rcec_ea;
 
-/* The pci_dev structure describes PCI devices */
+/* struct pci_dev - describes a PCI device
+ *
+ * @is_hotplug_bridge:	Hotplug bridge of any kind (e.g. PCIe Hot-Plug Capable,
+ *			Conventional PCI Hot-Plug, ACPI slot).
+ *			Such bridges are allocated additional MMIO and bus
+ *			number resources to allow for hierarchy expansion.
+ * @is_pciehp:		PCIe Hot-Plug Capable bridge.
+ */
 struct pci_dev {
 	struct list_head bus_list;	/* Node in per-bus list */
 	struct pci_bus	*bus;		/* Bus this device is on */
@@ -439,6 +446,7 @@ struct pci_dev {
 	unsigned int	is_physfn:1;
 	unsigned int	is_virtfn:1;
 	unsigned int	is_hotplug_bridge:1;
+	unsigned int	is_pciehp:1;
 	unsigned int	shpc_managed:1;		/* SHPC owned by shpchp */
 	unsigned int	is_thunderbolt:1;	/* Thunderbolt controller */
 	/*


