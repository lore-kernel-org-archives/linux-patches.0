Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3446F142624;
	Thu, 11 Apr 2024 10:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830199; cv=none; b=SKJBsFuMEMZnx9dWucpkSQ32PfpzH5vitUSyGM+A02ufirlrzHoUmr59DvnDGqDLGHHDjw4LHgTvTkvkYdcEqqsl/NkZUzRz8HWT1+bJ8OgMnjABaj81DkuKkjVkVVr63JtQbL7n56izNDuNmKGUmPG/8tMuCH+1EGHAf5POyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830199; c=relaxed/simple;
	bh=8Ye56ijoCCElzG3oSzl2pf4ueongfMHeOqk5qbJby94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdGi5zIHlmN3s8kSM3c/mLzg64k8b6cTFJMKL/UiRzHjqv6p1ExjGtz46ZmOSxu9jH5xwl8E+5hwElt/usbeUv09y4TvrclErA3TFy3/pt+hdzA8rNNSwHQCMK13/mtHNZiVtXn5UriBHHL6v7POdX6HCfgZycHITX+Gk36oBME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fonk8wFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fonk8wFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE473C433C7;
	Thu, 11 Apr 2024 10:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830199;
	bh=8Ye56ijoCCElzG3oSzl2pf4ueongfMHeOqk5qbJby94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fonk8wFmL3pR2pYKjr3SkUjitjKUrCi01gr+uSf1ICGNJqt/v4OuWnDfftTtqRgRF
	 DPJ2DPA+cKAKB8vuVcyz82rr+g9mKLOlvo11HGJ2OcuqQM94EQWm4LPInptxi9fEi5
	 jKoWsmDDX7Ql+BbugK4NZOehVK+BQfJj+2L1UCro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 069/143] drm/amd/display: Disable idle reallow as part of command/gpint execution
Date: Thu, 11 Apr 2024 11:55:37 +0200
Message-ID: <20240411095422.991619190@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 6226a5aa77370329e01ee8abe50a95e60618ce97 ]

[Why]
Workaroud for a race condition where DMCUB is in the process of
committing to IPS1 during the handshake causing us to miss the
transition into IPS2 and touch the INBOX1 RPTR causing a HW hang.

[How]
Disable the reallow to ensure that we have enough of a gap between entry
and exit and we're not seeing back-to-back wake_and_executes.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h                           | 1 +
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c                  | 4 ++--
 .../gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c    | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index f1342314f7f43..fc60fa5814fbe 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -987,6 +987,7 @@ struct dc_debug_options {
 	bool psp_disabled_wa;
 	unsigned int ips2_eval_delay_us;
 	unsigned int ips2_entry_delay_us;
+	bool disable_dmub_reallow_idle;
 	bool disable_timeout;
 	bool disable_extblankadj;
 	unsigned int static_screen_wait_frames;
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index 363d522603a21..9084b320849a6 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -1364,7 +1364,7 @@ bool dc_wake_and_execute_dmub_cmd_list(const struct dc_context *ctx, unsigned in
 	else
 		result = dm_execute_dmub_cmd(ctx, cmd, wait_type);
 
-	if (result && reallow_idle)
+	if (result && reallow_idle && !ctx->dc->debug.disable_dmub_reallow_idle)
 		dc_dmub_srv_apply_idle_power_optimizations(ctx->dc, true);
 
 	return result;
@@ -1413,7 +1413,7 @@ bool dc_wake_and_execute_gpint(const struct dc_context *ctx, enum dmub_gpint_com
 
 	result = dc_dmub_execute_gpint(ctx, command_code, param, response, wait_type);
 
-	if (result && reallow_idle)
+	if (result && reallow_idle && !ctx->dc->debug.disable_dmub_reallow_idle)
 		dc_dmub_srv_apply_idle_power_optimizations(ctx->dc, true);
 
 	return result;
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
index 04d230aa8861f..78c315541f031 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -782,6 +782,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.psp_disabled_wa = true,
 	.ips2_eval_delay_us = 2000,
 	.ips2_entry_delay_us = 800,
+	.disable_dmub_reallow_idle = true,
 	.static_screen_wait_frames = 2,
 };
 
-- 
2.43.0



