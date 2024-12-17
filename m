Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB15D1F429B;
	Tue, 17 Dec 2024 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456433; cv=none; b=BaK8u3c6ufUaNii+TFWvGNBiTccMAMOJcRtIQFyhuXDI9t+UcXgjBFEJY4DGgVNyrEYjxd0U8aQfyf0eLyblt9afcz4/RWIv25T/2oyDheNSFNY8wcZJzNG53fM6PEn3LNgc34ZKC0AS/jzQOUPvJlH6Fmxa3cqIJlL6BIz+2xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456433; c=relaxed/simple;
	bh=aI2X8b7vT9LaCjWzFlihWjxo2ILYbZcI5TfRU776qM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T3GU928/Lg5XdgXe2j+3ddrRFO5xnCnAsOjNFrPnjRHFJKY8kqkcQReA3OtQJWwVXd0COfJk4Fql1YJQH4hF6lBvbwaJave9orQ01ceIRNm0qjJAX2MMezRfb9i1ab2Ehc1P1PwB8KlNreRUWKcNZoQGutCzNhWSeGBDzWbu+CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsASpmUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsASpmUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77631C4CED3;
	Tue, 17 Dec 2024 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456432;
	bh=aI2X8b7vT9LaCjWzFlihWjxo2ILYbZcI5TfRU776qM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsASpmUz7NwQH4DTjqWWAC1lDjzGlsEJdhsd2gQqIImsKV0pun6PrpjC60OSNC5Pl
	 rm/swkiHB6gscirO0xi1LnSRpJzr7R+sf3CLInIX1UtvRMdxAZH++04SWc/MD/p241
	 7WlauU/mYDYsqoX2ZRx+OBVnHGEUzFOLOMpBcfZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.12 059/172] drm/i915/color: Stop using non-posted DSB writes for legacy LUT
Date: Tue, 17 Dec 2024 18:06:55 +0100
Message-ID: <20241217170548.721635672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit cd3da567e2e46b8f75549637b960a83b024d6b6e upstream.

DSB LUT register writes vs. palette anti-collision logic
appear to interact in interesting ways:
- posted DSB writes simply vanish into thin air while
  anti-collision is active
- non-posted DSB writes actually get blocked by the anti-collision
  logic, but unfortunately this ends up hogging the bus for
  long enough that unrelated parallel CPU MMIO accesses start
  to disappear instead

Even though we are updating the LUT during vblank we aren't
immune to the anti-collision logic because it kicks in briefly
for pipe prefill (initiated at frame start). The safe time
window for performing the LUT update is thus between the
undelayed vblank and frame start. Turns out that with low
enough CDCLK frequency (DSB execution speed depends on CDCLK)
we can exceed that.

As we are currently using non-posted writes for the legacy LUT
updates, in which case we can hit the far more severe failure
mode. The problem is exacerbated by the fact that non-posted
writes are much slower than posted writes (~4x it seems).

To mititage the problem let's switch to using posted DSB
writes for legacy LUT updates (which will involve using the
double write approach to avoid other problems with DSB
vs. legacy LUT writes). Despite writing each register twice
this will in fact make the legacy LUT update faster when
compared to the non-posted write approach, making the
problem less likely to appear. The failure mode is also
less severe.

This isn't the 100% solution we need though. That will involve
estimating how long the LUT update will take, and pushing
frame start and/or delayed vblank forward to guarantee that
the update will have finished by the time the pipe prefill
starts...

Cc: stable@vger.kernel.org
Fixes: 34d8311f4a1c ("drm/i915/dsb: Re-instate DSB for LUT updates")
Fixes: 25ea3411bd23 ("drm/i915/dsb: Use non-posted register writes for legacy LUT")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12494
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241120164123.12706-3-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
(cherry picked from commit 2504a316b35d49522f39cf0dc01830d7c36a9be4)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_color.c |   30 +++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -1333,19 +1333,29 @@ static void ilk_load_lut_8(const struct
 	lut = blob->data;
 
 	/*
-	 * DSB fails to correctly load the legacy LUT
-	 * unless we either write each entry twice,
-	 * or use non-posted writes
+	 * DSB fails to correctly load the legacy LUT unless
+	 * we either write each entry twice when using posted
+	 * writes, or we use non-posted writes.
+	 *
+	 * If palette anti-collision is active during LUT
+	 * register writes:
+	 * - posted writes simply get dropped and thus the LUT
+	 *   contents may not be correctly updated
+	 * - non-posted writes are blocked and thus the LUT
+	 *   contents are always correct, but simultaneous CPU
+	 *   MMIO access will start to fail
+	 *
+	 * Choose the lesser of two evils and use posted writes.
+	 * Using posted writes is also faster, even when having
+	 * to write each register twice.
 	 */
-	if (crtc_state->dsb_color_vblank)
-		intel_dsb_nonpost_start(crtc_state->dsb_color_vblank);
-
-	for (i = 0; i < 256; i++)
+	for (i = 0; i < 256; i++) {
 		ilk_lut_write(crtc_state, LGC_PALETTE(pipe, i),
 			      i9xx_lut_8(&lut[i]));
-
-	if (crtc_state->dsb_color_vblank)
-		intel_dsb_nonpost_end(crtc_state->dsb_color_vblank);
+		if (crtc_state->dsb_color_vblank)
+			ilk_lut_write(crtc_state, LGC_PALETTE(pipe, i),
+				      i9xx_lut_8(&lut[i]));
+	}
 }
 
 static void ilk_load_lut_10(const struct intel_crtc_state *crtc_state,


