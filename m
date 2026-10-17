Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA383ABDB3;
	Sat, 17 Oct 2026 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255166; cv=none; b=Ci6fOiRfSt/l6Xh1p4aclLDoYK+D8tbZvg5tEqlglGhIZGao/Lbgsea5GjsamsQpYVEZ4GcjuuieYsc8/DxI/WmPlqlttdb7Ufi2QK15DNyYr2WOx/D39h11YhhJXgm1R1oJcBCFfdPHbLn7YdLKceiJh/fo1d5VsEjUaaHnm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255166; c=relaxed/simple;
	bh=cpj+coRpM3cHUzQ8qwWhUzVLNvlbkPEYff7DXYaM3pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUPxTCxAfPczPQ22xvSuviyUmABtGnI28MXwkNv0NZgaOTE2qC1hHXCtpTdE/ZCGuJOdQfOlPzJf7kr4bi3VUHXux7hWxMvIE4yx7+rIdhCxrcSmN0hny/nJsRhfoPB2k826yxbQVCC8B2CZNnvP6owZxkgXOrESPpTEmmQnGr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH+0cps5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH+0cps5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1101C1F000C4;
	Sat, 17 Oct 2026 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255164;
	bh=e2DCPk8x7zA2hcmpCO6I/M4Pl5nK6ln1Xi2BzmwIlnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IH+0cps5Icye9xiUSAGyEq6NB9IQXRJt5tWwvJZRmHrgfnMV4q7ztjClwIoARRDGa
	 1I40/oD+56Ayh8dB+rCxtkDqXZ4kXhejnfqYwGMZ8CN956WP8x3odyRNA0Tb0pGLVU
	 oXLfAX7MenUoY2eiGYs8Rkk7qTx2rn/2h4BeGk1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 685/869] PCI: Make pci_match_one_device() match on ID instead of device
Date: Sat, 17 Oct 2026 17:58:46 +0200
Message-ID: <20261017160054.540103977@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 3ffc4c9690c3 ("PCI: Fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 38 +++++++++++++++++++++++++----------
 drivers/pci/pci.h        | 43 +++++++++++++++++++++++++++++-----------
 drivers/pci/search.c     |  8 +++++---
 3 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 0eb246a07c87a..943162501c8e4 100644
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
index 7b3d45f243264..f60d0eb600645 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -289,21 +289,40 @@ extern unsigned long pci_hotplug_mmio_pref_size;
 extern unsigned long pci_hotplug_bus_size;
 
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
index 53840634fbfc2..705ab725321a8 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -243,8 +243,10 @@ static int match_pci_dev_by_id(struct device *dev, const void *data)
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
@@ -368,9 +370,9 @@ EXPORT_SYMBOL(pci_get_class);
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



