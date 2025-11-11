Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA2B2BCF5;
	Tue, 11 Nov 2025 01:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825269; cv=none; b=SOwAnxtQHOPlzfmJ+C/q3Z9v6MH2xe60RKcvn+bwC6IY1ZkL6mC1+oESxoc6fhw72uLN7LOSDkDf9lpl5kjB7FAj1UR/jC+MGjKaGI6SOdNG/4amsZFUOSMfvhKh0EIuMwnBEt+bItZZ9sCPX2LmqKuI/dHQFeecVBwW5Haz5sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825269; c=relaxed/simple;
	bh=5BLRkKcUBQGIhxHKKYbteev+Y87x0KArfXzG6SQpUkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2yXZaaznD0/Ap2YfZONpf6MDrK3fKg9BKLfMnC17YZHbl9VM7Mjvllisu7ZHSCUsbpJzEQrenP1XGprvBxcPJRV5CwTe1g7ALKdZeVUfoemmW0M5lE/LZ5cyLFNcmsh6/l045PJb1wrkV58yX1weuIOaJWmtHm9ZryuMeUdVVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFOsQxcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFOsQxcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF309C113D0;
	Tue, 11 Nov 2025 01:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825269;
	bh=5BLRkKcUBQGIhxHKKYbteev+Y87x0KArfXzG6SQpUkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFOsQxczeZnNp2uSZB/FcYhvlb8ttlQYWh5juybmkX9gRKgjNvjE8+bNZam6MlTwB
	 w3at10B5xWXciuG9IZNEiJsbrUYqKUrhwZjbED5nz1H0IwDFxwTlWdncx9aeCFW/0z
	 j8aVA9sWLQjgaeQN5cT7ZDnWp8BPkxKoBu2ubBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 732/849] drm/amdgpu: Report individual reset error
Date: Tue, 11 Nov 2025 09:45:02 +0900
Message-ID: <20251111004554.131974541@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 25 +++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 1115af343e013..ddd0e7ab82be7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6337,23 +6337,28 @@ static int amdgpu_device_sched_resume(struct list_head *device_list,
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



