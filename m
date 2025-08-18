Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BBA322A08;
	Mon, 18 Aug 2025 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523951; cv=none; b=hg5RUf4f4EogLw9nTuIQNrz8HjnkhrsLp2LmhSf2iPvZPwrMLlvQfLqbqwxiVWRvFs5Y4dZFNyceb/ICYrUgZ1+YinDp4SreEecMxQ5q+EHIi7W+HwpUhxxKc2KvnJCO0wzCqNpmy2VSqtahKtdZB4OgJ9+DPY1Xb6HT9X/9FG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523951; c=relaxed/simple;
	bh=1TuK6x0rAd/hkXPzGz/30NEcffSPNXePTuhjVl7xraU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI0n0qE7X2SO4c5wVb+w9BF/qDkUka61e2lUdYUF3HCz2ztpWsSEmTLaACJumjfUCSDBVcWbeWP48+vIAUPt6ECyTUGH7cqZ4Lwi6DM+oaW4qHUZQwQmfz+ElWG3J7OKwhF95wg8BrEqQc+UnemtdLmpbAnQT3JYAM3/vC+zQPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auUOF0HN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auUOF0HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B17CC4CEEB;
	Mon, 18 Aug 2025 13:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523950;
	bh=1TuK6x0rAd/hkXPzGz/30NEcffSPNXePTuhjVl7xraU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auUOF0HNBUqlXrA5YGT/221+DtPyxKXy747rTIhfda2iTRIDjsUcaw+Dx16Y72bbl
	 gGz8cZrxVpGIuGclzmRYYhUDIE3iGbXU2ErfeD8mi7ya9OPGKRx2BlcDX0m4lFMIzX
	 ejaWW8CLJkM8btw3OSjbO53wcySuFgoHZvynFBio=
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
Subject: [PATCH 6.15 321/515] drm/amd/display: Update DMCUB loading sequence for DCN3.5
Date: Mon, 18 Aug 2025 14:45:07 +0200
Message-ID: <20250818124510.790824625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



