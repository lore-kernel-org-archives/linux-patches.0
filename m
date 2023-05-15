Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FED7FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69872C433D2;
	Mon, 15 May 2023 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170014;
	bh=uT7yH8EljGRkIGVgE54YDzsgnkU/Avswe1YPG7bcaDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOZDGrlQLlFB+FUf4LpgqVGZPO31rP4gHtrxJA9KKzK+mAKZpTyXsyJzQ1Np8JwTJ
	 JopdLD0QPCNU+q1wJOX92x86FagQwRSG2RRIR6srjdwRyVvprZzwmiuG8f3TGKBZZY
	 W9J3YbTardJ4jv/S+yanK4VYqPEgVGmmEsEkvCeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 218/246] drm/i915/mtl: Add workarounds Wa_14017066071 and Wa_14017654203
Date: Mon, 15 May 2023 18:27:10 +0200
Message-Id: <20230515161729.134779997@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
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
index be0f6e305c881..15b8636853ff0 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_regs.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_regs.h
@@ -1145,6 +1145,7 @@
 #define   ENABLE_SMALLPL			REG_BIT(15)
 #define   SC_DISABLE_POWER_OPTIMIZATION_EBB	REG_BIT(9)
 #define   GEN11_SAMPLER_ENABLE_HEADLESS_MSG	REG_BIT(5)
+#define   MTL_DISABLE_SAMPLER_SC_OOO		REG_BIT(3)
 
 #define GEN9_HALF_SLICE_CHICKEN7		MCR_REG(0xe194)
 #define   DG2_DISABLE_ROUND_ENABLE_ALLOW_FOR_SSLA	REG_BIT(15)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 485c5cc5d0f96..bfdffb6a013ce 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -3015,6 +3015,15 @@ general_render_compute_wa_init(struct intel_engine_cs *engine, struct i915_wa_li
 
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
 	    IS_DG2_GRAPHICS_STEP(i915, G10, STEP_B0, STEP_FOREVER) ||
-- 
2.39.2



