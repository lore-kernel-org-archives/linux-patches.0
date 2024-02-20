Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C62151CCD;
	Tue, 20 Feb 2024 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465028; cv=none; b=APx8RmdSj8jAoiP3eFsfgQ+rbg6Ja4DP00hzA+gwcxe0Yl8/RFoxShjifN1UTXK6Bn1OXC2QeVfuFeZY/m3hbLzCdSOr3vgmmuXb/YUiq+sVUcJTIRIB0loEXR2zaGkynknbxcKZCbW43/GheWTpjQkNloFam3VoyokVDpY+A0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465028; c=relaxed/simple;
	bh=AlVHxQfyF1Q4EQsBUh/ufWalk1NheVqJGJQD5+C+oj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyINZoV36cZG1rXSGsPyNVluYCHKIzQx6JeDQzEATrcIseqKr2HzWeTxygi5YykxV7R1KeLwLoGRENK0nPKnjfnbCJzqQeZBuMRh0tw7x6bDPo53aQQc2BUi8PZndKSwiCEOIiuslHenXF7EWcEqFN7TdAZizLuALQzNai74qqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huXGqjtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huXGqjtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE06C433C7;
	Tue, 20 Feb 2024 21:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465028;
	bh=AlVHxQfyF1Q4EQsBUh/ufWalk1NheVqJGJQD5+C+oj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huXGqjtgBafIaPPa4xYJ+uGH+WjqI2mGOMVk/0hqdKNck43tcPxP5voG6F0cBC2Ma
	 ZK2Pn0bRUrN7G97/DrYGyqQUvBhCojWlwgBIE/5ils9CF8yW1ODUhskDUv6zsz9xXG
	 Br+7YmtitrHl6gRKOuEGjeRRfHH10iYm1+eV+VMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 213/309] drm/amd/display: Preserve original aspect ratio in create stream
Date: Tue, 20 Feb 2024 21:56:12 +0100
Message-ID: <20240220205639.837104078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Tom Chung <chiahsuan.chung@amd.com>

commit deb110292180cd501f6fde2a0178d65fcbcabb0c upstream.

[Why]
The original picture aspect ratio in mode struct may have chance be
overwritten with wrong aspect ratio data in create_stream_for_sink().
It will create a different VIC output and cause HDMI compliance test
failed.

[How]
Preserve the original picture aspect ratio data during create the
stream.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6110,7 +6110,9 @@ create_stream_for_sink(struct drm_connec
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
 			drm_mode_copy(&saved_mode, &mode);
+			saved_mode.picture_aspect_ratio = mode.picture_aspect_ratio;
 			drm_mode_copy(&mode, freesync_mode);
+			mode.picture_aspect_ratio = saved_mode.picture_aspect_ratio;
 		} else {
 			decide_crtc_timing_for_drm_display_mode(
 					&mode, preferred_mode, scale);


