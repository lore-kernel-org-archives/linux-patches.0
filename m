Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07FA4FF7B;
	Mon, 18 Dec 2023 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pU52n9Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42994C433C8;
	Mon, 18 Dec 2023 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908182;
	bh=1/fCXDYGMSqljdjQNBlKY/gKtK6mqzIdlMjrcE0EAB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pU52n9Z9hTJpPj83ZpjxtPGaiqliqvuSre+Tstj0EAIVT2b0X6FzFerw3c9qSy/ck
	 k842ndgG8v81L0GYDxXSRbBOxNNIQiGn5CyXh9VD+YL6JRaFJbovbT3yk2SZdx1z/X
	 1fYQoBTKwOJ8iJld+xUgwriEc7P/t0M60/Qz0lzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/166] drm/i915/selftests: Fix engine reset count storage for multi-tile
Date: Mon, 18 Dec 2023 14:50:48 +0100
Message-ID: <20231218135108.677163505@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

[ Upstream commit 7c7c863bf89c5f76d8c7fda177a81559b61dc15b ]

Engine->id namespace is per-tile so struct igt_live_test->reset_engine[]
needs to be two-dimensional so engine reset counts from all tiles can be
stored with no aliasing. With aliasing, if we had a real multi-tile
platform, the reset counts would be incorrect for same engine instance on
different tiles.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: 0c29efa23f5c ("drm/i915/selftests: Consider multi-gt instead of to_gt()")
Reported-by: Alan Previn Teres Alexis <alan.previn.teres.alexis@intel.com>
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231201122109.729006-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 0647ece3819b018cb62a71c3bcb7c2c3243e78ac)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/selftests/igt_live_test.c | 9 +++++----
 drivers/gpu/drm/i915/selftests/igt_live_test.h | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/igt_live_test.c b/drivers/gpu/drm/i915/selftests/igt_live_test.c
index 4ddc6d902752a..7d41874a49c58 100644
--- a/drivers/gpu/drm/i915/selftests/igt_live_test.c
+++ b/drivers/gpu/drm/i915/selftests/igt_live_test.c
@@ -37,8 +37,9 @@ int igt_live_test_begin(struct igt_live_test *t,
 		}
 
 		for_each_engine(engine, gt, id)
-			t->reset_engine[id] =
-			i915_reset_engine_count(&i915->gpu_error, engine);
+			t->reset_engine[i][id] =
+				i915_reset_engine_count(&i915->gpu_error,
+							engine);
 	}
 
 	t->reset_global = i915_reset_count(&i915->gpu_error);
@@ -66,14 +67,14 @@ int igt_live_test_end(struct igt_live_test *t)
 
 	for_each_gt(gt, i915, i) {
 		for_each_engine(engine, gt, id) {
-			if (t->reset_engine[id] ==
+			if (t->reset_engine[i][id] ==
 			    i915_reset_engine_count(&i915->gpu_error, engine))
 				continue;
 
 			gt_err(gt, "%s(%s): engine '%s' was reset %d times!\n",
 			       t->func, t->name, engine->name,
 			       i915_reset_engine_count(&i915->gpu_error, engine) -
-			       t->reset_engine[id]);
+			       t->reset_engine[i][id]);
 			return -EIO;
 		}
 	}
diff --git a/drivers/gpu/drm/i915/selftests/igt_live_test.h b/drivers/gpu/drm/i915/selftests/igt_live_test.h
index 36ed42736c521..83e3ad430922f 100644
--- a/drivers/gpu/drm/i915/selftests/igt_live_test.h
+++ b/drivers/gpu/drm/i915/selftests/igt_live_test.h
@@ -7,6 +7,7 @@
 #ifndef IGT_LIVE_TEST_H
 #define IGT_LIVE_TEST_H
 
+#include "gt/intel_gt_defines.h" /* for I915_MAX_GT */
 #include "gt/intel_engine.h" /* for I915_NUM_ENGINES */
 
 struct drm_i915_private;
@@ -17,7 +18,7 @@ struct igt_live_test {
 	const char *name;
 
 	unsigned int reset_global;
-	unsigned int reset_engine[I915_NUM_ENGINES];
+	unsigned int reset_engine[I915_MAX_GT][I915_NUM_ENGINES];
 };
 
 /*
-- 
2.43.0



