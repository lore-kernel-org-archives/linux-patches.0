Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78250215793;
	Tue, 17 Jun 2025 16:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179030; cv=none; b=pgDpI2j3JIPEavNoIo9sa6rejm2aQFo5qgYwbzsHS0OlCOXoSGOg2PYrXlBW8Jy7hVdxAXVTeWh5TaAJen03rYDPK4g76iNr11urrut72QaqHxTaNzvoNfgfSwUFrLgTXfWEJtghIhxemkmzk/kpllK0o0ORslGCD9beVhn2Qbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179030; c=relaxed/simple;
	bh=xaoyet6vyDY8fWImqvgFmMVrbMIDy5z1aM9n+y93kjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LDVzq+8EhO+E3CJiXAoj+kvWxe5GGMrg1f6phC0YrmPmEwFZb5qFSZkIRGH7rr//C3z5V9LqIKyGqXu1oHLL222dJeLPRlVtWV6KK1iUyAiKkmIxUJTnAqnF1XG8Prvnkd/DfDi3UKyb205GNQ+fPLovqsq7PY7psDdKV8vgMuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRsgdsb5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRsgdsb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4DAC4CEE3;
	Tue, 17 Jun 2025 16:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179030;
	bh=xaoyet6vyDY8fWImqvgFmMVrbMIDy5z1aM9n+y93kjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRsgdsb5hhxQw+mK5ep4GTGtFoq9mDdgkEbtJQCJPnDOUWqZqV0h1qLjzsvHEkIjz
	 ctcRNLugpTjqrEKzoqL1hCar5H6kSEpHGUI8KWqlqiX2S+cg90SiXMgV1nlHiFFPvg
	 HGtQw+u6VkTipn3xmGlOd7mCwCDeuX1dr0pDcXgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 626/780] drm/xe/vm: move xe_svm_init() earlier
Date: Tue, 17 Jun 2025 17:25:34 +0200
Message-ID: <20250617152516.968947120@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 8cf8cde41ad01150afbd1327ad1942387787f7fd ]

In xe_vm_close_and_put() we need to be able to call xe_svm_fini(),
however during vm creation we can call this on the error path, before
having actually initialised the svm state, leading to various splats
followed by a fatal NPD.

Fixes: 6fd979c2f331 ("drm/xe: Add SVM init / close / fini to faulting VMs")
Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4967
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250514152424.149591-4-matthew.auld@intel.com
(cherry picked from commit 4f296d77cf49fcb5f90b4674123ad7f3a0676165)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 367c84b90e9ef..737172013a8f9 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1681,10 +1681,16 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 	if (flags & XE_VM_FLAG_LR_MODE)
 		xe_pm_runtime_get_noresume(xe);
 
+	if (flags & XE_VM_FLAG_FAULT_MODE) {
+		err = xe_svm_init(vm);
+		if (err)
+			goto err_no_resv;
+	}
+
 	vm_resv_obj = drm_gpuvm_resv_object_alloc(&xe->drm);
 	if (!vm_resv_obj) {
 		err = -ENOMEM;
-		goto err_no_resv;
+		goto err_svm_fini;
 	}
 
 	drm_gpuvm_init(&vm->gpuvm, "Xe VM", DRM_GPUVM_RESV_PROTECTED, &xe->drm,
@@ -1757,12 +1763,6 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 		}
 	}
 
-	if (flags & XE_VM_FLAG_FAULT_MODE) {
-		err = xe_svm_init(vm);
-		if (err)
-			goto err_close;
-	}
-
 	if (number_tiles > 1)
 		vm->composite_fence_ctx = dma_fence_context_alloc(1);
 
@@ -1776,6 +1776,11 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 	xe_vm_close_and_put(vm);
 	return ERR_PTR(err);
 
+err_svm_fini:
+	if (flags & XE_VM_FLAG_FAULT_MODE) {
+		vm->size = 0; /* close the vm */
+		xe_svm_fini(vm);
+	}
 err_no_resv:
 	mutex_destroy(&vm->snap_mutex);
 	for_each_tile(tile, xe, id)
-- 
2.39.5



