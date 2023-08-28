Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1CB469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2FAC433C7;
	Mon, 28 Aug 2023 10:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218811;
	bh=I0N5GY4DFedXWregs66XJVCAiZGkmjPM9vIGcO1GgI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0HUGPkSm3cy8zOSDGX7RVv/U6js9ZY7nwmNeNePCYPCkg4ud45qhh9aJPtwRzqeZ
	 KO/3zupPGcfW1vj6cdzU5R9DjM7XKiDnXSfYyu9T5YSfJxPtzaAslM8cJua8QK2h0N
	 qyMEyYGyISQp6q/9ZUQxe2gJf84CegEjp9mi7fu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Anshuman Gupta <anshuman.gupta@intel.com>,
	Aaron Ma <aaron.ma@canonical.com>,
	Jianshui Yu <Jianshui.yu@intel.com>
Subject: [PATCH 6.1 093/122] drm/i915/dgfx: Enable d3cold at s2idle
Date: Mon, 28 Aug 2023 12:13:28 +0200
Message-ID: <20230828101159.492816543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Anshuman Gupta <anshuman.gupta@intel.com>

commit 2872144aec04baa7e43ecd2a60f7f0be3aa843fd upstream.

System wide suspend already has support for lmem save/restore during
suspend therefore enabling d3cold for s2idle and keepng it disable for
runtime PM.(Refer below commit for d3cold runtime PM disable justification)
'commit 66eb93e71a7a ("drm/i915/dgfx: Keep PCI autosuspend control
'on' by default on all dGPU")'

It will reduce the DG2 Card power consumption to ~0 Watt
for s2idle power KPI.

v2:
- Added "Cc: stable@vger.kernel.org".

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8755
Cc: stable@vger.kernel.org
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Tested-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Jianshui Yu <Jianshui.yu@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230816125216.1722002-1-anshuman.gupta@intel.com
(cherry picked from commit 2643e6d1f2a5e51877be24042d53cf956589be10)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_driver.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -574,7 +574,6 @@ static int i915_pcode_init(struct drm_i9
 static int i915_driver_hw_probe(struct drm_i915_private *dev_priv)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
-	struct pci_dev *root_pdev;
 	int ret;
 
 	if (i915_inject_probe_failure(dev_priv))
@@ -686,15 +685,6 @@ static int i915_driver_hw_probe(struct d
 
 	intel_bw_init_hw(dev_priv);
 
-	/*
-	 * FIXME: Temporary hammer to avoid freezing the machine on our DGFX
-	 * This should be totally removed when we handle the pci states properly
-	 * on runtime PM and on s2idle cases.
-	 */
-	root_pdev = pcie_find_root_port(pdev);
-	if (root_pdev)
-		pci_d3cold_disable(root_pdev);
-
 	return 0;
 
 err_msi:
@@ -718,16 +708,11 @@ err_perf:
 static void i915_driver_hw_remove(struct drm_i915_private *dev_priv)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
-	struct pci_dev *root_pdev;
 
 	i915_perf_fini(dev_priv);
 
 	if (pdev->msi_enabled)
 		pci_disable_msi(pdev);
-
-	root_pdev = pcie_find_root_port(pdev);
-	if (root_pdev)
-		pci_d3cold_enable(root_pdev);
 }
 
 /**
@@ -1625,6 +1610,8 @@ static int intel_runtime_suspend(struct
 {
 	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
 	struct intel_runtime_pm *rpm = &dev_priv->runtime_pm;
+	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
+	struct pci_dev *root_pdev;
 	struct intel_gt *gt;
 	int ret, i;
 
@@ -1674,6 +1661,15 @@ static int intel_runtime_suspend(struct
 		drm_err(&dev_priv->drm,
 			"Unclaimed access detected prior to suspending\n");
 
+	/*
+	 * FIXME: Temporary hammer to avoid freezing the machine on our DGFX
+	 * This should be totally removed when we handle the pci states properly
+	 * on runtime PM.
+	 */
+	root_pdev = pcie_find_root_port(pdev);
+	if (root_pdev)
+		pci_d3cold_disable(root_pdev);
+
 	rpm->suspended = true;
 
 	/*
@@ -1712,6 +1708,8 @@ static int intel_runtime_resume(struct d
 {
 	struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
 	struct intel_runtime_pm *rpm = &dev_priv->runtime_pm;
+	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
+	struct pci_dev *root_pdev;
 	struct intel_gt *gt;
 	int ret, i;
 
@@ -1725,6 +1723,11 @@ static int intel_runtime_resume(struct d
 
 	intel_opregion_notify_adapter(dev_priv, PCI_D0);
 	rpm->suspended = false;
+
+	root_pdev = pcie_find_root_port(pdev);
+	if (root_pdev)
+		pci_d3cold_enable(root_pdev);
+
 	if (intel_uncore_unclaimed_mmio(&dev_priv->uncore))
 		drm_dbg(&dev_priv->drm,
 			"Unclaimed access during suspend, bios?\n");


