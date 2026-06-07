Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DAF12CDA5;
	Sun,  7 Jun 2026 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829858; cv=none; b=lBB/m3ACY7SX85TdpWGVcSeH4wb5irAWlIU+ALTUZ5joR6JsOUrUzHKlkmNxNqn8l7QLYYO9utGxJRS+GI4BgjFtXo9CcaABYx2KEWRoI6jnbCWJ5djR2/Baxxyqx7+A4LdJTAUNGssA/11Enqmr1wgDN6Lb3b3eAhWQoJ/NohU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829858; c=relaxed/simple;
	bh=SMV3i2ldu0Noo1phd0z9Z86nXxD5voA40ADjoyLfmx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CelTNBoVZOgjzTlH4P/0uyZY1u/lrlR5aSg022zPD2sWObKSDm2pOkSRZISWgsVVuRQ9qvAs+fZESrUVD7cYdNoNV7X9FT32h8n+QJYR8yoL3ISAbv6OqQ2c6HhgpBHB2N5NOJqf+s5laYOP+lHkRy68R25JiAYJQO+7BUSXiQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pei5QrX4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pei5QrX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D757F1F00893;
	Sun,  7 Jun 2026 10:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829857;
	bh=Vy9K3jNkI+SPEKqOvdOu4qJMzEkjm3/CAoIlTB2dmts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pei5QrX4l5tmYfGejWz2LtDQe5rvMgdQnQjtxfmKwFbjl5hvWsSBtAmQb5V1exNpo
	 RN2kqfz2hxAFrfFmBP0MeWKsP7EvtFuSKuZhGTg4Sqc0xwFu/bdUBJor2hJcwr8NOE
	 xXbVv8xRG30KJAoJuxVm5hUHqUesug49iFl/89cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/315] platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery
Date: Sun,  7 Jun 2026 12:01:11 +0200
Message-ID: <20260607095738.018307323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 348ccc754d8939e21ca5956ff45720b81d6e407f ]

After a PCIe Uncorrectable Error has been reported by a device with
Intel Vendor Specific Extended Capabilities and has been recovered
through a Secondary Bus Reset, its driver calls intel_vsec_pci_probe()
to rescan and reinitialize VSECs.

intel_vsec_pci_probe() invokes pcim_enable_device() and thereby adds
another devm action which calls pcim_disable_device() on driver unbind.

So once the driver unbinds, pcim_disable_device() will be called as many
times as an Uncorrectable Error occurred, plus one.  This will lead to
an enable_cnt imbalance on driver unbind.

Additionally, since commit dc957ab6aa05 ("platform/x86/intel/vsec: Add
private data for per-device data"), a devm_kzalloc() allocation is
leaked on every Uncorrectable Error.

Avoid by splitting the VSEC rescan out of intel_vsec_pci_probe() into a
separate helper and calling that on PCIe error recovery.

Fixes: 936874b77dd0 ("platform/x86/intel/vsec: Add PCI error recovery support to Intel PMT")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org  # v6.0+
Link: https://patch.msgid.link/bd594d09fa866dc51dddc9a447c3b23f9b1402cc.1778736835.git.lukas@wunner.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec.c |   54 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -620,29 +620,13 @@ static void intel_vsec_skip_missing_depe
 	}
 }
 
-static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int intel_vsec_pci_init(struct pci_dev *pdev)
 {
-	const struct intel_vsec_platform_info *info;
-	struct vsec_priv *priv;
-	int num_caps, ret;
+	struct vsec_priv *priv = pci_get_drvdata(pdev);
+	const struct intel_vsec_platform_info *info = priv->info;
 	int run_once = 0;
 	bool found_any = false;
-
-	ret = pcim_enable_device(pdev);
-	if (ret)
-		return ret;
-
-	pci_save_state(pdev);
-	info = (const struct intel_vsec_platform_info *)id->driver_data;
-	if (!info)
-		return -EINVAL;
-
-	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->info = info;
-	pci_set_drvdata(pdev, priv);
+	int num_caps;
 
 	num_caps = hweight_long(info->caps);
 	while (num_caps--) {
@@ -663,6 +647,31 @@ static int intel_vsec_pci_probe(struct p
 	return 0;
 }
 
+static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	const struct intel_vsec_platform_info *info;
+	struct vsec_priv *priv;
+	int ret;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_save_state(pdev);
+	info = (const struct intel_vsec_platform_info *)id->driver_data;
+	if (!info)
+		return -EINVAL;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->info = info;
+	pci_set_drvdata(pdev, priv);
+
+	return intel_vsec_pci_init(pdev);
+}
+
 int intel_vsec_set_mapping(struct oobmsm_plat_info *plat_info,
 			   struct intel_vsec_device *vsec_dev)
 {
@@ -796,7 +805,6 @@ static pci_ers_result_t intel_vsec_pci_s
 {
 	struct intel_vsec_device *intel_vsec_dev;
 	pci_ers_result_t status = PCI_ERS_RESULT_DISCONNECT;
-	const struct pci_device_id *pci_dev_id;
 	unsigned long index;
 
 	dev_info(&pdev->dev, "Resetting PCI slot\n");
@@ -817,10 +825,8 @@ static pci_ers_result_t intel_vsec_pci_s
 		devm_release_action(&pdev->dev, intel_vsec_remove_aux,
 				    &intel_vsec_dev->auxdev);
 	}
-	pci_disable_device(pdev);
 	pci_restore_state(pdev);
-	pci_dev_id = pci_match_id(intel_vsec_pci_ids, pdev);
-	intel_vsec_pci_probe(pdev, pci_dev_id);
+	intel_vsec_pci_init(pdev);
 
 out:
 	return status;


