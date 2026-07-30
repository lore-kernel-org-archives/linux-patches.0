Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EC539A801;
	Thu, 30 Jul 2026 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424114; cv=none; b=cUEWwwx9Q4/CaO02y7e4IPQzmH7ShkcYW7e4bJGI27MVXCgjRVFm/4EKfUwsIlR0xdf1LKSP6gDDHvuCBw5XYk/ROjkGOg93jqwrL/Wrkc8B2mR2MUNG7WYfr5GAvfRiGY5HM4pMGZXhEh1Ci0WzB21f3XmDd+sQx3phXjsn8gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424114; c=relaxed/simple;
	bh=mU9BcOX8ZPym2UfSW4maVDf7qxpx2EADJpYKEbLzsNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbwXhgiU2GAIGP4mnmsK1puICzV/j4ruV2MoNYT+kd31rhd8DKk+QWGAfygornvvPxMa7iRM7g3mQfHFE4rFrQwZjWXVcPRQcM8XGbfG0wKXF+QwSFCuA3zC44+cutftkZIQ/F+Ssl9OzvXPK9fuDdTdD7avSSWebiBvTTSwXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjrBwDlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjrBwDlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90D91F000E9;
	Thu, 30 Jul 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424113;
	bh=n9K6sjAxviTs+6lEyXQSLP7Bh1Lgj8AkGU3yuAbH44E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjrBwDlUHhN2xUDshrvwsHuqzuIYFdan24OYOszACBmdgcgUhBnyCZB3fwBrJ/bVu
	 pfZ1XZkdfkeyEtTR93bc0P+gDyMXqxEAjPNWlYGHsRUI+Cf/Y5je/XwyZriRMdlwKo
	 L9osy4FJN+lnKatMAiscItH8Ev2MxcmtnDZaOXKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/675] drm/xe/vm: Fix SVM leak on resv obj alloc failure in xe_vm_create()
Date: Thu, 30 Jul 2026 16:10:11 +0200
Message-ID: <20260730141451.097223019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 8f7b8f2da06bac..b00da90e399135 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1626,10 +1626,10 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
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



