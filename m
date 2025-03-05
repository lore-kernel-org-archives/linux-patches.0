Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34F41AAE2E;
	Wed,  5 Mar 2025 18:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198334; cv=none; b=Xoz/JycsdIavHhVxq2WAkekQNniM5d0QCFx0WKbxPhGNnOqJeuGpu6jUKgnOP1EQPIAhZNNGvG6g073ChrGXkxJKrH6aBOesLE49kwdRnACPBVvRB1eewr6MLdb4HitUJJGd1vSMVBz89LIMP7lZJ341nSaX8j1S4UgLA/aUAo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198334; c=relaxed/simple;
	bh=sFtd5gPj2DSlv6fdNuLBW7oY4tu6j/cZVl9BYN2Mzp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqhCzj8gkgxHUc28rIxfWt5a8SazrWbloLVYV805DoRLabH+czJ6ajwCAfyA3+9w6YVpt9NoX//CMKYQPiMOkiGj9vvZOWR29VoH32u/niUl9CJ2b8H2wqW0xOZrlRfrvsP2iXVFyi4I8x77unCnsPWqNXCiLV4KPgd2LfbxvYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwXkpTJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwXkpTJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF2DC4CED1;
	Wed,  5 Mar 2025 18:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198334;
	bh=sFtd5gPj2DSlv6fdNuLBW7oY4tu6j/cZVl9BYN2Mzp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwXkpTJE5FmxvwE/L9uN/hS4BG+hRObDvkLoYI1EZmQzZFwaJOppWsGdRiiKNRH4l
	 VYDBtasmMwhQAWArzv/g8VyRZFlSxzkH4SNdgJPUbvnWRLX6iqR2KyO/9pqqLq5Uw3
	 kqYEoM8N1L0senXu9LCNNNFc8uSJ6yPm1f+FRYCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	"chr[]" <chris@rudorff.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 6.12 142/150] amdgpu/pm/legacy: fix suspend/resume issues
Date: Wed,  5 Mar 2025 18:49:31 +0100
Message-ID: <20250305174509.518124159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: chr[] <chris@rudorff.com>

commit 91dcc66b34beb72dde8412421bdc1b4cd40e4fb8 upstream.

resume and irq handler happily races in set_power_state()

* amdgpu_legacy_dpm_compute_clocks() needs lock
* protect irq work handler
* fix dpm_enabled usage

v2: fix clang build, integrate Lijo's comments (Alex)

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2524
Fixes: 3712e7a49459 ("drm/amd/pm: unified lock protections in amdgpu_dpm.c")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Tested-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name> # on Oland PRO
Signed-off-by: chr[] <chris@rudorff.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ee3dc9e204d271c9c7a8d4d38a0bce4745d33e71)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c     |   25 ++++++++++++++++++------
 drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c |    8 +++++--
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c     |   26 +++++++++++++++++++------
 3 files changed, 45 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/kv_dpm.c
@@ -3043,6 +3043,7 @@ static int kv_dpm_hw_init(void *handle)
 	if (!amdgpu_dpm)
 		return 0;
 
+	mutex_lock(&adev->pm.mutex);
 	kv_dpm_setup_asic(adev);
 	ret = kv_dpm_enable(adev);
 	if (ret)
@@ -3050,6 +3051,8 @@ static int kv_dpm_hw_init(void *handle)
 	else
 		adev->pm.dpm_enabled = true;
 	amdgpu_legacy_dpm_compute_clocks(adev);
+	mutex_unlock(&adev->pm.mutex);
+
 	return ret;
 }
 
@@ -3067,32 +3070,42 @@ static int kv_dpm_suspend(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_work_sync(&adev->pm.dpm.thermal.work);
+
 	if (adev->pm.dpm_enabled) {
+		mutex_lock(&adev->pm.mutex);
+		adev->pm.dpm_enabled = false;
 		/* disable dpm */
 		kv_dpm_disable(adev);
 		/* reset the power state */
 		adev->pm.dpm.current_ps = adev->pm.dpm.requested_ps = adev->pm.dpm.boot_ps;
+		mutex_unlock(&adev->pm.mutex);
 	}
 	return 0;
 }
 
 static int kv_dpm_resume(void *handle)
 {
-	int ret;
+	int ret = 0;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (adev->pm.dpm_enabled) {
+	if (!amdgpu_dpm)
+		return 0;
+
+	if (!adev->pm.dpm_enabled) {
+		mutex_lock(&adev->pm.mutex);
 		/* asic init will reset to the boot state */
 		kv_dpm_setup_asic(adev);
 		ret = kv_dpm_enable(adev);
-		if (ret)
+		if (ret) {
 			adev->pm.dpm_enabled = false;
-		else
+		} else {
 			adev->pm.dpm_enabled = true;
-		if (adev->pm.dpm_enabled)
 			amdgpu_legacy_dpm_compute_clocks(adev);
+		}
+		mutex_unlock(&adev->pm.mutex);
 	}
-	return 0;
+	return ret;
 }
 
 static bool kv_dpm_is_idle(void *handle)
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/legacy_dpm.c
@@ -1009,9 +1009,12 @@ void amdgpu_dpm_thermal_work_handler(str
 	enum amd_pm_state_type dpm_state = POWER_STATE_TYPE_INTERNAL_THERMAL;
 	int temp, size = sizeof(temp);
 
-	if (!adev->pm.dpm_enabled)
-		return;
+	mutex_lock(&adev->pm.mutex);
 
+	if (!adev->pm.dpm_enabled) {
+		mutex_unlock(&adev->pm.mutex);
+		return;
+	}
 	if (!pp_funcs->read_sensor(adev->powerplay.pp_handle,
 				   AMDGPU_PP_SENSOR_GPU_TEMP,
 				   (void *)&temp,
@@ -1033,4 +1036,5 @@ void amdgpu_dpm_thermal_work_handler(str
 	adev->pm.dpm.state = dpm_state;
 
 	amdgpu_legacy_dpm_compute_clocks(adev->powerplay.pp_handle);
+	mutex_unlock(&adev->pm.mutex);
 }
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7783,6 +7783,7 @@ static int si_dpm_hw_init(void *handle)
 	if (!amdgpu_dpm)
 		return 0;
 
+	mutex_lock(&adev->pm.mutex);
 	si_dpm_setup_asic(adev);
 	ret = si_dpm_enable(adev);
 	if (ret)
@@ -7790,6 +7791,7 @@ static int si_dpm_hw_init(void *handle)
 	else
 		adev->pm.dpm_enabled = true;
 	amdgpu_legacy_dpm_compute_clocks(adev);
+	mutex_unlock(&adev->pm.mutex);
 	return ret;
 }
 
@@ -7807,32 +7809,44 @@ static int si_dpm_suspend(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	cancel_work_sync(&adev->pm.dpm.thermal.work);
+
 	if (adev->pm.dpm_enabled) {
+		mutex_lock(&adev->pm.mutex);
+		adev->pm.dpm_enabled = false;
 		/* disable dpm */
 		si_dpm_disable(adev);
 		/* reset the power state */
 		adev->pm.dpm.current_ps = adev->pm.dpm.requested_ps = adev->pm.dpm.boot_ps;
+		mutex_unlock(&adev->pm.mutex);
 	}
+
 	return 0;
 }
 
 static int si_dpm_resume(void *handle)
 {
-	int ret;
+	int ret = 0;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (adev->pm.dpm_enabled) {
+	if (!amdgpu_dpm)
+		return 0;
+
+	if (!adev->pm.dpm_enabled) {
 		/* asic init will reset to the boot state */
+		mutex_lock(&adev->pm.mutex);
 		si_dpm_setup_asic(adev);
 		ret = si_dpm_enable(adev);
-		if (ret)
+		if (ret) {
 			adev->pm.dpm_enabled = false;
-		else
+		} else {
 			adev->pm.dpm_enabled = true;
-		if (adev->pm.dpm_enabled)
 			amdgpu_legacy_dpm_compute_clocks(adev);
+		}
+		mutex_unlock(&adev->pm.mutex);
 	}
-	return 0;
+
+	return ret;
 }
 
 static bool si_dpm_is_idle(void *handle)


