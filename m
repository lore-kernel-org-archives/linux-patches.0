Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0FF28629E;
	Wed, 19 Feb 2025 09:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957032; cv=none; b=qTotWwEXL+q2R5Mc0+Ekbdk4ZTBs66H9bKHc5QWdUnIphg47BMa7V0NwILnpNWNhRQ/t0vt04wdPqEOyf0Og0e/6cCLylyxJI3JXQiRDEnN5kE8j/lQwhgkQx2FXPFfnrtWcQgwxZMJ51vBBtWNRa2m/wUSPXznrZW4BWNxuoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957032; c=relaxed/simple;
	bh=L+FZ+fj5tDEPjD1wvBWHTCFRYtrnqpa+QjcPuJAxsjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3/fQsJmTLZe7eUK+KorfH7ZUeoFo3O3JqdoHSk/gLVh6YFvrHO64mKZrVbRvObaW91xEd37CFKF47JXIIw9Y6UOEOuKPfl4lLSlxrp0t2LSvUbPO09In2h1sz2wU81pUoqru4zQ4tvGZMuy1q5TynOi9Pqr9TMIUUEHTo8cYAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghP/tTJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghP/tTJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8136C4CED1;
	Wed, 19 Feb 2025 09:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957032;
	bh=L+FZ+fj5tDEPjD1wvBWHTCFRYtrnqpa+QjcPuJAxsjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghP/tTJBx2yNMQ9F974u9Bnyw8Nh6ZmklKgDbHbeZMWBAHO9PZ/bkR0w71HQrrO5U
	 hqaQ9YTj6EZlQ5aMtIxhUuNUX2GErEVLAYDqSUy7/E6jypZuyFfEpku+nuuFFmcagd
	 OOC11MFmevLj1yCaejtemGXLSkZ9vo11Vpqf0Z7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 353/578] drm/i915: Drop 64bpp YUV formats from ICL+ SDR planes
Date: Wed, 19 Feb 2025 09:25:57 +0100
Message-ID: <20250219082706.909764764@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -100,8 +100,6 @@ static const u32 icl_sdr_y_plane_formats
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_sdr_uv_plane_formats[] = {
@@ -128,8 +126,6 @@ static const u32 icl_sdr_uv_plane_format
 	DRM_FORMAT_Y216,
 	DRM_FORMAT_XYUV8888,
 	DRM_FORMAT_XVYU2101010,
-	DRM_FORMAT_XVYU12_16161616,
-	DRM_FORMAT_XVYU16161616,
 };
 
 static const u32 icl_hdr_plane_formats[] = {


