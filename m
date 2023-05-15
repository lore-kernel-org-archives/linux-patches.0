Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10017FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB53C43443;
	Mon, 15 May 2023 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171438;
	bh=DvYH+xywGVlj2g5KbP5pThjfVBI9x7bOPqcNU1w3PP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXpJDYvmjnUZffB6tsNhZsbW+r7NTOe4u+hUtZqNUB77vFJp4+ClvucOYPEGKKIN+
	 yD1IsP/zmGB0ExYd2CFsiHH/4+d/Od1IjOUNz8rEXVSntnj1vINKBnnkZaaTKWcqKX
	 VB1WFVLnyLa9V5UQ4OF28G2cdiGn34jZE1ORfwoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 210/242] drm/i915/mtl: Add workarounds Wa_14017066071 and Wa_14017654203
Date: Mon, 15 May 2023 18:28:56 +0200
Message-Id: <20230515161728.232788770@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radhakrishna Sripada <radhakrishna.sripada@intel.com>

[ Upstream commit 5fba65efa7cfb8cef227a2c555deb10327a5e27b ]

Both workarounds require the same implementation and apply to MTL P and
M from stepping A0 to B0 (exclusive).

v2:
  - Remove unrelated brace removal. (Matt)

Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230329212336.106161-2-gustavo.sousa@intel.com
Stable-dep-of: 81900e3a3775 ("drm/i915: disable sampler indirect state in bindless heap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_regs.h     | 1 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_regs.h b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
index 9758b0b635601..cd45a45066ccb 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1135,6 +1135,7 @@
 #define   ENABLE_SMALLPL			REG_BIT(15)
 #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
 #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
+#define   MTL_DISABLE_SAMPLER_SC_OOO		REG_BIT(3)
 
 #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
 #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index e13052c5dae19..526fb9cc36b9b 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -3035,6 +3035,15 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 
 	add_render_compute_tuning_settings(i915, wal);
 
+	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
+	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0))
+		/*
+		 * Wa_14017066071
+		 * Wa_14017654203
+		 */
+		wa_mcr_masked_en(wal, GEN10_SAMPLER_MODE,
+				 MTL_DISABLE_SAMPLER_SC_OOO);
+
 	if (IS_MTL_GRAPHICS_STEP(i915, M, STEP_A0, STEP_B0) ||
 	    IS_MTL_GRAPHICS_STEP(i915, P, STEP_A0, STEP_B0) ||
 	    IS_PONTEVECCHIO(i915) ||
-- 
2.39.2



