Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4D4239573;
	Tue, 26 Aug 2025 11:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207639; cv=none; b=YVve66gNpTUjMSknxEevEBohybQveKKvmEESjXTlniWtkf5hJCGwjE9hQMPAAtQdZC1JM7PQ6s8KjfH+R6RHMFueu+J1cfICFMZLITMof4wB3Hs+bMFv/L4/8/9s+jRfgydsZDWlj/2TqrlDcKhihXcBoWLDpVufL2PJmjIiP6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207639; c=relaxed/simple;
	bh=8bORRnD/e3t5bb36KnmFYVmOreEYyQrFfgEolzDnYyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuIn5HJ7po658Mlsy6dt4JjfJrSed2Htw08vcN+DsfxZcpXpQuj7aX3sMXnwUlhFbmQF3lMTKxPcz37dL3auZm0XckAEAMvG4DSvgdxg+HSLuZZtFekhxQV6JANajUrQy5XGBwLlVGjJAiyMeFuj6BvbpNSrRUPHWgYWQtHX49I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maOa4NL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maOa4NL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F033C4CEF1;
	Tue, 26 Aug 2025 11:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207639;
	bh=8bORRnD/e3t5bb36KnmFYVmOreEYyQrFfgEolzDnYyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maOa4NL1hDAAxoKUGTRw8AANYcrp795rohQIOc6vKYrSpd91/M7YPznF1mH3z57/G
	 tcPgnT54OlZzbCbijjXyelTEeYmMGnj+6N4K9w6ZiYZXA3t0JiY/NJriBrSnTfGAfZ
	 ilXEmGZep2HTpP6CwG83MUEcVdoG/RtDcEXPty4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Charlton Lin <charlton.lin@intel.com>,
	Khaled Almahallawy <khaled.almahallawy@intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Subject: [PATCH 6.16 261/457] drm/i915/lnl+/tc: Fix handling of an enabled/disconnected dp-alt sink
Date: Tue, 26 Aug 2025 13:09:05 +0200
Message-ID: <20250826110943.826055205@linuxfoundation.org>
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

commit f52d6aa98379842fc255d93282655566f2114e0c upstream.

The TypeC PHY HW readout during driver loading and system resume
determines which TypeC mode the PHY is in (legacy/DP-alt/TBT-alt) and
whether the PHY is connected, based on the PHY's Owned and Ready flags.
For the PHY to be in DP-alt or legacy mode and for the PHY to be in the
connected state in these modes, both the Owned (set by the BIOS/driver)
and the Ready (set by the HW) flags should be set.

On ICL-MTL the HW kept the PHY's Ready flag set after the driver
connected the PHY by acquiring the PHY ownership (by setting the Owned
flag), until the driver disconnected the PHY by releasing the PHY
ownership (by clearing the Owned flag). On LNL+ this has changed, in
that the HW clears the Ready flag as soon as the sink gets disconnected,
even if the PHY ownership was acquired already and hence the PHY is
being used by the display.

When inheriting the HW state from BIOS for a PHY connected in DP-alt
mode on which the sink got disconnected - i.e. in a case where the sink
was connected while BIOS/GOP was running and so the sink got enabled
connecting the PHY, but the user disconnected the sink by the time the
driver loaded - the PHY Owned but not Ready state must be accounted for
on LNL+ according to the above. Do that by assuming on LNL+ that the PHY
is connected in DP-alt mode whenever the PHY Owned flag is set,
regardless of the PHY Ready flag.

This fixes a problem on LNL+, where the PHY TypeC mode / connected state
was detected incorrectly for a DP-alt sink, which got connected and then
disconnected by the user in the above way.

v2: Rename tc_phy_in_legacy_or_dp_alt_mode() to tc_phy_owned_by_display().
    (Luca, Jani)

Cc: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org # v6.8+
Reported-by: Charlton Lin <charlton.lin@intel.com>
Tested-by: Khaled Almahallawy <khaled.almahallawy@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
[Imre: Add one-liner function documentation for tc_phy_owned_by_display()]
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250811080152.906216-2-imre.deak@intel.com
(cherry picked from commit 89f4b196ee4b056e0e8c179b247b29d4a71a4e7e)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -1225,14 +1225,19 @@ static void tc_phy_get_hw_state(struct i
 	tc->phy_ops->get_hw_state(tc);
 }
 
-static bool tc_phy_is_ready_and_owned(struct intel_tc_port *tc,
-				      bool phy_is_ready, bool phy_is_owned)
+/* Is the PHY owned by display i.e. is it in legacy or DP-alt mode? */
+static bool tc_phy_owned_by_display(struct intel_tc_port *tc,
+				    bool phy_is_ready, bool phy_is_owned)
 {
 	struct intel_display *display = to_intel_display(tc->dig_port);
 
-	drm_WARN_ON(display->drm, phy_is_owned && !phy_is_ready);
+	if (DISPLAY_VER(display) < 20) {
+		drm_WARN_ON(display->drm, phy_is_owned && !phy_is_ready);
 
-	return phy_is_ready && phy_is_owned;
+		return phy_is_ready && phy_is_owned;
+	} else {
+		return phy_is_owned;
+	}
 }
 
 static bool tc_phy_is_connected(struct intel_tc_port *tc,
@@ -1243,7 +1248,7 @@ static bool tc_phy_is_connected(struct i
 	bool phy_is_owned = tc_phy_is_owned(tc);
 	bool is_connected;
 
-	if (tc_phy_is_ready_and_owned(tc, phy_is_ready, phy_is_owned))
+	if (tc_phy_owned_by_display(tc, phy_is_ready, phy_is_owned))
 		is_connected = port_pll_type == ICL_PORT_DPLL_MG_PHY;
 	else
 		is_connected = port_pll_type == ICL_PORT_DPLL_DEFAULT;
@@ -1351,7 +1356,7 @@ tc_phy_get_current_mode(struct intel_tc_
 	phy_is_ready = tc_phy_is_ready(tc);
 	phy_is_owned = tc_phy_is_owned(tc);
 
-	if (!tc_phy_is_ready_and_owned(tc, phy_is_ready, phy_is_owned)) {
+	if (!tc_phy_owned_by_display(tc, phy_is_ready, phy_is_owned)) {
 		mode = get_tc_mode_in_phy_not_owned_state(tc, live_mode);
 	} else {
 		drm_WARN_ON(display->drm, live_mode == TC_PORT_TBT_ALT);


