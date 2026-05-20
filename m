Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823E03769E0;
	Wed, 20 May 2026 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300035; cv=none; b=P+7DQ/AvWilAiZblmc3ggULBKEpyA0CK47VCeFUMKTts/1a9+HYxmKM/WyvaPAkcnuW5jiQJ7HqaMycSMt+OHiIpcyXJZQZup6FyCmRRvqxC5yQ7tn3rN/dTR0V5TztI78ILWr2pSjFio703sBTopOYov/uu1tkkV1HbREFwg2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300035; c=relaxed/simple;
	bh=6RoY9bnq9lDUDcyeyXjCWogbXbi3Kxtpmc14yyPbUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+vH818pC3mORjQuiPbN286pXilMdSBiEIxU6Wz/eCbNw8Lxk31zssChUIcsYonFRRlQlnBl7tcS19IvbYb2ZDzM61B5YEdsBtJ27LNka+FthSWruN8MIxdD987XXvYspc4AvyN0sZOBMSi24pZTHFr+o0zeLno+3E2VGAznFNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YiR8aMhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YiR8aMhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71211F000E9;
	Wed, 20 May 2026 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300034;
	bh=3AxnKjImNUKs5P4EjiPB+wBOqJ0UrcyxTsKPrTi99WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiR8aMhsbDxHnsm4zbT+jwzsX4BkU24JWZ5E/+PIJ5C/YrXMzo1iBU7Nxc0HscKUc
	 n7lpy9tmfkyuj/S9mnReWRRf7uTXS0yecSx9/BilTIkwCOY/jjwxz0la8P5cxklabk
	 t9/KH/pTdn2n5K7q0Mv9wXrp0nj3M9UUiD8COyLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex@shazbot.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/666] PCI: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:13:53 +0200
Message-ID: <20260520162111.712323101@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 10a4206a24013be4d558d476010cbf2eb4c9fa64 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: 782a985d7af2 ("PCI: Introduce new device binding path using pci_dev.driver_override")
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Alex Williamson <alex@shazbot.org>
Tested-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260324005919.2408620-6-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c           | 11 +++++++----
 drivers/pci/pci-sysfs.c            | 28 ----------------------------
 drivers/pci/probe.c                |  1 -
 drivers/vfio/pci/vfio_pci_core.c   |  5 ++---
 drivers/xen/xen-pciback/pci_stub.c |  6 ++++--
 include/linux/pci.h                |  6 ------
 6 files changed, 13 insertions(+), 44 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a00a2ce01045f..860d80787d9b1 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -138,9 +138,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL, *ids;
+	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (dev->driver_override && strcmp(dev->driver_override, drv->name))
+	ret = device_match_driver_override(&dev->dev, &drv->driver);
+	if (ret == 0)
 		return NULL;
 
 	/* Look at the dynamic ids first, before the static ones */
@@ -164,7 +166,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 		 * matching.
 		 */
 		if (found_id->override_only) {
-			if (dev->driver_override)
+			if (ret > 0)
 				return found_id;
 		} else {
 			return found_id;
@@ -172,7 +174,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	}
 
 	/* driver_override will always match, send a dummy id */
-	if (dev->driver_override)
+	if (ret > 0)
 		return &pci_device_id_any;
 	return NULL;
 }
@@ -423,7 +425,7 @@ static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 static inline bool pci_device_can_probe(struct pci_dev *pdev)
 {
 	return (!pdev->is_virtfn || pdev->physfn->sriov->drivers_autoprobe ||
-		pdev->driver_override);
+		device_has_driver_override(&pdev->dev));
 }
 #else
 static inline bool pci_device_can_probe(struct pci_dev *pdev)
@@ -1677,6 +1679,7 @@ static void pci_dma_cleanup(struct device *dev)
 
 const struct bus_type pci_bus_type = {
 	.name		= "pci",
+	.driver_override = true,
 	.match		= pci_bus_match,
 	.uevent		= pci_uevent,
 	.probe		= pci_device_probe,
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 96f9cf9f8d643..122c182229b33 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -606,33 +606,6 @@ static ssize_t devspec_show(struct device *dev,
 static DEVICE_ATTR_RO(devspec);
 #endif
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	int ret;
-
-	ret = driver_set_override(dev, &pdev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", pdev->driver_override);
-	device_unlock(dev);
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static struct attribute *pci_dev_attrs[] = {
 	&dev_attr_power_state.attr,
 	&dev_attr_resource.attr,
@@ -660,7 +633,6 @@ static struct attribute *pci_dev_attrs[] = {
 #ifdef CONFIG_OF
 	&dev_attr_devspec.attr,
 #endif
-	&dev_attr_driver_override.attr,
 	&dev_attr_ari_enabled.attr,
 	NULL,
 };
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9e71eb4d1010e..d8c5a957b70e5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2373,7 +2373,6 @@ static void pci_release_dev(struct device *dev)
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
-	kfree(pci_dev->driver_override);
 	bitmap_free(pci_dev->dma_alias_mask);
 	dev_dbg(dev, "device released\n");
 	kfree(pci_dev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5f545b45078f8..dd6e73de2e2a0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2014,9 +2014,8 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	    pdev->is_virtfn && physfn == vdev->pdev) {
 		pci_info(vdev->pdev, "Captured SR-IOV VF %s driver_override\n",
 			 pci_name(pdev));
-		pdev->driver_override = kasprintf(GFP_KERNEL, "%s",
-						  vdev->vdev.ops->name);
-		WARN_ON(!pdev->driver_override);
+		WARN_ON(device_set_driver_override(&pdev->dev,
+						   vdev->vdev.ops->name));
 	} else if (action == BUS_NOTIFY_BOUND_DRIVER &&
 		   pdev->is_virtfn && physfn == vdev->pdev) {
 		struct pci_driver *drv = pci_dev_driver(pdev);
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index b616b7768c3b9..8b3006078d003 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -618,6 +618,8 @@ static int pcistub_seize(struct pci_dev *dev,
 	return err;
 }
 
+static struct pci_driver xen_pcibk_pci_driver;
+
 /* Called when 'bind'. This means we must _NOT_ call pci_reset_function or
  * other functions that take the sysfs lock. */
 static int pcistub_probe(struct pci_dev *dev, const struct pci_device_id *id)
@@ -629,8 +631,8 @@ static int pcistub_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	match = pcistub_match(dev);
 
-	if ((dev->driver_override &&
-	     !strcmp(dev->driver_override, PCISTUB_DRIVER_NAME)) ||
+	if (device_match_driver_override(&dev->dev,
+					 &xen_pcibk_pci_driver.driver) > 0 ||
 	    match) {
 
 		if (dev->hdr_type != PCI_HEADER_TYPE_NORMAL
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 242ee3843e10e..825e6b3056f15 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -540,12 +540,6 @@ struct pci_dev {
 	u8		supported_speeds; /* Supported Link Speeds Vector */
 	phys_addr_t	rom;		/* Physical address if not from BAR */
 	size_t		romlen;		/* Length if not from BAR */
-	/*
-	 * Driver name to force a match.  Do not set directly, because core
-	 * frees it.  Use driver_set_override() to set or clear it.
-	 */
-	const char	*driver_override;
-
 	unsigned long	priv_flags;	/* Private flags for the PCI driver */
 
 	/* These methods index pci_reset_fn_methods[] */
-- 
2.53.0



