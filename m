Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790F04A205A;
	Tue, 13 Oct 2026 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894164; cv=none; b=W5jpUkKAv5wC4wupdZslTlYcOV4j5JKWRC6aqYPkWUNezHdv7kRb22MyWaAD8XV8kwAVn092gTq13OiLc7OrII/TtdXHlH7SB3JOEC6hQOG3tcHouY8NlKM96Wgv0QtsL/OKtsjs5yNQIO/d6iiigBF6ppdmkCUOo77PQf7+gCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894164; c=relaxed/simple;
	bh=uPdPnWE8Y+2PHhm6nh4U8m3Ya9wmdvzj9HgInW12TDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2/SxSHzf4M1inhdb+MspvgzKsUwN1pugHMiUBeJxvZRLGIll5kJ20faMAe11uzogpUyTJzM2Ix93LUznybx1uCC/4VH2GoK5cl2Zzn3eS7sKEu3jRsbgWT8FF8U3FFIoBug2orprpppVizmCpC/U6WnRCXNP4WQSkSyYBXqQ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fddSceUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fddSceUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC261F000FF;
	Tue, 13 Oct 2026 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894163;
	bh=yDWVmxZxkFI23qYIFL6y+tVjwsUqQyv5BbI2LHc4VDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fddSceUQ+EMmO3WFws8eFzZAFxQ/WUDWw49Oiz3PkEj6oOubHGB3BVAi6ib/l/KgD
	 CMKPK4JF7ZOQOkqG+q3UHLxFNqSum7V9x8mnFgxSI8bqK/BzMkjlHslUKWQWPkx67z
	 UAsQUZldZgI7re1Gn3GezEbFJGpN69aCwktBBpF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/621] PCI: Fix UAF when probe runs concurrent to dyn ID removal
Date: Tue, 13 Oct 2026 13:37:42 +0200
Message-ID: <20261013112931.915175270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 86fc446f76e5a..a2121abb1abf5 100644
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
@@ -1533,12 +1534,13 @@ static int pci_bus_match(struct device *dev, const struct device_driver *drv)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *pci_drv;
 	const struct pci_device_id *found_id;
+	struct pci_device_id id_copy;
 
 	if (pci_dev_binding_disallowed(pci_dev))
 		return 0;
 
 	pci_drv = (struct pci_driver *)to_pci_driver(drv);
-	found_id = pci_match_device(pci_drv, pci_dev);
+	found_id = pci_match_device(pci_drv, pci_dev, &id_copy);
 	if (found_id)
 		return 1;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 148b71af80b32..95c77e2a1d1f5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -937,6 +937,7 @@ struct module;
  *		function returns zero when the driver chooses to
  *		take "ownership" of the device or an error code
  *		(negative number) otherwise.
+ *		The pci_device_id parameter is only valid during probe.
  *		The probe function always gets called from process
  *		context, so it can sleep.
  * @remove:	The remove() function gets called whenever a device
-- 
2.53.0



