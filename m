Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E1044CAC1;
	Wed, 21 Jan 2026 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036272; cv=none; b=EocfyZ89PSrikEn2m2wN/Ykmx5dsPqquM0rYr7ZgvlPSePNtL4rFhEruoP/7RUNcXHEKv+fGwbaGqlhfl1uCTlj37VCYdFW1cJey4n/6T5myl+g3WQ+H04EqBce+2BkV2UyAcXq80yDGjgcyCT/UkyUKMaNvU2nK4On1zYfejMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036272; c=relaxed/simple;
	bh=3KahvyQMN6m2mGiAUICbKR2JVY49usN2B+c0GR/EYXA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KK2pk6H7JeKj66f6KvNNRqxTL+w5WAC7zTremhlVP1/c886TdYeBeSK/wfwhXscADqEZQn9CXjGEjLanMSDVqWAy9LNwbUTYjPYul8vybK383iCT5HRP1VmZfW0fdXqLgBlu5uimdrCylt/FoK2pyPRHfMSganHf12ybINDiglI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEAwGzlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEAwGzlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAA7C4CEF1;
	Wed, 21 Jan 2026 22:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769036271;
	bh=3KahvyQMN6m2mGiAUICbKR2JVY49usN2B+c0GR/EYXA=;
	h=From:Date:Subject:To:Cc:From;
	b=KEAwGzlNK0a7nJaSpxWO+kW36H80xvzX1Tsj21H/lbnQ/fq6ZGpR27oA36Sn1YSQC
	 dGENScnxxCe10dCx0dA1MMSzm8MiMcDwL5pIWn1WY5YkOjLdowu84MNhrGeNOZks+C
	 4tXO/QuPE3BoVCtqfAgZSvWiDEa0cYf6LizQjC+fqGhzTvlaboQECzL21QScssJTzN
	 /MO+KAiuTARekvRVzR9e82a2uDolM+l1hmYb/GKqC8VgsaYrWotVV0TBRdI13uRuNy
	 iabftvW3rYO6Q2nciUf92eWkl7X4X8ER6j5uClczqthuMXc2Pm9MJwf6keeQKBm7kt
	 c9OZtzaYr6eRg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 21 Jan 2026 15:57:35 -0700
Subject: [PATCH] drm/xe: Move _THIS_IP_ usage from xe_vm_create() to
 dedicated function
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-xe-vm-fix-clang-goto-error-v1-1-7e121d81512e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBCF4avIrB0wEUL1KuLCxFGnVCMTFUG8e
 8d2+fMe3wWJhClBnV0gdHDiuGiYPIMwdctIyL022MK6wliDJ+Ex48Anho/uOMYtIolEQW/LUPX
 O+8G9QIFVSH8/vGn/nXb/prA9Itz3F7T1SH5+AAAA
X-Change-ID: 20260121-xe-vm-fix-clang-goto-error-b23c9d6bbf68
To: Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Stuart Summers <stuart.summers@intel.com>, 
 Nirmoy Das <nirmoy.das@intel.com>, intel-xe@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5434; i=nathan@kernel.org;
 h=from:subject:message-id; bh=3KahvyQMN6m2mGiAUICbKR2JVY49usN2B+c0GR/EYXA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmFkW94jticebTHy8qlbvo8Dd3wg3VpXa8PPmXqLLxom
 nKo/lNNRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIijbD/6SuFOlt67naN1+t
 75vHX/M2RWTbutqXn2c2mj+0+Ke13p2R4fy25dorrawPFrdvYEo8oKf1vHm7fkrX0nSBFd4SFyb
 pswEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit a3866ce7b122 ("drm/xe: Add vm to exec queues association"),
building for an architecture other than x86 (which defines its own
_THIS_IP_) with clang fails with:

  drivers/gpu/drm/xe/xe_vm.c:1586:3: error: cannot jump from this indirect goto statement to one of its possible targets
   1586 |                 drm_exec_retry_on_contention(&exec);
        |                 ^
  include/drm/drm_exec.h:123:4: note: expanded from macro 'drm_exec_retry_on_contention'
    123 |                         goto *__drm_exec_retry_ptr;             \
        |                         ^
  drivers/gpu/drm/xe/xe_vm.c:1542:3: note: possible target of indirect goto statement
   1542 |                 might_lock(&vm->exec_queues.lock);
        |                 ^
  include/linux/lockdep.h:553:33: note: expanded from macro 'might_lock'
    553 |         lock_release(&(lock)->dep_map, _THIS_IP_);                      \
        |                                        ^
  include/linux/instruction_pointer.h:10:41: note: expanded from macro '_THIS_IP_'
     10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
        |                                         ^
  drivers/gpu/drm/xe/xe_vm.c:1583:2: note: jump exits scope of variable with __attribute__((cleanup))
   1583 |         xe_validation_guard(&ctx, &xe->val, &exec, (struct xe_val_flags) {.interruptible = true},
        |         ^
  drivers/gpu/drm/xe/xe_validation.h:189:2: note: expanded from macro 'xe_validation_guard'
    189 |         scoped_guard(xe_validation, _ctx, _val, _exec, _flags, &_ret) \
        |         ^
  include/linux/cleanup.h:442:2: note: expanded from macro 'scoped_guard'
    442 |         __scoped_guard(_name, __UNIQUE_ID(label), args)
        |         ^
  include/linux/cleanup.h:433:20: note: expanded from macro '__scoped_guard'
    433 |         for (CLASS(_name, scope)(args);                                 \
        |                           ^
  drivers/gpu/drm/xe/xe_vm.c:1542:3: note: jump enters a statement expression
   1542 |                 might_lock(&vm->exec_queues.lock);
        |                 ^
  include/linux/lockdep.h:553:33: note: expanded from macro 'might_lock'
    553 |         lock_release(&(lock)->dep_map, _THIS_IP_);                      \
        |                                        ^
  include/linux/instruction_pointer.h:10:20: note: expanded from macro '_THIS_IP_'
     10 | #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
        |                    ^

While this is a false positive error because __drm_exec_retry_ptr is
only ever assigned the label in drm_exec_until_all_locked() (thus it can
never jump over the cleanup variable), this error is not unreasonable in
general because the only supported use case for taking the address of a
label is computed gotos [1]. The kernel's use of the address of a label
in _THIS_IP_ is considered problematic by both GCC [2][3] and clang [4]
but they need to provide something equivalent before they can break this
use case.

Hide the usage of _THIS_IP_ by moving the CONFIG_PROVE_LOCKING if
statement to its own function, avoiding the error. This is similar to
commit 187e16f69de2 ("drm/xe: Work around clang multiple goto-label
error") but with the sources of _THIS_IP_.

Fixes: a3866ce7b122 ("drm/xe: Add vm to exec queues association")
Link: https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html [1]
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=44298 [2]
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [3]
Link: https://github.com/llvm/llvm-project/issues/138272 [4]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index f7bb21ac1987..293b92ed2fdd 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -1474,6 +1474,20 @@ static void xe_vm_pt_destroy(struct xe_vm *vm)
 	}
 }
 
+static void xe_vm_init_prove_locking(struct xe_device *xe, struct xe_vm *vm)
+{
+	if (!IS_ENABLED(CONFIG_PROVE_LOCKING))
+		return;
+
+	fs_reclaim_acquire(GFP_KERNEL);
+	might_lock(&vm->exec_queues.lock);
+	fs_reclaim_release(GFP_KERNEL);
+
+	down_read(&vm->exec_queues.lock);
+	might_lock(&xe_root_mmio_gt(xe)->uc.guc.ct.lock);
+	up_read(&vm->exec_queues.lock);
+}
+
 struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
 {
 	struct drm_gem_object *vm_resv_obj;
@@ -1537,15 +1551,7 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags, struct xe_file *xef)
 		vm->preempt.min_run_period_ms = xe->min_run_period_lr_ms;
 
 	init_rwsem(&vm->exec_queues.lock);
-	if (IS_ENABLED(CONFIG_PROVE_LOCKING)) {
-		fs_reclaim_acquire(GFP_KERNEL);
-		might_lock(&vm->exec_queues.lock);
-		fs_reclaim_release(GFP_KERNEL);
-
-		down_read(&vm->exec_queues.lock);
-		might_lock(&xe_root_mmio_gt(xe)->uc.guc.ct.lock);
-		up_read(&vm->exec_queues.lock);
-	}
+	xe_vm_init_prove_locking(xe, vm);
 
 	for_each_tile(tile, xe, id)
 		xe_range_fence_tree_init(&vm->rftree[id]);

---
base-commit: 9dd1048bca4fe2aa67c7a286bafb3947537adedb
change-id: 20260121-xe-vm-fix-clang-goto-error-b23c9d6bbf68

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

