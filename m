Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56133AAF43;
	Sat, 17 Oct 2026 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255064; cv=none; b=HqWXpVoaYekNbfwvG2iSey5mFWRofYJxdGLuy1znuikm5A+xr2gCA3V8P/1AoC8JGZtmEwlZwFHXTmEAX698BBD/EaZcjNpH3GApMcg4JVuYCZyK15sM9RJrWXXK7inPZu0B45AEAAEvD12g/7k3msfTyAPVljonwzH0fsau7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255064; c=relaxed/simple;
	bh=lDmXF3CsVzembjgiUVuVIiUOBdpJDqAFhBP8hkBY5Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=br7dMSmreuQmZG+egRC5KaU+C+eqXQ3bjjZfHox49N0kc3ioeo4qTQNy9VUmurjaZ7UzA2f4T1GRGN+/7OD9ZSsXrQoDUp6Mf7CpLflh2FOVIfb+1vFmeB/vbF13fXd2ekRdc2E8Kl6EsLFMQ82xWSXouIUMWjZoLG23xjE/p/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoKDY6zA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoKDY6zA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B151F000C4;
	Sat, 17 Oct 2026 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255063;
	bh=B3FMZBzYvG5WRZlV3Gs0zd6aspuuarkgF6ayA0eNSMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoKDY6zAEBibIMLj24SOsJyqYsD8ti99Az/F2Xsu2x7g8jPYnPCyCkw1nvRwwZZlC
	 8jKw3WOVjq/tiN/rf/EBwOfq5XfGN/9Wqs8eu/09oTbLqwP+AbXSJeEP//bqKGwLfR
	 5GlD+iXTBSzTmPEh9LA1X15+i88c8HzTDcfKsCw8=
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
Subject: [PATCH 6.12 651/869] drm/amd/display: disable replay when crc source is enabled
Date: Sat, 17 Oct 2026 17:58:12 +0200
Message-ID: <20261017160053.696622960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9682c190e9524..e447ab49cf3ca 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -732,6 +732,7 @@ struct amdgpu_dm_connector {
 
 	int sr_skip_count;
 	bool disallow_edp_enter_psr;
+	bool disallow_edp_enter_replay;
 
 	/* Record progress status of mst*/
 	uint8_t mst_status;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
index 41812081418e3..b4a769216d609 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crc.c
@@ -31,6 +31,7 @@
 #include "dc.h"
 #include "amdgpu_securedisplay.h"
 #include "amdgpu_dm_psr.h"
+#include "amdgpu_dm_replay.h"
 
 static const char *const pipe_crc_sources[] = {
 	"none",
@@ -216,6 +217,7 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
 {
 	struct amdgpu_device *adev = drm_to_adev(crtc->dev);
 	struct dc_stream_state *stream_state = dm_crtc_state->stream;
+	struct amdgpu_dm_connector *aconnector = NULL;
 	bool enable = amdgpu_dm_is_valid_crc_source(source);
 	int ret = 0;
 
@@ -223,11 +225,22 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
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
@@ -250,6 +263,12 @@ int amdgpu_dm_crtc_configure_crc_source(struct drm_crtc *crtc,
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
index 41f07f13a7b57..7db927dcfe8d2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_replay.c
@@ -153,10 +153,17 @@ bool amdgpu_dm_replay_enable(struct dc_stream_state *stream, bool wait)
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



