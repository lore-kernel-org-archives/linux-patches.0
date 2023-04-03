Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948866FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B097C4339C;
	Mon,  3 Apr 2023 14:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533069;
	bh=mJgUxo5owB/ky529vzd/7Ni0Rn3/5W3EfAkj5ZdLqhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woIBa3iQg9yGAcanBE34EYYWnCj3f7zI8Xmo7PLlfQgUagCtz867O60UnCyQqY1NP
	 GtY7VP+tJn0xlvDJdVLvtCn7D9Gshhw1EVFv2NzZF6ZVNdUvsL6Y6m+ojLzoQT739p
	 14Vnx8N3lbZCLjdGRM1ZQkGuwFQghjGnm9FaDPbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <Aurabindo.Pillai@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 042/187] drm/amd/display: Fix HDCP failing to enable after suspend
Date: Mon,  3 Apr 2023 16:08:07 +0200
Message-Id: <20230403140417.368961640@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

[ Upstream commit 728cefa53a36ba378ed4a7f31a0c08289687d824 ]

[Why]
On resume some displays are not ready for HDCP, so they will fail if we
start the hdcp authentintication too soon.

Add a delay so that the displays can be ready before we start.

NOTE: Previoulsy this delay was set to 3 seconds but it was causing
issues with compliance, 2 seconds should enough for compliance and the
s3 resume case.

[How]
Change the Delay to 2 seconds.

Reviewed-by: Aurabindo Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index a7fd98f57f94c..dc62375a8e2c4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -495,7 +495,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	link->dp.mst_enabled = config->mst_enabled;
 	link->dp.usb4_enabled = config->usb4_enabled;
 	display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
-	link->adjust.auth_delay = 0;
+	link->adjust.auth_delay = 2;
 	link->adjust.hdcp1.disable = 0;
 	conn_state = aconnector->base.state;
 
-- 
2.39.2



