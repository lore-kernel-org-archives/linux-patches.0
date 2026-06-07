Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1538B7A2;
	Sun,  7 Jun 2026 11:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830043; cv=none; b=ePjPRX8T6SrNuXdmUuDN6IIDKFYN6Ck/W25c9hYmv0e00/PlBvGk8s2+XYZa3vkuGthYHc5iURwA0R98RADF5H0IRBXffXu2/eg1OzwwYpy2WaSTPEBExucCpPuoZdyIo0OV2mmUQ+tMpSPNqxR0EQKrX/17RiGuHaSUFR43d1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830043; c=relaxed/simple;
	bh=etpNy6RSAimpma6/tU/Frskpn9TKGPsJX70fvKY++8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZnaK4wx9hAjYK9QhR4YceYV/gQSdz9Z66hMO1i/1BoLYOSFk6lIsGuGff/0YApFMscuM8KUxdXwmRRIN8ZRiLiK66vF6Y8rSQ1G88v8QhYUnRlSuqHMtvmPpPUlgDYam5VQw58r5URZz3lzv1rKGaPiXwOlj/zsWkngeJBlZekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUwYhuSg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUwYhuSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654B1F00893;
	Sun,  7 Jun 2026 11:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830041;
	bh=2D7CyNMMY2kySBERPSaOoGaLfZOgrCRkyKKKftvmpho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUwYhuSgGPVAfeh0O6xWHs4aXPUsUKYsQJVF/YAjn78praxdqMC+j31XeMiM/NjNU
	 PVcxAan86sv4KNDOg769DoRLZUz13KFyX8wuL1l0ovQbJpWIQRH/mxbsJAHEWRc/A7
	 a7a4hL7Y38m233afs3uddJiawmB0GVz3SAEHrL7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/307] platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery
Date: Sun,  7 Jun 2026 12:01:13 +0200
Message-ID: <20260607095737.863034376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
 drivers/platform/x86/intel/vsec.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -348,20 +348,10 @@ void intel_vsec_register(struct pci_dev
 }
 EXPORT_SYMBOL_NS_GPL(intel_vsec_register, INTEL_VSEC);
 
-static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int intel_vsec_pci_init(struct pci_dev *pdev,
+			       struct intel_vsec_platform_info *info)
 {
-	struct intel_vsec_platform_info *info;
 	bool have_devices = false;
-	int ret;
-
-	ret = pcim_enable_device(pdev);
-	if (ret)
-		return ret;
-
-	pci_save_state(pdev);
-	info = (struct intel_vsec_platform_info *)id->driver_data;
-	if (!info)
-		return -EINVAL;
 
 	if (intel_vsec_walk_dvsec(pdev, info))
 		have_devices = true;
@@ -379,6 +369,23 @@ static int intel_vsec_pci_probe(struct p
 	return 0;
 }
 
+static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct intel_vsec_platform_info *info;
+	int ret;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_save_state(pdev);
+	info = (struct intel_vsec_platform_info *)id->driver_data;
+	if (!info)
+		return -EINVAL;
+
+	return intel_vsec_pci_init(pdev, info);
+}
+
 /* DG1 info */
 static struct intel_vsec_header dg1_header = {
 	.length = 0x10,
@@ -467,6 +474,7 @@ static pci_ers_result_t intel_vsec_pci_e
 static pci_ers_result_t intel_vsec_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct intel_vsec_device *intel_vsec_dev;
+	struct intel_vsec_platform_info *info;
 	pci_ers_result_t status = PCI_ERS_RESULT_DISCONNECT;
 	const struct pci_device_id *pci_dev_id;
 	unsigned long index;
@@ -489,10 +497,10 @@ static pci_ers_result_t intel_vsec_pci_s
 		devm_release_action(&pdev->dev, intel_vsec_remove_aux,
 				    &intel_vsec_dev->auxdev);
 	}
-	pci_disable_device(pdev);
 	pci_restore_state(pdev);
 	pci_dev_id = pci_match_id(intel_vsec_pci_ids, pdev);
-	intel_vsec_pci_probe(pdev, pci_dev_id);
+	info = (struct intel_vsec_platform_info *)pci_dev_id->driver_data;
+	intel_vsec_pci_init(pdev, info);
 
 out:
 	return status;


