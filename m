Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D5526B2D7;
	Wed, 25 Feb 2026 01:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983703; cv=none; b=MDA6DOmcCZHCVX+oYophJ8oMODOJ6mu5wf/RmOQTuJeUm9OK0p1f63yBGxUwXVe2QHqUxDhUebiF77jRO8DaMuAiGF85+QAhm1TxXpHkzSyd3AcIvtpBqmShw/MzG+UFGr+6J1gHDkJvwFHepVgw19ADXBAw8sYibo2qqrF6tiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983703; c=relaxed/simple;
	bh=nzgIkOU783KPCiPq+ndev0U++6iDhK9rEYHcMKlK7nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L7g9dXgg6Ke7s7Y2psLD+IOp27b7Weyhk+3hCO0DkBU1JAW815P6zFWHACxgMRpIT+iVtG5iAasIlmb6TbSeYjHtIJgbrcLVfmNTUAOYuFHitmphyDg9YIuv04/mErylcQEw4t/wd1ecJSGpnXVVdcOqA87ZbELaSxEsNlwc1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjeGmC9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjeGmC9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01622C116D0;
	Wed, 25 Feb 2026 01:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983703;
	bh=nzgIkOU783KPCiPq+ndev0U++6iDhK9rEYHcMKlK7nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjeGmC9rvQpIZVVfXxbZKPfys52qiGWgOFfUPp6Qje5KHlQ1nwmtGqcXXDbq89T1l
	 TCeicpRhQUuXngY7zlz7kgCn3hbN9KDUsOM7cF1Z+qHInL69Od9HTFYS6Hkyj1MkOJ
	 l2xPQ8M5JQJo3g0GiLfzIuTtiYOYgmhNZIg2a1fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mauro Rossi <issor.oruam@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 747/781] drm/amd/display: Initialize DAC in DCE link encoder using VBIOS
Date: Tue, 24 Feb 2026 17:24:16 -0800
Message-ID: <20260225012418.046164014@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit e2a024345bce78a8e1ed7d9e84c859b05979e41e ]

The VBIOS DAC1EncoderControl() function can initialize the DAC,
by writing board-specific values to certain registers.
Call this at link encoder hardware initialization time similarly
to how the equivalent UNIPHYTransmitterControl initialization
is done.

This fixes DAC output on the Radeon HD 7790.

Also remove the ENCODER_CONTROL_SETUP enum from the
dac_encoder_control_prepare_params function which is actually
not a supported operation for DAC encoders.

Fixes: 0fbe321a93ce ("drm/amd/display: Implement DCE analog link encoders (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Tested-by: Mauro Rossi <issor.oruam@gmail.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/command_table.c   |  3 +--
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/command_table.c b/drivers/gpu/drm/amd/display/dc/bios/command_table.c
index 76a3559f0ddc1..b692fa37402d9 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/command_table.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/command_table.c
@@ -1874,8 +1874,7 @@ static void dac_encoder_control_prepare_params(
 	uint8_t dac_standard)
 {
 	params->ucDacStandard = dac_standard;
-	if (action == ENCODER_CONTROL_SETUP ||
-	    action == ENCODER_CONTROL_INIT)
+	if (action == ENCODER_CONTROL_INIT)
 		params->ucAction = ATOM_ENCODER_INIT;
 	else if (action == ENCODER_CONTROL_ENABLE)
 		params->ucAction = ATOM_ENABLE;
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 2e742950a62c7..48a1b3b492e7f 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -1033,6 +1033,16 @@ void dce110_link_encoder_hw_init(
 	cntl.coherent = false;
 	cntl.hpd_sel = enc110->base.hpd_source;
 
+	if (enc110->base.analog_engine != ENGINE_ID_UNKNOWN) {
+		result = link_dac_encoder_control(enc110, ENCODER_CONTROL_INIT, 0);
+		if (result != BP_RESULT_OK) {
+			DC_LOG_ERROR("%s: Failed to execute VBIOS command table for DAC!\n",
+				__func__);
+			BREAK_TO_DEBUGGER();
+			return;
+		}
+	}
+
 	/* The code below is only applicable to encoders with a digital transmitter. */
 	if (enc110->base.transmitter == TRANSMITTER_UNKNOWN)
 		return;
-- 
2.51.0



