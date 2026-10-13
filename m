Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F48D43CEF3;
	Tue, 13 Oct 2026 12:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894090; cv=none; b=l4hxIb/qig4eGtLF4Pdv4RO2Cm75KpZti8o2oF1EKfTIjtk5vFSgTEQRMi+95azIyboesaghwbj9rzf6kjTcLvCHRGzDqKN37q6+sS4XHv97g4bg2H10oQFX6s35XEmesPXY9idOfUpANTQwNwklcPRC0T/mqhBX1lX23LyZuTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894090; c=relaxed/simple;
	bh=iXk12KPFFmfehkBEIBOkHOh/kYWW82DEAck1whP9PGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R83wEW6vJElFjZl08F8BxNRPC+wNq0qJdaeUU3TwYmxEiVWbU4Jai4bYo/dZYNE3neNNFwoyqs0FKFLbXfqd72ctA1RyvgoKjCiTGXHuraXKRblUFUcMK/tEUC5TCtTVC9naoUvxLgEYJ60QTLPOoOLnpnbb/lbwp8Mvlqz0Zuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x82mT0m/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x82mT0m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC78A1F000FF;
	Tue, 13 Oct 2026 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894089;
	bh=LROM3quiQFvAPbfoJJDjhKY0OLO3OBMK9a64fpEgnR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x82mT0m/4z5TT2ta8mPawMS4pIznFr3Sj8eZw8j1KKHwLvV4WUdjLCmVLsWZTfeaC
	 ptm4QfF1C94LYEL9parRq8COwU/glg9u9HtBsmczgtWc5HJZDyXe391LCcjKvcSU3P
	 K6blGerGPAbKZ3dYTuNQKFW4EaNVS27ty+HlsJeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"ChiaHsuan (Tom) Chung" <chiahsuan.chung@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Matthew Stewart <matthew.stewart2@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 436/621] drm/amd/display: disable replay when crc source is enabled
Date: Tue, 13 Oct 2026 13:37:11 +0200
Message-ID: <20261013112931.179475649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Wu <ray.wu@amd.com>

[ Upstream commit a036db3953140d5c2816b056aa3e73b8e98d9bc0 ]

[Why]
IGT CRC tests fail on replay panels due to invalid CRC values
captured when replay is active.

[How]
- Disable replay when CRC source is enabled; set flag to
  prevent unexpected re-enable
- Reset flag when CRC source is disabled to allow replay

Reviewed-by: ChiaHsuan (Tom) Chung <chiahsuan.chung@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Matthew Stewart <matthew.stewart2@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 261e0fe4e2c9 ("drm/amd/display: Resize MST HDCP per-connector arrays to 32")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  1 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c | 25 ++++++++++++++++---
 .../amd/display/amdgpu_dm/amdgpu_dm_replay.c  |  7 ++++++
 3 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index a83fdd7b644ab..284cfcd238a29 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -830,6 +830,7 @@ struct amdgpu_dm_connector {
 
 	int sr_skip_count;
 	bool disallow_edp_enter_psr;
+	bool disallow_edp_enter_replay;
 
 	/* Record progress status of mst*/
 	uint8_t mst_status;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index 596a97092e0dd..84d7a79e52678 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -32,6 +32,7 @@
 #include "dc.h"
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_dm_psr.h"
+#include "amdgpu_dm_replay.h"
 
 static const char *const pipe_crc_sources[] = {
 	"none",
@@ -500,6 +501,7 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
 {
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	struct dc_stream_state *stream_state = dm_crtc_state->stream;
+	struct amdgpu_dm_connector *aconnector = NULL;
 	bool enable = amdgpu_dm_is_valid_crc_source(source);
 	int ret = 0;
 
@@ -507,11 +509,22 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
 	if (!stream_state)
 		return -EINVAL;
 
+	/* Get connector from stream */
+	aconnector = (struct amdgpu_dm_connector *)stream_state->dm_stream_context;
+
 	mutex_lock(&adev->dm.dc_lock);
 
-	/* For PSR1, check that the panel has exited PSR */
-	if (stream_state->link->psr_settings.psr_version < DC_PSR_VERSION_SU_1)
-		amdgpu_dm_psr_wait_disable(stream_state);
+
+	if (enable) {
+		/* For PSR1, check that the panel has exited PSR */
+		if (stream_state->link->psr_settings.psr_version < DC_PSR_VERSION_SU_1)
+			amdgpu_dm_psr_wait_disable(stream_state);
+
+		/* Set flag to disallow enter replay when CRC source is enabled */
+		if (aconnector)
+			aconnector->disallow_edp_enter_replay = true;
+		amdgpu_dm_replay_disable(stream_state);
+	}
 
 	/* Enable or disable CRTC CRC generation */
 	if (dm_is_crc_source_crtc(source) || source == AMDGPU_DM_PIPE_CRC_SOURCE_NONE) {
@@ -534,6 +547,12 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
 					    DYN_EXPANSION_AUTO);
 	}
 
+	if (!enable) {
+		/* Clear flag to allow enter replay when CRC source is disabled */
+		if (aconnector)
+			aconnector->disallow_edp_enter_replay = false;
+	}
+
 unlock:
 	mutex_unlock(&adev->dm.dc_lock);
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c
index 80704d709e44a..024bae662116c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c
@@ -154,10 +154,17 @@ bool amdgpu_dm_replay_enable(struct dc_stream_state *stream, bool wait)
 {
 	bool replay_active = true;
 	struct dc_link *link = NULL;
+	struct amdgpu_dm_connector *aconnector = NULL;
 
 	if (stream == NULL)
 		return false;
 
+	/* Check if replay is disabled by connector flag */
+	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
+	if (!aconnector || aconnector->disallow_edp_enter_replay) {
+		return false;
+	}
+
 	link = stream->link;
 
 	if (link) {
-- 
2.53.0



