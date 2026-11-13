Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590446;
	b=UGWwSiDk4vJBfCqnkjsY4Zni5gEiJ53mAiNqRnDcSnQpEPGRWoTDVDbs4mGNfI5nm4SE
	 lhmuXXY2kHguKAGJpi8ssbEyM0BBlM1ic2iOQUFeHg5tZdW652oYxD3UdTd4977GlwWto
	 ulVIKAQtnYN2svncyZnjDE+tCdsqCL2dKEbuTaTd/w2Z0GgtPspffkuO0gAt95Lbbn4Tc
	 Ing9nYE0OETEqaduuvbOOfmpHKgKGWlLC6k9MCwpAzuGtJtLl9fRKm9rlrg5pU68OWNyh
	 yGfHewXb6/mwkyNOhBp6lN3XoH1E3ocJftOy6/b6JIkn8IFP4m3hfKEkC5yeQdhX3mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nEDQB2PN8yTo89JIvTuI8lPlgKtPFKxfRYoP/xbHj14=;
	b=Gy7u1Zke5K+cr6lgI43JEPysRPVquuc3YnD2fMjN0KJeJ4BumrpoDlnnObiSqs2cf3vi
	 QrW6Gn2nOKM8ep9Hhyyr4MWlf8BZ2As1O4rnZdZSyf1/RT4CoAMESplJf3nMtoQRdWU6U
	 C2ook+4iV4knePbMRtRcXWVYxaPGxA7j0nWs+K3VofhvDTCkFIeiM8YIdhlG4pp3Ti0O0
	 6kKkdRb4q4oUa0wA8BCYDObb13z2p1d1NFbtiI5D3Tz9c4ATBMbkwyukTaFyHLT/QrqRS
	 +u6vc1BS7TFp0cYpjjxZe4xC4F2VMmoEs+BSvfTRO6flxGZD4y8mWe3GbtSPhXhMYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3qcg++a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875306071411;
	Fri, 13 Nov 2026 17:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3qcg++a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ADD1F000C4;
	Fri, 13 Nov 2026 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590446;
	bh=nEDQB2PN8yTo89JIvTuI8lPlgKtPFKxfRYoP/xbHj14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3qcg++a9WWYwQ2k10AeH5DASlSEX5Dy6pTfyT1tR0BUKKFyDzDDbig/ohcnVtGcT
	 9rzczAZAbaUd1KOPJdurzVri/kTNMJ8hufG7/keELqLDIQF8ETSD0tw9P9VckKj8TS
	 5crZwfLIB77qXrykbUr9aEJoue21LI5MA0fI8czY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/686] drm/amdgpu: finish GPU recovery callbacks before restarting schedulers
Date: Fri, 13 Nov 2026 10:48:56 -0500
Message-ID: <20261113153834.645602307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2e0998de67ed1..b152beddbc3f9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6667,8 +6667,10 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 
 	amdgpu_device_halt_activities(adev, job, reset_context, &device_list,
 				      hive, need_emergency_restart);
-	if (need_emergency_restart)
-		goto skip_sched_resume;
+	if (need_emergency_restart) {
+		amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
+		goto reset_unlock;
+	}
 	/*
 	 * Must check guilty signal here since after this point all old
 	 * HW fences are force signaled.
@@ -6678,18 +6680,17 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 	if (job && dma_fence_is_signaled(&job->hw_fence.base)) {
 		job_signaled = true;
 		dev_info(adev->dev, "Guilty job already signaled, skipping HW reset");
-		goto skip_hw_reset;
+		goto post_resume;
 	}
 
 	r = amdgpu_device_asic_reset(adev, &device_list, reset_context);
 	if (r)
 		goto reset_unlock;
-skip_hw_reset:
+post_resume:
+	amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
 	r = amdgpu_device_sched_resume(&device_list, reset_context, job_signaled);
 	if (r)
 		goto reset_unlock;
-skip_sched_resume:
-	amdgpu_device_gpu_resume(adev, &device_list, need_emergency_restart);
 reset_unlock:
 	amdgpu_device_recovery_put_reset_lock(adev, &device_list);
 end_reset:
-- 
2.53.0



