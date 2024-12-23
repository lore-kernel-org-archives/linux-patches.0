Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D2A1B412B;
	Mon, 23 Dec 2024 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969951; cv=none; b=BjkKqfMWpq6WtsQl574lkNgn+9jHqgR9x1533mnUOEt1zRjdOUkGjlFa79DSp1isOJWCRBF3IGL/VchqLaJ3qfN0YEW98en7msW7OdVIMVrrX9hMRJB2TwIvYHTEDTXeVKa1FmS0HKAffmX/bk+qdTpC8i7nEQsDat7653KpOS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969951; c=relaxed/simple;
	bh=hrolgPpUiFOgoPN6ky8oMNw/Us4d8jkJugQU2OHyDyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hrKB8QumZyP0O9doH2SmCE7c/iMUt/4rxp6rGyJ0NMlfmqNNSYdUEK2JACZngDknuas6NBPnujhjFG3sDsje/yv6UjNlpXEOCbHncHcrDOfroPFSNWJgzyhxr61GT+5KG9kjZDY9b8o+XXIRU6oPC0mTyqBRO/Ih1s3xfDg5exc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ln6lRAOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ln6lRAOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FEDC4CED4;
	Mon, 23 Dec 2024 16:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969950;
	bh=hrolgPpUiFOgoPN6ky8oMNw/Us4d8jkJugQU2OHyDyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln6lRAOFvow6PiJ+pY+lPtfV66vhZyOV40BmP4JPRQaIzNzoYLlNulPGkZbnkYnM1
	 61On3FGjaYV5Sb2BzVEKuSNHH6oqr6v3bR7kPfo3QrmsW3uofvZxxqQIjfN2LGElvS
	 6emNduivSsCtaj5DwvDrp9srjNXudTSoZVCSaiy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/160] drm/amdgpu: dont access invalid sched
Date: Mon, 23 Dec 2024 16:58:31 +0100
Message-ID: <20241223155412.545583711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16f2605ac50b..1ce20a19be8b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -253,7 +253,6 @@ void amdgpu_job_set_resources(struct amdgpu_job *job, struct amdgpu_bo *gds,
 
 void amdgpu_job_free_resources(struct amdgpu_job *job)
 {
-	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
 	struct dma_fence *f;
 	unsigned i;
 
@@ -266,7 +265,7 @@ void amdgpu_job_free_resources(struct amdgpu_job *job)
 		f = NULL;
 
 	for (i = 0; i < job->num_ibs; ++i)
-		amdgpu_ib_free(ring->adev, &job->ibs[i], f);
+		amdgpu_ib_free(NULL, &job->ibs[i], f);
 }
 
 static void amdgpu_job_free_cb(struct drm_sched_job *s_job)
-- 
2.39.5



