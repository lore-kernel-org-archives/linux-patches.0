Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1C826B098;
	Thu, 13 Feb 2025 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459030; cv=none; b=S4+jSS659jAd4DaGGtiu00ufnYLF/IX5sp92wOaxZR3chACR/NvxtKob3A81P4fu9jVyg+H08ujm7vBd7XOh/n0Z+Ozf3nx8w2lWGwDk+PsexMBaJBTyJGyPqqlGyBlK5rzTGaKdTn2wLxfBb/910qi75gpgB1n1E4+pZl6VfvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459030; c=relaxed/simple;
	bh=/5ieJs5zNCcPootpiu/OsIL2a7sOKtlYj5K+zhJmKno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOWTKN9wtffO7JLlVTrqxN5QXogTgRDRwAH/ip/P34y7WZqbhwGQS5zoJukkyWl9Z77FnHMdggI14bn0n1w81iAKhGRjocQRzDNreW1BwEBgLGAWGofdAEDCQkEsnpb8h9pelOryzZvgfdO0uIgALTiEeQ4wVhUHAhoILmKfX40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goLff/91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goLff/91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCB9C4CED1;
	Thu, 13 Feb 2025 15:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459030;
	bh=/5ieJs5zNCcPootpiu/OsIL2a7sOKtlYj5K+zhJmKno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goLff/91b7jIIuvtEnQSn0xukKsJPtI2fFh5zHQGtqmD/NzgdBD32NQUfO7+FatL1
	 KU08B0c/SP/dL77vhkjMy+Qq0lfCa93tP8VMqUXWohm2ele3F0IX5JVyELX9B0FPcK
	 Oyopq2dEeo4ofUKMAUvlLs+hS8J3EPqad2st8xME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 6.13 148/443] drm/client: Handle tiled displays better
Date: Thu, 13 Feb 2025 15:25:13 +0100
Message-ID: <20250213142446.309264645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -743,6 +743,15 @@ retry:
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


