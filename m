Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F111094A;
	Mon,  3 Jul 2023 18:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C649C433C8;
	Mon,  3 Jul 2023 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410650;
	bh=1Bj4CpYcal7jxAqaT5biZgAyCAA7N2tO8+RTqooD9GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7nj2AZAlLQhCtO5vbF6FtwkJ/OlZLSDRpqqJbhlOHM7t6MkPGrpYlJjIZxTTklJW
	 If6AX+FgKwUtP8KubxDYcZiAj1dSSuJS0FySPJWYWCbSbhK/vqwZPi9RvixLPVw1ws
	 76+tYWD61f7CgjXU7y72MGkhQTXuL6CXO9Ln9FgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Linux Regressions <regressions@lists.linux.dev>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 5.15 05/15] drm/amdgpu: Set vmbo destroy after pt bo is created
Date: Mon,  3 Jul 2023 20:54:50 +0200
Message-ID: <20230703184519.043464257@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184518.896751186@linuxfoundation.org>
References: <20230703184518.896751186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philip Yang <Philip.Yang@amd.com>

commit 9a3c6067bd2ee2ca2652fbb0679f422f3c9109f9 upstream.

Under VRAM usage pression, map to GPU may fail to create pt bo and
vmbo->shadow_list is not initialized, then ttm_bo_release calling
amdgpu_bo_vm_destroy to access vmbo->shadow_list generates below
dmesg and NULL pointer access backtrace:

Set vmbo destroy callback to amdgpu_bo_vm_destroy only after creating pt
bo successfully, otherwise use default callback amdgpu_bo_destroy.

amdgpu: amdgpu_vm_bo_update failed
amdgpu: update_gpuvm_pte() failed
amdgpu: Failed to map bo to gpuvm
amdgpu 0000:43:00.0: amdgpu: Failed to map peer:0000:43:00.0 mem_domain:2
BUG: kernel NULL pointer dereference, address:
 RIP: 0010:amdgpu_bo_vm_destroy+0x4d/0x80 [amdgpu]
 Call Trace:
  <TASK>
  ttm_bo_release+0x207/0x320 [amdttm]
  amdttm_bo_init_reserved+0x1d6/0x210 [amdttm]
  amdgpu_bo_create+0x1ba/0x520 [amdgpu]
  amdgpu_bo_create_vm+0x3a/0x80 [amdgpu]
  amdgpu_vm_pt_create+0xde/0x270 [amdgpu]
  amdgpu_vm_ptes_update+0x63b/0x710 [amdgpu]
  amdgpu_vm_update_range+0x2e7/0x6e0 [amdgpu]
  amdgpu_vm_bo_update+0x2bd/0x600 [amdgpu]
  update_gpuvm_pte+0x160/0x420 [amdgpu]
  amdgpu_amdkfd_gpuvm_map_memory_to_gpu+0x313/0x1130 [amdgpu]
  kfd_ioctl_map_memory_to_gpu+0x115/0x390 [amdgpu]
  kfd_ioctl+0x24a/0x5b0 [amdgpu]

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ This fixes a regression introduced by commit 1cc40dccad76 ("drm/amdgpu:
  fix Null pointer dereference error in amdgpu_device_recover_vram") in
  5.15.118. It's a hand modified cherry-pick because that commit that
  introduced the regression touched nearby code and the context is now
  incorrect. ]
Cc: Linux Regressions <regressions@lists.linux.dev>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2650
Fixes: 1cc40dccad76 ("drm/amdgpu: fix Null pointer dereference error in amdgpu_device_recover_vram")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -685,7 +685,6 @@ int amdgpu_bo_create_vm(struct amdgpu_de
 	 * num of amdgpu_vm_pt entries.
 	 */
 	BUG_ON(bp->bo_ptr_size < sizeof(struct amdgpu_bo_vm));
-	bp->destroy = &amdgpu_bo_vm_destroy;
 	r = amdgpu_bo_create(adev, bp, &bo_ptr);
 	if (r)
 		return r;


