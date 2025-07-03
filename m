Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FF2EFDA2;
	Thu,  3 Jul 2025 14:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554459; cv=none; b=eCwQWVw2tbAqK0hZ22bRJNv1QMTrvnMFAZ/xkH+FJkoU7tgZB6hzfQ5m/bOlgNWc8znEyJiZaDSnlFujS6Fv/88pEW+Km1iywFDdpPGTAkqooWm6+B8Qrp+rvT6kfqZg18ClglSEe8BjOsr1cP553XhzNmo4f0kEkCdOhT0syQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554459; c=relaxed/simple;
	bh=07zrUXu/0D3mQq4uPfaQQhRF4O5+Ds9XsixFMP+WNrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HD4/zAKb2AO/pDGDQcBj+bCLzZKFUP4qhVTo9XEIxYrmUB2E2/hFwAr3oe0zKCvjVO7kW1ehpHMcmKbn6kH36C0gjaaITEAAciK2NWihPPgtzivo2uxFPcG6GJg+75W2qWfnis221j+cd9a5KGgj0h+Vo+CR4aPf6Y+a5xXqqMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc0nWBM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc0nWBM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E86C4CEED;
	Thu,  3 Jul 2025 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554459;
	bh=07zrUXu/0D3mQq4uPfaQQhRF4O5+Ds9XsixFMP+WNrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yc0nWBM1tvhrFKQo15rI0w9IwAdpyxHZkGKg5/t22PAQy5MT1v2khlHO1/N6EGUXd
	 2gjStcDG0xK7bmINYpJHdjkDDqbTRngp3WtF7nYVfj92Bfm0+3xNqwsFkt/mSAGyf0
	 jDd2/eMceUx1aErM1m2neoTg0v9/Dlg0o6b4HUbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 164/218] drm/xe/vm: move rebind_work init earlier
Date: Thu,  3 Jul 2025 16:41:52 +0200
Message-ID: <20250703144002.712437844@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit a63e99b4d6d3a0353ef47146dd5bd562f08e1786 upstream.

In xe_vm_close_and_put() we need to be able to call
flush_work(rebind_work), however during vm creation we can call this on
the error path, before having actually set up the worker, leading to a
splat from flush_work().

It looks like we can simply move the worker init step earlier to fix
this.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250514152424.149591-3-matthew.auld@intel.com
(cherry picked from commit 96af397aa1a2d1032a6e28ff3f4bc0ab4be40e1d)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1477,8 +1477,10 @@ struct xe_vm *xe_vm_create(struct xe_dev
 	 * scheduler drops all the references of it, hence protecting the VM
 	 * for this case is necessary.
 	 */
-	if (flags & XE_VM_FLAG_LR_MODE)
+	if (flags & XE_VM_FLAG_LR_MODE) {
+		INIT_WORK(&vm->preempt.rebind_work, preempt_rebind_work_func);
 		xe_pm_runtime_get_noresume(xe);
+	}
 
 	vm_resv_obj = drm_gpuvm_resv_object_alloc(&xe->drm);
 	if (!vm_resv_obj) {
@@ -1523,10 +1525,8 @@ struct xe_vm *xe_vm_create(struct xe_dev
 		vm->batch_invalidate_tlb = true;
 	}
 
-	if (vm->flags & XE_VM_FLAG_LR_MODE) {
-		INIT_WORK(&vm->preempt.rebind_work, preempt_rebind_work_func);
+	if (vm->flags & XE_VM_FLAG_LR_MODE)
 		vm->batch_invalidate_tlb = false;
-	}
 
 	/* Fill pt_root after allocating scratch tables */
 	for_each_tile(tile, xe, id) {


