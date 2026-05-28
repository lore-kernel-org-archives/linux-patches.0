Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24804316199;
	Thu, 28 May 2026 20:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999623; cv=none; b=qOQ32kVqHRIJ9ASSIevVTMGELfWwU16+74A/Rmcf7gnOh9VUqOI0Qs8gmB5cJrp3Cs8LWVroGT8ijRDpH7W4nwMJ6Xiz75qhD/8UZL/F8AfuHyovGASI5DwK/73W6+zMEAmCxMK9jJAbmUFsr02w7ucTw10VL29EpdYv38K7qkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999623; c=relaxed/simple;
	bh=ZnMOZx1ewR9Ce8fX/ChqywASmduYkMI7WgxhgoaoaAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwGTruC1h85dY8xo0FbgwWKLwIS3yM/Xt4OkLVSPkrTrM+TGekmri5y8CFtRIfgM6Mrvx6ZYHMWF4HjsQVWgbS9d82O21BeXgawNmq9ua95Z0gyJitXQLZdR7LaVsJPIp05hafcwT8e4Tlt3zdinn8Gjr92IqdFfpcW3GSO1hIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HutKSS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HutKSS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828A01F000E9;
	Thu, 28 May 2026 20:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999622;
	bh=CxXNlil9i7mXZmIUD4pRXjcQCVy/IDMv9VLi2tfbAwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HutKSS05yZhkVTP3VOFIpmmTD3wDOLspygbdrko+ji1OKUViG9J6YwPgJRnt2+LI
	 kTTZTE3NWWq5vxgd0YgAhqtPazo+39Ouyh9irvrRmothlZK5yb9Lm4FghEKsfecEhm
	 f9RlWJy6qMn0DYQYHL7t4NJ0StV91IPHZs5q9Fug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Chauveau <chauveau.julien@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.18 132/377] drm/bridge: it66121: acquire reset GPIO in probe
Date: Thu, 28 May 2026 21:46:10 +0200
Message-ID: <20260528194642.185655503@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Julien Chauveau <chauveau.julien@gmail.com>

commit e02b5262fd288cc235f14e12233ea54e78c04611 upstream.

The it66121_ctx structure has a gpio_reset field, and it66121_hw_reset()
calls gpiod_set_value() on it. However, the GPIO descriptor is never
acquired via devm_gpiod_get(), leaving gpio_reset as NULL throughout
the driver lifetime.

gpiod_set_value() silently returns when passed a NULL descriptor, so
the hardware reset sequence in it66121_hw_reset() is a no-op. This
leaves the chip in an undefined state at probe time, which can prevent
it from responding on the I2C bus.

The DT binding marks reset-gpios as a required property, so all
compliant device trees provide this GPIO. Add the missing
devm_gpiod_get() call after enabling power supplies and before the
hardware reset, so the chip is properly reset with power applied.

Fixes: 988156dc2fc9 ("drm: bridge: add it66121 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Julien Chauveau <chauveau.julien@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Tested-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260324193011.16583-1-chauveau.julien@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ite-it66121.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/bridge/ite-it66121.c
+++ b/drivers/gpu/drm/bridge/ite-it66121.c
@@ -1559,6 +1559,11 @@ static int it66121_probe(struct i2c_clie
 		return ret;
 	}
 
+	ctx->gpio_reset = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(ctx->gpio_reset))
+		return dev_err_probe(dev, PTR_ERR(ctx->gpio_reset),
+				     "Failed to get reset GPIO\n");
+
 	it66121_hw_reset(ctx);
 
 	ctx->regmap = devm_regmap_init_i2c(client, &it66121_regmap_config);


