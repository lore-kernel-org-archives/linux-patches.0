Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513E52F12AE;
	Tue, 16 Jun 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632641; cv=none; b=N7FnTYf5QbxMdFwrOcAFCUSEa2JgAdWV+mxTxZFuhxSN1eTPWApT7jnmwDJCTbf3b8JFOZ2h+alK9iYsnuyP29+1J3ob0etXjUB3fL0fjl/tS3Y/0kBHDg7AEa23M8PGmWNAe6hceRALcMiUv0yVe3Sja1pQrvZftqLjHTggX4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632641; c=relaxed/simple;
	bh=wmmGhXwh/KuaVk63AF3b9BHNtF3hHfZf+qN5/ny5diI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKjCcsuF3WYfEgHukLxYt5BSRiMn/W4uhDrfn8cMR2PNVHPgaHjLpUPIyx3GxOMnEEMjgWihdyM2sHWqrk0vwK6KWnYMSaQkc/D0Izk9NdHtXVMFtpFYXpGn6YpL6gdsc8jLxrOwBvbgEhdcGAg0LDrygD64lSdD9xR79PrUiOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWgIywsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWgIywsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCB21F000E9;
	Tue, 16 Jun 2026 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632640;
	bh=bKjLu9lKWHqBksY+1iThrmFkdvLfj9Nfnuitip1Zi3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWgIywsrJpBAuW6eVf/VoNpoAqkfxM9Kw7Gub1YkpH3+Kne9mfNTP/jjwEIdblJxo
	 07v7Jbyh4jUFHL0kvqy3baL0fAgbvYtv9X/WJTYbwtM/gktI9t1zW2disezSLBZQju
	 BjaD7c3xwRnYdB/pn0BTZnCTeAVcgdGotORjNypg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 450/522] platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery
Date: Tue, 16 Jun 2026 20:29:57 +0530
Message-ID: <20260616145146.970751711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/intel/vsec.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -401,6 +401,17 @@ static bool intel_vsec_get_features(stru
 	return found;
 }
 
+static int intel_vsec_pci_init(struct pci_dev *pdev)
+{
+	struct vsec_priv *priv = pci_get_drvdata(pdev);
+	const struct intel_vsec_platform_info *info = priv->info;
+
+	if (!intel_vsec_get_features(pdev, info))
+		return -ENODEV;
+
+	return 0;
+}
+
 static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	const struct intel_vsec_platform_info *info;
@@ -423,10 +434,7 @@ static int intel_vsec_pci_probe(struct p
 	priv->info = info;
 	pci_set_drvdata(pdev, priv);
 
-	if (!intel_vsec_get_features(pdev, info))
-		return -ENODEV;
-
-	return 0;
+	return intel_vsec_pci_init(pdev);
 }
 
 /* TGL info */
@@ -489,7 +497,6 @@ static pci_ers_result_t intel_vsec_pci_s
 {
 	struct intel_vsec_device *intel_vsec_dev;
 	pci_ers_result_t status = PCI_ERS_RESULT_DISCONNECT;
-	const struct pci_device_id *pci_dev_id;
 	unsigned long index;
 
 	dev_info(&pdev->dev, "Resetting PCI slot\n");
@@ -510,10 +517,8 @@ static pci_ers_result_t intel_vsec_pci_s
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


