Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C000C1DB92A;
	Tue, 12 Aug 2025 18:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023810; cv=none; b=Mx+IB88u7naFjhtwWG3Vh/lVFftz0cJ5TUD2i1ibTxT5ouqIFhD4ByktaF3R15ol8Yq6T+n06b/faCeMn8hVNHkEjKkDOK2Jj5TZhLIxj8EPiEe6H+KaGOp1qekVS3nRjcBbNTCU47rM0GyPcP90IpcKMokA1I7jLJfZUS/5vl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023810; c=relaxed/simple;
	bh=sQtbooRGf/OEIhZHJoICIVJW+sIMvmNi+qo90Ojv0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IG3ocLPYgi990EdER3u1JoYxEHPAIqlgEKgz0xMZZsxrMzpC3gaO1jT1K/Y1frtUWOnPNT0as4wo7xyFIS/yYNyVTIK+p+Yz/VJakNRIJXQhutd+w3uMDN065hfY8l0MLyHOfJSTDxaUmA95XCO+5N2+qw5iRheDC1r20d8c/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkCds3Wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkCds3Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F65C4CEF0;
	Tue, 12 Aug 2025 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023810;
	bh=sQtbooRGf/OEIhZHJoICIVJW+sIMvmNi+qo90Ojv0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkCds3WixSJFI+ageKca4LlwMIltC/OfnlktXqzGJMUEHzeYWXXenhQ4GNP2BzbvF
	 MeTEbXO4ca2TW6OwliL6tY4e3Ck0OUml2cTv8yCKYoKDtzcX5JPetOWuTcP7KSdhaN
	 ZnEEMlOB7u7Bsnvp7bm1SdJQ05M7Vi7BEk6oHM9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 188/627] drm/amdgpu: rework queue reset scheduler interaction
Date: Tue, 12 Aug 2025 19:28:03 +0200
Message-ID: <20250812173426.425813446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <ckoenig.leichtzumerken@gmail.com>

[ Upstream commit 821aacb2dcf0d1fbc3c0f7803b6089b01addb8bf ]

Stopping the scheduler for queue reset is generally a good idea because
it prevents any worker from touching the ring buffer.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 14b2d71a9a24 ("drm/amdgpu/gfx10: fix KGQ reset sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 35 ++++++++++++++-----------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index ddb9d3269357..9ea3bce01faf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -91,8 +91,8 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 	struct amdgpu_job *job = to_amdgpu_job(s_job);
 	struct amdgpu_task_info *ti;
 	struct amdgpu_device *adev = ring->adev;
-	int idx;
-	int r;
+	bool set_error = false;
+	int idx, r;
 
 	if (!drm_dev_enter(adev_to_drm(adev), &idx)) {
 		dev_info(adev->dev, "%s - device unplugged skipping recovery on scheduler:%s",
@@ -136,10 +136,12 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 	} else if (amdgpu_gpu_recovery && ring->funcs->reset) {
 		bool is_guilty;
 
-		dev_err(adev->dev, "Starting %s ring reset\n", s_job->sched->name);
-		/* stop the scheduler, but don't mess with the
-		 * bad job yet because if ring reset fails
-		 * we'll fall back to full GPU reset.
+		dev_err(adev->dev, "Starting %s ring reset\n",
+			s_job->sched->name);
+
+		/*
+		 * Stop the scheduler to prevent anybody else from touching the
+		 * ring buffer.
 		 */
 		drm_sched_wqueue_stop(&ring->sched);
 
@@ -152,26 +154,29 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 		else
 			is_guilty = true;
 
-		if (is_guilty)
+		if (is_guilty) {
 			dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
+			set_error = true;
+		}
 
 		r = amdgpu_ring_reset(ring, job->vmid);
 		if (!r) {
-			if (amdgpu_ring_sched_ready(ring))
-				drm_sched_stop(&ring->sched, s_job);
 			if (is_guilty) {
 				atomic_inc(&ring->adev->gpu_reset_counter);
 				amdgpu_fence_driver_force_completion(ring);
 			}
-			if (amdgpu_ring_sched_ready(ring))
-				drm_sched_start(&ring->sched, 0);
-			dev_err(adev->dev, "Ring %s reset succeeded\n", ring->sched.name);
-			drm_dev_wedged_event(adev_to_drm(adev), DRM_WEDGE_RECOVERY_NONE);
+			drm_sched_wqueue_start(&ring->sched);
+			dev_err(adev->dev, "Ring %s reset succeeded\n",
+				ring->sched.name);
+			drm_dev_wedged_event(adev_to_drm(adev),
+					     DRM_WEDGE_RECOVERY_NONE);
 			goto exit;
 		}
-		dev_err(adev->dev, "Ring %s reset failure\n", ring->sched.name);
+		dev_err(adev->dev, "Ring %s reset failed\n", ring->sched.name);
 	}
-	dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
+
+	if (!set_error)
+		dma_fence_set_error(&s_job->s_fence->finished, -ETIME);
 
 	if (amdgpu_device_should_recover_gpu(ring->adev)) {
 		struct amdgpu_reset_context reset_context;
-- 
2.39.5



