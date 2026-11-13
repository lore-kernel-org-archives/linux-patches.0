Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585786;
	b=aB5uHxZz3L3jLBu8dnhQBg61YzguttOWl836pqxhB9u21rx6yRwtocP13gKHEWp0Jgsv
	 4TkIQSFtgx7cDDbizVVrc+On88GI89BFLqr4YiSJqIZOA+juB43X/N/8K6gtQeTmrWkvg
	 Pua3DvoyE+DRJc6YZFKt41loCSwPAWfYn8bwIhzhBABC2VxSGcCpCBzoIiktA59htf2Bz
	 ui8pcWw28uj1Q0J5vWAhrjNBSd/6sjvVCTUOj8k9gz6mKSHcxX8SuBbvzKkYGcYyF4KeM
	 s3jLOz98XgeCOskzQ67E/tOk27H6VwFvhNXNMdlUHYRfm/OKBz5v250fWZGXjyz0T2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L51M4UtrPxwrisczm0oYgVm03JbjzPfwq0sRujvvjjw=;
	b=etVsWcUX+xYvVPSaTo9ovRICMOqPP6G8VfADnyGNgIbEgGXbzzajFVuiSh4+dQKpmrgy
	 E582fV/OyweUeximflrVvUcw/WXKsM7LGIFH39bwjJJoGjX20+zP72pLBjjIIBf9/hlun
	 teUtlFWE5s8jh+AVgRIfDjHTKF3qKOHl8U5gXRFel0s0BHPcj1ALhs1KB2mEf3Ykm+zSj
	 aXgTDooBpGRlpfCeMnhJLPAQ9NI05YEOrP0lsyaHVYzP6/DdCGX3PH1YlZZEGon9VfzL6
	 eIS3b8yMsFxhrcLwD3SR9gz+YnAtSOXHJlcGkMlY+c1Y2TUdG9Ju6bTrXgTU/DCf3mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnwTFJ0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37AC606D479;
	Fri, 13 Nov 2026 16:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UnwTFJ0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B81F000C6;
	Fri, 13 Nov 2026 16:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585786;
	bh=L51M4UtrPxwrisczm0oYgVm03JbjzPfwq0sRujvvjjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnwTFJ0qDY3Y2J+9NzqbY5Ea0uXvFsBB+0jZUMVDdfGlBQf5UvYfluFushFYF+0nn
	 2fcsRN7yiYTG9IgAvslVNECzdmAMXmWHVXcjLn0otJlTR5uo/qLyu82d9tKiEZuu4A
	 pxVxf4IQ5uJ0cufBqxku9bx6p3x1hhcr9twngKBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 376/507] drm/amdgpu: unlock the VM and BO when attaching a KFD BO fails
Date: Fri, 13 Nov 2026 10:51:20 -0500
Message-ID: <20261113153808.935756048@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit e0a1404b34e0002f03f7979cdb791a9b5c3963f5 ]

kfd_mem_attach() locks the page directory and the BO with a drm_exec
transaction on its stack, but leaves through the unwind label without
drm_exec_fini() when locking fails, e.g. when MAP_MEMORY_TO_GPU gets a
signal while the page directory or the BO is busy. Reservations already
acquired then remain locked with their ww_acquire_ctx pointing into the
expired stack frame.

With one thread doing GEM_VA map/unmap on the KFD VM and
another one mapping KFD BOs while getting SIGUSR1 every 20 us:

  BUG: KASAN: stack-out-of-bounds in __ww_mutex_lock.constprop.0+0x34f5/0x3da0
   ww_mutex_lock_interruptible+0x2f/0x150
   drm_exec_lock_obj+0x107/0x2d0 [drm_exec]
   kfd_mem_attach+0x4dd/0x1b60 [amdgpu]

and the process ends up in D state.

Finish the transaction before unwinding.

Fixes: fd1fa48b935f ("drm/amdgpu: lock both VM and BO in amdgpu_gem_object_open")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7b885fa27e4b9fa5cbdc64e66fc35872aee296f5)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 501b1a9f27070..6c657d6060d65 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -975,11 +975,11 @@ static int kfd_mem_attach(struct amdgpu_device *adev, struct kgd_mem *mem,
 			ret = amdgpu_vm_lock_pd(vm, &exec, 0);
 			drm_exec_retry_on_contention(&exec);
 			if (unlikely(ret))
-				goto unwind;
+				goto unlock;
 			ret = drm_exec_lock_obj(&exec, &bo[i]->tbo.base);
 			drm_exec_retry_on_contention(&exec);
 			if (unlikely(ret))
-				goto unwind;
+				goto unlock;
 		}
 
 		bo_va = amdgpu_vm_bo_find(vm, bo[i]);
@@ -1005,6 +1005,8 @@ static int kfd_mem_attach(struct amdgpu_device *adev, struct kgd_mem *mem,
 
 	return 0;
 
+unlock:
+	drm_exec_fini(&exec);
 unwind:
 	for (; i >= 0; i--) {
 		if (!attachment[i])
-- 
2.53.0



