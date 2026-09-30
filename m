Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B27C51DE07;
	Wed, 30 Sep 2026 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789460; cv=none; b=QFPT1UAFWoTGKkjVdnxXERPm9GXXrAMU/ETCWrSmEuam5Z7StLtPotqxfmIe+H5FXSaVNDeORXd5qfLAqSCFsgIjAbU/y1u1/0+rHsEo5Nkljz+cHMkgu/QRpp9EEFiY1V3Fqj/oQTbe15G/eGwJMhpAy7DWDuxcuYi+4OTnAJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789460; c=relaxed/simple;
	bh=MJn/fCFQWAAsKAs8QsnfyTz7aYCOoG5rk/1xCZV32Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAwtZ2xDCNc4Z1tAg8VhXW1fAq8wYIFNO/l2KHUEJuZChzMhgaQLYvirYlgBhxdyhtMQrtKkl+4ROU+IhcC205rfncGD/+YBLumSpYP6X49tGDxmOelzAHNuxqTCQcFTOpBRciWXFIK0MShBDMklpAnf8moRoND51LZPZIlD8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+VBAeoT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+VBAeoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033661F000FF;
	Wed, 30 Sep 2026 17:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789459;
	bh=vjSmtJ1GHWq8K+cmlP20CHwZ3wU8oDUKDvkn35lrobY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+VBAeoTe6udkiOAPEdMbLvWCOmDWHqAaIvftPDjGohEIBpgjQnVxvE38V+EqbA6q
	 bmbQtO4/+FwDofFsx348IwvGsVhSHJQzAcVhMw/6f6mSz14YxJ3QLmqA0NZeqVMxoq
	 HJNIxYQ+Y+TjZTuhhUga95TUmaJU1dTdT5R+kMwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 484/877] drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()
Date: Wed, 30 Sep 2026 17:23:15 +0200
Message-ID: <20260930152425.109696519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2498,6 +2498,7 @@ error_free_root:
 	amdgpu_bo_unref(&root_bo);
 
 error_free_delayed:
+	dma_fence_put(vm->last_update);
 	dma_fence_put(vm->last_tlb_flush);
 	dma_fence_put(vm->last_unlocked);
 	ttm_lru_bulk_move_fini(&adev->mman.bdev, &vm->lru_bulk_move);


