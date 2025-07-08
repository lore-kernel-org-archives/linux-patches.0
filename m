Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BD32E2F0D;
	Tue,  8 Jul 2025 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993126; cv=none; b=M7Dsdw1CCFqL9XzPIEeyXu/Meg9fsmXYPibwY+VUboCQ/CdSzCCb0oTXxqRlXo1RYR3K9r8jPr6MZ7i2Cz4U7QLqBrqso+W/oYmyNBEz5jarXFOOCnSqYYcPh2KNl609GmO7oO0De7Cjm5taXpM6OJbtroOWvPIj2DcC/WP4ZgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993126; c=relaxed/simple;
	bh=KErBfbcQ1e+l2uNFRCW+b3VQuf84gO8USsZR9D4WWVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzgU0QzVnqSxLbq9gnjucdh/IphW/KBLNnSsRWJtNxWWFsZRA8j+JnKI/WrqeOQNeoMdPbK/A/cH8PbqMX+GbPl+SyzBxZE1BmnU4cakgACD8WDYj+U6XxPdsCujcW+LeeYUslR8F21yRpUuDzF4tPaoGRNY1exES8TMMbi7r7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17fhAY3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17fhAY3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7857BC4CEED;
	Tue,  8 Jul 2025 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993125;
	bh=KErBfbcQ1e+l2uNFRCW+b3VQuf84gO8USsZR9D4WWVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17fhAY3UlvjJsqMvEKbtdiZITsE+VIOCeDNXF4mGh6CNOwmklVPmHB2g4Ca3t3IQ0
	 Jwf3IMcaHqPKphm738AwW4+5kQYNn+nTqFgjzGJhMs550SC9UVqUhc9NyuhUupn69c
	 NttGZJAvyrDe5XM6n6c6nLGEp5V8EZxAuTE2ljCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Duncan Ma <duncan.ma@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/232] drm/amd/display: Add more checks for DSC / HUBP ONO guarantees
Date: Tue,  8 Jul 2025 18:22:42 +0200
Message-ID: <20250708162245.780612251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 0d57dd1765d311111d9885346108c4deeae1deb4 ]

[WHY]
For non-zero DSC instances it's possible that the HUBP domain required
to drive it for sequential ONO ASICs isn't met, potentially causing
the logic to the tile to enter an undefined state leading to a system
hang.

[HOW]
Add more checks to ensure that the HUBP domain matching the DSC instance
is appropriately powered.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Duncan Ma <duncan.ma@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit da63df07112e5a9857a8d2aaa04255c4206754ec)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn35/dcn35_hwseq.c   | 35 ++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
index ca446e08f6a27..21aff7fa6375d 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -1019,8 +1019,22 @@ void dcn35_calc_blocks_to_gate(struct dc *dc, struct dc_state *context,
 		if (pipe_ctx->plane_res.dpp || pipe_ctx->stream_res.opp)
 			update_state->pg_pipe_res_update[PG_MPCC][pipe_ctx->plane_res.mpcc_inst] = false;
 
-		if (pipe_ctx->stream_res.dsc)
+		if (pipe_ctx->stream_res.dsc) {
 			update_state->pg_pipe_res_update[PG_DSC][pipe_ctx->stream_res.dsc->inst] = false;
+			if (dc->caps.sequential_ono) {
+				update_state->pg_pipe_res_update[PG_HUBP][pipe_ctx->stream_res.dsc->inst] = false;
+				update_state->pg_pipe_res_update[PG_DPP][pipe_ctx->stream_res.dsc->inst] = false;
+
+				/* All HUBP/DPP instances must be powered if the DSC inst != HUBP inst */
+				if (!pipe_ctx->top_pipe && pipe_ctx->plane_res.hubp &&
+				    pipe_ctx->plane_res.hubp->inst != pipe_ctx->stream_res.dsc->inst) {
+					for (j = 0; j < dc->res_pool->pipe_count; ++j) {
+						update_state->pg_pipe_res_update[PG_HUBP][j] = false;
+						update_state->pg_pipe_res_update[PG_DPP][j] = false;
+					}
+				}
+			}
+		}
 
 		if (pipe_ctx->stream_res.opp)
 			update_state->pg_pipe_res_update[PG_OPP][pipe_ctx->stream_res.opp->inst] = false;
@@ -1165,6 +1179,25 @@ void dcn35_calc_blocks_to_ungate(struct dc *dc, struct dc_state *context,
 		update_state->pg_pipe_res_update[PG_HDMISTREAM][0] = true;
 
 	if (dc->caps.sequential_ono) {
+		for (i = 0; i < dc->res_pool->pipe_count; i++) {
+			struct pipe_ctx *new_pipe = &context->res_ctx.pipe_ctx[i];
+
+			if (new_pipe->stream_res.dsc && !new_pipe->top_pipe &&
+			    update_state->pg_pipe_res_update[PG_DSC][new_pipe->stream_res.dsc->inst]) {
+				update_state->pg_pipe_res_update[PG_HUBP][new_pipe->stream_res.dsc->inst] = true;
+				update_state->pg_pipe_res_update[PG_DPP][new_pipe->stream_res.dsc->inst] = true;
+
+				/* All HUBP/DPP instances must be powered if the DSC inst != HUBP inst */
+				if (new_pipe->plane_res.hubp &&
+				    new_pipe->plane_res.hubp->inst != new_pipe->stream_res.dsc->inst) {
+					for (j = 0; j < dc->res_pool->pipe_count; ++j) {
+						update_state->pg_pipe_res_update[PG_HUBP][j] = true;
+						update_state->pg_pipe_res_update[PG_DPP][j] = true;
+					}
+				}
+			}
+		}
+
 		for (i = dc->res_pool->pipe_count - 1; i >= 0; i--) {
 			if (update_state->pg_pipe_res_update[PG_HUBP][i] &&
 			    update_state->pg_pipe_res_update[PG_DPP][i]) {
-- 
2.39.5



