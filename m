Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6AD9447
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6656C433C8;
	Sun, 16 Jul 2023 20:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539400;
	bh=oh+bpNpnuRgFrG82qkGA8DJNXxDlfCEzL2HxGpnN5nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCduq+DlrWznJhoPVpa91sGy3dVK+9+W405PfqoIqupfirj5O8JJV6yQWDF4fxXz6
	 NwZ+FtJHRe4FOFyKZ3PGmZRnoZbtknvv/+OvghIgpmzGMCIyuT8+rbRCgxHUgu6/1M
	 zD5KaDJaPl6fubf47Sc3pqhqGe13dOcGGRk9ihqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=F6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Guchun Chen <guchun.chen@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: [PATCH 6.4 787/800] drm/amdgpu: make sure BOs are locked in amdgpu_vm_get_memory
Date: Sun, 16 Jul 2023 21:50:40 +0200
Message-ID: <20230716195007.428178299@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

commit e2ad8e2df432498b1cee2af04df605723f4d75e6 upstream.

We need to grab the lock of the BO or otherwise can run into a crash
when we try to inspect the current location.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.3.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |   69 ++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -920,42 +920,51 @@ error_unlock:
 	return r;
 }
 
+static void amdgpu_vm_bo_get_memory(struct amdgpu_bo_va *bo_va,
+				    struct amdgpu_mem_stats *stats)
+{
+	struct amdgpu_vm *vm = bo_va->base.vm;
+	struct amdgpu_bo *bo = bo_va->base.bo;
+
+	if (!bo)
+		return;
+
+	/*
+	 * For now ignore BOs which are currently locked and potentially
+	 * changing their location.
+	 */
+	if (bo->tbo.base.resv != vm->root.bo->tbo.base.resv &&
+	    !dma_resv_trylock(bo->tbo.base.resv))
+		return;
+
+	amdgpu_bo_get_memory(bo, stats);
+	if (bo->tbo.base.resv != vm->root.bo->tbo.base.resv)
+	    dma_resv_unlock(bo->tbo.base.resv);
+}
+
 void amdgpu_vm_get_memory(struct amdgpu_vm *vm,
 			  struct amdgpu_mem_stats *stats)
 {
 	struct amdgpu_bo_va *bo_va, *tmp;
 
 	spin_lock(&vm->status_lock);
-	list_for_each_entry_safe(bo_va, tmp, &vm->idle, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
-	list_for_each_entry_safe(bo_va, tmp, &vm->evicted, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
-	list_for_each_entry_safe(bo_va, tmp, &vm->relocated, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
-	list_for_each_entry_safe(bo_va, tmp, &vm->moved, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
-	list_for_each_entry_safe(bo_va, tmp, &vm->invalidated, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
-	list_for_each_entry_safe(bo_va, tmp, &vm->done, base.vm_status) {
-		if (!bo_va->base.bo)
-			continue;
-		amdgpu_bo_get_memory(bo_va->base.bo, stats);
-	}
+	list_for_each_entry_safe(bo_va, tmp, &vm->idle, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
+
+	list_for_each_entry_safe(bo_va, tmp, &vm->evicted, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
+
+	list_for_each_entry_safe(bo_va, tmp, &vm->relocated, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
+
+	list_for_each_entry_safe(bo_va, tmp, &vm->moved, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
+
+	list_for_each_entry_safe(bo_va, tmp, &vm->invalidated, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
+
+	list_for_each_entry_safe(bo_va, tmp, &vm->done, base.vm_status)
+		amdgpu_vm_bo_get_memory(bo_va, stats);
 	spin_unlock(&vm->status_lock);
 }
 


