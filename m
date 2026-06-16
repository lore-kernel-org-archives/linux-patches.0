Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41180478E26;
	Tue, 16 Jun 2026 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630112; cv=none; b=FFtOqDF/qyTmWzSSBzNoNi8onAmQmI1AC+l5WpOLZZGAgy4ikL2yXWIUigb4F2s6kQvh7dMuK0zaHiBEFbzWIQye1uiz8yMjTKoB9HGC0OYi0ZcLRD4sMMTiR2WPMOmSmfGHWEpHuDUgdAdIeBWDAoJOAPASAHT8/koI6jlP1fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630112; c=relaxed/simple;
	bh=Er3op0gv+F/gseBM4adZ2K9vpWSsdHjUYJi/B4dq3qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEuwVk3JNowUlUTx5L7YFlTiTgj5V2EgtvDa3+LAHT/4SvfR8ev9Eaai62VId/qgZhkuqJSABr+syg2QU7epmpd6ukAcptg74BraSo+9aXTdrpZt5TJ8JciCrP0KNwQTjYr6u49bcwpxDu/3PDVPd/9v2x+OUKYcGtwa/8uIUSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKFFxwdN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKFFxwdN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487381F000E9;
	Tue, 16 Jun 2026 17:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630111;
	bh=LCOPL5vnOycLXMF493m7R3y3zdByUCm1fXR2PyDGsh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKFFxwdNyhKQiUAJYvRumvFql4VtFa5kbkoPd/9H7vDNj5xPr2sO00dmgjDwy3k7O
	 1EMC15iAvLwHcOBCzK0FYygsGbwtydWZFMHJp3fB8CQKfa6kChA2AlitqfDumxl/e9
	 QwVMcHqGwRrugjMu2TXPiLSsJ+5I3FAq75YA+up0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 380/452] platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery
Date: Tue, 16 Jun 2026 20:30:07 +0530
Message-ID: <20260616145136.919190550@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/intel/vsec.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -358,20 +358,10 @@ static bool intel_vsec_walk_vsec(struct
 	return have_devices;
 }
 
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
@@ -389,6 +379,23 @@ static int intel_vsec_pci_probe(struct p
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
@@ -492,10 +499,9 @@ static pci_ers_result_t intel_vsec_pci_s
 		devm_release_action(&pdev->dev, intel_vsec_remove_aux,
 				    &intel_vsec_dev->auxdev);
 	}
-	pci_disable_device(pdev);
 	pci_restore_state(pdev);
 	pci_dev_id = pci_match_id(intel_vsec_pci_ids, pdev);
-	intel_vsec_pci_probe(pdev, pci_dev_id);
+	intel_vsec_pci_init(pdev, (struct intel_vsec_platform_info *)pci_dev_id->driver_data);
 
 out:
 	return status;


