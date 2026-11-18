Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039712;
	b=EY4okx+dKXf8xBTeVJYWftWHaPRyVNujSPibgWs5ZsSAS+p6L9PdVRu/ErXKyXwK4z3G
	 MlM4Ps3mOPsTzJXHv03bPfMfOAIA/r7m/TGrqnh8H5gwoKWOBddqHGJobPKXcuplrDzIO
	 0LoXjD0fjKJOkUK5GvZerSaki5CTicFi8CCYj6wAGXf5qhMwFA6MBBpLhKy/sl0TTsPf2
	 lyVh7+t9kHQUIy+lp85HUlp8IoP3+FBQFDGmXHOxMQcsMqyKvti2AU+9fasqGYqNE+BQd
	 2nM+77BI3vGsJEjrM+Ebx0TCcSX8Wi36gr8fP8+JPv1Lxrd4+krtU5oSKLyLG6frHkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=222Wf+EluFyX2SXDVxUXOG5eOkduPfDLXVsoUMZa9hI=;
	b=wZlk2E0FrLESO/nsGmvo0jP8W6INFkXpQ/MOZ9lPJ1AA7NXZxlAUKZ6PAF6c3u9PNS7m
	 xgJG0JilmKexWaZ8UPrxZc2XMLiEzN/AJEPVTn3SlG9pz5gDliSwn49VDw7BaIwHeWTL+
	 yn4SOpgW8xhSC218JhwRVx6nA76fXt/lvyEpAZFz1io+UKnIrk1nFfCQ9OtLBjqqHM2B6
	 0EEormqS7jZesjS4TuMxXvWtG7tRrrAFwYUGH1NK4ul6cPtm7SVSipIEuhCKGKFganPoD
	 6hlLALYa78tXpnd6ogWxDnxWHiFkBA/H2XdoPv1JcO+gb4Tgj40v7R52YiNCb8x7SPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzBMXsjJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F936606A31C;
	Wed, 18 Nov 2026 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzBMXsjJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22E01F000C4;
	Wed, 18 Nov 2026 22:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039712;
	bh=222Wf+EluFyX2SXDVxUXOG5eOkduPfDLXVsoUMZa9hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzBMXsjJiyGF+Ot8oCHubvAcYThemBFrkJTnV9SA8Z2ywrtxTLb9rBByhlQ+k0yHG
	 NDZn6LzPMjcGz0lP0xD4JX83qr0MZjlwoOBrS2HEACDmYI9zDwssWDVlGDQnIAdkSq
	 c5r+wuf5Sr9TD5YDxjivRlSHcx36EB5WIhhORXQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2199/3318] regulator: fixed: add support for under-voltage IRQ
Date: Wed, 18 Nov 2026 15:47:01 +0100
Message-ID: <20261118150427.905071885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8a92257668458..c1906c743a57f 100644
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
@@ -30,6 +31,8 @@
 #include <linux/clk.h>
 #include <linux/string.h>
 
+/* Default time in millisecond to wait for emergency shutdown */
+#define FV_DEF_EMERG_SHUTDWN_TMO	10
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
@@ -106,6 +109,49 @@ static int reg_is_enabled(struct regulator_dev *rdev)
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
@@ -299,6 +345,10 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
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



