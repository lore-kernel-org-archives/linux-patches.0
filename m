Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9526C7FBD0;
	Mon,  8 Apr 2024 13:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581996; cv=none; b=ndl/+tG6sExdS+Ud8Wm4fJBilzzbIyTZuN9fa4hn5mjuH9Y1NHdaemYMttptpmuCD8Z+Z9dIBZWI4iMX5/Gv1POPsDn0+g3AGtEBqVreqG7bLM8zrQlUq0VHGOP9OEncqPpSF2cbZyn7vXczOsFBWTWXFGSTViSFJoOAVEWNH04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581996; c=relaxed/simple;
	bh=hPO4rI/D5KzJ7gA7CWg3nlSBPDBRqkJju2brtbQa8dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uzRjc6RVoCcshz85rs9gjfarUL8Le5DumRCD6bO7hl77j5EgdUEyunio18VvwkBXKuhQjeChWKkkWh1ErkMjjGdhaUrs4H7GRIsA4q5nvECzHyUQEfMnjIsG4lOPClsVgGSPUK1E5dtxSEmEaIO8O7iU+MI8Wi4Ahg3JAvrKrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHnqyAM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHnqyAM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCEEC433C7;
	Mon,  8 Apr 2024 13:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581996;
	bh=hPO4rI/D5KzJ7gA7CWg3nlSBPDBRqkJju2brtbQa8dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHnqyAM4jozYZp8GiLMBV/aIlcGzL4K2J3Ii58FHh0mqwJSa0/lzPWKIIQsdE6hH4
	 ADhCrwazKUZkypGRoFk+RIQ25tbmK/we8vOwDb3aNED337Oau1vd7z0SfNsPrhhi+x
	 DiXv1h/wmsC00oViZI/Fm7KXboTK7E9Kp+JP1T7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/138] drm/amd: Evict resources during PM ops prepare() callback
Date: Mon,  8 Apr 2024 14:58:04 +0200
Message-ID: <20240408125258.399082065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 5095d5418193eb2748c7d8553c7150b8f1c44696 ]

Linux PM core has a prepare() callback run before suspend.

If the system is under high memory pressure, the resources may need
to be evicted into swap instead.  If the storage backing for swap
is offlined during the suspend() step then such a call may fail.

So move this step into prepare() to move evict majority of
resources and update all non-pmops callers to call the same callback.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2362
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ca299b4512d4 ("drm/amd: Flush GFXOFF requests in prepare stage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 26 ++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    | 10 ++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index e636c7850f777..dd22d2559720c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1342,6 +1342,7 @@ void amdgpu_driver_postclose_kms(struct drm_device *dev,
 void amdgpu_driver_release_kms(struct drm_device *dev);
 
 int amdgpu_device_ip_suspend(struct amdgpu_device *adev);
+int amdgpu_device_prepare(struct drm_device *dev);
 int amdgpu_device_suspend(struct drm_device *dev, bool fbcon);
 int amdgpu_device_resume(struct drm_device *dev, bool fbcon);
 u32 amdgpu_get_vblank_counter_kms(struct drm_crtc *crtc);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 6a4749c0c5a58..902a446cc4d38 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1639,6 +1639,7 @@ static void amdgpu_switcheroo_set_state(struct pci_dev *pdev,
 	} else {
 		pr_info("switched off\n");
 		dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
+		amdgpu_device_prepare(dev);
 		amdgpu_device_suspend(dev, true);
 		amdgpu_device_cache_pci_state(pdev);
 		/* Shut down the device */
@@ -4167,6 +4168,31 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 /*
  * Suspend & resume.
  */
+/**
+ * amdgpu_device_prepare - prepare for device suspend
+ *
+ * @dev: drm dev pointer
+ *
+ * Prepare to put the hw in the suspend state (all asics).
+ * Returns 0 for success or an error on failure.
+ * Called at driver suspend.
+ */
+int amdgpu_device_prepare(struct drm_device *dev)
+{
+	struct amdgpu_device *adev = drm_to_adev(dev);
+	int r;
+
+	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return 0;
+
+	/* Evict the majority of BOs before starting suspend sequence */
+	r = amdgpu_device_evict_resources(adev);
+	if (r)
+		return r;
+
+	return 0;
+}
+
 /**
  * amdgpu_device_suspend - initiate device suspend
  *
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index f24c3a20e901d..9a5416331f02e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2391,8 +2391,9 @@ static int amdgpu_pmops_prepare(struct device *dev)
 	/* Return a positive number here so
 	 * DPM_FLAG_SMART_SUSPEND works properly
 	 */
-	if (amdgpu_device_supports_boco(drm_dev))
-		return pm_runtime_suspended(dev);
+	if (amdgpu_device_supports_boco(drm_dev) &&
+	    pm_runtime_suspended(dev))
+		return 1;
 
 	/* if we will not support s3 or s2i for the device
 	 *  then skip suspend
@@ -2401,7 +2402,7 @@ static int amdgpu_pmops_prepare(struct device *dev)
 	    !amdgpu_acpi_is_s3_active(adev))
 		return 1;
 
-	return 0;
+	return amdgpu_device_prepare(drm_dev);
 }
 
 static void amdgpu_pmops_complete(struct device *dev)
@@ -2600,6 +2601,9 @@ static int amdgpu_pmops_runtime_suspend(struct device *dev)
 	if (amdgpu_device_supports_boco(drm_dev))
 		adev->mp1_state = PP_MP1_STATE_UNLOAD;
 
+	ret = amdgpu_device_prepare(drm_dev);
+	if (ret)
+		return ret;
 	ret = amdgpu_device_suspend(drm_dev, false);
 	if (ret) {
 		adev->in_runpm = false;
-- 
2.43.0



