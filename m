Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6F01A76B2;
	Tue, 30 Jul 2024 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360480; cv=none; b=efBg6HKyK3Gh2iahuypbaUNWWTRnnTr17sg86yB5z4alK/g0euhjYTeYNZ4vNk7Z1yMqSDBD3rp6jqIRtNWK+Ck6PCAR9akVbBT3GAFHozRqFs8PHhBglY2ODWE8vEkOST0UWD6qb9ILqvNVUxREo067Mfxtzvl2qqxEAV+3Q3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360480; c=relaxed/simple;
	bh=n8Y5SqSYYabcl7KOyGqOfant0VivXjZop2lqsgSgVJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Saky7V9HHcn7gexfotI/mW10A/9n+odc7CSDgz+2HW4ejT37345PDi+LvskC6RAbXf3psa6VtubKXaaj6CzRjxDoZVglHCkYOe7pluqskdC8+JY5tqEJ7u2uN9nR/F1hs8aINCKHKm2HWflk3HC293uvPerIP8gTO+zDfLPOFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlTmaPus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlTmaPus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9105CC32782;
	Tue, 30 Jul 2024 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360480;
	bh=n8Y5SqSYYabcl7KOyGqOfant0VivXjZop2lqsgSgVJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlTmaPusdjbfP2SX86twqqk4DYKEWpSmluTrUtRnizu/od4wEzbLrdtwSuS3P+uc5
	 tNrTQXfNixy+nk+t1WtYw0yvpGf91vmuIn+NpDwUsp96ClJBMH7QH5MhAEIwzRAYkN
	 84yhiPrmaaWKWMSUPKb9PPT5P86NDdbQ9FP8HbSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 711/809] ASoC: codecs: wcd939x: Fix typec mux and switch leak during device removal
Date: Tue, 30 Jul 2024 17:49:47 +0200
Message-ID: <20240730151753.014962280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 9f3ae72c5dbca9ba558c752f1ef969ed6908be01 upstream.

Driver does not unregister typec structures (typec_mux_dev and
typec_switch_desc) during removal leading to leaks.  Fix this by moving
typec registering parts to separate function and using devm interface to
release them.  This also makes code a bit simpler:
 - Smaller probe() function with less error paths and no #ifdefs,
 - No need to store typec_mux_dev and typec_switch_desc in driver state
   container structure.

Cc: stable@vger.kernel.org
Fixes: 10f514bd172a ("ASoC: codecs: Add WCD939x Codec driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20240701122616.414158-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd939x.c |  113 ++++++++++++++++++++++++++-------------------
 1 file changed, 66 insertions(+), 47 deletions(-)

--- a/sound/soc/codecs/wcd939x.c
+++ b/sound/soc/codecs/wcd939x.c
@@ -182,8 +182,6 @@ struct wcd939x_priv {
 	/* typec handling */
 	bool typec_analog_mux;
 #if IS_ENABLED(CONFIG_TYPEC)
-	struct typec_mux_dev *typec_mux;
-	struct typec_switch_dev *typec_sw;
 	enum typec_orientation typec_orientation;
 	unsigned long typec_mode;
 	struct typec_switch *typec_switch;
@@ -3528,6 +3526,68 @@ static const struct component_master_ops
 	.unbind = wcd939x_unbind,
 };
 
+static void __maybe_unused wcd939x_typec_mux_unregister(void *data)
+{
+	struct typec_mux_dev *typec_mux = data;
+
+	typec_mux_unregister(typec_mux);
+}
+
+static void __maybe_unused wcd939x_typec_switch_unregister(void *data)
+{
+	struct typec_switch_dev *typec_sw = data;
+
+	typec_switch_unregister(typec_sw);
+}
+
+static int wcd939x_add_typec(struct wcd939x_priv *wcd939x, struct device *dev)
+{
+#if IS_ENABLED(CONFIG_TYPEC)
+	int ret;
+	struct typec_mux_dev *typec_mux;
+	struct typec_switch_dev *typec_sw;
+	struct typec_mux_desc mux_desc = {
+		.drvdata = wcd939x,
+		.fwnode = dev_fwnode(dev),
+		.set = wcd939x_typec_mux_set,
+	};
+	struct typec_switch_desc sw_desc = {
+		.drvdata = wcd939x,
+		.fwnode = dev_fwnode(dev),
+		.set = wcd939x_typec_switch_set,
+	};
+
+	/*
+	 * Is USBSS is used to mux analog lines,
+	 * register a typec mux/switch to get typec events
+	 */
+	if (!wcd939x->typec_analog_mux)
+		return 0;
+
+	typec_mux = typec_mux_register(dev, &mux_desc);
+	if (IS_ERR(typec_mux))
+		return dev_err_probe(dev, PTR_ERR(typec_mux),
+				     "failed to register typec mux\n");
+
+	ret = devm_add_action_or_reset(dev, wcd939x_typec_mux_unregister,
+				       typec_mux);
+	if (ret)
+		return ret;
+
+	typec_sw = typec_switch_register(dev, &sw_desc);
+	if (IS_ERR(typec_sw))
+		return dev_err_probe(dev, PTR_ERR(typec_sw),
+				     "failed to register typec switch\n");
+
+	ret = devm_add_action_or_reset(dev, wcd939x_typec_switch_unregister,
+				       typec_sw);
+	if (ret)
+		return ret;
+#endif
+
+	return 0;
+}
+
 static int wcd939x_add_slave_components(struct wcd939x_priv *wcd939x,
 					struct device *dev,
 					struct component_match **matchptr)
@@ -3576,42 +3636,13 @@ static int wcd939x_probe(struct platform
 		return -EINVAL;
 	}
 
-#if IS_ENABLED(CONFIG_TYPEC)
-	/*
-	 * Is USBSS is used to mux analog lines,
-	 * register a typec mux/switch to get typec events
-	 */
-	if (wcd939x->typec_analog_mux) {
-		struct typec_mux_desc mux_desc = {
-			.drvdata = wcd939x,
-			.fwnode = dev_fwnode(dev),
-			.set = wcd939x_typec_mux_set,
-		};
-		struct typec_switch_desc sw_desc = {
-			.drvdata = wcd939x,
-			.fwnode = dev_fwnode(dev),
-			.set = wcd939x_typec_switch_set,
-		};
-
-		wcd939x->typec_mux = typec_mux_register(dev, &mux_desc);
-		if (IS_ERR(wcd939x->typec_mux)) {
-			ret = dev_err_probe(dev, PTR_ERR(wcd939x->typec_mux),
-					    "failed to register typec mux\n");
-			goto err_disable_regulators;
-		}
-
-		wcd939x->typec_sw = typec_switch_register(dev, &sw_desc);
-		if (IS_ERR(wcd939x->typec_sw)) {
-			ret = dev_err_probe(dev, PTR_ERR(wcd939x->typec_sw),
-					    "failed to register typec switch\n");
-			goto err_unregister_typec_mux;
-		}
-	}
-#endif /* CONFIG_TYPEC */
+	ret = wcd939x_add_typec(wcd939x, dev);
+	if (ret)
+		goto err_disable_regulators;
 
 	ret = wcd939x_add_slave_components(wcd939x, dev, &match);
 	if (ret)
-		goto err_unregister_typec_switch;
+		goto err_disable_regulators;
 
 	wcd939x_reset(wcd939x);
 
@@ -3628,18 +3659,6 @@ static int wcd939x_probe(struct platform
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_TYPEC)
-err_unregister_typec_mux:
-	if (wcd939x->typec_analog_mux)
-		typec_mux_unregister(wcd939x->typec_mux);
-#endif /* CONFIG_TYPEC */
-
-err_unregister_typec_switch:
-#if IS_ENABLED(CONFIG_TYPEC)
-	if (wcd939x->typec_analog_mux)
-		typec_switch_unregister(wcd939x->typec_sw);
-#endif /* CONFIG_TYPEC */
-
 err_disable_regulators:
 	regulator_bulk_disable(WCD939X_MAX_SUPPLY, wcd939x->supplies);
 	regulator_bulk_free(WCD939X_MAX_SUPPLY, wcd939x->supplies);


