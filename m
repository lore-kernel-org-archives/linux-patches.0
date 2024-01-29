Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDBA15D5CC;
	Mon, 29 Jan 2024 17:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548409; cv=none; b=LCntWwANbYdcXL8BOyTxogLdXlDUTdHzepRKtA3etW7/l2zFHfM5fdFNi5P2MgyLY/y56mfDBbs+CNriTN8XMxAYDyn8v10I3QDJliVjpn5yxYPif1WdtoVrm1h0zIDe2lCzIUkLWOItbS+sgTNbVmYP9y1Nufkkp7OpfDc/Bh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548409; c=relaxed/simple;
	bh=m6X/bjiSqDbvexGnJaUDXdy5guncMSvcMbSBXXOCDjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WucSVeB+iS+bKhnSfJrCahHl4YDAFE+MoHalcpjdtLShsV4Cf/gGzURqoxkRZBh+lW4T9Q2ehZJhm22tcqaGvG34R7+/j0qXsZZM6N6o9O87v3KhCkfCYNkN53/6EDE3doCbuCxrhDK8iA6LmnyQwuKt9F+3MEcxI2JwVcD5wdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXU4XGd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXU4XGd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5784CC433F1;
	Mon, 29 Jan 2024 17:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548408;
	bh=m6X/bjiSqDbvexGnJaUDXdy5guncMSvcMbSBXXOCDjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXU4XGd97t2J+v3jdEekKOh4gO8oJZ9FICyVhA3KtI8av546j8wrUQf23AgWgsaca
	 W6fMxhzwZ/wz1fnCLLHv0Mx5rIWfKpUu0TwSh1V3bPIuCtek7RidEBVavD6pzJj42K
	 2iK7IduJVPvDXWpNlU3KZ8G3WpZ5OJ96hSelVd2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Robert Foss <robert.foss@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/185] drm/bridge: sii902x: Use devm_regulator_bulk_get_enable()
Date: Mon, 29 Jan 2024 09:06:08 -0800
Message-ID: <20240129170003.987770352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit ff1eae1201a46f997126297d2d3440baa2d1b9a9 ]

Simplify using devm_regulator_bulk_get_enable()

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Acked-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/e6153c7beb2076b9ea13082b2024ec3296bc08bc.1669799805.git.mazziesaccount@gmail.com
Stable-dep-of: 08ac6f132dd7 ("drm/bridge: sii902x: Fix probing race issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/sii902x.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/bridge/sii902x.c b/drivers/gpu/drm/bridge/sii902x.c
index 878fb7d3732b..f6e8b401069b 100644
--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -171,7 +171,6 @@ struct sii902x {
 	struct drm_connector connector;
 	struct gpio_desc *reset_gpio;
 	struct i2c_mux_core *i2cmux;
-	struct regulator_bulk_data supplies[2];
 	bool sink_is_hdmi;
 	/*
 	 * Mutex protects audio and video functions from interfering
@@ -1072,6 +1071,7 @@ static int sii902x_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct device_node *endpoint;
 	struct sii902x *sii902x;
+	static const char * const supplies[] = {"iovcc", "cvcc12"};
 	int ret;
 
 	ret = i2c_check_functionality(client->adapter,
@@ -1122,27 +1122,11 @@ static int sii902x_probe(struct i2c_client *client,
 
 	mutex_init(&sii902x->mutex);
 
-	sii902x->supplies[0].supply = "iovcc";
-	sii902x->supplies[1].supply = "cvcc12";
-	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(sii902x->supplies),
-				      sii902x->supplies);
+	ret = devm_regulator_bulk_get_enable(dev, ARRAY_SIZE(supplies), supplies);
 	if (ret < 0)
-		return ret;
-
-	ret = regulator_bulk_enable(ARRAY_SIZE(sii902x->supplies),
-				    sii902x->supplies);
-	if (ret < 0) {
-		dev_err_probe(dev, ret, "Failed to enable supplies");
-		return ret;
-	}
+		return dev_err_probe(dev, ret, "Failed to enable supplies");
 
-	ret = sii902x_init(sii902x);
-	if (ret < 0) {
-		regulator_bulk_disable(ARRAY_SIZE(sii902x->supplies),
-				       sii902x->supplies);
-	}
-
-	return ret;
+	return sii902x_init(sii902x);
 }
 
 static void sii902x_remove(struct i2c_client *client)
@@ -1152,8 +1136,6 @@ static void sii902x_remove(struct i2c_client *client)
 
 	i2c_mux_del_adapters(sii902x->i2cmux);
 	drm_bridge_remove(&sii902x->bridge);
-	regulator_bulk_disable(ARRAY_SIZE(sii902x->supplies),
-			       sii902x->supplies);
 }
 
 static const struct of_device_id sii902x_dt_ids[] = {
-- 
2.43.0



