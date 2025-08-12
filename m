Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93473F9D2;
	Tue, 12 Aug 2025 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023049; cv=none; b=ojsIUIQoeW5oIt7vJGv+tn+mXg7ymP+PMcwRfD27MW4AfN0/0gLndMdNOR11d1Tqj4MjQR8Z5qvDySMYYnKNMicaBwwaUdnw1Ys6lLG656hFjOcjBVsvCtfu0eN5RBK7dYrkPJ+dW+fTePb5n7LY35CNMy2wB0x25wSTddArXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023049; c=relaxed/simple;
	bh=Wki39VWw+jbe7nsim1fK4rOSxmx+lJHi9yurrxGHoIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9P6/Rd39vxET5DCIubKNuFgp/WX+PeNAvBScKtRA8et+pVXMlEoLDoepxFeQdAYnA1tl/knrJ1epAI2zaX5Sfzof1gZTN7D0VsiMwCFC9knySo+6i2tylI1GJ5uNq7icKXarp3k+Wft/k+BMt3KUklqAdKUN/S6+oW7TIBp+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpJ+T6a3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpJ+T6a3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577E5C4CEF0;
	Tue, 12 Aug 2025 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023048;
	bh=Wki39VWw+jbe7nsim1fK4rOSxmx+lJHi9yurrxGHoIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpJ+T6a3bYqkmnAkH8ATt5MACUxn/U2v6PHYXSZkZ4F9z83V2B58DDg1h+uGGgt7J
	 5kvorA2ka1PvgdTpDX3AzT77hze23CXTvGPjdsvea1wfy+gmSOQFo0YDb38ZOGT5rv
	 u8os7FYFmxBQtgrbrm580fkhkyDPogXEv+lni3YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 335/369] drm/i915/ddi: change intel_ddi_init_{dp, hdmi}_connector() return type
Date: Tue, 12 Aug 2025 19:30:32 +0200
Message-ID: <20250812173029.308804404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit e1980a977686d46dbf45687f7750f1c50d1d6cf8 upstream.

The caller doesn't actually need the returned struct intel_connector;
it's stored in the ->attached_connector of intel_dp and
intel_hdmi. Switch to returning an int with 0 for success and negative
errors codes to be able to indicate success even when we don't have a
connector.

Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/8ef7fe838231919e85eaead640c51ad3e4550d27.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4413,8 +4413,7 @@ static const struct drm_encoder_funcs in
 	.late_register = intel_ddi_encoder_late_register,
 };
 
-static struct intel_connector *
-intel_ddi_init_dp_connector(struct intel_digital_port *dig_port)
+static int intel_ddi_init_dp_connector(struct intel_digital_port *dig_port)
 {
 	struct drm_i915_private *i915 = to_i915(dig_port->base.base.dev);
 	struct intel_connector *connector;
@@ -4422,7 +4421,7 @@ intel_ddi_init_dp_connector(struct intel
 
 	connector = intel_connector_alloc();
 	if (!connector)
-		return NULL;
+		return -ENOMEM;
 
 	dig_port->dp.output_reg = DDI_BUF_CTL(port);
 	if (DISPLAY_VER(i915) >= 14)
@@ -4437,7 +4436,7 @@ intel_ddi_init_dp_connector(struct intel
 
 	if (!intel_dp_init_connector(dig_port, connector)) {
 		kfree(connector);
-		return NULL;
+		return -EINVAL;
 	}
 
 	if (dig_port->base.type == INTEL_OUTPUT_EDP) {
@@ -4453,7 +4452,7 @@ intel_ddi_init_dp_connector(struct intel
 		}
 	}
 
-	return connector;
+	return 0;
 }
 
 static int intel_hdmi_reset_link(struct intel_encoder *encoder,
@@ -4623,20 +4622,19 @@ static bool bdw_digital_port_connected(s
 	return intel_de_read(dev_priv, GEN8_DE_PORT_ISR) & bit;
 }
 
-static struct intel_connector *
-intel_ddi_init_hdmi_connector(struct intel_digital_port *dig_port)
+static int intel_ddi_init_hdmi_connector(struct intel_digital_port *dig_port)
 {
 	struct intel_connector *connector;
 	enum port port = dig_port->base.port;
 
 	connector = intel_connector_alloc();
 	if (!connector)
-		return NULL;
+		return -ENOMEM;
 
 	dig_port->hdmi.hdmi_reg = DDI_BUF_CTL(port);
 	intel_hdmi_init_connector(dig_port, connector);
 
-	return connector;
+	return 0;
 }
 
 static bool intel_ddi_a_force_4_lanes(struct intel_digital_port *dig_port)
@@ -5185,7 +5183,7 @@ void intel_ddi_init(struct intel_display
 	intel_infoframe_init(dig_port);
 
 	if (init_dp) {
-		if (!intel_ddi_init_dp_connector(dig_port))
+		if (intel_ddi_init_dp_connector(dig_port))
 			goto err;
 
 		dig_port->hpd_pulse = intel_dp_hpd_pulse;
@@ -5199,7 +5197,7 @@ void intel_ddi_init(struct intel_display
 	 * but leave it just in case we have some really bad VBTs...
 	 */
 	if (encoder->type != INTEL_OUTPUT_EDP && init_hdmi) {
-		if (!intel_ddi_init_hdmi_connector(dig_port))
+		if (intel_ddi_init_hdmi_connector(dig_port))
 			goto err;
 	}
 


