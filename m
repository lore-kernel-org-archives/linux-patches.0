Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29A3EBF2C;
	Sat, 14 Feb 2026 01:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030999; cv=none; b=d41hViBq03/hFOnHzwAv1jJPg13nY2XugsNYwgaZwb52JAqK5Mv9bvuxu/B23Fbbf+X7H7sPlL4OqVVbpWq6M09OeFcNfVLORmekp3XcDHzk64C0LHgBBDYuIXhXEg1xe77SfPwxosuVwiCIp54+i1oNoXtsrrhCbj9ZdIDUc2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030999; c=relaxed/simple;
	bh=qRQFKAhBVdXYrFAqOWRohVFkJKasL7sKeBlZ5vfvO3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZsaPNYMfYiXAEcNiVzHqlKTI0OTa7F3U2nDIyAOAsz+QFaMvSEr3ff0Dwm+yaC7Ab8OLU0oqAef8oWod6JLCmoO39jZS8q+9INTBPH5WDpSW4QxnKc46emQ/ITebdWtSMqZe1QEe+jmSb3DDWKjS3DH/DuA98hWUytbRejLMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQF9W7UM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQF9W7UM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C812C116C6;
	Sat, 14 Feb 2026 01:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030998;
	bh=qRQFKAhBVdXYrFAqOWRohVFkJKasL7sKeBlZ5vfvO3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQF9W7UMxcrgHksEPhTVEBlKImiphrvrnxJ6mVHgSm+HgdNkxmk6CdEU5QchgFI97
	 CNTsr9ZpbTpkDssKqv/NPMLa5pmiPtQrPZcK/dIGjyfXimnwjplI1/o6i2aCT5HSlG
	 sv7GPS5nx8ozwyvD08/wKfRpDZkmOMNEY2RHPWakEti/+5lU8nxviaHQeInNbCEyh4
	 x90SaG00uEj+xILqA1Pmwi2Dh+8RWBhN22bYsdjXjT2HNhbEon+05x//UYek0ez2Ih
	 Q6ptH854e7+/Im5AhkguZwgPxwn2VpF+IuhWq9p3QJa1fay1xFsfHdu1AylgqwRUuB
	 OZJyqWzH5zJSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhongwei <Zhongwei.Zhang@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Dillon.Varone@amd.com,
	alvin.lee2@amd.com,
	alex.hung@amd.com,
	nicholas.kazlauskas@amd.com,
	mwen@igalia.com,
	Ausef.Yousof@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	Charlene.Liu@amd.com,
	Yihan.Zhu@amd.com,
	danny.wang@amd.com
Subject: [PATCH AUTOSEL 6.19-6.12] drm/amd/display: avoid dig reg access timeout on usb4 link training fail
Date: Fri, 13 Feb 2026 19:58:18 -0500
Message-ID: <20260214010245.3671907-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhongwei <Zhongwei.Zhang@amd.com>

[ Upstream commit 15b1d7b77e9836ff4184093163174a1ef28bbdd7 ]

[Why]
When usb4 link training fails, the dpia sym clock will be disabled and SYMCLK
source should be changed back to phy clock. In enable_streams, it is
assumed that link training succeeded and will switch from refclk to
phy clock. But phy clk here might not be on. Dig reg access timeout
will occur.

[How]
When enable_stream is hit, check if link training failed for usb4.
If it did, fall back to the ref clock to avoid reg access timeout.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Zhongwei <Zhongwei.Zhang@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is widely used across the DC codebase — no dependency concerns.

### 8. SUMMARY

**What it fixes:** A register access timeout that occurs when USB4
(DPIA) link training fails. The timeout happens because the code
unconditionally enables the symclk (which requires phy clock to be
running), but when link training failed, the phy clock is off. This
causes the register access to hang/timeout.

**How it fixes it:** By adding a check that mirrors the existing
128b/132b signal handling — when link training has failed (detected by
LINK_RATE_UNKNOWN, endpoint type is USB4 DPIA, and link is not active),
it disables the symclk instead of enabling it, falling back to the
reference clock. Additionally adds a NULL check on `link_enc`.

**Meets stable criteria:**
- Obviously correct: mirrors existing pattern for 128b/132b, reviewed
  and tested by AMD team
- Fixes a real bug: register access timeout causing display failures
- Small and contained: ~15 lines in one function in one file
- No new features: purely defensive error handling
- Low regression risk: only changes behavior in the failure path

**YES** — This is a well-contained bug fix for a real hardware timeout
issue affecting USB4 display connections. It's small, well-reviewed,
well-tested, follows existing patterns in the code, and has very low
regression risk.

**YES**

 .../gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c  | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index c8ff8ae85a030..517d4c08d34c4 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3058,9 +3058,17 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
 		}
 	} else {
-		if (dccg->funcs->enable_symclk_se)
-			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
+		if (dccg->funcs->enable_symclk_se && link_enc) {
+			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA
+				&& link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN
+				&& !link->link_status.link_active) {
+				if (dccg->funcs->disable_symclk_se)
+					dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,
 						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
+			} else
+				dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
+						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
+		}
 	}
 
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div)
-- 
2.51.0

