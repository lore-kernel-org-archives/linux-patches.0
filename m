Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B941CA8F;
	Mon,  1 Apr 2024 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987418; cv=none; b=X8lqkayr+YD92D7sU1vGeUn1R8VTQi8j1YkbDbpdaEYrsNFMxlIg1z6Wfm02gHSxzOnvyf//fAr50GrWqKOFaS7xSDxeCE7kSIDExQfedpgCt7prTycsO3xWVWr2OMoqTvj+CTyLoP1DIiNJ7wNeHPBkCZPkRVSuX7ed620mVlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987418; c=relaxed/simple;
	bh=WzWyrFaBuwJh+U1Vgl/lMUoFWtCFxpIR1hgnk+wkaFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C8la89S+vGxj4zQtokVuhnf32MW+wFB+WyMLK5gOoBigpMX2SKc+bWzEX2X3wOLDOaCJULLnkJsascjhEpEGDowzElMiN1SvMygKv0YA5pj+WTnCRGt0dtNE+XVjGf/eJoMKsKumoCuvlVmrplK9Tnc9/Ma0LBGuHWsAYoCP8AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYBlYrrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYBlYrrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DE4C433C7;
	Mon,  1 Apr 2024 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987418;
	bh=WzWyrFaBuwJh+U1Vgl/lMUoFWtCFxpIR1hgnk+wkaFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYBlYrrw5ZRrt8Dhy1tgJQnid1WpshTF8cXnxou/StqHoXXw5/r+iVEomixhZabyU
	 Efjy8ztbR4PwZh5tmtCelgCx3fWpHEX4sUbGfn6mtNjNMLQ2QVFzbF32Z94ssjwo6X
	 BkdJJoVdKQHYD7KW2XYBq/l22UbdX7/EMGOs7RIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.8 281/399] drm/i915: Suppress old PLL pipe_mask checks for MG/TC/TBT PLLs
Date: Mon,  1 Apr 2024 17:44:07 +0200
Message-ID: <20240401152557.571179829@linuxfoundation.org>
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

commit 33c7760226c79ee8de6c0646640963a8a7ee794a upstream.

TC ports have both the MG/TC and TBT PLLs selected simultanously (so
that we can switch from MG/TC to TBT as a fallback). This doesn't play
well with the state checker that assumes that the old PLL shouldn't
have the pipe in its pipe_mask anymore. Suppress that check for these
PLLs to avoid spurious WARNs when you disconnect a TC port and a
non-disabling modeset happens before actually disabling the port.

v2: Only suppress when one of the PLLs is the TBT PLL and the
    other one is not

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9816
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240123093137.9133-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |   23 +++++++++++++++++++----
 drivers/gpu/drm/i915/display/intel_dpll_mgr.h |    4 ++++
 2 files changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -4029,7 +4029,8 @@ static const struct intel_shared_dpll_fu
 static const struct dpll_info icl_plls[] = {
 	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
 	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
-	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL,
+	  .flags = INTEL_DPLL_IS_ALT_PORT_DPLL, },
 	{ .name = "MG PLL 1", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
 	{ .name = "MG PLL 2", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
 	{ .name = "MG PLL 3", .funcs = &mg_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
@@ -4074,7 +4075,8 @@ static const struct intel_shared_dpll_fu
 static const struct dpll_info tgl_plls[] = {
 	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
 	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
-	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL,
+	  .flags = INTEL_DPLL_IS_ALT_PORT_DPLL, },
 	{ .name = "TC PLL 1", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
 	{ .name = "TC PLL 2", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
 	{ .name = "TC PLL 3", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
@@ -4147,7 +4149,8 @@ static const struct intel_dpll_mgr adls_
 static const struct dpll_info adlp_plls[] = {
 	{ .name = "DPLL 0", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL0, },
 	{ .name = "DPLL 1", .funcs = &combo_pll_funcs, .id = DPLL_ID_ICL_DPLL1, },
-	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL, },
+	{ .name = "TBT PLL", .funcs = &tbt_pll_funcs, .id = DPLL_ID_ICL_TBTPLL,
+	  .flags = INTEL_DPLL_IS_ALT_PORT_DPLL, },
 	{ .name = "TC PLL 1", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL1, },
 	{ .name = "TC PLL 2", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL2, },
 	{ .name = "TC PLL 3", .funcs = &dkl_pll_funcs, .id = DPLL_ID_ICL_MGPLL3, },
@@ -4520,6 +4523,14 @@ verify_single_dpll_state(struct drm_i915
 			pll->info->name);
 }
 
+static bool has_alt_port_dpll(const struct intel_shared_dpll *old_pll,
+			      const struct intel_shared_dpll *new_pll)
+{
+	return old_pll && new_pll && old_pll != new_pll &&
+		(old_pll->info->flags & INTEL_DPLL_IS_ALT_PORT_DPLL ||
+		 new_pll->info->flags & INTEL_DPLL_IS_ALT_PORT_DPLL);
+}
+
 void intel_shared_dpll_state_verify(struct intel_atomic_state *state,
 				    struct intel_crtc *crtc)
 {
@@ -4541,7 +4552,11 @@ void intel_shared_dpll_state_verify(stru
 		I915_STATE_WARN(i915, pll->active_mask & pipe_mask,
 				"%s: pll active mismatch (didn't expect pipe %c in active mask (0x%x))\n",
 				pll->info->name, pipe_name(crtc->pipe), pll->active_mask);
-		I915_STATE_WARN(i915, pll->state.pipe_mask & pipe_mask,
+
+		/* TC ports have both MG/TC and TBT PLL referenced simultaneously */
+		I915_STATE_WARN(i915, !has_alt_port_dpll(old_crtc_state->shared_dpll,
+							 new_crtc_state->shared_dpll) &&
+				pll->state.pipe_mask & pipe_mask,
 				"%s: pll enabled crtcs mismatch (found pipe %c in enabled mask (0x%x))\n",
 				pll->info->name, pipe_name(crtc->pipe), pll->state.pipe_mask);
 	}
--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.h
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.h
@@ -277,12 +277,16 @@ struct dpll_info {
 	enum intel_display_power_domain power_domain;
 
 #define INTEL_DPLL_ALWAYS_ON	(1 << 0)
+#define INTEL_DPLL_IS_ALT_PORT_DPLL	(1 << 1)
 	/**
 	 * @flags:
 	 *
 	 * INTEL_DPLL_ALWAYS_ON
 	 *     Inform the state checker that the DPLL is kept enabled even if
 	 *     not in use by any CRTC.
+	 * INTEL_DPLL_IS_ALT_PORT_DPLL
+	 *     Inform the state checker that the DPLL can be used as a fallback
+	 *     (for TC->TBT fallback).
 	 */
 	u32 flags;
 };


