Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15772210F8;
	Thu, 12 Dec 2024 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021468; cv=none; b=r2w0BAbB1xMvNqUEBh/gTflUMmlq0WAhc+rQRP5YJjJtV54Rkf5ssQAOujJFUSeex47kXYWBOBjJV3gEOuA3fqUOE6sDCsR9EfIH6Akvp3J6UZDdO4cC4AEkHFPqdp8QFttAXSAuaH9EXgRy0gxi7tWZVYq+Lr1fThjrd0qwWbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021468; c=relaxed/simple;
	bh=xTVmgbXZvD8kbM+OsF51aLTLD0a7YuiIzFRb3JhrSQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQPpKQKkSQvzq+6w39BawQ/nIYyuvHNZULxQJBErAtba+YNPETgzz2vjW6j27DS+BGmDRk6/H411HfglUUHGCL+w0awhromKMJH9C0xgxt4PH4EiIM8KYvHHwGmma6eq545F1wC++gjCC66YAcTYrpV68bI+GtfrqGI1gSbVGv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8MNTxUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8MNTxUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A68C4CECE;
	Thu, 12 Dec 2024 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021468;
	bh=xTVmgbXZvD8kbM+OsF51aLTLD0a7YuiIzFRb3JhrSQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8MNTxUUFsyJ6LVN98Cq1AFdzDOWAg7qoCFUusMHSoRJw/6uiFOpH9BhZfDvDz9vc
	 9irxx86TopqfjCkoLd2OY9Wpbo0pjUxDI9fIxL5cwUklnaFzVpN+qnoAisxctj6M9Q
	 5oaZuw85VfWgsdOQZLsSE+SKejHdkMwGHGudMdBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 716/772] PCI: Add reset_subordinate to reset hierarchy below bridge
Date: Thu, 12 Dec 2024 16:01:01 +0100
Message-ID: <20241212144419.474689306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 840727fc75dcf..6c5ca95a94105 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -163,6 +163,17 @@ Description:
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
index df1c44a5c886c..e1a980179dc14 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -517,6 +517,31 @@ static ssize_t bus_rescan_store(struct device *dev,
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
@@ -621,6 +646,7 @@ static struct attribute *pci_dev_attrs[] = {
 static struct attribute *pci_bridge_attrs[] = {
 	&dev_attr_subordinate_bus_number.attr,
 	&dev_attr_secondary_bus_number.attr,
+	&dev_attr_reset_subordinate.attr,
 	NULL,
 };
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e08354b811073..8a35a9887302d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5933,7 +5933,7 @@ EXPORT_SYMBOL_GPL(pci_probe_reset_bus);
  *
  * Same as above except return -EAGAIN if the bus cannot be locked
  */
-static int __pci_reset_bus(struct pci_bus *bus)
+int __pci_reset_bus(struct pci_bus *bus)
 {
 	int rc;
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 5d5813aa5b458..38ad75ce52c32 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -37,6 +37,7 @@ bool pci_reset_supported(struct pci_dev *dev);
 void pci_init_reset_methods(struct pci_dev *dev);
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 int pci_bus_error_reset(struct pci_dev *dev);
+int __pci_reset_bus(struct pci_bus *bus);
 
 struct pci_cap_saved_data {
 	u16		cap_nr;
-- 
2.43.0



