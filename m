Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7351139341F;
	Wed, 21 Jan 2026 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020114; cv=none; b=U3uszHWZpphPB5qVDlRw3SZIwlzJxlymwONRfg1hTBJC/9NsG2W71Gf4UQPxRxrdV+4mXJ3NmO8wgBmxggCicCnay2uWGBGznmh091br+9iJu8CQBBJjVfOx9S2UIvh3eXBcpxQKFT0ij9to+To2nJSbhvQvYGOLwa46DKdS/Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020114; c=relaxed/simple;
	bh=Jl569x0wmUB0YJ48ng7+bjxKNnW6DubsKl+k1WvOTSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HpmiQUrbQzKnZ+S+VKXAkowDq6pV4mEDik+CMWxlZpeZb+nmbunz/+9PxUirFMb+bqGsGnB0JOi2g8qTfMgsHIcpoxaqjlpcHpDUvqp+XvHYHINCx1lla/PfD2tfdIMBIpp9NFZiZvtrAJj6ThOZ7ouBZ6HK/ty3Iubi7PJymvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuAZTvJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuAZTvJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6448C4CEF1;
	Wed, 21 Jan 2026 18:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020114;
	bh=Jl569x0wmUB0YJ48ng7+bjxKNnW6DubsKl+k1WvOTSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuAZTvJEVG49NoDOMFLP8Nt09OyqFT8r8ymsj/ckC5Q8LPwgVY+/Qo+xv4x+LmhRH
	 q3E99kJA0Ic4ByiDX1nj3Dpp22CxAc7AIVppYkEh6/F7y1gTqo/HXelo+uinCzpoOx
	 t0KB8LZseZDTeo7imgclSrd5RraKqf7bs9FKpxHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/198] drm/amdgpu/userq: Fix fence reference leak on queue teardown v2
Date: Wed, 21 Jan 2026 19:14:50 +0100
Message-ID: <20260121181420.789764022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

[ Upstream commit b2426a211dba6432e32a2e70e9183c6e134475c6 ]

The user mode queue keeps a pointer to the most recent fence in
userq->last_fence. This pointer holds an extra dma_fence reference.

When the queue is destroyed, we free the fence driver and its xarray,
but we forgot to drop the last_fence reference.

Because of the missing dma_fence_put(), the last fence object can stay
alive when the driver unloads. This leaves an allocated object in the
amdgpu_userq_fence slab cache and triggers

This is visible during driver unload as:

  BUG amdgpu_userq_fence: Objects remaining on __kmem_cache_shutdown()
  kmem_cache_destroy amdgpu_userq_fence: Slab cache still has objects
  Call Trace:
    kmem_cache_destroy
    amdgpu_userq_fence_slab_fini
    amdgpu_exit
    __do_sys_delete_module

Fix this by putting userq->last_fence and clearing the pointer during
amdgpu_userq_fence_driver_free().

This makes sure the fence reference is released and the slab cache is
empty when the module exits.

v2: Update to only release userq->last_fence with dma_fence_put()
    (Christian)

Fixes: edc762a51c71 ("drm/amdgpu/userq: move some code around")
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8e051e38a8d45caf6a866d4ff842105b577953bb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 4d0096d0baa9d..53fe10931fab0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -141,6 +141,8 @@ static void amdgpu_userq_walk_and_drop_fence_drv(struct xarray *xa)
 void
 amdgpu_userq_fence_driver_free(struct amdgpu_usermode_queue *userq)
 {
+	dma_fence_put(userq->last_fence);
+
 	amdgpu_userq_walk_and_drop_fence_drv(&userq->fence_drv_xa);
 	xa_destroy(&userq->fence_drv_xa);
 	/* Drop the fence_drv reference held by user queue */
-- 
2.51.0



