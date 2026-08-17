Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8043B71D9;
	Mon, 17 Aug 2026 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979689; cv=none; b=GpgFZ6GhceO/6MyPIMf54kM7epFAIKFOk0Ceea7h00Qo/46WCXS7kqisXnLOOs6Yfb6aPBmKF6tl5WZhIzeznjpzZE+DzHjABOtCFNN8v4O2OalJUqPIZdDwnmJCVI/QQZTrjtLl4mSe+YXczboEB0pJQX0rCt9z4vQTlfO65MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979689; c=relaxed/simple;
	bh=nxee6Eso31mQwMkkuOTNoLoHNFcku8sk9Zje6ouxtrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2u1DjpBBMXL/jOKi2zSV2LF/SsbAm2iYeYoYMH/QyhTek32XkVaoVM15DDyfNnbCQzD2fCK9e9EYlHfooiNJCmf9bx/N1YF8vjHCP8/Hv904NzAwxdv9LGVbW713ZURH7Dw+jE0AQHWVT8RfkaMf3+Gp7Luna8DwVluw6TnVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPAmrcv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPAmrcv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A91F000E9;
	Mon, 17 Aug 2026 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979688;
	bh=gcGRVAr9SIWU5dkLkH2im9KXduw3WQtMzqBIfnmB4bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPAmrcv5lsHBkdyJT3mVJh/aiK/iVs6UVjRD8tIJ5eZgfNgujSvpYepbMwgbRIYfm
	 Lz4mKHMBHXoBpvnfE16t5VIQ+vuY5FHYrMFIP3TzKlyjN5IOrMG0VdTHQ6r2nXru/p
	 do+kpkWxT1fCAtiVKeqDzPqLceqG9BYw9nAOa47w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 312/609] ata: libahci_platform: support non-consecutive port numbers
Date: Mon, 17 Aug 2026 15:30:08 +0200
Message-ID: <20260817132554.692560917@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 8c87215dd3a2c814dcffc0bafe8c80c8f98f2574 ]

So far ahci_platform relied on number of child nodes in firmware to
allocate arrays and expected port numbers to start from 0 without holes.
This number of ports is then set in private structure for use when
configuring phys and regulators.

Some platforms may not use every port of an ahci controller.
E.g. SolidRUN CN9130 Clearfog uses only port 1 but not port 0, leading
to the following errors during boot:
[    1.719476] ahci f2540000.sata: invalid port number 1
[    1.724562] ahci f2540000.sata: No port enabled

Update all accessesors of ahci_host_priv phys and target_pwrs arrays to
support holes. Access is gated by hpriv->mask_port_map which has a bit
set for each enabled port.

Update ahci_platform_get_resources to ignore holes in the port numbers
and enable ports defined in firmware by their reg property only.

When firmware does not define children it is assumed that there is
exactly one port, using index 0.

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Stable-dep-of: 4d99a91574c4 ("ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_brcm.c        |  3 +++
 drivers/ata/ahci_ceva.c        |  6 +++++
 drivers/ata/libahci_platform.c | 40 +++++++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 6f216eb256100..cb5d550d6b7ed 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -288,6 +288,9 @@ static unsigned int brcm_ahci_read_id(struct ata_device *dev,
 
 	/* Re-initialize and calibrate the PHY */
 	for (i = 0; i < hpriv->nports; i++) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		rc = phy_init(hpriv->phys[i]);
 		if (rc)
 			goto disable_phys;
diff --git a/drivers/ata/ahci_ceva.c b/drivers/ata/ahci_ceva.c
index 50e07ea60e45c..c179b8b328587 100644
--- a/drivers/ata/ahci_ceva.c
+++ b/drivers/ata/ahci_ceva.c
@@ -206,6 +206,9 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 		goto disable_clks;
 
 	for (i = 0; i < hpriv->nports; i++) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		rc = phy_init(hpriv->phys[i]);
 		if (rc)
 			goto disable_rsts;
@@ -215,6 +218,9 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 	ahci_platform_deassert_rsts(hpriv);
 
 	for (i = 0; i < hpriv->nports; i++) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		rc = phy_power_on(hpriv->phys[i]);
 		if (rc) {
 			phy_exit(hpriv->phys[i]);
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index b9e336bacf179..155ef2aa90a6c 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -48,6 +48,9 @@ int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 	int rc, i;
 
 	for (i = 0; i < hpriv->nports; i++) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		rc = phy_init(hpriv->phys[i]);
 		if (rc)
 			goto disable_phys;
@@ -69,6 +72,9 @@ int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 
 disable_phys:
 	while (--i >= 0) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		phy_power_off(hpriv->phys[i]);
 		phy_exit(hpriv->phys[i]);
 	}
@@ -87,6 +93,9 @@ void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
 	int i;
 
 	for (i = 0; i < hpriv->nports; i++) {
+		if (!(hpriv->mask_port_map & (1 << i)))
+			continue;
+
 		phy_power_off(hpriv->phys[i]);
 		phy_exit(hpriv->phys[i]);
 	}
@@ -434,6 +443,20 @@ static int ahci_platform_get_firmware(struct ahci_host_priv *hpriv,
 	return 0;
 }
 
+static u32 ahci_platform_find_max_port_id(struct device *dev)
+{
+	u32 max_port = 0;
+
+	for_each_child_of_node_scoped(dev->of_node, child) {
+		u32 port;
+
+		if (!of_property_read_u32(child, "reg", &port))
+			max_port = max(max_port, port);
+	}
+
+	return max_port;
+}
+
 /**
  * ahci_platform_get_resources - Get platform resources
  * @pdev: platform device to get resources for
@@ -461,6 +484,7 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 	struct ahci_host_priv *hpriv;
 	struct device_node *child;
 	u32 mask_port_map = 0;
+	u32 max_port;
 
 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
 		return ERR_PTR(-ENOMEM);
@@ -552,15 +576,17 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 		goto err_out;
 	}
 
+	/* find maximum port id for allocating structures */
+	max_port = ahci_platform_find_max_port_id(dev);
 	/*
-	 * If no sub-node was found, we still need to set nports to
-	 * one in order to be able to use the
+	 * Set nports according to maximum port id. Clamp at
+	 * AHCI_MAX_PORTS, warning message for invalid port id
+	 * is generated later.
+	 * When DT has no sub-nodes max_port is 0, nports is 1,
+	 * in order to be able to use the
 	 * ahci_platform_[en|dis]able_[phys|regulators] functions.
 	 */
-	if (child_nodes)
-		hpriv->nports = child_nodes;
-	else
-		hpriv->nports = 1;
+	hpriv->nports = min(AHCI_MAX_PORTS, max_port + 1);
 
 	hpriv->phys = devm_kcalloc(dev, hpriv->nports, sizeof(*hpriv->phys), GFP_KERNEL);
 	if (!hpriv->phys) {
@@ -633,6 +659,8 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 		 * If no sub-node was found, keep this for device tree
 		 * compatibility
 		 */
+		hpriv->mask_port_map |= BIT(0);
+
 		rc = ahci_platform_get_phy(hpriv, 0, dev, dev->of_node);
 		if (rc)
 			goto err_out;
-- 
2.53.0



