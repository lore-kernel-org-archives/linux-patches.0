Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AC219E971;
	Mon, 23 Dec 2024 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970418; cv=none; b=gfYxRYWGBmG69GSRVje1UQxD1Hr4v4P8g5Iq8OdZX3YQjFpSOYkozU1OK8JYUd8Utl1xPMtTroVMB4We0w3xaE1KWxBA7hVd0I1qI9m5AHGZiC1tdRWVMOyiNIeOhdqCUzL8Luf85ghrJyQ0iGAaFHTpuAz1TPM4EaTunqj3kO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970418; c=relaxed/simple;
	bh=bHr9/ewiTXXlllNtB/ksElHGSbWXKrCpP4BTR6mwfIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTv6BHXYDNdKe9SubIhy4uGz5Jh2TcRHGriVf69KeZWoLtHEMzYCLlxL/0t4ThgY4fzXkP2I4w6Rr+LTklOYdM/Fr+lx3irz1lfw7ZCpclhbPXGsKAzy+yUE3FCH8kiKuysKhWWD8dMcbGWzz11+AGM4e5KJqWU0oivMqfauuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxlq9lWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxlq9lWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A438BC4CED3;
	Mon, 23 Dec 2024 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970418;
	bh=bHr9/ewiTXXlllNtB/ksElHGSbWXKrCpP4BTR6mwfIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxlq9lWoDe6XtYDUCpGdPrvPqJ3ZqRbEDr0omEJpE+E6JL7l6ccW4wOsyZ2yqIi+0
	 1/x3NVZtyheP4JqDkBCeYtTHKw1Yf0j/aEsW/v9mn7LGFvssOSHUoaj09oc+TJUuP5
	 JY5GSnntzDMTeD1NcBouIwv6onfSGvWrcPMbIYPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/116] drm/amdgpu: dont access invalid sched
Date: Mon, 23 Dec 2024 16:59:08 +0100
Message-ID: <20241223155402.594895959@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>

[ Upstream commit a93b1020eb9386d7da11608477121b10079c076a ]

Since 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
accessing job->base.sched can produce unexpected results as the initialisation
of (*job)->base.sched done in amdgpu_job_alloc is overwritten by the
memset.

This commit fixes an issue when a CS would fail validation and would
be rejected after job->num_ibs is incremented. In this case,
amdgpu_ib_free(ring->adev, ...) will be called, which would crash the
machine because the ring value is bogus.

To fix this, pass a NULL pointer to amdgpu_ib_free(): we can do this
because the device is actually not used in this function.

The next commit will remove the ring argument completely.

Fixes: 2320c9e6a768 ("drm/sched: memset() 'job' in drm_sched_job_init()")
Signed-off-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2ae520cb12831d264ceb97c61f72c59d33c0dbd7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index 99dd86337e84..49a6b6b88843 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -159,7 +159,6 @@ void amdgpu_job_set_resources(struct amdgpu_job *job, struct amdgpu_bo *gds,
 
 void amdgpu_job_free_resources(struct amdgpu_job *job)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
 	struct dma_fence *f;
 	unsigned i;
 
@@ -172,7 +171,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 		f = NULL;
 
 	for (i = 0; i < job->num_ibs; ++i)
-		amdgpu_ib_free(ring->adev, &job->ibs[i], f);
+		amdgpu_ib_free(NULL, &job->ibs[i], f);
 }
 
 static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
-- 
2.39.5



