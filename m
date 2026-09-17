Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D583051AEF4;
	Thu, 17 Sep 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667022; cv=none; b=quqzU9e/MFJfLpuwPc4u6mYDhSGFj3iH/YwWe1eviovDUl4os6LN8LU7ROvBkcEaf1jvsMhcIMQYsK/9Uk/++2zzqsWlawBq9TWlTIx50r846oHL1qoHG4UEFEpk3wFjzRFoi90SwcJcrslAYraoqpqezkx1bmSRdouh7/SFkiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667022; c=relaxed/simple;
	bh=X8Rb8U99BaFBp0mBZB5e7WOQ6DhR7hIXWQJo+YTbH6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYRqIq5cYvh5TVD7Xidpwih8yaeHN5z9HysQD+fpSzlYmVCq/lClX/QrRb+9zRFnarI/g0xAKJVcEtwAWVMO7rdJRE2nCj1NBzpuJeMDMGkp8K4l1jo0TErw+ooK2R2S3n0Q3/U6ffSTZZM/uErlYC/8nOAvVvcGFl52bk21mvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9RaEtb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9RaEtb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F91E1F000FF;
	Thu, 17 Sep 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667020;
	bh=u2JqWKhz4u5/Uwp31nopRkwjBAHXyFRH9gIYpsw79ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9RaEtb9s/gNwbmtlK4lhw/qJ+y8sTWkyawvsz+i1LnJSL45/sUGG6ACjkkqlrN8Q
	 Qw10/f4PwnZLrefEYeWQ6aJEBkWG7Op2L/9DcWDIEZjMQ9K1aC8qABXGfSwoelNTlP
	 lZ5mw00LiOUFrcf6ZVet0Z9BgZFSh3iKDG3XZc2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyajit Roy <sroy14@alum.utk.edu>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1203/1250] drm/amd/display: Honor Broadcast RGB for BT.2020 RGB output
Date: Thu, 17 Sep 2026 16:16:38 +0100
Message-ID: <20260917151624.889145650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Satyajit Roy <sroy14@alum.utk.edu>

[ Upstream commit 7fca7acd60a228b62b4e9efa5f184738041e9564 ]

amdgpu_dm_get_output_color_space() applies the Broadcast RGB connector
property to default RGB output, but always selects full-range output for
BT.2020 RGB. Consequently, explicitly selecting Limited has no effect on
the output CSC or AVI InfoFrame when HDR uses BT.2020 RGB.

Select COLOR_SPACE_2020_RGB_LIMITEDRANGE when the output encoding is RGB
and Broadcast RGB is Limited. Keep Automatic and Full at full range, and
leave YCbCr output unchanged.

Add KUnit coverage for limited-range RGB output through both BT.2020
connector colorspace values.

Fixes: 6eb4c13a3845 ("drm/amd/display: Support "Broadcast RGB" drm property")
Signed-off-by: Satyajit Roy <sroy14@alum.utk.edu>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 022236eaa63bbf65761aa8aec43f661451a94654)
Cc: stable@vger.kernel.org
[ adapted the hunk to the older get_output_color_space() function in amdgpu_dm.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6511,10 +6511,14 @@ get_output_color_space(const struct dc_c
 		break;
 	case DRM_MODE_COLORIMETRY_BT2020_RGB:
 	case DRM_MODE_COLORIMETRY_BT2020_YCC:
-		if (dc_crtc_timing->pixel_encoding == PIXEL_ENCODING_RGB)
-			color_space = COLOR_SPACE_2020_RGB_FULLRANGE;
-		else
+		if (dc_crtc_timing->pixel_encoding == PIXEL_ENCODING_RGB) {
+			if (connector_state->hdmi.broadcast_rgb == DRM_HDMI_BROADCAST_RGB_LIMITED)
+				color_space = COLOR_SPACE_2020_RGB_LIMITEDRANGE;
+			else
+				color_space = COLOR_SPACE_2020_RGB_FULLRANGE;
+		} else {
 			color_space = COLOR_SPACE_2020_YCBCR_LIMITED;
+		}
 		break;
 	case DRM_MODE_COLORIMETRY_DEFAULT: // ITU601
 	default:


