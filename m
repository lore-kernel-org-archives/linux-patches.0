Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F74472534;
	Tue, 21 Jul 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664948; cv=none; b=Rvt2xkuoKf/EkEtyrWXna9UdJ77tZJz3ql9+1ieikT2DHZyXVRkrURqApepFELpYJcy3qn9KwFOo3le8DJh26bz44SmHXApC0QluxaaC1NXDgThA6hIACp7llfBuekuB3RwufjwjLJsPvqZok9krATqxfpePCBo86tR45Xz6B8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664948; c=relaxed/simple;
	bh=JBGP43NTkM5369krIHBMRPUfUJ3YLNDrFT2msn5aCtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4uAbXk/byHdSDMbBofO4SOUsgjurTbZWDGYc01UxCoTGaXPudT//FnSqusnsQ3cCO3o+2sYKM8+k6c9DwJbgh4tlQifhwkDZ0hp06DNcwvzlXzb90Dxm3T7Iq0RHhgeTzTbasSWbRmh5ucoTE5xAd8Ar+BT/YKE5f/cECRBc18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJMWebZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJMWebZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B511F000E9;
	Tue, 21 Jul 2026 20:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664947;
	bh=CykYx6+nvh2WgnjwWdaOmP6fAnBkPQEp/O5IyJOhEYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJMWebZORhYgkm/zs5R1AC3aQCUPYB/Bx7JlLnP5tDft/deBes62HxRK98SKQXlqY
	 XvqTxeWAnlTjC/yoJ3K0+H3SzVj6VSQvL+fWuefTaL/A6jEOBQYSiwd3oBJeTYtslH
	 q1izQigiMFfMZQJZA2dwVUH8BsiTX+lYaLr1P/Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.6 0118/1266] vfio/pci: Latch disable_idle_d3 per device
Date: Tue, 21 Jul 2026 17:09:15 +0200
Message-ID: <20260721152444.441000517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@nvidia.com>

commit 4575e9aac5336d1365138c0284773bf8da4b1fa3 upstream.

When disable_idle_d3 was introduced in vfio-pci, it directly manipulated
the device power state with pci_set_power_state().  There were no
refcounts to maintain or balanced operations, we could unconditionally
bring the device to D0 and conditionally move it to D3hot.  Therefore
the module parameter was made writable.

Later, in commit c61302aa48f7 ("vfio/pci: Move module parameters to
vfio_pci.c"), as part of the vfio-pci-core split, the writable aspect
of the module parameter was nullified.  The parameter value could still
be changed through sysfs, but the vfio-pci driver latched the values
into vfio-pci-core globals at module init.  Loading the vfio-pci module,
or unloading and reloading, with non-default or different values could
change the globals relative to existing devices bound to vfio-pci
variant drivers.

Runtime PM was introduced in commit 7ab5e10eda02 ("vfio/pci: Move the
unused device into low power state with runtime PM"), which marks the
point where power states became refcounted.  PM get and put operations
need to be balanced, but the same module operations noted above can
change the global variables relative to those devices already bound to
vfio-pci variant drivers.  This introduces a window where PM operations
can now become unbalanced.

To resolve this with a narrow footprint for stable backports, the
disable_idle_d3 flag is latched into the vfio_pci_core_device at the
time of initialization, such that the device always operates with a
consistent value.

NB. vfio_pci_dev_set_try_reset() now unconditionally raises the
runtime PM usage count around bus reset to account for disable_idle_d3
becoming a per-device rather than global flag.  When this flag is set,
the additional get/put pair is harmless and allows continued use of the
shared vfio_pci_dev_set_pm_runtime_get() helper.

Fixes: 7ab5e10eda02 ("vfio/pci: Move the unused device into low power state with runtime PM")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-2-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_core.c |   19 ++++++++++---------
 include/linux/vfio_pci_core.h    |    1 +
 2 files changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -477,7 +477,7 @@ int vfio_pci_core_enable(struct vfio_pci
 	u16 cmd;
 	u8 msix_pos;
 
-	if (!disable_idle_d3) {
+	if (!vdev->disable_idle_d3) {
 		ret = pm_runtime_resume_and_get(&pdev->dev);
 		if (ret < 0)
 			return ret;
@@ -555,7 +555,7 @@ out_free_state:
 out_disable_device:
 	pci_disable_device(pdev);
 out_power:
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		pm_runtime_put(&pdev->dev);
 	return ret;
 }
@@ -682,7 +682,7 @@ out:
 	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
 
 	/* Put the pm-runtime usage counter acquired during enable */
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		pm_runtime_put(&pdev->dev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
@@ -2058,6 +2058,8 @@ int vfio_pci_core_init_dev(struct vfio_d
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
+	vdev->disable_idle_d3 = disable_idle_d3;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_init_dev);
@@ -2149,7 +2151,7 @@ int vfio_pci_core_register_device(struct
 
 	dev->driver->pm = &vfio_pci_core_pm_ops;
 	pm_runtime_allow(dev);
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		pm_runtime_put(dev);
 
 	ret = vfio_register_group_dev(&vdev->vdev);
@@ -2158,7 +2160,7 @@ int vfio_pci_core_register_device(struct
 	return 0;
 
 out_power:
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		pm_runtime_get_noresume(dev);
 
 	pm_runtime_forbid(dev);
@@ -2177,7 +2179,7 @@ void vfio_pci_core_unregister_device(str
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_vga_uninit(vdev);
 
-	if (!disable_idle_d3)
+	if (!vdev->disable_idle_d3)
 		pm_runtime_get_noresume(&vdev->pdev->dev);
 
 	pm_runtime_forbid(&vdev->pdev->dev);
@@ -2505,7 +2507,7 @@ static void vfio_pci_dev_set_try_reset(s
 	 * state. Increment the usage count for all the devices in the dev_set
 	 * before reset and decrement the same after reset.
 	 */
-	if (!disable_idle_d3 && vfio_pci_dev_set_pm_runtime_get(dev_set))
+	if (vfio_pci_dev_set_pm_runtime_get(dev_set))
 		return;
 
 	if (!pci_reset_bus(pdev))
@@ -2515,8 +2517,7 @@ static void vfio_pci_dev_set_try_reset(s
 		if (reset_done)
 			cur->needs_reset = false;
 
-		if (!disable_idle_d3)
-			pm_runtime_put(&cur->pdev->dev);
+		pm_runtime_put(&cur->pdev->dev);
 	}
 }
 
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -80,6 +80,7 @@ struct vfio_pci_core_device {
 	bool			needs_pm_restore:1;
 	bool			pm_intx_masked:1;
 	bool			pm_runtime_engaged:1;
+	bool			disable_idle_d3:1;
 	bool			sriov_active;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;


