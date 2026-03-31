Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C472D63E8;
	Tue, 31 Mar 2026 17:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976670; cv=none; b=cUXUQxmhwiq1twq8besaBPmeU28ZkFpYf7JRuVjIVsG3EQ3ufNNR/xHWOKZdvsoB3kA6KAj3UYQEbWCJ/9uYXuwlnNs7RKsS0/cWD0iknh8t7A5FvzoIDW4cZl79PqUBLhS2f0KSSF+I7HjbeorkQ63Bvzc9jeW5NT6k6EE/qeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976670; c=relaxed/simple;
	bh=URUWnhx5e1yr0+12OShgorCxTEerUQSWWWijZ9LMkBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xghw+IcFTZDJDR5DSTIteM+qwSdEQHUa3d29eWRfjGyDvB2ICJXbXNf8vf4TsqqlY6TyUcnjfYwEsJ0/mlhNQSZmXSZWI9bgMpnBDN3HcrDSRALfqqB8bV5RRHr1NXAv0Ajdv+jzbAGlz5MpSduaMGDaGJ+yBefC+n0h+l7Op7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTH3Xk8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTH3Xk8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE97DC2BCB1;
	Tue, 31 Mar 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976670;
	bh=URUWnhx5e1yr0+12OShgorCxTEerUQSWWWijZ9LMkBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTH3Xk8CF44HJS3wILBL0AWVDF+satsDac9vhTZYAtzWgTdugLp+aeFhMQkFClO49
	 yjWb0l+crw3GKK8RayoJO7kUDU2N9Z50HfcvWf+zo+99twoxdQhTfZ4jxxjdpyFGJl
	 QsrC36joTp+vWgi1C9SriaweS3xkPFLDXNZe9B/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/309] drm/amdgpu: Fix fence put before wait in amdgpu_amdkfd_submit_ib
Date: Tue, 31 Mar 2026 18:21:08 +0200
Message-ID: <20260331161759.539081477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 7150850146ebfa4ca998f653f264b8df6f7f85be ]

amdgpu_amdkfd_submit_ib() submits a GPU job and gets a fence
from amdgpu_ib_schedule(). This fence is used to wait for job
completion.

Currently, the code drops the fence reference using dma_fence_put()
before calling dma_fence_wait().

If dma_fence_put() releases the last reference, the fence may be
freed before dma_fence_wait() is called. This can lead to a
use-after-free.

Fix this by waiting on the fence first and releasing the reference
only after dma_fence_wait() completes.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c:697 amdgpu_amdkfd_submit_ib() warn: passing freed memory 'f' (line 696)

Fixes: 9ae55f030dc5 ("drm/amdgpu: Follow up change to previous drm scheduler change.")
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8b9e5259adc385b61a6590a13b82ae0ac2bd3482)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index a2879d2b7c8ec..1ec26be82f30e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -687,9 +687,9 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
 		goto err_ib_sched;
 	}
 
-	/* Drop the initial kref_init count (see drm_sched_main as example) */
-	dma_fence_put(f);
 	ret = dma_fence_wait(f, false);
+	/* Drop the returned fence reference after the wait completes */
+	dma_fence_put(f);
 
 err_ib_sched:
 	amdgpu_job_free(job);
-- 
2.53.0



