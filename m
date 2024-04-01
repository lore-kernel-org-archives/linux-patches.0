Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AAA45BE4;
	Mon,  1 Apr 2024 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988538; cv=none; b=lL0a/FpPQbupDi1V1otLY1wITKbuWKcj0OJL8WK3qJg39dC7Xs0HKk/3Y9kAHoSOFyAC7jPcmU25i1eOCK6KkmrcuGI/y3GBakBgLIwbJlqVBbxb5MKNYvRpsNcchSOq1cyY3a99pJCFQDdkiXKBHPTsG7as0EC4GtZlbweK97M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988538; c=relaxed/simple;
	bh=w/mPsP7cohAyDfnQISVccRR/4wQNiXvQQqlkCCadO/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcVQ8byP7wJiX464eNSPdLp6Ei3z7UXZEnnwyc/F9mpppENttVh4ne48CKT4zXePUlTHZ57mLnZeDPFhSbJQYbIg7Gie/oo1hFpNlea+T1sMeAZdQfkK5Lw7hj7gG9EhRAkhAXD4TXMH2ZcHGvReZVgD/coDN1DnhGt7S+kveo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjX9EEdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjX9EEdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E706C433C7;
	Mon,  1 Apr 2024 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988538;
	bh=w/mPsP7cohAyDfnQISVccRR/4wQNiXvQQqlkCCadO/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjX9EEdVX/bVR8ZXOVA5yFt9oCJr06+TmBhZf0hb5LM4kdy6UB4dEhoKSfJEM1qlt
	 QKnP9AVnnm//Livu148tmGyTkIbE9I0dsOEh1j3G80G1Hlauq71tsbHR5kGY2KWmMI
	 Po9xsx5bmiGCC28cYJQ1EjurWvX2FnYZB4dD/pAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 214/432] drm/amd/display: Add dml2 copy functions
Date: Mon,  1 Apr 2024 17:43:21 +0200
Message-ID: <20240401152559.524207138@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit abd26a3252cbd1a3ae4e46d37596d176fe50b41a ]

Add function to handle deep copying dml2 context.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4f5b8d78ca43 ("drm/amd/display: Init DPPCLK from SMU on dcn32")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 15 +++-------
 .../drm/amd/display/dc/dml2/dml2_wrapper.c    | 29 ++++++++++++++++++-
 .../drm/amd/display/dc/dml2/dml2_wrapper.h    |  4 +++
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 537f71c19b806..dab26d7e4d52a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2258,23 +2258,16 @@ struct dc_state *dc_copy_state(struct dc_state *src_ctx)
 {
 	int i, j;
 	struct dc_state *new_ctx = kvmalloc(sizeof(struct dc_state), GFP_KERNEL);
-#ifdef CONFIG_DRM_AMD_DC_FP
-	struct dml2_context *dml2 =  NULL;
-#endif
 
 	if (!new_ctx)
 		return NULL;
 	memcpy(new_ctx, src_ctx, sizeof(struct dc_state));
 
 #ifdef CONFIG_DRM_AMD_DC_FP
-	if (new_ctx->bw_ctx.dml2) {
-		dml2 = kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
-		if (!dml2)
-			return NULL;
-
-		memcpy(dml2, src_ctx->bw_ctx.dml2, sizeof(struct dml2_context));
-		new_ctx->bw_ctx.dml2 = dml2;
-	}
+	if (new_ctx->bw_ctx.dml2 && !dml2_create_copy(&new_ctx->bw_ctx.dml2, src_ctx->bw_ctx.dml2)) {
+		dc_release_state(new_ctx);
+		return NULL;
+ 	}
 #endif
 
 	for (i = 0; i < MAX_PIPES; i++) {
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
index c62b61ac45d27..8f34df00055c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.c
@@ -696,10 +696,15 @@ bool dml2_validate(const struct dc *in_dc, struct dc_state *context, bool fast_v
 	return out;
 }
 
+static inline struct dml2_context *dml2_allocate_memory(void)
+{
+	return (struct dml2_context *) kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+}
+
 bool dml2_create(const struct dc *in_dc, const struct dml2_configuration_options *config, struct dml2_context **dml2)
 {
 	// Allocate Mode Lib Ctx
-	*dml2 = (struct dml2_context *) kzalloc(sizeof(struct dml2_context), GFP_KERNEL);
+	*dml2 = dml2_allocate_memory();
 
 	if (!(*dml2))
 		return false;
@@ -750,3 +755,25 @@ void dml2_extract_dram_and_fclk_change_support(struct dml2_context *dml2,
 	*fclk_change_support = (unsigned int) dml2->v20.dml_core_ctx.ms.support.FCLKChangeSupport[0];
 	*dram_clk_change_support = (unsigned int) dml2->v20.dml_core_ctx.ms.support.DRAMClockChangeSupport[0];
 }
+
+void dml2_copy(struct dml2_context *dst_dml2,
+	struct dml2_context *src_dml2)
+{
+	/* copy Mode Lib Ctx */
+	memcpy(dst_dml2, src_dml2, sizeof(struct dml2_context));
+}
+
+bool dml2_create_copy(struct dml2_context **dst_dml2,
+	struct dml2_context *src_dml2)
+{
+	/* Allocate Mode Lib Ctx */
+	*dst_dml2 = dml2_allocate_memory();
+
+	if (!(*dst_dml2))
+		return false;
+
+	/* copy Mode Lib Ctx */
+	dml2_copy(*dst_dml2, src_dml2);
+
+	return true;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
index fe15baa4bf094..0de6886969c69 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml2_wrapper.h
@@ -191,6 +191,10 @@ bool dml2_create(const struct dc *in_dc,
 				 struct dml2_context **dml2);
 
 void dml2_destroy(struct dml2_context *dml2);
+void dml2_copy(struct dml2_context *dst_dml2,
+	struct dml2_context *src_dml2);
+bool dml2_create_copy(struct dml2_context **dst_dml2,
+	struct dml2_context *src_dml2);
 
 /*
  * dml2_validate - Determines if a display configuration is supported or not.
-- 
2.43.0



