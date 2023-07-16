Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574C8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2557DC433BA;
	Sun, 16 Jul 2023 20:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541041;
	bh=ln/TPeLs+o3HMgCl+03UwH0hnjLaUcm0i6ZBarief/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ODTZZ9Q/PmXWFAkwZGuprxnH3jTgSfkpkkRMwUWNjHDIdS+5hxRsdhLW6rCiytNB
	 7hjPrOlffSDAyh1Vx2YxjWz9M9M2hZ3WefZ7Fhy0aHXm5TBlwiR5iXQKUYr5y3+YUe
	 biwLJWsFSktzaEilzUABSklslKEwMliZDqpeNNlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH 6.1 578/591] drm/i915/tc: Fix TC port link ref init for DP MST during HW readout
Date: Sun, 16 Jul 2023 21:51:57 +0200
Message-ID: <20230716194938.811584417@linuxfoundation.org>
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

commit 67165722c27cc46de112a4e10b450170c8980a6f upstream.

An enabled TC MST port holds one TC port link reference, regardless of
the number of enabled streams on it, but the TC port HW readout takes
one reference for each active MST stream.

Fix the HW readout, taking only one reference for MST ports.

This didn't cause an actual problem, since the encoder HW readout doesn't
yet support reading out the MST HW state.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230316131724.359612-3-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -683,11 +683,14 @@ static void intel_tc_port_update_mode(st
 	tc_cold_unblock(dig_port, domain, wref);
 }
 
-static void
-intel_tc_port_link_init_refcount(struct intel_digital_port *dig_port,
-				 int refcount)
+static void __intel_tc_port_get_link(struct intel_digital_port *dig_port)
 {
-	dig_port->tc_link_refcount = refcount;
+	dig_port->tc_link_refcount++;
+}
+
+static void __intel_tc_port_put_link(struct intel_digital_port *dig_port)
+{
+	dig_port->tc_link_refcount--;
 }
 
 /**
@@ -713,7 +716,7 @@ void intel_tc_port_init_mode(struct inte
 
 	dig_port->tc_mode = intel_tc_port_get_current_mode(dig_port);
 	/* Prevent changing dig_port->tc_mode until intel_tc_port_sanitize_mode() is called. */
-	intel_tc_port_link_init_refcount(dig_port, 1);
+	__intel_tc_port_get_link(dig_port);
 	dig_port->tc_lock_wakeref = tc_cold_block(dig_port, &dig_port->tc_lock_power_domain);
 
 	tc_cold_unblock(dig_port, domain, tc_cold_wref);
@@ -749,8 +752,6 @@ void intel_tc_port_sanitize_mode(struct
 		active_links = to_intel_crtc(encoder->base.crtc)->active;
 
 	drm_WARN_ON(&i915->drm, dig_port->tc_link_refcount != 1);
-	intel_tc_port_link_init_refcount(dig_port, active_links);
-
 	if (active_links) {
 		if (!icl_tc_phy_is_connected(dig_port))
 			drm_dbg_kms(&i915->drm,
@@ -769,6 +770,7 @@ void intel_tc_port_sanitize_mode(struct
 				    dig_port->tc_port_name,
 				    tc_port_mode_name(dig_port->tc_mode));
 		icl_tc_phy_disconnect(dig_port);
+		__intel_tc_port_put_link(dig_port);
 
 		tc_cold_unblock(dig_port, dig_port->tc_lock_power_domain,
 				fetch_and_zero(&dig_port->tc_lock_wakeref));
@@ -880,14 +882,14 @@ void intel_tc_port_get_link(struct intel
 			    int required_lanes)
 {
 	__intel_tc_port_lock(dig_port, required_lanes);
-	dig_port->tc_link_refcount++;
+	__intel_tc_port_get_link(dig_port);
 	intel_tc_port_unlock(dig_port);
 }
 
 void intel_tc_port_put_link(struct intel_digital_port *dig_port)
 {
 	intel_tc_port_lock(dig_port);
-	--dig_port->tc_link_refcount;
+	__intel_tc_port_put_link(dig_port);
 	intel_tc_port_unlock(dig_port);
 
 	/*


