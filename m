Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FCC242D7C;
	Tue, 20 May 2025 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750028; cv=none; b=thTSTrlyjETVJlIls/SQ1/QURFQ6cfbIN9EsKpTnrtsw1dizEunT00RrbQpdZVE3f9ssWJyT6oxLsD9n8qNvVpWvmQY+3ZpIplIMZ+gK4Px5XH+4SlVKsLgngp3vo6GlqdYRW3I/Djoxf2VGX8QDXiKhGE8l1IJHS33gYh9Dwtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750028; c=relaxed/simple;
	bh=OF08kxs10Kw8g6fQgfoBFPF1I494xIW0OXkQ1csFuSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+HYOL/AMDBahiOPXVPaHVDa7bmX78gxMAoYjIc9DAFzuuxzkxw2K/NAfhkk/0q7FjoSwoOgT+EkKPPj8EuQj6S0LSohXW7IRC9kcOqTTPIkcls9LVFYW2axFk5CaaiPGZZsbXUdctJa5zqL8GVE5hpfVpi0tsa+BE50mzVkc0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9CyUR/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9CyUR/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27090C4CEE9;
	Tue, 20 May 2025 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750027;
	bh=OF08kxs10Kw8g6fQgfoBFPF1I494xIW0OXkQ1csFuSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9CyUR/K7VlkviTVZNqvOlph+d88uBjkl1vLOZbhy3bOyp9U03JwD6mbp1AB9kJ6M
	 v6AE2FOvtpEkxRrhi3wcoiDTOd0J/BFJ+tLDupbeglE7ub1mFdag7FFg9pjcXKG+w5
	 HEFge/U05lABg2SMNCtIwhiQpLsHrTrmLb9G8gzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/143] drm/amd: Add Suspend/Hibernate notification callback support
Date: Tue, 20 May 2025 15:49:34 +0200
Message-ID: <20250520125810.813283769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2965e6355dcdf157b5fafa25a2715f00064da8bf ]

As part of the suspend sequence VRAM needs to be evicted on dGPUs.
In order to make suspend/resume more reliable we moved this into
the pmops prepare() callback so that the suspend sequence would fail
but the system could remain operational under high memory usage suspend.

Another class of issues exist though where due to memory fragementation
there isn't a large enough contiguous space and swap isn't accessible.

Add support for a suspend/hibernate notification callback that could
evict VRAM before tasks are frozen. This should allow paging out to swap
if necessary.

Link: https://github.com/ROCm/ROCK-Kernel-Driver/issues/174
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3476
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2362
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3781
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Link: https://lore.kernel.org/r/20241128032656.2090059-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: d0ce1aaa8531 ("Revert "drm/amd: Stop evicting resources on APUs in suspend"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 46 +++++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |  1 -
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index b7aad43d9ad07..8050e0960f5e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -853,6 +853,7 @@ struct amdgpu_device {
 	bool				need_swiotlb;
 	bool				accel_working;
 	struct notifier_block		acpi_nb;
+	struct notifier_block		pm_nb;
 	struct amdgpu_i2c_chan		*i2c_bus[AMDGPU_MAX_I2C_BUS];
 	struct debugfs_blob_wrapper     debugfs_vbios_blob;
 	struct debugfs_blob_wrapper     debugfs_discovery_blob;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 24d007715a14a..e6c8426fa06ec 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -145,6 +145,8 @@ const char *amdgpu_asic_name[] = {
 };
 
 static inline void amdgpu_device_stop_pending_resets(struct amdgpu_device *adev);
+static int amdgpu_device_pm_notifier(struct notifier_block *nb, unsigned long mode,
+				     void *data);
 
 /**
  * DOC: pcie_replay_count
@@ -4519,6 +4521,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 
 	amdgpu_device_check_iommu_direct_map(adev);
 
+	adev->pm_nb.notifier_call = amdgpu_device_pm_notifier;
+	r = register_pm_notifier(&adev->pm_nb);
+	if (r)
+		goto failed;
+
 	return 0;
 
 release_ras_con:
@@ -4583,6 +4590,8 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 		drain_workqueue(adev->mman.bdev.wq);
 	adev->shutdown = true;
 
+	unregister_pm_notifier(&adev->pm_nb);
+
 	/* make sure IB test finished before entering exclusive mode
 	 * to avoid preemption on IB test
 	 */
@@ -4712,6 +4721,41 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 /*
  * Suspend & resume.
  */
+/**
+ * amdgpu_device_pm_notifier - Notification block for Suspend/Hibernate events
+ * @nb: notifier block
+ * @mode: suspend mode
+ * @data: data
+ *
+ * This function is called when the system is about to suspend or hibernate.
+ * It is used to evict resources from the device before the system goes to
+ * sleep while there is still access to swap.
+ */
+static int amdgpu_device_pm_notifier(struct notifier_block *nb, unsigned long mode,
+				     void *data)
+{
+	struct amdgpu_device *adev = container_of(nb, struct amdgpu_device, pm_nb);
+	int r;
+
+	switch (mode) {
+	case PM_HIBERNATION_PREPARE:
+		adev->in_s4 = true;
+		fallthrough;
+	case PM_SUSPEND_PREPARE:
+		r = amdgpu_device_evict_resources(adev);
+		/*
+		 * This is considered non-fatal at this time because
+		 * amdgpu_device_prepare() will also fatally evict resources.
+		 * See https://gitlab.freedesktop.org/drm/amd/-/issues/3781
+		 */
+		if (r)
+			drm_warn(adev_to_drm(adev), "Failed to evict resources, freeze active processes if problems occur: %d\n", r);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 /**
  * amdgpu_device_prepare - prepare for device suspend
  *
@@ -4751,7 +4795,7 @@ int amdgpu_device_prepare(struct drm_device *dev)
 	return 0;
 
 unprepare:
-	adev->in_s0ix = adev->in_s3 = false;
+	adev->in_s0ix = adev->in_s3 = adev->in_s4 = false;
 
 	return r;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index a9eb0927a7664..700be1ac3c64c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2635,7 +2635,6 @@ static int amdgpu_pmops_freeze(struct device *dev)
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 	int r;
 
-	adev->in_s4 = true;
 	r = amdgpu_device_suspend(drm_dev, true);
 	if (r)
 		return r;
-- 
2.39.5



