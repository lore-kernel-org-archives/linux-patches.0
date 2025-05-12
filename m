Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460EC19049B;
	Mon, 12 May 2025 18:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073065; cv=none; b=E9LoOuhr/xvqiM9tgmybRLAjS774n3OFmxxL343ddPU/l1fHrO97qYtBhgzqyUyqtWPiXCwvtUUk6617rHx6A+GROpgg8ka7TBZhdV1ipXqVcqWwyYs8R39YEm0H8Q6i3bkeBC42gz1mB8BRlzs7gXyzfeRPeioc4cdGus26uhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073065; c=relaxed/simple;
	bh=I5az5wRzKhind2IBff+dV7VxU/cjoZ2Q7jYFeJQu+CM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T3O/8jqetvNugQqKDdRx6c4C8pUDGulnuTCVsWKKOBIzjLhWkPDz64KBZzoaWHsCEISMiVXS9wjSIY+xD2LMofkKQBwUPoW+kkizSOjOKYSvC3yT6OVKAl6P9R86cFJW0W2DTbCTZlfuuXv6K3MAm8tEs2z2XO0niJNu+yRCZWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSBCRxGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSBCRxGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14276C4CEE7;
	Mon, 12 May 2025 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073064;
	bh=I5az5wRzKhind2IBff+dV7VxU/cjoZ2Q7jYFeJQu+CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSBCRxGSu//FJAXYysiT/xkFHIV4XmMW+uQ5N0F9yvor4Sf2FkMC2YNaTs27Z2MRN
	 GsDQvakYhVzzUe0HCGr8wcry5PM1/yXTFFmP76nZBLfd/oq26RizMFOMUhMXynmAIV
	 pCBJjxF8MIeZimcyd2Fzs1PrEz1PIlffLks7NPLIizcunD2Lnk8tQtIuiRrNeTTFip
	 B+2FmmmS7vzfphSZXgLqrx4D5dS3FxEbTtc8BavhQPJfzKm/uGuP1vx1SNKubyEXxm
	 xnIEt24u25JuHDEgFKZNEfUYlwsn+sI5vNmN/jb6qWGT+fz09eIN/kDRL6rotONyhQ
	 9hnDs6WFm1EIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Austin Zheng <Austin.Zheng@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	austin.zheng@amd.com,
	jun.lei@amd.com,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	dillon.varone@amd.com,
	aurabindo.pillai@amd.com,
	alex.hung@amd.com,
	chenhuacai@kernel.org,
	jerry.zuo@amd.com,
	rostrows@amd.com,
	chris.park@amd.com,
	jiapeng.chong@linux.alibaba.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 14/15] drm/amd/display: Call FP Protect Before Mode Programming/Mode Support
Date: Mon, 12 May 2025 14:03:49 -0400
Message-Id: <20250512180352.437356-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180352.437356-1-sashal@kernel.org>
References: <20250512180352.437356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.6
Content-Transfer-Encoding: 8bit

From: Austin Zheng <Austin.Zheng@amd.com>

[ Upstream commit eba692ca3abca258b3214a6e4126afefad1822f0 ]

[Why]
Memory allocation occurs within dml21_validate() for adding phantom planes.
May cause kernel to be tainted due to usage of FP Start.

[How]
Move FP start from dml21_validate to before mode programming/mode support.
Calculations requiring floating point are all done within mode programming
or mode support.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Austin Zheng <Austin.Zheng@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fe3250f10819b411808ab9ae1d824c5fc9b59170)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index d6fd13f43c08f..e011dc56be828 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -220,7 +220,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	if (!result)
 		return false;
 
+	DC_FP_START();
 	result = dml2_build_mode_programming(mode_programming);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -263,7 +265,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
 	mode_support->dml2_instance = dml_init->dml2_instance;
 	dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
 	dml_ctx->v21.mode_programming.dml2_instance->scratch.build_mode_programming_locals.mode_programming_params.programming = dml_ctx->v21.mode_programming.programming;
+	DC_FP_START();
 	is_supported = dml2_check_mode_supported(mode_support);
+	DC_FP_END();
 	if (!is_supported)
 		return false;
 
@@ -274,16 +278,12 @@ bool dml21_validate(const struct dc *in_dc, struct dc_state *context, struct dml
 {
 	bool out = false;
 
-	DC_FP_START();
-
 	/* Use dml_validate_only for fast_validate path */
 	if (fast_validate)
 		out = dml21_check_mode_support(in_dc, context, dml_ctx);
 	else
 		out = dml21_mode_check_and_programming(in_dc, context, dml_ctx);
 
-	DC_FP_END();
-
 	return out;
 }
 
-- 
2.39.5

