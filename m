Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F32110E;
	Tue, 27 May 2025 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365920; cv=none; b=fioRE8z/AtXfwa0UjAWj1lGTLot71yEPnwj5TtH0H37HO3J72IgvdF2gk7tnxFDLdMLipRjNUi6KEnaAGjggopU88Vst4wnqmNdQ0ciDxH4UNGYyPKvhPVr7EefkbTEc3RyRZtP5wCTk4WFFMljKwiaGUmgzLwZzEO/JRO0piFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365920; c=relaxed/simple;
	bh=f5N3Ntd4Rw41ygKgZm3vKQk17svRiIFOmyCjAboS2nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1DHHqTAcny23lhCnB+XBda5OiFsRc2Fz1EUToewfd7zw5gioD/N4G/RNxPdjPYhsOexS0r1RtKlP5JJwdfTu82QYdq8doqfCJMrbpRKh2Cj1iMjQCN3IXKbMHTXZqbinhcAe11cGSrvNnt7YO/emE4hiIsPKFLcgnonCNBlYWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvo2pMcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvo2pMcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BF2C4CEE9;
	Tue, 27 May 2025 17:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365920;
	bh=f5N3Ntd4Rw41ygKgZm3vKQk17svRiIFOmyCjAboS2nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvo2pMcBgnWgGZ791YLoI+FwPgjg39e+HGT3JVdxNR96w6HAJkr+jUrqgt+498myy
	 LIcjVcO531vfH022KQlp+3XW9Uq871TWSrEkOkHSVxptnGQgaxXZFDkeN2mqnPrxpU
	 hBqytRfTL4vbJnyDze8WmaP+ugG0bClNd3h6isT0=
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
Subject: [PATCH 6.12 532/626] drm/amd/display: Call FP Protect Before Mode Programming/Mode Support
Date: Tue, 27 May 2025 18:27:05 +0200
Message-ID: <20250527162506.608854881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index e3e4f40bd4123..dcbe327209d5d 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -221,7 +221,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	if (!result)
 		return false;
 
+	DC_FP_START();
 	result = dml2_build_mode_programming(mode_programming);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -271,7 +273,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
 	mode_support->dml2_instance = dml_init->dml2_instance;
 	dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
 	dml_ctx->v21.mode_programming.dml2_instance->scratch.build_mode_programming_locals.mode_programming_params.programming = dml_ctx->v21.mode_programming.programming;
+	DC_FP_START();
 	is_supported = dml2_check_mode_supported(mode_support);
+	DC_FP_END();
 	if (!is_supported)
 		return false;
 
@@ -282,16 +286,12 @@ bool dml21_validate(const struct dc *in_dc, struct dc_state *context, struct dml
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



