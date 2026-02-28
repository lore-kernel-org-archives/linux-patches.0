Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614794A33EE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300993; cv=none; b=dJ4ocPc8FTkpjg5a/gFgyFtF8MoY+7+tKHcL+fP14kEoI4k45tbplXO0j5ZDJPSrwu4iuD0Lc+DwE+IWRLlx59AiMSOhJXCVO3cUNS8pjRv0lraeFj4woh6l1mJEfPlMySIDsSJFvCQiK7GPZu+VdtA8PCcwxcrBZVQnZnZMYY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300993; c=relaxed/simple;
	bh=O8LuF7uBLdULn1bPDrcQwl65kbPEhILYhTD+sMnXaPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndZwGS2TUo5eHQmJmnevkchme5g9N89bL/QBIu3jDQYPCaxk9I7NOQj3ESnp/actWxKMxRtHW1+sOaXYkspKZjB85aik+mtIcozITiM6yP0yBk4Y5krqWKq9RRd4Kpw+9V6Dqi9f5RLCbB49k5QRG1wSQ+Z1LNZYx5ivgVPvVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEXAEfAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEXAEfAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C3EC116D0;
	Sat, 28 Feb 2026 17:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300993;
	bh=O8LuF7uBLdULn1bPDrcQwl65kbPEhILYhTD+sMnXaPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEXAEfAxRerz3Sor0FXeLA3+wWnGglZAPRWhX6gOgOdmUJqvzMKpSKh6Atzb/CX36
	 VY3GuEdjwxXRuJvOxiJSef5ftu0VkIvqDbdS3bWII3y9sCvfI6cKWxM4Tcv7LNhGMA
	 Daoo75JIIoWPnqAE0WxL+zaRgJSvP29zN+ZFs3F15txUSvKAqt3rLi67X5D+WSxm/+
	 Mf/0ru7BT7FENNxvycfNcqzqcfrOojTKvPYUAKM4wPN/9b9stLaPNFVBe6l+th5rLW
	 U1RTLl/6zqUbid+rFj7mnjysXjBnkFcAlNor7oN/KNZTPsAb5H44B8cbaKl2iw0Lqa
	 u5Dkqn3617vhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peichen Huang <PeiChen.Huang@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/752] drm/amd/display: Don't disable DPCD mst_en if sink connected
Date: Sat, 28 Feb 2026 12:37:15 -0500
Message-ID: <20260228174750.1542406-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peichen Huang <PeiChen.Huang@amd.com>

[ Upstream commit 9aeb31b2456452257ad1ff7ec566f21bab1f3e8a ]

[WHY]
User may connect mst dock with multi monitors and do quick unplug
and plug in one of the monitor. This operatioin may create CSN from
dock to display driver. Then display driver would disable and then enable
mst link and also disable/enable DPCD mst_en bit in dock RX. However,
when mst_en bit being disabled, if dock has another CSN message to
transmit then the message would be removed because of the disabling of
mst_en. In this case, the message is missing and it ends up no display in
the replugged monitor.

[HOW]
Don't disable mst_en bit when link still has sink connected.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
index b66fbcb0040d6..a084c698ed6ef 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -1928,7 +1928,7 @@ static void disable_link_dp(struct dc_link *link,
 			link->dc->hwss.edp_power_control(link, false);
 	}
 
-	if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST)
+	if (signal == SIGNAL_TYPE_DISPLAY_PORT_MST && link->sink_count == 0)
 		/* set the sink to SST mode after disabling the link */
 		enable_mst_on_sink(link, false);
 
@@ -2079,7 +2079,12 @@ static enum dc_status enable_link_dp(struct dc_state *state,
 			pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT &&
 			link->dc->debug.set_mst_en_for_sst) {
 		enable_mst_on_sink(link, true);
+	} else if (link->dpcd_caps.is_mst_capable &&
+		pipe_ctx->stream->signal == SIGNAL_TYPE_DISPLAY_PORT) {
+		/* disable mst on sink */
+		enable_mst_on_sink(link, false);
 	}
+
 	if (pipe_ctx->stream->signal == SIGNAL_TYPE_EDP) {
 		/*in case it is not on*/
 		if (!link->dc->config.edp_no_power_sequencing)
@@ -2358,9 +2363,9 @@ void link_set_dpms_off(struct pipe_ctx *pipe_ctx)
 	if (pipe_ctx->stream->sink) {
 		if (pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_VIRTUAL &&
 			pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_NONE) {
-			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d\n", __func__,
+			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d sink_count=%d\n", __func__,
 			pipe_ctx->stream->sink->edid_caps.display_name,
-			pipe_ctx->stream->signal, link->link_index);
+			pipe_ctx->stream->signal, link->link_index, link->sink_count);
 		}
 	}
 
@@ -2474,10 +2479,11 @@ void link_set_dpms_on(
 	if (pipe_ctx->stream->sink) {
 		if (pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_VIRTUAL &&
 			pipe_ctx->stream->sink->sink_signal != SIGNAL_TYPE_NONE) {
-			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d\n", __func__,
+			DC_LOG_DC("%s pipe_ctx dispname=%s signal=%x link=%d sink_count=%d\n", __func__,
 			pipe_ctx->stream->sink->edid_caps.display_name,
 			pipe_ctx->stream->signal,
-			link->link_index);
+			link->link_index,
+			link->sink_count);
 		}
 	}
 
-- 
2.51.0

