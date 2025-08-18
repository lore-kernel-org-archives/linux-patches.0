Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A693375AB;
	Mon, 18 Aug 2025 14:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525726; cv=none; b=KboAy0MZrRXhnnron4nJPmWnwGXr2Y+gsL/ue9o0l+zOaz2YcZIBF+rcnBgTSEtjBMIrVaG1hEPazXVyxGf0HzMpFqur+XRxRrzPYDoeXtCby7XmL+SGaaFucKkNhVKudRdDiaFHbbCItNOIDzb3Po6mvAjvDiK4S8oMsVHpIZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525726; c=relaxed/simple;
	bh=aJGyoZkjQ0yckqVNHPNOgiQnsnA6WAdRnlBEbxxX0HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BafxZkAqXKoi+uFkt8EvpgYPqfNgn58nxz8vk7dHtmJOCmN8MjJNUUboWk6WavESHPnOaBWECQ/r9EheOYLlJ/7914aC6CktrA1SO/g4nZCVhQOWtyAh8zJmk0PHG1ubryV0aaoa4Zvh7H0YJViey0t/r3shte/fhEfjAYys6Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWmESnNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWmESnNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B127AC4CEEB;
	Mon, 18 Aug 2025 14:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525726;
	bh=aJGyoZkjQ0yckqVNHPNOgiQnsnA6WAdRnlBEbxxX0HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWmESnNQ5Oa1Ex7Wr2LblQRk1ge4tKBOBiRuZyX3BKpWk4XvR/88GVKmu3t53jQS5
	 d7Ap9JtDtnYaIMG9C1hHGvJdlwh68VtQWeIubT4YYxi4pG9dOopjxt8bZJ4H9J+SHK
	 iNdjVxJRIz7GTluO/JYnCyEMtt8PwMDLx7U6qX2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 349/570] drm/amd/display: Update DMCUB loading sequence for DCN3.5
Date: Mon, 18 Aug 2025 14:45:36 +0200
Message-ID: <20250818124519.303040588@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit d42b2331e158fa6bcdc89e4c8c470dc5da20be1f ]

[Why]
New sequence from HW for reset and firmware reloading has been
provided that aims to stabilize the reload sequence in the case the
firmware is hung or has outstanding requests.

[How]
Update the sequence to remove the DMUIF reset and the redundant
writes in the release.

Reviewed-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dmub/src/dmub_dcn35.c    | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
index 72a0f078cd1a..2884977a3dd2 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn35.c
@@ -92,19 +92,15 @@ void dmub_dcn35_reset(struct dmub_srv *dmub)
 	uint32_t in_reset, is_enabled, scratch, i, pwait_mode;
 
 	REG_GET(DMCUB_CNTL2, DMCUB_SOFT_RESET, &in_reset);
+	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_enabled);
 
-	if (in_reset == 0) {
+	if (in_reset == 0 && is_enabled != 0) {
 		cmd.bits.status = 1;
 		cmd.bits.command_code = DMUB_GPINT__STOP_FW;
 		cmd.bits.param = 0;
 
 		dmub->hw_funcs.set_gpint(dmub, cmd);
 
-		/**
-		 * Timeout covers both the ACK and the wait
-		 * for remaining work to finish.
-		 */
-
 		for (i = 0; i < timeout; ++i) {
 			if (dmub->hw_funcs.is_gpint_acked(dmub, cmd))
 				break;
@@ -130,11 +126,9 @@ void dmub_dcn35_reset(struct dmub_srv *dmub)
 		/* Force reset in case we timed out, DMCUB is likely hung. */
 	}
 
-	REG_GET(DMCUB_CNTL, DMCUB_ENABLE, &is_enabled);
-
 	if (is_enabled) {
 		REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-		REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
+		udelay(1);
 		REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
 	}
 
@@ -160,11 +154,7 @@ void dmub_dcn35_reset_release(struct dmub_srv *dmub)
 		     LONO_SOCCLK_GATE_DISABLE, 1,
 		     LONO_DMCUBCLK_GATE_DISABLE, 1);
 
-	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
-	udelay(1);
 	REG_UPDATE_2(DMCUB_CNTL, DMCUB_ENABLE, 1, DMCUB_TRACEPORT_EN, 1);
-	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-	udelay(1);
 	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 0);
 	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 0);
 }
-- 
2.39.5



