Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD12273D95;
	Wed, 30 Jul 2025 09:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868925; cv=none; b=qSbGzcIF2qeK3+c9lmhtTZYFlvqH9C0fHpQV5rQDBewTAaWJ9HgeT0wHsDLzVvYhjfvWVZyrwss+QjqePC9S98vA9NcThl9S/0Wj5QF2bp6+X835Fm/uW9F4S8jkKbv2BXtrabtW0CJfuOpnkxGpmLHYybC9MOuMcE6kVrJw9Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868925; c=relaxed/simple;
	bh=kXIOlWIv4wqDFAXuB6qN6ulepzgz0GoL+mGf5X/6l4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9ol3WzpCpIIxGgJg9+O2g/AbAPWO8k+mig1LcXAbcsxlGMNUafryCpPsAfbYugtIdn5ebVoj9/qCh4cF8eeWVJWhz9ldPFaNo6KuQQVkLxX+lqve3ST5JeFVNEehLhPxz3HnV2y+nVqkmnMu/nI1u182rmAap6ydmMEMHt0PuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl+JyO5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl+JyO5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BC3C4CEF5;
	Wed, 30 Jul 2025 09:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868925;
	bh=kXIOlWIv4wqDFAXuB6qN6ulepzgz0GoL+mGf5X/6l4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vl+JyO5wb7YoQkBzBl5oU4O+FVvUxwgl2p4GY1a3LwPZCJFq+EABjdzw7LDiNGjCM
	 1jU46Z/5yn5grYmxHQj3oqidotDzt8dQs8zNArpQRPv8YlQc5w5seMfM+YBgWtumS8
	 4Yq+71djZvZ0wvPsXSWArwgTdISK/TZG+U0D17vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/117] drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x
Date: Wed, 30 Jul 2025 11:36:20 +0200
Message-ID: <20250730093238.130013268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 9e0c433d0c05fde284025264b89eaa4ad59f0a3e upstream.

On g4x we currently use the 96MHz non-SSC refclk, which can't actually
generate an exact 2.7 Gbps link rate. In practice we end up with 2.688
Gbps which seems to be close enough to actually work, but link training
is currently failing due to miscalculating the DP_LINK_BW value (we
calcualte it directly from port_clock which reflects the actual PLL
outpout frequency).

Ideas how to fix this:
- nudge port_clock back up to 270000 during PLL computation/readout
- track port_clock and the nominal link rate separately so they might
  differ a bit
- switch to the 100MHz refclk, but that one should be SSC so perhaps
  not something we want

While we ponder about a better solution apply some band aid to the
immediate issue of miscalculated DP_LINK_BW value. With this
I can again use 2.7 Gbps link rate on g4x.

Cc: stable@vger.kernel.org
Fixes: 665a7b04092c ("drm/i915: Feed the DPLL output freq back into crtc_state")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250710201718.25310-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit a8b874694db5cae7baaf522756f87acd956e6e66)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[ changed display->platform.g4x to IS_G4X(i915) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1506,6 +1506,12 @@ int intel_dp_rate_select(struct intel_dp
 void intel_dp_compute_rate(struct intel_dp *intel_dp, int port_clock,
 			   u8 *link_bw, u8 *rate_select)
 {
+	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
+
+	/* FIXME g4x can't generate an exact 2.7GHz with the 96MHz non-SSC refclk */
+	if (IS_G4X(i915) && port_clock == 268800)
+		port_clock = 270000;
+
 	/* eDP 1.4 rate select method. */
 	if (intel_dp->use_rate_select) {
 		*link_bw = 0;


