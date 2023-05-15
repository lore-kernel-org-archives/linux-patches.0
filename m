Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139BFBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8975C4339B;
	Mon, 15 May 2023 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170199;
	bh=fZdalSZx9f05/xM4dMXYGpKWjeIT09FQ9n2JRDfWyqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf3oe7tOj08szhTJF9YIqRoh0OWaJw0+nagaLFQYArQYDKXO6V3V+XB0c5dmjU8qL
	 /thc7uq9JiHxYUxkLEkQmu3mGqUcDpp60GCeEgGMXQQYtdyXjwHgNZTkMV1j54eUt3
	 Nwwz1kW/VfIp89PWyiPbId71qfP+dAujsR03m80w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Broadworth <mark.broadworth@amd.com>,
	Nevenko Stupar <Nevenko.Stupar@amd.com>,
	Jun Lei <Jun.Lei@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/239] drm/amd/display: Remove FPU guards from the DML folder
Date: Mon, 15 May 2023 18:24:50 +0200
Message-Id: <20230515161722.507625437@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit bbfbf09d193ac831c40db50ef4b31d11548a9eef ]

As part of the programming expectation for using DML functions, DC
requires that any DML function invoked outside DML uses:

 DC_FP_START();
 ... dml function ...
 DC_FP_END();

Additionally, all the DML functions that can be invoked outside the DML
folder call the function dc_assert_fp_enabled(), which is responsible
for triggering a warning in the case that the DML function was not
guarded by the DC_FP_START/END. For this reason, call DC_FP_START/END
inside DML is wrong, and this commit removes all of those references.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Nevenko Stupar <Nevenko.Stupar@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 822b84ecfc64 ("drm/amd/display: Add missing WA and MCLK validation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dml/dcn30/dcn30_fpu.c    |  2 --
 .../drm/amd/display/dc/dml/dcn32/dcn32_fpu.c    | 17 +----------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/dcn30_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/dcn30_fpu.c
index 990dbd736e2ce..4fa6363647937 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/dcn30_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/dcn30_fpu.c
@@ -520,9 +520,7 @@ void dcn30_fpu_calculate_wm_and_dlg(
 		pipe_idx++;
 	}
 
-	DC_FP_START();
 	dcn20_calculate_dlg_params(dc, context, pipes, pipe_cnt, vlevel);
-	DC_FP_END();
 
 	if (!pstate_en)
 		/* Restore full p-state latency */
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index e22b4b3880af9..d2b184fdd7e02 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -1200,9 +1200,7 @@ static void dcn32_full_validate_bw_helper(struct dc *dc,
 			}
 		} else {
 			// Most populate phantom DLG params before programming hardware / timing for phantom pipe
-			DC_FP_START();
 			dcn32_helper_populate_phantom_dlg_params(dc, context, pipes, *pipe_cnt);
-			DC_FP_END();
 
 			/* Call validate_apply_pipe_split flags after calling DML getters for
 			 * phantom dlg params, or some of the VBA params indicating pipe split
@@ -1503,11 +1501,8 @@ bool dcn32_internal_validate_bw(struct dc *dc,
 
 	dml_log_pipe_params(&context->bw_ctx.dml, pipes, pipe_cnt);
 
-	if (!fast_validate) {
-		DC_FP_START();
+	if (!fast_validate)
 		dcn32_full_validate_bw_helper(dc, context, pipes, &vlevel, split, merge, &pipe_cnt);
-		DC_FP_END();
-	}
 
 	if (fast_validate ||
 			(dc->debug.dml_disallow_alternate_prefetch_modes &&
@@ -2172,9 +2167,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 		entry.fabricclk_mhz = 0;
 		entry.dram_speed_mts = 0;
 
-		DC_FP_START();
 		insert_entry_into_table_sorted(table, num_entries, &entry);
-		DC_FP_END();
 	}
 
 	// Insert the max DCFCLK
@@ -2182,9 +2175,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 	entry.fabricclk_mhz = 0;
 	entry.dram_speed_mts = 0;
 
-	DC_FP_START();
 	insert_entry_into_table_sorted(table, num_entries, &entry);
-	DC_FP_END();
 
 	// Insert the UCLK DPMS
 	for (i = 0; i < num_uclk_dpms; i++) {
@@ -2192,9 +2183,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 		entry.fabricclk_mhz = 0;
 		entry.dram_speed_mts = bw_params->clk_table.entries[i].memclk_mhz * 16;
 
-		DC_FP_START();
 		insert_entry_into_table_sorted(table, num_entries, &entry);
-		DC_FP_END();
 	}
 
 	// If FCLK is coarse grained, insert individual DPMs.
@@ -2204,9 +2193,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 			entry.fabricclk_mhz = bw_params->clk_table.entries[i].fclk_mhz;
 			entry.dram_speed_mts = 0;
 
-			DC_FP_START();
 			insert_entry_into_table_sorted(table, num_entries, &entry);
-			DC_FP_END();
 		}
 	}
 	// If FCLK fine grained, only insert max
@@ -2215,9 +2202,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 		entry.fabricclk_mhz = max_fclk_mhz;
 		entry.dram_speed_mts = 0;
 
-		DC_FP_START();
 		insert_entry_into_table_sorted(table, num_entries, &entry);
-		DC_FP_END();
 	}
 
 	// At this point, the table contains all "points of interest" based on
-- 
2.39.2



