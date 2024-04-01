Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11DC129;
	Mon,  1 Apr 2024 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988918; cv=none; b=EdQHatiRZf4yg247Kb38vurIwNTHiNUxnEI6QB7neBqCvgymHKxl0bok5FjDrFBynctnjfXnpmrr0N0KpTUbdnBfdkeqmr4n8sRCNvekInFJ+tDZztzu+63XbfQ8o4yl7RkO4dAYVdAYUsQnvaKXjpwA7NNzNnyp2DLUnDZVHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988918; c=relaxed/simple;
	bh=JQIZIxPQquaVzwh1RPJmLB2ZgLco//fp5qLLRJazhj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnTGBdXNRh3VEdGfLBjifYiDJqtx7hMp6E/rcXWLjGAmcQFxpyYsL6L8R8tBSk3x8XbKkJj18Wg0eJkjojQz3OI3E7G4/cyTGIaGW+y/9x814E1hyBXdo5URQ7oB253EsFQnVSI0zOawhumULWRWZWTDacsAHEpWEyOtfoDBg8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYKma3jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYKma3jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D5CC433F1;
	Mon,  1 Apr 2024 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988917;
	bh=JQIZIxPQquaVzwh1RPJmLB2ZgLco//fp5qLLRJazhj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYKma3jhVitYoT5/Z643+I/g6ojI3Q7pR8Ggx6DTMdtvkKJ+X5muCQpIh+8h1A+bj
	 jadmRD6Ld/DAP07HBnz332d4CoHm2qWopzsrzRoaCVJMyWLTl7vm7+an3HZz8XfFpE
	 w8U2bvx8rW23vOhwmiqlEB9TjWonomHhglrK8eHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.7 328/432] drm/i915: Try to preserve the current shared_dpll for fastset on type-c ports
Date: Mon,  1 Apr 2024 17:45:15 +0200
Message-ID: <20240401152602.997130203@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ba407525f8247ee4c270369f3371b9994c27bfda upstream.

Currently icl_compute_tc_phy_dplls() assumes that the active
PLL will be the TC PLL (as opposed to the TBT PLL). The actual
PLL will be selected during the modeset enable sequence, but
we need to put *something* into the crtc_state->shared_dpll
already during compute_config().

The downside of assuming one PLL or the other is that we'll
fail to fastset if the assumption doesn't match what was in
use previously. So let's instead keep the same PLL that was
in use previously (assuming there was one). This should allow
fastset to work again when using TBT PLL, at least in the
steady state.

Now, assuming we want keep the same PLL may not be entirely
correct either. But we should be covered by the type-c link
reset handling which will force a full modeset by flagging
connectors_changed=true which means the resulting modeset
can't be converted into a fastset even if the full crtc state
looks identical.

Cc: Imre Deak <imre.deak@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240118142436.25928-1-ville.syrjala@linux.intel.com
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -3288,6 +3288,8 @@ static int icl_compute_tc_phy_dplls(stru
 	struct drm_i915_private *i915 = to_i915(state->base.dev);
 	struct intel_crtc_state *crtc_state =
 		intel_atomic_get_new_crtc_state(state, crtc);
+	const struct intel_crtc_state *old_crtc_state =
+		intel_atomic_get_old_crtc_state(state, crtc);
 	struct icl_port_dpll *port_dpll =
 		&crtc_state->icl_port_dplls[ICL_PORT_DPLL_DEFAULT];
 	struct skl_wrpll_params pll_params = {};
@@ -3306,7 +3308,11 @@ static int icl_compute_tc_phy_dplls(stru
 		return ret;
 
 	/* this is mainly for the fastset check */
-	icl_set_active_port_dpll(crtc_state, ICL_PORT_DPLL_MG_PHY);
+	if (old_crtc_state->shared_dpll &&
+	    old_crtc_state->shared_dpll->info->id == DPLL_ID_ICL_TBTPLL)
+		icl_set_active_port_dpll(crtc_state, ICL_PORT_DPLL_DEFAULT);
+	else
+		icl_set_active_port_dpll(crtc_state, ICL_PORT_DPLL_MG_PHY);
 
 	crtc_state->port_clock = icl_ddi_mg_pll_get_freq(i915, NULL,
 							 &port_dpll->hw_state);


