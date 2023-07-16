Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92A8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0712EC433C8;
	Sun, 16 Jul 2023 20:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541100;
	bh=PT85VmMSCmhF8xBs/JYdQvdWlBnmjrxUSUkYFLmAVTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxjRwC40TRjFuWw7H5KWyrnuARh+oxFLirztv+TaXP7GidZcZc7Tkd+0DGQJhoIZY
	 aApAICwQNq10lGNN1zA/3BO4NpSQDTzMuty39nNvEQFnyNV6s4gKRb0cdGWiHwwWoZ
	 Pb8E7EzkmRKYUDNHdpLzqhOCnq2Mz4OsWjTtRfuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Subject: [PATCH 6.1 579/591] drm/i915/tc: Fix system resume MST mode restore for DP-alt sinks
Date: Sun, 16 Jul 2023 21:51:58 +0200
Message-ID: <20230716194938.837928439@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

commit 06f66261a1567d66b9d35c87393b6edfbea4c8f8 upstream.

At least restoring the MST topology during system resume needs to use
AUX before the display HW readout->sanitization sequence is complete,
but on TC ports the PHY may be in the wrong mode for this, resulting in
the AUX transfers to fail.

The initial TC port mode is kept fixed as BIOS left it for the above HW
readout sequence (to prevent changing the mode on an enabled port).  If
the port is disabled this initial mode is TBT - as in any case the PHY
ownership is not held - even if a DP-alt sink is connected. Thus, the
AUX transfers during this time will use TBT mode instead of the expected
DP-alt mode and so time out.

Fix the above by connecting the PHY during port initialization if the
port is disabled, which will switch to the expected mode (DP-alt in the
above case).

As the encoder/pipe HW state isn't read-out yet at this point, check if
the port is enabled based on the DDI_BUF enabled flag. Save the read-out
initial mode, so intel_tc_port_sanitize_mode() can check this wrt. the
read-out encoder HW state.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316131724.359612-5-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_display_types.h |    1 
 drivers/gpu/drm/i915/display/intel_tc.c            |   49 +++++++++++++++++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_display_types.h
+++ b/drivers/gpu/drm/i915/display/intel_display_types.h
@@ -1763,6 +1763,7 @@ struct intel_digital_port {
 	bool tc_legacy_port:1;
 	char tc_port_name[8];
 	enum tc_port_mode tc_mode;
+	enum tc_port_mode tc_init_mode;
 	enum phy_fia tc_phy_fia;
 	u8 tc_phy_fia_idx;
 
--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -5,6 +5,7 @@
 
 #include "i915_drv.h"
 #include "i915_reg.h"
+#include "intel_de.h"
 #include "intel_display.h"
 #include "intel_display_power_map.h"
 #include "intel_display_types.h"
@@ -116,6 +117,24 @@ assert_tc_cold_blocked(struct intel_digi
 	drm_WARN_ON(&i915->drm, !enabled);
 }
 
+static enum intel_display_power_domain
+tc_port_power_domain(struct intel_digital_port *dig_port)
+{
+	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+	enum tc_port tc_port = intel_port_to_tc(i915, dig_port->base.port);
+
+	return POWER_DOMAIN_PORT_DDI_LANES_TC1 + tc_port - TC_PORT_1;
+}
+
+static void
+assert_tc_port_power_enabled(struct intel_digital_port *dig_port)
+{
+	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+
+	drm_WARN_ON(&i915->drm,
+		    !intel_display_power_is_enabled(i915, tc_port_power_domain(dig_port)));
+}
+
 u32 intel_tc_port_get_lane_mask(struct intel_digital_port *dig_port)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
@@ -693,6 +712,16 @@ static void __intel_tc_port_put_link(str
 	dig_port->tc_link_refcount--;
 }
 
+static bool tc_port_is_enabled(struct intel_digital_port *dig_port)
+{
+	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
+
+	assert_tc_port_power_enabled(dig_port);
+
+	return intel_de_read(i915, DDI_BUF_CTL(dig_port->base.port)) &
+	       DDI_BUF_CTL_ENABLE;
+}
+
 /**
  * intel_tc_port_init_mode: Read out HW state and init the given port's TypeC mode
  * @dig_port: digital port
@@ -715,9 +744,23 @@ void intel_tc_port_init_mode(struct inte
 	tc_cold_wref = tc_cold_block(dig_port, &domain);
 
 	dig_port->tc_mode = intel_tc_port_get_current_mode(dig_port);
+	/*
+	 * Save the initial mode for the state check in
+	 * intel_tc_port_sanitize_mode().
+	 */
+	dig_port->tc_init_mode = dig_port->tc_mode;
+	dig_port->tc_lock_wakeref = tc_cold_block(dig_port, &dig_port->tc_lock_power_domain);
+
+	/*
+	 * The PHY needs to be connected for AUX to work during HW readout and
+	 * MST topology resume, but the PHY mode can only be changed if the
+	 * port is disabled.
+	 */
+	if (!tc_port_is_enabled(dig_port))
+		intel_tc_port_update_mode(dig_port, 1, false);
+
 	/* Prevent changing dig_port->tc_mode until intel_tc_port_sanitize_mode() is called. */
 	__intel_tc_port_get_link(dig_port);
-	dig_port->tc_lock_wakeref = tc_cold_block(dig_port, &dig_port->tc_lock_power_domain);
 
 	tc_cold_unblock(dig_port, domain, tc_cold_wref);
 
@@ -764,11 +807,11 @@ void intel_tc_port_sanitize_mode(struct
 		 * we'll just switch to disconnected mode from it here without
 		 * a note.
 		 */
-		if (dig_port->tc_mode != TC_PORT_TBT_ALT)
+		if (dig_port->tc_init_mode != TC_PORT_TBT_ALT)
 			drm_dbg_kms(&i915->drm,
 				    "Port %s: PHY left in %s mode on disabled port, disconnecting it\n",
 				    dig_port->tc_port_name,
-				    tc_port_mode_name(dig_port->tc_mode));
+				    tc_port_mode_name(dig_port->tc_init_mode));
 		icl_tc_phy_disconnect(dig_port);
 		__intel_tc_port_put_link(dig_port);
 


