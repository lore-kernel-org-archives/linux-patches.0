Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ABA1CA8F;
	Mon,  1 Apr 2024 16:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987590; cv=none; b=BoeBNUOxPK4/IH176vqGiIZg3gzEVZm0mNYndFERmtiHBah7bY3qaP2e5Xqgnnar+TaYBZIUAbPA2oTYRp2bz/JM1x78f77mENvJrerU2n/+sTwR4RG/dkk73hztXwd3N7a4DT2Y0vDK6TFPYOGLfzFQ6LDMJdTvhTANr7AR/iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987590; c=relaxed/simple;
	bh=cnocdDkzjwl8azKeSxFm2W99FQPKOn357VkIwOEONd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nziIAPUwrAaLMWcQGn+kSEyMGILUvK+ZsgAYvPgDISrfoq+eephFTmy9FAw8cVZshhdI+Hh0i0B0sPohlbrAkhzaRZAhRzdhoBtYakA7A20Qd+oOg2CeA51vjigLYT19EoZLtqHL6J9woa0Q3QxJoIaYFfrh5+gbbgX70yraU48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOAEoZZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOAEoZZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A50BC433C7;
	Mon,  1 Apr 2024 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987590;
	bh=cnocdDkzjwl8azKeSxFm2W99FQPKOn357VkIwOEONd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOAEoZZ7sUuigasdbAbEggLQJOaI9UL990woCcstoqSRKyT+inYto1H574gK57+RC
	 vOcLaW7zlxmAuIAoFYco1KYdoBpzi292LsMdwBL0KdOTN5uqd8hrOJLq32Q1T32LZA
	 WxiZWkhawNLZKVZ08s/6Jrwt6T4KL91Urem7tdAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 333/399] drm/i915/vrr: Generate VRR "safe window" for DSB
Date: Mon,  1 Apr 2024 17:44:59 +0200
Message-ID: <20240401152559.118209173@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit f7d3b9277ff7eb8e84e6f8554d1c2dd78278a572 upstream.

Looks like TRANS_CHICKEN bit 31 means something totally different
depending on the platform:
TGL: generate VRR "safe window" for DSB
ADL/DG2: make TRANS_SET_CONTEXT_LATENCY effective with VRR

So far we've only set this on ADL/DG2, but when using DSB+VRR
we also need to set it on TGL.

And a quick test on MTL says it doesn't need this bit for either
of those purposes, even though it's still documented as valid
in bspec.

Cc: stable@vger.kernel.org
Fixes: 34d8311f4a1c ("drm/i915/dsb: Re-instate DSB for LUT updates")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9927
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240306040806.21697-2-ville.syrjala@linux.intel.com
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
(cherry picked from commit 810e4519a1b34b5a0ff0eab32e5b184f533c5ee9)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    7 ++++---
 drivers/gpu/drm/i915/i915_reg.h          |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -187,10 +187,11 @@ void intel_vrr_set_transcoder_timings(co
 	enum transcoder cpu_transcoder = crtc_state->cpu_transcoder;
 
 	/*
-	 * TRANS_SET_CONTEXT_LATENCY with VRR enabled
-	 * requires this chicken bit on ADL/DG2.
+	 * This bit seems to have two meanings depending on the platform:
+	 * TGL: generate VRR "safe window" for DSB vblank waits
+	 * ADL/DG2: make TRANS_SET_CONTEXT_LATENCY effective with VRR
 	 */
-	if (DISPLAY_VER(dev_priv) == 13)
+	if (IS_DISPLAY_VER(dev_priv, 12, 13))
 		intel_de_rmw(dev_priv, CHICKEN_TRANS(cpu_transcoder),
 			     0, PIPE_VBLANK_WITH_DELAY);
 
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4597,7 +4597,7 @@
 #define MTL_CHICKEN_TRANS(trans)	_MMIO_TRANS((trans), \
 						    _MTL_CHICKEN_TRANS_A, \
 						    _MTL_CHICKEN_TRANS_B)
-#define   PIPE_VBLANK_WITH_DELAY	REG_BIT(31) /* ADL/DG2 */
+#define   PIPE_VBLANK_WITH_DELAY	REG_BIT(31) /* tgl+ */
 #define   SKL_UNMASK_VBL_TO_PIPE_IN_SRD	REG_BIT(30) /* skl+ */
 #define   HSW_FRAME_START_DELAY_MASK	REG_GENMASK(28, 27)
 #define   HSW_FRAME_START_DELAY(x)	REG_FIELD_PREP(HSW_FRAME_START_DELAY_MASK, x)


