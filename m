Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EA1151CD6;
	Tue, 20 Feb 2024 21:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463853; cv=none; b=IL4ZL5wQL7TcW0y8B6PBBce4SJoRKcck2dmrnU/KiN0rgf3NhQ3EaGnIandpVwNF7jcZy54+lgrEcrAJTphtfph66wN0tVck4jPytqsWdN/iHWC9uVvn0yIKvt0dKqk6V+mhd7xv6BXGdcA9OZIyHKrFxI2fTRrAVXchUWWDtck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463853; c=relaxed/simple;
	bh=LkcEOjjM6WamFbHFtQIM8/xk+OKLg7d2ncZ7Zpt6MJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhL/aKH3kqgSCDPZaAlsGLSznB2r4vdhm3kE/ZaEH5RnkM0PiMZ5Yv6kev4400LywQx3pYwCDKRHT6pteAZcQGt3rS4TmS3SQj6gzGGvI47gQ0Vx16Io+xLUNeNQRrtjBZKLcr4TF59Qz/it2X7mxsz/ncPD6yG3MqxlVLZsgPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NuwH0Zx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NuwH0Zx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99808C433F1;
	Tue, 20 Feb 2024 21:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463853;
	bh=LkcEOjjM6WamFbHFtQIM8/xk+OKLg7d2ncZ7Zpt6MJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NuwH0Zx9dhKSkZJR2vJwRPoOLHeCy/PPzwOxA8s0+I6VundZcQxxv9TSWQ7UFjx5/
	 YsvuaCIPy68kBsYjhDVjxLv80bBQeNE62SQkT/ZxaONE342LMn093ywvPW3KD67xyh
	 v7y5jMwjeZ6Cr8H5EZKtltS08mNKAWDh2OpR2CRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 173/331] drm/amd/display: Preserve original aspect ratio in create stream
Date: Tue, 20 Feb 2024 21:54:49 +0100
Message-ID: <20240220205642.956026031@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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
@@ -6072,7 +6072,9 @@ create_stream_for_sink(struct amdgpu_dm_
 		if (recalculate_timing) {
 			freesync_mode = get_highest_refresh_rate_mode(aconnector, false);
 			drm_mode_copy(&saved_mode, &mode);
+			saved_mode.picture_aspect_ratio = mode.picture_aspect_ratio;
 			drm_mode_copy(&mode, freesync_mode);
+			mode.picture_aspect_ratio = saved_mode.picture_aspect_ratio;
 		} else {
 			decide_crtc_timing_for_drm_display_mode(
 					&mode, preferred_mode, scale);


