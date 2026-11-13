Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590501;
	b=xT+UxL/aNZpEzQdLvf0rfWhQf8xQ1NnB+lPY6IErlqPOfSXutd6rFo/X1TkMXjC7smH4
	 OFD2p6NM3PXivd+TXnQ/C46OY7EfKEgyWkwwaHgcM4qj3w7k4lKlyMnvxOGPM72tziEYJ
	 KnDbYdwSjiS1vPKuJwS8OtXM2wFJPcj+0YRFqSDFDTQffE1yKUirYNhakfh/gHnlV7krB
	 E4kP3aQwsmD5xke7/fThAycX8JRmbGXpxcCvhLzFMVjOIykAbNIA15yQA4f51mg6Wa5o6
	 GZwnbfOMC9T4gk27JNunhUR8D5oTviRr8f+PtbSO4fina+W/RDUgu9eVviXVPyEEcFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZF9cEo8E+wKci7YDu12/RiFwoQ5aE5tkUYSpb44qWo=;
	b=AmLV+QKtJQnBksQK4CKPa0CSxpIT8xoxEgKvyVOdplfU1iYm60jK3A8y9ubIqMjQNJ0k
	 jkHrU6FdTFDwTxgIz0V/UHoN+7T5vxDogdgJ+a4ZHLhUlHUc9vjbVVszyt6Umnhiz2k1T
	 22yINKvlALTwZ8xs3P5hokCzsxf3IZRoSLPuOks45RpQv9wiPxP9ko445d5MdyltGudxf
	 fJMv4WdZ638JLqISoHtccsJ/Ut1RMe2/Srzbt/cypaZe2vhKy0gtwi24OoYzp/c694v1l
	 67pfmTNnX109TLipwndjPMudoLITKKJEy7XIUiGPg257rZjdZZo3J3krJ3LDeGl5qvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOKxWvwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5074C607143B;
	Fri, 13 Nov 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TOKxWvwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BA41F000C4;
	Fri, 13 Nov 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590501;
	bh=bZF9cEo8E+wKci7YDu12/RiFwoQ5aE5tkUYSpb44qWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOKxWvwHRuf0V+HSO3t6Q0z6Iw9t61HqyDwjyyq3qeQpk4s/9sTS3AVUWuhpBef9Q
	 +Svv9GdtnoFNH1OpG+AmjgTG+A3OgjNF8/sRhZk7WnYZOTppD6pTYwOHRABCS13J/X
	 kzL1mL3+dCMeSwGFQHWMhBrqiHb+YdL52yiHYD6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Erhan Bilgili <erhan.bilgili@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 412/686] drm/amdgpu: Fix duplicate dependency fence releases
Date: Fri, 13 Nov 2026 10:49:05 -0500
Message-ID: <20261113153834.936306673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 902d0a538e419..dd72891624ebb 100644
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



