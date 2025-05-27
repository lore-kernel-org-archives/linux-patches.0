Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3EA27BF8D;
	Tue, 27 May 2025 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368256; cv=none; b=U6IBDR6wklrAXyyEeURPzoDFtsp/v2PSM5RLqpN5IgP5F3m+6DenCzlegkqE6GBRgaBxVSQ4fMQDfq7aaNd8lQjFPR26DJGMqshlWTEU830TVI68plOTq3EO9JxxsaB0sKRnRLJdtDKsv2WIL+E6wb87Q3hGHY+aXJJND5CXcAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368256; c=relaxed/simple;
	bh=NAKKSl0D0fU4bnVqbEwKYV5DmFM0xAO9SX9qRM+DmP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REXSkP00+muxucY6/uJhm0Qthsjs9mcoEzKg4qSUUqP/ewfNJeE7yQXT2RdN1SDJVzMcNPSzha/zDs+dy9CvuaqlaABYFXKtXCnxScLqW9xFrYeu+Hd3pGMuy17UPuxE3McAy1aulEbe2kJ34LHQQAbf6glASM0vUz1hZPByvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBOJ+hRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBOJ+hRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F6CC4CEE9;
	Tue, 27 May 2025 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368256;
	bh=NAKKSl0D0fU4bnVqbEwKYV5DmFM0xAO9SX9qRM+DmP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBOJ+hRE32iEbZjV1tZCHSp2FJaBtFaF4O/MenZ+inh3IA9d3rneznvMmp/9IrTfC
	 tHeh1g+RLlb11Z8C8jMc4IIWEZgb3NfoCZSvxP5/kJzDEbruF+l8U22Hp1fM356Oyr
	 44UBQ7GJAVAmF6u37avdRLWNNwBB4a8Fj/JZCjN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Ovidiu Bunea <Ovidiu.Bunea@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 641/783] drm/amd/display: Exit idle optimizations before accessing PHY
Date: Tue, 27 May 2025 18:27:18 +0200
Message-ID: <20250527162539.247227264@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <Ovidiu.Bunea@amd.com>

[ Upstream commit c488967488d7eff7b9c527d5469c424c15377502 ]

[why & how]
By default, DCN HW is in idle optimized state which does not allow access
to PHY registers. If BIOS powers up the DCN, it is fine because they will
power up everything. Only exit idle optimized state when not taking control
from VBIOS.

Fixes: be704e5ef4bd ("Revert "drm/amd/display: Exit idle optimizations before attempt to access PHY"")
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Ovidiu Bunea <Ovidiu.Bunea@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 2f5f3e749a1ab..94ceccfc04982 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1889,6 +1889,7 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 	bool can_apply_edp_fast_boot = false;
 	bool can_apply_seamless_boot = false;
 	bool keep_edp_vdd_on = false;
+	struct dc_bios *dcb = dc->ctx->dc_bios;
 	DC_LOGGER_INIT();
 
 
@@ -1965,6 +1966,8 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 			hws->funcs.edp_backlight_control(edp_link_with_sink, false);
 		}
 		/*resume from S3, no vbios posting, no need to power down again*/
+		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
+			clk_mgr_exit_optimized_pwr_state(dc, dc->clk_mgr);
 
 		power_down_all_hw_blocks(dc);
 
@@ -1977,6 +1980,8 @@ void dce110_enable_accelerated_mode(struct dc *dc, struct dc_state *context)
 		disable_vga_and_power_gate_all_controllers(dc);
 		if (edp_link_with_sink && !keep_edp_vdd_on)
 			dc->hwss.edp_power_control(edp_link_with_sink, false);
+		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
+			clk_mgr_optimize_pwr_state(dc, dc->clk_mgr);
 	}
 	bios_set_scratch_acc_mode_change(dc->ctx->dc_bios, 1);
 }
-- 
2.39.5



