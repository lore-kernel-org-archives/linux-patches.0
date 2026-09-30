Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4011636A033;
	Wed, 30 Sep 2026 18:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793439; cv=none; b=rrIIbqTBnhucXimQ0C6TfJg/7yFfSgqACsh4ZhRRkfOnfhK2+ufExj3mJ2+q4F62sps1fxZtP3ubaRDRmy9NopJegmK4IzlEd98PItegs41c75XQMm3fDCuK3ah7xmPwvevGiCqsZnj8JqVydHbSj1PP4RCRKDhJI+rzkrIIQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793439; c=relaxed/simple;
	bh=3KMvFTiHvQHi0E6+mZtNr/VcMNyMbnyGUT8T2O3SZms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qN3dh3qeEQdoh2HdRRs36EaKFIBo+tMMjenfVzlkKkQkehliFKrJVqYbI0oNViTpc2fYKfn9gBQ2o/mUqwtGb4cFecGqpP3tq8F+ChRVKgZTW9aOjmVKurlMSvk9XvlyLgwf2Kj6SPHTbZuMNsyGOpzjH+SMRaHqqYrMwwHFdpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5MfDTJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5MfDTJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971FA1F000FF;
	Wed, 30 Sep 2026 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793438;
	bh=8xia0+/yQNMa5b3NlgM6g2v7GmTwL1PgKtn1GpzyOYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5MfDTJgrxe88rvqupOZVvV4iF3q0sWotrd7M0O3IOGyqKxpNaqHXjcauvFrC4Q1i
	 HH6jlKioIbhjCr/DJN58q5hn36lAmy/OKO5/TwE+nPatjBa/d4tT3qRb0wOz+xp9JJ
	 25oCipnm+Cm+c2m0dHUKxdd7/Io/n3JXydPInayQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 254/395] drm/xe/vm: nuke PTs only after unlinking contested VMAs
Date: Wed, 30 Sep 2026 17:28:36 +0200
Message-ID: <20260930152346.161696533@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 24a22fb3c731474b68e986af6804db450fb88617 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1744,21 +1744,13 @@ void xe_vm_close_and_put(struct xe_vm *v
 		vma->gpuva.flags |= XE_VMA_DESTROYED;
 	}
 
-	/*
-	 * All vm operations will add shared fences to resv.
-	 * The only exception is eviction for a shared object,
-	 * but even so, the unbind when evicted would still
-	 * install a fence to resv. Hence it's safe to
-	 * destroy the pagetables immediately.
-	 */
-	xe_vm_free_scratch(vm);
-	xe_vm_pt_destroy(vm);
 	xe_vm_unlock(vm);
 
 	/*
-	 * VM is now dead, cannot re-add nodes to vm->vmas if it's NULL
-	 * Since we hold a refcount to the bo, we can remove and free
-	 * the members safely without locking.
+	 * Unlink and destroy all contested external-BO VMAs before destroying
+	 * the page tables. Otherwise, concurrent eviction holding only bo->resv
+	 * can walk the BO's VMAs and attempt to invalidate/zap page tables that
+	 * have already been freed.
 	 */
 	list_for_each_entry_safe(vma, next_vma, &contested,
 				 combined_links.destroy) {
@@ -1766,6 +1758,11 @@ void xe_vm_close_and_put(struct xe_vm *v
 		xe_vma_destroy_unlocked(vma);
 	}
 
+	xe_vm_lock(vm, false);
+	xe_vm_free_scratch(vm);
+	xe_vm_pt_destroy(vm);
+	xe_vm_unlock(vm);
+
 	xe_svm_fini(vm);
 
 	up_write(&vm->lock);


