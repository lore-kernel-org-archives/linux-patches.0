Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEE61CA8F;
	Mon,  1 Apr 2024 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987600; cv=none; b=Aqngqs4DHTeP8WxcwJu5cGeskSuyOtqjw06/BvGWb8nMGm70Tp102pH9tq3S50YMF6VmrFIMKN7ZUgJt33lqb1i9DLW1bx4eDndjAIvhT3onvmxrjp74NfKe0xpfFUUfZ8dArjmr8VEwwaD2Jsjzjkt2UUHyzsyKH5e6c3SYNSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987600; c=relaxed/simple;
	bh=7Oc+u0nYtLp3XxmkuAuB5u+EYRbXz7eXQvGN0xpFhiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBH7EhG0ANqWF+bkJDJWhAYHgHvn0eFsi/X7bzTm6GBgA2OyLgMeRQLEHlLFGPlkkM3h5cVrA20Nxfb0q6Zr7U0IbEVheTwTV64niMP2sY27+xQsDKGYNdr9SAHpUoKgtA+dqZKSfDoUOwt1XG8WDNWjlVZUBbkNiiKTau/SB9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PooBA0Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PooBA0Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82380C433F1;
	Mon,  1 Apr 2024 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987600;
	bh=7Oc+u0nYtLp3XxmkuAuB5u+EYRbXz7eXQvGN0xpFhiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PooBA0DiOerAIIST6xxVYhDNl1krGjsAiOGgKReZJULH51izZ4y2/DNMLDNZIaiM7
	 MmeP9PopEtKXo0DR4IL9txA8FKbsQrekXPdk3s+l31u7Dj7gsDHnYRXvDjHMi/HMQH
	 RPPWLXndzhEwwj8X7NW/0wT1xm0QwD5uyWj/Bsu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathon Hall <jonathon.hall@puri.sm>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 336/399] drm/i915: Do not match JSL in ehl_combo_pll_div_frac_wa_needed()
Date: Mon,  1 Apr 2024 17:45:02 +0200
Message-ID: <20240401152559.205857077@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2509,7 +2509,7 @@ static void icl_wrpll_params_populate(st
 static bool
 ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
-	return (((IS_ELKHARTLAKE(i915) || IS_JASPERLAKE(i915)) &&
+	return ((IS_ELKHARTLAKE(i915) &&
 		 IS_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
 		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->display.dpll.ref_clks.nssc == 38400;


