Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF913A256;
	Tue, 14 May 2024 10:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683081; cv=none; b=KjvWkzvDfLPZhRukQOlRNY1+qfG6z0ffZ8dcA7uwa61eeKCnZEh3n8Pa/QYIUTVOiWfBw3rbUyAfOBhbxRcJBJeeA3lC7cb82nYPxry8SexKge4nBHTPt30MnQIaKY8l5Yd3SHU+H51ITyz4g6p/IMEyi+TWjc6XhgLXePuYuqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683081; c=relaxed/simple;
	bh=XciNWBk3ZvKLczCN5rSQe2YTLBYpqnOxWW8cU3rPc9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSrRja/t+9ELLvyDN+H7Y1KRY9WfvCnjjLrkRWjT0QVUw8IdGeaq9wIXLYd2SmipQv8mQBOSxoubALsjZNJGEpN1SwZdsucqHQYVJmj7tGupVnt+E7E/Fe6L/xcakvsc3ZHUhQccv76CrFBEUj5CpwaDX7Qz/9+nqU7NfcZdkVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRpMU9RO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRpMU9RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C6EC2BD10;
	Tue, 14 May 2024 10:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683081;
	bh=XciNWBk3ZvKLczCN5rSQe2YTLBYpqnOxWW8cU3rPc9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRpMU9ROjqqNpBEEjQbKNTk+Jydm3qMXL2hE7Sj3v39tjYqr2pu5TtD+PTGl4lV/I
	 5nSuqD3ldHA1VrhKQ/AAzvVjntAd8N0ZUigc35XWhkeX5bCIQBE4KWjftik16U+IRW
	 XJnju/6cA7F3XiRiNTubN8GxQ3q5rbP538dUR+cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 163/336] drm/amd/display: Skip on writeback when its not applicable
Date: Tue, 14 May 2024 12:16:07 +0200
Message-ID: <20240514101044.759448477@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit ecedd99a9369fb5cde601ae9abd58bca2739f1ae ]

[WHY]
dynamic memory safety error detector (KASAN) catches and generates error
messages "BUG: KASAN: slab-out-of-bounds" as writeback connector does not
support certain features which are not initialized.

[HOW]
Skip them when connector type is DRM_MODE_CONNECTOR_WRITEBACK.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3199
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0d3e553647993..9044214dfdbdf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3028,6 +3028,10 @@ static int dm_resume(void *handle)
 	/* Do mst topology probing after resuming cached state*/
 	drm_connector_list_iter_begin(ddev, &iter);
 	drm_for_each_connector_iter(connector, &iter) {
+
+		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+			continue;
+
 		aconnector = to_amdgpu_dm_connector(connector);
 		if (aconnector->dc_link->type != dc_connection_mst_branch ||
 		    aconnector->mst_root)
@@ -5879,6 +5883,9 @@ get_highest_refresh_rate_mode(struct amdgpu_dm_connector *aconnector,
 		&aconnector->base.probed_modes :
 		&aconnector->base.modes;
 
+	if (aconnector->base.connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
+		return NULL;
+
 	if (aconnector->freesync_vid_base.clock != 0)
 		return &aconnector->freesync_vid_base;
 
@@ -8633,10 +8640,10 @@ static void amdgpu_dm_commit_audio(struct drm_device *dev,
 		if (!drm_atomic_crtc_needs_modeset(new_crtc_state))
 			continue;
 
+notify:
 		if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
 			continue;
 
-notify:
 		aconnector = to_amdgpu_dm_connector(connector);
 
 		mutex_lock(&adev->dm.audio_lock);
-- 
2.43.0



