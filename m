Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D239FE1;
	Fri, 24 Nov 2023 18:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMGR+gYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45087C433CB;
	Fri, 24 Nov 2023 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850296;
	bh=gdDEY5TSy1K1cMaz7qtCdt8VHrZYnkoIoftfxgoE+BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMGR+gYyLb+Vbqvs7ZicWfuEbSTIJr3ib87qNjzS8Cz58PHwCig5XH5oFwEYdwFag
	 ItJHK0ZkFqnCG9i5BY90cmPIF2U+KJ8Nrny+6ErSsa0kGs2NkbgAo3pdafcV3WrJ+i
	 Xb8doi16JHbt5XBAMj4pUdnaMUTHtWRbHe7PZRoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 524/530] drm/amdgpu: Fix possible null pointer dereference
Date: Fri, 24 Nov 2023 17:51:30 +0000
Message-ID: <20231124172044.137341362@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Felix Kuehling <Felix.Kuehling@amd.com>

commit 256503071c2de2b5b5c20e06654aa9a44f13aa62 upstream.

mem = bo->tbo.resource may be NULL in amdgpu_vm_bo_update.

Fixes: 180253782038 ("drm/ttm: stop allocating dummy resources during BO creation")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1095,8 +1095,8 @@ int amdgpu_vm_bo_update(struct amdgpu_de
 				bo = gem_to_amdgpu_bo(gobj);
 		}
 		mem = bo->tbo.resource;
-		if (mem->mem_type == TTM_PL_TT ||
-		    mem->mem_type == AMDGPU_PL_PREEMPT)
+		if (mem && (mem->mem_type == TTM_PL_TT ||
+			    mem->mem_type == AMDGPU_PL_PREEMPT))
 			pages_addr = bo->tbo.ttm->dma_address;
 	}
 


