Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CC04D9F6;
	Mon,  1 Apr 2024 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990411; cv=none; b=RN9MXfQO0m+o60MJp6cXgrvOIZDKEfeOmmDHUW5I6HZWXaF004AZESQDo2d4nA2zIbThoR9HlADFSiwQfdQ7odcGFf1zATSWfqC3uU/2CgWYSBd/tfjk4EGbp+dB5dobJ4fhRyJBcUGQhZj3ywsWKQLX6sTt7fed6GNpkUh+tEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990411; c=relaxed/simple;
	bh=3Z6iiYY9lX3Q+6lKbfcehWlMXpiAYuTJclcAmjr3Heo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W33eFDxMaQxL3sUOzw1RB79bFZ+0Zuk8Yc7mjr/9tR+F09sx6XyFfxY+4zMmwYfun/Kz2E2jvr3TxwZe+pHZEIsypFhgtQOtqYLQk1+bU3iFagc+VIPk/THL4xCXtuvoutN9LlR3WC6bQi4QRVKXsxr5MFG/F0EzUYwwDUbmoIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7kDJzEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7kDJzEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB333C433F1;
	Mon,  1 Apr 2024 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990411;
	bh=3Z6iiYY9lX3Q+6lKbfcehWlMXpiAYuTJclcAmjr3Heo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7kDJzEiof02+hChZphUzhhzeg0KrFAnYhY3F5uJkVYzj2OM6nVHVVNcdzYRNHyBN
	 4ZjH5hTXnL5A4L9pd2qwFgab0XSFipdAmBdqEx9/5a6iI9EOcbzBWW9whN27/QNE3K
	 pDMRDkuh4mn+QUG2l5Ldg759wQA5BdEAyYjwuwQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathon Hall <jonathon.hall@puri.sm>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.6 345/396] drm/i915: Do not match JSL in ehl_combo_pll_div_frac_wa_needed()
Date: Mon,  1 Apr 2024 17:46:34 +0200
Message-ID: <20240401152558.203188486@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2462,7 +2462,7 @@ static void icl_wrpll_params_populate(st
 static bool
 ehl_combo_pll_div_frac_wa_needed(struct drm_i915_private *i915)
 {
-	return (((IS_ELKHARTLAKE(i915) || IS_JASPERLAKE(i915)) &&
+	return ((IS_ELKHARTLAKE(i915) &&
 		 IS_DISPLAY_STEP(i915, STEP_B0, STEP_FOREVER)) ||
 		 IS_TIGERLAKE(i915) || IS_ALDERLAKE_S(i915) || IS_ALDERLAKE_P(i915)) &&
 		 i915->display.dpll.ref_clks.nssc == 38400;


