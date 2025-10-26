Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65B23EA89;
	Sun, 26 Oct 2025 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490225; cv=none; b=ANF1zsUsoN4wZYJISb7PkJ2G2CUgCE1TaD9aqI5YPJMOBY9trz63PXQQBOmb1YkAqACGtT6rdWghARcqYtXQ9BGI/nnuEzL04m2zTINn4425QkuJEvD1Elm1LlvHm2s64hULaAPoS/aPdPHYTOty+8cWzlh148iq+v2NsJC1I0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490225; c=relaxed/simple;
	bh=nAPdwis2vsUYx9A+DDlbYAp2acEo+E4+SZdScECi7/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wgjl3MxkcGRBridC7j3/Ce/4DtN1dUCS+BG/QemK53yoAwgHlfKlmmSfvuXNIouhr1iaMkqj/snchCHZRO9mFMRr6e0J41I1hbRr3hFa126yIvMSqRpn/9VR1MQLV2Eog1Nl9y2JTiP1Yngd00nsljyHbb2MgJIeli7Z7UKWgZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lWVOVw27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lWVOVw27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D088EC4CEE7;
	Sun, 26 Oct 2025 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490225;
	bh=nAPdwis2vsUYx9A+DDlbYAp2acEo+E4+SZdScECi7/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWVOVw27kIquhwL2M/Je+0DBXAsf9r3fa3XUx/VoLgJbnQehvg9pvr1AjzD1V3srr
	 zD4ui1Nx5l6yvGnrgJUtfw1JgEyAk+6x4Vi3u+H21na7AR888WcPHjuUsK9rdz+SRo
	 uskJ+sT6kCJEWwVPwrIf/CCROqpdJUluqj5/pWgwhvYIdytsliL+tJLOGKtLp72izp
	 7UrprPvpaTXvlD7e8QtlzJ1Z0NDGGlAm5KqZZOSMH3dew2lKONbBe8uftVeQx2wMb/
	 EW6Cs5OmLYQdet13x5NL5DKjICl5xMlbuiPg4tqgEY1AERGLkIkHstCTsWoCrRWgFs
	 wVAHBUyNYDchg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	cesun102@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Report individual reset error
Date: Sun, 26 Oct 2025 10:48:51 -0400
Message-ID: <20251026144958.26750-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 2e97663760e5fb7ee14f399c68e57b894f01e505 ]

If reinitialization of one of the GPUs fails after reset, it logs
failure on all subsequent GPUs eventhough they have resumed
successfully.

A sample log where only device at 0000:95:00.0 had a failure -

	amdgpu 0000:15:00.0: amdgpu: GPU reset(19) succeeded!
	amdgpu 0000:65:00.0: amdgpu: GPU reset(19) succeeded!
	amdgpu 0000:75:00.0: amdgpu: GPU reset(19) succeeded!
	amdgpu 0000:85:00.0: amdgpu: GPU reset(19) succeeded!
	amdgpu 0000:95:00.0: amdgpu: GPU reset(19) failed
	amdgpu 0000:e5:00.0: amdgpu: GPU reset(19) failed
	amdgpu 0000:f5:00.0: amdgpu: GPU reset(19) failed
	amdgpu 0000:05:00.0: amdgpu: GPU reset(19) failed
	amdgpu 0000:15:00.0: amdgpu: GPU reset end with ret = -5

To avoid confusion, report the error for each device
separately and return the first error as the overall result.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The fix makes `amdgpu_device_sched_resume()` report failures per-
  device by gating the failure path on `tmp_adev->asic_reset_res` and
  logging the GPU-specific errno
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6341-6356`). Without
  this, once any GPU in an XGMI hive fails to reinitialize, every
  subsequent GPU is logged — and reported to SR-IOV guests — as failed
  even when it succeeds, exactly matching the problem described in the
  commit message.
- `amdgpu_vf_error_put()` now receives the correct GPU’s error code,
  preventing benign devices from being flagged as reset failures to the
  management stack
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6354-6356`).
- By only recording the first non-zero `r` and leaving later successful
  devices untouched
  (`drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:6357-6359`), the overall
  reset outcome still reflects a real fault while no longer clobbering
  it with spurious data.
- The change is self-contained (single function, no new APIs, no
  behavior change for the success path), so regression risk is minimal,
  yet it fixes a real user-visible bug in multi-GPU recovery flows—clear
  stable-tree material.

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 25 +++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c8459337fcb89..690bda2ab8d2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6338,23 +6338,28 @@ static int amdgpu_device_sched_resume(struct list_head *device_list,
 		if (!drm_drv_uses_atomic_modeset(adev_to_drm(tmp_adev)) && !job_signaled)
 			drm_helper_resume_force_mode(adev_to_drm(tmp_adev));
 
-		if (tmp_adev->asic_reset_res)
-			r = tmp_adev->asic_reset_res;
-
-		tmp_adev->asic_reset_res = 0;
-
-		if (r) {
+		if (tmp_adev->asic_reset_res) {
 			/* bad news, how to tell it to userspace ?
 			 * for ras error, we should report GPU bad status instead of
 			 * reset failure
 			 */
 			if (reset_context->src != AMDGPU_RESET_SRC_RAS ||
 			    !amdgpu_ras_eeprom_check_err_threshold(tmp_adev))
-				dev_info(tmp_adev->dev, "GPU reset(%d) failed\n",
-					atomic_read(&tmp_adev->gpu_reset_counter));
-			amdgpu_vf_error_put(tmp_adev, AMDGIM_ERROR_VF_GPU_RESET_FAIL, 0, r);
+				dev_info(
+					tmp_adev->dev,
+					"GPU reset(%d) failed with error %d \n",
+					atomic_read(
+						&tmp_adev->gpu_reset_counter),
+					tmp_adev->asic_reset_res);
+			amdgpu_vf_error_put(tmp_adev,
+					    AMDGIM_ERROR_VF_GPU_RESET_FAIL, 0,
+					    tmp_adev->asic_reset_res);
+			if (!r)
+				r = tmp_adev->asic_reset_res;
+			tmp_adev->asic_reset_res = 0;
 		} else {
-			dev_info(tmp_adev->dev, "GPU reset(%d) succeeded!\n", atomic_read(&tmp_adev->gpu_reset_counter));
+			dev_info(tmp_adev->dev, "GPU reset(%d) succeeded!\n",
+				 atomic_read(&tmp_adev->gpu_reset_counter));
 			if (amdgpu_acpi_smart_shift_update(tmp_adev,
 							   AMDGPU_SS_DEV_D0))
 				dev_warn(tmp_adev->dev,
-- 
2.51.0

