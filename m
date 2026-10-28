Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216589;
	b=C1a7kXAWLJDxhQF82zN5oE/vTz4Qsk4gyYTukqyolcVRO9Y6+fXrMk7KYsoGNdWjRG5R
	 A0eiVoKqdR9pD+uALK9GP5+tHbmUEWvpgWL5hg2EZYbvrUBERwrpiE0Ev1+Er9t+wV9qh
	 KAylK8zJrX8uYHgWn6qXY9tf7jF1eVrg6sdvsf79kyoisBY5HB17S5416IJ52a/bb/YjX
	 i6R4JTY0TxTmF0BwZ1TavhkdEflYOQxLy3hrS+Or5TNw6cpqHTPkZtY2WI6ek8AqdNb2w
	 DozcfbboBXsbviQpRaopETLnfV8V8Fv/AoreW71DegI/aMNUYu0ZA9+I7aOrj2uuZEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rmvo+F178WTfoD6JkaW8rAw+D23VLPP2nhRgrwzXB68=;
	b=PpEbiw2lggQa/GLTsHO/W6TCSfIfg3aYvOfTrbCB9JZLFuY7bsDDX0m451vPnm80hkaY
	 /Rsxv342m1BAq4NZOaU8HeFi9vLOMfyPoYfxCl17GXgbl3cK0LmLQnpq3eTETqhgU33B6
	 EePOX22iYM9Hgk5rGRpAs6a5NX3X9FYBmxzxfz8xPyIJ/k+WhIybH/2Jg27A4ndbYsBMV
	 Wr+3O7kvLB01in5ZFE36LxBKp+cac6MMw4fZoCS2SjJ6pkJQH3/wSrNQLbg1P3uyBDjka
	 HHkeIi3R0VgSwXykb7BltbWfz8uFcKDbtCsR9AoBdhtUM1K63FWQThqLVGBMGi6t3Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKa7qdmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8E0606A31A;
	Wed, 28 Oct 2026 19:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKa7qdmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637FC1F01825;
	Wed, 28 Oct 2026 19:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216588;
	bh=rmvo+F178WTfoD6JkaW8rAw+D23VLPP2nhRgrwzXB68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKa7qdmtJtq9QIDET0mG3jh7/RW/7iuz+J8JUW+uJgD5nr0ZqoxhWPwjP/uibnUPO
	 4wQPJh9K/YJfMAY9udVquzJ8rynJHTqFylJ4u3mZjsyN7/RnQ3KWKdSJJnAPO3Ih7a
	 rWWwF+OGKzT4KNRd5fNG3E+rCRsjrsfoivsKivwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1610/1887] PCI: Fix UAF when probe runs concurrent to dyn ID removal
Date: Wed, 28 Oct 2026 18:01:46 +0100
Message-ID: <20261028170536.105481602@linuxfoundation.org>
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
index 3a1bb9b43cf78..1fbf42f2c961a 100644
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
 
@@ -199,17 +200,16 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 
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
 
 	found_id = do_pci_match_id(drv->id_table, &dev_id, !!dev->driver_override);
 	if (found_id)
@@ -436,12 +436,13 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
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
@@ -1546,12 +1547,13 @@ static int pci_bus_match(struct device *dev, struct device_driver *drv)
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
index 31ac4bb31251b..39e9aea18f5d3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -882,6 +882,7 @@ struct module;
  *		function returns zero when the driver chooses to
  *		take "ownership" of the device or an error code
  *		(negative number) otherwise.
+ *		The pci_device_id parameter is only valid during probe.
  *		The probe function always gets called from process
  *		context, so it can sleep.
  * @remove:	The remove() function gets called whenever a device
-- 
2.53.0



