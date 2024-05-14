Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB13713A415;
	Tue, 14 May 2024 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683088; cv=none; b=RRkW26uO5kwcyGcnvcctjQP88pph1x/1c2UDd9kFz0wICtNl/GFM+QkaLKyetyyUUEZ4vqNJb5iXTIQR1kJ7MI7/ivXome/h3H/B6KMt+HutoOzMaRXl7ri6Lvc7KeMbgja1mlZT8L2801rccQLqoI+zoXafbQVJl54ufm/C9J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683088; c=relaxed/simple;
	bh=5ZPgI5fowkorkbaREYjbn7398A+xZ62nxZ2nLfYo3ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLW4y/EW4y9q0qfLtYzz1qy9O4ezka9zXNej4KT5db7ZU/7+8y2gRIGe9EoKmPO2hB3vVNQ50w4CplUjdB8/VT4eIxSL0GY9aW+MxjrU0p4eXNwxBYjJWsmjB3oXKBE1UEjiSM0DDvH8DVHsO61pTljME7n8IWYiJxJXLgGMFpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vghhDEfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vghhDEfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C0FC2BD10;
	Tue, 14 May 2024 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683088;
	bh=5ZPgI5fowkorkbaREYjbn7398A+xZ62nxZ2nLfYo3ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vghhDEfdiHMy4TCpY6leh9DUKgYo4GJ9yWT43Jw6g4+u74ZKJS1+ggPKUKIsX3E6O
	 ERGxXz0A7scl3thICqbbLTwMN0Cg9nxOIejkbL3JxgobxNhXoauvC15uKnZk/R5TCL
	 quQECRCVExG5Ntqy754xRe7vfa8DgiLw2WhObQ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 164/336] drm/amd/pm: fix the high voltage issue after unload
Date: Tue, 14 May 2024 12:16:08 +0200
Message-ID: <20240514101044.796665538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 3818708e9c9712e2ba4006bc23502ee7b031bd3f ]

fix the high voltage issue after unload on smu 13.0.10

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c    | 26 ++++++++++--------
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c     | 27 +++++++++++++++++--
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  1 +
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  |  8 +++++-
 4 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d0afb9ba3789c..14d878675586a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4120,18 +4120,22 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 					adev->ip_blocks[i].status.hw = true;
 				}
 			}
+		} else if (amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 10) &&
+				   !amdgpu_device_has_display_hardware(adev)) {
+					r = psp_gpu_reset(adev);
 		} else {
-			tmp = amdgpu_reset_method;
-			/* It should do a default reset when loading or reloading the driver,
-			 * regardless of the module parameter reset_method.
-			 */
-			amdgpu_reset_method = AMD_RESET_METHOD_NONE;
-			r = amdgpu_asic_reset(adev);
-			amdgpu_reset_method = tmp;
-			if (r) {
-				dev_err(adev->dev, "asic reset on init failed\n");
-				goto failed;
-			}
+				tmp = amdgpu_reset_method;
+				/* It should do a default reset when loading or reloading the driver,
+				 * regardless of the module parameter reset_method.
+				 */
+				amdgpu_reset_method = AMD_RESET_METHOD_NONE;
+				r = amdgpu_asic_reset(adev);
+				amdgpu_reset_method = tmp;
+		}
+
+		if (r) {
+		  dev_err(adev->dev, "asic reset on init failed\n");
+		  goto failed;
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 0ad947df777ab..ba1597b01a970 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -734,7 +734,7 @@ static int smu_early_init(void *handle)
 	smu->adev = adev;
 	smu->pm_enabled = !!amdgpu_dpm;
 	smu->is_apu = false;
-	smu->smu_baco.state = SMU_BACO_STATE_EXIT;
+	smu->smu_baco.state = SMU_BACO_STATE_NONE;
 	smu->smu_baco.platform_support = false;
 	smu->user_dpm_profile.fan_mode = -1;
 
@@ -1954,10 +1954,25 @@ static int smu_smc_hw_cleanup(struct smu_context *smu)
 	return 0;
 }
 
+static int smu_reset_mp1_state(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+	int ret = 0;
+
+	if ((!adev->in_runpm) && (!adev->in_suspend) &&
+		(!amdgpu_in_reset(adev)) && amdgpu_ip_version(adev, MP1_HWIP, 0) ==
+									IP_VERSION(13, 0, 10) &&
+		!amdgpu_device_has_display_hardware(adev))
+		ret = smu_set_mp1_state(smu, PP_MP1_STATE_UNLOAD);
+
+	return ret;
+}
+
 static int smu_hw_fini(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct smu_context *smu = adev->powerplay.pp_handle;
+	int ret;
 
 	if (amdgpu_sriov_vf(adev) && !amdgpu_sriov_is_pp_one_vf(adev))
 		return 0;
@@ -1975,7 +1990,15 @@ static int smu_hw_fini(void *handle)
 
 	adev->pm.dpm_enabled = false;
 
-	return smu_smc_hw_cleanup(smu);
+	ret = smu_smc_hw_cleanup(smu);
+	if (ret)
+		return ret;
+
+	ret = smu_reset_mp1_state(smu);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static void smu_late_fini(void *handle)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index 66e84defd0b6e..2aa4fea873147 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -424,6 +424,7 @@ enum smu_reset_mode {
 enum smu_baco_state {
 	SMU_BACO_STATE_ENTER = 0,
 	SMU_BACO_STATE_EXIT,
+	SMU_BACO_STATE_NONE,
 };
 
 struct smu_baco_context {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 9c03296f92cdd..67117ced7c6ae 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -2751,7 +2751,13 @@ static int smu_v13_0_0_set_mp1_state(struct smu_context *smu,
 
 	switch (mp1_state) {
 	case PP_MP1_STATE_UNLOAD:
-		ret = smu_cmn_set_mp1_state(smu, mp1_state);
+		ret = smu_cmn_send_smc_msg_with_param(smu,
+											  SMU_MSG_PrepareMp1ForUnload,
+											  0x55, NULL);
+
+		if (!ret && smu->smu_baco.state == SMU_BACO_STATE_EXIT)
+			ret = smu_v13_0_disable_pmfw_state(smu);
+
 		break;
 	default:
 		/* Ignore others */
-- 
2.43.0



