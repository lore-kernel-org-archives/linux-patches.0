Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F561DE4E0;
	Thu, 28 May 2026 20:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000643; cv=none; b=Ek0HjUEtF1Zi1suB3B3mXCKft/fNQdj3jktiwEyQ193iZF8fOWyumh5GXNey6VzQvPD7hsZofdk3RAUHpj+f5BPx9A7j4cjYFUCjQ35umvuC1B5YGYBrVofxbZF+U3q6gh1xSY7kP2jhI8SbT4DNoNs8C9DkpV9rQjTlNmAMexw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000643; c=relaxed/simple;
	bh=3t/Okzrr7T3pLlwClNsbhl6M5oYljRP6QYI6qaaYqG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ3be96RpfIhwC1VFJl6sGhgr/ix1MYpryh5P8YVPRP97e6OLTYAHy9hzL7WeN6tsEyzK7N8zPP5+vVHVG3ZklfQgQ+2PAlUKyyH++DQu1M24/scvhiHwf5IkgojLeEzV7WSsQafx6x0WJlODJg+xBhoTMu8bYCstNy9V7vHIJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLKyUvkr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLKyUvkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CB91F000E9;
	Thu, 28 May 2026 20:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000642;
	bh=LqKS/z+ffFCG3CEVF94uVjwvRfCTLtiKGthLVtjJN7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLKyUvkreBi/GnNb3xArp6JTeQwEYDvAcqJDoOr6mnTcQDJ3JIuoXA2m44sT/Y50n
	 cRdv2rE5CZaHVbIu15wsw/CXMlCvMws+ez099+PMJxXCgSUL2iT6CcrLxtvf63ueOS
	 nJ8A1+aiwAEumdjFPFjoXYAqQ9it3H+jja1PH6jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Chauveau <chauveau.julien@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>
Subject: [PATCH 6.12 116/272] drm/bridge: it66121: acquire reset GPIO in probe
Date: Thu, 28 May 2026 21:48:10 +0200
Message-ID: <20260528194632.629257576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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


