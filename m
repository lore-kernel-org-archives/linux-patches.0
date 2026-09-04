Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3A640F742;
	Fri,  4 Sep 2026 05:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498285; cv=none; b=m5nWwTryBSpymYwdqWjx1Spx1/tQS5EpS8S9VlDAARf4xEurbYI4q1wWP5doyd3jeuI5CgmyjFSpI9qC9cAl2mCPSGfQTeZd+2et6WruJjFjG02uJSsgSzRLcM3/JkvxNrZ2hk3uci8F9nl5g+O/11ldPkgOngflDBgtrA/+e1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498285; c=relaxed/simple;
	bh=pRCy/J7Ptc1cpzxXZPvmx3rGh8A6fkE+KFvPdRw0EEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXA72uhlKPwQKLG9Pv7bIU5mHcvLPgUCwaPScS6nNwxGiZNbKAiZkElEQ0nQQDWN+fcdLanFpNiZlhsQ5WjATpMRwvIO6biFSj1lZdpJl+vYzqw9PGhu7Hp3fMlYOfy5rQC08Q3UIeedKmT5zWPPlJNf19/cDypgdAOQ6puecCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFDHCO1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFDHCO1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C9F1F00A3D;
	Fri,  4 Sep 2026 05:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498284;
	bh=7Fy9u9kd+VN0fssr6xmUkWsfRZdSmG3qDKhppUUUPTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFDHCO1Vx7wlRkyKtTbDcX/TL48QiXYApoczW3wwGJPoyI76BtzAVHMytEJ5+X2bF
	 Ox8Hj/Kh7wdSrEoio1YRz5nyP0KFwRkOdCdxEsTA9BmG9B0EnYQ3kYrsXUF8NNxjXn
	 yW0prMcI5hurc/4lfF9DH7rNR+8u95Zz2qBZpEnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 001/713] drm/amd/display: Skip Update HDCP Config In Transition State
Date: Fri,  4 Sep 2026 06:49:29 +0200
Message-ID: <20260904045803.848887821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit d5164580a99477dcfe15cea101b153b1e63f1535 ]

Transition state does not have a valid dm_stream_ctx that should skip
configuring HDCP routine. The routine is valid to go through only when
a valid stream is created.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_hdcp.c    | 28 +++++++++++++------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index 4c164ae4a4f9c..8304e8897a3ed 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -535,15 +535,27 @@ static bool enable_assr(void *handle, struct dc_link *link)
 static void update_config(void *handle, struct cp_psp_stream_config *config)
 {
 	struct hdcp_workqueue *hdcp_work = handle;
-	struct amdgpu_dm_connector *aconnector = config->dm_stream_ctx;
-	int link_index = aconnector->dc_link->link_index;
-	unsigned int conn_index = aconnector->base.index;
-	struct mod_hdcp_display *display = &hdcp_work[link_index].display;
-	struct mod_hdcp_link *link = &hdcp_work[link_index].link;
-	struct hdcp_workqueue *hdcp_w = &hdcp_work[link_index];
+	struct amdgpu_dm_connector *aconnector;
+	const struct dc *dc;
+	int link_index;
+	unsigned int conn_index;
+	struct mod_hdcp_display *display;
+	struct mod_hdcp_link *link;
+	struct hdcp_workqueue *hdcp_w;
 	struct dc_sink *sink = NULL;
 	bool link_is_hdcp14 = false;
-	const struct dc *dc = aconnector->dc_link->dc;
+
+	aconnector = config->dm_stream_ctx;
+	if (!aconnector || !aconnector->dc_link)
+		return;
+
+	link_index = aconnector->dc_link->link_index;
+	display = &hdcp_work[link_index].display;
+	link = &hdcp_work[link_index].link;
+	hdcp_w = &hdcp_work[link_index];
+
+	conn_index = aconnector->base.index;
+	dc = aconnector->dc_link->dc;
 
 	if (config->dpms_off) {
 		hdcp_remove_display(hdcp_work, link_index, aconnector);
@@ -581,7 +593,7 @@ static void update_config(void *handle, struct cp_psp_stream_config *config)
 	link->dp.mst_enabled = config->mst_enabled;
 	link->dp.dp2_enabled = config->dp2_enabled;
 	link->dp.usb4_enabled = config->usb4_enabled;
-	if (aconnector->dc_sink->sink_signal == SIGNAL_TYPE_HDMI_FRL)
+	if (sink && sink->sink_signal == SIGNAL_TYPE_HDMI_FRL)
 		link->hdmi.frl_enabled = config->frl_enabled;
 	display->adjust.disable = MOD_HDCP_DISPLAY_DISABLE_AUTHENTICATION;
 	link->adjust.auth_delay = 2;
-- 
2.53.0



