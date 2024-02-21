Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9966F074;
	Wed, 21 Feb 2024 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523032; cv=none; b=oFyuD1FWGgZyYjEm1d6BP/txTT63qkrdu9Bo9ZCtTxyLD/kgSbTXIdW51DYxIvLwyWjdkvfnIQk8PswThTS2sWKWJ/EqreLQVjUUVy0PIhrVgbOOpzNLyAtjaW0swBijuwmSWn7rtStZ5gChQe+SY1Tu8n+r7nFG/o4yQqdnapI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523032; c=relaxed/simple;
	bh=RR6IX5igTFlrtWwgAMTywaCeHOqw187/OL4R9F40ykM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isnERoY5wFqhUGMHo4vfeULRlyj6nA3tjKykUwPhVUpXGGO7KbKeEmP4/pOmyU8IdV2UhQq9ADPuxYQ5s7pvnJ3n/e5I+KyYn70O7xzG9AyCEHj6K48f+FECR/FPVtvXnwJdv2kx/TIUj+Jp3UyjaCuZy+eJRboDeB/JTw2YFh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYQd4BGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYQd4BGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C56C433C7;
	Wed, 21 Feb 2024 13:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523032;
	bh=RR6IX5igTFlrtWwgAMTywaCeHOqw187/OL4R9F40ykM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYQd4BGMmwpHFHcVYToyyZTLoRFTd360SfoPa7C1vBW5DTwKGNZqNw3Oj3777P/ST
	 wLmGBXM4cbS38Bts/9thycJY4F7N0dguuElC8vjfgAGfFow1egXXx3Jl/nqm9kk2hX
	 bgmfge2dcEIhamzcznYPHDmLaLJJnvDc7+D+DrG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
	Mikita Lipski <mikita.lipski@amd.com>,
	Anson Jacob <Anson.Jacob@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/476] drm/amd/display: Fix multiple memory leaks reported by coverity
Date: Wed, 21 Feb 2024 14:06:11 +0100
Message-ID: <20240221130019.840752400@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 7b89bf83181363a84f86da787159ddbbef505b8c ]

coccinelle patch used:

@@ expression enc1,vpg,afmt; @@
-       if (!enc1 || !vpg || !afmt)
+       if (!enc1 || !vpg || !afmt) {
+               kfree(enc1);
+               kfree(vpg);
+               kfree(afmt);
                return NULL;
+       }

Addresses-Coverity-ID: 1466017: ("Resource leaks")

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 58fca355ad37 ("drm/amd/display: Implement bounds check for stream encoder creation in DCN301")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c   | 6 +++++-
 drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c | 6 +++++-
 drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c | 6 +++++-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c   | 6 +++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index 735c92a5aa36..e8d4a8044d1f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1164,8 +1164,12 @@ struct stream_encoder *dcn30_stream_encoder_create(
 	vpg = dcn30_vpg_create(ctx, vpg_inst);
 	afmt = dcn30_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
index dea358b01791..b6c363b462a7 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn301/dcn301_resource.c
@@ -1195,8 +1195,12 @@ struct stream_encoder *dcn301_stream_encoder_create(
 	vpg = dcn301_vpg_create(ctx, vpg_inst);
 	afmt = dcn301_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
diff --git a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
index 2292bb82026e..7f04042d2213 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn302/dcn302_resource.c
@@ -542,8 +542,12 @@ static struct stream_encoder *dcn302_stream_encoder_create(enum engine_id eng_id
 	vpg = dcn302_vpg_create(ctx, vpg_inst);
 	afmt = dcn302_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios, eng_id, vpg, afmt, &stream_enc_regs[eng_id],
 			&se_shift, &se_mask);
diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index e224c5213258..4f7bc8829b20 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1291,8 +1291,12 @@ static struct stream_encoder *dcn31_stream_encoder_create(
 	vpg = dcn31_vpg_create(ctx, vpg_inst);
 	afmt = dcn31_afmt_create(ctx, afmt_inst);
 
-	if (!enc1 || !vpg || !afmt)
+	if (!enc1 || !vpg || !afmt) {
+		kfree(enc1);
+		kfree(vpg);
+		kfree(afmt);
 		return NULL;
+	}
 
 	dcn30_dio_stream_encoder_construct(enc1, ctx, ctx->dc_bios,
 					eng_id, vpg, afmt,
-- 
2.43.0



