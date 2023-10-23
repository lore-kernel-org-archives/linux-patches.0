Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2946314A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkHG8An2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E89C433C7;
	Mon, 23 Oct 2023 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059569;
	bh=KvG9OEUnugvKhzABfeNr+AKxma4IlHSG2ffCMkTo+dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkHG8An247M2kS9u97cKpOVOiMcjANvJwLGFcJG/9RHueLc589Pfl879/LdmylSZW
	 2FzTX3S7wBGStHG7KIw0U65i2SwXzmcc/CfZD3dsyc3rrzquHOB0D6KrcdTo3mosJ9
	 q75+/I5momvxfzze19fNiScsST2IebL1H/D6eW/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 221/241] drm/amdgpu: Fix possible null pointer dereference
Date: Mon, 23 Oct 2023 12:56:47 +0200
Message-ID: <20231023104839.240002020@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 51b79f33817544e3b4df838d86e8e8e4388ff684 ]

abo->tbo.resource may be NULL in amdgpu_vm_bo_update.

Fixes: 180253782038 ("drm/ttm: stop allocating dummy resources during BO creation")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index ec1ec08d40584..7a67bb1490159 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1094,7 +1094,8 @@ int amdgpu_vm_bo_update(struct amdgpu_device *adev, struct amdgpu_bo_va *bo_va,
 			struct drm_gem_object *gobj = dma_buf->priv;
 			struct amdgpu_bo *abo = gem_to_amdgpu_bo(gobj);
 
-			if (abo->tbo.resource->mem_type == TTM_PL_VRAM)
+			if (abo->tbo.resource &&
+			    abo->tbo.resource->mem_type == TTM_PL_VRAM)
 				bo = gem_to_amdgpu_bo(gobj);
 		}
 		mem = bo->tbo.resource;
-- 
2.42.0



