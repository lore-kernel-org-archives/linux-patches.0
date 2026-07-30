Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070B5440A2C;
	Thu, 30 Jul 2026 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422126; cv=none; b=cXe0KdNoH9tm3Pz/DSuk/KwKH8n3JAmxBmIcGq1nyj2aQ2RY/VZJhH85YBKvlvWpEeNTI4XzjIMA+CDpFdBocpY57MU9shO/oh1/kuBbNCUdnTI163zpD7LK8ckKxo8PFxE4LuinzIIx7CNlF4p1ICO8lY6+dl/TI6DbH3JFOfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422126; c=relaxed/simple;
	bh=T0BFpX8BEIT9YNg9h7FnYsoyBKhTF3PS57HtSniEkLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=reHyhwu/OjalTyEFvHIZDOAYwqVaOaRi/qxGSjxJNhTc5sbJlShqk+HUkdukHE2IeA2wTp9gJwFwepmMdYQJFKEVkMayn7AGOwnjATCan+3ZcfYES1aG+P96CIqk3XRk2WT+QrssTgLz1kEq9ad7HhESNriNFh6yVUvmJQNhLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tU4Yyczi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tU4Yyczi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625A51F000E9;
	Thu, 30 Jul 2026 14:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422124;
	bh=rxw6MMWC1WGJhdOQxdCjLMQvztOytx9vgJ22Kx9fDnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tU4YyczidL/5GXnc9euYP9WyeR9akto+wUYuDD+D6Nrs2H7KeLFmn5fLhxisrEP1Y
	 5YQcXK50SRhBeyxg4egbdrmMozcUka0Cf9RWt0EuppuFG58Ka5TvKiSd+rRBqyVDHo
	 pK879GNKax0J6alCNqA0ZmTXFnDsC48EXet0Mvgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 316/744] drm/xe/vm: Fix SVM leak on resv obj alloc failure in xe_vm_create()
Date: Thu, 30 Jul 2026 16:09:49 +0200
Message-ID: <20260730141451.000992766@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit d2c6800ad1802bed72a6de1416536737f114f1d6 ]

Commit 9e9787414882 ("drm/xe/userptr: replace xe_hmm with gpusvm") made
xe_svm_init() unconditional in xe_vm_create() and extended it to also
initialize a "simple" gpusvm state for non-fault-mode VMs. The matching
xe_svm_fini() call in xe_vm_close_and_put() was updated to run
unconditionally, but the error unwind path in xe_vm_create() was not.

On the drm_gpuvm_resv_object_alloc() failure path, xe_svm_init() has
already succeeded but xe_svm_fini() is only called when
XE_VM_FLAG_FAULT_MODE is set. For non-fault-mode VMs this leaves
vm->svm.gpusvm partially initialized and leaks the resources allocated
by drm_gpusvm_init().

For fault-mode VMs, xe_svm_init() additionally acquires the pagemap
owner via drm_pagemap_acquire_owner() and the pagemaps via
xe_svm_get_pagemaps(). Those resources are released by xe_svm_close(),
not xe_svm_fini(). On the same error path, xe_svm_close() is not
called either, so fault-mode VMs leak the pagemap owner and pagemaps.

Fix both leaks:

- Call xe_svm_fini() unconditionally on the err_svm_fini path, matching
  the unconditional xe_svm_init() call. Move the vm->size = 0
  assignment out of the conditional so the xe_vm_is_closed() assert in
  xe_svm_fini() (and xe_svm_close()) holds for both modes.

- Call xe_svm_close() for fault-mode VMs before xe_svm_fini(), matching
  the ordering used in xe_vm_close_and_put().

Fixes: 9e9787414882 ("drm/xe/userptr: replace xe_hmm with gpusvm")
Cc: Matthew Auld <matthew.auld@intel.com>
Assisted-by: Claude:claude-opus-4.7
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260721205516.4058959-2-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit ca2a3587d577ba764e0fe628fb676244fc33ddd4)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index ab6cc1f0a78949..aec3c2a60d5888 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1810,10 +1810,10 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
 	return ERR_PTR(err);
 
 err_svm_fini:
-	if (flags & XE_VM_FLAG_FAULT_MODE) {
-		vm->size = 0; /* close the vm */
-		xe_svm_fini(vm);
-	}
+	vm->size = 0; /* close the vm */
+	if (flags & XE_VM_FLAG_FAULT_MODE)
+		xe_svm_close(vm);
+	xe_svm_fini(vm);
 err_no_resv:
 	mutex_destroy(&vm->snap_mutex);
 	for_each_tile(tile, xe, id)
-- 
2.53.0



