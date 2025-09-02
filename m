Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774712DAFA1;
	Tue,  2 Sep 2025 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819557; cv=none; b=GiMbRPSZo/k8lEtxGQUMbjoceKPXfM3GfQROg7dwWVynu56xOPTiIhQAu7posnNXHOUL3E4c+fAV6BZlNtkp3KyrpdKrqYU3h3lcO4fOXeeNoXlNTaapXf6C4zqCYDS9wmx5aHIP8Lk6H0rcnle9Omrp08gjk5zeaYgfT0iFqh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819557; c=relaxed/simple;
	bh=P9T1P5ivl7uGYGDB0qub3q1LrwcHatp4FgPdyZd1kUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJtL/jFd30Mwc++I3Dfh7Om1NN6c2z3Una75sivBweYB7uJoqkyIh8MEQa8MFUkAFrHo/+YiS3/82BhYk47OapaBvl25Y3vVCF3F5crL0sUtQEZooRHAZ8BYJuqF5s6GsSPB6LSiQFx8otmvQUxUfVTvdQm0HheUqpagBjPRF8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAeGeyT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAeGeyT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E3EC4CEF5;
	Tue,  2 Sep 2025 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819557;
	bh=P9T1P5ivl7uGYGDB0qub3q1LrwcHatp4FgPdyZd1kUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAeGeyT1UykraRiyYYfBpwSwlLx5ZsMQZrQKLmiXHYk288fZwP64GR3CIRRVPYZLi
	 Fn2IxWdzeiJQWT8vpjdfuo1aj33AspdDE1gLDqV+G3my6zUzAgGmmOxeahopueUr71
	 PCCgtAQVnSvlth4vLNDxeTVNnAZbnDmQDr4E1nyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 070/142] drm/xe/vm: Dont pin the vm_resv during validation
Date: Tue,  2 Sep 2025 15:19:32 +0200
Message-ID: <20250902131950.943408961@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit 7551865cd12af2dc47e5a174eebcfb0b94b5449b ]

The pinning has the odd side-effect that unlocking *any* resv
during validation triggers an "unlocking pinned lock" warning.

Cc: Matthew Brost <matthew.brost@intel.com>
Fixes: 5cc3325584c4 ("drm/xe: Rework eviction rejection of bound external bos")
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250821143045.106005-2-thomas.hellstrom@linux.intel.com
(cherry picked from commit 0a51bf3e54dd8b77e6f1febbbb66def0660862d2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c |  5 ++---
 drivers/gpu/drm/xe/xe_vm.h | 15 ++-------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 7aa2c17825da9..e2c6493cb70d9 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2435,7 +2435,6 @@ int xe_bo_validate(struct xe_bo *bo, struct xe_vm *vm, bool allow_res_evict)
 		.no_wait_gpu = false,
 		.gfp_retry_mayfail = true,
 	};
-	struct pin_cookie cookie;
 	int ret;
 
 	if (vm) {
@@ -2446,10 +2445,10 @@ int xe_bo_validate(struct xe_bo *bo, struct xe_vm *vm, bool allow_res_evict)
 		ctx.resv = xe_vm_resv(vm);
 	}
 
-	cookie = xe_vm_set_validating(vm, allow_res_evict);
+	xe_vm_set_validating(vm, allow_res_evict);
 	trace_xe_bo_validate(bo);
 	ret = ttm_bo_validate(&bo->ttm, &bo->placement, &ctx);
-	xe_vm_clear_validating(vm, allow_res_evict, cookie);
+	xe_vm_clear_validating(vm, allow_res_evict);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index 0158ec0ae3b23..e54ca835b5828 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -310,22 +310,14 @@ void xe_vm_snapshot_free(struct xe_vm_snapshot *snap);
  * Register this task as currently making bos resident for the vm. Intended
  * to avoid eviction by the same task of shared bos bound to the vm.
  * Call with the vm's resv lock held.
- *
- * Return: A pin cookie that should be used for xe_vm_clear_validating().
  */
-static inline struct pin_cookie xe_vm_set_validating(struct xe_vm *vm,
-						     bool allow_res_evict)
+static inline void xe_vm_set_validating(struct xe_vm *vm, bool allow_res_evict)
 {
-	struct pin_cookie cookie = {};
-
 	if (vm && !allow_res_evict) {
 		xe_vm_assert_held(vm);
-		cookie = lockdep_pin_lock(&xe_vm_resv(vm)->lock.base);
 		/* Pairs with READ_ONCE in xe_vm_is_validating() */
 		WRITE_ONCE(vm->validating, current);
 	}
-
-	return cookie;
 }
 
 /**
@@ -333,17 +325,14 @@ static inline struct pin_cookie xe_vm_set_validating(struct xe_vm *vm,
  * @vm: Pointer to the vm or NULL
  * @allow_res_evict: Eviction from @vm was allowed. Must be set to the same
  * value as for xe_vm_set_validation().
- * @cookie: Cookie obtained from xe_vm_set_validating().
  *
  * Register this task as currently making bos resident for the vm. Intended
  * to avoid eviction by the same task of shared bos bound to the vm.
  * Call with the vm's resv lock held.
  */
-static inline void xe_vm_clear_validating(struct xe_vm *vm, bool allow_res_evict,
-					  struct pin_cookie cookie)
+static inline void xe_vm_clear_validating(struct xe_vm *vm, bool allow_res_evict)
 {
 	if (vm && !allow_res_evict) {
-		lockdep_unpin_lock(&xe_vm_resv(vm)->lock.base, cookie);
 		/* Pairs with READ_ONCE in xe_vm_is_validating() */
 		WRITE_ONCE(vm->validating, NULL);
 	}
-- 
2.50.1



