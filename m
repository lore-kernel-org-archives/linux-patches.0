Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7E88F5C;
	Mon,  1 Apr 2024 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990193; cv=none; b=Py8Afit2fIujVWNqaF3NO/iQoczwQdItGNovzWnGxJV/lQTCQ2J8zdnHJZzPDUl1N7B6il4OKnFCTM/laci2R8STXXTSdLN/6TMT8q+YuqXEVHbTdNPI4c73CNSYpnEY4kf+6LfYCTGsa00k9ztkaOcF5ECaasUmXXyo6garJkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990193; c=relaxed/simple;
	bh=cqNUJb6iJHZQxBbdTOp2eR4ZtxurUoZRKC09Y1RPpTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aoT4uc27s4jVLZqdFsXUTr9+yuhhug/OhENjbXxaNHdL1R7PospxzRHvMsRk93DKKNEIyyBCA7+2a2QKCqdXU0t3ewnlgT/5APSVG2imW9ix8AGYb68ssLWhu46YjgJXDv83RxQbCiz0OzR4tylRuKU7DRQvWVvxsksigil2qd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omwWhnvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omwWhnvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ECAC433C7;
	Mon,  1 Apr 2024 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990193;
	bh=cqNUJb6iJHZQxBbdTOp2eR4ZtxurUoZRKC09Y1RPpTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omwWhnvD0i6PjomJLQTTLJub8eaOhsAkhKSTj1LIRUjTPKWhsPIdtNC/XM9TZhYSv
	 7qUWkMGvZdypgQfFVsbCqK/+vj/goUDjx5OGT46pF9OHF5KZIECzSWrQWol0A95G7k
	 JOnfpEJufIOQuW0JbNVU4uHG9WHuE87CzvpDdp5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.6 247/396] drm/i915: Dont explode when the dig port we dont have an AUX CH
Date: Mon,  1 Apr 2024 17:44:56 +0200
Message-ID: <20240401152555.277114977@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit 0b385be4c3ccd5636441923d7cad5eda6b4651cb upstream.

The icl+ power well code currently assumes that every AUX power
well maps to an encoder which is using said power well. That is
by no menas guaranteed as we:
- only register encoders for ports declared in the VBT
- combo PHY HDMI-only encoder no longer get an AUX CH since
  commit 9856308c94ca ("drm/i915: Only populate aux_ch if really needed")

However we have places such as intel_power_domains_sanitize_state()
that blindly traverse all the possible power wells. So these bits
of code may very well encounbter an aux power well with no associated
encoder.

In this particular case the BIOS seems to have left one AUX power
well enabled even though we're dealing with a HDMI only encoder
on a combo PHY. We then proceed to turn off said power well and
explode when we can't find a matching encoder. As a short term fix
we should be able to just skip the PHY related parts of the power
well programming since we know this situation can only happen with
combo PHYs.

Another option might be to go back to always picking an AUX CH for
all encoders. However I'm a bit wary about that since we might in
theory end up conflicting with the VBT AUX CH assignment. Also
that wouldn't help with encoders not declared in the VBT, should
we ever need to poke the corresponding power wells.

Longer term we need to figure out what the actual relationship
is between the PHY vs. AUX CH vs. AUX power well. Currently this
is entirely unclear.

Cc: stable@vger.kernel.org
Fixes: 9856308c94ca ("drm/i915: Only populate aux_ch if really needed")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10184
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240223203216.15210-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit 6a8c66bf0e565c34ad0a18f820e0bb17951f7f91)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../drm/i915/display/intel_display_power_well.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_power_well.c b/drivers/gpu/drm/i915/display/intel_display_power_well.c
index 47cd6bb04366..06900ff307b2 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power_well.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power_well.c
@@ -246,7 +246,14 @@ static enum phy icl_aux_pw_to_phy(struct drm_i915_private *i915,
 	enum aux_ch aux_ch = icl_aux_pw_to_ch(power_well);
 	struct intel_digital_port *dig_port = aux_ch_to_digital_port(i915, aux_ch);
 
-	return intel_port_to_phy(i915, dig_port->base.port);
+	/*
+	 * FIXME should we care about the (VBT defined) dig_port->aux_ch
+	 * relationship or should this be purely defined by the hardware layout?
+	 * Currently if the port doesn't appear in the VBT, or if it's declared
+	 * as HDMI-only and routed to a combo PHY, the encoder either won't be
+	 * present at all or it will not have an aux_ch assigned.
+	 */
+	return dig_port ? intel_port_to_phy(i915, dig_port->base.port) : PHY_NONE;
 }
 
 static void hsw_wait_for_power_well_enable(struct drm_i915_private *dev_priv,
@@ -414,7 +421,8 @@ icl_combo_phy_aux_power_well_enable(struct drm_i915_private *dev_priv,
 
 	intel_de_rmw(dev_priv, regs->driver, 0, HSW_PWR_WELL_CTL_REQ(pw_idx));
 
-	if (DISPLAY_VER(dev_priv) < 12)
+	/* FIXME this is a mess */
+	if (phy != PHY_NONE)
 		intel_de_rmw(dev_priv, ICL_PORT_CL_DW12(phy),
 			     0, ICL_LANE_ENABLE_AUX);
 
@@ -437,7 +445,10 @@ icl_combo_phy_aux_power_well_disable(struct drm_i915_private *dev_priv,
 
 	drm_WARN_ON(&dev_priv->drm, !IS_ICELAKE(dev_priv));
 
-	intel_de_rmw(dev_priv, ICL_PORT_CL_DW12(phy), ICL_LANE_ENABLE_AUX, 0);
+	/* FIXME this is a mess */
+	if (phy != PHY_NONE)
+		intel_de_rmw(dev_priv, ICL_PORT_CL_DW12(phy),
+			     ICL_LANE_ENABLE_AUX, 0);
 
 	intel_de_rmw(dev_priv, regs->driver, HSW_PWR_WELL_CTL_REQ(pw_idx), 0);
 
-- 
2.44.0



