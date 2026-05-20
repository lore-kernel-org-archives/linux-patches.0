Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFE532F770;
	Wed, 20 May 2026 18:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303077; cv=none; b=j0F0Ldqv6q2QQZ9BvOe0yr2XgTGZHprT8eaOq9uS679bOc/cDvdVOVEKGARN3Zmmj+651jYeQM28Uj31IM6XM6qXmx0JfKQrxNUISLsaZnnH7GVvZ2qoyx2cdzuesKazpNryj09RA+K5QpPBvqhPIh2NwHU3OoYBhKFK3Dn1Q5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303077; c=relaxed/simple;
	bh=+7k9JTNey7K29r3fdVaJp6GSBKL8zSt5MXK1HQF6wE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoepErYGWFQL0eWz8pmq7tKRD93wzpGpK/OYTJqQJ7IHFtaavoTCHzl3wDzjgqqVzQS7SYMzTyHwtjKOn+19gjHr54Zwh/6zTnvVweHI+GbzWouvuPQk8oov5gxkSMRYyhoMKObb4tkkZT+DrJEIUl0knOUCYIcjaTNKRXlqyFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8JSm7hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8JSm7hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765791F00893;
	Wed, 20 May 2026 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303075;
	bh=mg0Q4RHX+DwOaGrXQ/klJosn9wtiS++HSeeMGccv9jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8JSm7hQCbKaG0WnRK7fguOcvVLmsjknPLJArPgdqEZc+o9WgIFs4x9//scl5c5YH
	 HspY0lD6WeSgJRTOpktMr4ZALczvCiLrwu59osPjr4DgO1re1cnWQRblbeo2yuwbaI
	 Dusw/Iph7zcPuzOPuz1dPLhze5PxxjY8VHCRWdZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 6.6 483/508] drm/gma500/oaktrail_lvds: fix i2c adapter leaks on init
Date: Wed, 20 May 2026 18:25:06 +0200
Message-ID: <20260520162109.059436723@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -368,6 +368,8 @@ void oaktrail_lvds_init(struct drm_devic
 	if (edid == NULL && dev_priv->lpc_gpio_base) {
 		ddc_bus = oaktrail_lvds_i2c_init(dev);
 		if (!IS_ERR(ddc_bus)) {
+			if (i2c_adap)
+				i2c_put_adapter(i2c_adap);
 			i2c_adap = &ddc_bus->base;
 			edid = drm_get_edid(connector, i2c_adap);
 		}
@@ -424,6 +426,8 @@ err_unlock:
 	mutex_unlock(&dev->mode_config.mutex);
 	if (!IS_ERR_OR_NULL(ddc_bus))
 		gma_i2c_destroy(ddc_bus);
+	else if (i2c_adap)
+		i2c_put_adapter(i2c_adap);
 	drm_encoder_cleanup(encoder);
 err_connector_cleanup:
 	drm_connector_cleanup(connector);


