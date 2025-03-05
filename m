Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC95919C542;
	Wed,  5 Mar 2025 18:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198821; cv=none; b=RgfkcQfLzqDk6G67Zi/vDsjzQVa4YpoU1E3/J9hFLsd79swRXkT30jeh/T/jHTh7e+MDXeEoCmJJZCID27yj+es8wzUlrHdByoCEadIYAcRZgpNM7m86y+aXyh2U8IdsUeLXsxBaE7NBjfZ7O9ePSDBdRXWexcN7Vn8AlKPy730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198821; c=relaxed/simple;
	bh=+VdM8krl6nguvfP5SbxKtEIKq+r2RYNl0gGLtEaWY60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS1CltpCBz5RPKjZkXaqgYKt4v0q1MYlc13ZOiRlyhIUwfkZeSqjCpNxRFVgSWts/iY/vdlHbIxrA5w4dC1GjWzN/SVFPdZBdK1DNxVUeocHiwSMscmu6QQC4TEUap3o2u5d87fLU5CrmANabkBarGHVY+e4tVhlXce+Wm5XRPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnbDyObe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnbDyObe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE9CC4CED1;
	Wed,  5 Mar 2025 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198821;
	bh=+VdM8krl6nguvfP5SbxKtEIKq+r2RYNl0gGLtEaWY60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnbDyObe4UXn42jRLmswul2kruPySpjmvEwuRTa57a2A6EE5BRv27sM/OOof1DwD3
	 CbVkFTJ1o7axNVQIVhQ+Qx+rhsmwkZkyCtHEdM5RoKV+l/KX2wWW7dK9eiVaDlhnA1
	 +jE/TW2deJs4NdiivPJPWS524OGRQ/7Azk84lu5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	"chr[]" <chris@rudorff.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: [PATCH 6.13 127/157] amdgpu/pm/legacy: fix suspend/resume issues
Date: Wed,  5 Mar 2025 18:49:23 +0100
Message-ID: <20250305174510.407116703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3042,6 +3042,7 @@ static int kv_dpm_hw_init(struct amdgpu_
 	if (!amdgpu_dpm)
 		return 0;
 
+	mutex_lock(&adev->pm.mutex);
 	kv_dpm_setup_asic(adev);
 	ret = kv_dpm_enable(adev);
 	if (ret)
@@ -3049,6 +3050,8 @@ static int kv_dpm_hw_init(struct amdgpu_
 	else
 		adev->pm.dpm_enabled = true;
 	amdgpu_legacy_dpm_compute_clocks(adev);
+	mutex_unlock(&adev->pm.mutex);
+
 	return ret;
 }
 
@@ -3066,32 +3069,42 @@ static int kv_dpm_suspend(struct amdgpu_
 {
 	struct amdgpu_device *adev = ip_block->adev;
 
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
 
 static int kv_dpm_resume(struct amdgpu_ip_block *ip_block)
 {
-	int ret;
+	int ret = 0;
 	struct amdgpu_device *adev = ip_block->adev;
 
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
@@ -7785,6 +7785,7 @@ static int si_dpm_hw_init(struct amdgpu_
 	if (!amdgpu_dpm)
 		return 0;
 
+	mutex_lock(&adev->pm.mutex);
 	si_dpm_setup_asic(adev);
 	ret = si_dpm_enable(adev);
 	if (ret)
@@ -7792,6 +7793,7 @@ static int si_dpm_hw_init(struct amdgpu_
 	else
 		adev->pm.dpm_enabled = true;
 	amdgpu_legacy_dpm_compute_clocks(adev);
+	mutex_unlock(&adev->pm.mutex);
 	return ret;
 }
 
@@ -7809,32 +7811,44 @@ static int si_dpm_suspend(struct amdgpu_
 {
 	struct amdgpu_device *adev = ip_block->adev;
 
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
 
 static int si_dpm_resume(struct amdgpu_ip_block *ip_block)
 {
-	int ret;
+	int ret = 0;
 	struct amdgpu_device *adev = ip_block->adev;
 
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


