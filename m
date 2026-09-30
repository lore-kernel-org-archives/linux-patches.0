Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A433525A66;
	Wed, 30 Sep 2026 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790487; cv=none; b=mlxDdM91tWdv7bcKk2NsD3y5NNJiAh9Pg3TMCaDQitLgjDzapov+Ogb8WtODLfHDV0RhGeZXh53xJiGimnVBEXuVB0BAdW1IbgVMHkVdxMn2xOKS539m0MLPgzzXZ1+fYywmatupvBUEq5dITcZowioc3QkUXXFIERIDI/DLwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790487; c=relaxed/simple;
	bh=qW9Wg9iO1PhGHgD0hL3JsMVJ/tnZtBXdLbx7w8JMQAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6udsHzZ5Ptm6x1af3h0fEO48TIsgo083/REto6sSiv2E6Y6GWZ2tcGbFV/3+jZLgFvv8LERv3ElSVQq28ZXZxx1rDNaq0T4CN0xoxLbv45BWNt5JnGD17d6wz5XzXTw1fnBZ/ijJgOA4RunoY3fvC3/+yq0hYzGsZcLV/DJGIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlpqg+lb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlpqg+lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AB81F00898;
	Wed, 30 Sep 2026 17:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790486;
	bh=qvrq9ZwM2sznDHyLbgyMi/udvjnoGtwG9IrL5z+k1m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlpqg+lbtijXUmJHQR3scA/ZdAXkGY4P0FXmMXawkNxZLoJS+VfCDY7YHWQc7EJSw
	 ruq9AYLq63/Wm2pXaoyrU+SWxvtWFnwi/Alz2d/R4sEWBffMC9ncO2WpnNl4J3VRp2
	 zHEn7T/dEb+8f+nERaT+CLh/MoJ/TNVS934ZWC0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 829/877] drm/xe/vm: nuke PTs only after unlinking contested VMAs
Date: Wed, 30 Sep 2026 17:29:00 +0200
Message-ID: <20260930152432.620513077@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 24a22fb3c731474b68e986af6804db450fb88617 ]

In xe_vm_close_and_put(), external-BO VMAs are queued on the contested
list for deferred destruction via xe_vma_destroy_unlocked(). However,
xe_vm_pt_destroy() was previously invoked before processing contested
VMAs, destroying vm->pt_root while those VMAs were still linked to their
respective buffer objects (vm_bo->list.gpuva).

If a concurrent thread evicts one of those shared buffer objects,
xe_bo_trigger_rebind() holding only bo->resv walks the BO's VMAs and, in
fault mode, calls xe_vm_invalidate_vma() -> xe_pt_zap_ptes(). Because
vm->pt_root[tile->id] is already NULL, dereferencing pt->level causes a
NULL ptr deref.

Fix this by deferring xe_vm_free_scratch() and xe_vm_pt_destroy() until
after all contested VMAs have been unlinked and destroyed.

User is reporting hitting a NULL ptr deref in xe_pt_zap_ptes(), which
could be explained by this race.

Assisted-by: LLM
Fixes: b06d47be7c83 ("drm/xe: Port Xe to GPUVA")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/9290
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260918131034.598078-2-matthew.auld@intel.com
(cherry picked from commit c2863648959489767f08892fd6e90577d2ea0b6a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ adapted xe_vm_pt_destroy() cleanup to the existing inline page-table destruction loop. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1678,13 +1678,21 @@ void xe_vm_close_and_put(struct xe_vm *v
 		vma->gpuva.flags |= XE_VMA_DESTROYED;
 	}
 
+	xe_vm_unlock(vm);
+
 	/*
-	 * All vm operations will add shared fences to resv.
-	 * The only exception is eviction for a shared object,
-	 * but even so, the unbind when evicted would still
-	 * install a fence to resv. Hence it's safe to
-	 * destroy the pagetables immediately.
+	 * Unlink and destroy all contested external-BO VMAs before destroying
+	 * the page tables. Otherwise, concurrent eviction holding only bo->resv
+	 * can walk the BO's VMAs and attempt to invalidate/zap page tables that
+	 * have already been freed.
 	 */
+	list_for_each_entry_safe(vma, next_vma, &contested,
+				 combined_links.destroy) {
+		list_del_init(&vma->combined_links.destroy);
+		xe_vma_destroy_unlocked(vma);
+	}
+
+	xe_vm_lock(vm, false);
 	xe_vm_free_scratch(vm);
 
 	for_each_tile(tile, xe, id) {
@@ -1695,17 +1703,6 @@ void xe_vm_close_and_put(struct xe_vm *v
 	}
 	xe_vm_unlock(vm);
 
-	/*
-	 * VM is now dead, cannot re-add nodes to vm->vmas if it's NULL
-	 * Since we hold a refcount to the bo, we can remove and free
-	 * the members safely without locking.
-	 */
-	list_for_each_entry_safe(vma, next_vma, &contested,
-				 combined_links.destroy) {
-		list_del_init(&vma->combined_links.destroy);
-		xe_vma_destroy_unlocked(vma);
-	}
-
 	up_write(&vm->lock);
 
 	down_write(&xe->usm.lock);


