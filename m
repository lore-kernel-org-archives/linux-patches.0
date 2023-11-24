Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58A71A5A4;
	Fri, 24 Nov 2023 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="we5G0rAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A49CC433CA;
	Fri, 24 Nov 2023 19:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852493;
	bh=qlJ95LKJxLU51feko1kithl+O7xfS9XI/2NgSL11xwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=we5G0rAm7WKRNK3H4fvbF3elZtZbS7bwjaxmP6CrPdJskqgPWXXoNlXHnRXA7XYDO
	 nqHirx2fJod1+lT5eRXUPWn2V8ZqYQvkHWguWRVvUOp5bZrkWopCY7K1raGmEoPC4v
	 qgInTsjR6b1+SsGtT4eGgD3nKpNEoZTStwe6+IjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 358/372] drm/i915: Bump GLK CDCLK frequency when driving multiple pipes
Date: Fri, 24 Nov 2023 17:52:25 +0000
Message-ID: <20231124172022.242017182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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
@@ -2368,6 +2368,18 @@ static int intel_compute_min_cdclk(struc
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


