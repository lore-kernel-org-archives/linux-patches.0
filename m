Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6B238654F;
	Sat, 17 Oct 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254383; cv=none; b=KFX98CXfO/7l9+XA1VuG9bK2zw+NVmlW1YV3ROFUIBbj9Tj1WOU4c+GlTkQzHiHDsO0dOEItRXdu1JgoGFimt6AzdtefD5WIOx0IKHupiBQ8pAJaS2imEyCnOQSqpy6ajcOo8avQfl8h4PMxboHYzHpPOXhnM7JIDq1BPFY3zps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254383; c=relaxed/simple;
	bh=78TkbuEbzUb0dNejL92k1W+ZLBEXyA1gGSy/BpYU7Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTviG2FLNuJ9tjgm0tpinNc+VwKw5HGZWHAc9+sWTe/kQnq1zvPuULoOFk0Tk6nP28D2OOkk4OxNdaygHgiJp2rX9dSirlOtrTOkxnRcDRmNA6qih76DRfYNJdGPpWdQgaEviVu0xKD+HkTGu6QXW43BGoCjWmJOSpq+fyc5nmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUrnEwoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUrnEwoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73A91F000C4;
	Sat, 17 Oct 2026 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254382;
	bh=YOEZlHx7sZXh9EoGfzE9Vky9sXRrQzqr8+lV/Hbrzz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUrnEwoRrZtvel7fBMrn7vA2q9hSLG2Mzj1Aj24OdMybYf7LfFLEqUnA1xvgwhJyM
	 DEIL9SOaACg6XjfgmqORq0D8muGONMSp4WY0aD+O+a6dFxZumd4+z92eDGsD5oIBbc
	 muM6PizQNyyGcH2yvsIDKpMFc5NenQjN7mRUkQk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 386/869] drm/i915/gt: Fix NULL deref on sched_engine alloc failure
Date: Sat, 17 Oct 2026 17:53:47 +0200
Message-ID: <20261017160047.011824137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

[ Upstream commit 82ec992c404c3dc774c5e9f3d4aa858e97187675 ]

Avoid using intel_context_put() before intel_context_init() in
execlists_create_virtual() as the kref_put() inside would lead
to NULL deref on the IOCTL path when sched_engine allocation fails.

Discovered using AI-assisted static analysis confirmed by
Intel Product Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 3e28d37146db ("drm/i915: Move priolist to new i915_sched_engine object")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260701114513.221254-1-joonas.lahtinen@linux.intel.com
(cherry picked from commit 4f2a12f2d50e9f48227656e4dcbd6423506be31d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/gt/intel_execlists_submission.c  | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
index 72090f52fb850..c8501f823991c 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3935,11 +3935,11 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 	struct drm_i915_private *i915 = siblings[0]->i915;
 	struct virtual_engine *ve;
 	unsigned int n;
-	int err;
+	int err = -ENOMEM;
 
 	ve = kzalloc(struct_size(ve, siblings, count), GFP_KERNEL);
 	if (!ve)
-		return ERR_PTR(-ENOMEM);
+		goto err;
 
 	ve->base.i915 = i915;
 	ve->base.gt = siblings[0]->gt;
@@ -3971,10 +3971,8 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 	intel_engine_init_execlists(&ve->base);
 
 	ve->base.sched_engine = i915_sched_engine_create(ENGINE_VIRTUAL);
-	if (!ve->base.sched_engine) {
-		err = -ENOMEM;
-		goto err_put;
-	}
+	if (!ve->base.sched_engine)
+		goto err_noput;
 	ve->base.sched_engine->private_data = &ve->base;
 
 	ve->base.cops = &virtual_context_ops;
@@ -3990,10 +3988,8 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 	intel_context_init(&ve->context, &ve->base);
 
 	ve->base.breadcrumbs = intel_breadcrumbs_create(NULL);
-	if (!ve->base.breadcrumbs) {
-		err = -ENOMEM;
+	if (!ve->base.breadcrumbs)
 		goto err_put;
-	}
 
 	for (n = 0; n < count; n++) {
 		struct intel_engine_cs *sibling = siblings[n];
@@ -4068,8 +4064,13 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 	virtual_engine_initial_hint(ve);
 	return &ve->context;
 
+err_noput:
+	kfree(ve);
+	goto err;
+
 err_put:
 	intel_context_put(&ve->context);
+err:
 	return ERR_PTR(err);
 }
 
-- 
2.53.0



