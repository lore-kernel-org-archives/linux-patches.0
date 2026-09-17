Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA250E5A1;
	Thu, 17 Sep 2026 17:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666344; cv=none; b=AW0siPhzdx+f70JctXvtWIcqkCFtJtlLWuB/6QT6g+pkX/ehFXmYmJp90oyFH5MFtuevfO4FBuaS3d4u54n+MFYvwRDGB6vTKq50lMCPNUIB1+rMyT//sfY/Z8Xh3UZD0d2qZ9LQLDE8cOr7rSwStJWIT/78Jw420/jj4ZgusOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666344; c=relaxed/simple;
	bh=DXjrI6c3PLdK9ciEw46WWCRzDV7Ja/r76mIFFiiWFqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No+XYP2DG+8ShW0opwCYDufTggyKaXxq9WjwHEC5BD02q4DQLMzNA+D16wMnhrxP3mrarzozCeiX0cAuKr18SRgUEDMH6LUMFgqmCVt93e3BinbWiXDWhuAWMmDsrf3alS5bv86ms6pNrj0JNGk4fp+Dn3g68ETlz+h7kbiYDRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6/27i0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6/27i0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6791F00893;
	Thu, 17 Sep 2026 17:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666342;
	bh=xGEKsSMZ2Q7gyIVvSq9W9mtVRhlk5bTcY2GJgVxPVNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s6/27i0UHR/qcVHx1yKyscH1cHywf+kn1QU0YE0HFgjnxFbzu1dtnbWa73LCLLJva
	 JrgutGIUIkt289th+lxHL7ufG86XM6OCPz7rRnoWdiQZsAZMbC9WMaw+Fdi9ixIeXu
	 26RnJnfyUB8gIydjMP8D5OopW/vdB1vIJypCXQZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonardo Costa <leonardo.costa@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Swamil Jain <s-jain1@ti.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 1005/1250] drm/bridge: tc358768: Enforce input bus flags via atomic_check
Date: Thu, 17 Sep 2026 16:13:20 +0100
Message-ID: <20260917151619.282557870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonardo Costa <leonardo.costa@toradex.com>

commit ed761e0693950fcb4f6b0f60387a3961b972adf3 upstream.

The tc358768 declares static bridge timings requiring pixel data to be
sampled on the positive clock edge.

However, the DRM core default propagation simply copies the output-side
bus flags, coming from the next bridge, connector or panel, to the
input side. If the propagated flags are incompatible with the bridge
ones, the data is wrongly sampled, typically resulting in visual
artifacts on the panel.

Implement the atomic_check hook, replacing the mutually exclusive
mode_fixup, and set the bridge state input bus flags to the ones
required by the tc358768. The sync polarity defaulting previously done
in mode_fixup is carried over into atomic_check unchanged.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Leonardo Costa <leonardo.costa@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Swamil Jain <s-jain1@ti.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260706132440.1594239-1-leoreis.costa@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/tc358768.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -1152,10 +1152,13 @@ tc358768_atomic_get_input_bus_fmts(struc
 	return input_fmts;
 }
 
-static bool tc358768_mode_fixup(struct drm_bridge *bridge,
-				const struct drm_display_mode *mode,
-				struct drm_display_mode *adjusted_mode)
+static int tc358768_bridge_atomic_check(struct drm_bridge *bridge,
+					struct drm_bridge_state *bridge_state,
+					struct drm_crtc_state *crtc_state,
+					struct drm_connector_state *conn_state)
 {
+	struct drm_display_mode *adjusted_mode = &crtc_state->adjusted_mode;
+
 	/* Default to positive sync */
 
 	if (!(adjusted_mode->flags &
@@ -1166,13 +1169,15 @@ static bool tc358768_mode_fixup(struct d
 	      (DRM_MODE_FLAG_PVSYNC | DRM_MODE_FLAG_NVSYNC)))
 		adjusted_mode->flags |= DRM_MODE_FLAG_PVSYNC;
 
-	return true;
+	bridge_state->input_bus_cfg.flags = bridge->timings->input_bus_flags;
+
+	return 0;
 }
 
 static const struct drm_bridge_funcs tc358768_bridge_funcs = {
 	.attach = tc358768_bridge_attach,
 	.mode_valid = tc358768_bridge_mode_valid,
-	.mode_fixup = tc358768_mode_fixup,
+	.atomic_check = tc358768_bridge_atomic_check,
 	.atomic_pre_enable = tc358768_bridge_atomic_pre_enable,
 	.atomic_enable = tc358768_bridge_atomic_enable,
 	.atomic_disable = tc358768_bridge_atomic_disable,


