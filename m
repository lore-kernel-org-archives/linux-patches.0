Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E056371049;
	Wed, 30 Sep 2026 19:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796990; cv=none; b=Zlg8q4KhLpE/n4vYPxmvEDU/RzJDpqwN+S28P6GGiX8k1KnlmFOJmqtrbKR5lTzepxHGKclfe+cSi8vhInVsvRoNqeXqo9lFSnQDOvFnNT5+/lZQ5oAtvYM+jMMsjox9fqhZSLyDgplsuq74SVPhhFbdOZzws7g4xnaYQOKpxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796990; c=relaxed/simple;
	bh=Jl2Z1e15iflOy/nVFBox5hjKRHCvZw6oVTE77s0yKg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiKapTSiejR5aV6FfMZ8zSljAyzzNsHkGiB9F7DRtb7PE6h0g2I+RmyD6EI+tXrsmtb9rnlkbSgnPsRrFYGuLyqNFdY+ozeHjSQ2SBVD3sW+z9fktoajotnNvQhZvO8Evhc9r0bNcR/gJYHHD29ZZ6iYQMWTGo2IsdIf4alN3ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL0ZDUBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL0ZDUBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCC41F000FF;
	Wed, 30 Sep 2026 19:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796989;
	bh=Xyp4z+E9UNAJIMeU3O0JTSkZyB1n4+O9i989po2cxxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mL0ZDUBjdL87/Am22a3pFzQKnR4koygMN3R+Elb/+7y3Z99a6ApzODa3dHFr1FmC+
	 tAZPFb5fJU39WY2reHeaayH4WbED2gOZ61pOS8Vh3Vaxq4n8qLDIeYs+58TjT+mU6K
	 vg/cOFhltma/QrynY2ZcrxZRnfOIs+u1oXQ1aVdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 1109/1193] drm/amdgpu: Fix last_update fence leak in amdgpu_vm_init()
Date: Wed, 30 Sep 2026 17:29:53 +0200
Message-ID: <20260930152458.870220293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2230,6 +2230,7 @@ error_free_root:
 	amdgpu_bo_unref(&root_bo);
 
 error_free_delayed:
+	dma_fence_put(vm->last_update);
 	dma_fence_put(vm->last_tlb_flush);
 	dma_fence_put(vm->last_unlocked);
 	amdgpu_vm_fini_entities(vm);


