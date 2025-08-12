Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9F81E500C;
	Tue, 12 Aug 2025 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023813; cv=none; b=FAxSAEyQlFU94xwXj7HftrvCvbO2pHVn3H1qOtSNv05YBNe6RIH7WbmCmF6cVgBahlov57YkBpw4+60ZYMiX3hmctIaSvqWcDSr6y00F8yWW0BdtJyijrhAF+N6HMUb+m5YE/t3u2FsZHuyTwAOpD6gHtPfEYmbOBgNWvu7PX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023813; c=relaxed/simple;
	bh=XZ6A8UDAlfWCvQzszvk1x0HzwMnW10M7w+ORBeuWLco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJnxIVmxH5mmLWpCrZbguMnCIfWNRTrtKouChWCLWr5hBEBgY/RbevwEmxsXNLoi0o5AvESyiLWLnhbyu9AT4LlThHnEbcepM3h5S04deOzo7LqFls4YGP6EPD+lxCPu6q8TA/QwpZdv4KsCGXRFW1/RU3ee7NQky7l+nDcARi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzZZPx+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzZZPx+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005DEC4CEF0;
	Tue, 12 Aug 2025 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023813;
	bh=XZ6A8UDAlfWCvQzszvk1x0HzwMnW10M7w+ORBeuWLco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzZZPx+GgJVHtKgZSNF3KoERwI8AfEEXTQuxwUcR92/ycP6AXsDTdOXpM1wtcwTJ3
	 xqFpAe2LZ9TIFJoErgwb71GbC5qsUWyIwB5Yr+tiRpaHsYnkg2u3uKO93ptq0SYy8q
	 xZ8Ba2Qe6QHVWuL4jnUAy8fKaV+2khFma3/beoko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 189/627] drm/amdgpu: move force completion into ring resets
Date: Tue, 12 Aug 2025 19:28:04 +0200
Message-ID: <20250812173426.462880915@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 2dee58ca471dae05c473270d0fb74efe01a78ccb ]

Move the force completion handling into each ring
reset function so that each engine can determine
whether or not it needs to force completion on the
jobs in the ring.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 14b2d71a9a24 ("drm/amdgpu/gfx10: fix KGQ reset sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c  |  4 +--
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c   | 12 +++++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c   | 12 +++++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c   | 12 +++++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c    |  7 +++++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c  |  7 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c   |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c   |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c   |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c   |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c |  8 +++++-
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c | 31 +++++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c   |  5 +++-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c   |  5 +++-
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c   |  6 ++++-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c   |  6 ++++-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c    |  7 +++++-
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c  |  6 +++--
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c  |  7 +++++-
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c  |  7 +++++-
 21 files changed, 152 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 9ea3bce01faf..3528a27c7c1d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -161,10 +161,8 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 
 		r = amdgpu_ring_reset(ring, job->vmid);
 		if (!r) {
-			if (is_guilty) {
+			if (is_guilty)
 				atomic_inc(&ring->adev->gpu_reset_counter);
-				amdgpu_fence_driver_force_completion(ring);
-			}
 			drm_sched_wqueue_start(&ring->sched);
 			dev_err(adev->dev, "Ring %s reset succeeded\n",
 				ring->sched.name);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 75ea071744eb..777e383d75e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9575,7 +9575,11 @@ static int gfx_v10_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
@@ -9647,7 +9651,11 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	if (r)
 		return r;
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static void gfx_v10_ip_print(struct amdgpu_ip_block *ip_block, struct drm_printer *p)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index ec9b84f92d46..e632e97d63be 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -6840,7 +6840,11 @@ static int gfx_v11_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int gfx_v11_0_reset_compute_pipe(struct amdgpu_ring *ring)
@@ -7000,7 +7004,11 @@ static int gfx_v11_0_reset_kcq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static void gfx_v11_ip_print(struct amdgpu_ip_block *ip_block, struct drm_printer *p)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 1234c8d64e20..50f04c2c0b8c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -5335,7 +5335,11 @@ static int gfx_v12_0_reset_kgq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int gfx_v12_0_reset_compute_pipe(struct amdgpu_ring *ring)
@@ -5448,7 +5452,11 @@ static int gfx_v12_0_reset_kcq(struct amdgpu_ring *ring, unsigned int vmid)
 		return r;
 	}
 
-	return amdgpu_ring_test_ring(ring);
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static void gfx_v12_0_ring_begin_use(struct amdgpu_ring *ring)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index ad9be3656653..23f998181561 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -7286,7 +7286,12 @@ static int gfx_v9_0_reset_kcq(struct amdgpu_ring *ring,
 		DRM_ERROR("fail to remap queue\n");
 		return r;
 	}
-	return amdgpu_ring_test_ring(ring);
+
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static void gfx_v9_ip_print(struct amdgpu_ip_block *ip_block, struct drm_printer *p)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index c233edf60569..264b37e85696 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -3619,7 +3619,12 @@ static int gfx_v9_4_3_reset_kcq(struct amdgpu_ring *ring,
 		dev_err(adev->dev, "fail to remap queue\n");
 		return r;
 	}
-	return amdgpu_ring_test_ring(ring);
+
+	r = amdgpu_ring_test_ring(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 enum amdgpu_gfx_cp_ras_mem_id {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index 4cde8a8bcc83..49620fbf6c7a 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -766,9 +766,15 @@ static int jpeg_v2_0_process_interrupt(struct amdgpu_device *adev,
 
 static int jpeg_v2_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	jpeg_v2_0_stop(ring->adev);
 	jpeg_v2_0_start(ring->adev);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v2_0_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index 8b39e114f3be..98ae9c0e83f7 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -645,9 +645,15 @@ static int jpeg_v2_5_process_interrupt(struct amdgpu_device *adev,
 
 static int jpeg_v2_5_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	jpeg_v2_5_stop_inst(ring->adev, ring->me);
 	jpeg_v2_5_start_inst(ring->adev, ring->me);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v2_5_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index 2f8510c2986b..7fb599430365 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -557,9 +557,15 @@ static int jpeg_v3_0_process_interrupt(struct amdgpu_device *adev,
 
 static int jpeg_v3_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	jpeg_v3_0_stop(ring->adev);
 	jpeg_v3_0_start(ring->adev);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v3_0_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
index f17ec5414fd6..a6612c942b93 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -722,12 +722,18 @@ static int jpeg_v4_0_process_interrupt(struct amdgpu_device *adev,
 
 static int jpeg_v4_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	if (amdgpu_sriov_vf(ring->adev))
 		return -EINVAL;
 
 	jpeg_v4_0_stop(ring->adev);
 	jpeg_v4_0_start(ring->adev);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v4_0_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 79e342d5ab28..90d773dbe337 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1145,12 +1145,18 @@ static void jpeg_v4_0_3_core_stall_reset(struct amdgpu_ring *ring)
 
 static int jpeg_v4_0_3_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	if (amdgpu_sriov_vf(ring->adev))
 		return -EOPNOTSUPP;
 
 	jpeg_v4_0_3_core_stall_reset(ring);
 	jpeg_v4_0_3_start_jrbc(ring);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v4_0_3_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 3b6f65a25646..7cad77a968f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -836,12 +836,18 @@ static void jpeg_v5_0_1_core_stall_reset(struct amdgpu_ring *ring)
 
 static int jpeg_v5_0_1_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	int r;
+
 	if (amdgpu_sriov_vf(ring->adev))
 		return -EOPNOTSUPP;
 
 	jpeg_v5_0_1_core_stall_reset(ring);
 	jpeg_v5_0_1_init_jrbc(ring);
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amd_ip_funcs jpeg_v5_0_1_ip_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index 5de2f047c534..9f0ad1199431 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -1674,6 +1674,7 @@ static bool sdma_v4_4_2_page_ring_is_guilty(struct amdgpu_ring *ring)
 
 static int sdma_v4_4_2_reset_queue(struct amdgpu_ring *ring, unsigned int vmid)
 {
+	bool is_guilty = ring->funcs->is_guilty(ring);
 	struct amdgpu_device *adev = ring->adev;
 	u32 id = ring->me;
 	int r;
@@ -1684,8 +1685,13 @@ static int sdma_v4_4_2_reset_queue(struct amdgpu_ring *ring, unsigned int vmid)
 	amdgpu_amdkfd_suspend(adev, true);
 	r = amdgpu_sdma_reset_engine(adev, id);
 	amdgpu_amdkfd_resume(adev, true);
+	if (r)
+		return r;
 
-	return r;
+	if (is_guilty)
+		amdgpu_fence_driver_force_completion(ring);
+
+	return 0;
 }
 
 static int sdma_v4_4_2_stop_queue(struct amdgpu_ring *ring)
@@ -1729,8 +1735,8 @@ static int sdma_v4_4_2_stop_queue(struct amdgpu_ring *ring)
 static int sdma_v4_4_2_restore_queue(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	u32 inst_mask;
-	int i;
+	u32 inst_mask, tmp_mask;
+	int i, r;
 
 	inst_mask = 1 << ring->me;
 	udelay(50);
@@ -1747,7 +1753,24 @@ static int sdma_v4_4_2_restore_queue(struct amdgpu_ring *ring)
 		return -ETIMEDOUT;
 	}
 
-	return sdma_v4_4_2_inst_start(adev, inst_mask, true);
+	r = sdma_v4_4_2_inst_start(adev, inst_mask, true);
+	if (r)
+		return r;
+
+	tmp_mask = inst_mask;
+	for_each_inst(i, tmp_mask) {
+		ring = &adev->sdma.instance[i].ring;
+
+		amdgpu_fence_driver_force_completion(ring);
+
+		if (adev->sdma.has_page_queue) {
+			struct amdgpu_ring *page = &adev->sdma.instance[i].page;
+
+			amdgpu_fence_driver_force_completion(page);
+		}
+	}
+
+	return r;
 }
 
 static int sdma_v4_4_2_set_trap_irq_state(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 37f4b5b4a098..b43d6cb8a0d4 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1616,7 +1616,10 @@ static int sdma_v5_0_restore_queue(struct amdgpu_ring *ring)
 
 	r = sdma_v5_0_gfx_resume_instance(adev, inst_id, true);
 	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
-	return r;
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int sdma_v5_0_ring_preempt_ib(struct amdgpu_ring *ring)
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 0b40411b92a0..a88aa53e887c 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -1532,7 +1532,10 @@ static int sdma_v5_2_restore_queue(struct amdgpu_ring *ring)
 	r = sdma_v5_2_gfx_resume_instance(adev, inst_id, true);
 
 	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
-	return r;
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int sdma_v5_2_ring_preempt_ib(struct amdgpu_ring *ring)
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
index a9bdf8d61d6c..041bca58add5 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1572,7 +1572,11 @@ static int sdma_v6_0_reset_queue(struct amdgpu_ring *ring, unsigned int vmid)
 	if (r)
 		return r;
 
-	return sdma_v6_0_gfx_resume_instance(adev, i, true);
+	r = sdma_v6_0_gfx_resume_instance(adev, i, true);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static int sdma_v6_0_set_trap_irq_state(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
index 86903eccbd4e..b4167f23c02d 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -824,7 +824,11 @@ static int sdma_v7_0_reset_queue(struct amdgpu_ring *ring, unsigned int vmid)
 	if (r)
 		return r;
 
-	return sdma_v7_0_gfx_resume_instance(adev, i, true);
+	r = sdma_v7_0_gfx_resume_instance(adev, i, true);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
index b5071f77f78d..46c329a1b2f5 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1971,6 +1971,7 @@ static int vcn_v4_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vcn_inst *vinst = &adev->vcn.inst[ring->me];
+	int r;
 
 	if (!(adev->vcn.supported_reset & AMDGPU_RESET_TYPE_PER_QUEUE))
 		return -EOPNOTSUPP;
@@ -1978,7 +1979,11 @@ static int vcn_v4_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 	vcn_v4_0_stop(vinst);
 	vcn_v4_0_start(vinst);
 
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static struct amdgpu_ring_funcs vcn_v4_0_unified_ring_vm_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index 5a33140f5723..faba11166efb 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1621,8 +1621,10 @@ static int vcn_v4_0_3_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 	vcn_v4_0_3_hw_init_inst(vinst);
 	vcn_v4_0_3_start_dpg_mode(vinst, adev->vcn.inst[ring->me].indirect_sram);
 	r = amdgpu_ring_test_helper(ring);
-
-	return r;
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amdgpu_ring_funcs vcn_v4_0_3_unified_ring_vm_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index 16ade84facc7..af29a8e141a4 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -1469,6 +1469,7 @@ static int vcn_v4_0_5_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vcn_inst *vinst = &adev->vcn.inst[ring->me];
+	int r;
 
 	if (!(adev->vcn.supported_reset & AMDGPU_RESET_TYPE_PER_QUEUE))
 		return -EOPNOTSUPP;
@@ -1476,7 +1477,11 @@ static int vcn_v4_0_5_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 	vcn_v4_0_5_stop(vinst);
 	vcn_v4_0_5_start(vinst);
 
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static struct amdgpu_ring_funcs vcn_v4_0_5_unified_ring_vm_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
index f8e3f0b882da..216324f6da85 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_0.c
@@ -1196,6 +1196,7 @@ static int vcn_v5_0_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_vcn_inst *vinst = &adev->vcn.inst[ring->me];
+	int r;
 
 	if (!(adev->vcn.supported_reset & AMDGPU_RESET_TYPE_PER_QUEUE))
 		return -EOPNOTSUPP;
@@ -1203,7 +1204,11 @@ static int vcn_v5_0_0_ring_reset(struct amdgpu_ring *ring, unsigned int vmid)
 	vcn_v5_0_0_stop(vinst);
 	vcn_v5_0_0_start(vinst);
 
-	return amdgpu_ring_test_helper(ring);
+	r = amdgpu_ring_test_helper(ring);
+	if (r)
+		return r;
+	amdgpu_fence_driver_force_completion(ring);
+	return 0;
 }
 
 static const struct amdgpu_ring_funcs vcn_v5_0_0_unified_ring_vm_funcs = {
-- 
2.39.5



