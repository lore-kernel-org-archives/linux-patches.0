Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D979D36A352;
	Wed, 20 May 2026 17:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297448; cv=none; b=OPFWngyqxYB4FkikMr9y3yNYf4ojEV0+WASKyuX3B+usxVX2FAQNxrNoCuO8DqbcMT5pmwznYIPciiviFBR2FZIntL81SwJJivo63b4aIBjhEx+3mxurVxskbShFIxr0VkDX8t2jOxs2hv3DtyDvOa586OXX9aBJtdO/9lA7t+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297448; c=relaxed/simple;
	bh=H5kCx4am+uzCGk++Yv5pO0AvGwaKCCRs5aVjGP0exvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGAoJeDkZJj0qjPfefoxc0XeS7NJXiAgeGcrNpK5gHrPrBLqi5c94LQL4eUeMIu5u53FHnef2KRLD9J0M3NS75dEIlhc2JB1Frrioq+BraIVjzR9OCY8og9eRNQzA5O2z7YAzpjzQqvGkfjMzeZEmjg/qJBzNup9bF+pbvT7vZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbJ7JpsX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbJ7JpsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8301F000E9;
	Wed, 20 May 2026 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297446;
	bh=cpNhUOmzL4dhy/cRd8Cp26iva5qB+GlGq5zD8+jiEVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbJ7JpsXdYaHq62/JZGLd/5/3EGU314+WQ5Ycm0qClpZvEVBSfU7Fpq4QE28CGBD6
	 G/0xm1XGd/yfq9ze4NwgHMnisDNEhQEQuPFvJSfeHbpZC5ZhJVnzke5tzZsz/lfS9K
	 jdqLVDpyHQ+zoZfdD7aGEEAFOZxRYbUpuwlZ2VYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/957] bus: fsl-mc: use generic driver_override infrastructure
Date: Wed, 20 May 2026 18:08:37 +0200
Message-ID: <20260520162135.299414489@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 6c8dfb0362732bf1e4829867a2a5239fedc592d0 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: 1f86a00c1159 ("bus/fsl-mc: add support for 'driver_override' in the mc-bus")
Link: https://patch.msgid.link/20260324005919.2408620-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c   | 43 +++++--------------------------
 drivers/vfio/fsl-mc/vfio_fsl_mc.c |  4 +--
 include/linux/fsl/mc.h            |  4 ---
 3 files changed, 8 insertions(+), 43 deletions(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index eb7b6c0ba9e7c..996379ace3764 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -86,12 +86,16 @@ static int fsl_mc_bus_match(struct device *dev, const struct device_driver *drv)
 	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
 	const struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(drv);
 	bool found = false;
+	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
-	if (mc_dev->driver_override) {
-		found = !strcmp(mc_dev->driver_override, mc_drv->driver.name);
+	ret = device_match_driver_override(dev, drv);
+	if (ret > 0) {
+		found = true;
 		goto out;
 	}
+	if (ret == 0)
+		goto out;
 
 	if (!mc_drv->match_id_table)
 		goto out;
@@ -181,39 +185,8 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(modalias);
 
-static ssize_t driver_override_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
-	int ret;
-
-	if (WARN_ON(dev->bus != &fsl_mc_bus_type))
-		return -EINVAL;
-
-	ret = driver_set_override(dev, &mc_dev->driver_override, buf, count);
-	if (ret)
-		return ret;
-
-	return count;
-}
-
-static ssize_t driver_override_show(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", mc_dev->driver_override);
-	device_unlock(dev);
-	return len;
-}
-static DEVICE_ATTR_RW(driver_override);
-
 static struct attribute *fsl_mc_dev_attrs[] = {
 	&dev_attr_modalias.attr,
-	&dev_attr_driver_override.attr,
 	NULL,
 };
 
@@ -316,6 +289,7 @@ ATTRIBUTE_GROUPS(fsl_mc_bus);
 
 const struct bus_type fsl_mc_bus_type = {
 	.name = "fsl-mc",
+	.driver_override = true,
 	.match = fsl_mc_bus_match,
 	.uevent = fsl_mc_bus_uevent,
 	.dma_configure  = fsl_mc_dma_configure,
@@ -925,9 +899,6 @@ static struct notifier_block fsl_mc_nb;
  */
 void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
 {
-	kfree(mc_dev->driver_override);
-	mc_dev->driver_override = NULL;
-
 	/*
 	 * The device-specific remove callback will get invoked by device_del()
 	 */
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 76ccbab0e3d64..84cd0eb65c471 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -430,9 +430,7 @@ static int vfio_fsl_mc_bus_notifier(struct notifier_block *nb,
 
 	if (action == BUS_NOTIFY_ADD_DEVICE &&
 	    vdev->mc_dev == mc_cont) {
-		mc_dev->driver_override = kasprintf(GFP_KERNEL, "%s",
-						    vfio_fsl_mc_ops.name);
-		if (!mc_dev->driver_override)
+		if (device_set_driver_override(dev, vfio_fsl_mc_ops.name))
 			dev_warn(dev, "VFIO_FSL_MC: Setting driver override for device in dprc %s failed\n",
 				 dev_name(&mc_cont->dev));
 		else
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 897d6211c1635..1da63f2d70401 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -178,9 +178,6 @@ struct fsl_mc_obj_desc {
  * @regions: pointer to array of MMIO region entries
  * @irqs: pointer to array of pointers to interrupts allocated to this device
  * @resource: generic resource associated with this MC object device, if any.
- * @driver_override: driver name to force a match; do not set directly,
- *                   because core frees it; use driver_set_override() to
- *                   set or clear it.
  *
  * Generic device object for MC object devices that are "attached" to a
  * MC bus.
@@ -214,7 +211,6 @@ struct fsl_mc_device {
 	struct fsl_mc_device_irq **irqs;
 	struct fsl_mc_resource *resource;
 	struct device_link *consumer_link;
-	const char *driver_override;
 };
 
 #define to_fsl_mc_device(_dev) \
-- 
2.53.0



