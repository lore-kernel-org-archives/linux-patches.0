Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F44C3ACF0E;
	Mon, 23 Mar 2026 14:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274702; cv=none; b=EQpozcJaYRJK/jzhdTkBrV7tVXy07a1To4xZOmoBgWeamafu9Fn9wg/LCISxThr6CYU3aeQPiek55hzD9vPMpcNtJnS+ISKeGdHAUUcLTjR51XSnFgXo10rDIbs+NXu8OCVZzNrOwZR7VkJM5EB7irwOHUj9OLysCE9NkTAlDh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274702; c=relaxed/simple;
	bh=YD7OX+o3VPT/yV2fAoFcfY/9SeDckuWUZIiTFNC0jRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2kyN1XGJ2kZUPm/wPxJco8v6X8FH3Wgz2s0/zPl02d0YTUpO9efxV3bcbv6TGd60fRkx6/aKy9x5nEFHfmjxS+d8WCFTH0G7O7ZlwoMxP9u+SXGDuPxvduuaXNZRxeH+d+Q883htuc+0FhCYea3gXmr5w1/25KtrEmZaPvas6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqnTQf6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqnTQf6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9404C2BC9E;
	Mon, 23 Mar 2026 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274702;
	bh=YD7OX+o3VPT/yV2fAoFcfY/9SeDckuWUZIiTFNC0jRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqnTQf6R2siO63jZZKg5VKfJbQzLyYyPkpDy31gMbsDdUWKntZT/rT0ONgI0EKarT
	 iSSLiQ1E6S6aEl41QIO8kkXO+4nIf1/PnmvlSBEyp7NxTs1i+roixr4mzHVhW+poLt
	 bEDBD4eEvfQaFP0FEL869YfR+ChNMBnDi2FXQwsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/212] drm/i915/vrr: Configure VRR timings after enabling TRANS_DDI_FUNC_CTL
Date: Mon, 23 Mar 2026 14:44:19 +0100
Message-ID: <20260323134504.966058428@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 237aab549676288d9255bb8dcc284738e56eaa31 ]

Apparently ICL may hang with an MCE if we write TRANS_VRR_VMAX/FLIPLINE
before enabling TRANS_DDI_FUNC_CTL.

Personally I was only able to reproduce a hang (on an Dell XPS 7390
2-in-1) with an external display connected via a dock using a dodgy
type-C cable that made the link training fail. After the failed
link training the machine would hang. TGL seemed immune to the
problem for whatever reason.

BSpec does tell us to configure VRR after enabling TRANS_DDI_FUNC_CTL
as well. The DMC firmware also does the VRR restore in two stages:
- first stage seems to be unconditional and includes TRANS_VRR_CTL
  and a few other VRR registers, among other things
- second stage is conditional on the DDI being enabled,
  and includes TRANS_DDI_FUNC_CTL and TRANS_VRR_VMAX/VMIN/FLIPLINE,
  among other things

So let's reorder the steps to match to avoid the hang, and
toss in an extra WARN to make sure we don't screw this up later.

BSpec: 22243
Cc: stable@vger.kernel.org
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reported-by: Benjamin Tissoires <bentiss@kernel.org>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15777
Tested-by: Benjamin Tissoires <bentiss@kernel.org>
Fixes: dda7dcd9da73 ("drm/i915/vrr: Use fixed timings for platforms that support VRR")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260303095414.4331-1-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
(cherry picked from commit 93f3a267c3dd4d811b224bb9e179a10d81456a74)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |    1 -
 drivers/gpu/drm/i915/display/intel_vrr.c     |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -1642,7 +1642,6 @@ static void hsw_configure_cpu_transcoder
 	}
 
 	intel_set_transcoder_timings(crtc_state);
-	intel_vrr_set_transcoder_timings(crtc_state);
 
 	if (cpu_transcoder != TRANSCODER_EDP)
 		intel_de_write(display, TRANS_MULT(display, cpu_transcoder),
--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -465,6 +465,18 @@ void intel_vrr_set_transcoder_timings(co
 		return;
 
 	/*
+	 * Bspec says:
+	 * "(note: VRR needs to be programmed after
+	 *  TRANS_DDI_FUNC_CTL and before TRANS_CONF)."
+	 *
+	 * In practice it turns out that ICL can hang if
+	 * TRANS_VRR_VMAX/FLIPLINE are written before
+	 * enabling TRANS_DDI_FUNC_CTL.
+	 */
+	drm_WARN_ON(display->drm,
+		    !(intel_de_read(display, TRANS_DDI_FUNC_CTL(display, cpu_transcoder)) & TRANS_DDI_FUNC_ENABLE));
+
+	/*
 	 * This bit seems to have two meanings depending on the platform:
 	 * TGL: generate VRR "safe window" for DSB vblank waits
 	 * ADL/DG2: make TRANS_SET_CONTEXT_LATENCY effective with VRR
@@ -658,6 +670,8 @@ void intel_vrr_transcoder_enable(const s
 	if (!HAS_VRR(display))
 		return;
 
+	intel_vrr_set_transcoder_timings(crtc_state);
+
 	if (!intel_vrr_possible(crtc_state))
 		return;
 


