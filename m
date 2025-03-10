Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4E32D023;
	Mon, 10 Mar 2025 17:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629345; cv=none; b=L2k7u+dHowYBOJlzIA2QAfFnbHrsCYFFEKmE9qley6iZsNdJbYTv47uH5GKoFqTvzVV16q6YL90W3BuK03Ldymukc1LLcY1ZxwBs3Dod9kbtJ9dfuVPQMV6HAA+iGJkLEvfH/xqkBSmqbJJ9MBklMm1L9qDM8wDhp3sOlsBEWNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629345; c=relaxed/simple;
	bh=cmCpbw0jC9W2elNSh31f92vGuX+yukurhwQClCOkrRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lAs+wlDCfQb935mVOCB9az/mwVTAv0hOsS62OlnStcwVdTA1k4kFNrJF303I3wHddr+5hnE9LZkxvXhxA3EPGJePFYAOmUN7IXFC1pMx3BDqAyhPIlWecBv7wT1LW2Djt+FdxGo0vj/4HkISaxEmSK1zE+BwoFiGhnzpbNcAXDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTyUkawF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTyUkawF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB40FC4CEE5;
	Mon, 10 Mar 2025 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629345;
	bh=cmCpbw0jC9W2elNSh31f92vGuX+yukurhwQClCOkrRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTyUkawF0c6S8mKwcNMFJ4MARGtKrG1ioxImSufkLM+VXIfXXZ8DNZPci/I0Nwsqs
	 zukKRsApWBx0vV63V9yZpKqOf4OS6bQ2nJv6vz58DIpANAD/iYZ6C8Ss0LCkccwvHV
	 /hJ+nS4cQUyLr5uTQNKv4I3mI7oVKsaIoU1Cn8GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 263/620] drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes
Date: Mon, 10 Mar 2025 18:01:49 +0100
Message-ID: <20250310170556.007600560@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit c7b49506b3ba7a62335e6f666a43f67d5cd9fd1e upstream.

I'm seeing underruns with these 64bpp YUV formats on TGL.

The weird details:
- only happens on pipe B/C/D SDR planes, pipe A SDR planes
  seem fine, as do all HDR planes
- somehow CDCLK related, higher CDCLK allows for bigger plane
  with these formats without underruns. With 300MHz CDCLK I
  can only go up to 1200 pixels wide or so, with 650MHz even
  a 3840 pixel wide plane was OK
- ICL and ADL so far appear unaffected

So not really sure what's the deal with this, but bspec does
state "64-bit formats supported only on the HDR planes" so
let's just drop these formats from the SDR planes. We already
disallow 64bpp RGB formats.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241218173650.19782-2-ville.syrjala@linux.intel.com
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
(cherry picked from commit 35e1aacfe536d6e8d8d440cd7155366da2541ad4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/skl_universal_plane.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -98,8 +98,6 @@ static const u32 icl_sdr_y_plane_formats
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_sdr_uv_plane_formats[] = {
@@ -126,8 +124,6 @@ static const u32 icl_sdr_uv_plane_format
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_hdr_plane_formats[] = {


