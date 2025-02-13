Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1081A26B099;
	Thu, 13 Feb 2025 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459156; cv=none; b=ZfhzZ6QE4HlFA3aoeM5spB14CiXLg2ibuN9J9uf03hmHPC4lNvgxHXqKaF43aMa2RRTHvz+XUuZ2oj+hSOWm+Sqbzhl0rfIYkU1Hhd3+MwapTmFVkklQmt3qya+5npk16obNWwTaXuO5rg49PDNzvswphl+SmNJB0+ZBJYQNQi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459156; c=relaxed/simple;
	bh=TDt0dDb8ohTcRI6bYyHV51ixH+t4VVIFDT2cuKCoJRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jlOi3619bufHNukJfTK0gAftrVGjf9og+N16KNWfwBLYP4es+1o6R1jNbDRpT6CcFdBuYxd7pZZH1z8GfzH+irqcjIODE6lmFEFrl8oqIIeBNOhGScZJ2G4U+aWv90H57PhINkpteomOHq5fWMVPACCXa1RI9Lr25wYKxP6+uLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geZs24II; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geZs24II"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFAFC4CED1;
	Thu, 13 Feb 2025 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459155;
	bh=TDt0dDb8ohTcRI6bYyHV51ixH+t4VVIFDT2cuKCoJRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geZs24II9URge230NtSFL3z8Z60WFvbU/thgtRF3fqWatXwqwbOwfb3lxtxzB5fdv
	 CRS0sZNLFExO8oxIOtUE6/ZCpeQfEzVbjLK9HPVmfYDW6IU99zLHZW+CQoHg+XIT0S
	 NZxaZWyAoJEQrSzRpTMK0ladthWk1T0UtTPyoMbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 185/443] drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes
Date: Thu, 13 Feb 2025 15:25:50 +0100
Message-ID: <20250213142447.754364700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -106,8 +106,6 @@ static const u32 icl_sdr_y_plane_formats
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_sdr_uv_plane_formats[] = {
@@ -134,8 +132,6 @@ static const u32 icl_sdr_uv_plane_format
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_hdr_plane_formats[] = {


