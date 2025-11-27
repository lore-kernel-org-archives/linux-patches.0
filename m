Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E624E4A8;
	Thu, 27 Nov 2025 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255969; cv=none; b=W3FH7TXuvT4Rm/e9X5nNJqhmHXY5KIROHnn2izMqhm+y/La4hm2cF8KUOQOnffRmlyiVqhuNKvoG0GEROKvtdt8xgdWtV/0D8IrpouQycD0I8uF4oWSp3Gy6+aku+XOzb9eKBff0Gj5KkNP+zjC44ioO50fffI/njKsSKmz31YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255969; c=relaxed/simple;
	bh=tqcUE7agmPYJLs4+hucf/KykKe2DI6NLf9GLeyQrDAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgUpIf3qVJ/I9DEZ3VYuDVcjVKrVal6ihqxJ8C4IS8QsKArG34WdX1WZ0tcfts8dABJM+GBIKyRqLz/tKzlkkI5a4Z+8rPZ6I+Nl1IgPd278nX+DCLcgd7z12GNNzlgS0d0dFQnZhici9rZlmswwBwOa8uLOxU+IiuOEBsP/yl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cISt56iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cISt56iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49409C113D0;
	Thu, 27 Nov 2025 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255969;
	bh=tqcUE7agmPYJLs4+hucf/KykKe2DI6NLf9GLeyQrDAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cISt56izLEMhvBY5EuC4DT1vBSMtot+p6P7wmyx8kep06WsbqwFTRwb4I0PlGww6Q
	 4jA3BAsgmM3nDElMOqzngeAvbmSmQGqRdIxmgS9OREq4qim+/x9OvUPg3IM7GBL+AE
	 rRnhDz01EWAWetUQr269Wod2Cj1LoF6QahF7DYo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Roman Li <roman.li@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 170/175] drm/amd/display: Prevent Gating DTBCLK before It Is Properly Latched
Date: Thu, 27 Nov 2025 15:47:03 +0100
Message-ID: <20251127144049.166091510@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit cfa0904a35fd0231f4d05da0190f0a22ed881cce ]

[why]
1. With allow_0_dtb_clk enabled, the time required to latch DTBCLK to 600 MHz
depends on the SMU. If DTBCLK is not latched to 600 MHz before set_mode completes,
gating DTBCLK causes the DP2 sink to lose its clock source.

2. The existing DTBCLK gating sequence ungates DTBCLK based on both pix_clk and ref_dtbclk,
but gates DTBCLK when either pix_clk or ref_dtbclk is zero.
pix_clk can be zero outside the set_mode sequence before DTBCLK is properly latched,
which can lead to DTBCLK being gated by mistake.

[how]
Consider both pixel_clk and ref_dtbclk when determining when it is safe to gate DTBCLK;
this is more accurate.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4701
Fixes: 5949e7c4890c ("drm/amd/display: Enable Dynamic DTBCLK Switch")
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d04eb0c402780ca037b62a6aecf23b863545ebca)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    4 +++-
 drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c       |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -394,6 +394,8 @@ void dcn35_update_clocks(struct clk_mgr
 	display_count = dcn35_get_active_display_cnt_wa(dc, context, &all_active_disps);
 	if (new_clocks->dtbclk_en && !new_clocks->ref_dtbclk_khz)
 		new_clocks->ref_dtbclk_khz = 600000;
+	else if (!new_clocks->dtbclk_en && new_clocks->ref_dtbclk_khz > 590000)
+		new_clocks->ref_dtbclk_khz = 0;
 
 	/*
 	 * if it is safe to lower, but we are already in the lower state, we don't have to do anything
@@ -435,7 +437,7 @@ void dcn35_update_clocks(struct clk_mgr
 
 			actual_dtbclk = REG_READ(CLK1_CLK4_CURRENT_CNT);
 
-			if (actual_dtbclk) {
+			if (actual_dtbclk > 590000) {
 				clk_mgr_base->clks.ref_dtbclk_khz = new_clocks->ref_dtbclk_khz;
 				clk_mgr_base->clks.dtbclk_en = new_clocks->dtbclk_en;
 			}
--- a/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dccg/dcn35/dcn35_dccg.c
@@ -1411,7 +1411,7 @@ static void dccg35_set_dtbclk_dto(
 				__func__, params->otg_inst, params->pixclk_khz,
 				params->ref_dtbclk_khz, req_dtbclk_khz, phase, modulo);
 
-	} else {
+	} else if (!params->ref_dtbclk_khz && !req_dtbclk_khz) {
 		switch (params->otg_inst) {
 		case 0:
 			REG_UPDATE(DCCG_GATE_DISABLE_CNTL5, DTBCLK_P0_GATE_DISABLE, 0);


