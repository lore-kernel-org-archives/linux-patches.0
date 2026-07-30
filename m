Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17693A254B;
	Thu, 30 Jul 2026 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422283; cv=none; b=LXXGwPY9g1KwSBhbvnLFjxmwAY73vIX1M2xg1JVZAjiQmtYX5cWP/AQzO7gBQEYQGGFaZ2G5KAOsMPym9ZZ+p+bOlHCBiGVviep0zUdJoFnSQxRe53Ad7M/wbO+W6MuphjBW1RcVGDls3SXPtW/IkAiDMg2o6vNaJlJQmATmWBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422283; c=relaxed/simple;
	bh=0xIGcBgOaoPI9Vr8P+PrZNtX9uNyZmlUTnM2lv+55kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM1OoE2Bq4gALSMd4801Z+lgOW/xNflOHbXIOz1r6ZCZ/tXwM27vUWFnCu7FmDAH00+w72+qRFf+41i6wm+bcr2fMH/o2BEeP0CF++Ca9LJWfOsN5586wz6davXGpoiRoucyLnrdoJAQGaIelwsPgzV0mzrV6umChpB0erFqUcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVXDjpCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVXDjpCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220F61F000E9;
	Thu, 30 Jul 2026 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422281;
	bh=6dju7QdYk3ubF53Po6VccWUrCU0kWGQKh/DTwznYfiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVXDjpChbS+E50b/b+Uk3/JppnZ+vwwkZRGMOI+9cd6q8IK79CGHaGzGcEDF1xLTM
	 fOBYLNqOBU/Zt9ZJh8Wa20g2u2nb4e/9LKGcaMmElW37vHgYC3bW1u/ze2qK/Xnl5s
	 psKZ8Uszu5JQn98Lngm5hgjszFCVMemy2j7AEEfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Chengming Gui <Jack.Gui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.1 385/744] drm/amdgpu: Fix context pstate override handling
Date: Thu, 30 Jul 2026 16:10:58 +0200
Message-ID: <20260730141452.467933880@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit c1dc4ccb82c9e56325d8e7514ca4c90bd1efb351 upstream.

There are several problems in the context pstate handling code.

The most serious ones are potential use-after-free and NULL pointer
dereferences at context initialization time. Both are due
amdgpu_ctx_init() not holding the adev->pm.stable_pstate_ctx_lock, which
is otherwise used from both sysfs and the context code itself for
modifying and clearing the stored context pointer.

Second issue is that context fini can trample over the pstate
configuration set via sysfs. This is due the restore state
(ctx->stable_pstate) being saved at context init time, and not if, or when
the context actually changes the pstate. As the context exits it will
therefore incorrectly restore to what was set before the sysfs override
was requested.

The simplest fix is to drastically simplify how the state is tracked, by
clearly defining the points at which pstate ownership is taken and
released, and to handle all transitions under the correct lock.

Instead of at context init time, the previous state is saved only at the
point the context overrides the current state, and is restored on context
exit only if the context is still the owner of the current override state.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Fixes: 79610d304133 ("drm/amdgpu: fix pstate setting issue")
Cc: Chengming Gui <Jack.Gui@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b5e413713c0a93bc1818394d0ce49aaad21bd27)
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c |   71 ++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -326,7 +326,6 @@ static int amdgpu_ctx_init(struct amdgpu
 			   struct drm_file *filp, struct amdgpu_ctx *ctx)
 {
 	struct amdgpu_fpriv *fpriv = filp->driver_priv;
-	u32 current_stable_pstate;
 	int r;
 
 	r = amdgpu_ctx_priority_permit(filp, priority);
@@ -344,36 +343,21 @@ static int amdgpu_ctx_init(struct amdgpu
 	ctx->generation = amdgpu_vm_generation(mgr->adev, &fpriv->vm);
 	ctx->init_priority = priority;
 	ctx->override_priority = AMDGPU_CTX_PRIORITY_UNSET;
-
-	r = amdgpu_ctx_get_stable_pstate(ctx, &current_stable_pstate);
-	if (r)
-		return r;
-
-	if (mgr->adev->pm.stable_pstate_ctx)
-		ctx->stable_pstate = mgr->adev->pm.stable_pstate_ctx->stable_pstate;
-	else
-		ctx->stable_pstate = current_stable_pstate;
+	ctx->stable_pstate = AMDGPU_CTX_STABLE_PSTATE_NONE;
 
 	return 0;
 }
 
-static int amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
-					u32 stable_pstate)
+static int __amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
+					  u32 stable_pstate)
 {
 	struct amdgpu_device *adev = ctx->mgr->adev;
 	enum amd_dpm_forced_level level;
+	struct amdgpu_ctx *current_ctx;
 	u32 current_stable_pstate;
-	int r;
-
-	mutex_lock(&adev->pm.stable_pstate_ctx_lock);
-	if (adev->pm.stable_pstate_ctx && adev->pm.stable_pstate_ctx != ctx) {
-		r = -EBUSY;
-		goto done;
-	}
+	int r = 0;
 
-	r = amdgpu_ctx_get_stable_pstate(ctx, &current_stable_pstate);
-	if (r || (stable_pstate == current_stable_pstate))
-		goto done;
+	lockdep_assert_held(&adev->pm.stable_pstate_ctx_lock);
 
 	switch (stable_pstate) {
 	case AMDGPU_CTX_STABLE_PSTATE_NONE:
@@ -392,17 +376,41 @@ static int amdgpu_ctx_set_stable_pstate(
 		level = AMD_DPM_FORCED_LEVEL_PROFILE_PEAK;
 		break;
 	default:
-		r = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
+	current_ctx = adev->pm.stable_pstate_ctx;
+	if (current_ctx && current_ctx != ctx)
+		return -EBUSY;
+
+	r = amdgpu_ctx_get_stable_pstate(ctx, &current_stable_pstate);
+	if (r || current_stable_pstate == stable_pstate)
+		return r;
+
 	r = amdgpu_dpm_force_performance_level(adev, level);
+	if (r)
+		return r;
 
-	if (level == AMD_DPM_FORCED_LEVEL_AUTO)
-		adev->pm.stable_pstate_ctx = NULL;
-	else
+	if (!current_ctx) {
 		adev->pm.stable_pstate_ctx = ctx;
-done:
+		/*
+		 * Serialized by context taking ownership for the first time
+		 * while holding adev->pm.stable_pstate_ctx_lock).
+		 */
+		WRITE_ONCE(ctx->stable_pstate, current_stable_pstate);
+	}
+
+	return 0;
+}
+
+static int amdgpu_ctx_set_stable_pstate(struct amdgpu_ctx *ctx,
+					u32 stable_pstate)
+{
+	struct amdgpu_device *adev = ctx->mgr->adev;
+	int r;
+
+	mutex_lock(&adev->pm.stable_pstate_ctx_lock);
+	r = __amdgpu_ctx_set_stable_pstate(ctx, stable_pstate);
 	mutex_unlock(&adev->pm.stable_pstate_ctx_lock);
 
 	return r;
@@ -428,7 +436,12 @@ static void amdgpu_ctx_fini(struct kref
 	}
 
 	if (drm_dev_enter(adev_to_drm(adev), &idx)) {
-		amdgpu_ctx_set_stable_pstate(ctx, ctx->stable_pstate);
+		mutex_lock(&adev->pm.stable_pstate_ctx_lock);
+		if (adev->pm.stable_pstate_ctx == ctx) {
+			__amdgpu_ctx_set_stable_pstate(ctx, ctx->stable_pstate);
+			adev->pm.stable_pstate_ctx = NULL;
+		}
+		mutex_unlock(&adev->pm.stable_pstate_ctx_lock);
 		drm_dev_exit(idx);
 	}
 


