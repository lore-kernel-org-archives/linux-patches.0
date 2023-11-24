Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76FA39FE8;
	Fri, 24 Nov 2023 18:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8hJht1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFD7C433C9;
	Fri, 24 Nov 2023 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850311;
	bh=I9KQOrqbMHtvI0q9XLtJi+k06K16zzKo+ME1O7rMai0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8hJht1vC0e50/ScPbfnFiPRGNpbaqUFHT2KgyXFOuid37Di/BvsRaoJbsmlPhbrI
	 wT9KxzoOtZ0SZrGz9Rrt5AdHopFuqRpJTDMIlcg92TbptPb9ZEniFjck4dq6HwelaB
	 EzGEB3BgQsJ3iJ1OHLYWclu68tyqTiJ4d+9rFMnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 512/530] drm/i915: Bump GLK CDCLK frequency when driving multiple pipes
Date: Fri, 24 Nov 2023 17:51:18 +0000
Message-ID: <20231124172043.751113913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 0cb89cd42fd22bbdec0b046c48f35775f5b88bdb upstream.

On GLK CDCLK frequency needs to be at least 2*96 MHz when accessing
the audio hardware. Currently we bump the CDCLK frequency up
temporarily (if not high enough already) whenever audio hardware
is being accessed, and drop it back down afterwards.

With a single active pipe this works just fine as we can switch
between all the valid CDCLK frequencies by changing the cd2x
divider, which doesn't require a full modeset. However with
multiple active pipes the cd2x divider trick no longer works,
and thus we end up blinking all displays off and back on.

To avoid this let's just bump the CDCLK frequency to >=2*96MHz
whenever multiple pipes are active. The downside is slightly
higher power consumption, but that seems like an acceptable
tradeoff. With a single active pipe we can stick to the current
more optiomal (from power comsumption POV) behaviour.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9599
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231031160800.18371-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 451eaa1a614c911f5a51078dcb68022874e4cb12)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_cdclk.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_cdclk.c
+++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
@@ -2688,6 +2688,18 @@ static int intel_compute_min_cdclk(struc
 	for_each_pipe(dev_priv, pipe)
 		min_cdclk = max(cdclk_state->min_cdclk[pipe], min_cdclk);
 
+	/*
+	 * Avoid glk_force_audio_cdclk() causing excessive screen
+	 * blinking when multiple pipes are active by making sure
+	 * CDCLK frequency is always high enough for audio. With a
+	 * single active pipe we can always change CDCLK frequency
+	 * by changing the cd2x divider (see glk_cdclk_table[]) and
+	 * thus a full modeset won't be needed then.
+	 */
+	if (IS_GEMINILAKE(dev_priv) && cdclk_state->active_pipes &&
+	    !is_power_of_2(cdclk_state->active_pipes))
+		min_cdclk = max(2 * 96000, min_cdclk);
+
 	if (min_cdclk > dev_priv->display.cdclk.max_cdclk_freq) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "required cdclk (%d kHz) exceeds max (%d kHz)\n",


