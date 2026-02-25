Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E242BDC03;
	Wed, 25 Feb 2026 06:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002762; cv=none; b=lydmyC6TTQZeD59B4c5EF4RsZJ5NHJPen8fAG8oo+Kh6c1EHLQxfIdwPKcQdlWjlW4OyjA4GQ4c5Aq5msqHZ3PNUhRDRTJhKn1G3efu5h0jtxMoOMaVQng0rfLfmNAyNE4wblECe7GGBArjtr0CaAeRGNBfTtDAfrsPa7JXH4h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002762; c=relaxed/simple;
	bh=6sfTjFsDe9Kwf/spSj65jT1JEboyrSD8Clqk29LAc6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGIr747VF4CuUjQczS65zSuRjQDC7Tiq7F2uQvHZCpFLqG2WRYmC19ywNBPAH/C6aAcj61iGJqSMfQxGppZIFViPf7y13w2hhFOeia2EJN4PXh4cXKdkyG3llRaKhHYP/ojIGyAHgHrJNiLM0DZdekSxBWWfOrIy7FD0j1Li1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zARMqQt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zARMqQt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A854C116D0;
	Wed, 25 Feb 2026 06:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002762;
	bh=6sfTjFsDe9Kwf/spSj65jT1JEboyrSD8Clqk29LAc6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zARMqQt2Hs3K9LRnIG2FlamWfV1tOwbm001apLvddlj4/Lyg6XicyJd5/pxwMAuMa
	 zaofMKIePKrNkAA855UT4wMMonkG8C0FFYbMPeCzQkp9eAFMxZjj+5q/ad6iFIjVHx
	 FYDEa0wVMmYKTCW9e+Puon5UEblav+TtT0gIDJkE=
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
Subject: [PATCH 6.18 592/641] drm/amd/display: Fix out-of-bounds stream encoder index v3
Date: Tue, 24 Feb 2026 17:25:18 -0800
Message-ID: <20260225012402.859255091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 82cc78c291d82..12c2a0d9fb2a3 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn315/dcn315_resource.c
@@ -1226,12 +1226,12 @@ static struct stream_encoder *dcn315_stream_encoder_create(
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
index 636110e48d01b..3c77c14c5a5ed 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn316/dcn316_resource.c
@@ -1220,12 +1220,12 @@ static struct stream_encoder *dcn316_stream_encoder_create(
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
index 3965a7f1b64b7..9cace432ce364 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1208,12 +1208,12 @@ static struct stream_encoder *dcn32_stream_encoder_create(
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
index ad214986f7ac7..26fd5c03c0147 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn321/dcn321_resource.c
@@ -1189,12 +1189,12 @@ static struct stream_encoder *dcn321_stream_encoder_create(
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
index 06bec7dcc7556..e8d74ceb9dc29 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -1271,12 +1271,12 @@ static struct stream_encoder *dcn35_stream_encoder_create(
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
index 7974e306126e0..532e5d9bc4337 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -1251,12 +1251,12 @@ static struct stream_encoder *dcn35_stream_encoder_create(
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



