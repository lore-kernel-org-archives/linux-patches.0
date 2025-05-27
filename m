Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BC6263F5E;
	Tue, 27 May 2025 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368444; cv=none; b=idECqKFxktE7NgClOT9dxmXso2NRsi4cvNvHtqNdxlMPmrk/tbn+8ApvDHp/ilMG4PtgccN83gtwQXjhllCktJyBiwFV7VV3EWWbceXraUwgLnxU3AHOrXvT/MQJmCHLDArAX6OXG8ewQNJRT1gl6uluRUuvPHv0GB+5D6fIwBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368444; c=relaxed/simple;
	bh=la1wxIaqLgr6ZbfBABYoja19LSWlggIcZtVoATLywhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teTme4J4XLQWSrsTt1v0f4P1rN67ImP8UQrMXnsagQAj9+1x+ub5zGk+qpPGeVNRFXuqZQ+Tab2ZYaMOPnaH+LEvtP0OWftC8LczFAF9+f29EHXbhizeTEGnWngCXGvA7UzShs+sg9/Cdj+08V0YbTJzQTuqNUuPTuLhW2LdbhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x75bDduU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x75bDduU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B1CC4CEE9;
	Tue, 27 May 2025 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368443;
	bh=la1wxIaqLgr6ZbfBABYoja19LSWlggIcZtVoATLywhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x75bDduU9EzghQ+ZOJaFfZl6UAiFbODpLlx0QmiEkbVvxNBw4TDe9Hx8TzLU0Q1qd
	 WVIM8Tp+oDNwaqudBH2tCR+4IUNGM7lnW+/DKsz9rFp/dd8u/kBsYUzEAS6XP4r75K
	 Tlal0EEu691P7JtddjuG7gL0ezgF+gnNxPywrVi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 679/783] drm/amd/display: Call FP Protect Before Mode Programming/Mode Support
Date: Tue, 27 May 2025 18:27:56 +0200
Message-ID: <20250527162540.778925786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 5d16f36ec95c8..ed6584535e898 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -234,7 +234,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	if (!result)
 		return false;
 
+	DC_FP_START();
 	result = dml2_build_mode_programming(mode_programming);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -277,7 +279,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
 	mode_support->dml2_instance = dml_init->dml2_instance;
 	dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
 	dml_ctx->v21.mode_programming.dml2_instance->scratch.build_mode_programming_locals.mode_programming_params.programming = dml_ctx->v21.mode_programming.programming;
+	DC_FP_START();
 	is_supported = dml2_check_mode_supported(mode_support);
+	DC_FP_END();
 	if (!is_supported)
 		return false;
 
@@ -288,16 +292,12 @@ bool dml21_validate(const struct dc *in_dc, struct dc_state *context, struct dml
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



