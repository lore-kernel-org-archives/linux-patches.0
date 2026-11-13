Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585835;
	b=gSb861ynqPeVPtdvCJJLLdyjR5p56FmmPLXm4Ek1dMfKuGI4tRoagPWRVDYeO6cWc+Ui
	 DbkFCZbb+0zddiJimHP7bEWPEaQ3Ev9aF8MTXBBh/RM4kBwdAfEVUKJRdcSzA7LHY+Ocg
	 +yZYPKO5ZdxtOJM6EcM87UmYixzZpRN/VWwQClGdEbDi7QgIpi8eHFrjbM4dR+hPrSx6M
	 wv7d/Fp1sp3Ovnv+xFAqH3dTN2pwe5oF3dj6pyzleVOD4N4BP4FX4DKWKJ9Eg0kkyiVOy
	 GbN4BwEA2ZiJoH5gZudsUAg8Xy8hXb8dJ3w7cDbZ8FVAEFuDDH3JBh8Zd/iA2vTDjhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n+iYoqImGicct81/gqLRWPr7amJyeQQ/wBQweR2OEZg=;
	b=gE2a7Cu86h3zJBgsIgeHr7LeYWVkF1rYSqnbfByAsz7JH3I4/HTFK8/p/0771XI+1ubq
	 9T3DC1cvSLDo4tdWQh/+6dIMDVkLDFVNSM5i2JX54ZbN7j3uJfne4RMdAhQl8X96xVC4I
	 VQSJokDhRhndxu0VVYGesZb99qD0I13WGyYVQbjKS7J5/0nPSZumcQMbicbnKyNH2r/7V
	 EV+pCCbCcvTMb027H5JkzFOjD7kczi1i3cp2fLAUF1QQjGJNYsjsdhuDvRHAYNDo1y4YN
	 nZd5X8g2tagM8Hvl8WUuI30e3KN8wvEie54lz74HBr0Dji/9/czwrkM/qf3CZbKcYDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2f0QFBQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43806606BAA6;
	Fri, 13 Nov 2026 16:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2f0QFBQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CA11F000C4;
	Fri, 13 Nov 2026 16:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585835;
	bh=n+iYoqImGicct81/gqLRWPr7amJyeQQ/wBQweR2OEZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2f0QFBQa1iaH/gPlCY2dUWBqWKskNg7AbSt6za6rikatxcxGF4DCeuyuYjuU2G3HA
	 /sTOVlsmWNQqzx0BKE17vgqGtX0LZIPgGygnZjcAGUfTKZANDjih36qaxarzuYQ/jp
	 ikx7bBJzJ0MxAgjjvB2dNXaxn3hHgucPSRDoYGs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 372/507] drm/amdgpu: Fix duplicate dependency fence releases
Date: Fri, 13 Nov 2026 10:51:16 -0500
Message-ID: <20261113153808.766405147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erhan Bilgili <erhan.bilgili@gmail.com>

[ Upstream commit ea47f84199241dd083d40a241beea665415d4f6c ]

drm_sched_job_add_dependency() consumes its fence reference on success
and failure. Do not release the fence again if
drm_sched_job_add_dependency() fails.

Fixes: 41cc108b2451 ("drm/amdgpu: fix missing dma_fence_put in error path")
Fixes: c1c4a8b21721 ("drm/amdgpu: grab extra fence reference for drm_sched_job_add_dependency")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Erhan Bilgili <erhan.bilgili@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e04f3dfb2071451633e6440a3911a9bb65df9144)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c    | 4 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index d6ae9974c952e..4f31021b21520 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -447,10 +447,8 @@ int amdgpu_sync_push_to_job(struct amdgpu_sync *sync, struct amdgpu_job *job)
 
 		dma_fence_get(f);
 		r = drm_sched_job_add_dependency(&job->base, f);
-		if (r) {
-			dma_fence_put(f);
+		if (r)
 			return r;
-		}
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index eb8cf0d9d9c59..652266e937664 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -234,7 +234,6 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 		dma_fence_get(fence);
 		r = drm_sched_job_add_dependency(&p->job->base, fence);
 		if (r) {
-			dma_fence_put(fence);
 			dma_resv_iter_end(&cursor);
 			return r;
 		}
-- 
2.53.0



