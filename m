Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765E1B7910;
	Wed, 20 May 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299946; cv=none; b=CIpyY84yl8qhurmL9cA10fW3xoy3MGdFilbb05POo01OHkiRD/IOXZIA8wn9MPg83r/LSZmzvUcKmQVnxhEQHKd7+eXym63XT59OIq+HpkWUtEdLerQbIG3xIQVMM32dP9/78MdxAU5XV6vlrEPSlpP1zvcLzqwmS01Dwr6FPGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299946; c=relaxed/simple;
	bh=w+WQoKlGXaJGlANn2dFwLHL3l9Uc5XSTWVxNGYzOQUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJscj1iEnCH/niozgDCNnx1yhJadyvlQNTDCcRefl7YYzL7boKlY1XscaIl+44yj3/oIu1QSROph9/TwPFJrBO7/VAusa8WI/YfRA77OwVIQmc5SMVD4mY7zH09f2XIpwz77i/tN01xBT58TdiWLW8x3bNYlR6EriOOzMZsdKls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBU2N3Ds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBU2N3Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0748B1F000E9;
	Wed, 20 May 2026 17:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299944;
	bh=IFjfZprQ1B4jOGlbq0fpL7SKBsAjwbV5odAwTunRHxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBU2N3Ds1gNnK8fqTsJ9logenh17X3bkdA0b8r08Ai22JERbWhxFJCga62YAlf+Co
	 TjvR6wFYv/ii6QlBGn5J+xAWjWZng1B2fD5bN90yAFpLP0ghnXrRujyYvS7Qa9ZN5/
	 evzLZBCTHNZbL4Pjd9vDVgI7/xgzILQUgxqSrGus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.18 947/957] drm/gma500/oaktrail_lvds: fix i2c adapter leaks on init
Date: Wed, 20 May 2026 18:23:50 +0200
Message-ID: <20260520162155.137382422@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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


