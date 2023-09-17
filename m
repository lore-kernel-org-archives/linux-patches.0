Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03367461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB89C433C7;
	Sun, 17 Sep 2023 20:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981171;
	bh=JQAtbsY5w7UTVgv01xI83BtoLB70zbCoWuozD11rWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/Cw2y8krj0fZ0JB1ww6kHdF86UNc2mOFc7r5yswO1LYiWIqllzO+pwoxm5x0aVCF
	 gMS7STnpU2hwVDjLdJPS5WVd6U2bhisuvwu9edVAUYSLuMaJOWGdvC1sdpbr4YRkf5
	 0/HIxVhUd739NfSnS0bu6Oiy2vB0pBnnzqqr/hUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/219] drm/i915: mark requests for GuC virtual engines to avoid use-after-free
Date: Sun, 17 Sep 2023 21:13:29 +0200
Message-ID: <20230917191043.938406444@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Hajda <andrzej.hajda@intel.com>

[ Upstream commit 5eefc5307c983b59344a4cb89009819f580c84fa ]

References to i915_requests may be trapped by userspace inside a
sync_file or dmabuf (dma-resv) and held indefinitely across different
proceses. To counter-act the memory leaks, we try to not to keep
references from the request past their completion.
On the other side on fence release we need to know if rq->engine
is valid and points to hw engine (true for non-virtual requests).
To make it possible extra bit has been added to rq->execution_mask,
for marking virtual engines.

Fixes: bcb9aa45d5a0 ("Revert "drm/i915: Hold reference to intel_context over life of i915_request"")
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821153035.3903006-1-andrzej.hajda@intel.com
(cherry picked from commit 280410677af763f3871b93e794a199cfcf6fb580)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h      | 1 +
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 3 +++
 drivers/gpu/drm/i915/i915_request.c               | 7 ++-----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index 6b5d4ea22b673..107f465a27b9e 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -56,6 +56,7 @@ struct intel_breadcrumbs;
 
 typedef u32 intel_engine_mask_t;
 #define ALL_ENGINES ((intel_engine_mask_t)~0ul)
+#define VIRTUAL_ENGINES BIT(BITS_PER_TYPE(intel_engine_mask_t) - 1)
 
 struct intel_hw_status_page {
 	struct list_head timelines;
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 0ec07dad1dcf1..fecdc7ea78ebd 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -5111,6 +5111,9 @@ guc_create_virtual(struct intel_engine_cs **siblings, unsigned int count,
 
 	ve->base.flags = I915_ENGINE_IS_VIRTUAL;
 
+	BUILD_BUG_ON(ilog2(VIRTUAL_ENGINES) < I915_NUM_ENGINES);
+	ve->base.mask = VIRTUAL_ENGINES;
+
 	intel_context_init(&ve->context, &ve->base);
 
 	for (n = 0; n < count; n++) {
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 803cd2ad4deb5..7ce126a01cbf6 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -134,9 +134,7 @@ static void i915_fence_release(struct dma_fence *fence)
 	i915_sw_fence_fini(&rq->semaphore);
 
 	/*
-	 * Keep one request on each engine for reserved use under mempressure
-	 * do not use with virtual engines as this really is only needed for
-	 * kernel contexts.
+	 * Keep one request on each engine for reserved use under mempressure.
 	 *
 	 * We do not hold a reference to the engine here and so have to be
 	 * very careful in what rq->engine we poke. The virtual engine is
@@ -166,8 +164,7 @@ static void i915_fence_release(struct dma_fence *fence)
 	 * know that if the rq->execution_mask is a single bit, rq->engine
 	 * can be a physical engine with the exact corresponding mask.
 	 */
-	if (!intel_engine_is_virtual(rq->engine) &&
-	    is_power_of_2(rq->execution_mask) &&
+	if (is_power_of_2(rq->execution_mask) &&
 	    !cmpxchg(&rq->engine->request_pool, NULL, rq))
 		return;
 
-- 
2.40.1



