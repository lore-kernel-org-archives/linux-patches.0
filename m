Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B954F797E;
	Tue, 13 Oct 2026 12:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893664; cv=none; b=aRb3vxKO7zOjIXtlm8od044rKDw2dje+uWE1C5sqp3haxJU+EbEzS0LRVgGjsKJcwsALoGLRdBk37D2pgY64X/J8702f+J7S0aJdWUc/EV6fUPXH1gQk19bO6+zK05neOeHJs21uEsrFfCEYc3haBVto1epcWjHVs/l/lsTZN0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893664; c=relaxed/simple;
	bh=kHFUxjRGn3eMrepFgmUtvxVH12vHOd0g2YhP4B07hzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPBZoMwrVp1fJXMkKF/HpM+qMT4HD20FnqKHzDvqEO1oenJqSIEkym93AyPZAQne7YfWyZT6g8Z6iOpuu5TvMt9OzQ19XupZc3bfr2IfVhyKSg3j0hvN+i44Lbh9idKhKicc0JPxUVkSIunEML3E+OeThktltz1ueqSqrDlhKuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBvDxbUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBvDxbUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95DF1F000FF;
	Tue, 13 Oct 2026 12:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893663;
	bh=yTTLs4EThTa5AEvLMbjSXYpIU7HJ/RAPngaGTSYijGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBvDxbUeJHSB331fLZyOHjzIna3RvNDi1umtcZ8QkARM1HMvTWmovdKzHXCaxJNUC
	 3R/07I2ts4NWqXSEASt4D17nPtUdWfM6BO3DupFqhomvkCaBOg99NAuakteOhoEKe1
	 /bgnY3Fkp0tQuoEDYRU2NPIPTke0TgOmTYJG3sIY=
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
Subject: [PATCH 6.18 257/621] drm/i915/gt: Fix NULL deref on sched_engine alloc failure
Date: Tue, 13 Oct 2026 13:34:12 +0200
Message-ID: <20261013112926.959576362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7f389cb0bde44..e2fc1b1f09794 100644
--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -3930,11 +3930,11 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
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
@@ -3966,10 +3966,8 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
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
@@ -3985,10 +3983,8 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 	intel_context_init(&ve->context, &ve->base);
 
 	ve->base.breadcrumbs = intel_breadcrumbs_create(NULL);
-	if (!ve->base.breadcrumbs) {
-		err = -ENOMEM;
+	if (!ve->base.breadcrumbs)
 		goto err_put;
-	}
 
 	for (n = 0; n < count; n++) {
 		struct intel_engine_cs *sibling = siblings[n];
@@ -4063,8 +4059,13 @@ execlists_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
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



