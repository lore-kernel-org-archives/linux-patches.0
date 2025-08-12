Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CFA2F6573;
	Tue, 12 Aug 2025 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025107; cv=none; b=Om8dzWBmWtgmqwOMu+0cyT3Dn0ekSl6/BxFvuc2M8SlVhO3O+wLpYrRP/8dCC6XkBr1sM27meW5nF1nEQT1S8EqxCF/hsrxYByGlp5Lc1tJmfmEg72S/45YoNA6QV+KxCGRpm9iR/s51r0AQ3FuW3zAnaOhRVyXyqorR9q2BFsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025107; c=relaxed/simple;
	bh=oBm07/OnSCojxzzld7wwgZWzuT37tkwU6rLvOhX1Qa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qylL6ElarFphzqAqg6QRDLRJ0iFzxGkAju3EUoWYpTw/W6zTGpP+VA4M8wGaLThaDem4IGgD9rfJSf2Zh74xQEyHL6CCvsDV4O3tvGCaEtMyMo43eyV1/ulDpgongHDtKvDwciVaFk03wyNdlN6TpKyKvuwdByRzFKXyla4p+SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdyWgvMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdyWgvMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512F2C4CEF0;
	Tue, 12 Aug 2025 18:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025106;
	bh=oBm07/OnSCojxzzld7wwgZWzuT37tkwU6rLvOhX1Qa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdyWgvMjEf4OAgU3dai2JITQYTrG/McPO8/yHHsMFE4x+koLhMBLfFOcuZObXWjSw
	 D+aEgCdIu6oDxFzu5dTtCrF4updQOPeICzk/oETx2uEH5263crOkRWeEZClMWO+BUP
	 bRaAMXGm/TYKj9QMTr0HoAkXJXokR+3XblNhvHeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 572/627] tools/power turbostat: Fix DMR support
Date: Tue, 12 Aug 2025 19:34:27 +0200
Message-ID: <20250812173453.638604224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 3a088b07c4f10bf577f4a2392111704195a794ba ]

Together with the RAPL MSRs, there are more MSRs gone on DMR, including
PLR (Perf Limit Reasons), and IRTL (Package cstate Interrupt Response
Time Limit) MSRs. The configurable TDP info should also be retrieved
from TPMI based Intel Speed Select Technology feature.

Remove the access of these MSRs for DMR. Improve the DMR platform
feature table to make it more readable at the same time.

Fixes: 83075bd59de2 ("tools/power turbostat: Add initial support for DMR")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 29 ++++++++++++++-------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index d56d457d6d93..426eabc10d76 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -840,20 +840,21 @@ static const struct platform_features spr_features = {
 };
 
 static const struct platform_features dmr_features = {
-	.has_msr_misc_feature_control = spr_features.has_msr_misc_feature_control,
-	.has_msr_misc_pwr_mgmt = spr_features.has_msr_misc_pwr_mgmt,
-	.has_nhm_msrs = spr_features.has_nhm_msrs,
-	.has_config_tdp = spr_features.has_config_tdp,
-	.bclk_freq = spr_features.bclk_freq,
-	.supported_cstates = spr_features.supported_cstates,
-	.cst_limit = spr_features.cst_limit,
-	.has_msr_core_c1_res = spr_features.has_msr_core_c1_res,
-	.has_msr_module_c6_res_ms = 1,	/* DMR has Dual Core Module and MC6 MSR */
-	.has_irtl_msrs = spr_features.has_irtl_msrs,
-	.has_cst_prewake_bit = spr_features.has_cst_prewake_bit,
-	.has_fixed_rapl_psys_unit = spr_features.has_fixed_rapl_psys_unit,
-	.trl_msrs = spr_features.trl_msrs,
-	.rapl_msrs = 0,		/* DMR does not have RAPL MSRs */
+	.has_msr_misc_feature_control	= spr_features.has_msr_misc_feature_control,
+	.has_msr_misc_pwr_mgmt		= spr_features.has_msr_misc_pwr_mgmt,
+	.has_nhm_msrs			= spr_features.has_nhm_msrs,
+	.bclk_freq			= spr_features.bclk_freq,
+	.supported_cstates		= spr_features.supported_cstates,
+	.cst_limit			= spr_features.cst_limit,
+	.has_msr_core_c1_res		= spr_features.has_msr_core_c1_res,
+	.has_cst_prewake_bit		= spr_features.has_cst_prewake_bit,
+	.has_fixed_rapl_psys_unit	= spr_features.has_fixed_rapl_psys_unit,
+	.trl_msrs			= spr_features.trl_msrs,
+	.has_msr_module_c6_res_ms	= 1,	/* DMR has Dual-Core-Module and MC6 MSR */
+	.rapl_msrs			= 0,	/* DMR does not have RAPL MSRs */
+	.plr_msrs			= 0,	/* DMR does not have PLR  MSRs */
+	.has_irtl_msrs			= 0,	/* DMR does not have IRTL MSRs */
+	.has_config_tdp			= 0,	/* DMR does not have CTDP MSRs */
 };
 
 static const struct platform_features srf_features = {
-- 
2.39.5



