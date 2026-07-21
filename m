Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030746EF81;
	Tue, 21 Jul 2026 18:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659665; cv=none; b=Pym6QFy0LJAcF96R7vk+Pu3g8YDZxoYs8xiH2P2o6gHoyN/qBotOzuPhqG4pqbiafDOhwHQFTKzYm67qJIk5V/8UrKGETP4xL9S10d8cs582C3FxqYmbQZq4jbfqFkag1BstR3vt7UcAemgtv37KC2p+Q5cHgI+1zN9o/+Ny8vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659665; c=relaxed/simple;
	bh=tZc4nvC6u8sgIhsCgzDAYpajuHEL0Gcp5zW16YGbbzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxh73ErScAOaKY73IE0+RQ5ExJ1p/OG1zCli1omlJTl9mOXBtuzQmL1eKAO2asFTsSKLWXa2/rY/AVkS4JVHd5HKX1n8eIBu9XjHSOQpRbfWZN6kF0Wct5C1tlyc8ItLs9uQ9GvjiQLWZ1nCgR1VVkX3sAoLEcxTqiCuRVI/CG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMEuwqFZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMEuwqFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767A1F000E9;
	Tue, 21 Jul 2026 18:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659664;
	bh=f5LYkpNZWb+u2sFdWnU282JhINix3kl5rmelMCLSczs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMEuwqFZ7tlhtTVnfeLfDKsCrk08W1uq0ymynZKtgt067+sH/5EPDmKyOQvpEaxzn
	 q8kCz3oQTfF0WUdj2kfppN5e44qe2ZBbh8VhkqdSzyJSZY4APxezhdpOyE8f8xnliL
	 8IGvK2ETDPL0uZyBDFBE8LhdRBqau4MGTtBeNyT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 1605/1611] PCI: Fix Resizable BAR restore order
Date: Tue, 21 Jul 2026 17:28:41 +0200
Message-ID: <20260721152551.576480434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 5528fd38f230c906fcebb202cc94fbb8ed8f122a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/rebar.c     |   18 +-----------------
 drivers/pci/setup-bus.c |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/pci/rebar.c
+++ b/drivers/pci/rebar.c
@@ -215,7 +215,6 @@ int pci_resize_resource(struct pci_dev *
 			int exclude_bars)
 {
 	struct pci_host_bridge *host;
-	int old, ret;
 	u32 sizes;
 
 	/* Check if we must preserve the firmware's resource assignment */
@@ -233,21 +232,6 @@ int pci_resize_resource(struct pci_dev *
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
@@ -2452,12 +2452,20 @@ int pci_do_resource_release_and_resize(s
 	struct resource *b_win, *r;
 	LIST_HEAD(saved);
 	unsigned int i;
-	int ret = 0;
+	int old, ret;
 
 	b_win = pbus_select_window(bus, res);
 	if (!b_win)
 		return -EINVAL;
 
+	old = pci_rebar_get_current_size(pdev, resno);
+	if (old < 0)
+		return old;
+
+	ret = pci_rebar_set_size(pdev, resno, size);
+	if (ret)
+		return ret;
+
 	pci_dev_for_each_resource(pdev, r, i) {
 		if (i >= PCI_BRIDGE_RESOURCES)
 			break;
@@ -2490,7 +2498,15 @@ out:
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


