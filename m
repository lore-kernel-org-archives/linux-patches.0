Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74676382F25;
	Sat, 17 Oct 2026 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253312; cv=none; b=GfrQBhrhNayOh0DUr4spxxqwpI54gzrqxpea2JQWWZZNQKPVE0H0oc7BoDYtG3mTqTFj/WPf0oC1eNqQj72bRDtaSashaydhfaiGMXyIbju0Ur6fxZQxKdIL4Pvn3CrwqbVRrWMq2NJ728OUz1O99VN/q/zNajdR62S4WcPCfUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253312; c=relaxed/simple;
	bh=hGipbFt0hM50UF3hJFd1VAqZC893m15Ne5LJrZn9RAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=koREPSEzueV10L2sn1oA6M8kfPjX/HIop7CaiGFoc3AYG+3dGmhckYHuYZtyjpCLTkuk7XXcAawUdcghd8LrVKf74TAIbfJTAw1CHx2ALAPMle2VmG8NMCPjWIVmc/0HJxsHBLNa5r14xZ21duExZDNXl4BVirjyQyis9syFgCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu5jlhrD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu5jlhrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BA51F000C5;
	Sat, 17 Oct 2026 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253308;
	bh=3gjApN4WrjAPZhYYn2EVFj0wUU1tQwVg8VGZZCUYVDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qu5jlhrDGnDGDZtJTEioKbEINkLAY9rIS1YJlj9v1XnMSXyNietPEvzHBU3/d9bLZ
	 fgctMi/OsdBJFPntzS+TqNuY7KtEHG3yzBIpguZxrBOURTXLOY19rG7K/MqimLl52F
	 FGgFuhM2vLyXohz/kuf8Xr9WdaipMAn0igwJrE+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable+noautosel@kernel.org
Subject: [PATCH 6.12 077/869] PCI/pwrctl: Create pwrctl device only if at least one power supply is present
Date: Sat, 17 Oct 2026 17:48:38 +0200
Message-ID: <20261017160039.000940988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 278dd091e95d428eea0a2c3c517d895b052de5ff ]

Currently, pwrctl devices are created if the corresponding PCI nodes are
defined in devicetree. But this is not correct, because not all PCI nodes
require pwrctl support. Pwrctl comes into the picture only when the device
requires kernel to manage its power state. This can be determined using the
power supply properties present in the devicetree node of the device.

Add of_pci_supply_present() to check whether the devicetree contains at
least one power supply property for a device. If one is present, create a
pwrctl device for that PCI node.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 8fb18619d910 ("PCI/pwrctl: Create platform devices for child OF nodes of the port node")
Link: https://lore.kernel.org/r/20241025-pci-pwrctl-rework-v2-2-568756156cbe@linaro.org
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[bhelgaas: rename of_pci_is_supply_present() to of_pci_supply_present() for
readability]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable+noautosel@kernel.org		# Depends on of_platform_device_create() rework
Stable-dep-of: 8b926f237743 ("PCI/pwrctrl: Cancel outstanding rescan work when unregistering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/bus.c | 11 +++++++++++
 drivers/pci/of.c  | 27 +++++++++++++++++++++++++++
 drivers/pci/pci.h |  5 +++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index aa11262857166..b7f4510c284c0 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -357,6 +357,17 @@ void pci_bus_add_device(struct pci_dev *dev)
 
 	if (dev_of_node(&dev->dev) && pci_is_bridge(dev)) {
 		for_each_available_child_of_node_scoped(dn, child) {
+			/*
+			 * First check whether the pwrctl device needs to be
+			 * created or not. This is decided based on at least
+			 * one of the power supplies being defined in the
+			 * devicetree node of the device.
+			 */
+			if (!of_pci_supply_present(child)) {
+				pci_dbg(dev, "skipping OF node: %s\n", child->name);
+				continue;
+			}
+
 			pdev = of_platform_device_create(child, NULL, &dev->dev);
 			if (!pdev)
 				pci_err(dev, "failed to create OF node: %s\n", child->name);
diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index dacea3fc5128f..52f770bcc4819 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -728,6 +728,33 @@ void of_pci_make_dev_node(struct pci_dev *pdev)
 }
 #endif
 
+/**
+ * of_pci_supply_present() - Check if the power supply is present for the PCI
+ *				device
+ * @np: Device tree node
+ *
+ * Check if the power supply for the PCI device is present in the device tree
+ * node or not.
+ *
+ * Return: true if at least one power supply exists; false otherwise.
+ */
+bool of_pci_supply_present(struct device_node *np)
+{
+	struct property *prop;
+	char *supply;
+
+	if (!np)
+		return false;
+
+	for_each_property_of_node(np, prop) {
+		supply = strrchr(prop->name, '-');
+		if (supply && !strcmp(supply, "-supply"))
+			return true;
+	}
+
+	return false;
+}
+
 #endif /* CONFIG_PCI */
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index cdc0c78b36f56..7b3d45f243264 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -775,6 +775,7 @@ void pci_set_bus_of_node(struct pci_bus *bus);
 void pci_release_bus_of_node(struct pci_bus *bus);
 
 int devm_of_pci_bridge_init(struct device *dev, struct pci_host_bridge *bridge);
+bool of_pci_supply_present(struct device_node *np);
 
 #else
 static inline int
@@ -822,6 +823,10 @@ static inline int devm_of_pci_bridge_init(struct device *dev, struct pci_host_br
 	return 0;
 }
 
+static inline bool of_pci_supply_present(struct device_node *np)
+{
+	return false;
+}
 #endif /* CONFIG_OF */
 
 struct of_changeset;
-- 
2.53.0



