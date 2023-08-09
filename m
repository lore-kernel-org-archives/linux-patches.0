Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99BC174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C579C433C8;
	Wed,  9 Aug 2023 10:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578627;
	bh=FrDkZ6Lwbx9XAR5PnwuSfBzCGjvu884ya+ON1ddBC38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV8GEhQfZO1MBkvRBH7kmeB3yt2nuDHOjVGKCohZEjvApwl9d4EiL0nU+YG0x29n4
	 bMWrsJ/89nO/Kf6Bx6LvhE/o3m750qb78Q62efUHJWNDnH8QDP1+FO67LuXLqJl8Rx
	 Zb0bqCcuxCt0JZHSw/r1ZqPhPL7T3CgqQD6Ftogc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Manasi Navare <navaremanasi@google.com>,
	Drew Davenport <ddavenport@chromium.org>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 127/127] Revert "drm/i915: Disable DC states for all commits"
Date: Wed,  9 Aug 2023 12:41:54 +0200
Message-ID: <20230809103640.795291713@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 0fc6fea41c7122aa5f2088117f50144b507e13d7 which is
commit a2b6e99d8a623544f3bdccd28ee35b9c1b00daa5 upstream.

It is reported to cause regression issues, so it should be reverted from
the 6.1.y tree for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Link: https://lore.kernel.org/r/f0870e8f-0c66-57fd-f95d-18d014a11939@leemhuis.info
Link: https://gitlab.freedesktop.org/drm/intel/-/issues/8419
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Jouni Högander <jouni.hogander@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display.c |   28 ++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -7123,8 +7123,6 @@ static void intel_update_crtc(struct int
 
 	intel_fbc_update(state, crtc);
 
-	drm_WARN_ON(&i915->drm, !intel_display_power_is_enabled(i915, POWER_DOMAIN_DC_OFF));
-
 	if (!modeset &&
 	    (new_crtc_state->uapi.color_mgmt_changed ||
 	     new_crtc_state->update_pipe))
@@ -7501,28 +7499,8 @@ static void intel_atomic_commit_tail(str
 	drm_atomic_helper_wait_for_dependencies(&state->base);
 	drm_dp_mst_atomic_wait_for_dependencies(&state->base);
 
-	/*
-	 * During full modesets we write a lot of registers, wait
-	 * for PLLs, etc. Doing that while DC states are enabled
-	 * is not a good idea.
-	 *
-	 * During fastsets and other updates we also need to
-	 * disable DC states due to the following scenario:
-	 * 1. DC5 exit and PSR exit happen
-	 * 2. Some or all _noarm() registers are written
-	 * 3. Due to some long delay PSR is re-entered
-	 * 4. DC5 entry -> DMC saves the already written new
-	 *    _noarm() registers and the old not yet written
-	 *    _arm() registers
-	 * 5. DC5 exit -> DMC restores a mixture of old and
-	 *    new register values and arms the update
-	 * 6. PSR exit -> hardware latches a mixture of old and
-	 *    new register values -> corrupted frame, or worse
-	 * 7. New _arm() registers are finally written
-	 * 8. Hardware finally latches a complete set of new
-	 *    register values, and subsequent frames will be OK again
-	 */
-	wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_DC_OFF);
+	if (state->modeset)
+		wakeref = intel_display_power_get(dev_priv, POWER_DOMAIN_MODESET);
 
 	intel_atomic_prepare_plane_clear_colors(state);
 
@@ -7661,8 +7639,8 @@ static void intel_atomic_commit_tail(str
 		 * the culprit.
 		 */
 		intel_uncore_arm_unclaimed_mmio_detection(&dev_priv->uncore);
+		intel_display_power_put(dev_priv, POWER_DOMAIN_MODESET, wakeref);
 	}
-	intel_display_power_put(dev_priv, POWER_DOMAIN_DC_OFF, wakeref);
 	intel_runtime_pm_put(&dev_priv->runtime_pm, state->wakeref);
 
 	/*


