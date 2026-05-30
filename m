Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1CC3AB476;
	Sat, 30 May 2026 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162217; cv=none; b=aiBwQEyqx8vztSM8Pl2ebJgqQ0FMVi/jm+GWwBFwSsdgmP1es2uyiaOt/U/QPiisfb3PIWvBhQVbr2Jh5fQPXBRtps3LpTHE7Ykb0r31oScZi+7+Eb0tzr2brJqqWKEdtX594ymkbToY1OU6ARjvYzxqbRcZMBycHknHVDhsCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162217; c=relaxed/simple;
	bh=MZZyRrkGv0x0e5+an+vSgUZKmMr2QhAhJt5oTOPHoqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfG0R9YvzDD4oDck143wuo2w/Q7kQvZv/6GBRA4jjbSdOe8554aLwErX65oUiZlgLoaOQJiZO9NQ5JnoPdHTa/i4Bjm9TnZ+A6kohRUQ5mdloCDRS3Cb2CXl6trLc2kqpr/3uVq8IqHVdojQmWFJd8JaweUHBvaQwDuyQGM3e9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytu3xkgE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytu3xkgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F299E1F00893;
	Sat, 30 May 2026 17:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162215;
	bh=ik782KBnREBjq52nQV1YmV97jLfGo7tNGIVpVcZen7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytu3xkgE8ivb3A95ag0bzPj8m3F1dXfEgxYxqHE/8qY2YCu/WmIbAemRK6cwInoEV
	 UGe7dp1O+uGEyjVlDgMNglaHsu4DlDXSLlT6e7pPuXTuK1b+GskPwS6WYmxfRRVcuS
	 mq6CmhlibiuZqMVDLbULLAsWTNAUZRMa7FjwmimQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 828/969] drm/gma500/oaktrail_lvds: fix hang on init failure
Date: Sat, 30 May 2026 18:05:52 +0200
Message-ID: <20260530160323.506757667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 657a091ab6d01d0091b77660c75cfed573c9a53e upstream.

The LVDS init code looks up an I2C adapter using i2c_get_adapter() and
tries to read the EDID before falling back to allocating and registering
its own adapter.

The error handling does not separate these cases so on a late init
failure it will try to deregister and free also an adapter that had
previously been registered. Since i2c_get_adapter() takes another
reference to the adapter, deregistration hangs indefinitely while
waiting for the reference to be released.

Fix this by only destroying adapters allocated during LVDS init on
errors.

Fixes: a57ebfc0b4da ("drm/gma500: Make oaktrail lvds use ddc adapter from drm_connector")
Cc: stable@vger.kernel.org	# 6.0
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_lvds.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -293,7 +293,7 @@ void oaktrail_lvds_init(struct drm_devic
 {
 	struct gma_encoder *gma_encoder;
 	struct gma_connector *gma_connector;
-	struct gma_i2c_chan *ddc_bus;
+	struct gma_i2c_chan *ddc_bus = NULL;
 	struct drm_connector *connector;
 	struct drm_encoder *encoder;
 	struct drm_psb_private *dev_priv = to_drm_psb_private(dev);
@@ -421,7 +421,8 @@ out:
 
 err_unlock:
 	mutex_unlock(&dev->mode_config.mutex);
-	gma_i2c_destroy(to_gma_i2c_chan(connector->ddc));
+	if (!IS_ERR_OR_NULL(ddc_bus))
+		gma_i2c_destroy(ddc_bus);
 	drm_encoder_cleanup(encoder);
 err_connector_cleanup:
 	drm_connector_cleanup(connector);


