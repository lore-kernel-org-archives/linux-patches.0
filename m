Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA891C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99EBC433EF;
	Wed, 28 Dec 2022 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246384;
	bh=cZNNScqHcCN606hosHGQCZoKIh6e63Zn9gRo+mJaMdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDiOXU5X0ulgxy7jKotTKSkXXqUi3GzCDEXomPJHuFWFAGyznmhq/jZqQDvVa3uEO
	 a0jgFBjLpwN5oNs0oD1EPdPFJt9rG3dSIlOjpb+sF7ENvYBJykN/0fjp/5sz3z4kg5
	 jtIEDjndIhtjP1R4I2aPJRwxhDCKQvyOYaERsh3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <Dillon.Varone@amd.com>,
	Jasdeep Dhillon <jdhillon@amd.com>,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1030/1146] drm/amd/display: Fix DTBCLK disable requests and SRC_SEL programming
Date: Wed, 28 Dec 2022 15:42:49 +0100
Message-Id: <20221228144358.336003515@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit f6015da7f2410109bd2ccd2e2828f26185aeb81d ]

[Description]
- When transitioning FRL / DP2 is not required, we will always request
  DTBCLK = 0Mhz, but PMFW returns the min freq
- This causes us to make DTBCLK requests every time we call optimize
  after transitioning from FRL to non-FRL
- If DTBCLK is not required, request the min instead (then we only need
  to make 1 extra request at boot time)
- Also when programming PIPE_DTO_SRC_SEL, don't programming for DP
  first, just programming once for the required selection (programming
  DP on an HDMI connection then switching back causes corruption)

Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c    | 2 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c           | 6 +-----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
index 6f77d8e538ab..9eb9fe5b8d2c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn32/dcn32_clk_mgr.c
@@ -438,7 +438,7 @@ static void dcn32_update_clocks(struct clk_mgr *clk_mgr_base,
 	}
 
 	if (!new_clocks->dtbclk_en) {
-		new_clocks->ref_dtbclk_khz = 0;
+		new_clocks->ref_dtbclk_khz = clk_mgr_base->bw_params->clk_table.entries[0].dtbclk_mhz * 1000;
 	}
 
 	/* clock limits are received with MHz precision, divide by 1000 to prevent setting clocks at every call */
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
index df4f25119142..e4472c6be6c3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_dccg.c
@@ -225,11 +225,7 @@ static void dccg32_set_dtbclk_dto(
 	} else {
 		REG_UPDATE_2(OTG_PIXEL_RATE_CNTL[params->otg_inst],
 				DTBCLK_DTO_ENABLE[params->otg_inst], 0,
-				PIPE_DTO_SRC_SEL[params->otg_inst], 1);
-		if (params->is_hdmi)
-			REG_UPDATE(OTG_PIXEL_RATE_CNTL[params->otg_inst],
-				PIPE_DTO_SRC_SEL[params->otg_inst], 0);
-
+				PIPE_DTO_SRC_SEL[params->otg_inst], params->is_hdmi ? 0 : 1);
 		REG_WRITE(DTBCLK_DTO_MODULO[params->otg_inst], 0);
 		REG_WRITE(DTBCLK_DTO_PHASE[params->otg_inst], 0);
 	}
-- 
2.35.1



