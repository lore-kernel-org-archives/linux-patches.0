Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989623DE431;
	Tue, 31 Mar 2026 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975891; cv=none; b=MIcmr7wC2BmPOnPeqnegMdTfceSnLKurGD0olVWlLS+iX6vHrUKjZL3rPtB4rVzmobNwJFUE2QUaawzg4JOjz5kDra9rQh1Vq9J6tZL5QmL494GPZHJa3aEhUUpdOlsdWUq2M2Plc/IGkf6d5L+LVZLohA2KlHmoGFywK8MlOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975891; c=relaxed/simple;
	bh=l9FRl0c2pO2Tq4gn2y6TEeD35pfzGW+bE3TAnbWJfKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FABs8RLOfLNw+d3Tukbo41Zx948R/qiEOOHCi/+cu2/LyGHKbLppsL6rCnUWvzMqyHGU5zyWBdYC2JmxJ0os/luVEc9BMgd/Q28ubANmP28iFVu3RC9l8b5uTLS+kantqhcYyS2+VQjt23jxBHVtLYs/jt1s978viy7powyA4wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFGRNuMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFGRNuMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE688C19423;
	Tue, 31 Mar 2026 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975891;
	bh=l9FRl0c2pO2Tq4gn2y6TEeD35pfzGW+bE3TAnbWJfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFGRNuMe/+bVAvva02mz+4SBPz61B6Au2M86c95d/Utk1f3DrN5sSecP1qCakbCl3
	 GgfdLIhIHwQguY0Ivn7t9ZGKbZu078lWYrKctl/GhSAprEnTv6N7VVGOQlXn6tNAvR
	 dV/99IiILWpF44Jub4Chj39xy5ExcRo8IlMVz0mQ=
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
Subject: [PATCH 6.12 126/244] drm/amdgpu: Fix fence put before wait in amdgpu_amdkfd_submit_ib
Date: Tue, 31 Mar 2026 18:21:16 +0200
Message-ID: <20260331161746.311137946@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 84e5364d1f67d..a872da6324865 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -702,9 +702,9 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
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



