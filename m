Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E79C433D6;
	Wed, 30 Nov 2022 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834270;
	bh=RYiL9DUddLCPgw9J51Sa4l2kovyOTMBBMqb6P5ZaWec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLfA3RiVNGIuGp+nBCFP8FBU4DFyFaSn8judcswlMnbhxYu8eyPNEt1UJtjKU0TjT
	 srmzm9mbIjfK0z1qC/UWw2vUhabxVG8SRQvyaXa2CF7suVxcJMkUGEUGyNSey83omx
	 okE9bTxDY4uvOP+GCmrFgvHZdlHwWYV1NkHj/EjI=
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
Subject: [PATCH 6.0 191/289] drm/amd/display: Fix calculation for cursor CAB allocation
Date: Wed, 30 Nov 2022 19:22:56 +0100
Message-Id: <20221130180548.453712583@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit 4d285241230676ba8b888701b89684b4e0360fcc ]

[Why]
The cursor size (in memory) is currently incorrectly calculated,
resulting not enough CAB being allocated for static screen cursor
in MALL refresh. This results in cursor image corruption.

[How]
Use cursor pitch instead of cursor width when calculating cursor size.
Update num cache lines calculation to use the result of the cursor size
calculation instead of manually recalculating again.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
index 84a20ce9bd36..bbc0bfbec6c4 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -284,8 +284,7 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 			using the max for calculation */
 
 		if (hubp->curs_attr.width > 0) {
-				// Round cursor width to next multiple of 64
-				cursor_size = (((hubp->curs_attr.width + 63) / 64) * 64) * hubp->curs_attr.height;
+				cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 				switch (pipe->stream->cursor_attributes.color_format) {
 				case CURSOR_MODE_MONO:
@@ -310,9 +309,9 @@ static uint32_t dcn32_calculate_cab_allocation(struct dc *dc, struct dc_state *c
 						cursor_size > 16384) {
 					/* cursor_num_mblk = CEILING(num_cursors*cursor_width*cursor_width*cursor_Bpe/mblk_bytes, 1)
 					 */
-					cache_lines_used += (((hubp->curs_attr.width * hubp->curs_attr.height * cursor_bpp +
-										DCN3_2_MALL_MBLK_SIZE_BYTES - 1) / DCN3_2_MALL_MBLK_SIZE_BYTES) *
-										DCN3_2_MALL_MBLK_SIZE_BYTES) / dc->caps.cache_line_size + 2;
+					cache_lines_used += (((cursor_size + DCN3_2_MALL_MBLK_SIZE_BYTES - 1) /
+							DCN3_2_MALL_MBLK_SIZE_BYTES) * DCN3_2_MALL_MBLK_SIZE_BYTES) /
+							dc->caps.cache_line_size + 2;
 				}
 				break;
 			}
@@ -730,10 +729,7 @@ void dcn32_update_mall_sel(struct dc *dc, struct dc_state *context)
 		struct hubp *hubp = pipe->plane_res.hubp;
 
 		if (pipe->stream && pipe->plane_state && hubp && hubp->funcs->hubp_update_mall_sel) {
-			//Round cursor width up to next multiple of 64
-			int cursor_width = ((hubp->curs_attr.width + 63) / 64) * 64;
-			int cursor_height = hubp->curs_attr.height;
-			int cursor_size = cursor_width * cursor_height;
+			int cursor_size = hubp->curs_attr.pitch * hubp->curs_attr.height;
 
 			switch (hubp->curs_attr.color_format) {
 			case CURSOR_MODE_MONO:
-- 
2.35.1



