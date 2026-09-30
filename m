Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C6D5304BF;
	Wed, 30 Sep 2026 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790584; cv=none; b=p7cdV4eC2kABDyAHd+a1LJkhY7tRg9yeC5IC00vlkp21A4kYD+uurFpL++CBtcM/dteiPdurNfDD7gsl9CwEVVdWaLXBNie34CMSTX+PVwHzot5jcKKBvZKKgdIFRO7ElLmrAnupZT4WryDePKoWwFCBk5giomJiQXL7/cP5qso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790584; c=relaxed/simple;
	bh=bGRvT8yJmwKT3VkLfwy/lXZGo2WZlDdpqQtHxxVpstQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM2F7LUTT4xWFanbTsG40zptxiKO1JRfttIUKTm2JWFIL3NWuUNtzzjp7kgfsO0+aLUB15+p+Lm/xr29Jdg9GNeatasy3XFfZ2MDRD4G4KxrSWAoxpd9na8VUmPXRCRS2zTaG9MuKscWCO6AZP3IG8stcXr6wlBPQKLYppfUfOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfsC0CMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfsC0CMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026451F000FF;
	Wed, 30 Sep 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790582;
	bh=Zcm04X43eP1DfstJZyFYsVB1Yp0RciLPIDfVxv3I5PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfsC0CMvB7YZlUha9FxaWOTfE8QSy5mcFfOqithSolDIYf7I+k4kTzusDLj9auoUQ
	 +Dl/eo1EIOGqLV9m+GlVR+akjLAp0s6kr9H67boQKzcwnXEJea/+fc/8dHpPJyYQUo
	 mDQ7sBjqA1DNXQ7+pDHaSJdlPS7FqKpOhj/msWts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 835/877] PCI: Fix Resizable BAR restore order
Date: Wed, 30 Sep 2026 17:29:06 +0200
Message-ID: <20260930152432.754059880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 5528fd38f230c906fcebb202cc94fbb8ed8f122a ]

The commit 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback
path") changed BAR resize to layer rebar code and resource setup/restore
code cleanly. Unfortunately, it did not consider how the value of the BAR
Size field impacts the read-only bits in the Base Address Register (PCIe7
spec, sec. 7.8.6.3). That is, it very much matters in which order the BAR
Size and Base Address Register are restored.

Post-337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
during BAR resize rollback, pci_do_resource_release_and_resize() attempts
to restore the old address to the BAR that was resized, but it can fail to
setup the address correctly if the address has low bits set that collide
with the bits that are still read-only. As a result, kernel's resource and
BAR will be out-of-sync.

Fix this by restoring BAR Size before rolling back the resource changes and
restoring the BAR.

Fixes: 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/linux-pci/aW_w1oFQCzUxGYtu@intel.com/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260121131417.9582-3-ilpo.jarvinen@linux.intel.com

[6.12 dependency preparation for d58384c22739848efe14b34e9586e4f1242f33c0:
Keep the existing memory-decoding and supported-size checks in rebar.c.
Move BAR size programming and rollback into the resource release helper,
so the old size is restored before restoring BAR addresses.

Use the assigned parent window to select resources for release, retaining
the old flags-based selection when the resized BAR has no parent. Provide
file-local macro mappings for the follow-up's bridge reassignment and
resource assignment checks; no functions are added.

Retain the upstream pre-target pci_bus_sem placement to allow the target
to apply without conflicts. This preparatory dependency must be applied
together with d58384c22739848efe14b34e9586e4f1242f33c0, which takes the lock
before releasing resources and assigns released BARs on root buses.]

Stable-dep-of: d58384c22739 ("PCI: Fix BAR resize for devices on a root bus")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/rebar.c     |   19 +------------------
 drivers/pci/setup-bus.c |   39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 25 deletions(-)

--- a/drivers/pci/rebar.c
+++ b/drivers/pci/rebar.c
@@ -156,7 +156,6 @@ int pci_resize_resource(struct pci_dev *
 			int exclude_bars)
 {
 	struct pci_host_bridge *host;
-	int old, ret;
 	u32 sizes;
 	u16 cmd;
 
@@ -176,22 +175,6 @@ int pci_resize_resource(struct pci_dev *
 	if (!(sizes & BIT(size)))
 		return -EINVAL;
 
-	old = pci_rebar_get_current_size(dev, resno);
-	if (old < 0)
-		return old;
-
-	ret = pci_rebar_set_size(dev, resno, size);
-	if (ret)
-		return ret;
-
-	ret = pci_do_resource_release_and_resize(dev, resno, size, exclude_bars);
-	if (ret)
-		goto error_resize;
-
-	return 0;
-
-error_resize:
-	pci_rebar_set_size(dev, resno, old);
-	return ret;
+	return pci_do_resource_release_and_resize(dev, resno, size, exclude_bars);
 }
 EXPORT_SYMBOL(pci_resize_resource);
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2368,6 +2368,11 @@ static int pci_reassign_bridge_resources
 	return 0;
 }
 
+/* Keep the resize follow-up compatible with the 6.12 resource helpers. */
+#define pbus_reassign_bridge_resources(bus, res, saved) \
+	pci_reassign_bridge_resources((bus)->self, (res)->flags, (saved))
+#define resource_assigned(res) ((res)->parent != NULL)
+
 int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size,
 				       int exclude_bars)
 {
@@ -2375,12 +2380,20 @@ int pci_do_resource_release_and_resize(s
 	unsigned long flags = res->flags;
 	struct pci_dev_resource *dev_res;
 	struct pci_bus *bus = pdev->bus;
-	struct resource *r;
+	struct resource *b_win, *r;
 	LIST_HEAD(saved);
 	unsigned int i;
-	int ret = 0;
+	int old, ret;
 
-	down_read(&pci_bus_sem);
+	b_win = res->parent;
+
+	old = pci_rebar_get_current_size(pdev, resno);
+	if (old < 0)
+		return old;
+
+	ret = pci_rebar_set_size(pdev, resno, size);
+	if (ret)
+		return ret;
 
 	pci_dev_for_each_resource(pdev, r, i) {
 		if (i >= PCI_BRIDGE_RESOURCES)
@@ -2389,7 +2402,10 @@ int pci_do_resource_release_and_resize(s
 		if (exclude_bars & BIT(i))
 			continue;
 
-		if (!pci_resource_len(pdev, i) || r->flags != flags)
+		if (!pci_resource_len(pdev, i))
+			continue;
+
+		if (b_win ? r->parent != b_win : r->flags != flags)
 			continue;
 
 		ret = add_to_list(&saved, pdev, r, 0, 0);
@@ -2403,7 +2419,8 @@ int pci_do_resource_release_and_resize(s
 	if (!bus->self)
 		goto out;
 
-	ret = pci_reassign_bridge_resources(bus->self, res->flags, &saved);
+	down_read(&pci_bus_sem);
+	ret = pbus_reassign_bridge_resources(bus, res, &saved);
 	if (ret)
 		goto restore;
 
@@ -2413,14 +2430,22 @@ out:
 	return ret;
 
 restore:
-	/* Revert to the old configuration */
+	/*
+	 * Revert to the old configuration.
+	 *
+	 * BAR Size must be restored first because it affects the read-only
+	 * bits in BAR (the old address might not be restorable otherwise
+	 * due to low address bits).
+	 */
+	pci_rebar_set_size(pdev, resno, old);
+
 	list_for_each_entry(dev_res, &saved, list) {
 		struct resource *res = dev_res->res;
 		struct pci_dev *dev = dev_res->dev;
 
 		i = res - dev->resource;
 
-		if (res->parent) {
+		if (resource_assigned(res)) {
 			release_child_resources(res);
 			pci_release_resource(dev, i);
 		}


