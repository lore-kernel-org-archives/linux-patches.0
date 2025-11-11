Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1249B1D86FF;
	Tue, 11 Nov 2025 01:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824731; cv=none; b=rT+jqBfvkdsd7dU9HOY40lGXePmWjg6AEFD7SLR6/8XXLtl8/nVula7jaCg7Q3tqYqRwfbl+Qs7hnl5WzXCwEumpoiskhvT/f2ooa6Iicexzfqzppi6uYtCCOHh+lPzZlSixF1nvf8XyenmiOcScjNBDl0mbdauzcOA3TE7gTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824731; c=relaxed/simple;
	bh=NmOsgLiDgu8G5787qnntXzk+xC3ufACIxVlaHuPQm20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXIzy9uNNDAbFHoTkrrS3OJohtEk1vB+vAN4EnfM9MfWjg18W2Xb5muLocqNBJ3OsL8TmOCMhLGrVHMkTmY2y33ER6dlTHPOn7Zj8bmGzXs1feqw4u9GhtON9IvGpKSvp/pOMSZgtAmVdjB7CynVzr33JctYxF/lTg3XHPvY/SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnsn8130; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnsn8130"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE4C4CEFB;
	Tue, 11 Nov 2025 01:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824730;
	bh=NmOsgLiDgu8G5787qnntXzk+xC3ufACIxVlaHuPQm20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnsn8130YDhuNhy9y9O/dLDuZ9O5lkCOsOCqQUQTnCoFF08Zbvg+Koh9zzoz0vAqZ
	 vZBdxd0CmBrgEWXKxhXDbAYhKGikTdqL+sbLAt5+B9eNN/oqnVZbl/3croZRsdHHOB
	 Y/8sw5GuEPk4mxqUDwg3AnCeWKnzXPDtC+tS7OHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asiacn <710187964@qq.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 559/849] drm/amd/display/dml2: Guard dml21_map_dc_state_into_dml_display_cfg with DC_FP_START
Date: Tue, 11 Nov 2025 09:42:09 +0900
Message-ID: <20251111004549.926540023@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit c97a7dccb3ed680031011cfc1457506e6de49c9a ]

dml21_map_dc_state_into_dml_display_cfg calls (the call is usually
inlined by the compiler) populate_dml21_surface_config_from_plane_state
and populate_dml21_plane_config_from_plane_state which may use FPU.  In
a x86-64 build:

    $ objdump --disassemble=dml21_map_dc_state_into_dml_display_cfg \
    > drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_translation_helper.o |
    > grep %xmm -c
    63

Thus it needs to be guarded with DC_FP_START.  But we must note that the
current code quality of the in-kernel FPU use in AMD dml2 is very much
problematic: we are actually calling DC_FP_START in dml21_wrapper.c
here, and this translation unit is built with CC_FLAGS_FPU.  Strictly
speaking this does not make any sense: with CC_FLAGS_FPU the compiler is
allowed to generate FPU uses anywhere in the translated code, perhaps
out of the DC_FP_START guard.  This problematic pattern also occurs in
at least dml2_wrapper.c, dcn35_fpu.c, and dcn351_fpu.c.  Thus we really
need a careful audit and refactor for the in-kernel FPU uses, and this
patch is simply whacking a mole.  However per the reporter, whacking
this mole is enough to make a 9060XT "just work."

Reported-by: Asiacn <710187964@qq.com>
Closes: https://github.com/loongson-community/discussions/issues/102
Tested-by: Asiacn <710187964@qq.com>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index 03de3cf06ae59..059ede6ff2561 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -224,7 +224,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	dml_ctx->config.svp_pstate.callbacks.release_phantom_streams_and_planes(in_dc, context);
 
 	/* Populate stream, plane mappings and other fields in display config. */
+	DC_FP_START();
 	result = dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -279,7 +281,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
 	dml_ctx->config.svp_pstate.callbacks.release_phantom_streams_and_planes(in_dc, context);
 
 	mode_support->dml2_instance = dml_init->dml2_instance;
+	DC_FP_START();
 	dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
+	DC_FP_END();
 	dml_ctx->v21.mode_programming.dml2_instance->scratch.build_mode_programming_locals.mode_programming_params.programming = dml_ctx->v21.mode_programming.programming;
 	DC_FP_START();
 	is_supported = dml2_check_mode_supported(mode_support);
-- 
2.51.0



