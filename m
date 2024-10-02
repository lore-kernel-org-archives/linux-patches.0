Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E61D0403;
	Wed,  2 Oct 2024 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875743; cv=none; b=l3h3rnQvHxh+X6q3GMFtOQ1nM8MeTbCiQG+Tr6MytiPOlFWrp8Z/+K0604RWugXJwixebsUm4LF5NK9aGmRTMI0rzUp1I7jek/wc2b7KYry8ggcBKWfXLcd0502NJYd/9UW4cFmeM1FwTGq6/1XkTb/HoGuf7sG6aFs29CAoa0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875743; c=relaxed/simple;
	bh=QwZttdrryEXkIrkxEy/18LIzjcxoy/FBu/ha61NnZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKUV1DgtCq5X2rZ66GDveH0zZO5RngF7Yx0lfVxxxG/gbaVQHWNhWcIiokRDNN9n/UwxWMTxRQEL2eRt3SwpCW0srZAurzqh1D5q+s2F/3yb9+D7PaWZP0y24/5DydlGD8CgRuMMUReGxH/VSZ5Tz8JrhTSoay+1TzIczKooXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU8cTUAV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU8cTUAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51594C4CECD;
	Wed,  2 Oct 2024 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875742;
	bh=QwZttdrryEXkIrkxEy/18LIzjcxoy/FBu/ha61NnZz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU8cTUAVGC5afTTBLqQqozj17I/UyZVmsIPv73BW+l5MGOzkQcqcIYOwMvUEUI0Ic
	 vsn2IyHi0pwIuOaORbwX+YVH/6eNv+HqnUU710f6PILsJfmdvwIEmtsJzE3EdwpMnt
	 vO0oVKJeIKPdMsk3eIBMbRDNRJ1qBZHRbfLXWeAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Sun peng Li <sunpeng.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 205/695] drm/amd/display: Reset VRR config during resume
Date: Wed,  2 Oct 2024 14:53:23 +0200
Message-ID: <20241002125830.644689558@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Chung <chiahsuan.chung@amd.com>

[ Upstream commit df18a4de9e77ad92c472fd1eb0fb1255d52dd4cd ]

[Why]
After resume the system, the new_crtc_state->vrr_infopacket does not
synchronize with the current state.  It will affect the
update_freesync_state_on_stream() does not update the state correctly.

The previous patch causes a PSR SU regression that cannot let panel go
into self-refresh mode.

[How]
Reset the VRR config during resume to force update the VRR config later.

Fixes: eb6dfbb7a9c6 ("drm/amd/display: Reset freesync config before update new state")
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Reviewed-by: Sun peng Li <sunpeng.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 511d46d38d6af..ba5f98bd7b391 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -176,6 +176,7 @@ MODULE_FIRMWARE(FIRMWARE_DCN_401_DMUB);
 static int amdgpu_dm_init(struct amdgpu_device *adev);
 static void amdgpu_dm_fini(struct amdgpu_device *adev);
 static bool is_freesync_video_mode(const struct drm_display_mode *mode, struct amdgpu_dm_connector *aconnector);
+static void reset_freesync_config_for_crtc(struct dm_crtc_state *new_crtc_state);
 
 static enum drm_mode_subconnector get_subconnector_type(struct dc_link *link)
 {
@@ -3239,8 +3240,11 @@ static int dm_resume(void *handle)
 	drm_connector_list_iter_end(&iter);
 
 	/* Force mode set in atomic commit */
-	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i)
+	for_each_new_crtc_in_state(dm->cached_state, crtc, new_crtc_state, i) {
 		new_crtc_state->active_changed = true;
+		dm_new_crtc_state = to_dm_crtc_state(new_crtc_state);
+		reset_freesync_config_for_crtc(dm_new_crtc_state);
+	}
 
 	/*
 	 * atomic_check is expected to create the dc states. We need to release
-- 
2.43.0



