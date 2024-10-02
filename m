Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B851D0494;
	Wed,  2 Oct 2024 13:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875760; cv=none; b=XRXnO7Rz/KLmsVwxmyejPqnbDPeQq82BZL/CIorm+gW5x0p6p0Ktu8eqG95oneid+ChM4WAveX5vn+d3qyeHadQGBrwXgMdOJe+SAJsukSgUgelIFzHGNtcjeA6GvG03uMEAh2zBW5Zl25SV4wdM48oxRjRXx2SXAFvbH/DOcqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875760; c=relaxed/simple;
	bh=HJDe7S2lJ47pbN8Rc3lZoh6kydAccWlty3M4guPtBA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMRHiz7GHSNnic8RZyH6I9wU3kFGCZILm4LOYVzMzdSCBlGUd6S1Z45thS0zFxJ7wc+JQKclyMD3hCBRamKjsWqtgnDYQBEqlNy0eAp79C5t/WyHkIgLXvnWnGmnYu6ub6Ihke6819lNSn+uIcxmYS/ZfwFRp2FsmCsk9VOgljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIEoliNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIEoliNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA608C4CEC5;
	Wed,  2 Oct 2024 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875760;
	bh=HJDe7S2lJ47pbN8Rc3lZoh6kydAccWlty3M4guPtBA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIEoliNrN5eikLDuniV/CzoRQC+AQdCS/5GI8yypXBh5ZisrgUPngw7VhR0e6jf2z
	 m1Fc0ZMH9Vn/Jx6IJDbXIvQs+iU8+OpIlb2Jdo8D1oyYS/9CmNiMOY4aAkdSwU0uhx
	 DU93koz1DzaxkKGbRsG36xv16IRQKGgqRfFp+VxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 211/695] drm/amd/display: Improve FAM control for DCN401
Date: Wed,  2 Oct 2024 14:53:29 +0200
Message-ID: <20241002125830.883223640@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

[ Upstream commit 17b6527dcfb3249401e037734ed3fd0f4752572f ]

[why & how]
When the commit 5324e2b205a2 ("drm/amd/display: Add driver support for
future FAMS versions") was introduced, it missed some of the FAM2 code.
This commit introduces the code that control the FAM enable and disable.

Fixes: 5324e2b205a2 ("drm/amd/display: Add driver support for future FAMS versions")
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
index 05d8f81daa064..f4eb28206bcb2 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -982,8 +982,19 @@ void dcn32_init_hw(struct dc *dc)
 		dc->caps.dmub_caps.gecc_enable = dc->ctx->dmub_srv->dmub->feature_caps.gecc_enable;
 		dc->caps.dmub_caps.mclk_sw = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver;
 
-		if (dc->ctx->dmub_srv->dmub->fw_version <
+		/* for DCN401 testing only */
+		dc->caps.dmub_caps.fams_ver = dc->ctx->dmub_srv->dmub->feature_caps.fw_assisted_mclk_switch_ver;
+		if (dc->caps.dmub_caps.fams_ver == 2) {
+			/* FAMS2 is enabled */
+			dc->debug.fams2_config.bits.enable &= true;
+		} else if (dc->ctx->dmub_srv->dmub->fw_version <
 				DMUB_FW_VERSION(7, 0, 35)) {
+			/* FAMS2 is disabled */
+			dc->debug.fams2_config.bits.enable = false;
+			if (dc->debug.using_dml2 && dc->res_pool->funcs->update_bw_bounding_box) {
+				/* update bounding box if FAMS2 disabled */
+				dc->res_pool->funcs->update_bw_bounding_box(dc, dc->clk_mgr->bw_params);
+			}
 			dc->debug.force_disable_subvp = true;
 			dc->debug.disable_fpo_optimizations = true;
 		}
-- 
2.43.0



