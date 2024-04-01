Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD88495F0;
	Mon,  1 Apr 2024 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989927; cv=none; b=cC/BmgJLq7baOcNs6kHUmz0Mb0DRf5anOsVE16dJmZD/QsSSsv8KGuZwZodHVCEV+Bot73AqL65HnCWJ6d9nplJ52Y9i0NyC3dYemtIEUJXBnAXQxbwkm1MnODAEAtQsyFrJMffn9cel/MKDv28+x/YFMrj7LNm7O87niktkNjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989927; c=relaxed/simple;
	bh=Zt1NRuVuXcuovdgA+BU8ApqsZdxrOpxhGya+B8oQaq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmlOd73YuDyM9F672WHLzcV0edFxxCv3BL4id7P6BrP1MdPt+uCu2PtIL8HeY5na9pu9bDQRD2fJxTsQRsrSeNfmRKZnl+AaNJdXN9X0rF85D1ap1ZMZsAZEJQ/7frpQCYINmew4PBqePlU2y/jHh65HE0Bl1MPR4UCVODO0+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pR8WjY3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pR8WjY3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BF2C43142;
	Mon,  1 Apr 2024 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989927;
	bh=Zt1NRuVuXcuovdgA+BU8ApqsZdxrOpxhGya+B8oQaq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pR8WjY3EHPgwgBkUBYKN46Rs13GLe6N8m2oeBnQXruhJ5NY783wjmMKmZEcpRCxqx
	 yppI0t7r/1tcad1vTQPWWsntGVuAzB9hGY4Oj5/GCqnPR1GhRMwATURRiqXzDDhKEw
	 bSORX0Mo0BAjQySvMb+XdNhfa6q7Ib4IiRMoJ/aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 195/396] drm/amd/display: Use freesync when `DRM_EDID_FEATURE_CONTINUOUS_FREQ` found
Date: Mon,  1 Apr 2024 17:44:04 +0200
Message-ID: <20240401152553.750604080@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
@@ -10746,18 +10746,24 @@ void amdgpu_dm_update_freesync_caps(stru
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


