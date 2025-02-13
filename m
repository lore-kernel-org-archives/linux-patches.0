Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA6813F434;
	Thu, 13 Feb 2025 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457515; cv=none; b=e1Kz0//bihZ1CYV70dxlmatUtm/nPHkSTFyCq0eHLnNwJ1xK46nVpBae12CiQZsiCqaN6LT9kTBU09A+ws7KShEaNGYyWoIqV1KfwrvEBVjNoDKwb1EG5w6zvWffnQq/5asIVdf/ijvPXVM6zsE05Bybx6b/Ow2pE4AzjhY14k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457515; c=relaxed/simple;
	bh=jsLl53AYg/aEaPatqFdV/5DjQakbxxISP7zf0mRow2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq7EP3iGd4s8PbOmodDGuWPMfkyv5MBvAI3f9Pk7Gkuws9SVcD3lHDICt4jSuTKA5SOQbfMLdRqAqI7bov1dBnuUaiDoYhxdf8o/XKPGofw0X4zqVCWGv70IzjVyJML97C/VqGSRH3W1imEcQV/e3Hfpz23oL4RVRqO4DvRQTuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THJo9OhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THJo9OhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F19AC4CED1;
	Thu, 13 Feb 2025 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457515;
	bh=jsLl53AYg/aEaPatqFdV/5DjQakbxxISP7zf0mRow2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THJo9OhYgFwgsGw1M50bV46Huj532apH1Gnk/KmxqblWD8ov4sdr3RC5qO3kN62eE
	 2E6q7ACtyCNVzow8SI45RPeJcmV2XEUo0TPEczIk9pnC7m0VT4rZkVytLziVstCfvp
	 /Y9WlftZPsS5u1uiCwaaDa28zTPvGQAchr/4deYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 6.12 134/422] drm/client: Handle tiled displays better
Date: Thu, 13 Feb 2025 15:24:43 +0100
Message-ID: <20250213142441.720073571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Maarten Lankhorst <dev@lankhorst.se>

commit 10026f536843eb8c9148ef6ffb4c6deeebc26838 upstream.

When testing on my tiled display, initially the tiled display is
detected correctly:
[90376.523692] xe 0000:67:00.0: [drm:drm_client_firmware_config.isra.0 [drm]] fallback: Not all outputs enabled
[90376.523713] xe 0000:67:00.0: [drm:drm_client_firmware_config.isra.0 [drm]] Enabled: 0, detected: 2
...
[90376.523967] xe 0000:67:00.0: [drm:drm_client_modeset_probe [drm]] [CRTC:82:pipe A] desired mode 1920x2160 set (1920,0)
[90376.524020] xe 0000:67:00.0: [drm:drm_client_modeset_probe [drm]] [CRTC:134:pipe B] desired mode 1920x2160 set (0,0)

But then, when modes have been set:
[90379.729525] xe 0000:67:00.0: [drm:drm_client_firmware_config.isra.0 [drm]] [CONNECTOR:287:DP-4] on [CRTC:82:pipe A]: 1920x2160
[90379.729640] xe 0000:67:00.0: [drm:drm_client_firmware_config.isra.0 [drm]] [CONNECTOR:289:DP-5] on [CRTC:134:pipe B]: 1920x2160
...
[90379.730036] xe 0000:67:00.0: [drm:drm_client_modeset_probe [drm]] [CRTC:82:pipe A] desired mode 1920x2160 set (0,0)
[90379.730124] xe 0000:67:00.0: [drm:drm_client_modeset_probe [drm]] [CRTC:134:pipe B] desired mode 1920x2160 set (0,0)

Call drm_client_get_tile_offsets() in drm_client_firmware_config() as
well, to ensure that the offset is set correctly.

This has to be done as a separate pass, as the tile order may not be
equal to the drm connector order.

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20250116142825.3933-2-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_client_modeset.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -741,6 +741,15 @@ retry:
 	if ((conn_configured & mask) != mask && conn_configured != conn_seq)
 		goto retry;
 
+	for (i = 0; i < count; i++) {
+		struct drm_connector *connector = connectors[i];
+
+		if (connector->has_tile)
+			drm_client_get_tile_offsets(dev, connectors, connector_count,
+						    modes, offsets, i,
+						    connector->tile_h_loc, connector->tile_v_loc);
+	}
+
 	/*
 	 * If the BIOS didn't enable everything it could, fall back to have the
 	 * same user experiencing of lighting up as much as possible like the


