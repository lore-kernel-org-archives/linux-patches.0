Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B49D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF14C433D2;
	Mon, 12 Jun 2023 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567000;
	bh=LbffKf9v3dKBaeQq37WIBdVftKgG1vbIxyNIVX8aDoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZL70HH00wuxf3ZT5YV9TtPopoOPghQRgL83Rrs5vrTkNteq6Mand9md5s/IZte6Q
	 /YLFQZzHGT7zX7ku5f7lwPRUF6mClkgLqy/pA6D7FR5xKGiOLFnqbfbJRaSEjum/HP
	 UR9C3AoPDFUJ+IEcaYdOpU9kAYschW2vq88B3wbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.3 084/160] drm/i915/gt: Use the correct error value when kernel_context() fails
Date: Mon, 12 Jun 2023 12:26:56 +0200
Message-ID: <20230612101718.844734000@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andi Shyti <andi.shyti@linux.intel.com>

commit 40023959dbab3c6ad56fa7213770e63d197b69fb upstream.

kernel_context() returns an error pointer. Use pointer-error
conversion functions to evaluate its return value, rather than
checking for a '0' return.

Fixes: eb5c10cbbc2f ("drm/i915: Remove I915_USER_PRIORITY_SHIFT")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.13+
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Acked-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230526124138.2006110-1-andi.shyti@linux.intel.com
(cherry picked from commit edad9ee94f17adc75d3b13ab51bbe3d615ce1e7e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/selftest_execlists.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/selftest_execlists.c
+++ b/drivers/gpu/drm/i915/gt/selftest_execlists.c
@@ -1530,8 +1530,8 @@ static int live_busywait_preempt(void *a
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	enum intel_engine_id id;
-	int err = -ENOMEM;
 	u32 *map;
+	int err;
 
 	/*
 	 * Verify that even without HAS_LOGICAL_RING_PREEMPTION, we can
@@ -1539,13 +1539,17 @@ static int live_busywait_preempt(void *a
 	 */
 
 	ctx_hi = kernel_context(gt->i915, NULL);
-	if (!ctx_hi)
-		return -ENOMEM;
+	if (IS_ERR(ctx_hi))
+		return PTR_ERR(ctx_hi);
+
 	ctx_hi->sched.priority = I915_CONTEXT_MAX_USER_PRIORITY;
 
 	ctx_lo = kernel_context(gt->i915, NULL);
-	if (!ctx_lo)
+	if (IS_ERR(ctx_lo)) {
+		err = PTR_ERR(ctx_lo);
 		goto err_ctx_hi;
+	}
+
 	ctx_lo->sched.priority = I915_CONTEXT_MIN_USER_PRIORITY;
 
 	obj = i915_gem_object_create_internal(gt->i915, PAGE_SIZE);


