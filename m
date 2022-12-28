Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FC91C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CFEC433F1;
	Wed, 28 Dec 2022 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245725;
	bh=scAjh5f8FKUHPUIaZJCpBxjtgn9vl/P0GaSN3HR+cwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys+mEpzvBxyy0Uz7Fnms6BDco4BMr7dT640JN9naaa8JcF4AFpfxLmBbhspNWu63i
	 HAJCDC2FzruXRmg18cB1RtjIf3CjRKWxocQq+VYAtlSsMlti03zYBdRfkVO6tuWQA0
	 6xpAt32o5k0HSWVrX243K94Zp2I7zbA3/2MQgDb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	George Shen <george.shen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0944/1073] drm/amd/display: Workaround to increase phantom pipe vactive in pipesplit
Date: Wed, 28 Dec 2022 15:42:12 +0100
Message-Id: <20221228144353.679754050@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: George Shen <george.shen@amd.com>

[ Upstream commit 5b8f9deaf3b6badfc0da968e6e07ceabd19700b6 ]

[Why]
Certain high resolution displays exhibit DCC line corruption with SubVP
enabled. This is likely due to insufficient DCC meta data buffered
immediately after the mclk switch.

[How]
Add workaround to increase phantom pipe vactive height by
meta_row_height number of lines, thus increasing the amount of meta data
buffered immediately after mclk switch finishes.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 07c56e231b04..d05df4f7139f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -485,9 +485,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
 	unsigned int i, pipe_idx;
 	struct pipe_ctx *pipe;
 	uint32_t phantom_vactive, phantom_bp, pstate_width_fw_delay_lines;
+	unsigned int num_dpp;
 	unsigned int vlevel = context->bw_ctx.dml.vba.VoltageLevel;
 	unsigned int dcfclk = context->bw_ctx.dml.vba.DCFCLKState[vlevel][context->bw_ctx.dml.vba.maxMpcComb];
 	unsigned int socclk = context->bw_ctx.dml.vba.SOCCLKPerState[vlevel];
+	struct vba_vars_st *vba = &context->bw_ctx.dml.vba;
 
 	dc_assert_fp_enabled();
 
@@ -523,6 +525,11 @@ void dcn32_set_phantom_stream_timing(struct dc *dc,
 	phantom_vactive = get_subviewport_lines_needed_in_mall(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx) +
 				pstate_width_fw_delay_lines + dc->caps.subvp_swath_height_margin_lines;
 
+	// W/A for DCC corruption with certain high resolution timings.
+	// Determing if pipesplit is used. If so, add meta_row_height to the phantom vactive.
+	num_dpp = vba->NoOfDPP[vba->VoltageLevel][vba->maxMpcComb][vba->pipe_plane[pipe_idx]];
+	phantom_vactive += num_dpp > 1 ? vba->meta_row_height[vba->pipe_plane[pipe_idx]] : 0;
+
 	// For backporch of phantom pipe, use vstartup of the main pipe
 	phantom_bp = get_vstartup(&context->bw_ctx.dml, pipes, pipe_cnt, pipe_idx);
 
-- 
2.35.1



