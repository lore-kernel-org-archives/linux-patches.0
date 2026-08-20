Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C223806DC;
	Thu, 20 Aug 2026 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239540; cv=none; b=gr2gMC6yAhRRDPt5U20HmGQxxYXxaGYN/sV1OL+EHW2tvJxGZ1TL8pkYBYfWJ6c5m7bUOMSIPfahESz4NOJFlw6LfQcIFvPCG50TQS5alUai4RMNW9jVF9a+TESytCrpNbrG+Ng8F30c1SdTYK5+4kBYs/L7Biro76J3+vZ7ljM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239540; c=relaxed/simple;
	bh=S7lemm8lNmHl2dXI4VI1bANMMIZIq3rGrdFI2Q3ZKS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTLf69nPQtuZXrXGxdRXdyS0rk638xHU6Hfd3Ud5LiFB7WA91MBhPTc0uABIwPRmZGATSGX5c9ma5t/mORUJeerRH2szM6s8xymb7/4LjuNFgfZabM2b+luX5hP+ZhbRLBI6TsqX8Gc1hFsq3zJMpWsIs/n8WgzpK0uwoCo1Q3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExSfVJoN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExSfVJoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20151F00A3D;
	Thu, 20 Aug 2026 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239539;
	bh=VzsvWpFkP1HFNNXmppwAEZ9C/OjP5gvFAUEV+OMJ9BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ExSfVJoNwagv8dbhJIcs83yKm4X7aQ7R4gqo9UpP5uLRt+OYN0LRL62/0aICTv6vj
	 qzNk12OgILFg10gwTSzxF8Z8yQdLUWzJZ/pbLks/hjtXx9cE0qp3SbiQC7Nv+mP4e1
	 VYhMiSvxUbsgjQjobN8bU7Fymbxl5M5/9UeybyZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 084/220] drm/amdgpu: check ASPM on the dGPU host link
Date: Thu, 20 Aug 2026 16:54:34 +0200
Message-ID: <20260820145226.008854131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit 2a9c5154a5650c09ad44ff5e1dff74754e15a3c6 upstream.

dGPUs with an internal PCIe switch expose graphics functions below the
switch downstream port. The automatic ASPM check uses the display
endpoint and evaluates the internal link instead of the host link.

Use the switch upstream port for the check and report the selected
link.

Fixes: 0ab5d711ec74 ("drm/amd: Refactor `amdgpu_aspm` to be evaluated per device")
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4e0d6f2876e704fff707b18c40dbd383aea4a1c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   50 ++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1806,6 +1806,31 @@ static bool amdgpu_device_aspm_support_q
 #endif
 }
 
+/*
+ * Some dGPUs expose their display endpoint below an internal PCIe switch.
+ * Use the switch upstream port to query the host-facing link.
+ */
+static struct pci_dev *amdgpu_device_get_aspm_pdev(struct amdgpu_device *adev)
+{
+	struct pci_dev *swds, *swus;
+
+	swds = pci_upstream_bridge(adev->pdev);
+	if (!swds ||
+	    (swds->vendor != PCI_VENDOR_ID_ATI &&
+	     swds->vendor != PCI_VENDOR_ID_AMD) ||
+	    pci_pcie_type(swds) != PCI_EXP_TYPE_DOWNSTREAM)
+		return adev->pdev;
+
+	swus = pci_upstream_bridge(swds);
+	if (!swus ||
+	    (swus->vendor != PCI_VENDOR_ID_ATI &&
+	     swus->vendor != PCI_VENDOR_ID_AMD) ||
+	    pci_pcie_type(swus) != PCI_EXP_TYPE_UPSTREAM)
+		return adev->pdev;
+
+	return swus;
+}
+
 /**
  * amdgpu_device_should_use_aspm - check if the device should program ASPM
  *
@@ -1818,6 +1843,9 @@ static bool amdgpu_device_aspm_support_q
  */
 bool amdgpu_device_should_use_aspm(struct amdgpu_device *adev)
 {
+	struct pci_dev *aspm_pdev, *parent;
+	bool enabled;
+
 	switch (amdgpu_aspm) {
 	case -1:
 		break;
@@ -1832,7 +1860,27 @@ bool amdgpu_device_should_use_aspm(struc
 		return false;
 	if (amdgpu_device_aspm_support_quirk(adev))
 		return false;
-	return pcie_aspm_enabled(adev->pdev);
+
+	/*
+	 * pcie_aspm_enabled() checks the link between its argument and
+	 * the immediate upstream bridge. Use SWUS for dGPUs with an
+	 * internal switch so that this is the host-facing link.
+	 */
+	aspm_pdev = amdgpu_device_get_aspm_pdev(adev);
+	parent = pci_upstream_bridge(aspm_pdev);
+	if (!parent) {
+		dev_dbg(adev->dev, "ASPM: no upstream PCIe link for %s\n",
+			pci_name(aspm_pdev));
+		return false;
+	}
+
+	enabled = pcie_aspm_enabled(aspm_pdev);
+	/* Report the exact link used for the automatic ASPM decision. */
+	dev_dbg(adev->dev, "ASPM: link %s <-> %s is %s\n",
+		pci_name(parent), pci_name(aspm_pdev),
+		enabled ? "enabled" : "disabled");
+
+	return enabled;
 }
 
 /* if we get transitioned to only one device, take VGA back */


