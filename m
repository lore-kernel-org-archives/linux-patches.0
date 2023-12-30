Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CE079CD;
	Sat, 30 Dec 2023 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHuuL+u0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AA8C433C8;
	Sat, 30 Dec 2023 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938230;
	bh=iPuCW4b72GEau599RTwqCRyNqqwyMKnOdcvJtRrFMVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHuuL+u0b0oo7Zgg96t12YzbSQfPBHVRhcDvOGA6cSobD/19S3HaSmMh568t9TKPo
	 FT67gnsx1Z7lxEerQHPZJwBN+H+RyROpumhTz2QmW2BNp0Lfn9hSgOZigBBGjh2Uej
	 2gw/jRKX5EY4iKWO3Ksk0RtQnB/TncCFwrnFD8F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/112] drm/i915: Fix ADL+ tiled plane stride when the POT stride is smaller than the original
Date: Sat, 30 Dec 2023 11:59:26 +0000
Message-ID: <20231230115808.408687995@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 324b70e997aab0a7deab8cb90711faccda4e98c8 ]

plane_view_scanout_stride() currently assumes that we had to pad the
mapping stride with dummy pages in order to align it. But that is not
the case if the original fb stride exceeds the aligned stride used
to populate the remapped view, which is calculated from the user
specified framebuffer width rather than the user specified framebuffer
stride.

Ignore the original fb stride in this case and just stick to the POT
aligned stride. Getting this wrong will cause the plane to fetch the
wrong data, and can lead to fault errors if the page tables at the
bogus location aren't even populated.

TODO: figure out if this is OK for CCS, or if we should instead increase
the width of the view to cover the entire user specified fb stride
instead...

Cc: Imre Deak <imre.deak@intel.com>
Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231204202443.31247-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
(cherry picked from commit 01a39f1c4f1220a4e6a25729fae87ff5794cbc52)
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fb.c b/drivers/gpu/drm/i915/display/intel_fb.c
index 583b3c0f96ddc..c69a638796c62 100644
--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -1316,7 +1316,8 @@ plane_view_scanout_stride(const struct intel_framebuffer *fb, int color_plane,
 	struct drm_i915_private *i915 = to_i915(fb->base.dev);
 	unsigned int stride_tiles;
 
-	if (IS_ALDERLAKE_P(i915) || DISPLAY_VER(i915) >= 14)
+	if ((IS_ALDERLAKE_P(i915) || DISPLAY_VER(i915) >= 14) &&
+	    src_stride_tiles < dst_stride_tiles)
 		stride_tiles = src_stride_tiles;
 	else
 		stride_tiles = dst_stride_tiles;
-- 
2.43.0



