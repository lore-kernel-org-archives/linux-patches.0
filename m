Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048220;
	b=tk2okdCktmcDsSokj3APDsCvIS+tZA7uTSCpPcssQ1RtYjs1CyeNKBIADK04EFLoZXBF
	 JajMPi+5rLsQmay+4Mn3Nt5pGUkS4Fxtoiif2f1ruEfgod1KYhcSoClHhcnSQLII/wRR2
	 r0bNMZt83HEVIScuhYc579z7b4nyCh8gs8G2W8Yf4LowIi+UmyuR3cDMLzLOpoJ5IREjK
	 ple8uyzme6TnAdMRFKTJ0/kqzLIPKocW0TGoybkhB2cE9a0HaZu6UtbazStjlQyw1PuEu
	 /1gcDoEHoJGwPY+Z6lyfjPYB4EcvHrKYz48uUx7qiSTMxb0JGWiKw76oynutNSlV2PA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2BwtDKJp5zP7EGUPA2yapWsyeOMxs18+toz8kTFR5Aw=;
	b=kTmTB8ndRjnaXbqZMPFKPZZbhiDS9qnmahj5v+QtQvWj06XyNtS1Oz2a5Muz7CL0lPSL
	 IwYY4har0hRtmxM9glehoMzzW6ZQ/9XytAeXXGrC32rMmBK3Y/gckz9yaQW5NhEr22P/M
	 hQhY9Vaq2IDD7cwh2zB5trB+RjbtmY9+w1GUA7PuDlNgUsruZoVwnzhWWEb+vL5pDZDDT
	 ME/oqIc4ZTuFmsbb1InLMls2sSaki+oDCbaYHKbrNNXv+vJpR867PbYBsT2NRFu47566T
	 ONNlqZSwAbhh3TwiqHm80OH7/hPy+K3oNndCIdknm+3g68kd71TOCvbXft5s9/bE8kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10Az7ZVf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C8160A263D;
	Thu, 19 Nov 2026 00:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=10Az7ZVf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126071F000C5;
	Thu, 19 Nov 2026 00:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048219;
	bh=2BwtDKJp5zP7EGUPA2yapWsyeOMxs18+toz8kTFR5Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10Az7ZVf8LU5McyBk72a0IdzzLfIN7de0ELeO2CZTUojd7fMGraGIJmGK/lSRtMZX
	 UGtkUomxEW5BXAktv1ZogNuHojRbcRGnAact74pl8f8psBO8vrdvZvKZHNSVRrWBpb
	 AMQDWp4HNwpO/r1gmlQuEl0QIcYasNoieYrcZVT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1918/2857] regulator: fixed: add support for under-voltage IRQ
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118150310.272679209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ecb6f1f456144e9ade5a492192287decbeef4cfe ]

Add interrupt support for under-voltage notification. This functionality
can be used on systems capable to detect under-voltage state and having
enough capacity to let the SoC do some emergency preparation.

This change enforce default policy to shutdown system as soon as
interrupt is triggered.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20231025084614.3092295-6-o.rempel@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 51d6888b51e0 ("regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 50 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index ddaff8579c889..35ee43bf275ba 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_opp.h>
+#include <linux/reboot.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/fixed.h>
 #include <linux/gpio/consumer.h>
@@ -31,6 +32,8 @@
 #include <linux/clk.h>
 #include <linux/string.h>
 
+/* Default time in millisecond to wait for emergency shutdown */
+#define FV_DEF_EMERG_SHUTDWN_TMO	10
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
@@ -107,6 +110,49 @@ static int reg_is_enabled(struct regulator_dev *rdev)
 	return priv->enable_counter > 0;
 }
 
+static irqreturn_t reg_fixed_under_voltage_irq_handler(int irq, void *data)
+{
+	struct fixed_voltage_data *priv = data;
+	struct regulator_dev *rdev = priv->dev;
+
+	regulator_notifier_call_chain(rdev, REGULATOR_EVENT_UNDER_VOLTAGE,
+				      NULL);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * reg_fixed_get_irqs - Get and register the optional IRQ for fixed voltage
+ *                      regulator.
+ * @dev: Pointer to the device structure.
+ * @priv: Pointer to fixed_voltage_data structure containing private data.
+ *
+ * This function tries to get the IRQ from the device firmware node.
+ * If it's an optional IRQ and not found, it returns 0.
+ * Otherwise, it attempts to request the threaded IRQ.
+ *
+ * Return: 0 on success, or error code on failure.
+ */
+static int reg_fixed_get_irqs(struct device *dev,
+			      struct fixed_voltage_data *priv)
+{
+	int ret;
+
+	ret = fwnode_irq_get(dev_fwnode(dev), 0);
+	/* This is optional IRQ. If not found we will get -EINVAL */
+	if (ret == -EINVAL)
+		return 0;
+	if (ret < 0)
+		return dev_err_probe(dev, ret, "Failed to get IRQ\n");
+
+	ret = devm_request_threaded_irq(dev, ret, NULL,
+					reg_fixed_under_voltage_irq_handler,
+					IRQF_ONESHOT, "under-voltage", priv);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to request IRQ\n");
+
+	return 0;
+}
 
 /**
  * of_get_fixed_voltage_config - extract fixed_voltage_config structure info
@@ -300,6 +346,10 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s supplying %duV\n", drvdata->desc.name,
 		drvdata->desc.fixed_uV);
 
+	ret = reg_fixed_get_irqs(dev, drvdata);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.53.0



