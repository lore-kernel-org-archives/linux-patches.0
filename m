Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CA91D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkH+VN5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F8BC433C9;
	Wed,  4 Oct 2023 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444058;
	bh=fpkDYqCxm+AKn3Nsq/uyTll16d/bzllkDbcDtynCrlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkH+VN5qVok49XY45Fa5TQGqaxUDYlwZr20NltvJ/68vmjF9nkwAg8k7dpm2bAytG
	 ywx2d6+VBaydeYtPN1JvDOXGyWccxl/OYYtsfYZPeDFbcVhQtNMjXgZ2JHw/2z39yc
	 WkXiGDYSy1DdWYtqn0oxUcVKwsTvV5RIgXAv1OnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 114/321] drm/amd/display: fix a regression in blank pixel data caused by coding mistake
Date: Wed,  4 Oct 2023 19:54:19 +0200
Message-ID: <20231004175234.519791849@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

[ Upstream commit f77d1a49902bc70625e3d101a16d8a687f7e97db ]

[why]
There was unfortunately a coding mistake. It gets caught with an ultrawide monitor
that requires ODM 4:1 combine. We are blanking or unblanking pixel data we
are supposed to enumerate through all ODM pipes and program DPG for each
of those pipes. However the coding mistake causes us to program only the
first and last ODM pipes.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Martin Leung <martin.leung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c            | 2 +-
 drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 704d02d89fb34..62a077adcdbfa 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1084,7 +1084,7 @@ void dcn20_blank_pixel_data(
 
 	while (odm_pipe->next_odm_pipe) {
 		dc->hwss.set_disp_pattern_generator(dc,
-				pipe_ctx,
+				odm_pipe,
 				test_pattern,
 				test_pattern_color_space,
 				stream->timing.display_color_depth,
diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index bce0428ad6123..9fd68a11fad23 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -513,7 +513,7 @@ static void set_crtc_test_pattern(struct dc_link *link,
 				odm_opp = odm_pipe->stream_res.opp;
 				odm_opp->funcs->opp_program_bit_depth_reduction(odm_opp, &params);
 				link->dc->hwss.set_disp_pattern_generator(link->dc,
-						pipe_ctx,
+						odm_pipe,
 						controller_test_pattern,
 						controller_color_space,
 						color_depth,
-- 
2.40.1



