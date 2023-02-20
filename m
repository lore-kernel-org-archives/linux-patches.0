Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1012463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF75C433D2;
	Mon, 20 Feb 2023 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901215;
	bh=BhaweQ49vOQZnSjvZkeRts6GVuae7qNdmFUj6voPtdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOHgzzQKnVZGZp8TOBdZ3LIcueJFEYDmhswY/zHC1g84kpQJ+PHwTadFceGAYtNF5
	 SBihhApoa/EIKGYYXyJBjeYbWPSQmOgnGejw5pdNJfwSdkcfZH8//DBOOPrQ0sj+Cw
	 4IpQoU+DPGKbB5+cEjJBmGDttFYQBVOk8eI+eHBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/83] drm/i915/gen11: Wa_1408615072/Wa_1407596294 should be on GT list
Date: Mon, 20 Feb 2023 14:36:47 +0100
Message-Id: <20230220133556.266763661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit d5a1224aa68c8b124a4c5c390186e571815ed390 ]

The UNSLICE_UNIT_LEVEL_CLKGATE register programmed by this workaround
has 'BUS' style reset, indicating that it does not lose its value on
engine resets.  Furthermore, this register is part of the GT forcewake
domain rather than the RENDER domain, so it should not be impacted by
RCS engine resets.  As such, we should implement this on the GT
workaround list rather than an engine list.

Bspec: 19219
Fixes: 3551ff928744 ("drm/i915/gen11: Moving WAs to rcs_engine_wa_init()")
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230201222831.608281-2-matthew.d.roper@intel.com
(cherry picked from commit 5f21dc07b52eb54a908e66f5d6e05a87bcb5b049)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_workarounds.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index 0dda8f6da4230..de93a1e988f29 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1049,6 +1049,13 @@ icl_gt_workarounds_init(struct drm_i915_private *i915, struct i915_wa_list *wal)
 		    GAMT_CHKN_BIT_REG,
 		    GAMT_CHKN_DISABLE_L3_COH_PIPE);
 
+	/*
+	 * Wa_1408615072:icl,ehl  (vsunit)
+	 * Wa_1407596294:icl,ehl  (hsunit)
+	 */
+	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
+		    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
+
 	/* Wa_1407352427:icl,ehl */
 	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
 		    PSDUNIT_CLKGATE_DIS);
@@ -1747,13 +1754,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_masked_en(wal, GEN9_CSFE_CHICKEN1_RCS,
 			     GEN11_ENABLE_32_PLANE_MODE);
 
-		/*
-		 * Wa_1408615072:icl,ehl  (vsunit)
-		 * Wa_1407596294:icl,ehl  (hsunit)
-		 */
-		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
-			    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
-
 		/*
 		 * Wa_1408767742:icl[a2..forever],ehl[all]
 		 * Wa_1605460711:icl[a0..c0]
-- 
2.39.0



