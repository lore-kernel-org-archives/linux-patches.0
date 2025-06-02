Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6023D285;
	Mon,  2 Jun 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873569; cv=none; b=IKwYUNZSVuFs53WcEDZkqJNW+oYBJSOF6rNpzvIY6+G9Y69fn/vml1wSQctDw5BUG0nIRfOQbwt3+VXBsshpqZOPvkQTiybPICQXIHUVoB61bFQyvMlEdb23W5PVsnxL4BN3moogiVtT0Q7UVkvn4291pIftNCzJHYFlkbjKQmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873569; c=relaxed/simple;
	bh=KxmkDQTuVhGuZUd+mVr7SBLAAyt+VXe43E5ju/npiuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6w6vE3+3bxsGygga7oHUHh/oN8mkF4BbBX8MHPQylXMWnKndGpBz2SOILfOXYqzx94HbgSShfYTcYWluvQqa4C28A/rQIP7eFQJo8PkXX+P/AAM258oIsBytJJ0/uwFDF7a4+M/hsDI8Il9MrOtmdCXS+ILvKnzcgqcfLTkQ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNmA/UlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNmA/UlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65050C4CEEB;
	Mon,  2 Jun 2025 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873568;
	bh=KxmkDQTuVhGuZUd+mVr7SBLAAyt+VXe43E5ju/npiuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNmA/UlQfPwjxHAw98dP1GwBQKzc6jEXIWsdeJ5MpgNStpzD7GimokHdWfJGfT/+4
	 k/lKizjU46qjPEjVZaiNZWh+53DPaFaoR7rDEQbWAZzwvCWX3mgyrTFHtAeJbiByC3
	 Izh9fy6aJ6I1ztm02mrjz44jV2qJwAnMQEsKO6AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samson Tam <samson.tam@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Zaeem Mohamed <zaeem.mohamed@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 183/444] drm/amd/display: handle max_downscale_src_width fail check
Date: Mon,  2 Jun 2025 15:44:07 +0200
Message-ID: <20250602134348.322030806@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

[ Upstream commit 02a940da2ccc0cc0299811379580852b405a0ea2 ]

[WHY]
If max_downscale_src_width check fails, we exit early from TAP calculation and left a NULL
value to the scaling data structure to cause the zero divide in the DML validation.

[HOW]
Call set default TAP calculation before early exit in get_optimal_number_of_taps due to
max downscale limit exceed.

Reviewed-by: Samson Tam <samson.tam@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
index 50dc834046446..4ce45f1bdac0f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
@@ -392,11 +392,6 @@ bool dpp3_get_optimal_number_of_taps(
 	int min_taps_y, min_taps_c;
 	enum lb_memory_config lb_config;
 
-	if (scl_data->viewport.width > scl_data->h_active &&
-		dpp->ctx->dc->debug.max_downscale_src_width != 0 &&
-		scl_data->viewport.width > dpp->ctx->dc->debug.max_downscale_src_width)
-		return false;
-
 	/*
 	 * Set default taps if none are provided
 	 * From programming guide: taps = min{ ceil(2*H_RATIO,1), 8} for downscaling
@@ -434,6 +429,12 @@ bool dpp3_get_optimal_number_of_taps(
 	else
 		scl_data->taps.h_taps_c = in_taps->h_taps_c;
 
+	// Avoid null data in the scl data with this early return, proceed non-adaptive calcualtion first
+	if (scl_data->viewport.width > scl_data->h_active &&
+		dpp->ctx->dc->debug.max_downscale_src_width != 0 &&
+		scl_data->viewport.width > dpp->ctx->dc->debug.max_downscale_src_width)
+		return false;
+
 	/*Ensure we can support the requested number of vtaps*/
 	min_taps_y = dc_fixpt_ceil(scl_data->ratios.vert);
 	min_taps_c = dc_fixpt_ceil(scl_data->ratios.vert_c);
-- 
2.39.5



