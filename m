Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024BD1CA8F;
	Mon,  1 Apr 2024 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988696; cv=none; b=cfB1hzHK5VFavMS5Po7f8haTbaCvFJ98ZU7emtcZc2dwIQ54vy4Y+r5GKq2m02/LSWfVZ220L0Gbi2bfbHHOPgozxJhsEYtygsAG0BkQnHFtpPRDuBC1ghc91Xz3MLm6HWRrnsUixUrmJUrmDObFq+eOrplAIRZ8f1kmz4nK5JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988696; c=relaxed/simple;
	bh=pf2kwIwDoO+PMBtVgRcyJM/hEXZq4ejAi3o+Wu9dBhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riJJOzv79fZ9Zjra61mtLN+rMMSPi1wGrLMr8SyTjaug3hQf+hXAtCn7xyFF3C4vpDoRvehg4gZuH/ewdhe9v1dxg4d9NjwXcgb+GXNxezhGcLiHXanGH4fREC8tm1OPoXq2hZMg3JguEjhZ8Dwki1W0WN+67TqshwqYTHQfMiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZCqMm11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZCqMm11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699DFC433F1;
	Mon,  1 Apr 2024 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988695;
	bh=pf2kwIwDoO+PMBtVgRcyJM/hEXZq4ejAi3o+Wu9dBhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZCqMm11CboXbPOkzu/ffeQbmTMQ3JY0qNAmiOj3h49B/3Fs/8X5u73T8ULGZ0KlY
	 DOSNCya04H+w6JhQqyXtFNT3uRU7a9okp8aw9XiImmMKbnuYge3AXwRp6frh6wNtuI
	 aYHM2s/FsC8qEJG2mhirxO7dl1zXw/sH3Dj75bsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 233/432] drm/amd/display: Use freesync when `DRM_EDID_FEATURE_CONTINUOUS_FREQ` found
Date: Mon,  1 Apr 2024 17:43:40 +0200
Message-ID: <20240401152600.084373310@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 2f14c0c8cae8e9e3b603a3f91909baba66540027 upstream.

The monitor shipped with the Framework 16 supports VRR [1], but it's not
being advertised.

This is because the detailed timing block doesn't contain
`EDID_DETAIL_MONITOR_RANGE` which amdgpu looks for to find min and max
frequencies.  This check however is superfluous for this case because
update_display_info() calls drm_get_monitor_range() to get these ranges
already.

So if the `DRM_EDID_FEATURE_CONTINUOUS_FREQ` EDID feature is found then
turn on freesync without extra checks.

v2: squash in fix from Harry

Closes: https://www.reddit.com/r/framework/comments/1b4y2i5/no_variable_refresh_rate_on_the_framework_16_on/
Closes: https://www.reddit.com/r/framework/comments/1b6vzcy/framework_16_variable_refresh_rate/
Closes: https://community.frame.work/t/resolved-no-vrr-freesync-with-amd-version/42338
Link: https://gist.github.com/superm1/e8fbacfa4d0f53150231d3a3e0a13faf
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10839,18 +10839,24 @@ void amdgpu_dm_update_freesync_caps(stru
 	if (!adev->dm.freesync_module)
 		goto update;
 
-	if (sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT
-		|| sink->sink_signal == SIGNAL_TYPE_EDP) {
+	if (edid && (sink->sink_signal == SIGNAL_TYPE_DISPLAY_PORT ||
+		     sink->sink_signal == SIGNAL_TYPE_EDP)) {
 		bool edid_check_required = false;
 
-		if (edid) {
-			edid_check_required = is_dp_capable_without_timing_msa(
-						adev->dm.dc,
-						amdgpu_dm_connector);
+		if (is_dp_capable_without_timing_msa(adev->dm.dc,
+						     amdgpu_dm_connector)) {
+			if (edid->features & DRM_EDID_FEATURE_CONTINUOUS_FREQ) {
+				freesync_capable = true;
+				amdgpu_dm_connector->min_vfreq = connector->display_info.monitor_range.min_vfreq;
+				amdgpu_dm_connector->max_vfreq = connector->display_info.monitor_range.max_vfreq;
+			} else {
+				edid_check_required = edid->version > 1 ||
+						      (edid->version == 1 &&
+						       edid->revision > 1);
+			}
 		}
 
-		if (edid_check_required == true && (edid->version > 1 ||
-		   (edid->version == 1 && edid->revision > 1))) {
+		if (edid_check_required) {
 			for (i = 0; i < 4; i++) {
 
 				timing	= &edid->detailed_timings[i];


