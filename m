Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E953246778;
	Mon, 23 Mar 2026 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283154; cv=none; b=I2mHbUajd6oNGADd3LDIeuQZTAoX1QJeXjL7Y42GsG+Rp6o9uCCp/qAyvWgltC5DckIJqpYf1abxR2KufkJDVqXMJ3H8YWgSSswu07iHd9cUlfJ/KSFQLR6s+AO1r1o1zej9ZxVQSxUUbgHZq0P9+HRa4dAX1gxxx25UIRAIgbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283154; c=relaxed/simple;
	bh=K5Y/5WqMqQgwq4UMb4CyTjoUGIZe+K8lt+ucjolOdyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXgMfHqH/+VM4xTHmhswHoZB3xRtCH76gzddV9Cv9KGx1kojIa1NBplDc2r13T9zJ6+Z1NApvJiUSzNqCtHbSsrdyu81us2zzard3hCtjvstgtCzFdmSZbHD7JPtV2APqotopSKx03Rtn2UN0+rfu61J/vrT520sQS/KITRmjJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5PFJnGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5PFJnGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECA7C4CEF7;
	Mon, 23 Mar 2026 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283154;
	bh=K5Y/5WqMqQgwq4UMb4CyTjoUGIZe+K8lt+ucjolOdyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5PFJnGT4Isjba+ObjAgA0Zh5/mvSsXpd2l5N1L4LTg+zz0h64Hq3XeBsYyGyhsGH
	 ZGdS+x4ojbwtpKRS+NYBfu3t95Pfc8ZfFn9SIZgFBtbI00utKDEbVl1DoJsODMADj+
	 LyuP1k4Lh1omGZ7dPCBFwhVsci6zwlU7IFEvMHrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 6.1 378/481] net: enetc: reimplement RFS/RSS memory clearing as PCI quirk
Date: Mon, 23 Mar 2026 14:46:00 +0100
Message-ID: <20260323134534.344454915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f0168042a21292d20007d24ab2e4fc32f79ebf11 ]

The workaround implemented in commit 3222b5b613db ("net: enetc:
initialize RFS/RSS memories for unused ports too") is no longer
effective after commit 6fffbc7ae137 ("PCI: Honor firmware's device
disabled status"). Thus, it has introduced a regression and we see AER
errors being reported again:

$ ip link set sw2p0 up && dhclient -i sw2p0 && ip addr show sw2p0
fsl_enetc 0000:00:00.2 eno2: configuring for fixed/internal link mode
fsl_enetc 0000:00:00.2 eno2: Link is Up - 2.5Gbps/Full - flow control rx/tx
mscc_felix 0000:00:00.5 swp2: configuring for fixed/sgmii link mode
mscc_felix 0000:00:00.5 swp2: Link is Up - 1Gbps/Full - flow control off
sja1105 spi2.2 sw2p0: configuring for phy/rgmii-id link mode
sja1105 spi2.2 sw2p0: Link is Up - 1Gbps/Full - flow control off
pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 0000:00:00.0
pcieport 0000:00:1f.0: AER: can't find device of ID0000

Rob's suggestion is to reimplement the enetc driver workaround as a
PCI fixup, and to modify the PCI core to run the fixups for all PCI
functions. This change handles the first part.

We refactor the common code in enetc_psi_create() and enetc_psi_destroy(),
and use the PCI fixup only for those functions for which enetc_pf_probe()
won't get called. This avoids some work being done twice for the PFs
which are enabled.

Fixes: 6fffbc7ae137 ("PCI: Honor firmware's device disabled status")
Link: https://lore.kernel.org/netdev/CAL_JsqLsVYiPLx2kcHkDQ4t=hQVCR7NHziDwi9cCFUFhx48Qow@mail.gmail.com/
Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |  103 +++++++++++++++++-------
 1 file changed, 73 insertions(+), 30 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1236,50 +1236,81 @@ static int enetc_pf_register_with_ierb(s
 	return ret;
 }
 
-static int enetc_pf_probe(struct pci_dev *pdev,
-			  const struct pci_device_id *ent)
+static struct enetc_si *enetc_psi_create(struct pci_dev *pdev)
 {
-	struct device_node *node = pdev->dev.of_node;
-	struct enetc_ndev_priv *priv;
-	struct net_device *ndev;
 	struct enetc_si *si;
-	struct enetc_pf *pf;
 	int err;
 
-	err = enetc_pf_register_with_ierb(pdev);
-	if (err == -EPROBE_DEFER)
-		return err;
-	if (err)
-		dev_warn(&pdev->dev,
-			 "Could not register with IERB driver: %pe, please update the device tree\n",
-			 ERR_PTR(err));
-
-	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(*pf));
-	if (err)
-		return dev_err_probe(&pdev->dev, err, "PCI probing failed\n");
+	err = enetc_pci_probe(pdev, KBUILD_MODNAME, sizeof(struct enetc_pf));
+	if (err) {
+		dev_err_probe(&pdev->dev, err, "PCI probing failed\n");
+		goto out;
+	}
 
 	si = pci_get_drvdata(pdev);
 	if (!si->hw.port || !si->hw.global) {
 		err = -ENODEV;
 		dev_err(&pdev->dev, "could not map PF space, probing a VF?\n");
-		goto err_map_pf_space;
+		goto out_pci_remove;
 	}
 
 	err = enetc_setup_cbdr(&pdev->dev, &si->hw, ENETC_CBDR_DEFAULT_SIZE,
 			       &si->cbd_ring);
 	if (err)
-		goto err_setup_cbdr;
+		goto out_pci_remove;
 
 	err = enetc_init_port_rfs_memory(si);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize RFS memory\n");
-		goto err_init_port_rfs;
+		goto out_teardown_cbdr;
 	}
 
 	err = enetc_init_port_rss_memory(si);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to initialize RSS memory\n");
-		goto err_init_port_rss;
+		goto out_teardown_cbdr;
+	}
+
+	return si;
+
+out_teardown_cbdr:
+	enetc_teardown_cbdr(&si->cbd_ring);
+out_pci_remove:
+	enetc_pci_remove(pdev);
+out:
+	return ERR_PTR(err);
+}
+
+static void enetc_psi_destroy(struct pci_dev *pdev)
+{
+	struct enetc_si *si = pci_get_drvdata(pdev);
+
+	enetc_teardown_cbdr(&si->cbd_ring);
+	enetc_pci_remove(pdev);
+}
+
+static int enetc_pf_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *ent)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct enetc_ndev_priv *priv;
+	struct net_device *ndev;
+	struct enetc_si *si;
+	struct enetc_pf *pf;
+	int err;
+
+	err = enetc_pf_register_with_ierb(pdev);
+	if (err == -EPROBE_DEFER)
+		return err;
+	if (err)
+		dev_warn(&pdev->dev,
+			 "Could not register with IERB driver: %pe, please update the device tree\n",
+			 ERR_PTR(err));
+
+	si = enetc_psi_create(pdev);
+	if (IS_ERR(si)) {
+		err = PTR_ERR(si);
+		goto err_psi_create;
 	}
 
 	if (node && !of_device_is_available(node)) {
@@ -1365,15 +1396,10 @@ err_alloc_si_res:
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
-err_init_port_rss:
-err_init_port_rfs:
 err_device_disabled:
 err_setup_mac_addresses:
-	enetc_teardown_cbdr(&si->cbd_ring);
-err_setup_cbdr:
-err_map_pf_space:
-	enetc_pci_remove(pdev);
-
+	enetc_psi_destroy(pdev);
+err_psi_create:
 	return err;
 }
 
@@ -1396,12 +1422,29 @@ static void enetc_pf_remove(struct pci_d
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
-	enetc_teardown_cbdr(&si->cbd_ring);
 
 	free_netdev(si->ndev);
 
-	enetc_pci_remove(pdev);
+	enetc_psi_destroy(pdev);
+}
+
+static void enetc_fixup_clear_rss_rfs(struct pci_dev *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct enetc_si *si;
+
+	/* Only apply quirk for disabled functions. For the ones
+	 * that are enabled, enetc_pf_probe() will apply it.
+	 */
+	if (node && of_device_is_available(node))
+		return;
+
+	si = enetc_psi_create(pdev);
+	if (si)
+		enetc_psi_destroy(pdev);
 }
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PF,
+			enetc_fixup_clear_rss_rfs);
 
 static const struct pci_device_id enetc_pf_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_FREESCALE, ENETC_DEV_ID_PF) },


