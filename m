Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE381C5D57;
	Wed,  4 Feb 2026 15:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219064; cv=none; b=bjG4pnwgGGJubuBFsm4DiuSdLbp85L2L6UcreoyqD9bV+d926cHrLP4YoZK+9zoR4+TiqO2RirhFO1iZDDzRnjk1p32SGyBp/da2j6flM96lX0v2dm+2tpfFWjVcuhA3Vj7Ngbh1Gh1nWOHUiG+LmZVURDjtqIONlAEpzZjQCrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219064; c=relaxed/simple;
	bh=Yz/dGmxN6n3a3j4OyyOPmQe6AIxVW1LzwDQekEZVVc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RdMlpaDy/83MJdJNlEgn542YAjbcbW2wn/Yf3bnjH/0nEpF2WN6yxQxS9K+zOqizWWguZ9fDxPHJnO4lusPdZUEagsI5xuZJk1gi6qKUDmZ9MZQv/ij30Es+8uag8tEN4e5qXFdMzq68VrH/WqK8UR3IYIySIQqPAjui2HVYd50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0SUudJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0SUudJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11100C4CEF7;
	Wed,  4 Feb 2026 15:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219064;
	bh=Yz/dGmxN6n3a3j4OyyOPmQe6AIxVW1LzwDQekEZVVc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0SUudJDem+m/emkWDdWHPkW0NY4T+WcdkHHjPjbeOjehzIqXQndOItiqj/swXMhA
	 WNKOc9C9g2RTX6i+4JVBldfrm6PX/qPkE54Y5DyxQNWqkJSEYoVJ5yB1LrQnjg3lIc
	 UC3A7Ud5toSu9k/HKkno2dApB/hmWPZqnGjcpb8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Brian Nguyen <brian3.nguyen@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/122] drm/xe/nvm: Manage nvm aux cleanup with devres
Date: Wed,  4 Feb 2026 15:40:37 +0100
Message-ID: <20260204143853.834163474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 2da8fbb8f1c17129a08c1e0e42c71eabdca76062 ]

Move nvm teardown to a devm-managed action registered from xe_nvm_init().
This ensures the auxiliary NVM device is deleted on probe failure and
device detach without requiring explicit calls from remove paths.

As part of this, drop xe_nvm_fini() from xe_device_remove() and from the
survivability sysfs teardown, and remove the public xe_nvm_fini() API from
the header.

This is to fix below warn message when there is probe failure after
xe_nvm_init(), then xe_device_probe() is called again:
"
[  207.318152] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:01.0/0000:03:00.0/xe.nvm.768'
[  207.318157] CPU: 5 UID: 0 PID: 10261 Comm: modprobe Tainted: G    B   W           6.19.0-rc2-lgci-xe-kernel+ #223 PREEMPT(voluntary)
[  207.318160] Tainted: [B]=BAD_PAGE, [W]=WARN
[  207.318161] Hardware name: ASUS System Product Name/PRIME Z790-P WIFI, BIOS 0812 02/24/2023
[  207.318163] Call Trace:
[  207.318163]  <TASK>
[  207.318165]  dump_stack_lvl+0xa0/0xc0
[  207.318170]  dump_stack+0x10/0x20
[  207.318171]  sysfs_warn_dup+0xd5/0x110
[  207.318175]  sysfs_create_dir_ns+0x1f6/0x280
[  207.318177]  ? __pfx_sysfs_create_dir_ns+0x10/0x10
[  207.318179]  ? lock_acquire+0x1a4/0x2e0
[  207.318182]  ? __kasan_check_read+0x11/0x20
[  207.318185]  ? do_raw_spin_unlock+0x5c/0x240
[  207.318187]  kobject_add_internal+0x28d/0x8e0
[  207.318189]  kobject_add+0x11f/0x1f0
[  207.318191]  ? __pfx_kobject_add+0x10/0x10
[  207.318193]  ? lockdep_init_map_type+0x4b/0x230
[  207.318195]  ? get_device_parent.isra.0+0x43/0x4c0
[  207.318197]  ? kobject_get+0x55/0xf0
[  207.318199]  device_add+0x2d7/0x1500
[  207.318201]  ? __pfx_device_add+0x10/0x10
[  207.318203]  ? lockdep_init_map_type+0x4b/0x230
[  207.318205]  __auxiliary_device_add+0x99/0x140
[  207.318208]  xe_nvm_init+0x7a2/0xef0 [xe]
[  207.318333]  ? xe_devcoredump_init+0x80/0x110 [xe]
[  207.318452]  ? __devm_add_action+0x82/0xc0
[  207.318454]  ? fs_reclaim_release+0xc0/0x110
[  207.318457]  xe_device_probe+0x17dd/0x2c40 [xe]
[  207.318574]  ? __pfx___drm_dev_dbg+0x10/0x10
[  207.318576]  ? add_dr+0x180/0x220
[  207.318579]  ? __pfx___drmm_mutex_release+0x10/0x10
[  207.318582]  ? __pfx_xe_device_probe+0x10/0x10 [xe]
[  207.318697]  ? xe_pm_init_early+0x33a/0x410 [xe]
[  207.318850]  xe_pci_probe+0x936/0x1250 [xe]
[  207.318999]  ? lock_acquire+0x1a4/0x2e0
[  207.319003]  ? __pfx_xe_pci_probe+0x10/0x10 [xe]
[  207.319151]  local_pci_probe+0xe6/0x1a0
[  207.319154]  pci_device_probe+0x523/0x840
[  207.319157]  ? __pfx_pci_device_probe+0x10/0x10
[  207.319159]  ? sysfs_do_create_link_sd.isra.0+0x8c/0x110
[  207.319162]  ? sysfs_create_link+0x48/0xc0
...
"

Fixes: c28bfb107dac ("drm/xe/nvm: add on-die non-volatile memory device")
Reviewed-by: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Brian Nguyen <brian3.nguyen@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Riana Tauro <riana.tauro@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patch.msgid.link/20260120183239.2966782-6-shuicheng.lin@intel.com
(cherry picked from commit 11035eab1b7d88daa7904440046e64d3810b1ca1)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c |  2 --
 drivers/gpu/drm/xe/xe_nvm.c    | 43 +++++++++++++++++-----------------
 drivers/gpu/drm/xe/xe_nvm.h    |  2 --
 3 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 5f757790d6f53..fe5aadb27b779 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -974,8 +974,6 @@ void xe_device_remove(struct xe_device *xe)
 {
 	xe_display_unregister(xe);
 
-	xe_nvm_fini(xe);
-
 	drm_dev_unplug(&xe->drm);
 
 	xe_bo_pci_dev_remove_all(xe);
diff --git a/drivers/gpu/drm/xe/xe_nvm.c b/drivers/gpu/drm/xe/xe_nvm.c
index 33f4ac82fc80a..1fff24dbc7cd4 100644
--- a/drivers/gpu/drm/xe/xe_nvm.c
+++ b/drivers/gpu/drm/xe/xe_nvm.c
@@ -83,6 +83,27 @@ static bool xe_nvm_writable_override(struct xe_device *xe)
 	return writable_override;
 }
 
+static void xe_nvm_fini(void *arg)
+{
+	struct xe_device *xe = arg;
+	struct intel_dg_nvm_dev *nvm = xe->nvm;
+
+	if (!xe->info.has_gsc_nvm)
+		return;
+
+	/* No access to internal NVM from VFs */
+	if (IS_SRIOV_VF(xe))
+		return;
+
+	/* Nvm pointer should not be NULL here */
+	if (WARN_ON(!nvm))
+		return;
+
+	auxiliary_device_delete(&nvm->aux_dev);
+	auxiliary_device_uninit(&nvm->aux_dev);
+	xe->nvm = NULL;
+}
+
 int xe_nvm_init(struct xe_device *xe)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
@@ -141,30 +162,10 @@ int xe_nvm_init(struct xe_device *xe)
 		auxiliary_device_uninit(aux_dev);
 		goto err;
 	}
-	return 0;
+	return devm_add_action_or_reset(xe->drm.dev, xe_nvm_fini, xe);
 
 err:
 	kfree(nvm);
 	xe->nvm = NULL;
 	return ret;
 }
-
-void xe_nvm_fini(struct xe_device *xe)
-{
-	struct intel_dg_nvm_dev *nvm = xe->nvm;
-
-	if (!xe->info.has_gsc_nvm)
-		return;
-
-	/* No access to internal NVM from VFs */
-	if (IS_SRIOV_VF(xe))
-		return;
-
-	/* Nvm pointer should not be NULL here */
-	if (WARN_ON(!nvm))
-		return;
-
-	auxiliary_device_delete(&nvm->aux_dev);
-	auxiliary_device_uninit(&nvm->aux_dev);
-	xe->nvm = NULL;
-}
diff --git a/drivers/gpu/drm/xe/xe_nvm.h b/drivers/gpu/drm/xe/xe_nvm.h
index 7f3d5f57bed08..fd3467ad35a4d 100644
--- a/drivers/gpu/drm/xe/xe_nvm.h
+++ b/drivers/gpu/drm/xe/xe_nvm.h
@@ -10,6 +10,4 @@ struct xe_device;
 
 int xe_nvm_init(struct xe_device *xe);
 
-void xe_nvm_fini(struct xe_device *xe);
-
 #endif
-- 
2.51.0



