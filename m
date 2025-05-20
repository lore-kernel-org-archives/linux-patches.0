Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC022F37;
	Tue, 20 May 2025 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749990; cv=none; b=p81S4yyitaUc42Zuq1/0bc171Vh5n1rO/RfEDDv/H0F1sBdUDawHIoVSeNJ17s6hFI1Ps74qg0FZ0pDUpD/oZ4BsKA7V+SmsI7E7VEvTn0yDBUQ6NUcs7Sh/ZGFdyirovDruPoJX2QMoenoQlAJOn+B97muqRLyvDWQoncMDUbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749990; c=relaxed/simple;
	bh=nJctjtODrgE9/l7oYR1Mfmtmvx6UO/67q6WCHW1BVsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDKHiW8/bFC8ggTxLNuIUkyZ4FcZJuGaRvcFcllHshOJoRJUYJUcwm7WbIABWIzWAldXKTX/MwO6F+KkG5NCslOWi5yiDX4EXA+fodVTf3LQxDgQALqm2/nvjbLDQ/F1YXIfZza12Aihqt490f/5VEej3Mdt/vn+r3iC5sYcKdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWKlnZXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWKlnZXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7102C4CEE9;
	Tue, 20 May 2025 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749990;
	bh=nJctjtODrgE9/l7oYR1Mfmtmvx6UO/67q6WCHW1BVsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWKlnZXM/qOWCN7UANWjbaY4tKhVGfB8J53El7Sxh9WLOGZ2aEeBczWMFKFNgs4kO
	 mVLEz9N81ca+CDp8EeH5DUKY6lsoX23COxXr2CC8V1BXiHmyVxErpKqdnJFxVHP/Cx
	 F1a0teEU+npoPOFtb3mwi+f2FXeEODG/4Xy+UhOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 117/117] drm/amdgpu: fix pm notifier handling
Date: Tue, 20 May 2025 15:51:22 +0200
Message-ID: <20250520125808.640070911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4aaffc85751da5722e858e4333e8cf0aa4b6c78f upstream.

Set the s3/s0ix and s4 flags in the pm notifier so that we can skip
the resource evictions properly in pm prepare based on whether
we are suspending or hibernating.  Drop the eviction as processes
are not frozen at this time, we we can end up getting stuck trying
to evict VRAM while applications continue to submit work which
causes the buffers to get pulled back into VRAM.

v2: Move suspend flags out of pm notifier (Mario)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4178
Fixes: 2965e6355dcd ("drm/amd: Add Suspend/Hibernate notification callback support")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 06f2dcc241e7e5c681f81fbc46cacdf4bfd7d6d7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   18 +++++-------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c    |   10 +---------
 2 files changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4125,28 +4125,20 @@ static int amdgpu_device_evict_resources
  * @data: data
  *
  * This function is called when the system is about to suspend or hibernate.
- * It is used to evict resources from the device before the system goes to
- * sleep while there is still access to swap.
+ * It is used to set the appropriate flags so that eviction can be optimized
+ * in the pm prepare callback.
  */
 static int amdgpu_device_pm_notifier(struct notifier_block *nb, unsigned long mode,
 				     void *data)
 {
 	struct amdgpu_device *adev = container_of(nb, struct amdgpu_device, pm_nb);
-	int r;
 
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 		adev->in_s4 = true;
-		fallthrough;
-	case PM_SUSPEND_PREPARE:
-		r = amdgpu_device_evict_resources(adev);
-		/*
-		 * This is considered non-fatal at this time because
-		 * amdgpu_device_prepare() will also fatally evict resources.
-		 * See https://gitlab.freedesktop.org/drm/amd/-/issues/3781
-		 */
-		if (r)
-			drm_warn(adev_to_drm(adev), "Failed to evict resources, freeze active processes if problems occur: %d\n", r);
+		break;
+	case PM_POST_HIBERNATION:
+		adev->in_s4 = false;
 		break;
 	}
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2475,13 +2475,8 @@ static int amdgpu_pmops_freeze(struct de
 static int amdgpu_pmops_thaw(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-	int r;
 
-	r = amdgpu_device_resume(drm_dev, true);
-	adev->in_s4 = false;
-
-	return r;
+	return amdgpu_device_resume(drm_dev, true);
 }
 
 static int amdgpu_pmops_poweroff(struct device *dev)
@@ -2494,9 +2489,6 @@ static int amdgpu_pmops_poweroff(struct
 static int amdgpu_pmops_restore(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-
-	adev->in_s4 = false;
 
 	return amdgpu_device_resume(drm_dev, true);
 }


