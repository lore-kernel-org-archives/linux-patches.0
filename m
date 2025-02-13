Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F0628137F;
	Thu, 13 Feb 2025 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457738; cv=none; b=MMXfzSk2kzXuj41yievNWRuhprutLl6KgDN/r9oegzB7e0gC+YSOE8SV3KQ5Y+PbIpbjcG44/xvW7ZX/k5RudcT+bEhANMppjYF/7ffh2VXLn0qqgUCmL9uGABVlkFcZM/+iyPr8Cm+xIgUaYJPl4ftYMfEUAoXSYXAAFVVsVkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457738; c=relaxed/simple;
	bh=0nb7dViblHucCoT8bX4TYjg1FvJbemdVowo1vsT5byo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=unFkCfMOzvMK1Pce3rBP/Ax65f+t40/lExTUWZNZFmY3WRsoL6BsYKlDf/DmoF65KVDYMb/xwSRiwEUhSa1n4efBvWtgzsl7T26GgaqWA9D6JhaTK0LFNMj8F9hzwEhAvzlCPsxMhBJLNE2/CqqePqCTcvAoVTTsRs5E0fUjq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmYZTWYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmYZTWYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97A6C4CED1;
	Thu, 13 Feb 2025 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457738;
	bh=0nb7dViblHucCoT8bX4TYjg1FvJbemdVowo1vsT5byo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmYZTWYjuGdR0EW+1tB8LEq0yq7EmQN3mnYAl5QWI6pbhs2l2Ipvh4kbwzwSCPhi8
	 f33qDQZpmEGLgXQBZDPIORS6uQKNl6JFv1kHWZaDWesbQneYeJcR3K2VGRVl1tp7Xn
	 yIPcmfK2mCNUyb1p/a8Mdg8sN0poCY4QLWiP2lqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 167/422] drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes
Date: Thu, 13 Feb 2025 15:25:16 +0100
Message-ID: <20250213142442.989529622@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -105,8 +105,6 @@ static const u32 icl_sdr_y_plane_formats
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_sdr_uv_plane_formats[] = {
@@ -133,8 +131,6 @@ static const u32 icl_sdr_uv_plane_format
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_hdr_plane_formats[] = {


