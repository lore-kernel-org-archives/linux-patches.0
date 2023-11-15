Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71FC3BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Je6Wmgw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6647DC433C8;
	Wed, 15 Nov 2023 19:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077812;
	bh=VZCS0V9aPrf2liMVOlm5LGZd0gcoFXo7MRa7dHFW4Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je6Wmgw0leW5kPL73BhxVLtfiQ8RNUIZcIef/gWZEhAUkZcyT8dCJsS2abP3RlQu4
	 yL9CVGtkQDiHuOro1Qqsli6k778Y1fT0kEkCO7ok1FlpNXhXBTYdrp+tDpMwbrtuXo
	 mhAl/OsMLn8yi+3AD9pcZ1FeUuN7LrSrU+TgXayU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 534/603] drm/amdgpu/gfx10,11: use memcpy_to/fromio for MQDs
Date: Wed, 15 Nov 2023 14:17:59 -0500
Message-ID: <20231115191648.830136643@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b3c942bb6c32a8ddc1d52ee6bc24b8cf732dddf4 ]

Since they were moved to VRAM, we need to use the IO
variants of memcpy.

Fixes: 1cfb4d612127 ("drm/amdgpu: put MQDs in VRAM")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 12 ++++++------
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 9032d7a24d7cd..306252cd67fd7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6457,11 +6457,11 @@ static int gfx_v10_0_gfx_init_queue(struct amdgpu_ring *ring)
 		nv_grbm_select(adev, 0, 0, 0, 0);
 		mutex_unlock(&adev->srbm_mutex);
 		if (adev->gfx.me.mqd_backup[mqd_idx])
-			memcpy(adev->gfx.me.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.me.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
 	} else {
 		/* restore mqd with the backup copy */
 		if (adev->gfx.me.mqd_backup[mqd_idx])
-			memcpy(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
 		*ring->wptr_cpu_addr = 0;
@@ -6735,7 +6735,7 @@ static int gfx_v10_0_kiq_init_queue(struct amdgpu_ring *ring)
 	if (amdgpu_in_reset(adev)) { /* for GPU_RESET case */
 		/* reset MQD to a clean status */
 		if (adev->gfx.kiq[0].mqd_backup)
-			memcpy(mqd, adev->gfx.kiq[0].mqd_backup, sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.kiq[0].mqd_backup, sizeof(*mqd));
 
 		/* reset ring buffer */
 		ring->wptr = 0;
@@ -6758,7 +6758,7 @@ static int gfx_v10_0_kiq_init_queue(struct amdgpu_ring *ring)
 		mutex_unlock(&adev->srbm_mutex);
 
 		if (adev->gfx.kiq[0].mqd_backup)
-			memcpy(adev->gfx.kiq[0].mqd_backup, mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.kiq[0].mqd_backup, mqd, sizeof(*mqd));
 	}
 
 	return 0;
@@ -6779,11 +6779,11 @@ static int gfx_v10_0_kcq_init_queue(struct amdgpu_ring *ring)
 		mutex_unlock(&adev->srbm_mutex);
 
 		if (adev->gfx.mec.mqd_backup[mqd_idx])
-			memcpy(adev->gfx.mec.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.mec.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
 	} else {
 		/* restore MQD to a clean status */
 		if (adev->gfx.mec.mqd_backup[mqd_idx])
-			memcpy(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset ring buffer */
 		ring->wptr = 0;
 		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 762d7a19f1be1..43d066bc5245b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3684,11 +3684,11 @@ static int gfx_v11_0_gfx_init_queue(struct amdgpu_ring *ring)
 		soc21_grbm_select(adev, 0, 0, 0, 0);
 		mutex_unlock(&adev->srbm_mutex);
 		if (adev->gfx.me.mqd_backup[mqd_idx])
-			memcpy(adev->gfx.me.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.me.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
 	} else {
 		/* restore mqd with the backup copy */
 		if (adev->gfx.me.mqd_backup[mqd_idx])
-			memcpy(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
 		*ring->wptr_cpu_addr = 0;
@@ -3977,7 +3977,7 @@ static int gfx_v11_0_kiq_init_queue(struct amdgpu_ring *ring)
 	if (amdgpu_in_reset(adev)) { /* for GPU_RESET case */
 		/* reset MQD to a clean status */
 		if (adev->gfx.kiq[0].mqd_backup)
-			memcpy(mqd, adev->gfx.kiq[0].mqd_backup, sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.kiq[0].mqd_backup, sizeof(*mqd));
 
 		/* reset ring buffer */
 		ring->wptr = 0;
@@ -4000,7 +4000,7 @@ static int gfx_v11_0_kiq_init_queue(struct amdgpu_ring *ring)
 		mutex_unlock(&adev->srbm_mutex);
 
 		if (adev->gfx.kiq[0].mqd_backup)
-			memcpy(adev->gfx.kiq[0].mqd_backup, mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.kiq[0].mqd_backup, mqd, sizeof(*mqd));
 	}
 
 	return 0;
@@ -4021,11 +4021,11 @@ static int gfx_v11_0_kcq_init_queue(struct amdgpu_ring *ring)
 		mutex_unlock(&adev->srbm_mutex);
 
 		if (adev->gfx.mec.mqd_backup[mqd_idx])
-			memcpy(adev->gfx.mec.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
+			memcpy_fromio(adev->gfx.mec.mqd_backup[mqd_idx], mqd, sizeof(*mqd));
 	} else {
 		/* restore MQD to a clean status */
 		if (adev->gfx.mec.mqd_backup[mqd_idx])
-			memcpy(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(*mqd));
+			memcpy_toio(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset ring buffer */
 		ring->wptr = 0;
 		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
-- 
2.42.0



