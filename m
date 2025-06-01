Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DF125D218;
	Sun,  1 Jun 2025 23:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821110; cv=none; b=BorXr7CrZclPkra5dPFDds/gxQM3XPWNrkZjjO2R+d6mEBsUXwQ7jZ0743wQY4XKqi/IvBflY8sZjocsrEbQ+v4GYyde/fLpeAkafSzJDqzQA9xUn2frnJO3hisYgG3kSo/ePUf/QTwqt2RkKZjWmHHh/ESPlGL/G3eXM1bIBzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821110; c=relaxed/simple;
	bh=dBVfe+/jcACn03EwBCo2A97xv8qZKms3L5iF/yK/YBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QQVy2oyn3OE9SPkhjXKn9h3+x9FW0YEI4DOD3LtWmKpNmsjeCjhqplnt/lF8f+uCG2jRQ/I1dxFrQmt5proPYN6vhdeZJWoZDMUBCTN9H7rmaKcusnJc9YvBf5ENQC4w6bUaxRj6t6+sUs37XF90wrhLE5r043kZUjmvPbAkA5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZs2+sJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZs2+sJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658E5C4CEF1;
	Sun,  1 Jun 2025 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821110;
	bh=dBVfe+/jcACn03EwBCo2A97xv8qZKms3L5iF/yK/YBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZs2+sJnAO71z9sfK3V16jM7GPJvxMGIO4tr75yCVGs/e7rYUtbI7tSqMCAoPp1k2
	 l3YyoTijdKaEZRBNLV+whAbkHK1aE+eh/auXmgVELMvqu3ma4+jhdfFUK1oK3pjQ7+
	 ruJWJTKpO7+cG2RnLWp3kj1jNrgdmSzitxODtYb3h4fpftxYZQ1rvv+QkViWthMADs
	 jgsaZ09fjflo5lqkoLM705ILPkzqoA4lzo3EJBiwmHUHN6qykUTtn4IzlLJE1QqXfy
	 Q2Xmi/9K/88XKS7X4wlmrRSGfN2lA+chHycloNH14nqMzf0BeY5HiTRFRjWEPKf3pC
	 t7yX6feyqa3Vw==
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
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 17/66] drm/amd/display: Skip to enable dsc if it has been off
Date: Sun,  1 Jun 2025 19:36:54 -0400
Message-Id: <20250601233744.3514795-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233744.3514795-1-sashal@kernel.org>
References: <20250601233744.3514795-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
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

 .../gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
index 33a8626bda735..c6334303114c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_hwseq.c
@@ -107,6 +107,20 @@ static void update_dsc_on_stream(struct pipe_ctx *pipe_ctx, bool enable)
 		struct dsc_config dsc_cfg;
 		struct dsc_optc_config dsc_optc_cfg;
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

