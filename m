Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5658483;
	Sat, 30 Dec 2023 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PWw3CHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB39C433C8;
	Sat, 30 Dec 2023 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937821;
	bh=hyD9uvDkVgjtNKGWwdfR2RivUciZGns65PM0rtqd2Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PWw3CHY7r0mK2zJ11ezPSzABqZ5JGNZsl7psRwaTCVrIwh7Rh7J5Kcc2Atvih1c9
	 fcrIU2EZKIc7YPR1L3/YrSAnQJeCC4WVvOaQOY2Yeffy50nk5iIw5SRFZ6hvXc38d9
	 ahc6cjVki0PFW/PjfmzHQfnSe03j+5CDI0The5D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhenGuo Yin <zhenguo.yin@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/156] drm/amdgpu: re-create idle bos PTE during VM state machine reset
Date: Sat, 30 Dec 2023 11:58:49 +0000
Message-ID: <20231230115814.811673960@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: ZhenGuo Yin <zhenguo.yin@amd.com>

[ Upstream commit 4a0057afa35872a5f2e65576785844688dd9fa5e ]

Idle bo's PTE needs to be re-created when resetting VM state machine.
Set idle bo's vm_bo as moved to mark it as invalid.

Fixes: 55bf196f60df ("drm/amdgpu: reset VM when an error is detected")
Signed-off-by: ZhenGuo Yin <zhenguo.yin@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 89c8e51cd3323..9fe1278fd5861 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -285,6 +285,7 @@ static void amdgpu_vm_bo_reset_state_machine(struct amdgpu_vm *vm)
 	list_for_each_entry_safe(vm_bo, tmp, &vm->idle, vm_status) {
 		struct amdgpu_bo *bo = vm_bo->bo;
 
+		vm_bo->moved = true;
 		if (!bo || bo->tbo.type != ttm_bo_type_kernel)
 			list_move(&vm_bo->vm_status, &vm_bo->vm->moved);
 		else if (bo->parent)
-- 
2.43.0



