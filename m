Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9595129BDAE;
	Tue, 26 Aug 2025 11:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207644; cv=none; b=R/yaOnasvoKLKQKjtQksT3xuSfOb5c198uPmCddip82iSB7jNlCYjc/6pSq00jAbfOw5L1MPOS5IzaalCA9fbrDIfaL2XD4hR4YLPYWsM7H8sClfmPO7RLZKDcU9krR6aj5hkss0O5DbCIRzFYEjODZ6aQ62Nm8Q/JkhLabldLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207644; c=relaxed/simple;
	bh=ZuUxwr2w6NSfWFPZ1Jd8YQ7FHIbPfm2+xzMKdgQazEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neIohfO6hylSkB20NYR54R/Y/qfMgLHY7HdP8qy9UypW1R3Q+xhtxFWbAlECgttcl5tkiYCCS6mpMhK7sFjC7+alxvqNqNN14efZbtn4T8J+tkaOaqhdZ2HF5SDt4WjLK0lY2fgVRBFJk20EoCIGWYUlNiATj8l9tg/bFM37m2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcJNupjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcJNupjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E24FC4CEF1;
	Tue, 26 Aug 2025 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207644;
	bh=ZuUxwr2w6NSfWFPZ1Jd8YQ7FHIbPfm2+xzMKdgQazEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcJNupjZGTTXDn9v7epRSfjmI7T1Ymp/yymYQZqs72n+Knf8Gh8LPlTmcnZme5yXW
	 n6ZVxkMCb5TBgAERv2HYJK4tM5RoBZIhcUxc6UJkBsh2QjuneOeygRPVEZsu+JB4cy
	 QivBzSOXCB5C4yUWYeEMAzijS1UcqTiZ8LECFKFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlton Lin <charlton.lin@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 263/457] drm/i915/lnl+/tc: Fix max lane count HW readout
Date: Tue, 26 Aug 2025 13:09:07 +0200
Message-ID: <20250826110943.877917151@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit c87514a0bb0a64507412a2d98264060dc0c1562a upstream.

On LNL+ for a disconnected sink the pin assignment value gets cleared by
the HW/FW as soon as the sink gets disconnected, even if the PHY
ownership got acquired already by the BIOS/driver (and hence the PHY
itself is still connected and used by the display). During HW readout
this can result in detecting the PHY's max lane count as 0 - matching
the above cleared aka NONE pin assignment HW state. For a connected PHY
the driver in general (outside of intel_tc.c) expects the max lane count
value to be valid for the video mode enabled on the corresponding output
(1, 2 or 4). Ensure this by setting the max lane count to 4 in this
case. Note, that it doesn't matter if this lane count happened to be
more than the max lane count with which the PHY got connected and
enabled, since the only thing the driver can do with such an output -
where the DP-alt sink is disconnected - is to disable the output.

v2: Rebased on change reading out the pin configuration only if the PHY
    is connected.

Cc: stable@vger.kernel.org # v6.8+
Reported-by: Charlton Lin <charlton.lin@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250811080152.906216-4-imre.deak@intel.com
(cherry picked from commit 33cf70bc0fe760224f892bc1854a33665f27d482)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -22,6 +22,7 @@
 #include "intel_modeset_lock.h"
 #include "intel_tc.h"
 
+#define DP_PIN_ASSIGNMENT_NONE	0x0
 #define DP_PIN_ASSIGNMENT_C	0x3
 #define DP_PIN_ASSIGNMENT_D	0x4
 #define DP_PIN_ASSIGNMENT_E	0x5
@@ -307,6 +308,8 @@ static int lnl_tc_port_get_max_lane_coun
 		REG_FIELD_GET(TCSS_DDI_STATUS_PIN_ASSIGNMENT_MASK, val);
 
 	switch (pin_assignment) {
+	case DP_PIN_ASSIGNMENT_NONE:
+		return 0;
 	default:
 		MISSING_CASE(pin_assignment);
 		fallthrough;
@@ -1158,6 +1161,12 @@ static void xelpdp_tc_phy_get_hw_state(s
 		tc->lock_wakeref = tc_cold_block(tc);
 
 		read_pin_configuration(tc);
+		/*
+		 * Set a valid lane count value for a DP-alt sink which got
+		 * disconnected. The driver can only disable the output on this PHY.
+		 */
+		if (tc->max_lane_count == 0)
+			tc->max_lane_count = 4;
 	}
 
 	drm_WARN_ON(display->drm,


