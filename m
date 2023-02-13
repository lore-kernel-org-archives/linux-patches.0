Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789BD8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ED6C433D2;
	Mon, 13 Feb 2023 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300415;
	bh=aG5+0nb8j+7Ps6ycHG1eVYf9qmIo11CD1bM1lM3h2QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQNjpjTv7CP9mn3SmT9KxWZuCIdc3wODwAfN5qQY9iCA7uFQTVir3EBfBcqd2DVpH
	 +YeAtNReTW3q8KCDLHufyH+6cFi888rj+7dPPmSnvEswACEeWIAM9elE9fHdI/Waml
	 Wb4EaWu8sNqjRq6uT1okPqZ/40WWIF3ArIt3QzhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 66/67] drm/i915: Fix VBT DSI DVO port handling
Date: Mon, 13 Feb 2023 15:49:47 +0100
Message-Id: <20230213144735.551218210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 6a7ff131f17f44c593173c5ee30e2c03ef211685 upstream.

Turns out modern (icl+) VBTs still declare their DSI ports
as MIPI-A and MIPI-C despite the PHYs now being A and B.
Remap appropriately to allow the panels declared as MIPI-C
to work.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8016
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230207064337.18697-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 118b5c136c04da705b274b0d39982bb8b7430fc5)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c |   33 ++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1820,6 +1820,22 @@ static enum port dvo_port_to_port(struct
 					  dvo_port);
 }
 
+static enum port
+dsi_dvo_port_to_port(struct drm_i915_private *i915, u8 dvo_port)
+{
+	switch (dvo_port) {
+	case DVO_PORT_MIPIA:
+		return PORT_A;
+	case DVO_PORT_MIPIC:
+		if (DISPLAY_VER(i915) >= 11)
+			return PORT_B;
+		else
+			return PORT_C;
+	default:
+		return PORT_NONE;
+	}
+}
+
 static int parse_bdb_230_dp_max_link_rate(const int vbt_max_link_rate)
 {
 	switch (vbt_max_link_rate) {
@@ -2733,19 +2749,16 @@ bool intel_bios_is_dsi_present(struct dr
 
 		dvo_port = child->dvo_port;
 
-		if (dvo_port == DVO_PORT_MIPIA ||
-		    (dvo_port == DVO_PORT_MIPIB && DISPLAY_VER(i915) >= 11) ||
-		    (dvo_port == DVO_PORT_MIPIC && DISPLAY_VER(i915) < 11)) {
-			if (port)
-				*port = dvo_port - DVO_PORT_MIPIA;
-			return true;
-		} else if (dvo_port == DVO_PORT_MIPIB ||
-			   dvo_port == DVO_PORT_MIPIC ||
-			   dvo_port == DVO_PORT_MIPID) {
+		if (dsi_dvo_port_to_port(i915, dvo_port) == PORT_NONE) {
 			drm_dbg_kms(&i915->drm,
 				    "VBT has unsupported DSI port %c\n",
 				    port_name(dvo_port - DVO_PORT_MIPIA));
+			continue;
 		}
+
+		if (port)
+			*port = dsi_dvo_port_to_port(i915, dvo_port);
+		return true;
 	}
 
 	return false;
@@ -2830,7 +2843,7 @@ bool intel_bios_get_dsc_params(struct in
 		if (!(child->device_type & DEVICE_TYPE_MIPI_OUTPUT))
 			continue;
 
-		if (child->dvo_port - DVO_PORT_MIPIA == encoder->port) {
+		if (dsi_dvo_port_to_port(i915, child->dvo_port) == encoder->port) {
 			if (!devdata->dsc)
 				return false;
 


