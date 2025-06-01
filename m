Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6296628D839;
	Sun,  1 Jun 2025 23:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820660; cv=none; b=j5RvXp3iVA3/577bLw5J31debg4jRGspMW0oUFrT6Sb4kqWtklH9+kzC/vQUHMgG30OmA+xYzSpI6Ls7emz1Rz49gtjCvEP4uv3E+S8lZ0W10VZNjeKb8FkhM2XiyGMEBuF/QjDYrIAplEfha03I1iN6BRRHjiGhIdDPYy+6Isg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820660; c=relaxed/simple;
	bh=VgXaw0opX4N8DOTZJP/W6frQFN+qpfKXQt25PrW05WI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5fy4tVivLi7uPoiJLKGbpTxIhbFrJHzaaEVY2kXVNoh3vhUHsbsiMafGtysvHe8OXEN3fqvQRB2f4Z4VnlxcMBvvNKnn+DxHXFvOQv1D+YxF2Gfgf35Og7VZNF/zuzsKdEFg6nguNqhy3DDO/ciB721w5zEjsYOi2YljTLeIS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6S1tKJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6S1tKJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDD8C4CEE7;
	Sun,  1 Jun 2025 23:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820660;
	bh=VgXaw0opX4N8DOTZJP/W6frQFN+qpfKXQt25PrW05WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6S1tKJigPyVxUDJKt7VjJYF809Be/5GKTexb7y4RMdmlb8JkFTso+Rg3QqaTsj1B
	 xPmBMZwjBW/UhzsqBR6q0V7BhJ4tDY75aRqp6h0STp3J/og6kY2u+Lq2iUtzVogBn1
	 DlfaANvVoqlHfO6aTXmPIL1MIqaWVME/s3PdbhOEAI40bavN1lD8EebLn/Bpf2oA4m
	 2tKnLWY2NMjoX/aAU/rmmMno+Vi+PHuyEsEMv/XyQwwQ/mrUsXy2XT2468GR0rr/vx
	 7dpXly6/e7VkAT3OIbOwaXeqd8flA1xym+HA0pH3ETV8+1jYmynFdH04wmZ+z7P85B
	 xVY25WdLMmAdA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paul Hsieh <Paul.Hsieh@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	nicholas.kazlauskas@amd.com,
	rodrigo.siqueira@amd.com,
	alvin.lee2@amd.com,
	Fudong.Wang@amd.com,
	v.shevtsov@maxima.ru,
	george.shen@amd.com,
	yi-lchen@amd.com,
	Zhongwei.Zhang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 031/102] drm/amd/display: Skip to enable dsc if it has been off
Date: Sun,  1 Jun 2025 19:28:23 -0400
Message-Id: <20250601232937.3510379-31-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Hsieh <Paul.Hsieh@amd.com>

[ Upstream commit 8b8a602c985e99074fa1d5233cd224b7bcfb9df2 ]

[Why]
It makes DSC enable when we commit the stream which need
keep power off.And then it will skip to disable DSC if
pipe reset at this situation as power has been off. It may
cause the DSC unexpected enable on the pipe with the
next new stream which doesn't support DSC.

[HOW]
Check the DSC used on current pipe status when update stream.
Skip to enable if it has been off. The operation enable
DSC should happen when set power on.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Paul Hsieh <Paul.Hsieh@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## **YES** This commit should be backported to stable kernel trees based
on my comprehensive analysis: ### **Analysis Summary:** **1. Bug
Description and Impact:** The commit fixes a critical DSC (Display
Stream Compression) state management bug where: - DSC gets incorrectly
enabled when committing a stream that should keep power off - When a
pipe reset occurs with power already off, DSC disable is skipped - This
causes DSC to be unexpectedly enabled on subsequent streams that don't
support DSC - This can lead to display corruption or system instability
for users with affected AMD GPUs **2. Code Changes Analysis:** The fix
adds robust state checking in
`drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c:72-108` by:
```c struct dcn_dsc_state dsc_state = {0}; if (!dsc) { DC_LOG_DSC("DSC
is NULL for tg instance %d:", pipe_ctx->stream_res.tg->inst); return; }
if (dsc->funcs->dsc_read_state) { dsc->funcs->dsc_read_state(dsc,
&dsc_state); if (!dsc_state.dsc_fw_en) { DC_LOG_DSC("DSC has been
disabled for tg instance %d:", pipe_ctx->stream_res.tg->inst); return; }
} ``` This adds a critical safety check that: - Reads the current DSC
hardware state before attempting to enable it - Checks if DSC is already
disabled (`!dsc_state.dsc_fw_en`) - Returns early if DSC is already off,
preventing incorrect state transitions **3. Consistency with Similar
Fixes:** Historical analysis shows this exact fix pattern was already
applied to: - **dcn32** in commit `4bdc5b504af7` (with Cc:
stable@vger.kernel.org) - **dcn35** in the same commit - This commit
extends the fix to **dcn314** hardware Similar Commit #1 in the examples
shows a nearly identical fix that received **"Backport Status: YES"**
and was explicitly marked for stable (`Cc: stable@vger.kernel.org`).
**4. Backport Criteria Assessment:** - ✅ **Fixes important user-
affecting bug**: Display corruption/instability - ✅ **Small and
contained change**: Only 14 lines, minimal scope - ✅ **No architectural
changes**: Pure defensive programming addition - ✅ **Minimal regression
risk**: Only adds safety checks, no behavior change for correct flows -
✅ **Subsystem confined**: Limited to AMD display driver dcn314 path - ✅
**Follows established pattern**: Identical fix already applied to
related hardware generations - ✅ **Clear maintainer support**: Previous
similar commits included stable tree marking **5. Hardware Impact:**
This affects DCN 3.14 generation AMD GPUs, which are used in production
systems where display stability is critical for users. The fix follows
the exact same defensive programming pattern already proven safe and
effective in dcn32/dcn35, making it a low-risk, high-value backport
candidate that addresses a real user-impacting display bug.

 .../drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
index be26c925fdfa1..e68f21fd5f0fb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn314/dcn314_hwseq.c
@@ -84,6 +84,20 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		struct dsc_config dsc_cfg;
 		struct dsc_optc_config dsc_optc_cfg = {0};
 		enum optc_dsc_mode optc_dsc_mode;
+		struct dcn_dsc_state dsc_state = {0};
+
+		if (!dsc) {
+			DC_LOG_DSC("DSC is NULL for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+			return;
+		}
+
+		if (dsc->funcs->dsc_read_state) {
+			dsc->funcs->dsc_read_state(dsc, &dsc_state);
+			if (!dsc_state.dsc_fw_en) {
+				DC_LOG_DSC("DSC has been disabled for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+				return;
+			}
+		}
 
 		/* Enable DSC hw block */
 		dsc_cfg.pic_width = (stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right) / opp_cnt;
-- 
2.39.5

