Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9065939FF3;
	Fri, 24 Nov 2023 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a108Xy3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95B9C433C7;
	Fri, 24 Nov 2023 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850309;
	bh=nQ2MHL5SML/fxa7hYrqny1kvJaIJwuNwvsp7PKfMt10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a108Xy3r4cQ/MBRQ1ssW2dSfo6KJ39Foin8Thf6UgTQ7Q+lny7EXAf5bc5x1XbCy8
	 iQwaxnH/dohqOaKCsEUkSa2tsQ3lPHEYPAOO+O/v7YVp5C4+lKoaPBrLu8uIldBkv2
	 6gSFL3cBPcOJfdx8ZxWwYBc9X2AwpBnqzwLomBgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Paul Hsieh <paul.hsieh@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 529/530] drm/amd/display: Clear dpcd_sink_ext_caps if not set
Date: Fri, 24 Nov 2023 17:51:35 +0000
Message-ID: <20231124172044.302847831@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Hsieh <paul.hsieh@amd.com>

commit 923bbfe6c888812db1088d684bd30c24036226d2 upstream.

[WHY]
Some eDP panels' ext caps don't set initial values
and the value of dpcd_addr (0x317) is random.
It means that sometimes the eDP can be OLED, miniLED and etc,
and cause incorrect backlight control interface.

[HOW]
Add remove_sink_ext_caps to remove sink ext caps (HDR, OLED and etc)

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_types.h            |    1 +
 drivers/gpu/drm/amd/display/dc/link/link_detection.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dc_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_types.h
@@ -189,6 +189,7 @@ struct dc_panel_patch {
 	unsigned int disable_fams;
 	unsigned int skip_avmute;
 	unsigned int mst_start_top_delay;
+	unsigned int remove_sink_ext_caps;
 };
 
 struct dc_edid_caps {
--- a/drivers/gpu/drm/amd/display/dc/link/link_detection.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_detection.c
@@ -1085,6 +1085,9 @@ static bool detect_link_and_local_sink(s
 		if (sink->edid_caps.panel_patch.skip_scdc_overwrite)
 			link->ctx->dc->debug.hdmi20_disable = true;
 
+		if (sink->edid_caps.panel_patch.remove_sink_ext_caps)
+			link->dpcd_sink_ext_caps.raw = 0;
+
 		if (dc_is_hdmi_signal(link->connector_signal))
 			read_scdc_caps(link->ddc, link->local_sink);
 


