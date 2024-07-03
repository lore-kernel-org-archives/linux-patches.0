Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6406E5ED;
	Wed,  3 Jul 2024 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005427; cv=none; b=OCHZZoyx1Q9hYUrsfj0QVVp4++J5DOug/RyE1o4jfJX7QjY7hSxoJhUtHZpECiSNXXczwSuRGmetMOyrdWF8AyARmEaVufNZfvVzm3usXzU+kqc5/ueupliF/7NqxLyWvxVsuuMVxKd/Vchiw7SlLvfrmi/Fb9DTz6H1pMiepQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005427; c=relaxed/simple;
	bh=aZ6YlC5x3jfZ2b6Y99zz0NjJMXT/qrtAX5cH0le3LdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lz4wvx3CJ+yRCSNfTFIT2reuTXbEcy5TII4Pzt3zMFvYIhNJjFcimDiZpWeeRST5q1VwHq5thYz+xZFOeMLmbEu4TZ23Ikw7r2uxvsJmWxWOaC4ShEpWRDzCL9ySRD7tkwoCLh2HgE2mhCdbZ6C4OjUYviRZsW2SY5aB9pVFjEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFizdlwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFizdlwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B9C2BD10;
	Wed,  3 Jul 2024 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005426;
	bh=aZ6YlC5x3jfZ2b6Y99zz0NjJMXT/qrtAX5cH0le3LdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFizdlwEoOTmx+z7T/StS7JzaYQ1eC6hbDb91TGwPRvHZnSqldVAfQ6q3QPfgO/P0
	 Pe0nN4FsOeQJCfhsZ5GNlgiSltP1emxhKEIYSZCNve6qCUzuqWgOy+vv13m+dHMMLz
	 793W9Ba1ysCz5iJ3WtzGCza+RwJDl2Am6HJcdfNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/356] misc/pvpanic: deduplicate common code
Date: Wed,  3 Jul 2024 12:36:22 +0200
Message-ID: <20240703102914.838249410@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit c1426d392aebc51da4944d950d89e483e43f6f14 ]

pvpanic-mmio.c and pvpanic-pci.c share a lot of code.
Refactor it into pvpanic.c where it doesn't have to be kept in sync
manually and where the core logic can be understood more easily.

No functional change.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20231011-pvpanic-cleanup-v2-1-4b21d56f779f@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ee59be35d7a8 ("misc/pvpanic-pci: register attributes via pci_driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-mmio.c | 58 +---------------------
 drivers/misc/pvpanic/pvpanic-pci.c  | 58 +---------------------
 drivers/misc/pvpanic/pvpanic.c      | 76 ++++++++++++++++++++++++++++-
 drivers/misc/pvpanic/pvpanic.h      | 10 +---
 4 files changed, 80 insertions(+), 122 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-mmio.c b/drivers/misc/pvpanic/pvpanic-mmio.c
index eb97167c03fb4..9715798acce3d 100644
--- a/drivers/misc/pvpanic/pvpanic-mmio.c
+++ b/drivers/misc/pvpanic/pvpanic-mmio.c
@@ -24,52 +24,9 @@ MODULE_AUTHOR("Hu Tao <hutao@cn.fujitsu.com>");
 MODULE_DESCRIPTION("pvpanic-mmio device driver");
 MODULE_LICENSE("GPL");
 
-static ssize_t capability_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%x\n", pi->capability);
-}
-static DEVICE_ATTR_RO(capability);
-
-static ssize_t events_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%x\n", pi->events);
-}
-
-static ssize_t events_store(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-	unsigned int tmp;
-	int err;
-
-	err = kstrtouint(buf, 16, &tmp);
-	if (err)
-		return err;
-
-	if ((tmp & pi->capability) != tmp)
-		return -EINVAL;
-
-	pi->events = tmp;
-
-	return count;
-}
-static DEVICE_ATTR_RW(events);
-
-static struct attribute *pvpanic_mmio_dev_attrs[] = {
-	&dev_attr_capability.attr,
-	&dev_attr_events.attr,
-	NULL
-};
-ATTRIBUTE_GROUPS(pvpanic_mmio_dev);
-
 static int pvpanic_mmio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct pvpanic_instance *pi;
 	struct resource *res;
 	void __iomem *base;
 
@@ -92,18 +49,7 @@ static int pvpanic_mmio_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	pi = devm_kmalloc(dev, sizeof(*pi), GFP_KERNEL);
-	if (!pi)
-		return -ENOMEM;
-
-	pi->base = base;
-	pi->capability = PVPANIC_PANICKED | PVPANIC_CRASH_LOADED;
-
-	/* initialize capability by RDPT */
-	pi->capability &= ioread8(base);
-	pi->events = pi->capability;
-
-	return devm_pvpanic_probe(dev, pi);
+	return devm_pvpanic_probe(dev, base);
 }
 
 static const struct of_device_id pvpanic_mmio_match[] = {
@@ -123,7 +69,7 @@ static struct platform_driver pvpanic_mmio_driver = {
 		.name = "pvpanic-mmio",
 		.of_match_table = pvpanic_mmio_match,
 		.acpi_match_table = pvpanic_device_ids,
-		.dev_groups = pvpanic_mmio_dev_groups,
+		.dev_groups = pvpanic_dev_groups,
 	},
 	.probe = pvpanic_mmio_probe,
 };
diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 07eddb5ea30fa..689af4c28c2a9 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -22,51 +22,8 @@ MODULE_AUTHOR("Mihai Carabas <mihai.carabas@oracle.com>");
 MODULE_DESCRIPTION("pvpanic device driver");
 MODULE_LICENSE("GPL");
 
-static ssize_t capability_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%x\n", pi->capability);
-}
-static DEVICE_ATTR_RO(capability);
-
-static ssize_t events_show(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%x\n", pi->events);
-}
-
-static ssize_t events_store(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct pvpanic_instance *pi = dev_get_drvdata(dev);
-	unsigned int tmp;
-	int err;
-
-	err = kstrtouint(buf, 16, &tmp);
-	if (err)
-		return err;
-
-	if ((tmp & pi->capability) != tmp)
-		return -EINVAL;
-
-	pi->events = tmp;
-
-	return count;
-}
-static DEVICE_ATTR_RW(events);
-
-static struct attribute *pvpanic_pci_dev_attrs[] = {
-	&dev_attr_capability.attr,
-	&dev_attr_events.attr,
-	NULL
-};
-ATTRIBUTE_GROUPS(pvpanic_pci_dev);
-
 static int pvpanic_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct pvpanic_instance *pi;
 	void __iomem *base;
 	int ret;
 
@@ -78,18 +35,7 @@ static int pvpanic_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	if (!base)
 		return -ENOMEM;
 
-	pi = devm_kmalloc(&pdev->dev, sizeof(*pi), GFP_KERNEL);
-	if (!pi)
-		return -ENOMEM;
-
-	pi->base = base;
-	pi->capability = PVPANIC_PANICKED | PVPANIC_CRASH_LOADED;
-
-	/* initlize capability by RDPT */
-	pi->capability &= ioread8(base);
-	pi->events = pi->capability;
-
-	return devm_pvpanic_probe(&pdev->dev, pi);
+	return devm_pvpanic_probe(&pdev->dev, base);
 }
 
 static const struct pci_device_id pvpanic_pci_id_tbl[]  = {
@@ -103,7 +49,7 @@ static struct pci_driver pvpanic_pci_driver = {
 	.id_table =     pvpanic_pci_id_tbl,
 	.probe =        pvpanic_pci_probe,
 	.driver = {
-		.dev_groups = pvpanic_pci_dev_groups,
+		.dev_groups = pvpanic_dev_groups,
 	},
 };
 module_pci_driver(pvpanic_pci_driver);
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 049a120063489..305b367e0ce34 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -7,6 +7,7 @@
  *  Copyright (C) 2021 Oracle.
  */
 
+#include <linux/device.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
@@ -26,6 +27,13 @@ MODULE_AUTHOR("Mihai Carabas <mihai.carabas@oracle.com>");
 MODULE_DESCRIPTION("pvpanic device driver");
 MODULE_LICENSE("GPL");
 
+struct pvpanic_instance {
+	void __iomem *base;
+	unsigned int capability;
+	unsigned int events;
+	struct list_head list;
+};
+
 static struct list_head pvpanic_list;
 static spinlock_t pvpanic_lock;
 
@@ -81,11 +89,75 @@ static void pvpanic_remove(void *param)
 	spin_unlock(&pvpanic_lock);
 }
 
-int devm_pvpanic_probe(struct device *dev, struct pvpanic_instance *pi)
+static ssize_t capability_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pvpanic_instance *pi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%x\n", pi->capability);
+}
+static DEVICE_ATTR_RO(capability);
+
+static ssize_t events_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pvpanic_instance *pi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%x\n", pi->events);
+}
+
+static ssize_t events_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct pvpanic_instance *pi = dev_get_drvdata(dev);
+	unsigned int tmp;
+	int err;
+
+	err = kstrtouint(buf, 16, &tmp);
+	if (err)
+		return err;
+
+	if ((tmp & pi->capability) != tmp)
+		return -EINVAL;
+
+	pi->events = tmp;
+
+	return count;
+}
+static DEVICE_ATTR_RW(events);
+
+static struct attribute *pvpanic_dev_attrs[] = {
+	&dev_attr_capability.attr,
+	&dev_attr_events.attr,
+	NULL
+};
+
+static const struct attribute_group pvpanic_dev_group = {
+	.attrs = pvpanic_dev_attrs,
+};
+
+const struct attribute_group *pvpanic_dev_groups[] = {
+	&pvpanic_dev_group,
+	NULL
+};
+EXPORT_SYMBOL_GPL(pvpanic_dev_groups);
+
+int devm_pvpanic_probe(struct device *dev, void __iomem *base)
 {
-	if (!pi || !pi->base)
+	struct pvpanic_instance *pi;
+
+	if (!base)
 		return -EINVAL;
 
+	pi = devm_kmalloc(dev, sizeof(*pi), GFP_KERNEL);
+	if (!pi)
+		return -ENOMEM;
+
+	pi->base = base;
+	pi->capability = PVPANIC_PANICKED | PVPANIC_CRASH_LOADED;
+
+	/* initlize capability by RDPT */
+	pi->capability &= ioread8(base);
+	pi->events = pi->capability;
+
 	spin_lock(&pvpanic_lock);
 	list_add(&pi->list, &pvpanic_list);
 	spin_unlock(&pvpanic_lock);
diff --git a/drivers/misc/pvpanic/pvpanic.h b/drivers/misc/pvpanic/pvpanic.h
index 4935459517548..46ffb10438adf 100644
--- a/drivers/misc/pvpanic/pvpanic.h
+++ b/drivers/misc/pvpanic/pvpanic.h
@@ -8,13 +8,7 @@
 #ifndef PVPANIC_H_
 #define PVPANIC_H_
 
-struct pvpanic_instance {
-	void __iomem *base;
-	unsigned int capability;
-	unsigned int events;
-	struct list_head list;
-};
-
-int devm_pvpanic_probe(struct device *dev, struct pvpanic_instance *pi);
+int devm_pvpanic_probe(struct device *dev, void __iomem *base);
+extern const struct attribute_group *pvpanic_dev_groups[];
 
 #endif /* PVPANIC_H_ */
-- 
2.43.0



