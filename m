Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5018F5C;
	Mon,  1 Apr 2024 16:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990196; cv=none; b=ptPCZi7lRe0RWe68Aj5tH7BuGG+CqY0aCGdbRzCJO1CewTOiv38u1nE8s5DqXuooZKTiqpEirF2gAnkuDwYUBiodxo1oTa6JyLxUOBtmp32H73WrrTd1cdNOQcapkRza3zJnwfx8zzOYFEGt7irqMd4p2K7MJhL5RPPzG+rmG04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990196; c=relaxed/simple;
	bh=k4c28xBGYfeisFJ1sE/DVYVio82JrapwXdqUnHs8L9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcYo0H3VzbaDu9KhC9W6ucX1XIMsL5YZJynwMNZxa2TbZfdSpfZgxCKwebPvF5htyXRF0HT2zI+zlFjZmR7B650b6yGON0bCZsJaGzLpsrsHK8KQQJceC4BgQ/TgP552YeOK04XcU8/cEyvZr7u4FRO3PJ5VruK9dB6fEzBOMJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCUdUY+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCUdUY+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1595EC433C7;
	Mon,  1 Apr 2024 16:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990196;
	bh=k4c28xBGYfeisFJ1sE/DVYVio82JrapwXdqUnHs8L9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCUdUY+b62XSXPYB9oJm6DFTYodg9GQtt7KmtBXY6BuNMpjhZBfZGKr9BLuStmykX
	 03zD02y98MIp10XxfD0BefTM10wEDnqA8MLZnIldkQkCe11QHR2T3IzvVNBJbdYeD8
	 vo0qk1WZWLsutw26I9wTLnzww82WZQ1/UfWtiICc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mano=20S=C3=A9gransan?= <mano.segransan@protonmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 248/396] drm/amd/display: handle range offsets in VRR ranges
Date: Mon,  1 Apr 2024 17:44:57 +0200
Message-ID: <20240401152555.306337982@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 937844d661354bf142dc1c621396fdab10ecbacc upstream.

Need to check the offset bits for values greater than 255.

v2: also update amdgpu_dm_connector values.

Suggested-by: Mano Ségransan <mano.segransan@protonmail.com>
Tested-by: Mano Ségransan <mano.segransan@protonmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3203
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10783,14 +10783,23 @@ void amdgpu_dm_update_freesync_caps(stru
 				if (range->flags != 1)
 					continue;
 
-				amdgpu_dm_connector->min_vfreq = range->min_vfreq;
-				amdgpu_dm_connector->max_vfreq = range->max_vfreq;
-				amdgpu_dm_connector->pixel_clock_mhz =
-					range->pixel_clock_mhz * 10;
-
 				connector->display_info.monitor_range.min_vfreq = range->min_vfreq;
 				connector->display_info.monitor_range.max_vfreq = range->max_vfreq;
 
+				if (edid->revision >= 4) {
+					if (data->pad2 & DRM_EDID_RANGE_OFFSET_MIN_VFREQ)
+						connector->display_info.monitor_range.min_vfreq += 255;
+					if (data->pad2 & DRM_EDID_RANGE_OFFSET_MAX_VFREQ)
+						connector->display_info.monitor_range.max_vfreq += 255;
+				}
+
+				amdgpu_dm_connector->min_vfreq =
+					connector->display_info.monitor_range.min_vfreq;
+				amdgpu_dm_connector->max_vfreq =
+					connector->display_info.monitor_range.max_vfreq;
+				amdgpu_dm_connector->pixel_clock_mhz =
+					range->pixel_clock_mhz * 10;
+
 				break;
 			}
 


