Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D2368968;
	Wed, 20 May 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301683; cv=none; b=Ohp/MuO3MXCZxQaLfawzHnd5YNCiePPsGq6Sbv86SXklMAEDNN/Od7QT8sUvKsuCG/i3XHaXvegP0r2zNODp2zjRl+3Xq25oSNViaB7g1ZsdfKHEI/pPa2nv3ykeARK/z2jwQuy8xsKbOGrxJFHvpsl4yAWLW85Koz3Y+0rtRQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301683; c=relaxed/simple;
	bh=ztgE/iu8TzTuX6tOnA+2jBKeEVxZJqO7AT3cDPs+wic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVgnsAnAps1YQBlSrVMDFdFmDbkwd6hQSt+d1suokybaC6NHEG2FQFRNlNF8EktTRUxvSOVxXUinaDyar7lsXl/84YKn8OOIm1errXW8Km1XYbu9efejIR+zMdWUEkU463ftmPkYyIsJ+YC2gR0BDLgmB8oo+huRXpUDVwb0MLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIl2FbrX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIl2FbrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76F01F00897;
	Wed, 20 May 2026 18:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301681;
	bh=0ZXgSCcvpsxCKeVU3rFmtiBSGkcCwFlNPW4ZCXLpvsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIl2FbrXtqPU8+F+oSjzvmLXSPe2gB4Btwgx2XiuhUQWxKKjmvGqynmuR0lL0s9tN
	 0Fe4t+Afkn93JADvslonvwBvBxuZ+GpFy9oBc3/fCSJ0iz4WtjYSdkd5P+sTH3HIJM
	 xue8XC+e3FL5RKYkrtbyy0rNyVw0o/o9fm3Steg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.12 646/666] drm/gma500/oaktrail_lvds: fix i2c adapter leaks on init
Date: Wed, 20 May 2026 18:24:17 +0200
Message-ID: <20260520162125.282215331@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 84d1c9b416d54afe760ca4c378bd95c89261254c upstream.

The LVDS init code looks up an I2C adapter using i2c_get_adapter() and
tries to read the EDID before falling back to allocating and registering
its own adapter.

Make sure to drop the references taken by i2c_get_adapter() when falling
back to allocating an adapter as well as on late errors to allow the
looked up adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_lvds.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -366,6 +366,8 @@ void oaktrail_lvds_init(struct drm_devic
 	if (edid == NULL && dev_priv->lpc_gpio_base) {
 		ddc_bus = oaktrail_lvds_i2c_init(dev);
 		if (!IS_ERR(ddc_bus)) {
+			if (i2c_adap)
+				i2c_put_adapter(i2c_adap);
 			i2c_adap = &ddc_bus->base;
 			edid = drm_get_edid(connector, i2c_adap);
 		}
@@ -422,6 +424,8 @@ err_unlock:
 	mutex_unlock(&dev->mode_config.mutex);
 	if (!IS_ERR_OR_NULL(ddc_bus))
 		gma_i2c_destroy(ddc_bus);
+	else if (i2c_adap)
+		i2c_put_adapter(i2c_adap);
 	drm_encoder_cleanup(encoder);
 err_connector_cleanup:
 	drm_connector_cleanup(connector);


