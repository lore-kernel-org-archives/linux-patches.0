Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0462572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D81C433D2;
	Tue, 18 Apr 2023 12:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822301;
	bh=ln6XzTMYNR/OxX7UOrfi6W+HYBL2AaaT9QbQO/DSoqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0ySYozERmSi74lXGijaoH4I3rbX6Y5LZyVEePM5rtsJurd8fFuXVwzlg0fX/vuY0
	 vmGUQGiUk0vA5knOM6rIYYYRIRgudBgAnKomNIcp/Lu1+Z0ZW75Bn+OOfEgLdS3+1D
	 OeerSpJpyzAdfNEZEiHMkhuGF9sdyznUnyTYDmQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuBiao Wang <YuBiao.Wang@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 097/139] drm/amdgpu: Force signal hw_fences that are embedded in non-sched jobs
Date: Tue, 18 Apr 2023 14:22:42 +0200
Message-Id: <20230418120317.430779142@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YuBiao Wang <YuBiao.Wang@amd.com>

[ Upstream commit 033c56474acf567a450f8bafca50e0b610f2b716 ]

[Why]
For engines not supporting soft reset, i.e. VCN, there will be a failed
ib test before mode 1 reset during asic reset. The fences in this case
are never signaled and next time when we try to free the sa_bo, kernel
will hang.

[How]
During pre_asic_reset, driver will clear job fences and afterwards the
fences' refcount will be reduced to 1. For drm_sched_jobs it will be
released in job_free_cb, and for non-sched jobs like ib_test, it's meant
to be released in sa_bo_free but only when the fences are signaled. So
we have to force signal the non_sched bad job's fence during
pre_asic_reset or the clear is not complete.

Signed-off-by: YuBiao Wang <YuBiao.Wang@amd.com>
Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index faff4a3f96e6e..f52d0ba91a770 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -678,6 +678,15 @@ void amdgpu_fence_driver_clear_job_fences(struct amdgpu_ring *ring)
 		ptr = &ring->fence_drv.fences[i];
 		old = rcu_dereference_protected(*ptr, 1);
 		if (old && old->ops == &amdgpu_job_fence_ops) {
+			struct amdgpu_job *job;
+
+			/* For non-scheduler bad job, i.e. failed ib test, we need to signal
+			 * it right here or we won't be able to track them in fence_drv
+			 * and they will remain unsignaled during sa_bo free.
+			 */
+			job = container_of(old, struct amdgpu_job, hw_fence);
+			if (!job->base.s_fence && !dma_fence_is_signaled(old))
+				dma_fence_signal(old);
 			RCU_INIT_POINTER(*ptr, NULL);
 			dma_fence_put(old);
 		}
-- 
2.39.2



