Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC05FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAAFC4339B;
	Mon, 15 May 2023 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169237;
	bh=JIRY4KI0oa0rFkCpTiczzmNYECTJbWVQ4KyF9q0KfAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMcScnKw9e8JFvzZm81KSyYWqUNPjVgIV4dOCpGepY+FDHzgP+UrrtBd7gBx8PkyC
	 SaSEN6WwYphr++jFXzAvDWoZd5MADtAMc233A79A8BCaCl3frnNBnMJkuhmOqr/YVy
	 w3duHWk7FMbVR1j1lbrY+haNTQzoTscWMg1/bswQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Rex Zhu <Rex.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/191] drm/amdgpu: Add amdgpu_gfx_off_ctrl function
Date: Mon, 15 May 2023 18:26:33 +0200
Message-Id: <20230515161713.093283569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rex Zhu <Rex.Zhu@amd.com>

[ Upstream commit d23ee13fba23a3039971a976b2c4857cb5ba9c73 ]

v2:
   1. drop the special handling for the hw IP
      suggested by hawking and Christian.
   2. refine the variable name suggested by Flora.

This funciton as the entry of gfx off feature.
we arbitrat gfx off feature enable/disable in this
function.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Rex Zhu <Rex.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 2397e3d8d2e1 ("drm/amdgpu: add a missing lock for AMDGPU_SCHED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  5 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    | 36 ++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index acbd33fcb73d3..624864148f1d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -950,6 +950,10 @@ struct amdgpu_gfx {
 	/* NGG */
 	struct amdgpu_ngg		ngg;
 
+	/* gfx off */
+	bool                            gfx_off_state; /* true: enabled, false: disabled */
+	struct mutex                    gfx_off_mutex;
+	uint32_t                        gfx_off_req_count; /* default 1, enable gfx off: dec 1, disable gfx off: add 1 */
 	/* pipe reservation */
 	struct mutex			pipe_reserve_mutex;
 	DECLARE_BITMAP			(pipe_reserve_bitmap, AMDGPU_MAX_COMPUTE_QUEUES);
@@ -1776,6 +1780,7 @@ void amdgpu_device_program_register_sequence(struct amdgpu_device *adev,
 					     const u32 array_size);
 
 bool amdgpu_device_is_px(struct drm_device *dev);
+void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable);
 /* atpx handler */
 #if defined(CONFIG_VGA_SWITCHEROO)
 void amdgpu_register_atpx_handler(void);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 102b05b8f0c2b..fed1097c64690 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2369,6 +2369,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	mutex_init(&adev->gfx.gpu_clock_mutex);
 	mutex_init(&adev->srbm_mutex);
 	mutex_init(&adev->gfx.pipe_reserve_mutex);
+	mutex_init(&adev->gfx.gfx_off_mutex);
 	mutex_init(&adev->grbm_idx_mutex);
 	mutex_init(&adev->mn_lock);
 	mutex_init(&adev->virt.vf_errors.lock);
@@ -2396,6 +2397,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	INIT_DELAYED_WORK(&adev->late_init_work,
 			  amdgpu_device_ip_late_init_func_handler);
 
+	adev->gfx.gfx_off_req_count = 1;
 	adev->pm.ac_power = power_supply_is_system_supplied() > 0 ? true : false;
 
 	/* Registers mapping */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index eeaa2e825858b..889d1266f3ae7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -340,3 +340,39 @@ void amdgpu_gfx_compute_mqd_sw_fini(struct amdgpu_device *adev)
 			      &ring->mqd_gpu_addr,
 			      &ring->mqd_ptr);
 }
+
+/* amdgpu_gfx_off_ctrl - Handle gfx off feature enable/disable
+ *
+ * @adev: amdgpu_device pointer
+ * @bool enable true: enable gfx off feature, false: disable gfx off feature
+ *
+ * 1. gfx off feature will be enabled by gfx ip after gfx cg gp enabled.
+ * 2. other client can send request to disable gfx off feature, the request should be honored.
+ * 3. other client can cancel their request of disable gfx off feature
+ * 4. other client should not send request to enable gfx off feature before disable gfx off feature.
+ */
+
+void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable)
+{
+	if (!(adev->powerplay.pp_feature & PP_GFXOFF_MASK))
+		return;
+
+	if (!adev->powerplay.pp_funcs->set_powergating_by_smu)
+		return;
+
+	mutex_lock(&adev->gfx.gfx_off_mutex);
+
+	if (!enable)
+		adev->gfx.gfx_off_req_count++;
+	else if (adev->gfx.gfx_off_req_count > 0)
+		adev->gfx.gfx_off_req_count--;
+
+	if (enable && !adev->gfx.gfx_off_state && !adev->gfx.gfx_off_req_count) {
+		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, true))
+			adev->gfx.gfx_off_state = true;
+	} else if (!enable && adev->gfx.gfx_off_state) {
+		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false))
+			adev->gfx.gfx_off_state = false;
+	}
+	mutex_unlock(&adev->gfx.gfx_off_mutex);
+}
-- 
2.39.2



