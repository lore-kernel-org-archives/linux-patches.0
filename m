Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8E746B9F;
	Mon,  1 Apr 2024 16:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989083; cv=none; b=LY/y98KVsv79L97sBnQYmRwghVPKo1xz8jweU+yGSl3Cz1YbEO+ZAu5OMXsOuNlS++c9UkwXtMr1GwrAFg5Uy6x9V/mwUPpu2bI8SEPpEu1BYmldjHv2l+AR2Y8rPsMVzCzh1fglpV1Z7qFzpqVYdNc9TD9n2nBjPhKExVlumwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989083; c=relaxed/simple;
	bh=lsCFDHXb5R7qXfljthDl7WxC7rE8CeZQQXwVxfgO478=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYAsBjS4+yzydAmZYTONidyUZ7vNM8USgGzTGTvylw4pV1QGCdT0S0hTIyOfk+x9++FHmIpMYe8aSgH520vay+jI+14KcHfr+AgLr82JfxLHvW28NgRVhFXQoSmNUOx4Fm19vRxVqlCdXcTerCZ3A52+mDz3TDs6WLYdsIPYSFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAQ4zijH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAQ4zijH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7A3C433F1;
	Mon,  1 Apr 2024 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989083;
	bh=lsCFDHXb5R7qXfljthDl7WxC7rE8CeZQQXwVxfgO478=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAQ4zijHOg/1EdPMw30o6cMr5p9fqOMNoL/6lW7fdvFEXzJsZcE7Mt5Euozg35hw/
	 8iG75zAgwzcQiuW+w3/aQfcrxC+y7h8iIeBoc2c+InPQh9pYMawDVGOVPXcTpWHkEd
	 nBy/an65LnC5uXgp6CLvGXWTdOOPULkui3/QU1JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathon Hall <jonathon.hall@puri.sm>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.7 375/432] drm/i915: Do not match JSL in ehl_combo_pll_div_frac_wa_needed()
Date: Mon,  1 Apr 2024 17:46:02 +0200
Message-ID: <20240401152604.473674271@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathon Hall <jonathon.hall@puri.sm>

commit e41d769f1a7a1dc533c35ef7b366be3dbf432a1c upstream.

Since commit 0c65dc062611 ("drm/i915/jsl: s/JSL/JASPERLAKE for
platform/subplatform defines"), boot freezes on a Jasper Lake tablet
(Librem 11), usually with graphical corruption on the eDP display,
but sometimes just a black screen.  This commit was included in 6.6 and
later.

That commit was intended to refactor EHL and JSL macros, but the change
to ehl_combo_pll_div_frac_wa_needed() started matching JSL incorrectly
when it was only intended to match EHL.

It replaced:
	return ((IS_PLATFORM(i915, INTEL_ELKHARTLAKE) &&
		 IS_JSL_EHL_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
with:
	return (((IS_ELKHARTLAKE(i915) || IS_JASPERLAKE(i915)) &&
		 IS_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||

Remove IS_JASPERLAKE() to fix the regression.

Signed-off-by: Jonathon Hall <jonathon.hall@puri.sm>
Cc: stable@vger.kernel.org
Fixes: 0c65dc062611 ("drm/i915/jsl: s/JSL/JASPERLAKE for platform/subplatform defines")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240313135424.3731410-1-jonathon.hall@puri.sm
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 1ef48859317b2a77672dea8682df133abf9c44ed)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
+++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
@@ -2489,7 +2489,7 @@ static void icl_wrpll_params_populate(st
 static bool
 ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
-	return (((IS_ELKHARTLAKE(i915) || IS_JASPERLAKE(i915)) &&
+	return ((IS_ELKHARTLAKE(i915) &&
 		 IS_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
 		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->display.dpll.ref_clks.nssc == 38400;


