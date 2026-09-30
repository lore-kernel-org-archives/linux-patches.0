Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C48146EF8D;
	Wed, 30 Sep 2026 18:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793405; cv=none; b=ZO1CnBTQzsEsTX+S/dwQDCiqYfossOmy8XUULWK7YO7e1yti3hDIJm+sh4datE/xS4ATV4eSpJzkP+bTS9fSvw0HE5XNdZcFRFCgq58k9MS2lKbuOMTy0fpseNb9nOZBUx9ZbvKXYoBWxbd5RlNKZNfyAnk1jLmcgWOqWtn3Zrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793405; c=relaxed/simple;
	bh=wF7UGHWzsZQwHgORJ/W5GMV2Rxen1onQDearg/uXBgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK61N+X5sll5Q7X8CLQCtgyGA0ICOGIAu/WSER7BesG+dS77BxL5oPtpB4L0/UBzIbXiC8cSim3OLpyYLeAshB8zM4ATSEA/JHpH5xjev0H2vBQ2UxLam7yDeiKJYwRjSijOoRg++dorZc2rDrmkiUbjk2WRBtabg6FstR7WrWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hihlH4BQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hihlH4BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770981F000FF;
	Wed, 30 Sep 2026 18:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793404;
	bh=lhgYyCv2KbGLZ1s4gLLKiEA4jNoU/LOzgz9UzdsjM/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hihlH4BQNCoJnutB7Aodsvi5toB02/ZAxxlerzfnIQPC3u3YYdxOd74IvGW2DBGpc
	 nKbf5FhitxpsXs4ZnUpvkNvMwvkizETfR1Xap7qg3AKxIT3EMVAor8VCKYlTr8QC44
	 Nd4VBYGnbvj+7D2LfN8OejPg7WJ+ydn6ISFeUOrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 243/395] drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()
Date: Wed, 30 Sep 2026 17:28:25 +0200
Message-ID: <20260930152345.927253000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit b4f7b4459b1b155e4c4977a6482b5df2cf08758c upstream.

amdgpu_vm_init() initializes vm->last_update, vm->last_unlocked and
vm->last_tlb_flush with references to the stub fence taken via
dma_fence_get_stub().  The error label at the end of the function
releases the last_unlocked and last_tlb_flush references with
dma_fence_put(), but the reference stored in vm->last_update is never
dropped, so whenever the page table root creation, the reservation of
the root BO or the PASID registration fails, the stub fence reference
leaks.

Drop the vm->last_update reference together with the other stub fence
references on the error path.

Fixes: 187916e6ed9d ("drm/amdgpu: install stub fence into potential unused fence pointers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e7979c84fc05a176bdf855ee664871b1648404c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2673,6 +2673,7 @@ error_free_root:
 	amdgpu_bo_unref(&root_bo);
 
 error_free_delayed:
+	dma_fence_put(vm->last_update);
 	dma_fence_put(vm->last_tlb_flush);
 	dma_fence_put(vm->last_unlocked);
 	ttm_lru_bulk_move_fini(&adev->mman.bdev, &vm->lru_bulk_move);


