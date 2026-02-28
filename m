Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892E7340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301051; cv=none; b=bCt/G5o/bE49fyO1UdboS7lCBw9eICAaggXm6uCKc91K6DdbS8pyjxbNyXkgovlTBbNeEFFYypi86HW5czrHIc3CBspUsMmwQ4gqk38omd9i0rkzfvGbQNDY2fTeGp+JlK5XXVJyHkVNSPYH/KMNVe+UEJfAAcb6ANsCwDxIi5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301051; c=relaxed/simple;
	bh=uXt4EcvHwKzGaFGbXxhLQb2M30CgHEkwoMNd8HBBal0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeSzDFs6OOaUDMV9BULjJMLUFFjL7IFng8ZbCtPWn6LHfPGUlNB/0+LbOL90BFKJqMuPFsSqT65VgbpMIxgiMhjU5ZzMqIjlKIrj4lXJkvudckKrdzOMolX/emRVphiv7jfX98M3PKJ88Y0lYKiTCNmePXomt1PtRLzo8Jm6QdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bd1gQ8VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bd1gQ8VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2C6C19423;
	Sat, 28 Feb 2026 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301051;
	bh=uXt4EcvHwKzGaFGbXxhLQb2M30CgHEkwoMNd8HBBal0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd1gQ8VRsBePO6qk8sETgVWr3ZrYRSR/9JejIkoQTmgkM1oVCVotv+as/VIg0rZYT
	 8qez9uhOSQDTiB8uj8jMkcFhOg8npcf4H/1pBss7D4mytH7b2n88xxHlIYiuanoFBy
	 oZckjGyU9+kYOB9iKIZrY5hCAaKAJZtQNoWOsdU/CoPToAoPOEMwPRNownGOe/IGsa
	 0cvszsF9Ky569g0JkL4SibYVYnZV+Um5N0B4fywgrilioyJZV7XcOEWL+i1kuV1QvE
	 10/eIeOCpdNz4GpYG12vEyV00Ry56Do03wsTxe9S9ElPOhFqcM/veVGQtELMTMDykH
	 c5FEGbOR1I0iQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zhongwei <Zhongwei.Zhang@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/752] drm/amd/display: avoid dig reg access timeout on usb4 link training fail
Date: Sat, 28 Feb 2026 12:38:22 -0500
Message-ID: <20260228174750.1542406-191-sashal@kernel.org>
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

From: Zhongwei <Zhongwei.Zhang@amd.com>

[ Upstream commit 15b1d7b77e9836ff4184093163174a1ef28bbdd7 ]

[Why]
When usb4 link training fails, the dpia sym clock will be disabled and SYMCLK
source should be changed back to phy clock. In enable_streams, it is
assumed that link training succeeded and will switch from refclk to
phy clock. But phy clk here might not be on. Dig reg access timeout
will occur.

[How]
When enable_stream is hit, check if link training failed for usb4.
If it did, fall back to the ref clock to avoid reg access timeout.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Zhongwei <Zhongwei.Zhang@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c  | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
index 56c1ab6c73308..a4025a09a38a3 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3055,9 +3055,17 @@ void dcn20_enable_stream(struct pipe_ctx *pipe_ctx)
 			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
 		}
 	} else {
-		if (dccg->funcs->enable_symclk_se)
-			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
+		if (dccg->funcs->enable_symclk_se && link_enc) {
+			if (link->ep_type == DISPLAY_ENDPOINT_USB4_DPIA
+				&& link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN
+				&& !link->link_status.link_active) {
+				if (dccg->funcs->disable_symclk_se)
+					dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,
 						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
+			} else
+				dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
+						      link_enc->transmitter - TRANSMITTER_UNIPHY_A);
+		}
 	}
 
 	if (dc->res_pool->dccg->funcs->set_pixel_rate_div)
-- 
2.51.0

