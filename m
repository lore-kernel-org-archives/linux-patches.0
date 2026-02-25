Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5326ED3D;
	Wed, 25 Feb 2026 01:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983632; cv=none; b=NaHq+xYt145wArSM+vHlSWQf12b/xlbI6w4rwDSK/ZZCB/psLUzaHbX4uu5PbpZIKgZKca7ELmX81D3ipr2RBWhCWmJduLO1l4xYGP9JxTS3D5mI+JYqXr2E9MTKQXHbrTQDFNCHBok5xWfewoLjWkCRoyvo3LOE9FcikiGnQP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983632; c=relaxed/simple;
	bh=lB0fb+LvSzvfRm30zY1TTCzP57ILI9gbcy6/h4265Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+K+J+4sHKQQ7UgdK+5SjjSAmhCCcD7MU1f6LMt48jru5Dz6S6wZPrxgynD7UkAKjLS6uxodNKEQCjDaQAMosSpdbv+hk/DNSEgT2LN7beEm1rohmSG7XAIXhOUda6AVcx4xUr6+D/yLkOjZRXbGSA2MuQT7uNhx08TOcap7D04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+YDP2S6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+YDP2S6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B919C116D0;
	Wed, 25 Feb 2026 01:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983632;
	bh=lB0fb+LvSzvfRm30zY1TTCzP57ILI9gbcy6/h4265Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+YDP2S6TcowS7/bifTks7WbR+mAn2M09ehjNW0UcBDMGcGWhS5umUzSNFzZT/hCq
	 FXdN9mgx8pQmA6FGwMqC0h7U6XgEHLZALW0uVvek5KLgYXcCpEGaI1ezd07OQQSwD/
	 zrMtlJUH98Nvsx4dcP1f9q0vTYo7GeGo/Im6yF1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <superm1@kernel.org>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Roman Li <roman.li@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 723/781] drm/amd/display: Fix out-of-bounds stream encoder index v3
Date: Tue, 24 Feb 2026 17:23:52 -0800
Message-ID: <20260225012417.470025417@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit abde491143e4e12eecc41337910aace4e8d59603 ]

eng_id can be negative and that stream_enc_regs[]
can be indexed out of bounds.

eng_id is used directly as an index into stream_enc_regs[], which has
only 5 entries. When eng_id is 5 (ENGINE_ID_DIGF) or negative, this can
access memory past the end of the array.

Add a bounds check using ARRAY_SIZE() before using eng_id as an index.
The unsigned cast also rejects negative values.

This avoids out-of-bounds access.

Fixes the below smatch error:
dcn*_resource.c: stream_encoder_create() may index
stream_enc_regs[eng_id] out of bounds (size 5).

drivers/gpu/drm/amd/amdgpu/../display/dc/resource/dcn351/dcn351_resource.c
    1246 static struct stream_encoder *dcn35_stream_encoder_create(
    1247         enum engine_id eng_id,
    1248         struct dc_context *ctx)
    1249 {

    ...

    1255
    1256         /* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
    1257         if (eng_id <= ENGINE_ID_DIGF) {

ENGINE_ID_DIGF is 5.  should <= be <?

Unrelated but, ugh, why is Smatch saying that "eng_id" can be negative?
end_id is type signed long, but there are checks in the caller which prevent it from being negative.

    1258                 vpg_inst = eng_id;
    1259                 afmt_inst = eng_id;
    1260         } else
    1261                 return NULL;
    1262

    ...

    1281
    1282         dcn35_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
    1283                                         eng_id, vpg, afmt,
--> 1284                                         &stream_enc_regs[eng_id],
                                                  ^^^^^^^^^^^^^^^^^^^^^^^ This stream_enc_regs[] array has 5 elements so we are one element beyond the end of the array.

    ...

    1287         return &enc1->base;
    1288 }

v2: use explicit bounds check as suggested by Roman/Dan; avoid unsigned int cast

v3: The compiler already knows how to compare the two values, so the
    cast (int) is not needed. (Roman)

Fixes: 2728e9c7c842 ("drm/amd/display: add DC changes for DCN351")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Cc: Roman Li <roman.li@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/resource/dcn315/dcn315_resource.c  | 8 ++++----
 .../drm/amd/display/dc/resource/dcn316/dcn316_resource.c  | 8 ++++----
 .../drm/amd/display/dc/resource/dcn32/dcn32_resource.c    | 8 ++++----
 .../drm/amd/display/dc/resource/dcn321/dcn321_resource.c  | 8 ++++----
 .../drm/amd/display/dc/resource/dcn35/dcn35_resource.c    | 8 ++++----
 .../drm/amd/display/dc/resource/dcn351/dcn351_resource.c  | 8 ++++----
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
index 4e962f522f1be..228ae665c7893 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
@@ -1230,12 +1230,12 @@ static struct stream_encoder *dcn315_stream_encoder_create(
 	/*PHYB is wired off in HW, allow front end to remapping, otherwise needs more changes*/
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn31_vpg_create(ctx, vpg_inst);
 	afmt = dcn31_afmt_create(ctx, afmt_inst);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
index 5a95dd54cb429..45abf3b2eb2c4 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
@@ -1223,12 +1223,12 @@ static struct stream_encoder *dcn316_stream_encoder_create(
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn31_vpg_create(ctx, vpg_inst);
 	afmt = dcn31_afmt_create(ctx, afmt_inst);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index b276fec3e479a..d39a0f9c78c92 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1211,12 +1211,12 @@ static struct stream_encoder *dcn32_stream_encoder_create(
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn32_vpg_create(ctx, vpg_inst);
 	afmt = dcn32_afmt_create(ctx, afmt_inst);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
index 3466ca34c93fe..c72c6dbc0cb4d 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1192,12 +1192,12 @@ static struct stream_encoder *dcn321_stream_encoder_create(
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn321_vpg_create(ctx, vpg_inst);
 	afmt = dcn321_afmt_create(ctx, afmt_inst);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index d056e5fd54587..9edabd8ceca9b 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1274,12 +1274,12 @@ static struct stream_encoder *dcn35_stream_encoder_create(
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn31_vpg_create(ctx, vpg_inst);
 	afmt = dcn31_afmt_create(ctx, afmt_inst);
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
index 9fab3169069c4..43ece2bbcd64f 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1254,12 +1254,12 @@ static struct stream_encoder *dcn35_stream_encoder_create(
 	int afmt_inst;
 
 	/* Mapping of VPG, AFMT, DME register blocks to DIO block instance */
-	if (eng_id <= ENGINE_ID_DIGF) {
-		vpg_inst = eng_id;
-		afmt_inst = eng_id;
-	} else
+	if (eng_id < 0 || eng_id >= ARRAY_SIZE(stream_enc_regs))
 		return NULL;
 
+	vpg_inst = eng_id;
+	afmt_inst = eng_id;
+
 	enc1 = kzalloc(sizeof(struct dcn10_stream_encoder), GFP_KERNEL);
 	vpg = dcn31_vpg_create(ctx, vpg_inst);
 	afmt = dcn31_afmt_create(ctx, afmt_inst);
-- 
2.51.0



