Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E2E11C94
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA55C433C8;
	Mon, 28 Aug 2023 10:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218690;
	bh=QNe/QEY/Mk/Dkn9Im5z862V6xl+U0WjpVTg7QF+JV44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT+1ZohtlNA/s+svAAic4dTp3HTZ850gjqvL9MpAHIjjTP1h5IuNTgI0dlwXKvC8N
	 1tPRXV/OM4uBTlyhoa7t9x/Jz3dNuNo2H6Dqd285vk4wfU8yz6Y4KPGTFnOfzl9Yra
	 2UIMaJZjVujdOfhlGltD0n9Uqwre8rN1f5y6WF2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/122] drm/i915: Add the gen12_needs_ccs_aux_inv helper
Date: Mon, 28 Aug 2023 12:12:15 +0200
Message-ID: <20230828101157.111103084@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@linux.intel.com>

[ Upstream commit b2f59e9026038a5bbcbc0019fa58f963138211ee ]

We always assumed that a device might either have AUX or FLAT
CCS, but this is an approximation that is not always true, e.g.
PVC represents an exception.

Set the basis for future finer selection by implementing a
boolean gen12_needs_ccs_aux_inv() function that tells whether aux
invalidation is needed or not.

Currently PVC is the only exception to the above mentioned rule.

Requires: 059ae7ae2a1c ("drm/i915/gt: Cleanup aux invalidation registers")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230725001950.1014671-3-andi.shyti@linux.intel.com
(cherry picked from commit c827655b87ad201ebe36f2e28d16b5491c8f7801)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/gen8_engine_cs.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
index b2838732ac936..8e286733a4367 100644
--- a/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/gen8_engine_cs.c
@@ -165,6 +165,18 @@ static u32 preparser_disable(bool state)
 	return MI_ARB_CHECK | 1 << 8 | state;
 }
 
+static bool gen12_needs_ccs_aux_inv(struct intel_engine_cs *engine)
+{
+	if (IS_PONTEVECCHIO(engine->i915))
+		return false;
+
+	/*
+	 * so far platforms supported by i915 having
+	 * flat ccs do not require AUX invalidation
+	 */
+	return !HAS_FLAT_CCS(engine->i915);
+}
+
 u32 *gen12_emit_aux_table_inv(struct intel_gt *gt, u32 *cs, const i915_reg_t inv_reg)
 {
 	u32 gsi_offset = gt->uncore->gsi_offset;
@@ -236,7 +248,7 @@ int gen12_emit_flush_rcs(struct i915_request *rq, u32 mode)
 		else if (engine->class == COMPUTE_CLASS)
 			flags &= ~PIPE_CONTROL_3D_ENGINE_FLAGS;
 
-		if (!HAS_FLAT_CCS(rq->engine->i915))
+		if (gen12_needs_ccs_aux_inv(rq->engine))
 			count = 8 + 4;
 		else
 			count = 8;
@@ -254,7 +266,7 @@ int gen12_emit_flush_rcs(struct i915_request *rq, u32 mode)
 
 		cs = gen8_emit_pipe_control(cs, flags, LRC_PPHWSP_SCRATCH_ADDR);
 
-		if (!HAS_FLAT_CCS(rq->engine->i915)) {
+		if (gen12_needs_ccs_aux_inv(rq->engine)) {
 			/* hsdes: 1809175790 */
 			cs = gen12_emit_aux_table_inv(rq->engine->gt, cs,
 						      GEN12_CCS_AUX_INV);
@@ -276,7 +288,7 @@ int gen12_emit_flush_xcs(struct i915_request *rq, u32 mode)
 	if (mode & EMIT_INVALIDATE) {
 		cmd += 2;
 
-		if (!HAS_FLAT_CCS(rq->engine->i915) &&
+		if (gen12_needs_ccs_aux_inv(rq->engine) &&
 		    (rq->engine->class == VIDEO_DECODE_CLASS ||
 		     rq->engine->class == VIDEO_ENHANCEMENT_CLASS)) {
 			aux_inv = rq->engine->mask &
-- 
2.40.1



