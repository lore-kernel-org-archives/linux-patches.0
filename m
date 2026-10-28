Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216586;
	b=kwhGisLKfvyiJKcHVlYDDIe3HPIbyiUTIxhpvK2xyLEWbKA58KiaFEVUJPi+DRt8Ra8t
	 +jEcsH8sLf5lAe+0UaokPXprOd97Juq6yYiejsIJz8Yy4Gk0owTk9oT8MLOy6UO2tzP7j
	 kelVhQpFGq2+UasM7eWhUsrqgIhvKkeGphYo3GHvgHXQpgodbE3gPPOneYS0rmKTbbaS/
	 eSTsvx5W7EEfItxvlQLpWKF/pOFyPDzDoauSj2wPQsybNXkt/pJesbfUclc5XCPy7dfqd
	 3lcvB9vBOfWMctdbtVtzEJgeju1dnOysDVmQNwMzJL8fYzC7YXT7qh04KQ9tpqAJjSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J9mU+idiolkWVxV7+LMOyBnmq0q2ndKUxqFjMxKY5No=;
	b=SSXWgvNDiqzZKC6cselCVAhm0Bma9gXJhCRVgL8hYNcP1yGCQr1maewQ4bfeH2mJ9LJW
	 zKoxc+QVmJlX8A/yDhfuLSOZ4PWYOwSjRUiUqALzXV4si8hmKhuiJkJZQnIQs8Vnqy5gL
	 lUKJbAxMU9/TZQy2em7wSEdHWGm1DNVibv9MUxAvP+Jok24stF8MwrQUdhmEc2kDeL50L
	 JR2AZCaHpcIgjeirmuWsgv48DGDSb+qOzpLZ6EnRbFIEJWwy2wj8EDObjN7YbqlVORIhy
	 kGiM9PiOnhJLFQ025vSdo+rYtgb/PulxHUtlIDKt40cbT8QCKZPtpqUwesVxjb4W84A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGzIVXIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB7606A31A;
	Wed, 28 Oct 2026 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGzIVXIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7A1F01825;
	Wed, 28 Oct 2026 19:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216586;
	bh=J9mU+idiolkWVxV7+LMOyBnmq0q2ndKUxqFjMxKY5No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGzIVXIJbi/qCVurJG3E7yGZRPndYiQPOlJmsfIy9NkJfhzIzlshPicCDWH//fU3v
	 9lBJRg2Ln01kdxsYnFzzNVoSeWHgCD9lAxQpXbsQgxDLRCoMdsThFL3tWXbdhMZnJE
	 CiXUA5xkzvWSceKxFSPqjhpMFrmmz4eDu1WZO0N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1609/1887] PCI: Fix dyn_id add TOCTOU
Date: Wed, 28 Oct 2026 18:01:45 +0100
Message-ID: <20261028170536.081666680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 04fde70f782b6ce984f9f80c2023786caea28287 ]

Currently there is a TOCTOU issue in new_id_store() as the dyn ID insertion
in pci_add_dynid() and the pci_match_device() are in separate critical
sections.

Fix this by moving the existing ID check to inside pci_add_dynid() and only
check against the static ID table outside the critical section.

Fixes: 3853f9123c18 ("PCI: Avoid duplicate IDs in driver dynamic IDs list")
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-8-3580726844e1@garyguo.net

Adapted to this tree: use kzalloc() instead of kzalloc_obj(), and keep
the dev->driver_override check to decide whether override-only table
entries are matched.

Stable-dep-of: 3ffc4c9690c3 ("PCI: Fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 142 ++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 69 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2b5b70e5b393a..3a1bb9b43cf78 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -29,6 +29,47 @@ struct pci_dynid {
 	struct pci_device_id id;
 };
 
+/**
+ * do_pci_add_dynid - Add a new PCI device ID to this driver and re-probe
+ * @drv: target PCI driver
+ * @id: ID to be added
+ * @check_dup: whether to check if matching ID is already present
+ *
+ * Add a new dynamic PCI device ID to this driver and causes the driver to
+ * probe for all devices again.  @drv must have been registered prior to calling
+ * this function.
+ *
+ * Context: Does GFP_KERNEL allocation.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+static int do_pci_add_dynid(struct pci_driver *drv,
+			    const struct pci_device_id *id,
+			    bool check_dup)
+{
+	struct pci_dynid *dynid, *existing_dynid;
+
+	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
+	if (!dynid)
+		return -ENOMEM;
+
+	dynid->id = *id;
+
+	scoped_guard(spinlock, &drv->dynids.lock) {
+		if (check_dup) {
+			list_for_each_entry(existing_dynid, &drv->dynids.list, node) {
+				if (pci_match_one_id(&existing_dynid->id, id)) {
+					kfree(dynid);
+					return -EEXIST;
+				}
+			}
+		}
+		list_add_tail(&dynid->node, &drv->dynids.list);
+	}
+
+	return driver_attach(&drv->driver);
+}
+
 /**
  * pci_add_dynid - add a new PCI device ID to this driver and re-probe devices
  * @drv: target pci driver
@@ -56,25 +97,17 @@ int pci_add_dynid(struct pci_driver *drv,
 		  unsigned int class, unsigned int class_mask,
 		  unsigned long driver_data)
 {
-	struct pci_dynid *dynid;
-
-	dynid = kzalloc(sizeof(*dynid), GFP_KERNEL);
-	if (!dynid)
-		return -ENOMEM;
+	struct pci_device_id id = {
+		.vendor = vendor,
+		.device = device,
+		.subvendor = subvendor,
+		.subdevice = subdevice,
+		.class = class,
+		.class_mask = class_mask,
+		.driver_data = driver_data,
+	};
 
-	dynid->id.vendor = vendor;
-	dynid->id.device = device;
-	dynid->id.subvendor = subvendor;
-	dynid->id.subdevice = subdevice;
-	dynid->id.class = class;
-	dynid->id.class_mask = class_mask;
-	dynid->id.driver_data = driver_data;
-
-	spin_lock(&drv->dynids.lock);
-	list_add_tail(&dynid->node, &drv->dynids.list);
-	spin_unlock(&drv->dynids.lock);
-
-	return driver_attach(&drv->driver);
+	return do_pci_add_dynid(drv, &id, false);
 }
 EXPORT_SYMBOL_GPL(pci_add_dynid);
 
@@ -94,16 +127,20 @@ static void pci_free_dynids(struct pci_driver *drv)
  * do_pci_match_id - See if a PCI ID matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
  * @dev_id: the PCI device ID structure to match against.
+ * @include_override_only: also match against device ID entries marked as
+ *                         override only.
  *
  * Returns the matching pci_device_id structure or %NULL if there is no match.
  */
 static const struct pci_device_id *
 do_pci_match_id(const struct pci_device_id *ids,
-		const struct pci_device_id *dev_id)
+		const struct pci_device_id *dev_id,
+		bool include_override_only)
 {
 	if (ids) {
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_id(ids, dev_id))
+			if ((!ids->override_only || include_override_only) &&
+			    pci_match_one_id(ids, dev_id))
 				return ids;
 			ids++;
 		}
@@ -128,7 +165,7 @@ const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 {
 	struct pci_device_id dev_id = pci_id_from_device(dev);
 
-	return do_pci_match_id(ids, &dev_id);
+	return do_pci_match_id(ids, &dev_id, true);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -153,7 +190,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 						    struct pci_dev *dev)
 {
 	struct pci_dynid *dynid;
-	const struct pci_device_id *found_id = NULL, *ids;
+	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 
 	/* When driver_override is set, only bind to the matching driver */
@@ -174,20 +211,9 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
-	     ids = found_id + 1) {
-		/*
-		 * The match table is split based on driver_override.
-		 * In case override_only was set, enforce driver_override
-		 * matching.
-		 */
-		if (found_id->override_only) {
-			if (dev->driver_override)
-				return found_id;
-		} else {
-			return found_id;
-		}
-	}
+	found_id = do_pci_match_id(drv->id_table, &dev_id, !!dev->driver_override);
+	if (found_id)
+		return found_id;
 
 	/* driver_override will always match, send a dummy id */
 	if (dev->driver_override)
@@ -195,11 +221,6 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	return NULL;
 }
 
-static void _pci_free_device(struct device *dev)
-{
-	kfree(to_pci_dev(dev));
-}
-
 /**
  * new_id_store - sysfs frontend to pci_add_dynid()
  * @driver: target device driver
@@ -213,38 +234,22 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 {
 	struct pci_driver *pdrv = to_pci_driver(driver);
 	const struct pci_device_id *ids = pdrv->id_table;
-	u32 vendor, device, subvendor = PCI_ANY_ID,
-		subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
-	unsigned long driver_data = 0;
-	int fields = 0;
+	struct pci_device_id id = {
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID
+	};
+	int fields;
 	int retval = 0;
 
 	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
-			&vendor, &device, &subvendor, &subdevice,
-			&class, &class_mask, &driver_data);
+			&id.vendor, &id.device, &id.subvendor, &id.subdevice,
+			&id.class, &id.class_mask, &id.driver_data);
 	if (fields < 2)
 		return -EINVAL;
 
 	if (fields != 7) {
-		struct pci_dev *pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
-		if (!pdev)
-			return -ENOMEM;
-
-		pdev->vendor = vendor;
-		pdev->device = device;
-		pdev->subsystem_vendor = subvendor;
-		pdev->subsystem_device = subdevice;
-		pdev->class = class;
-		pdev->dev.release = _pci_free_device;
-
-		device_initialize(&pdev->dev);
-		if (pci_match_device(pdrv, pdev))
-			retval = -EEXIST;
-
-		put_device(&pdev->dev);
-
-		if (retval)
-			return retval;
+		if (do_pci_match_id(pdrv->id_table, &id, false))
+			return -EEXIST;
 	}
 
 	/* Only accept driver_data values that match an existing id_table
@@ -252,7 +257,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 	if (ids) {
 		retval = -EINVAL;
 		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (driver_data == ids->driver_data) {
+			if (id.driver_data == ids->driver_data) {
 				retval = 0;
 				break;
 			}
@@ -262,8 +267,7 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 			return retval;
 	}
 
-	retval = pci_add_dynid(pdrv, vendor, device, subvendor, subdevice,
-			       class, class_mask, driver_data);
+	retval = do_pci_add_dynid(pdrv, &id, fields != 7);
 	if (retval)
 		return retval;
 	return count;
-- 
2.53.0



