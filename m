Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388E323D2A2;
	Wed, 30 Jul 2025 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868420; cv=none; b=UEjETYjY+GT0GxyDdYKpHoidIjI+LCMFfjvDCu9Jc+2t2wLbutQpiVB6xcxeMS34OHVlsc4Ww6zhDcJ4OUGY2U99cVc8THg75Hn5yh9DV0eRwvqoan/fYcjTxsTlQLUG2un1a26w74lAxuf0Loc795ceyzULrtn6F0xiBiDrDzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868420; c=relaxed/simple;
	bh=d3oxiHctySQOBRKqQEfpdVhr7BZAEPgBUl/UYmMWoLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXgJ8M+vtEWCDoG04GDgibNqSDv3a6YmV6nwrg3CVND5XUJb6nTV3VyyZQc1E7SiGy2ziI4GisOvjhU1lqi39QBOzyufdLz2QJhgVf+nts5bPPvUbGOWKNcojfJ5OsKMhO/d5cUaztVsnsxt3fMfWopMpMua3T/TWfdx2+8e3uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISlrMJNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISlrMJNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A3CC4CEE7;
	Wed, 30 Jul 2025 09:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868418;
	bh=d3oxiHctySQOBRKqQEfpdVhr7BZAEPgBUl/UYmMWoLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISlrMJNYqkQdP2EiL2+GIJG6RgAcLlA105034J15NosTn6yrHT2KFSRrpOp4v5x2g
	 XY3f55flP5AumrCpPdQN9Riz2Gr1zkUXBfgUL5bj9pBHXpn6Eb/CQOsEz9xX5zgoGf
	 QAvfHBW+QTlC6Am70uX9N7TYQHQNlWaUkNimSOqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 57/76] drm/i915/dp: Fix 2.7 Gbps DP_LINK_BW value on g4x
Date: Wed, 30 Jul 2025 11:35:50 +0200
Message-ID: <20250730093229.057186365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1293,6 +1293,12 @@ int intel_dp_rate_select(struct intel_dp
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


