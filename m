Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72ABF158878;
	Tue, 23 Jul 2024 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759715; cv=none; b=j+LKGDs0tXcWl+/o9UIMkUxys1xX4r+cjUBUBWHWK2Lzncwb2F5LA3uXYXPwCu/f5MJLmRWpTAdz7jW0ZPlAL1809atC9QxTDRufcXT7EXXjVsWDaZYrq69iorGFuOjH64MfMpiVGe1hRlQeY4qCaUnsIcSRBIcxLWcq9kNQelE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759715; c=relaxed/simple;
	bh=gBePPhEsOwOuTgw9Km9DtlH1QOBvaW3LxpYZxlLelPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izfhBmgUYiZ4ZGTeV5xvTCHpLlSXgsgNZv0Y0nG1Gcu8FyE0M/EU+51wbHOC6/maMIioubCc+Fm9UaryZIrffmU2uVXqawgbwRD6XzHGfuoWldHkOc5+qeDoy/iIKNWvdmPiZUsGH+WR9TKi6m8VwUYi82oVObsk1KYor7fz7YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J9dJdt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J9dJdt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C55C4AF09;
	Tue, 23 Jul 2024 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759715;
	bh=gBePPhEsOwOuTgw9Km9DtlH1QOBvaW3LxpYZxlLelPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J9dJdt6kWA9VVGqLajb4ACNSfxcdl1gVlt/s7aSTxKTKZLhf4GzPwW//o2VTipr2
	 a79oOmG02/wIp3/zxR6ycwI4EX8vkHWL0sY6E4nR0Y0yZDbu9VVW3EDeLYFDRmHZV7
	 2cwkb2WH+6oEy6tmsCAeYZO0LhQ6sUOQYXgTlwe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun peng Li <sunpeng.li@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/129] drm/amd/display: Fix refresh rate range for some panel
Date: Tue, 23 Jul 2024 20:24:12 +0200
Message-ID: <20240723180408.811967822@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit 9ef1548aeaa8858e7aee2152bf95cc71cdcd6dff ]

[Why]
Some of the panels does not have the refresh rate range info
in base EDID and only have the refresh rate range info in
DisplayID block.
It will cause the max/min freesync refresh rate set to 0.

[How]
Try to parse the refresh rate range info from DisplayID if the
max/min refresh rate is 0.

Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6e5ca0c755c3b..60db3800666ec 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10630,6 +10630,49 @@ static bool parse_edid_cea(struct amdgpu_dm_connector *aconnector,
 	return ret;
 }
 
+static void parse_edid_displayid_vrr(struct drm_connector *connector,
+		struct edid *edid)
+{
+	u8 *edid_ext = NULL;
+	int i;
+	int j = 0;
+	u16 min_vfreq;
+	u16 max_vfreq;
+
+	if (edid == NULL || edid->extensions == 0)
+		return;
+
+	/* Find DisplayID extension */
+	for (i = 0; i < edid->extensions; i++) {
+		edid_ext = (void *)(edid + (i + 1));
+		if (edid_ext[0] == DISPLAYID_EXT)
+			break;
+	}
+
+	if (edid_ext == NULL)
+		return;
+
+	while (j < EDID_LENGTH) {
+		/* Get dynamic video timing range from DisplayID if available */
+		if (EDID_LENGTH - j > 13 && edid_ext[j] == 0x25	&&
+		    (edid_ext[j+1] & 0xFE) == 0 && (edid_ext[j+2] == 9)) {
+			min_vfreq = edid_ext[j+9];
+			if (edid_ext[j+1] & 7)
+				max_vfreq = edid_ext[j+10] + ((edid_ext[j+11] & 3) << 8);
+			else
+				max_vfreq = edid_ext[j+10];
+
+			if (max_vfreq && min_vfreq) {
+				connector->display_info.monitor_range.max_vfreq = max_vfreq;
+				connector->display_info.monitor_range.min_vfreq = min_vfreq;
+
+				return;
+			}
+		}
+		j++;
+	}
+}
+
 static int parse_amd_vsdb(struct amdgpu_dm_connector *aconnector,
 			  struct edid *edid, struct amdgpu_hdmi_vsdb_info *vsdb_info)
 {
@@ -10752,6 +10795,11 @@ void amdgpu_dm_update_freesync_caps(struct drm_connector *connector,
 	if (!adev->dm.freesync_module)
 		goto update;
 
+	/* Some eDP panels only have the refresh rate range info in DisplayID */
+	if ((connector->display_info.monitor_range.min_vfreq == 0 ||
+	     connector->display_info.monitor_range.max_vfreq == 0))
+		parse_edid_displayid_vrr(connector, edid);
+
 	if (edid && (sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT ||
 		     sink->sink_signal == SIGNAL_TYPE_EDP)) {
 		bool edid_check_required = false;
-- 
2.43.0



