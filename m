Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CBF29CE9;
	Tue, 21 Jul 2026 18:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658160; cv=none; b=DaKv3m3pQ4ZKxmp1B6AQUJV39Ibqa5VQjIE+je7q5dNNuNGJM4vFz/H1Rdxdw+jXtVm8dmifMOrszKqoA1jk46V98V173m8sGlDGeU2Wux+FUzwsmiCZzj4ZQwy11/Iff4qX5Ssil9LoTH84rqCizJCs/21BLTJA9DMK4IHYN40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658160; c=relaxed/simple;
	bh=Tuak7PMHZu2ooCcB79kRQ/cp6XDz0PuvitEsNTtrNsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSR5TCFQm0LO89ZdE8uIFSFHlbOrPt+kFwxdsO6A5Pjih6nS3+7flvrbfQ1BL+qAoAifFSrGWNWk2JlNBJNgUdFLh6qF8O4S/fMQohHvwIBzyaWodO0UIn10Pal4a0iJb6KrEpnL7FhHDHOmLJbjyeM6G7ZamtHVQMbzZSyny0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3k46oEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3k46oEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6691F000E9;
	Tue, 21 Jul 2026 18:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658158;
	bh=qSsSaRuHVcg4QfHb12GR7w06++wBfKuE8wQnWOenv/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3k46oEIcVq17N0QJW3Y2wL/FPSypW8dRTdA1MRgXvsWzIcUdgcM3SRJu+H5l7Hi1
	 JJCiZ3zj6x97Q5ItVYni2Lsi1iQYd1G80oy3mdJYsIXCPSysCVPXHDwDNqfo3iBT16
	 V8pzzsKYCaY56eQOrTj2jZ4lk+drFjEogcMThdao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1021/1611] drm/xe/userptr: Hold notifier_lock for write on inject test path
Date: Tue, 21 Jul 2026 17:18:57 +0200
Message-ID: <20260721152538.356980011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit dca6e08c923a44d2d66b955e03dd57a3a38c2b94 ]

When CONFIG_DRM_XE_USERPTR_INVAL_INJECT=y, xe_pt_svm_userptr_pre_commit()
runs vma_check_userptr() with the svm notifier_lock taken for read. The
test injection causes vma_check_userptr() to call
xe_vma_userptr_force_invalidate(), which feeds into
xe_vma_userptr_do_inval() with drm_gpusvm_ctx.in_notifier=true. That
flag tells drm_gpusvm_unmap_pages() the caller already holds
notifier_lock for write and only asserts the mode. Because the caller
actually holds it for read, the assertion fires:

  WARNING: drivers/gpu/drm/drm_gpusvm.c:1669 at \
           drm_gpusvm_unmap_pages+0xd4/0x130 [drm_gpusvm_helper]
  Call Trace:
   xe_vma_userptr_do_inval+0x40d/0xfd0 [xe]
   xe_vma_userptr_invalidate_pass1+0x3e6/0x8d0 [xe]
   xe_vma_userptr_force_invalidate+0xde/0x290 [xe]
   vma_check_userptr.constprop.0+0x1c6/0x220 [xe]
   xe_pt_svm_userptr_pre_commit+0x6a3/0xc60 [xe]
   ...
   xe_vm_bind_ioctl+0x3a0a/0x4480 [xe]

Acquire notifier_lock for write in pre-commit when the inject Kconfig
is enabled, via new helpers xe_pt_svm_userptr_notifier_lock()/_unlock().
Rename xe_svm_assert_held_read() to
xe_svm_assert_held_read_or_inject_write() so it asserts the correct
mode under each build configuration. Production builds
(CONFIG_DRM_XE_USERPTR_INVAL_INJECT=n) keep the existing read-mode
behavior bit-for-bit.

Fixes: 9e9787414882 ("drm/xe/userptr: replace xe_hmm with gpusvm")
Assisted-by: Claude:claude-opus-4.7
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Zongyao Bai <zongyao.bai@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260625215615.3016892-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 80ccbd97ffee8ad2e73167d826fe7be548364365)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pt.c  | 43 ++++++++++++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_svm.h | 15 +++++++++++--
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index 93c0a9d860f61b..6b75794e76b124 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1061,7 +1061,7 @@ static void xe_pt_commit_locks_assert(struct xe_vma *vma)
 	xe_pt_commit_prepare_locks_assert(vma);
 
 	if (xe_vma_is_userptr(vma))
-		xe_svm_assert_held_read(vm);
+		xe_svm_assert_held_read_or_inject_write(vm);
 }
 
 static void xe_pt_commit(struct xe_vma *vma,
@@ -1388,6 +1388,33 @@ static int xe_pt_pre_commit(struct xe_migrate_pt_update *pt_update)
 				     pt_update_ops, rftree);
 }
 
+/*
+ * Acquire/release the svm notifier_lock around xe_pt_svm_userptr_pre_commit()
+ * and the matching late release in xe_pt_update_ops_run(). Read mode by
+ * default; write mode when CONFIG_DRM_XE_USERPTR_INVAL_INJECT is on,
+ * because a userptr op in this critical section may invoke the injected
+ * xe_vma_userptr_force_invalidate() path that calls
+ * drm_gpusvm_unmap_pages() with ctx->in_notifier=true, which requires the
+ * lock held for write.
+ */
+static void xe_pt_svm_userptr_notifier_lock(struct xe_vm *vm)
+{
+#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
+	down_write(&vm->svm.gpusvm.notifier_lock);
+#else
+	xe_svm_notifier_lock(vm);
+#endif
+}
+
+static void xe_pt_svm_userptr_notifier_unlock(struct xe_vm *vm)
+{
+#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
+	up_write(&vm->svm.gpusvm.notifier_lock);
+#else
+	xe_svm_notifier_unlock(vm);
+#endif
+}
+
 #if IS_ENABLED(CONFIG_DRM_GPUSVM)
 #ifdef CONFIG_DRM_XE_USERPTR_INVAL_INJECT
 
@@ -1419,7 +1446,7 @@ static int vma_check_userptr(struct xe_vm *vm, struct xe_vma *vma,
 	struct xe_userptr_vma *uvma;
 	unsigned long notifier_seq;
 
-	xe_svm_assert_held_read(vm);
+	xe_svm_assert_held_read_or_inject_write(vm);
 
 	if (!xe_vma_is_userptr(vma))
 		return 0;
@@ -1449,7 +1476,7 @@ static int op_check_svm_userptr(struct xe_vm *vm, struct xe_vma_op *op,
 {
 	int err = 0;
 
-	xe_svm_assert_held_read(vm);
+	xe_svm_assert_held_read_or_inject_write(vm);
 
 	switch (op->base.op) {
 	case DRM_GPUVA_OP_MAP:
@@ -1521,12 +1548,12 @@ static int xe_pt_svm_userptr_pre_commit(struct xe_migrate_pt_update *pt_update)
 	if (err)
 		return err;
 
-	xe_svm_notifier_lock(vm);
+	xe_pt_svm_userptr_notifier_lock(vm);
 
 	list_for_each_entry(op, &vops->list, link) {
 		err = op_check_svm_userptr(vm, op, pt_update_ops);
 		if (err) {
-			xe_svm_notifier_unlock(vm);
+			xe_pt_svm_userptr_notifier_unlock(vm);
 			break;
 		}
 	}
@@ -2192,7 +2219,7 @@ static void bind_op_commit(struct xe_vm *vm, struct xe_tile *tile,
 			   vma->tile_invalidated & ~BIT(tile->id));
 	vma->tile_staged &= ~BIT(tile->id);
 	if (xe_vma_is_userptr(vma)) {
-		xe_svm_assert_held_read(vm);
+		xe_svm_assert_held_read_or_inject_write(vm);
 		to_userptr_vma(vma)->userptr.initial_bind = true;
 	}
 
@@ -2228,7 +2255,7 @@ static void unbind_op_commit(struct xe_vm *vm, struct xe_tile *tile,
 	if (!vma->tile_present) {
 		list_del_init(&vma->combined_links.rebind);
 		if (xe_vma_is_userptr(vma)) {
-			xe_svm_assert_held_read(vm);
+			xe_svm_assert_held_read_or_inject_write(vm);
 
 			spin_lock(&vm->userptr.invalidated_lock);
 			list_del_init(&to_userptr_vma(vma)->userptr.invalidate_link);
@@ -2517,7 +2544,7 @@ xe_pt_update_ops_run(struct xe_tile *tile, struct xe_vma_ops *vops)
 	}
 
 	if (pt_update_ops->needs_svm_lock)
-		xe_svm_notifier_unlock(vm);
+		xe_pt_svm_userptr_notifier_unlock(vm);
 
 	xe_tlb_inval_job_put(mjob);
 	xe_tlb_inval_job_put(ijob);
diff --git a/drivers/gpu/drm/xe/xe_svm.h b/drivers/gpu/drm/xe/xe_svm.h
index fa757dd07954d9..45bf10f8666044 100644
--- a/drivers/gpu/drm/xe/xe_svm.h
+++ b/drivers/gpu/drm/xe/xe_svm.h
@@ -353,8 +353,19 @@ static inline void xe_svm_flush(struct xe_vm *vm)
 #define xe_svm_assert_in_notifier(vm__) \
 	lockdep_assert_held_write(&(vm__)->svm.gpusvm.notifier_lock)
 
-#define xe_svm_assert_held_read(vm__) \
+/*
+ * Assert the svm notifier_lock is held. Read mode by default; write mode
+ * when CONFIG_DRM_XE_USERPTR_INVAL_INJECT is on, because that path forces
+ * a userptr invalidation that ends in drm_gpusvm_unmap_pages() with
+ * ctx->in_notifier=true, which requires the lock held for write.
+ */
+#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
+#define xe_svm_assert_held_read_or_inject_write(vm__) \
+	lockdep_assert_held_write(&(vm__)->svm.gpusvm.notifier_lock)
+#else
+#define xe_svm_assert_held_read_or_inject_write(vm__) \
 	lockdep_assert_held_read(&(vm__)->svm.gpusvm.notifier_lock)
+#endif
 
 #define xe_svm_notifier_lock(vm__)	\
 	drm_gpusvm_notifier_lock(&(vm__)->svm.gpusvm)
@@ -368,7 +379,7 @@ static inline void xe_svm_flush(struct xe_vm *vm)
 #else
 #define xe_svm_assert_in_notifier(...) do {} while (0)
 
-static inline void xe_svm_assert_held_read(struct xe_vm *vm)
+static inline void xe_svm_assert_held_read_or_inject_write(struct xe_vm *vm)
 {
 }
 
-- 
2.53.0



