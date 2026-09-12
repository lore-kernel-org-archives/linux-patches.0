Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520852931FB;
	Sat, 12 Sep 2026 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200101; cv=none; b=PmpCujtyvGY7vTiK4Hp39ugKM74QYDO4KvptJjH5nSZzqh28fSGIbuufhxXc3HazF9gtsETZrNVPg14g2AyeWdTJy49OXrM5syL8QPgSudh8uSW7s3Hv1sWr2DE3Yi6mcnTjLqWpwCEEp3ZcDotojbCeH6xf8ZDAmuBK9ti6yJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200101; c=relaxed/simple;
	bh=lgqvCA8StryPlU7CfcxhnE847pnTMmeL7K3GB2flF70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBtaEzE0fy7fmWoVYtsUjIeOIBWx9YMCBSzTe/3gMzd18kcUd6OlsLS3eXMYiqtPxakeeVU3uB06O+H37lYOv7B6i3JNR4MpepYRyi1L/5xWlTtjWnyf4jk7ldFkqlUquTb4rqyw34JX2Z4Bz66r+e2Aw4ka0rk4pNPKkGUZIgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk/3D9bK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk/3D9bK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6281F000FF;
	Sat, 12 Sep 2026 08:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200100;
	bh=LkPp8vjZsL2K0+XFAD23pp2esJoiFqSEdjpVlMshlog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pk/3D9bKDeJH4Z0ClpAb1Fxp8eBxJrKMqk5p/PEVuM3VHs+OI3cunEm9WIn4urfow
	 d/H8y66Hc4OTy+NRBffpeO33ZSxEJghtbOU/eNcbhDdODbgob9yX7zbiylKfbLtevs
	 98kB1oA8HV3oSQD8y5CVHTpt55tNjPoP1BDPSCQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0720/1815] PCI: Make pci_match_one_device() match on ID instead of device
Date: Sat, 12 Sep 2026 08:41:10 +0200
Message-ID: <20260912065705.800738505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit c967b365d7b51c2297d9be5df39ac3e20638faf4 ]

PCI dynamic ID needs to match IDs against a new ID to see if it already
exists. Existing APIs can only match IDs against devices, so the dynamic ID
insertion code creates a temporary device only for matching purposes.
Rename pci_match_one_device() to pci_match_one_id() so it can be used for
this purpose instead; add a pci_id_from_device() helper to make it easy to
convert users.

Similarly, convert pci_match_id() to do_pci_match_id(). But keep the
existing API because there are many users.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-7-3580726844e1@garyguo.net
Stable-dep-of: 04fde70f782b ("PCI: Fix dyn_id add TOCTOU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 38 +++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 43 +++++++++++++++++++++++++++++-----------
 drivers/pci/search.c     |  8 +++++---
 3 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f36778e62ac1a..c9424edb45481 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -90,6 +90,27 @@ static void pci_free_dynids(struct pci_driver *drv)
 	spin_unlock(&drv->dynids.lock);
 }
 
+/**
+ * do_pci_match_id - See if a PCI ID matches a given pci_id table
+ * @ids: array of PCI device ID structures to search in
+ * @dev_id: the actual PCI device ID structure to match against.
+ *
+ * Return: the matching pci_device_id structure or %NULL if there is no match.
+ */
+static const struct pci_device_id *
+do_pci_match_id(const struct pci_device_id *ids,
+		const struct pci_device_id *dev_id)
+{
+	if (ids) {
+		while (ids->vendor || ids->subvendor || ids->class_mask) {
+			if (pci_match_one_id(ids, dev_id))
+				return ids;
+			ids++;
+		}
+	}
+	return NULL;
+}
+
 /**
  * pci_match_id - See if a PCI device matches a given pci_id table
  * @ids: array of PCI device ID structures to search in
@@ -105,14 +126,9 @@ static void pci_free_dynids(struct pci_driver *drv)
 const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
 					 struct pci_dev *dev)
 {
-	if (ids) {
-		while (ids->vendor || ids->subvendor || ids->class_mask) {
-			if (pci_match_one_device(ids, dev))
-				return ids;
-			ids++;
-		}
-	}
-	return NULL;
+	struct pci_device_id dev_id = pci_id_from_device(dev);
+
+	return do_pci_match_id(ids, &dev_id);
 }
 EXPORT_SYMBOL(pci_match_id);
 
@@ -138,6 +154,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 {
 	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL, *ids;
+	struct pci_device_id dev_id;
 	int ret;
 
 	/* When driver_override is set, only bind to the matching driver */
@@ -145,10 +162,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (ret == 0)
 		return NULL;
 
+	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
 	spin_lock(&drv->dynids.lock);
 	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_device(&dynid->id, dev)) {
+		if (pci_match_one_id(&dynid->id, &dev_id)) {
 			found_id = &dynid->id;
 			break;
 		}
@@ -158,7 +176,7 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	if (found_id)
 		return found_id;
 
-	for (ids = drv->id_table; (found_id = pci_match_id(ids, dev));
+	for (ids = drv->id_table; (found_id = do_pci_match_id(ids, &dev_id));
 	     ids = found_id + 1) {
 		/*
 		 * The match table is split based on driver_override.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4469e1a77f3c1..62c1b324a9bd0 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -442,21 +442,40 @@ static inline int pci_setup_cardbus(char *str) { return -ENOENT; }
 #endif /* CONFIG_CARDBUS */
 
 /**
- * pci_match_one_device - Tell if a PCI device structure has a matching
- *			  PCI device id structure
- * @id: single PCI device id structure to match
- * @dev: the PCI device structure to match against
+ * pci_id_from_device - Obtain a pci_device_id from a PCI device
+ * @dev: the PCI device
  *
- * Returns the matching pci_device_id structure or %NULL if there is no match.
+ * Return: a pci_device_id filled.
  */
-static inline const struct pci_device_id *
-pci_match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
+static inline struct pci_device_id pci_id_from_device(const struct pci_dev *dev)
 {
-	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
-	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
-	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev->subsystem_vendor) &&
-	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev->subsystem_device) &&
-	    !((id->class ^ dev->class) & id->class_mask))
+	return (struct pci_device_id) {
+		.vendor = dev->vendor,
+		.device = dev->device,
+		.subvendor = dev->subsystem_vendor,
+		.subdevice = dev->subsystem_device,
+		.class = dev->class,
+	};
+}
+
+/**
+ * pci_match_one_id - Tell if a PCI device ID matches a needle PCI device ID
+ * @id: single PCI device id structure to match against (needle)
+ * @dev_id: the actual ID from the PCI device
+ *
+ * ID can be retrieved from device using pci_id_from_device().
+ *
+ * Return: the matching pci_device_id structure or %NULL if there is no match.
+ */
+static inline const struct pci_device_id *
+pci_match_one_id(const struct pci_device_id *id,
+		 const struct pci_device_id *dev_id)
+{
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev_id->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev_id->device) &&
+	    (id->subvendor == PCI_ANY_ID || id->subvendor == dev_id->subvendor) &&
+	    (id->subdevice == PCI_ANY_ID || id->subdevice == dev_id->subdevice) &&
+	    !((id->class ^ dev_id->class) & id->class_mask))
 		return id;
 	return NULL;
 }
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index e3d3177fce549..34f8de551d587 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -245,8 +245,10 @@ static int match_pci_dev_by_id(struct device *dev, const void *data)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	const struct pci_device_id *id = data;
+	struct pci_device_id dev_id;
 
-	if (pci_match_one_device(id, pdev))
+	dev_id = pci_id_from_device(pdev);
+	if (pci_match_one_id(id, &dev_id))
 		return 1;
 	return 0;
 }
@@ -416,9 +418,9 @@ EXPORT_SYMBOL(pci_get_class);
  * @class: search for a PCI device with this base class code
  * @from: Previous PCI device found in search, or %NULL for new search.
  *
- * Iterates through the list of known PCI devices. If a PCI device is found
+ * Iterate through the list of known PCI devices. If a PCI device is found
  * with a matching base class code, the reference count to the device is
- * incremented. See pci_match_one_device() to figure out how does this works.
+ * incremented. See pci_match_one_id() to figure out how this works.
  * A new search is initiated by passing %NULL as the @from argument.
  * Otherwise if @from is not %NULL, searches continue from next device on the
  * global list. The reference count for @from is always decremented if it is
-- 
2.53.0



