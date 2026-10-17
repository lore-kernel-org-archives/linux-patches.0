Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B090F36195A;
	Sat, 17 Oct 2026 18:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260563; cv=none; b=jf5rBwi509fY7ZjQd/vpgNlf/CLMwZlWj2kzUPClEtPh3SExqv4DHCej8Gldv8i3p/hPTtetFf/hXe04i+Y1wpZuDV37eHQCfBuBliBAx1JyeYA03AYrCcOIw0B5mnKPqmCQPjVsBbOF2rpXyCE4pV+h2YyATxoh7V6NoCrvZec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260563; c=relaxed/simple;
	bh=sgI+cZRmeWTnlEdx9xHR92YbjnuvxCKkRkw6W30FZOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4DNrthobJJhohEzEoNcdjleMRs5WzzvBGguxH3fIdb88yjN471pd7vDwNadVPKxWzMeNwEP6ohe/S/J+Sp1GHgpPH82pqSEbwfQmU7fe89bJAXAPHabwS3Fb1K+Q+YCW+OsFHwL6mEGCcKKtLNLwPZpOMSLAvr2jtWARijsHwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VWcSwEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VWcSwEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E8E1F000C4;
	Sat, 17 Oct 2026 18:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260562;
	bh=ii/yiAz7Rnr47wliahjT1uNI7e0JX6bU1lIC5t7vkgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VWcSwEWAmIPKpRJEGs3FX5shTZlFlWXXT9zs9nCuzO9mXTIdkq+M4UEbwhytf86n
	 DRaXpZFvQ5OOc38I1I2ZWEAtAyuAWBnxgFKnXt3KgnaVGZ023ubSHdppBsvhJO+Ynr
	 PTniKzQmkPAsqI+8RE8qE4dhQh/CbczaLOBlzc7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1545/1674] PCI/sysfs: Demacrofy pci_dev_resource_resize_attr(n) functions
Date: Sat, 17 Oct 2026 18:03:37 +0200
Message-ID: <20261017160510.767226198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit f6c73999837820f98519bf0146df44e58f20f89c ]

pci_dev_resource_resize_attr(n) macro is invoked for six resources,
creating a large footprint function for each resource.

Rework the macro to only create a function that calls a helper function so
the compiler can decide if it warrants to inline the function or not.

With x86_64 defconfig, this saves roughly 2.5kB:

  $ scripts/bloat-o-meter drivers/pci/pci-sysfs.o{.old,.new}
  add/remove: 1/0 grow/shrink: 0/6 up/down: 512/-2934 (-2422)
  Function                                     old     new   delta
  __resource_resize_store                        -     512    +512
  resource5_resize_store                       503      14    -489
  resource4_resize_store                       503      14    -489
  resource3_resize_store                       503      14    -489
  resource2_resize_store                       503      14    -489
  resource1_resize_store                       503      14    -489
  resource0_resize_store                       500      11    -489
  Total: Before=13399, After=10977, chg -18.08%

(The compiler seemingly chose to still inline __resource_resize_show()
which is fine, those functions are not very complex/large.)

Link: https://lore.kernel.org/r/20240222114607.1837-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Adapt the helper to this tree's existing resize logic: keep the
four-argument pci_resize_resource() call and omit the loop that releases
same-flag BARs, which is not present here.

Stable-dep-of: 25ec7f57dece ("PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-sysfs.c | 122 ++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 56 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 857bfe349cf5c..087fe400e6372 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1409,71 +1409,81 @@ static const struct attribute_group pci_dev_reset_attr_group = {
 	.is_visible = pci_dev_reset_attr_is_visible,
 };
 
+static ssize_t __resource_resize_show(struct device *dev, int n, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	ssize_t ret;
+
+	pci_config_pm_runtime_get(pdev);
+
+	ret = sysfs_emit(buf, "%016llx\n",
+			 (u64)pci_rebar_get_possible_sizes(pdev, n));
+
+	pci_config_pm_runtime_put(pdev);
+
+	return ret;
+}
+
+static ssize_t __resource_resize_store(struct device *dev, int n,
+				       const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long size;
+	int ret;
+	u16 cmd;
+
+	if (kstrtoul(buf, 0, &size) < 0)
+		return -EINVAL;
+
+	device_lock(dev);
+	if (dev->driver) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	pci_config_pm_runtime_get(pdev);
+
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {
+		ret = aperture_remove_conflicting_pci_devices(pdev,
+						"resourceN_resize");
+		if (ret)
+			goto pm_put;
+	}
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      cmd & ~PCI_COMMAND_MEMORY);
+
+	pci_remove_resource_files(pdev);
+
+	ret = pci_resize_resource(pdev, n, size, 0);
+
+	pci_assign_unassigned_bus_resources(pdev->bus);
+
+	if (pci_create_resource_files(pdev))
+		pci_warn(pdev, "Failed to recreate resource files after BAR resizing\n");
+
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+pm_put:
+	pci_config_pm_runtime_put(pdev);
+unlock:
+	device_unlock(dev);
+
+	return ret ? ret : count;
+}
+
 #define pci_dev_resource_resize_attr(n)					\
 static ssize_t resource##n##_resize_show(struct device *dev,		\
 					 struct device_attribute *attr,	\
-					 char * buf)			\
+					 char *buf)			\
 {									\
-	struct pci_dev *pdev = to_pci_dev(dev);				\
-	ssize_t ret;							\
-									\
-	pci_config_pm_runtime_get(pdev);				\
-									\
-	ret = sysfs_emit(buf, "%016llx\n",				\
-			 (u64)pci_rebar_get_possible_sizes(pdev, n));	\
-									\
-	pci_config_pm_runtime_put(pdev);				\
-									\
-	return ret;							\
+	return __resource_resize_show(dev, n, buf);			\
 }									\
-									\
 static ssize_t resource##n##_resize_store(struct device *dev,		\
 					  struct device_attribute *attr,\
 					  const char *buf, size_t count)\
 {									\
-	struct pci_dev *pdev = to_pci_dev(dev);				\
-	unsigned long size;						\
-	int ret;							\
-	u16 cmd;							\
-									\
-	if (kstrtoul(buf, 0, &size) < 0)				\
-		return -EINVAL;						\
-									\
-	device_lock(dev);						\
-	if (dev->driver) {						\
-		ret = -EBUSY;						\
-		goto unlock;						\
-	}								\
-									\
-	pci_config_pm_runtime_get(pdev);				\
-									\
-	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA) {		\
-		ret = aperture_remove_conflicting_pci_devices(pdev,	\
-						"resourceN_resize");	\
-		if (ret)						\
-			goto pm_put;					\
-	}								\
-									\
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);			\
-	pci_write_config_word(pdev, PCI_COMMAND,			\
-			      cmd & ~PCI_COMMAND_MEMORY);		\
-									\
-	pci_remove_resource_files(pdev);				\
-									\
-	ret = pci_resize_resource(pdev, n, size, 0);			\
-									\
-	pci_assign_unassigned_bus_resources(pdev->bus);			\
-									\
-	if (pci_create_resource_files(pdev))				\
-		pci_warn(pdev, "Failed to recreate resource files after BAR resizing\n");\
-									\
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);			\
-pm_put:									\
-	pci_config_pm_runtime_put(pdev);				\
-unlock:									\
-	device_unlock(dev);						\
-									\
-	return ret ? ret : count;					\
+	return __resource_resize_store(dev, n, buf, count);		\
 }									\
 static DEVICE_ATTR_RW(resource##n##_resize)
 
-- 
2.53.0



