Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D31522C325;
	Tue, 20 May 2025 13:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749352; cv=none; b=ZDoi16EqcIxSJ65FPoEa34f7IhbvJrp6OKjUKTCxY/hlP0bKOHaXPpQtLbGvAL3oR7sGXpPWztkuIGFcNfHhmqmdwRBowi4msHK+jST1Cg/pAhOe2tpEctBLvnlHJSsbw58X88VMLiIlCPQkC8FWOgkr2j5cchbMke5nmNwNyso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749352; c=relaxed/simple;
	bh=iKv360UFb1pn7vWuNJDCbvFhTVOqmO1oZ1eX2Sy6qLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W828JhwNhT3+ZRV8d6mRMlhfOdNYq/6T/5/Rvj73Al4c8vhOMYeLgtIxqpP6vFWHvBGZxLLqf7pM3QM78hu6PlJfilefMARswmUd0t2yBuxX7C16r/dGsHDwRBNiF54fdL4r9ROEcL+JDa86jydwar5MweinZ52Dcd3r1GY/o5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAIP2IsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAIP2IsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97146C4CEE9;
	Tue, 20 May 2025 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749352;
	bh=iKv360UFb1pn7vWuNJDCbvFhTVOqmO1oZ1eX2Sy6qLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAIP2IsRjLLFl05H9d91L5+JmM6GuHhMEQyJVvtk7Hx5pSs3SX9K+6hzHwctV0G+S
	 o86dkdKxdFo3y5hsqw+IKXhrY9NbfRI0wWbIVgZ5WTXagKq47NeWsJOngRFriuR7PO
	 CBUbRq9uZpHI5HnxmcRDIfm8/3wdWTiW7vDYCWi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/97] drm/amd: Add Suspend/Hibernate notification callback support
Date: Tue, 20 May 2025 15:49:42 +0200
Message-ID: <20250520125801.342954780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 705703bab2fdd..019a83c7170d4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -781,6 +781,7 @@ struct amdgpu_device {
 	bool				need_swiotlb;
 	bool				accel_working;
 	struct notifier_block		acpi_nb;
+	struct notifier_block		pm_nb;
 	struct amdgpu_i2c_chan		*i2c_bus[AMDGPU_MAX_I2C_BUS];
 	struct debugfs_blob_wrapper     debugfs_vbios_blob;
 	struct debugfs_blob_wrapper     debugfs_discovery_blob;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index aac0e49f77c7f..32c571e9288ae 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -140,6 +140,8 @@ const char *amdgpu_asic_name[] = {
 };
 
 static inline void amdgpu_device_stop_pending_resets(struct amdgpu_device *adev);
+static int amdgpu_device_pm_notifier(struct notifier_block *nb, unsigned long mode,
+				     void *data);
 
 /**
  * DOC: pcie_replay_count
@@ -3992,6 +3994,11 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 
 	amdgpu_device_check_iommu_direct_map(adev);
 
+	adev->pm_nb.notifier_call = amdgpu_device_pm_notifier;
+	r = register_pm_notifier(&adev->pm_nb);
+	if (r)
+		goto failed;
+
 	return 0;
 
 release_ras_con:
@@ -4053,6 +4060,8 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 	flush_delayed_work(&adev->delayed_init_work);
 	adev->shutdown = true;
 
+	unregister_pm_notifier(&adev->pm_nb);
+
 	/* make sure IB test finished before entering exclusive mode
 	 * to avoid preemption on IB test
 	 * */
@@ -4183,6 +4192,41 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
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
@@ -4222,7 +4266,7 @@ int amdgpu_device_prepare(struct drm_device *dev)
 	return 0;
 
 unprepare:
-	adev->in_s0ix = adev->in_s3 = false;
+	adev->in_s0ix = adev->in_s3 = adev->in_s4 = false;
 
 	return r;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 0a85a59519cac..06958608c9849 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2468,7 +2468,6 @@ static int amdgpu_pmops_freeze(struct device *dev)
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 	int r;
 
-	adev->in_s4 = true;
 	r = amdgpu_device_suspend(drm_dev, true);
 	if (r)
 		return r;
-- 
2.39.5



