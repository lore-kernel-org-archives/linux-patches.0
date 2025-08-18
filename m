Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0B3320389;
	Mon, 18 Aug 2025 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522842; cv=none; b=BFg57xLLAWpixSbDidtnJhGUJG+z6kXD+mFU2FJ/Ar674G+ZVEQHHAcRtDfY7gbm/6Afo0oVJp26I1tIpgMzFo60slEiScCfywH1e2zhbcbXcsnIWfNRoM09NV9lISLdzJ1yM/yHZrpQKTAHsQEOl2n1FUTEhday6EI5JZmiZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522842; c=relaxed/simple;
	bh=Wrhc6wGPTEfNZmp5GSXMIEMprh/hyVTqpjceRvzSK0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AXTXajQCAK9l5qQwqI8+dgiOZ2AKWljtZ2nYYQ/pR5ErKFeikjxgyVugO3xzdSMHQ+jhLsPJo3Aa7VJyOYhrxBsSjvl4HV+qixd3wsLfGh0zJyTp2+TcOj9ZkPgclTdiyB56K+IK6nVrcMt3kNyx9Xam8YQ9JJTF9VvyLnTyFUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynoTB5la; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynoTB5la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C170EC4CEEB;
	Mon, 18 Aug 2025 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522842;
	bh=Wrhc6wGPTEfNZmp5GSXMIEMprh/hyVTqpjceRvzSK0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynoTB5laLyB0xR82XHbvAIBgfMAv3ZmVhcpekjkItbo9gbv5igjqowotS++cT+ZuD
	 UJudHTv8xzR+x6eZq74ebDItRJKgG3+i8CAMItEyZ1b8RWuq3wDmAvEh2ydJpUpdpG
	 l2ku/IuClqvvJvB6xSjT9vSqC/9jNBsq4xPaBlEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/444] PCI: Store all PCIe Supported Link Speeds
Date: Mon, 18 Aug 2025 14:47:36 +0200
Message-ID: <20250818124505.072345563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d2bd39c0456b75be9dfc7d774b8d021355c26ae3 ]

The PCIe bandwidth controller added by a subsequent commit will require
selecting PCIe Link Speeds that are lower than the Maximum Link Speed.

The struct pci_bus only stores max_bus_speed. Even if PCIe r6.1 sec 8.2.1
currently disallows gaps in supported Link Speeds, the Implementation Note
in PCIe r6.1 sec 7.5.3.18, recommends determining supported Link Speeds
using the Supported Link Speeds Vector in the Link Capabilities 2 Register
(when available) to "avoid software being confused if a future
specification defines Links that do not require support for all slower
speeds."

Reuse code in pcie_get_speed_cap() to add pcie_get_supported_speeds() to
query the Supported Link Speeds Vector of a PCIe device. The value is taken
directly from the Supported Link Speeds Vector or synthesized from the Max
Link Speed in the Link Capabilities Register when the Link Capabilities 2
Register is not available.

The Supported Link Speeds Vector in the Link Capabilities Register 2
corresponds to the bus below on Root Ports and Downstream Ports, whereas it
corresponds to the bus above on Upstream Ports and Endpoints (PCIe r6.1 sec
7.5.3.18):

  Supported Link Speeds Vector - This field indicates the supported Link
  speed(s) of the associated Port.

Add supported_speeds into the struct pci_dev that caches the
Supported Link Speeds Vector.

supported_speeds contains a set of Link Speeds only in the case where PCIe
Link Speed can be determined. Root Complex Integrated Endpoints do not have
a well-defined Link Speed because they do not implement either of the Link
Capabilities Registers, which is allowed by PCIe r6.1 sec 7.5.3 (the same
limitation applies to determining cur_bus_speed and max_bus_speed that are
PCI_SPEED_UNKNOWN in such case). This is of no concern from PCIe bandwidth
controller point of view because such devices are not attached into a PCIe
Root Port that could be controlled.

The supported_speeds field keeps the extra reserved zero at the least
significant bit to match the Link Capabilities 2 Register layout.

An attempt was made to store supported_speeds field into the struct pci_bus
as an intersection of both ends of the Link, however, the subordinate
struct pci_bus is not available early enough. The Target Speed quirk (in
pcie_failed_link_retrain()) can run either during initial scan or later,
requiring it to use the API provided by the PCIe bandwidth controller to
set the Target Link Speed in order to co-exist with the bandwidth
controller. When the Target Speed quirk is calling the bandwidth controller
during initial scan, the struct pci_bus is not yet initialized. As such,
storing supported_speeds into the struct pci_bus is not viable.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/20241018144755.7875-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[bhelgaas: move pcie_get_supported_speeds() decl to drivers/pci/pci.h]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 6cff20ce3b92 ("PCI/ACPI: Fix runtime PM ref imbalance on Hot-Plug Capable ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c             |   58 ++++++++++++++++++++++++++++++------------
 drivers/pci/pci.h             |    1 
 drivers/pci/probe.c           |    3 ++
 include/linux/pci.h           |   10 ++++++-
 include/uapi/linux/pci_regs.h |    1 
 5 files changed, 56 insertions(+), 17 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6199,38 +6199,64 @@ u32 pcie_bandwidth_available(struct pci_
 EXPORT_SYMBOL(pcie_bandwidth_available);
 
 /**
- * pcie_get_speed_cap - query for the PCI device's link speed capability
+ * pcie_get_supported_speeds - query Supported Link Speed Vector
  * @dev: PCI device to query
  *
- * Query the PCI device speed capability.  Return the maximum link speed
- * supported by the device.
+ * Query @dev supported link speeds.
+ *
+ * Implementation Note in PCIe r6.0 sec 7.5.3.18 recommends determining
+ * supported link speeds using the Supported Link Speeds Vector in the Link
+ * Capabilities 2 Register (when available).
+ *
+ * Link Capabilities 2 was added in PCIe r3.0, sec 7.8.18.
+ *
+ * Without Link Capabilities 2, i.e., prior to PCIe r3.0, Supported Link
+ * Speeds field in Link Capabilities is used and only 2.5 GT/s and 5.0 GT/s
+ * speeds were defined.
+ *
+ * For @dev without Supported Link Speed Vector, the field is synthesized
+ * from the Max Link Speed field in the Link Capabilities Register.
+ *
+ * Return: Supported Link Speeds Vector (+ reserved 0 at LSB).
  */
-enum pci_bus_speed pcie_get_speed_cap(struct pci_dev *dev)
+u8 pcie_get_supported_speeds(struct pci_dev *dev)
 {
 	u32 lnkcap2, lnkcap;
+	u8 speeds;
 
 	/*
-	 * Link Capabilities 2 was added in PCIe r3.0, sec 7.8.18.  The
-	 * implementation note there recommends using the Supported Link
-	 * Speeds Vector in Link Capabilities 2 when supported.
-	 *
-	 * Without Link Capabilities 2, i.e., prior to PCIe r3.0, software
-	 * should use the Supported Link Speeds field in Link Capabilities,
-	 * where only 2.5 GT/s and 5.0 GT/s speeds were defined.
+	 * Speeds retain the reserved 0 at LSB before PCIe Supported Link
+	 * Speeds Vector to allow using SLS Vector bit defines directly.
 	 */
 	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP2, &lnkcap2);
+	speeds = lnkcap2 & PCI_EXP_LNKCAP2_SLS;
 
 	/* PCIe r3.0-compliant */
-	if (lnkcap2)
-		return PCIE_LNKCAP2_SLS2SPEED(lnkcap2);
+	if (speeds)
+		return speeds;
 
 	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
+
+	/* Synthesize from the Max Link Speed field */
 	if ((lnkcap & PCI_EXP_LNKCAP_SLS) == PCI_EXP_LNKCAP_SLS_5_0GB)
-		return PCIE_SPEED_5_0GT;
+		speeds = PCI_EXP_LNKCAP2_SLS_5_0GB | PCI_EXP_LNKCAP2_SLS_2_5GB;
 	else if ((lnkcap & PCI_EXP_LNKCAP_SLS) == PCI_EXP_LNKCAP_SLS_2_5GB)
-		return PCIE_SPEED_2_5GT;
+		speeds = PCI_EXP_LNKCAP2_SLS_2_5GB;
+
+	return speeds;
+}
 
-	return PCI_SPEED_UNKNOWN;
+/**
+ * pcie_get_speed_cap - query for the PCI device's link speed capability
+ * @dev: PCI device to query
+ *
+ * Query the PCI device speed capability.
+ *
+ * Return: the maximum link speed supported by the device.
+ */
+enum pci_bus_speed pcie_get_speed_cap(struct pci_dev *dev)
+{
+	return PCIE_LNKCAP2_SLS2SPEED(dev->supported_speeds);
 }
 EXPORT_SYMBOL(pcie_get_speed_cap);
 
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -390,6 +390,7 @@ static inline int pcie_dev_speed_mbps(en
 	return -EINVAL;
 }
 
+u8 pcie_get_supported_speeds(struct pci_dev *dev);
 const char *pci_speed_string(enum pci_bus_speed speed);
 enum pci_bus_speed pcie_get_speed_cap(struct pci_dev *dev);
 enum pcie_link_width pcie_get_width_cap(struct pci_dev *dev);
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1972,6 +1972,9 @@ int pci_setup_device(struct pci_dev *dev
 
 	set_pcie_untrusted(dev);
 
+	if (pci_is_pcie(dev))
+		dev->supported_speeds = pcie_get_supported_speeds(dev);
+
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -320,7 +320,14 @@ struct pci_sriov;
 struct pci_p2pdma;
 struct rcec_ea;
 
-/* The pci_dev structure describes PCI devices */
+/* struct pci_dev - describes a PCI device
+ *
+ * @supported_speeds:	PCIe Supported Link Speeds Vector (+ reserved 0 at
+ *			LSB). 0 when the supported speeds cannot be
+ *			determined (e.g., for Root Complex Integrated
+ *			Endpoints without the relevant Capability
+ *			Registers).
+ */
 struct pci_dev {
 	struct list_head bus_list;	/* Node in per-bus list */
 	struct pci_bus	*bus;		/* Bus this device is on */
@@ -524,6 +531,7 @@ struct pci_dev {
 	struct npem	*npem;		/* Native PCIe Enclosure Management */
 #endif
 	u16		acs_cap;	/* ACS Capability offset */
+	u8		supported_speeds; /* Supported Link Speeds Vector */
 	phys_addr_t	rom;		/* Physical address if not from BAR */
 	size_t		romlen;		/* Length if not from BAR */
 	/*
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -678,6 +678,7 @@
 #define PCI_EXP_DEVSTA2		0x2a	/* Device Status 2 */
 #define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V2 0x2c	/* end of v2 EPs w/o link */
 #define PCI_EXP_LNKCAP2		0x2c	/* Link Capabilities 2 */
+#define  PCI_EXP_LNKCAP2_SLS		0x000000fe /* Supported Link Speeds Vector */
 #define  PCI_EXP_LNKCAP2_SLS_2_5GB	0x00000002 /* Supported Speed 2.5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_5_0GB	0x00000004 /* Supported Speed 5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_8_0GB	0x00000008 /* Supported Speed 8GT/s */


