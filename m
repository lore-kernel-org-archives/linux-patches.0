Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C90216E2D;
	Thu, 12 Dec 2024 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025830; cv=none; b=IKezPn3SyHM7Nowr47gDmnBVXRWKC0ARDrj74b/5hi2eoi+FVG7GGyxM8rfotERoKzGnxE3PDD+Yk+xzn3Y/R6lfbVWKkf4qhTJMRXvkPZUri/mJjehsIjw/NQYoqdyaEi0j5KOE/5dLYH3xYHoQbru+Bd1zYtEIm0a+dv11fzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025830; c=relaxed/simple;
	bh=Zs5WZaFfkU/+bS6quDC7kFh48KNZ9uJMdlMUNbuKDPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6vlfP3DiOOLHKUYF+xUp6vYU1eGFDsZ0Zcox0QiKgPr4Biv+NnY5v+l/W1yoAGYUQ3rOq0rksYHo949Fc0nXOu6eA42onGufp1ZEMyzlJj0LDu16CVpnJ7wPl2P/N/yPjWwS6vhXkbbicyWHydsuJqLEcGV5IuIGBMi53ua4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1laHKs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1laHKs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35318C4CECE;
	Thu, 12 Dec 2024 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025830;
	bh=Zs5WZaFfkU/+bS6quDC7kFh48KNZ9uJMdlMUNbuKDPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1laHKs81ehoC8tTL7cYx60elOfgxYQ8wJ9pLQZ/pZURvaTfHnPQnydeXvt2yWpgb
	 yqCVHZutySjUuqCv5IIKCo9a03iMlGtxYx0LtgrvzCNXEodZdVqMEx/lvH6sWe1T0d
	 A/1qIfuy5XCjGenJm6YXJZyEUQyLOe7W/ZomGqeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 301/321] PCI: Add reset_subordinate to reset hierarchy below bridge
Date: Thu, 12 Dec 2024 16:03:39 +0100
Message-ID: <20241212144241.865281886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 2fa046449a82a7d0f6d9721dd83e348816038444 ]

The "bus" and "cxl_bus" reset methods reset a device by asserting Secondary
Bus Reset on the bridge leading to the device.  These only work if the
device is the only device below the bridge.

Add a sysfs 'reset_subordinate' attribute on bridges that can assert
Secondary Bus Reset regardless of how many devices are below the bridge.

This resets all the devices below a bridge in a single command, including
the locking and config space save/restore that reset methods normally do.

This may be the only way to reset devices that don't support other reset
methods (ACPI, FLR, PM reset, etc).

Link: https://lore.kernel.org/r/20241025222755.3756162-1-kbusch@meta.com
Signed-off-by: Keith Busch <kbusch@kernel.org>
[bhelgaas: commit log, add capable(CAP_SYS_ADMIN) check]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Amey Narkhede <ameynarkhede03@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-pci | 11 +++++++++++
 drivers/pci/pci-sysfs.c                 | 26 +++++++++++++++++++++++++
 drivers/pci/pci.c                       |  2 +-
 drivers/pci/pci.h                       |  1 +
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 8bfee557e50ea..e84434d48dcf0 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -125,6 +125,17 @@ Description:
 		will be present in sysfs.  Writing 1 to this file
 		will perform reset.
 
+What:		/sys/bus/pci/devices/.../reset_subordinate
+Date:		October 2024
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This is visible only for bridge devices. If you want to reset
+		all devices attached through the subordinate bus of a specific
+		bridge device, writing 1 to this will try to do it.  This will
+		affect all devices attached to the system through this bridge
+		similiar to writing 1 to their individual "reset" file, so use
+		with caution.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bwh@kernel.org>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 90d5a29a6ff3d..131c6d7e86f8f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -505,6 +505,31 @@ static ssize_t bus_rescan_store(struct device *dev,
 static struct device_attribute dev_attr_bus_rescan = __ATTR(rescan, 0200, NULL,
 							    bus_rescan_store);
 
+static ssize_t reset_subordinate_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct pci_bus *bus = pdev->subordinate;
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		int ret = __pci_reset_bus(bus);
+
+		if (ret)
+			return ret;
+	}
+
+	return count;
+}
+static DEVICE_ATTR_WO(reset_subordinate);
+
 #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 static ssize_t d3cold_allowed_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -628,6 +653,7 @@ static struct attribute *pci_dev_attrs[] = {
 static struct attribute *pci_bridge_attrs[] = {
 	&dev_attr_subordinate_bus_number.attr,
 	&dev_attr_secondary_bus_number.attr,
+	&dev_attr_reset_subordinate.attr,
 	NULL,
 };
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 41050a35631fa..ad5bd17f77a3b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5538,7 +5538,7 @@ EXPORT_SYMBOL_GPL(pci_probe_reset_bus);
  *
  * Same as above except return -EAGAIN if the bus cannot be locked
  */
-static int __pci_reset_bus(struct pci_bus *bus)
+int __pci_reset_bus(struct pci_bus *bus)
 {
 	int rc;
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 725d2b0d45693..7a737ef76e6de 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -41,6 +41,7 @@ int pci_mmap_fits(struct pci_dev *pdev, int resno, struct vm_area_struct *vmai,
 int pci_probe_reset_function(struct pci_dev *dev);
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
+int __pci_reset_bus(struct pci_bus *bus);
 
 #define PCI_PM_D2_DELAY         200
 #define PCI_PM_D3_WAIT          10
-- 
2.43.0



