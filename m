Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488EF339709;
	Tue, 11 Nov 2025 01:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823989; cv=none; b=Zpo11cUyjfeVLkYA0kNAAkNOE8YMkIVD8r7H5qpynh4YaNimakuQnRpD/Pqogn9pnbYac5X8sZmsIH35Up0oXRPWq2s9Gw6+bFQYxZ6X6GZvw3jEMDNI6FsbgBvY36U8Ia4DuvOjhI9Zot2hQrHh8aL6ik7f5+Ij5E5Erh4YhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823989; c=relaxed/simple;
	bh=Y+wuqkgA8WKN7acxPNUEMopGbaHzyVr47FhWa7+QN1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co79jkOH9AzfvaeLLULydyR0PjvfVpuDmtLRESS5ud6MOfeXB3qKow+6hFLCv8f9wAakd73Ra5z/HlJg/H9CFHtJZ0xPGFgXhb+LCRUZHOvsAUxlkyMBSUjkacL+jSW+8JXlbMAI0UrpjAiNA494M9a4BThpuF1ceQHIPsKVmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWMlk8Fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWMlk8Fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E47C113D0;
	Tue, 11 Nov 2025 01:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823989;
	bh=Y+wuqkgA8WKN7acxPNUEMopGbaHzyVr47FhWa7+QN1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWMlk8FwlH6fdxa8w8Mfgms+IAwQfUZ5MWgu/w2M/M3kZt2iN3LPLkVeUjNsBxvPU
	 kIFtsvQQF/EAsdh7Xc/yNFKy/2vmYy+pgzX80p3jmtSioNbUowt2ZuaMq6z8dCFqDo
	 8n13PdZfC6/lilxiRrFhePX3nAVtvvbAqZjj4x0c=
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
Subject: [PATCH 6.12 366/565] drm/amd/display/dml2: Guard dml21_map_dc_state_into_dml_display_cfg with DC_FP_START
Date: Tue, 11 Nov 2025 09:43:42 +0900
Message-ID: <20251111004535.102888068@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dcbe327209d5d..20c643ab756eb 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -217,7 +217,9 @@ static bool dml21_mode_check_and_programming(const struct dc *in_dc, struct dc_s
 	dml_ctx->config.svp_pstate.callbacks.release_phantom_streams_and_planes(in_dc, context);
 
 	/* Populate stream, plane mappings and other fields in display config. */
+	DC_FP_START();
 	result = dml21_map_dc_state_into_dml_display_cfg(in_dc, context, dml_ctx);
+	DC_FP_END();
 	if (!result)
 		return false;
 
@@ -271,7 +273,9 @@ static bool dml21_check_mode_support(const struct dc *in_dc, struct dc_state *co
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



