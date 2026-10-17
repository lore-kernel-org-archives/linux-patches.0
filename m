Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DE83BD64A;
	Sat, 17 Oct 2026 18:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260187; cv=none; b=LJH55PBIkx8mReZGo4fwebxfd4AoH6AUT2PtL4SYmPJhjGymnakzQfoymsBBp708sBpY0wrwV9e32O7o6EhW+yLQWxVtzQ1l1AKosgxZAZzm48F/0gcL0LJHgpz+7iFBg33OwER7EulHRR+L9i51+w+DrhWIKw/aIWFfUb1jW5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260187; c=relaxed/simple;
	bh=FrYi9AG+6qEFbMk8DbEXWgMMva6tYA3rNjkf/f67yqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvTYCITaAqtlxSH9i/m9qFfql3FCsm2yaSZwVmiOgQz8VlkYFAFmSRpolwJyfpgC319zW/iIkFILMATca5KbO7ojIMeYz5Sjx29rxskAF8vnte8pGsFiZ+i6uq9JUpqLjhxruN7JQf3+X9UONBq4ged+NK+T1Wji8ReOCbCkw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TenVQvAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TenVQvAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DEF1F000C4;
	Sat, 17 Oct 2026 18:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260186;
	bh=vrxHhIYm2JNbtBwW61/AnhphGWaBaGnlIyzsj5QHY4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TenVQvAaEqIGzzeFjSE7EBnCnGWk4Zte8wQphkVmd5leAON1CvwFyDCEdgB8NGlIq
	 pn7hoj28ICaPFA1AiJt/JVuVRtVrrYsw4TmlTfhyjjewDaSqjX4hJT6uz75o/3zhCc
	 gEhK2ErgdseYbQc22FTGUiS6i/6bfGcnjqGjaFJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1463/1674] PCI: Fix UAF when probe runs concurrent to dyn ID removal
Date: Sat, 17 Oct 2026 18:02:15 +0200
Message-ID: <20261017160508.722555720@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 3ffc4c9690c33ee28cdb3d0182b12f9c623e3acc ]

Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
as remove_id_store() can free the node. Thus, make a copy in
pci_match_device(). Also, clarify that the id parameter is only valid
during probe.

Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel.org/
Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-9-3580726844e1@garyguo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 28 +++++++++++++++-------------
 include/linux/pci.h      |  1 +
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d237a10ebdad0..02c63637dcef4 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -180,6 +180,7 @@ static const struct pci_device_id pci_device_id_any = {
  * pci_match_device - See if a device matches a driver's list of IDs
  * @drv: the PCI driver to match against
  * @dev: the PCI device structure to match against
+ * @id_copy: place to store copy of pci_device_id for dynamic ID
  *
  * Used by a driver to check whether a PCI device is in its list of
  * supported devices or in the dynids list, which may have been augmented
@@ -187,9 +188,9 @@ static const struct pci_device_id pci_device_id_any = {
  * structure or %NULL if there is no match.
  */
 static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
-						    struct pci_dev *dev)
+						    struct pci_dev *dev,
+						    struct pci_device_id *id_copy)
 {
-	struct pci_dynid *dynid;
 	const struct pci_device_id *found_id = NULL;
 	struct pci_device_id dev_id;
 	int ret;
@@ -201,17 +202,16 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 
 	dev_id = pci_id_from_device(dev);
 	/* Look at the dynamic ids first, before the static ones */
-	spin_lock(&drv->dynids.lock);
-	list_for_each_entry(dynid, &drv->dynids.list, node) {
-		if (pci_match_one_id(&dynid->id, &dev_id)) {
-			found_id = &dynid->id;
-			break;
+	scoped_guard(spinlock, &drv->dynids.lock) {
+		struct pci_dynid *dynid;
+
+		list_for_each_entry(dynid, &drv->dynids.list, node) {
+			if (pci_match_one_id(&dynid->id, &dev_id)) {
+				*id_copy = dynid->id;
+				return id_copy;
+			}
 		}
 	}
-	spin_unlock(&drv->dynids.lock);
-
-	if (found_id)
-		return found_id;
 
 	found_id = do_pci_match_id(drv->id_table, &dev_id, ret > 0);
 	if (found_id)
@@ -438,12 +438,13 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 static int __pci_device_probe(struct pci_driver *drv, struct pci_dev *pci_dev)
 {
 	const struct pci_device_id *id;
+	struct pci_device_id id_copy;
 	int error = 0;
 
 	if (drv->probe) {
 		error = -ENODEV;
 
-		id = pci_match_device(drv, pci_dev);
+		id = pci_match_device(drv, pci_dev, &id_copy);
 		if (id)
 			error = pci_call_probe(drv, pci_dev, id);
 	}
@@ -1549,12 +1550,13 @@ static int pci_bus_match(struct device *dev, struct device_driver *drv)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *pci_drv;
 	const struct pci_device_id *found_id;
+	struct pci_device_id id_copy;
 
 	if (!pci_dev->match_driver)
 		return 0;
 
 	pci_drv = to_pci_driver(drv);
-	found_id = pci_match_device(pci_drv, pci_dev);
+	found_id = pci_match_device(pci_drv, pci_dev, &id_copy);
 	if (found_id)
 		return 1;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 59aec8f9ae78d..5c8f0a8e02ea4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -892,6 +892,7 @@ struct module;
  *		function returns zero when the driver chooses to
  *		take "ownership" of the device or an error code
  *		(negative number) otherwise.
+ *		The pci_device_id parameter is only valid during probe.
  *		The probe function always gets called from process
  *		context, so it can sleep.
  * @remove:	The remove() function gets called whenever a device
-- 
2.53.0



