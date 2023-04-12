Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04CC2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CFBC433EF;
	Wed, 12 Apr 2023 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288595;
	bh=4MpD9K1viLKj1tqX2ZdomU2qThJJePFPEfyFO3QQ25E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDaWjHbu3GLXZlGJixFENs9I4bsOLy06RkUSx3tWO5xVq/ae/IQJEfzB3yt5Dhy8q
	 +G0mJFfMZR1bSqVdtsElRL0OM3slShYtoh+iB48k4jCd44M0lkbIQEp8KDftG5X8wt
	 Pe3/qEfXr/hyOjfBaU9UC9LAkwxEC6kGeRAUS5tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/93] drm/amdgpu: Prevent race between late signaled fences and GPU reset.
Date: Wed, 12 Apr 2023 10:33:21 +0200
Message-Id: <20230412082823.908025238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

[ Upstream commit 9e225fb9e636b31b97e9d35324c2f9e43ee0aab4 ]

Problem:
After we start handling timed out jobs we assume there fences won't be
signaled but we cannot be sure and sometimes they fire late. We need
to prevent concurrent accesses to fence array from
amdgpu_fence_driver_clear_job_fences during GPU reset and amdgpu_fence_process
from a late EOP interrupt.

Fix:
Before accessing fence array in GPU disable EOP interrupt and flush
all pending interrupt handlers for amdgpu device's interrupt line.

v2: Switch from irq_get/put to full enable/disable_irq for amdgpu

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 1427a7202739 ("drm/amdgpu: fix amdgpu_job_free_resources v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  4 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c  | 18 ++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h   |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2f51789d98181..8711d39fc2f71 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4609,6 +4609,8 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_virt_fini_data_exchange(adev);
 	}
 
+	amdgpu_fence_driver_isr_toggle(adev, true);
+
 	/* block all schedulers and reset given job's ring */
 	for (i = 0; i < AMDGPU_MAX_RINGS; ++i) {
 		struct amdgpu_ring *ring = adev->rings[i];
@@ -4631,6 +4633,8 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_fence_driver_force_completion(ring);
 	}
 
+	amdgpu_fence_driver_isr_toggle(adev, false);
+
 	if (job && job->vm)
 		drm_sched_increase_karma(&job->base);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index bbd6f7a123033..f3d7094184530 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -569,6 +569,24 @@ void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 	}
 }
 
+/* Will either stop and flush handlers for amdgpu interrupt or reanble it */
+void amdgpu_fence_driver_isr_toggle(struct amdgpu_device *adev, bool stop)
+{
+	int i;
+
+	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
+		struct amdgpu_ring *ring = adev->rings[i];
+
+		if (!ring || !ring->fence_drv.initialized || !ring->fence_drv.irq_src)
+			continue;
+
+		if (stop)
+			disable_irq(adev->irq.irq);
+		else
+			enable_irq(adev->irq.irq);
+	}
+}
+
 void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
 {
 	unsigned int i, j;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index e713d31619fe7..fc87a1fea8b44 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -131,6 +131,7 @@ signed long amdgpu_fence_wait_polling(struct amdgpu_ring *ring,
 				      uint32_t wait_seq,
 				      signed long timeout);
 unsigned amdgpu_fence_count_emitted(struct amdgpu_ring *ring);
+void amdgpu_fence_driver_isr_toggle(struct amdgpu_device *adev, bool stop);
 
 /*
  * Rings.
-- 
2.39.2



