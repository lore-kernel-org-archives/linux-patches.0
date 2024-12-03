Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E21F8AE4;
	Tue,  3 Dec 2024 15:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238699; cv=none; b=EX5kwfLKBNbNgWC8c2r9G9F5jqd0t5+xL1CzQrk8gYd4OZgsK73AdrnJyuKmmgqLvbOgCOWNu/3tBwhQCa+J2fEurgv8xI9sel8859tXeLinB6GjNynXpaKGSvAMvbC5/thV9wpGRdObtloFPVOovWz8G5D1VBApsrPrg9H7VSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238699; c=relaxed/simple;
	bh=kBYPIDJTH+Ug0f1RRAi/QxupDEOgUPIYbjfu/9+xmUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKjOm8GnJAikT+ASeLheaRlzkd4oSHjCKcIYsk8n9b+9PGM/jhuLu8HKDzDreu7cT0qEuwtv3LO2qkCYm9hU/IS9ngbjOCWGC+M2XsYU105U0E2FJ6q1Js/YXNFA3srNklSfdcId2EuVR5rAeu5sl+KRz/e9B1jej3isx2v4nvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fyb8Q4dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fyb8Q4dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF44C4CECF;
	Tue,  3 Dec 2024 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238699;
	bh=kBYPIDJTH+Ug0f1RRAi/QxupDEOgUPIYbjfu/9+xmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fyb8Q4dry/qe28bJjtjxr0g7ImbXOdsJwNR3V1oVtrTMQvWHy2jt2ts+vNGdyH2pF
	 L2/XK6MCOZW5yrXLg2nOiuHZeZz+F0ylFkt4+5L2gj8AHswzoazhOsh/NrVxMNqyDK
	 VtvtVnpLo14J6UaOSyUf4ZWIL7IHWny1TsWkl6R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Le Ma <le.ma@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 340/817] drm/amdgpu: Fix map/unmap queue logic
Date: Tue,  3 Dec 2024 15:38:32 +0100
Message-ID: <20241203144009.093519315@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit fa31798582882740f2b13d19e1bd43b4ef918e2f ]

In current logic, it calls ring_alloc followed by a ring_test. ring_test
in turn will call another ring_alloc. This is illegal usage as a
ring_alloc is expected to be closed properly with a ring_commit. Change
to commit the map/unmap queue packet first followed by a ring_test. Add a
comment about the usage of ring_test.

Also, reorder the current pre-condition checks of job hang or kiq ring
scheduler not ready. Without them being met, it is not useful to attempt
ring or memory allocations.

Fixes tag refers to the original patch which introduced this issue which
then got carried over into newer code.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Le Ma <le.ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: 6c10b5cc4eaa ("drm/amdgpu: Remove duplicate code in gfx_v8_0.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 13 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    | 63 +++++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c      |  7 +++
 3 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index c272461d70a9a..b397c78386739 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -850,6 +850,9 @@ int amdgpu_amdkfd_unmap_hiq(struct amdgpu_device *adev, u32 doorbell_off,
 	if (!kiq->pmf || !kiq->pmf->kiq_unmap_queues)
 		return -EINVAL;
 
+	if (!kiq_ring->sched.ready || adev->job_hang)
+		return 0;
+
 	ring_funcs = kzalloc(sizeof(*ring_funcs), GFP_KERNEL);
 	if (!ring_funcs)
 		return -ENOMEM;
@@ -874,8 +877,14 @@ int amdgpu_amdkfd_unmap_hiq(struct amdgpu_device *adev, u32 doorbell_off,
 
 	kiq->pmf->kiq_unmap_queues(kiq_ring, ring, RESET_QUEUES, 0, 0);
 
-	if (kiq_ring->sched.ready && !adev->job_hang)
-		r = amdgpu_ring_test_helper(kiq_ring);
+	/* Submit unmap queue packet */
+	amdgpu_ring_commit(kiq_ring);
+	/*
+	 * Ring test will do a basic scratch register change check. Just run
+	 * this to ensure that unmap queues that is submitted before got
+	 * processed successfully before returning.
+	 */
+	r = amdgpu_ring_test_helper(kiq_ring);
 
 	spin_unlock(&kiq->ring_lock);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 3ff39d3ec317c..0058f1796c75c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -522,6 +522,17 @@ int amdgpu_gfx_disable_kcq(struct amdgpu_device *adev, int xcc_id)
 	if (!kiq->pmf || !kiq->pmf->kiq_unmap_queues)
 		return -EINVAL;
 
+	if (!kiq_ring->sched.ready || adev->job_hang)
+		return 0;
+	/**
+	 * This is workaround: only skip kiq_ring test
+	 * during ras recovery in suspend stage for gfx9.4.3
+	 */
+	if ((amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 3) ||
+	     amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 4)) &&
+	    amdgpu_ras_in_recovery(adev))
+		return 0;
+
 	spin_lock(&kiq->ring_lock);
 	if (amdgpu_ring_alloc(kiq_ring, kiq->pmf->unmap_queues_size *
 					adev->gfx.num_compute_rings)) {
@@ -535,20 +546,15 @@ int amdgpu_gfx_disable_kcq(struct amdgpu_device *adev, int xcc_id)
 					   &adev->gfx.compute_ring[j],
 					   RESET_QUEUES, 0, 0);
 	}
-
-	/**
-	 * This is workaround: only skip kiq_ring test
-	 * during ras recovery in suspend stage for gfx9.4.3
+	/* Submit unmap queue packet */
+	amdgpu_ring_commit(kiq_ring);
+	/*
+	 * Ring test will do a basic scratch register change check. Just run
+	 * this to ensure that unmap queues that is submitted before got
+	 * processed successfully before returning.
 	 */
-	if ((amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 3) ||
-	    amdgpu_ip_version(adev, GC_HWIP, 0) == IP_VERSION(9, 4, 4)) &&
-	    amdgpu_ras_in_recovery(adev)) {
-		spin_unlock(&kiq->ring_lock);
-		return 0;
-	}
+	r = amdgpu_ring_test_helper(kiq_ring);
 
-	if (kiq_ring->sched.ready && !adev->job_hang)
-		r = amdgpu_ring_test_helper(kiq_ring);
 	spin_unlock(&kiq->ring_lock);
 
 	return r;
@@ -576,8 +582,11 @@ int amdgpu_gfx_disable_kgq(struct amdgpu_device *adev, int xcc_id)
 	if (!kiq->pmf || !kiq->pmf->kiq_unmap_queues)
 		return -EINVAL;
 
-	spin_lock(&kiq->ring_lock);
+	if (!adev->gfx.kiq[0].ring.sched.ready || adev->job_hang)
+		return 0;
+
 	if (amdgpu_gfx_is_master_xcc(adev, xcc_id)) {
+		spin_lock(&kiq->ring_lock);
 		if (amdgpu_ring_alloc(kiq_ring, kiq->pmf->unmap_queues_size *
 						adev->gfx.num_gfx_rings)) {
 			spin_unlock(&kiq->ring_lock);
@@ -590,11 +599,17 @@ int amdgpu_gfx_disable_kgq(struct amdgpu_device *adev, int xcc_id)
 						   &adev->gfx.gfx_ring[j],
 						   PREEMPT_QUEUES, 0, 0);
 		}
-	}
+		/* Submit unmap queue packet */
+		amdgpu_ring_commit(kiq_ring);
 
-	if (adev->gfx.kiq[0].ring.sched.ready && !adev->job_hang)
+		/*
+		 * Ring test will do a basic scratch register change check.
+		 * Just run this to ensure that unmap queues that is submitted
+		 * before got processed successfully before returning.
+		 */
 		r = amdgpu_ring_test_helper(kiq_ring);
-	spin_unlock(&kiq->ring_lock);
+		spin_unlock(&kiq->ring_lock);
+	}
 
 	return r;
 }
@@ -699,7 +714,13 @@ int amdgpu_gfx_enable_kcq(struct amdgpu_device *adev, int xcc_id)
 		kiq->pmf->kiq_map_queues(kiq_ring,
 					 &adev->gfx.compute_ring[j]);
 	}
-
+	/* Submit map queue packet */
+	amdgpu_ring_commit(kiq_ring);
+	/*
+	 * Ring test will do a basic scratch register change check. Just run
+	 * this to ensure that map queues that is submitted before got
+	 * processed successfully before returning.
+	 */
 	r = amdgpu_ring_test_helper(kiq_ring);
 	spin_unlock(&kiq->ring_lock);
 	if (r)
@@ -750,7 +771,13 @@ int amdgpu_gfx_enable_kgq(struct amdgpu_device *adev, int xcc_id)
 						 &adev->gfx.gfx_ring[j]);
 		}
 	}
-
+	/* Submit map queue packet */
+	amdgpu_ring_commit(kiq_ring);
+	/*
+	 * Ring test will do a basic scratch register change check. Just run
+	 * this to ensure that map queues that is submitted before got
+	 * processed successfully before returning.
+	 */
 	r = amdgpu_ring_test_helper(kiq_ring);
 	spin_unlock(&kiq->ring_lock);
 	if (r)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index b4658c7db0e16..618972c43aac5 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -4823,6 +4823,13 @@ static int gfx_v8_0_kcq_disable(struct amdgpu_device *adev)
 		amdgpu_ring_write(kiq_ring, 0);
 		amdgpu_ring_write(kiq_ring, 0);
 	}
+	/* Submit unmap queue packet */
+	amdgpu_ring_commit(kiq_ring);
+	/*
+	 * Ring test will do a basic scratch register change check. Just run
+	 * this to ensure that unmap queues that is submitted before got
+	 * processed successfully before returning.
+	 */
 	r = amdgpu_ring_test_helper(kiq_ring);
 	if (r)
 		DRM_ERROR("KCQ disable failed\n");
-- 
2.43.0



