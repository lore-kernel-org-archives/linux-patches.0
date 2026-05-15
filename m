Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69E03D6CB9;
	Fri, 15 May 2026 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862681; cv=none; b=A9Hk+VXfkD3Lw6Q6UAi48mSspsmV79LQBkPHyB/F6fi+bJb0fab/hphEE/w4kXXpmj3RNBv8VH6ahnIyCN1ciVF4u7GWleYyaC1xURlzfPX0Ih97Av9CbEzPvVsUm7BgjyVu8aRoXtDDu9AeP6vAzc4nVTDB2ZddeKWceLLK6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862681; c=relaxed/simple;
	bh=MOz/EXZA/0irvlQf6OD+5eyR+R4KxULPs/yIqszsmZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5csDL77ItgsXwS7yNVqnm9LGAhlu+2Kl2EmRhsMz03354MhhYenC3uSEZbAv4nMddefIBbYsRdri+4H2v92XnuwClTfYfzu+WQxWmT1wZOxBxD2amwLRVaDqczFAWqJ2W5S7FO6G5+B5ZxGt/4gIgLFXHUDo3AhM7kyrglPUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWvD0xZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWvD0xZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0BBC2BCB0;
	Fri, 15 May 2026 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862681;
	bh=MOz/EXZA/0irvlQf6OD+5eyR+R4KxULPs/yIqszsmZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWvD0xZZiIAuoXmY2eYEeJir0EOXFts68ycpVOwtHTPDV+udHIePtjQXBIHqmrirA
	 4xEDywjO8Os0uB8i5zrLT3B+6xhau9Bro6CUYEqlE6Xdkbq4MRZEt3KDaILcYQGzlq
	 napzqeJ/Hox2ZlzssS840WpiVG+RttAzIC5MIhIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Kleiner <mario.kleiner.de@gmail.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Krunoslav Kovac <krunoslav.kovac@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH 7.0 143/201] drm/amd/display: Change dither policy for 10 bpc output back to dithering
Date: Fri, 15 May 2026 17:49:21 +0200
Message-ID: <20260515154701.665098493@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Kleiner <mario.kleiner.de@gmail.com>

commit d65bfb1782304b03862c8c725fac608015dffd36 upstream.

Commit d5df648ec830 ("drm/amd/display: Change dither policy for 10bpc to
round") degraded display of 12 bpc color precision output to 10 bpc sinks
by switching 10 bpc output from dithering to "truncate to 10 bpc".

I don't find the argumentation in that commit convincing, but the
consequences highly unfortunate, especially for applications that
require effective > 10 bpc precision output of > 10 bpc framebuffers.

The argument wasn't something strong like "there are hardware design
defects or limitations which require us to work around broken dithering
to 10 bpc", or "there are some special use cases which do require
truncation to 10 bpc", but essentially "at some point in the past we
used truncation in Polaris/Vega times and it looks like it got
inadvertently changed for Navi, so let's do that again". I couldn't find
evidence for that in the git commit logs for this. The commit message also
acknowledges that using dithering "...makes some sense for FP16...
...but not for ARGB2101010 surfaces..."

The problem with this is that it makes fp16 surfaces, and especially
rgba16 fixed point surfaces, less useful. These are now well
supported by Mesa 25.3 and later via OpenGL + EGL, Vulkan/WSI, and by
OSS AMDVLK Vulkan/WSI/display, and also by GNOME 50 mutter under Wayland,
and they used to provide more than 10 bpc effective precision at the
output.

Even for 8 or 10 bpc surfaces, the color pipeline behind the framebuffer,
e.g., gamma tables, CTM, can be used for color correction and will
benefit from an effective > 10 bpc output precision via dithering,
retaining some precision that would get lost on the way through the
pipeline, e.g., due to non-linear gamma functions.

Scientific apps rely on this for > 10 bpc display precision. Truncating
to 10 bpc, instead of dithering the pipeline internal 12 bpc precision
down to 10 bpc, causes a serious loss of precision. This also creates the
undesirable and slightly absurd situation that using a cheap monitor
with only 8 bpc input and display panel will yield roughly 12 bpc
precision via dithering from 12 -> 8 bpc, whereas investment into a
more expensive monitor with 10 bpc input and native 10 bpc display will
only yield 10 bpc, even if a fp16 or rgb16 framebuffer and/or a properly
set up color pipeline (gamma tables, CTM's etc. with more than 10 bpc out
precision) would allow effective 12 bpc precision output.

Therefore this patch proposes reverting that commit and going back to
dithering down to 10 bpc, consistent with the behaviour for 6 bpc or 8 bpc
output.

Successfully tested on AMD Polaris DCE 11.2 and Raven Ridge DCN 1.0 with
a native 10 bpc capable monitor, outputting a RGBA16 unorm framebuffer and
measuring resulting color precision with a photometer. No apparent visual
artifacts or problems were observed, and effective precision was measured
to be 12 bpc again, as expected.

Fixes: d5df648ec830 ("drm/amd/display: Change dither policy for 10bpc to round")
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Tested-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: stable@vger.kernel.org
Cc: Aric Cyr <aric.cyr@amd.com>
Cc: Anthony Koo <anthony.koo@amd.com>
Cc: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Cc: Krunoslav Kovac <krunoslav.kovac@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -5049,7 +5049,7 @@ void resource_build_bit_depth_reduction_
 			option = DITHER_OPTION_SPATIAL8;
 			break;
 		case COLOR_DEPTH_101010:
-			option = DITHER_OPTION_TRUN10;
+			option = DITHER_OPTION_SPATIAL10;
 			break;
 		default:
 			option = DITHER_OPTION_DISABLE;


