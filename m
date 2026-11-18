Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047430;
	b=efJWSDmreyjPUYZQP2a9R95yVcpQvSUQFVEZtxkTovLR6c7dKI2FZK5IewaWGs+TjWC+
	 fHhGwfhe/OkWvRJRL9yijGzzLabRO0h/lAZ3C9CECV8hp6Aaj8PACXfATvpK09YQhwTol
	 aYAVTwzmHYI2VLWm9hVsd9VDpUycDXBzmvqTCV/ekLFh4vGm5hHneoo6A9wUYDXU5Rlv3
	 kTqI4WQyFVrzFBP50JcBbDLER4re/gYmp9zlm6AUysKZGx7pkUThU+IqhvZ415OK3omdY
	 djmv2NPYK6jvu0CwV1LT5q97zNiDtUKVrFW2vOjQq8YqYJi7oBwAco7H9tU4sVByfIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OOa4lAR5Q0J3SpIIGwVvt6pFxQGa5lqPuWEniUamQWA=;
	b=AS7YJUfBGRj3utGxbxDLKHlSqTjkbjrlhKNuP7HhZozqs/0TEOWglND4GdWhjmHNaKuY
	 db27/Qp0NY9rc/7uVxc2274PC1RF3mIeA+cyNs16X8hs+J64qgVd3oFovNs+vy2rPrmNz
	 lzr4xt/vZp+2T3Q9g7j89yM0PNm9b9H7SstPrUu5V1VW0NATax/TFmNpvBqUqIWUSXJ/m
	 i3LDTVp8nJQqtmhYKcY3X4w5pmJvwKCqymaL/6OVzszemnkgLc6KxOL01J2gjNl5P7bHc
	 vGztiHQC0Y0695PJLHPbA9GxQLiX1DAdq6cmh0xfrNwSm4dzbBW0rof8vYyKOUTSZvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzODoauF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1B7606A335;
	Thu, 19 Nov 2026 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzODoauF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D61D1F000C4;
	Thu, 19 Nov 2026 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047430;
	bh=OOa4lAR5Q0J3SpIIGwVvt6pFxQGa5lqPuWEniUamQWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzODoauFNmoGs1N5/QasyErndge2v+IlVAZX2ic+ZVsZrZa84klvNB05+/HSUGWaQ
	 EMaQ80r8TxgyFj64hSF+lfbrp780uN70FDHRtiYTi5O5FHDuBJ1TYrhhuQopkXnKAg
	 aBrqpMxZ771jC4mCHEcVTRNZ90dTVmDgE8DeMx5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1634/2857] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150300.171232956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 733389cb31e2c55e355410759fdc68afe74a4582 ]

Run GPU post-reset callbacks, including KFD and display-audio resume,
before restarting DRM scheduler workqueues. IP hardware initialization
already happens inside ASIC recovery; this change orders the remaining
callbacks before new scheduler submissions. Preserve the emergency-stop
and guity job completition path's callbacks without starting schedulers,

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f6433e2b264e75c56ae95f187788806201bdbc3)
Cc: stable@vger.kernel.org
[ sashal: Adapted upstream recovery helper reordering to the existing inline recovery code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 43 ++++++++++++----------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 8bd9ecb88c94a..3cd3fb1a5eb4b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5621,7 +5621,7 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	}
 
 	if (need_emergency_restart)
-		goto skip_sched_resume;
+		goto post_resume;
 
 	/*
 	 * Must check guilty signal here since after this point all old
@@ -5693,7 +5693,30 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 			!(tmp_vram_lost_counter < atomic_read(&adev->vram_lost_counter)))
 			amdgpu_device_recheck_guilty_jobs(
 				tmp_adev, device_list_handle, reset_context);
+	}
+
+post_resume:
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
+		/* unlock kfd: SRIOV would do it separately */
+		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
+			amdgpu_amdkfd_post_reset(tmp_adev);
+
+		/* kfd_post_reset will do nothing if kfd device is not initialized,
+		 * need to bring up kfd here if it's not be initialized before
+		 */
+		if (!adev->kfd.init_complete)
+			amdgpu_amdkfd_device_init(adev);
+
+		if (audio_suspended)
+			amdgpu_device_resume_display_audio(tmp_adev);
+
+		amdgpu_device_unset_mp1_state(tmp_adev);
+	}
+
+	if (need_emergency_restart)
+		goto recover_end;
 
+	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
 		for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 			struct amdgpu_ring *ring = tmp_adev->rings[i];
 
@@ -5730,24 +5753,6 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		}
 	}
 
-skip_sched_resume:
-	list_for_each_entry(tmp_adev, device_list_handle, reset_list) {
-		/* unlock kfd: SRIOV would do it separately */
-		if (!need_emergency_restart && !amdgpu_sriov_vf(tmp_adev))
-			amdgpu_amdkfd_post_reset(tmp_adev);
-
-		/* kfd_post_reset will do nothing if kfd device is not initialized,
-		 * need to bring up kfd here if it's not be initialized before
-		 */
-		if (!adev->kfd.init_complete)
-			amdgpu_amdkfd_device_init(adev);
-
-		if (audio_suspended)
-			amdgpu_device_resume_display_audio(tmp_adev);
-
-		amdgpu_device_unset_mp1_state(tmp_adev);
-	}
-
 recover_end:
 	tmp_adev = list_first_entry(device_list_handle, struct amdgpu_device,
 					    reset_list);
-- 
2.53.0



