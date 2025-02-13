Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62034281377;
	Thu, 13 Feb 2025 14:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457250; cv=none; b=oHCKNX67y8Z6PcmWOX928JCQBYwvT6vn6gqoI1SdtZCbVfXjqsVjDvfEJMyVA8/bS1fQL/nXMUm0BhBRFjmLabtiratpW9micYjAvd8kYmIa0Tr3TY6D048I7dXB4y8JqhlEBhuDO9By7eK+/d5E1jqa3h9+Kow2nuvXl3Hl5PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457250; c=relaxed/simple;
	bh=3ODMXChXrlWaL07KjkCLVAyK0g+0V2g+faSJ2e1fwtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Olknim+8f8dxlBI74vADMgWZhtzrOCdFu1B1wQx3lMo6SzfKQSTNsWSk6wjLELztQzV81z/0SUzCBw5t9MtU1+Ou8XyFkhb5ZxVhyQnzm3JzuJRzf7/m9oTDHOlKEiW3LfNPc0eEM0KmoW8BXO4156pgqPnLfJCqNxTADpuRSZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0s4YytSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0s4YytSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63B0C4CED1;
	Thu, 13 Feb 2025 14:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457250;
	bh=3ODMXChXrlWaL07KjkCLVAyK0g+0V2g+faSJ2e1fwtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0s4YytSdaAeh3pvr4bLKIrw+/zcBcr5lCuMzp+boFlFvLuwT/G2Pfssl3WEtXZ7ZG
	 EpkjeKSieMsqDhvTXyYA2wtceI8umaFm14WLNKloeuMooeEnD3LOfh16SxeYthItwJ
	 5V4iK+i+PZA99En0wpHOjn5cdObp2kiutBOQdgPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ausef Yousof <Ausef.Yousof@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/422] drm/amd/display: Overwriting dualDPP UBF values before usage
Date: Thu, 13 Feb 2025 15:22:55 +0100
Message-ID: <20250213142437.564452792@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 24909d9ec7c3afa8da2f3c9afa312e7a4a61f250 ]

[WHY]
Right now in dml2 mode validation we are calculating UBF parameters for
prefetch calculation for single and dual DPP scenarios. Data structure
to store such values are just 1D arrays, the single DPP values are
overwritten by the dualDPP values, and we end up using dualDPP for
prefetch calculations twice (once in place of singleDPP support check
and again for dual).

This naturally leads to many problems, one of which validating a mode in
"singleDPP" (when we used dual DPP parameters) and sending the singleDPP
parameters to mode programming, if we cannot support then we observe the
corruption as described in the ticket.

[HOW]
UBF values need to have 2d arrays to store values specific to single and
dual DPP states to avoid single DPP values being overwritten. Other
parameters are recorded on a per state basis such as prefetch UBF values
but they are in the same loop used for calculation and at that point its
fine to overwrite them, its not the case for plain UBF values.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dml2/display_mode_core.c   | 30 +++++++++----------
 .../dc/dml2/display_mode_core_structs.h       |  6 ++--
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index be87dc0f07799..6822b07951204 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6301,9 +6301,9 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 			mode_lib->ms.meta_row_bandwidth_this_state,
 			mode_lib->ms.dpte_row_bandwidth_this_state,
 			mode_lib->ms.NoOfDPPThisState,
-			mode_lib->ms.UrgentBurstFactorLuma,
-			mode_lib->ms.UrgentBurstFactorChroma,
-			mode_lib->ms.UrgentBurstFactorCursor);
+			mode_lib->ms.UrgentBurstFactorLuma[j],
+			mode_lib->ms.UrgentBurstFactorChroma[j],
+			mode_lib->ms.UrgentBurstFactorCursor[j]);
 
 		s->VMDataOnlyReturnBWPerState = dml_get_return_bw_mbps_vm_only(
 																	&mode_lib->ms.soc,
@@ -6458,9 +6458,9 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 				mode_lib->ms.cursor_bw_pre,
 				mode_lib->ms.prefetch_vmrow_bw,
 				mode_lib->ms.NoOfDPPThisState,
-				mode_lib->ms.UrgentBurstFactorLuma,
-				mode_lib->ms.UrgentBurstFactorChroma,
-				mode_lib->ms.UrgentBurstFactorCursor,
+				mode_lib->ms.UrgentBurstFactorLuma[j],
+				mode_lib->ms.UrgentBurstFactorChroma[j],
+				mode_lib->ms.UrgentBurstFactorCursor[j],
 				mode_lib->ms.UrgentBurstFactorLumaPre,
 				mode_lib->ms.UrgentBurstFactorChromaPre,
 				mode_lib->ms.UrgentBurstFactorCursorPre,
@@ -6517,9 +6517,9 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 						mode_lib->ms.cursor_bw,
 						mode_lib->ms.cursor_bw_pre,
 						mode_lib->ms.NoOfDPPThisState,
-						mode_lib->ms.UrgentBurstFactorLuma,
-						mode_lib->ms.UrgentBurstFactorChroma,
-						mode_lib->ms.UrgentBurstFactorCursor,
+						mode_lib->ms.UrgentBurstFactorLuma[j],
+						mode_lib->ms.UrgentBurstFactorChroma[j],
+						mode_lib->ms.UrgentBurstFactorCursor[j],
 						mode_lib->ms.UrgentBurstFactorLumaPre,
 						mode_lib->ms.UrgentBurstFactorChromaPre,
 						mode_lib->ms.UrgentBurstFactorCursorPre);
@@ -6586,9 +6586,9 @@ static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
 													mode_lib->ms.cursor_bw_pre,
 													mode_lib->ms.prefetch_vmrow_bw,
 													mode_lib->ms.NoOfDPP[j], // VBA_ERROR DPPPerSurface is not assigned at this point, should use NoOfDpp here
-													mode_lib->ms.UrgentBurstFactorLuma,
-													mode_lib->ms.UrgentBurstFactorChroma,
-													mode_lib->ms.UrgentBurstFactorCursor,
+													mode_lib->ms.UrgentBurstFactorLuma[j],
+													mode_lib->ms.UrgentBurstFactorChroma[j],
+													mode_lib->ms.UrgentBurstFactorCursor[j],
 													mode_lib->ms.UrgentBurstFactorLumaPre,
 													mode_lib->ms.UrgentBurstFactorChromaPre,
 													mode_lib->ms.UrgentBurstFactorCursorPre,
@@ -7809,9 +7809,9 @@ dml_bool_t dml_core_mode_support(struct display_mode_lib_st *mode_lib)
 				mode_lib->ms.DETBufferSizeYThisState[k],
 				mode_lib->ms.DETBufferSizeCThisState[k],
 				/* Output */
-				&mode_lib->ms.UrgentBurstFactorCursor[k],
-				&mode_lib->ms.UrgentBurstFactorLuma[k],
-				&mode_lib->ms.UrgentBurstFactorChroma[k],
+				&mode_lib->ms.UrgentBurstFactorCursor[j][k],
+				&mode_lib->ms.UrgentBurstFactorLuma[j][k],
+				&mode_lib->ms.UrgentBurstFactorChroma[j][k],
 				&mode_lib->ms.NotUrgentLatencyHiding[k]);
 		}
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core_structs.h b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core_structs.h
index f951936bb579e..504c427b3b319 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core_structs.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core_structs.h
@@ -884,11 +884,11 @@ struct mode_support_st {
 	dml_uint_t meta_row_height[__DML_NUM_PLANES__];
 	dml_uint_t meta_row_height_chroma[__DML_NUM_PLANES__];
 	dml_float_t UrgLatency;
-	dml_float_t UrgentBurstFactorCursor[__DML_NUM_PLANES__];
+	dml_float_t UrgentBurstFactorCursor[2][__DML_NUM_PLANES__];
 	dml_float_t UrgentBurstFactorCursorPre[__DML_NUM_PLANES__];
-	dml_float_t UrgentBurstFactorLuma[__DML_NUM_PLANES__];
+	dml_float_t UrgentBurstFactorLuma[2][__DML_NUM_PLANES__];
 	dml_float_t UrgentBurstFactorLumaPre[__DML_NUM_PLANES__];
-	dml_float_t UrgentBurstFactorChroma[__DML_NUM_PLANES__];
+	dml_float_t UrgentBurstFactorChroma[2][__DML_NUM_PLANES__];
 	dml_float_t UrgentBurstFactorChromaPre[__DML_NUM_PLANES__];
 	dml_float_t MaximumSwathWidthInLineBufferLuma;
 	dml_float_t MaximumSwathWidthInLineBufferChroma;
-- 
2.39.5



